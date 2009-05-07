Return-Path: <linux-kernel-owner+w=401wt.eu-S1760421AbZEGJwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760421AbZEGJwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbZEGJwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:52:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44048 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbZEGJwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:52:14 -0400
Date: Thu, 7 May 2009 11:50:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: [patch 2/2] ptrace: turn ptrace_access_check() into a retval
	function
Message-ID: <20090507095054.GB4911@elte.hu>
References: <20090506080050.GF17457@elte.hu> <20090506235349.GC3756@redhat.com> <20090507002133.02D05FC39E@magilla.sf.frob.com> <20090507063606.GA15220@redhat.com> <20090507082027.GD12285@elte.hu> <20090507083102.GA20125@redhat.com> <20090507083851.GA19133@elte.hu> <20090507085742.GB3036@sequoia.sous-sol.org> <20090507090459.GE19133@elte.hu> <20090507093124.GA355@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507093124.GA355@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace_access_check() returns a bool, while most of the ptrace 
access check machinery works with Linux retvals (where 0 indicates 
success, negative indicates an error).

So eliminate the bool and invert the usage at the call sites.

( Note: "< 0" checks are used instead of !0 checks, because that's
  the convention for retval checks and it results in similarly fast
  assembly code. )

[ Impact: cleanup ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/proc/array.c        |    2 +-
 fs/proc/base.c         |    8 ++++----
 fs/proc/task_mmu.c     |    2 +-
 include/linux/ptrace.h |    2 +-
 kernel/ptrace.c        |    6 ++++--
 5 files changed, 11 insertions(+), 9 deletions(-)

Index: linux/fs/proc/array.c
===================================================================
--- linux.orig/fs/proc/array.c
+++ linux/fs/proc/array.c
@@ -366,7 +366,7 @@ static int do_task_stat(struct seq_file 
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
-	permitted = ptrace_access_check(task, PTRACE_MODE_READ);
+	permitted = !ptrace_access_check(task, PTRACE_MODE_READ);
 	mm = get_task_mm(task);
 	if (mm) {
 		vsize = task_vsize(mm);
Index: linux/fs/proc/base.c
===================================================================
--- linux.orig/fs/proc/base.c
+++ linux/fs/proc/base.c
@@ -222,7 +222,7 @@ static int check_mem_permission(struct t
 		rcu_read_lock();
 		match = (tracehook_tracer_task(task) == current);
 		rcu_read_unlock();
-		if (match && ptrace_access_check(task, PTRACE_MODE_ATTACH))
+		if (match && !ptrace_access_check(task, PTRACE_MODE_ATTACH))
 			return 0;
 	}
 
@@ -322,7 +322,7 @@ static int proc_pid_wchan(struct task_st
 	wchan = get_wchan(task);
 
 	if (lookup_symbol_name(wchan, symname) < 0)
-		if (!ptrace_access_check(task, PTRACE_MODE_READ))
+		if (ptrace_access_check(task, PTRACE_MODE_READ) < 0)
 			return 0;
 		else
 			return sprintf(buffer, "%lu", wchan);
@@ -559,7 +559,7 @@ static int proc_fd_access_allowed(struct
 	 */
 	task = get_proc_task(inode);
 	if (task) {
-		allowed = ptrace_access_check(task, PTRACE_MODE_READ);
+		allowed = !ptrace_access_check(task, PTRACE_MODE_READ);
 		put_task_struct(task);
 	}
 	return allowed;
@@ -938,7 +938,7 @@ static ssize_t environ_read(struct file 
 	if (!task)
 		goto out_no_task;
 
-	if (!ptrace_access_check(task, PTRACE_MODE_READ))
+	if (ptrace_access_check(task, PTRACE_MODE_READ) < 0)
 		goto out;
 
 	ret = -ENOMEM;
Index: linux/fs/proc/task_mmu.c
===================================================================
--- linux.orig/fs/proc/task_mmu.c
+++ linux/fs/proc/task_mmu.c
@@ -656,7 +656,7 @@ static ssize_t pagemap_read(struct file 
 		goto out;
 
 	ret = -EACCES;
-	if (!ptrace_access_check(task, PTRACE_MODE_READ))
+	if (ptrace_access_check(task, PTRACE_MODE_READ) < 0)
 		goto out_task;
 
 	ret = -EINVAL;
Index: linux/include/linux/ptrace.h
===================================================================
--- linux.orig/include/linux/ptrace.h
+++ linux/include/linux/ptrace.h
@@ -101,7 +101,7 @@ extern void ptrace_fork(struct task_stru
 /* Returns 0 on success, -errno on denial. */
 extern int __ptrace_access_check(struct task_struct *task, unsigned int mode);
 /* Returns true on success, false on denial. */
-extern bool ptrace_access_check(struct task_struct *task, unsigned int mode);
+extern int ptrace_access_check(struct task_struct *task, unsigned int mode);
 
 static inline int ptrace_reparented(struct task_struct *child)
 {
Index: linux/kernel/ptrace.c
===================================================================
--- linux.orig/kernel/ptrace.c
+++ linux/kernel/ptrace.c
@@ -165,13 +165,15 @@ int __ptrace_access_check(struct task_st
 	return security_ptrace_access_check(task, mode);
 }
 
-bool ptrace_access_check(struct task_struct *task, unsigned int mode)
+int ptrace_access_check(struct task_struct *task, unsigned int mode)
 {
 	int err;
+
 	task_lock(task);
 	err = __ptrace_access_check(task, mode);
 	task_unlock(task);
-	return !err;
+
+	return err;
 }
 
 int ptrace_attach(struct task_struct *task)
