Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbZBZNht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbZBZNht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 08:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756195AbZBZNgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 08:36:44 -0500
Received: from www.tglx.de ([62.245.132.106]:55717 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217AbZBZNgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 08:36:43 -0500
Message-Id: <20090226133430.723636001@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 26 Feb 2009 13:35:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 1/3] signals: split do_tkill
References: <20090226133339.875832967@linutronix.de>
Content-Disposition: inline; filename=signals-split-do-tkill.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split out the code from do_tkill to make it reusable by the follow up
patch which implements sys_rt_tgsigqueueinfo

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/signal.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

Index: linux-2.6-tip/kernel/signal.c
===================================================================
--- linux-2.6-tip.orig/kernel/signal.c
+++ linux-2.6-tip/kernel/signal.c
@@ -2235,24 +2235,20 @@ SYSCALL_DEFINE2(kill, pid_t, pid, int, s
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
+	int error = -ESRCH;
 
-	error = -ESRCH;
-	info.si_signo = sig;
-	info.si_errno = 0;
-	info.si_code = SI_TKILL;
-	info.si_pid = task_tgid_vnr(current);
-	info.si_uid = current_uid();
+	info->si_pid = task_tgid_vnr(current);
+	info->si_uid = current_uid();
 
 	rcu_read_lock();
 	p = find_task_by_vpid(pid);
 	if (p && (tgid <= 0 || task_tgid_vnr(p) == tgid)) {
-		error = check_kill_permission(sig, &info, p);
+		error = check_kill_permission(sig, info, p);
 		/*
 		 * The null signal is a permissions and process existence
 		 * probe.  No signal is actually delivered.
@@ -2262,7 +2258,7 @@ static int do_tkill(pid_t tgid, pid_t pi
 		 * signal is private anyway.
 		 */
 		if (!error && sig && lock_task_sighand(p, &flags)) {
-			error = specific_send_sig_info(sig, &info, p);
+			error = specific_send_sig_info(sig, info, p);
 			unlock_task_sighand(p, &flags);
 		}
 	}
@@ -2271,6 +2267,17 @@ static int do_tkill(pid_t tgid, pid_t pi
 	return error;
 }
 
+static int do_tkill(pid_t tgid, pid_t pid, int sig)
+{
+	struct siginfo info;
+
+	info.si_signo = sig;
+	info.si_errno = 0;
+	info.si_code = SI_TKILL;
+
+	return do_send_specific(tgid, pid, sig, &info);
+}
+
 /**
  *  sys_tgkill - send signal to one specific thread
  *  @tgid: the thread group ID of the thread


