Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbYI3Tt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbYI3Tt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbYI3TtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:49:24 -0400
Received: from www.tglx.de ([62.245.132.106]:44866 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbYI3TtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:49:23 -0400
Message-Id: <20080930194516.891475378@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 30 Sep 2008 19:49:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: [RFC patch 2/3] signals: implement sys_rt_tgsigqueueinfo
References: <20080930194445.978351700@linutronix.de>
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
 kernel/signal.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

Index: linux-2.6-tip/kernel/signal.c
===================================================================
--- linux-2.6-tip.orig/kernel/signal.c
+++ linux-2.6-tip/kernel/signal.c
@@ -2307,6 +2307,27 @@ sys_rt_sigqueueinfo(pid_t pid, int sig, 
 	return kill_proc_info(sig, &info, pid);
 }
 
+asmlinkage long
+sys_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig, siginfo_t __user *uinfo)
+{
+	siginfo_t info;
+
+	/* This is only valid for single tasks */
+	if (pid <= 0 || tgid <= 0)
+		return -EINVAL;
+
+	if (copy_from_user(&info, uinfo, sizeof(siginfo_t)))
+		return -EFAULT;
+
+	/* Not even root can pretend to send signals from the kernel.
+	   Nor can they impersonate a kill(), which adds source info.  */
+	if (info.si_code >= 0)
+		return -EPERM;
+	info.si_signo = sig;
+
+	return do_send_specific(tgid, pid, sig, &info);
+}
+
 int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 {
 	struct task_struct *t = current;


