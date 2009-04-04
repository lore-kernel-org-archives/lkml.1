Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbZDDVD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbZDDVD2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 17:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697AbZDDVCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 17:02:50 -0400
Received: from www.tglx.de ([62.245.132.106]:54165 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048AbZDDVCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 17:02:48 -0400
Message-Id: <20090404201649.557307529@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 04 Apr 2009 21:01:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@osdl.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: [patch 2/3] signals: implement sys_rt_tgsigqueueinfo
References: <20090404201641.328118982@linutronix.de>
Content-Disposition: inline;
	filename=signals-implement-sys-rt-tgsigqueueinfo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Acked-by: Ulrich Drepper <drepper@redhat.com>
---
 include/linux/compat.h |    2 ++
 include/linux/signal.h |    2 ++
 kernel/compat.c        |   11 +++++++++++
 kernel/signal.c        |   26 ++++++++++++++++++++++++++
 4 files changed, 41 insertions(+)

Index: linux-2.6/include/linux/compat.h
===================================================================
--- linux-2.6.orig/include/linux/compat.h
+++ linux-2.6/include/linux/compat.h
@@ -222,6 +222,8 @@ int copy_siginfo_from_user32(siginfo_t *
 int copy_siginfo_to_user32(struct compat_siginfo __user *to, siginfo_t *from);
 int get_compat_sigevent(struct sigevent *event,
 		const struct compat_sigevent __user *u_event);
+long compat_sys_rt_tgsigqueueinfo(compat_pid_t tgid, compat_pid_t pid, int sig,
+				  struct compat_siginfo __user *uinfo);
 
 static inline int compat_timeval_compare(struct compat_timeval *lhs,
 					struct compat_timeval *rhs)
Index: linux-2.6/include/linux/signal.h
===================================================================
--- linux-2.6.orig/include/linux/signal.h
+++ linux-2.6/include/linux/signal.h
@@ -235,6 +235,8 @@ static inline int valid_signal(unsigned 
 extern int next_signal(struct sigpending *pending, sigset_t *mask);
 extern int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p);
 extern int __group_send_sig_info(int, struct siginfo *, struct task_struct *);
+extern long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig,
+				 siginfo_t *info);
 extern long do_sigpending(void __user *, unsigned long);
 extern int sigprocmask(int, sigset_t *, sigset_t *);
 extern int show_unhandled_signals;
Index: linux-2.6/kernel/compat.c
===================================================================
--- linux-2.6.orig/kernel/compat.c
+++ linux-2.6/kernel/compat.c
@@ -882,6 +882,17 @@ compat_sys_rt_sigtimedwait (compat_sigse
 
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
Index: linux-2.6/kernel/signal.c
===================================================================
--- linux-2.6.orig/kernel/signal.c
+++ linux-2.6/kernel/signal.c
@@ -2369,6 +2369,32 @@ SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t, 
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


