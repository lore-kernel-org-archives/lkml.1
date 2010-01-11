Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299Ab0AKV1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab0AKV1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356Ab0AKV1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:27:31 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:35373 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab0AKV1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=wbahk46Fv8iLwlVVLY5uKW5TCbBrEqjsQ6P4sx4Uij7FwAPRTTmtRSqHOUQFAZEi1Q
         sJz+FUehzEfNhDze+o4oZpj6IrkUn34uMCR+gQHBivtuzHkRNYiVaN4wR+HAJgMRAesM
         PAKgPZngwsdYGk6p2FJfYLrXNkFe2JfFVbFUA=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 15/26] clocksource: Convert watchdog_lock to raw_spinlock
Date: Mon, 11 Jan 2010 22:26:45 +0100
Message-Id: <1263245216-14754-16-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-15-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
 <1263245216-14754-4-git-send-email-jkacur@redhat.com>
 <1263245216-14754-5-git-send-email-jkacur@redhat.com>
 <1263245216-14754-6-git-send-email-jkacur@redhat.com>
 <1263245216-14754-7-git-send-email-jkacur@redhat.com>
 <1263245216-14754-8-git-send-email-jkacur@redhat.com>
 <1263245216-14754-9-git-send-email-jkacur@redhat.com>
 <1263245216-14754-10-git-send-email-jkacur@redhat.com>
 <1263245216-14754-11-git-send-email-jkacur@redhat.com>
 <1263245216-14754-12-git-send-email-jkacur@redhat.com>
 <1263245216-14754-13-git-send-email-jkacur@redhat.com>
 <1263245216-14754-14-git-send-email-jkacur@redhat.com>
 <1263245216-14754-15-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks that cannot sleep in preempt-rt to raw-spinlocks.

See also fea886ed3f18a93ab76fbeed13f1f73c97bd8982

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/time/clocksource.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index e85c234..ffcb48f 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -183,7 +183,7 @@ static LIST_HEAD(watchdog_list);
 static struct clocksource *watchdog;
 static struct timer_list watchdog_timer;
 static DECLARE_WORK(watchdog_work, clocksource_watchdog_work);
-static DEFINE_SPINLOCK(watchdog_lock);
+static DEFINE_RAW_SPINLOCK(watchdog_lock);
 static cycle_t watchdog_last;
 static int watchdog_running;
 
@@ -233,13 +233,13 @@ void clocksource_mark_unstable(struct clocksource *cs)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&watchdog_lock, flags);
+	raw_spin_lock_irqsave(&watchdog_lock, flags);
 	if (!(cs->flags & CLOCK_SOURCE_UNSTABLE)) {
 		if (list_empty(&cs->wd_list))
 			list_add(&cs->wd_list, &watchdog_list);
 		__clocksource_unstable(cs);
 	}
-	spin_unlock_irqrestore(&watchdog_lock, flags);
+	raw_spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
 static void clocksource_watchdog(unsigned long data)
@@ -249,7 +249,7 @@ static void clocksource_watchdog(unsigned long data)
 	int64_t wd_nsec, cs_nsec;
 	int next_cpu;
 
-	spin_lock(&watchdog_lock);
+	raw_spin_lock(&watchdog_lock);
 	if (!watchdog_running)
 		goto out;
 
@@ -308,7 +308,7 @@ static void clocksource_watchdog(unsigned long data)
 	watchdog_timer.expires += WATCHDOG_INTERVAL;
 	add_timer_on(&watchdog_timer, next_cpu);
 out:
-	spin_unlock(&watchdog_lock);
+	raw_spin_unlock(&watchdog_lock);
 }
 
 static inline void clocksource_start_watchdog(void)
@@ -343,16 +343,16 @@ static void clocksource_resume_watchdog(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&watchdog_lock, flags);
+	raw_spin_lock_irqsave(&watchdog_lock, flags);
 	clocksource_reset_watchdog();
-	spin_unlock_irqrestore(&watchdog_lock, flags);
+	raw_spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
 static void clocksource_enqueue_watchdog(struct clocksource *cs)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&watchdog_lock, flags);
+	raw_spin_lock_irqsave(&watchdog_lock, flags);
 	if (cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
 		/* cs is a clocksource to be watched. */
 		list_add(&cs->wd_list, &watchdog_list);
@@ -370,7 +370,7 @@ static void clocksource_enqueue_watchdog(struct clocksource *cs)
 	}
 	/* Check if the watchdog timer needs to be started. */
 	clocksource_start_watchdog();
-	spin_unlock_irqrestore(&watchdog_lock, flags);
+	raw_spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
 static void clocksource_dequeue_watchdog(struct clocksource *cs)
@@ -378,7 +378,7 @@ static void clocksource_dequeue_watchdog(struct clocksource *cs)
 	struct clocksource *tmp;
 	unsigned long flags;
 
-	spin_lock_irqsave(&watchdog_lock, flags);
+	raw_spin_lock_irqsave(&watchdog_lock, flags);
 	if (cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
 		/* cs is a watched clocksource. */
 		list_del_init(&cs->wd_list);
@@ -397,7 +397,7 @@ static void clocksource_dequeue_watchdog(struct clocksource *cs)
 	cs->flags &= ~CLOCK_SOURCE_WATCHDOG;
 	/* Check if the watchdog timer needs to be stopped. */
 	clocksource_stop_watchdog();
-	spin_unlock_irqrestore(&watchdog_lock, flags);
+	raw_spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
 static int clocksource_watchdog_kthread(void *data)
@@ -407,7 +407,7 @@ static int clocksource_watchdog_kthread(void *data)
 	LIST_HEAD(unstable);
 
 	mutex_lock(&clocksource_mutex);
-	spin_lock_irqsave(&watchdog_lock, flags);
+	raw_spin_lock_irqsave(&watchdog_lock, flags);
 	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list)
 		if (cs->flags & CLOCK_SOURCE_UNSTABLE) {
 			list_del_init(&cs->wd_list);
@@ -415,7 +415,7 @@ static int clocksource_watchdog_kthread(void *data)
 		}
 	/* Check if the watchdog timer needs to be stopped. */
 	clocksource_stop_watchdog();
-	spin_unlock_irqrestore(&watchdog_lock, flags);
+	raw_spin_unlock_irqrestore(&watchdog_lock, flags);
 
 	/* Needs to be done outside of watchdog lock */
 	list_for_each_entry_safe(cs, tmp, &unstable, wd_list) {
-- 
1.6.5.2

