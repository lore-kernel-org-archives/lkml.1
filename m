Return-Path: <linux-kernel-owner+w=401wt.eu-S1759650AbZFJWZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650AbZFJWZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 18:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140AbZFJWZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 18:25:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51491 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbZFJWZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 18:25:15 -0400
Date: Thu, 11 Jun 2009 00:25:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] signal code updates for v2.6.31
Message-ID: <20090610222509.GA5397@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest signal-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git signal-for-linus

Add the new sys_rt_tgsigqueueinfo() syscall and hook it up in x86. 
Ack by Ulrich, Roland and Oleg.

 Thanks,

	Ingo

------------------>
Thomas Gleixner (3):
      signals: split do_tkill
      signals: implement sys_rt_tgsigqueueinfo
      x86: hookup sys_rt_tgsigqueueinfo


 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    1 +
 arch/x86/include/asm/unistd_64.h   |    2 +
 arch/x86/kernel/syscall_table_32.S |    1 +
 include/linux/compat.h             |    2 +
 include/linux/signal.h             |    2 +
 kernel/compat.c                    |   11 +++++++
 kernel/signal.c                    |   56 ++++++++++++++++++++++++++++--------
 8 files changed, 64 insertions(+), 12 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index a505202..dcef387 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -830,4 +830,5 @@ ia32_sys_call_table:
 	.quad sys_inotify_init1
 	.quad compat_sys_preadv
 	.quad compat_sys_pwritev
+	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index 6e72d74..708dae6 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -340,6 +340,7 @@
 #define __NR_inotify_init1	332
 #define __NR_preadv		333
 #define __NR_pwritev		334
+#define __NR_rt_tgsigqueueinfo	335
 
 #ifdef __KERNEL__
 
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index f818294..4e2b054 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -657,6 +657,8 @@ __SYSCALL(__NR_inotify_init1, sys_inotify_init1)
 __SYSCALL(__NR_preadv, sys_preadv)
 #define __NR_pwritev				296
 __SYSCALL(__NR_pwritev, sys_pwritev)
+#define __NR_rt_tgsigqueueinfo			297
+__SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 
 
 #ifndef __NO_STUBS
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index ff5c873..734f92c 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -334,3 +334,4 @@ ENTRY(sys_call_table)
 	.long sys_inotify_init1
 	.long sys_preadv
 	.long sys_pwritev
+	.long sys_rt_tgsigqueueinfo	/* 335 */
diff --git a/include/linux/compat.h b/include/linux/compat.h
index f2ded21..af931ee 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -222,6 +222,8 @@ int copy_siginfo_from_user32(siginfo_t *to, struct compat_siginfo __user *from);
 int copy_siginfo_to_user32(struct compat_siginfo __user *to, siginfo_t *from);
 int get_compat_sigevent(struct sigevent *event,
 		const struct compat_sigevent __user *u_event);
+long compat_sys_rt_tgsigqueueinfo(compat_pid_t tgid, compat_pid_t pid, int sig,
+				  struct compat_siginfo __user *uinfo);
 
 static inline int compat_timeval_compare(struct compat_timeval *lhs,
 					struct compat_timeval *rhs)
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 84f997f..c755283 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -235,6 +235,8 @@ static inline int valid_signal(unsigned long sig)
 extern int next_signal(struct sigpending *pending, sigset_t *mask);
 extern int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p);
 extern int __group_send_sig_info(int, struct siginfo *, struct task_struct *);
+extern long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig,
+				 siginfo_t *info);
 extern long do_sigpending(void __user *, unsigned long);
 extern int sigprocmask(int, sigset_t *, sigset_t *);
 extern int show_unhandled_signals;
diff --git a/kernel/compat.c b/kernel/compat.c
index 42d5654..f6c204f 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -882,6 +882,17 @@ compat_sys_rt_sigtimedwait (compat_sigset_t __user *uthese,
 
 }
 
