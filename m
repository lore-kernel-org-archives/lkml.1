Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbZD3PL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbZD3PL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763325AbZD3PLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:11:44 -0400
Received: from vena.lwn.net ([206.168.112.25]:41825 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763015AbZD3PLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:11:43 -0400
Date: Thu, 30 Apr 2009 09:11:40 -0600
From: Jake Edge <jake@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, stable@kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] proc: avoid leaking eip, esp, or wchan to non-privileged
 processes
Message-ID: <20090430091140.4b97b4f8@chukar>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


proc: avoid leaking eip, esp, or wchan to non-privileged processes

Using the same test as is used for /proc/pid/maps and smaps, only allow
processes that can ptrace() a given process to access its /proc/pid/wchan and
get eip and esp from /proc/pid/stat.

ASLR can be bypassed by sampling eip as shown by the proof-of-concept code
at http://code.google.com/p/fuzzyaslr/  As part of a presentation
(http://www.cr0.org/paper/to-jt-linux-alsr-leak.pdf) esp and wchan were also
noted as possibly usable information leaks as well.

Signed-off-by: Jake Edge <jake@lwn.net>
---
 fs/proc/array.c |   11 ++++++++---
 fs/proc/base.c  |    3 +++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 7e4877d..e96d508 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -80,6 +80,7 @@
 #include <linux/delayacct.h>
 #include <linux/seq_file.h>
 #include <linux/pid_namespace.h>
+#include <linux/ptrace.h>
 #include <linux/tracehook.h>
 
 #include <asm/pgtable.h>
@@ -352,6 +353,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	char state;
 	pid_t ppid = 0, pgid = -1, sid = -1;
 	int num_threads = 0;
+	int permitted;
 	struct mm_struct *mm;
 	unsigned long long start_time;
 	unsigned long cmin_flt = 0, cmaj_flt = 0;
@@ -364,11 +366,14 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
+	permitted = ptrace_may_access(task, PTRACE_MODE_READ);
 	mm = get_task_mm(task);
 	if (mm) {
 		vsize = task_vsize(mm);
-		eip = KSTK_EIP(task);
-		esp = KSTK_ESP(task);
+		if (permitted) {
+			eip = KSTK_EIP(task);
+			esp = KSTK_ESP(task);
+		}
 	}
 
 	get_task_comm(tcomm, task);
@@ -424,7 +429,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		unlock_task_sighand(task, &flags);
 	}
 
-	if (!whole || num_threads < 2)
+	if (permitted && (!whole || num_threads < 2))
 		wchan = get_wchan(task);
 	if (!whole) {
 		min_flt = task->min_flt;
diff --git a/fs/proc/base.c b/fs/proc/base.c
index aa763ab..cd3c0d7 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -319,6 +319,9 @@ static int proc_pid_wchan(struct task_struct *task, char *buffer)
 	unsigned long wchan;
 	char symname[KSYM_NAME_LEN];
 
+	if (!ptrace_may_access(task, PTRACE_MODE_READ))
+		return 0;
+
 	wchan = get_wchan(task);
 
 	if (lookup_symbol_name(wchan, symname) < 0)
-- 
1.6.2.2


-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
