Return-Path: <linux-kernel-owner+w=401wt.eu-S1761597AbYHOUb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761597AbYHOUb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 16:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760961AbYHOUaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 16:30:52 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:36024
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760821AbYHOUau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:30:50 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH RT RFC v4 4/8] rtmutex: formally initialize the
	rt_mutex_waiters
To: mingo@elte.hu, paulmck@linux.vnet.ibm.com, peterz@infradead.org,
       tglx@linutronix.de, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       gregory.haskins@gmail.com, David.Holmes@sun.com, jkacur@gmail.com
Date: Fri, 15 Aug 2008 16:28:39 -0400
Message-ID: <20080815202839.668.70080.stgit@dev.haskins.net>
In-Reply-To: <20080815202408.668.23736.stgit@dev.haskins.net>
References: <20080815202408.668.23736.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will be adding more logic to rt_mutex_waiters and therefore lets
centralize the initialization to make this easier going forward.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/rtmutex.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 7d11380..12de859 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -805,6 +805,15 @@ static int adaptive_wait(struct rt_mutex_waiter *waiter,
 }
 #endif
 
+static void init_waiter(struct rt_mutex_waiter *waiter)
+{
+	memset(waiter, 0, sizeof(*waiter));
+
+	debug_rt_mutex_init_waiter(waiter);
+	waiter->task = NULL;
+	waiter->write_lock = 0;
+}
+
 /*
  * Slow path lock function spin_lock style: this variant is very
  * careful not to miss any non-lock wakeups.
@@ -823,9 +832,7 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 	struct task_struct *orig_owner;
 	int missed = 0;
 
-	debug_rt_mutex_init_waiter(&waiter);
-	waiter.task = NULL;
-	waiter.write_lock = 0;
+	init_waiter(&waiter);
 
 	spin_lock_irqsave(&lock->wait_lock, flags);
 	init_lists(lock);
@@ -1324,6 +1331,8 @@ rt_read_slowlock(struct rw_mutex *rwm, int mtx)
 	int saved_lock_depth = -1;
 	unsigned long saved_state = -1, state, flags;
 
+	init_waiter(&waiter);
+
 	spin_lock_irqsave(&mutex->wait_lock, flags);
 	init_rw_lists(rwm);
 
@@ -1335,10 +1344,6 @@ rt_read_slowlock(struct rw_mutex *rwm, int mtx)
 
 	/* Owner is a writer (or a blocked writer). Block on the lock */
 
-	debug_rt_mutex_init_waiter(&waiter);
-	waiter.task = NULL;
-	waiter.write_lock = 0;
-
 	if (mtx) {
 		/*
 		 * We drop the BKL here before we go into the wait loop to avoid a
@@ -1538,8 +1543,7 @@ rt_write_slowlock(struct rw_mutex *rwm, int mtx)
 	int saved_lock_depth = -1;
 	unsigned long flags, saved_state = -1, state;
 
-	debug_rt_mutex_init_waiter(&waiter);
-	waiter.task = NULL;
+	init_waiter(&waiter);
 
 	/* we do PI different for writers that are blocked */
 	waiter.write_lock = 1;
@@ -2270,9 +2274,7 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 	struct rt_mutex_waiter waiter;
 	unsigned long flags;
 
-	debug_rt_mutex_init_waiter(&waiter);
-	waiter.task = NULL;
-	waiter.write_lock = 0;
+	init_waiter(&waiter);
 
 	spin_lock_irqsave(&lock->wait_lock, flags);
 	init_lists(lock);

