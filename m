Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbZEDSva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbZEDSva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 14:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZEDSvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 14:51:20 -0400
Received: from vena.lwn.net ([206.168.112.25]:37962 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbZEDSvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 14:51:19 -0400
Date: Mon, 4 May 2009 12:51:14 -0600
From: Jake Edge <jake@lwn.net>
To: <security@kernel.org>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, Eric Paris <eparis@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Roland McGrath <roland@redhat.com>,
       mingo@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Greg KH <greg@kroah.com>, ebiederm@xmission.com (Eric W. Biederman)
Subject: [PATCH] proc: avoid information leaks to non-privileged processes
Message-ID: <20090504125114.5e391564@chukar>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is essentially v2 of "[PATCH] proc: avoid leaking eip, esp, or
wchan to non-privileged processes", adding some of Eric Biederman's
suggestions as well as the start_stack change (only give out that
address if the process is ptrace()-able).  This has been tested with ps
and top without any ill effects being seen.

proc: avoid information leaks to non-privileged processes

By using the same test as is used for /proc/pid/maps and /proc/pid/smaps,
only allow processes that can ptrace() a given process to see information
that might be used to bypass address space layout randomization (ASLR).
These include eip, esp, wchan, and start_stack in /proc/pid/stat as well
as the non-symbolic output from /proc/pid/wchan.

ASLR can be bypassed by sampling eip as shown by the proof-of-concept code
at http://code.google.com/p/fuzzyaslr/  As part of a presentation
(http://www.cr0.org/paper/to-jt-linux-alsr-leak.pdf) esp and wchan were also
noted as possibly usable information leaks as well.  The start_stack address
also leaks potentially useful information.

Cc: Stable Team <stable@kernel.org>
Signed-off-by: Jake Edge <jake@lwn.net>
---
 fs/proc/array.c |   13 +++++++++----
 fs/proc/base.c  |    5 ++++-
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 7e4877d..725a650 100644
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
@@ -476,7 +481,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		rsslim,
 		mm ? mm->start_code : 0,
 		mm ? mm->end_code : 0,
-		mm ? mm->start_stack : 0,
+		(permitted && mm) ? mm->start_stack : 0,
 		esp,
 		eip,
 		/* The signal information here is obsolete.
diff --git a/fs/proc/base.c b/fs/proc/base.c
index aa763ab..fb45615 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -322,7 +322,10 @@ static int proc_pid_wchan(struct task_struct *task, char *buffer)
 	wchan = get_wchan(task);
 
 	if (lookup_symbol_name(wchan, symname) < 0)
-		return sprintf(buffer, "%lu", wchan);
+		if (!ptrace_may_access(task, PTRACE_MODE_READ))
+			return 0;
+		else
+			return sprintf(buffer, "%lu", wchan);
 	else
 		return sprintf(buffer, "%s", symname);
 }
-- 
1.6.2.2


-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
