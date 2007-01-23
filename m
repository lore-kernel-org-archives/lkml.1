Return-Path: <linux-kernel-owner+w=401wt.eu-S932933AbXAWJr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbXAWJr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 04:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932934AbXAWJr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 04:47:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35787 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932933AbXAWJr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 04:47:28 -0500
Date: Tue, 23 Jan 2007 10:45:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Subject: [patch] notifiers: fix blocking_notifier_call_chain() scalability
Message-ID: <20070123094550.GA21105@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_40 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3245]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [patch] notifiers: fix blocking_notifier_call_chain() scalability
From: Ingo Molnar <mingo@elte.hu>

while lock-profiling the -rt kernel i noticed weird contention during 
mmap-intense workloads, and the tracer showed the following gem, in one 
of our MM hotpaths:

 threaded-2771  1....   65us : sys_munmap (sysenter_do_call)
 threaded-2771  1....   66us : profile_munmap (sys_munmap)
 threaded-2771  1....   66us : blocking_notifier_call_chain (profile_munmap)
 threaded-2771  1....   66us : rt_down_read (blocking_notifier_call_chain)

ouch! a global rw-semaphore taken in one of the most 
performance-sensitive codepaths of the kernel. And i dont even have 
oprofile enabled! All distro kernels have CONFIG_PROFILING enabled, so 
this scalability problem affects the majority of Linux users.

The fix is to enhance blocking_notifier_call_chain() to only take the 
lock if there appears to be work on the call-chain.

With this patch applied i get nicely saturated system, and much higher 
munmap performance, on SMP systems.

And as a bonus this also fixes a similar scalability bottleneck in the 
thread-exit codepath: profile_task_exit() ...

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sys.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

Index: linux/kernel/sys.c
===================================================================
--- linux.orig/kernel/sys.c
+++ linux/kernel/sys.c
@@ -325,11 +325,18 @@ EXPORT_SYMBOL_GPL(blocking_notifier_chai
 int blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 		unsigned long val, void *v)
 {
-	int ret;
+	int ret = NOTIFY_DONE;
 
-	down_read(&nh->rwsem);
-	ret = notifier_call_chain(&nh->head, val, v);
-	up_read(&nh->rwsem);
+	/*
+	 * We check the head outside the lock, but if this access is
+	 * racy then it does not matter what the result of the test
+	 * is, we re-check the list after having taken the lock anyway:
+	 */
+	if (rcu_dereference(nh->head)) {
+		down_read(&nh->rwsem);
+		ret = notifier_call_chain(&nh->head, val, v);
+		up_read(&nh->rwsem);
+	}
 	return ret;
 }
 
