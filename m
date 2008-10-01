Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452AbYJAKCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbYJAKCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 06:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYJAKCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 06:02:06 -0400
Received: from www.tglx.de ([62.245.132.106]:37618 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbYJAKCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 06:02:05 -0400
Message-Id: <20081001095412.217106351@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 01 Oct 2008 10:01:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: [RFC patch 2/3] signals: implement sys_rt_tgsigqueueinfo
References: <20081001095204.343984413@linutronix.de>
Content-Disposition: inline; filename=signals-implement-rt-tgsigqueueinfo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_kill has the per thread counterpart sys_tgkill. sigqueueinfo is
missing a thread directed counterpart. Such an interface is important
for migrating applications from other OSes which have the per thread
delivery implemented.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/compat.h |    2 ++
 include/linux/signal.h |    2 ++
 kernel/compat.c        |   11 +++++++++++
 kernel/signal.c        |   26 ++++++++++++++++++++++++++
 4 files changed, 41 insertions(+)

Index: linux-2.6-tip/include/linux/compat.h
===================================================================
--- linux-2.6-tip.orig/include/linux/compat.h
+++ linux-2.6-tip/include/linux/compat.h
@@ -209,6 +209,8 @@ int copy_siginfo_from_user32(siginfo_t *
 int copy_siginfo_to_user32(struct compat_siginfo __user *to, siginfo_t *from);
 int get_compat_sigevent(struct sigevent *event,
 		const struct compat_sigevent __user *u_event);
+long compat_sys_rt_tgsigqueueinfo(compat_pid_t tgid, compat_pid_t pid, int sig,
+				  struct compat_siginfo __user *uinfo);
 
 static inline int compat_timeval_compare(struct compat_timeval *lhs,
 					struct compat_timeval *rhs)
Index: linux-2.6-tip/include/linux/signal.h
===================================================================
--- linux-2.6-tip.orig/include/linux/signal.h
+++ linux-2.6-tip/include/linux/signal.h
@@ -235,6 +235,8 @@ static inline int valid_signal(unsigned 
 extern int next_signal(struct sigpending *pending, sigset_t *mask);
 extern int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p);
 extern int __group_send_sig_info(int, struct siginfo *, struct task_struct *);
+extern long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig,
+				 siginfo_t *info);
 extern long do_sigpending(void __user *, unsigned long);
 extern int sigprocmask(int, sigset_t *, sigset_t *);
 extern int show_unhandled_signals;
Index: linux-2.6-tip/kernel/compat.c
===================================================================
--- linux-2.6-tip.orig/kernel/compat.c
+++ linux-2.6-tip/kernel/compat.c
@@ -836,6 +836,17 @@ compat_sys_rt_sigtimedwait (compat_sigse
 
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
Index: linux-2.6-tip/kernel/signal.c
===================================================================
--- linux-2.6-tip.orig/kernel/signal.c
+++ linux-2.6-tip/kernel/signal.c
@@ -2307,6 +2307,32 @@ sys_rt_sigqueueinfo(pid_t pid, int sig, 
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
+asmlinkage long
+sys_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig, siginfo_t __user *uinfo)
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


