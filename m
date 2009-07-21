Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbZGUS0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbZGUS0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 14:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbZGUS0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 14:26:36 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:56017 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZGUS0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 14:26:35 -0400
Date: Tue, 21 Jul 2009 20:25:05 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [RFC][PATCH] cache __next_timer_interrupt result
Message-ID: <20090721202505.7d56a079@skybase>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Each time a cpu goes to sleep on a NOHZ=y system the timer wheel is
searched for the next timer interrupt. It can take quite a few cycles
to find the next pending timer. This patch adds a field to tvec_base
that caches the result of __next_timer_interrupt. The hit ratio is
around 80% on my thinkpad under normal use, on a server I've seen
hit ratios from 5% to 95% dependent on the workload.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 kernel/timer.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -72,6 +72,7 @@ struct tvec_base {
 	spinlock_t lock;
 	struct timer_list *running_timer;
 	unsigned long timer_jiffies;
+	unsigned long next_timer;
 	struct tvec_root tv1;
 	struct tvec tv2;
 	struct tvec tv3;
@@ -622,6 +623,9 @@ __mod_timer(struct timer_list *timer, un
 
 	if (timer_pending(timer)) {
 		detach_timer(timer, 0);
+		if (timer->expires == base->next_timer &&
+		    !tbase_get_deferrable(timer->base))
+			base->next_timer = base->timer_jiffies;
 		ret = 1;
 	} else {
 		if (pending_only)
@@ -663,6 +667,9 @@ __mod_timer(struct timer_list *timer, un
 	}
 
 	timer->expires = expires;
+	if (timer->expires < base->next_timer &&
+	    !tbase_get_deferrable(timer->base))
+		base->next_timer = timer->expires;
 	internal_add_timer(base, timer);
 
 out_unlock:
@@ -781,6 +788,9 @@ void add_timer_on(struct timer_list *tim
 	spin_lock_irqsave(&base->lock, flags);
 	timer_set_base(timer, base);
 	debug_timer_activate(timer);
+	if (timer->expires < base->next_timer &&
+	    !tbase_get_deferrable(timer->base))
+		base->next_timer = timer->expires;
 	internal_add_timer(base, timer);
 	/*
 	 * Check whether the other CPU is idle and needs to be
@@ -817,6 +827,9 @@ int del_timer(struct timer_list *timer)
 		base = lock_timer_base(timer, &flags);
 		if (timer_pending(timer)) {
 			detach_timer(timer, 1);
+			if (timer->expires == base->next_timer &&
+			    !tbase_get_deferrable(timer->base))
+				base->next_timer = base->timer_jiffies;
 			ret = 1;
 		}
 		spin_unlock_irqrestore(&base->lock, flags);
@@ -850,6 +863,9 @@ int try_to_del_timer_sync(struct timer_l
 	ret = 0;
 	if (timer_pending(timer)) {
 		detach_timer(timer, 1);
+		if (timer->expires == base->next_timer &&
+		    !tbase_get_deferrable(timer->base))
+			base->next_timer = base->timer_jiffies;
 		ret = 1;
 	}
 out:
@@ -1134,7 +1150,9 @@ unsigned long get_next_timer_interrupt(u
 	unsigned long expires;
 
 	spin_lock(&base->lock);
-	expires = __next_timer_interrupt(base);
+	if (base->next_timer <= base->timer_jiffies)
+		base->next_timer = __next_timer_interrupt(base);
+	expires = base->next_timer;
 	spin_unlock(&base->lock);
 
 	if (time_before_eq(expires, now))
@@ -1523,6 +1541,7 @@ static int __cpuinit init_timers_cpu(int
 		INIT_LIST_HEAD(base->tv1.vec + j);
 
 	base->timer_jiffies = jiffies;
+	base->next_timer = base->timer_jiffies;
 	return 0;
 }
 
@@ -1535,6 +1554,9 @@ static void migrate_timer_list(struct tv
 		timer = list_first_entry(head, struct timer_list, entry);
 		detach_timer(timer, 0);
 		timer_set_base(timer, new_base);
+		if (timer->expires < new_base->next_timer &&
+		    !tbase_get_deferrable(timer->base))
+			new_base->next_timer = timer->expires;
 		internal_add_timer(new_base, timer);
 	}
 }