+asmlinkage long
+compat_sys_rt_tgsigqueueinfo(compat_pid_t tgid, compat_pid_t pid, int sig,
+			     struct compat_siginfo __user *uinfo)
+{
+	siginfo_t info;
+
+	if (copy_siginfo_from_user32(&info, uinfo))
+		return -EFAULT;
+	return do_rt_tgsigqueueinfo(tgid, pid, sig, &info);
+}
+
 #ifdef __ARCH_WANT_COMPAT_SYS_TIME
 
 /* compat_time_t is a 32 bit "long" and needs to get converted. */
diff --git a/kernel/signal.c b/kernel/signal.c
index d803473..f79b3b9 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2278,24 +2278,17 @@ SYSCALL_DEFINE2(kill, pid_t, pid, int, sig)
 	return kill_something_info(sig, &info, pid);
 }
 
-static int do_tkill(pid_t tgid, pid_t pid, int sig)
+static int
+do_send_specific(pid_t tgid, pid_t pid, int sig, struct siginfo *info)
 {
-	int error;
-	struct siginfo info;
 	struct task_struct *p;
 	unsigned long flags;
-
-	error = -ESRCH;
-	info.si_signo = sig;
-	info.si_errno = 0;
-	info.si_code = SI_TKILL;
-	info.si_pid = task_tgid_vnr(current);
-	info.si_uid = current_uid();
+	int error = -ESRCH;
 
 	rcu_read_lock();
 	p = find_task_by_vpid(pid);
 	if (p && (tgid <= 0 || task_tgid_vnr(p) == tgid)) {
-		error = check_kill_permission(sig, &info, p);
+		error = check_kill_permission(sig, info, p);
 		/*
 		 * The null signal is a permissions and process existence
 		 * probe.  No signal is actually delivered.
@@ -2305,7 +2298,7 @@ static int do_tkill(pid_t tgid, pid_t pid, int sig)
 		 * signal is private anyway.
 		 */
 		if (!error && sig && lock_task_sighand(p, &flags)) {
-			error = specific_send_sig_info(sig, &info, p);
+			error = specific_send_sig_info(sig, info, p);
 			unlock_task_sighand(p, &flags);
 		}
 	}
@@ -2314,6 +2307,19 @@ static int do_tkill(pid_t tgid, pid_t pid, int sig)
 	return error;
 }
 
+static int do_tkill(pid_t tgid, pid_t pid, int sig)
+{
+	struct siginfo info;
+
+	info.si_signo = sig;
+	info.si_errno = 0;
+	info.si_code = SI_TKILL;
+	info.si_pid = task_tgid_vnr(current);
+	info.si_uid = current_uid();
+
+	return do_send_specific(tgid, pid, sig, &info);
+}
+
 /**
  *  sys_tgkill - send signal to one specific thread
  *  @tgid: the thread group ID of the thread
@@ -2363,6 +2369,32 @@ SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t, pid, int, sig,
 	return kill_proc_info(sig, &info, pid);
 }
 
+long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig, siginfo_t *info)
+{
+	/* This is only valid for single tasks */
+	if (pid <= 0 || tgid <= 0)
+		return -EINVAL;
+
+	/* Not even root can pretend to send signals from the kernel.
+	   Nor can they impersonate a kill(), which adds source info.  */
+	if (info->si_code >= 0)
+		return -EPERM;
+	info->si_signo = sig;
+
+	return do_send_specific(tgid, pid, sig, info);
+}
+
+SYSCALL_DEFINE4(rt_tgsigqueueinfo, pid_t, tgid, pid_t, pid, int, sig,
+		siginfo_t __user *, uinfo)
+{
+	siginfo_t info;
+
+	if (copy_from_user(&info, uinfo, sizeof(siginfo_t)))
+		return -EFAULT;
+
+	return do_rt_tgsigqueueinfo(tgid, pid, sig, &info);
+}
+
 int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 {
 	struct task_struct *t = current;
