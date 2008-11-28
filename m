Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbYK1TER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbYK1TER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 14:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbYK1TEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 14:04:01 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:59564 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbYK1TEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 14:04:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=A14gThboEF52pTafJtfOAaE4aZGapZ94KT3ntO/uqyRUFU7dCohBaj1SRxmy7hOVCd
         oCCSY6gLTfIYecyB01a1oor6EHF3jyDSKSF53An4WJkVR+NFxNlKoZ5tWl2gC/r/tAjR
         iWJ1ey2lpapW5KiDoMZDFXqLF+1eHHbWgX/Iw=
Date: Fri, 28 Nov 2008 22:08:00 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sched: move double_unlock_balance() higher
Message-ID: <20081128190800.GB29909@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move double_lock_balance()/double_unlock_balance() higher to fix the following
with gcc-3.4.6:

  CC      kernel/sched.o
In file included from kernel/sched.c:1605:
kernel/sched_rt.c: In function `find_lock_lowest_rq':
kernel/sched_rt.c:914: sorry, unimplemented: inlining failed in call to 'double_unlock_balance': function body not available
kernel/sched_rt.c:1077: sorry, unimplemented: called from here
make[2]: *** [kernel/sched.o] Error 1

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 kernel/sched.c    |   67 ++++++++++++++++++++++++++----------------------------
 kernel/sched_rt.c |    4 ---
 2 files changed, 33 insertions(+), 38 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1588,6 +1588,39 @@ static inline void update_shares_locked(struct rq *rq, struct sched_domain *sd)
 
 #endif
 
+/*
+ * double_lock_balance - lock the busiest runqueue, this_rq is locked already.
+ */
+static int double_lock_balance(struct rq *this_rq, struct rq *busiest)
+	__releases(this_rq->lock)
+	__acquires(busiest->lock)
+	__acquires(this_rq->lock)
+{
+	int ret = 0;
+
+	if (unlikely(!irqs_disabled())) {
+		/* printk() doesn't work good under rq->lock */
+		spin_unlock(&this_rq->lock);
+		BUG_ON(1);
+	}
+	if (unlikely(!spin_trylock(&busiest->lock))) {
+		if (busiest < this_rq) {
+			spin_unlock(&this_rq->lock);
+			spin_lock(&busiest->lock);
+			spin_lock_nested(&this_rq->lock, SINGLE_DEPTH_NESTING);
+			ret = 1;
+		} else
+			spin_lock_nested(&busiest->lock, SINGLE_DEPTH_NESTING);
+	}
+	return ret;
+}
+
+static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
+	__releases(busiest->lock)
+{
+	spin_unlock(&busiest->lock);
+	lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_);
+}
 #endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -2788,40 +2821,6 @@ static void double_rq_unlock(struct rq *rq1, struct rq *rq2)
 }
 
 /*
- * double_lock_balance - lock the busiest runqueue, this_rq is locked already.
- */
-static int double_lock_balance(struct rq *this_rq, struct rq *busiest)
-	__releases(this_rq->lock)
-	__acquires(busiest->lock)
-	__acquires(this_rq->lock)
-{
-	int ret = 0;
-
-	if (unlikely(!irqs_disabled())) {
-		/* printk() doesn't work good under rq->lock */
-		spin_unlock(&this_rq->lock);
-		BUG_ON(1);
-	}
-	if (unlikely(!spin_trylock(&busiest->lock))) {
-		if (busiest < this_rq) {
-			spin_unlock(&this_rq->lock);
-			spin_lock(&busiest->lock);
-			spin_lock_nested(&this_rq->lock, SINGLE_DEPTH_NESTING);
-			ret = 1;
-		} else
-			spin_lock_nested(&busiest->lock, SINGLE_DEPTH_NESTING);
-	}
-	return ret;
-}
-
-static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
-	__releases(busiest->lock)
-{
-	spin_unlock(&busiest->lock);
-	lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_);
-}
-
-/*
  * If dest_cpu is allowed for this process, migrate the task to it.
  * This is accomplished by forcing the cpu_allowed mask to only
  * allow dest_cpu, which will force the cpu onto dest_cpu. Then
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -909,10 +909,6 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 /* Only try algorithms three times */
 #define RT_MAX_TRIES 3
 
-static int double_lock_balance(struct rq *this_rq, struct rq *busiest);
-static inline void double_unlock_balance(struct rq *this_rq,
-						struct rq *busiest);
-
 static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep);
 
 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
