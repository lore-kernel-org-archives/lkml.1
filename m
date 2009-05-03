Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbZECX34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbZECX34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 19:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757536AbZECX3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 19:29:33 -0400
Received: from tundra.namei.org ([65.99.196.166]:59484 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757557AbZECX3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 19:29:31 -0400
Date: Mon, 4 May 2009 09:27:29 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
cc: Jake Edge <jake@lwn.net>, Arjan van de Ven <arjan@infradead.org>,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] proc: avoid leaking eip, esp, or wchan to non-privileged
 processes (fwd)
Message-ID: <alpine.LRH.2.00.0905040917240.20251@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch needs some review.

Note that stable@kernel.org typically backport already-reviewed and 
applied patches.  I think security@kernel.org is for reporting problems in 
a non-public way (whereas, this is already public knowledge).

Having someone specifically responsible for maintaining kernel memory 
protection features would be of immense value.  Any takers?

---------- Forwarded message ----------
Date: Thu, 30 Apr 2009 09:11:40 -0600
From: Jake Edge <jake@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, stable@kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] proc: avoid leaking eip, esp,
    or wchan to non-privileged processes


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
@@ -352,6 +353,7 @@ static int do_task_stat(struct seq_file *m, struct
pid_namespace *ns,
 	char state;
 	pid_t ppid = 0, pgid = -1, sid = -1;
 	int num_threads = 0;
+	int permitted;
 	struct mm_struct *mm;
 	unsigned long long start_time;
 	unsigned long cmin_flt = 0, cmaj_flt = 0;
@@ -364,11 +366,14 @@ static int do_task_stat(struct seq_file *m, struct
pid_namespace *ns,

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
@@ -424,7 +429,7 @@ static int do_task_stat(struct seq_file *m, struct
pid_namespace *ns,
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
@@ -319,6 +319,9 @@ static int proc_pid_wchan(struct task_struct *task, char
*buffer)
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
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
