Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbYL0MUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbYL0MUs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 07:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbYL0MUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 07:20:39 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:35233 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbYL0MUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 07:20:38 -0500
X-Greylist: delayed 2152 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Dec 2008 07:20:37 EST
Date: Sat, 27 Dec 2008 11:44:53 +0000
From: Scott James Remnant <scott@canonical.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Notify init when processes are reparented to it
Message-ID: <20081227114452.GA2919@zelda.netsplit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230378128.7026.50.camel@quest>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the init daemon to be notified by signal when processes are
reparented to it.  The signal has the same form as SIGCHLD except that
the si_status field contains the original parent proecss id.

Notification is enabled/disabled by prctl().

Signed-off-by: Scott James Remnant <scott@canonical.com>
---
 fs/exec.c                |    2 ++
 include/linux/prctl.h    |    4 ++++
 include/linux/sched.h    |    2 ++
 kernel/exit.c            |    3 +++
 kernel/signal.c          |   37 +++++++++++++++++++++++++++++++++++++
 kernel/sys.c             |   10 ++++++++++
 security/commoncap.c     |    1 +
 security/selinux/hooks.c |    4 +++-
 8 files changed, 62 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index c5f1a92..07a8782 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1011,6 +1011,7 @@ int flush_old_exec(struct linux_binprm * bprm)
 		suid_keys(current);
 		set_dumpable(current->mm, suid_dumpable);
 		current->pdeath_signal = 0;
+		current->adopt_signal = 0;
 	} else if (file_permission(bprm->file, MAY_READ) ||
 			(bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP)) {
 		suid_keys(current);
@@ -1099,6 +1100,7 @@ void compute_creds(struct linux_binprm *bprm)
 	if (bprm->e_uid != current->uid) {
 		suid_keys(current);
 		current->pdeath_signal = 0;
+		current->adopt_signal = 0;
 	}
 	exec_keys(current);
 
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index 48d887e..1fa1b75 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -85,4 +85,8 @@
 #define PR_SET_TIMERSLACK 29
 #define PR_GET_TIMERSLACK 30
 
+/* Set/get notification of adoption by signal */
+#define PR_SET_ADOPTSIG 31  /* Second arg is a signal */
+#define PR_GET_ADOPTSIG 32  /* Second arg is a ptr to return the signal */
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 55e30d1..bcd2af3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1133,6 +1133,7 @@ struct task_struct {
 	int exit_state;
 	int exit_code, exit_signal;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
+	int adopt_signal;  /*  The signal sent when a process is reparented  */
 	/* ??? */
 	unsigned int personality;
 	unsigned did_exec:1;
@@ -1829,6 +1830,7 @@ extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
 extern int kill_proc_info(int, struct siginfo *, pid_t);
 extern int do_notify_parent(struct task_struct *, int);
+extern void do_notify_parent_adopted(struct task_struct *, struct task_struct *);
 extern void force_sig(int, struct task_struct *);
 extern void force_sig_specific(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
diff --git a/kernel/exit.c b/kernel/exit.c
index 2d8be7e..813a232 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -813,6 +813,9 @@ static void reparent_thread(struct task_struct *p, struct task_struct *father)
 		/* We already hold the tasklist_lock here.  */
 		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
 
+	if (p->real_parent->adopt_signal)
+		do_notify_parent_adopted(p, father);
+
 	list_move_tail(&p->sibling, &p->real_parent->children);
 
 	/* If this is a threaded reparent there is no need to
diff --git a/kernel/signal.c b/kernel/signal.c
index 4530fc6..40228e2 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1474,6 +1474,43 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 	spin_unlock_irqrestore(&sighand->siglock, flags);
 }
 
+/* Let init know that it has adopted a new child */
+void do_notify_parent_adopted(struct task_struct *tsk, struct task_struct *father)
+{
+	struct siginfo info;
+	unsigned long flags;
+	struct task_struct *reaper;
+	struct sighand_struct *sighand;
+	int ret;
+
+	reaper = tsk->real_parent;
+
+	memset (&info, 0, sizeof info);
+	info.si_signo = reaper->adopt_signal;
+	/*
+	 * set code to the same range as SIGCHLD so the right bits of
+	 * siginfo_t get copied, to userspace this will appear as si_code=0
+	 */
+	info.si_code = __SI_CHLD;
+	/*
+	 * see comment in do_notify_parent() about the following 4 lines
+	 */
+	rcu_read_lock();
+	info.si_pid = task_pid_nr_ns(tsk, reaper->nsproxy->pid_ns);
+	info.si_status = task_pid_nr_ns(father, reaper->nsproxy->pid_ns);
+	rcu_read_unlock();
+
+	info.si_uid = tsk->uid;
+
+	info.si_utime = cputime_to_clock_t(tsk->utime);
+	info.si_stime = cputime_to_clock_t(tsk->stime);
+
+	sighand = reaper->sighand;
+	spin_lock_irqsave(&sighand->siglock, flags);
+	__group_send_sig_info(reaper->adopt_signal, &info, reaper);
+	spin_unlock_irqrestore(&sighand->siglock, flags);
+}
+
 static inline int may_ptrace_stop(void)
 {
 	if (!likely(current->ptrace & PT_PTRACED))
diff --git a/kernel/sys.c b/kernel/sys.c
index 31deba8..1720053 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1726,6 +1726,16 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 			else
 				current->timer_slack_ns = arg2;
 			break;
+		case PR_SET_ADOPTSIG:
+			if (!valid_signal(arg2)) {
+				error = -EINVAL;
+				break;
+			}
+			current->adopt_signal = arg2;
+			break;
+		case PR_GET_ADOPTSIG:
+			error = put_user(current->adopt_signal, (int __user *)arg2);
+			break;
 		default:
 			error = -EINVAL;
 			break;
diff --git a/security/commoncap.c b/security/commoncap.c
index 6cbec11..a2da3ab 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -365,6 +365,7 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 			  current->cap_permitted)) {
 		set_dumpable(current->mm, suid_dumpable);
 		current->pdeath_signal = 0;
+		current->adopt_signal = 0;
 
 		if (unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
 			if (!capable(CAP_SETUID)) {
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 75777cb..8f089c8 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2280,8 +2280,10 @@ static void selinux_bprm_post_apply_creds(struct linux_binprm *bprm)
 		spin_unlock_irq(&current->sighand->siglock);
 	}
 
-	/* Always clear parent death signal on SID transitions. */
+	/* Always clear parent death signal and adoption notification
+	 * on SID transitions. */
 	current->pdeath_signal = 0;
+	current->adopt_signal = 0;
 
 	/* Check whether the new SID can inherit resource limits
 	   from the old SID.  If not, reset all soft limits to
-- 
1.6.0.5

