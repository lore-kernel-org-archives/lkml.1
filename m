Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbZHABjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbZHABjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 21:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZHABjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 21:39:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39873 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbZHABjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 21:39:11 -0400
Date: Sat, 1 Aug 2009 03:28:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
Subject: [PATCH 1/2] signals: introduce do_send_sig_info() helper
Message-ID: <20090801012811.GB30259@redhat.com>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com> <1248869948.6987.3083.camel@twins> <20090729221703.GA25368@redhat.com> <1248953485.6391.41.camel@twins> <20090730192040.GA9503@redhat.com> <1248984003.4164.0.camel@laptop> <20090730202804.GA13675@redhat.com> <1249029320.6391.72.camel@twins> <20090731141122.a1939712.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090731141122.a1939712.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce do_send_sig_info() and convert group_send_sig_info(),
send_sig_info(), do_send_specific() to use this helper.

Hopefully it will have more users soon, it allows to specify
specific/group behaviour via "bool group" argument.

Shaves 80 bytes from .text.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/signal.h |    2 +
 kernel/signal.c        |   56 +++++++++++++++++++++++--------------------------
 2 files changed, 29 insertions(+), 29 deletions(-)

--- WAIT/include/linux/signal.h~1_HELPER	2009-06-11 14:16:46.000000000 +0200
+++ WAIT/include/linux/signal.h	2009-08-01 02:26:41.000000000 +0200
@@ -233,6 +233,8 @@ static inline int valid_signal(unsigned 
 }
 
 extern int next_signal(struct sigpending *pending, sigset_t *mask);
+extern int do_send_sig_info(int sig, struct siginfo *info,
+				struct task_struct *p, bool group);
 extern int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p);
 extern int __group_send_sig_info(int, struct siginfo *, struct task_struct *);
 extern long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig,
--- WAIT/kernel/signal.c~1_HELPER	2009-07-01 20:22:44.000000000 +0200
+++ WAIT/kernel/signal.c	2009-08-01 02:21:27.000000000 +0200
@@ -971,6 +971,20 @@ specific_send_sig_info(int sig, struct s
 	return send_signal(sig, info, t, 0);
 }
 
+int do_send_sig_info(int sig, struct siginfo *info, struct task_struct *p,
+			bool group)
+{
+	unsigned long flags;
+	int ret = -ESRCH;
+
+	if (lock_task_sighand(p, &flags)) {
+		ret = send_signal(sig, info, p, group);
+		unlock_task_sighand(p, &flags);
+	}
+
+	return ret;
+}
+
 /*
  * Force a signal that the process can't ignore: if necessary
  * we unblock the signal and change any SIG_IGN to SIG_DFL.
@@ -1068,18 +1082,10 @@ struct sighand_struct *lock_task_sighand
  */
 int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {
-	unsigned long flags;
-	int ret;
-
-	ret = check_kill_permission(sig, info, p);
+	int ret = check_kill_permission(sig, info, p);
 
-	if (!ret && sig) {
-		ret = -ESRCH;
-		if (lock_task_sighand(p, &flags)) {
-			ret = __group_send_sig_info(sig, info, p);
-			unlock_task_sighand(p, &flags);
-		}
-	}
+	if (!ret && sig)
+		ret = do_send_sig_info(sig, info, p, true);
 
 	return ret;
 }
@@ -1224,15 +1230,9 @@ static int kill_something_info(int sig, 
  * These are for backward compatibility with the rest of the kernel source.
  */
 
-/*
- * The caller must ensure the task can't exit.
- */
 int
 send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {
-	int ret;
-	unsigned long flags;
-
 	/*
 	 * Make sure legacy kernel users don't send in bad values
 	 * (normal paths check this in check_kill_permission).
@@ -1240,10 +1240,7 @@ send_sig_info(int sig, struct siginfo *i
 	if (!valid_signal(sig))
 		return -EINVAL;
 
-	spin_lock_irqsave(&p->sighand->siglock, flags);
-	ret = specific_send_sig_info(sig, info, p);
-	spin_unlock_irqrestore(&p->sighand->siglock, flags);
-	return ret;
+	return do_send_sig_info(sig, info, p, false);
 }
 
 #define __si_special(priv) \
@@ -2281,7 +2278,6 @@ static int
 do_send_specific(pid_t tgid, pid_t pid, int sig, struct siginfo *info)
 {
 	struct task_struct *p;
-	unsigned long flags;
 	int error = -ESRCH;
 
 	rcu_read_lock();
@@ -2291,14 +2287,16 @@ do_send_specific(pid_t tgid, pid_t pid, 
 		/*
 		 * The null signal is a permissions and process existence
 		 * probe.  No signal is actually delivered.
-		 *
-		 * If lock_task_sighand() fails we pretend the task dies
-		 * after receiving the signal. The window is tiny, and the
-		 * signal is private anyway.
 		 */
-		if (!error && sig && lock_task_sighand(p, &flags)) {
-			error = specific_send_sig_info(sig, info, p);
-			unlock_task_sighand(p, &flags);
+		if (!error && sig) {
+			error = do_send_sig_info(sig, info, p, false);
+			/*
+			 * If lock_task_sighand() failed we pretend the task
+			 * dies after receiving the signal. The window is tiny,
+			 * and the signal is private anyway.
+			 */
+			if (unlikely(error == -ESRCH))
+				error = 0;
 		}
 	}
 	rcu_read_unlock();

