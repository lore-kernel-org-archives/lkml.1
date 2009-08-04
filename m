Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZHDOQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZHDOQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbZHDOQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:16:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:40687 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479AbZHDOQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:16:39 -0400
Date: Tue, 4 Aug 2009 14:16:04 GMT
From: tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, venkatesh.pallipadi@intel.com,
       schwidefsky@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com,
       venkatesh.pallipadi@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090721202505.7d56a079@skybase>
References: <20090721202505.7d56a079@skybase>
Subject: [tip:timers/core] timers: Cache __next_timer_interrupt result
Message-ID: <tip-91ff44bdb806a3d26436cc4f5e4816d1ea75b34b@git.kernel.org>
Git-Commit-ID: 91ff44bdb806a3d26436cc4f5e4816d1ea75b34b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 14:16:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  91ff44bdb806a3d26436cc4f5e4816d1ea75b34b
Gitweb:     http://git.kernel.org/tip/91ff44bdb806a3d26436cc4f5e4816d1ea75b34b
Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
AuthorDate: Tue, 21 Jul 2009 20:25:05 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 16:07:51 +0200

timers: Cache __next_timer_interrupt result

Each time a cpu goes to sleep on a NOHZ=y system the timer
wheel is searched for the next timer interrupt. It can take
quite a few cycles to find the next pending timer.

This patch adds a field to tvec_base that caches the result of
__next_timer_interrupt.

The hit ratio is around 80% on my thinkpad under normal use, on
a server I've seen hit ratios from 5% to 95% dependent on the
workload.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>
LKML-Reference: <20090721202505.7d56a079@skybase>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/timer.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 0b36b9e..7769923 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -72,6 +72,7 @@ struct tvec_base {
 	spinlock_t lock;
 	struct timer_list *running_timer;
 	unsigned long timer_jiffies;
+	unsigned long next_timer;
 	struct tvec_root tv1;
 	struct tvec tv2;
 	struct tvec tv3;
@@ -622,6 +623,9 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 
 	if (timer_pending(timer)) {
 		detach_timer(timer, 0);
+		if (timer->expires == base->next_timer &&
+		    !tbase_get_deferrable(timer->base))
+			base->next_timer = base->timer_jiffies;
 		ret = 1;
 	} else {
 		if (pending_only)
@@ -663,6 +667,9 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 	}
 
 	timer->expires = expires;
+	if (timer->expires < base->next_timer &&
+	    !tbase_get_deferrable(timer->base))
+		base->next_timer = timer->expires;
 	internal_add_timer(base, timer);
 
 out_unlock:
@@ -781,6 +788,9 @@ void add_timer_on(struct timer_list *timer, int cpu)
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
@@ -850,6 +863,9 @@ int try_to_del_timer_sync(struct timer_list *timer)
 	ret = 0;
 	if (timer_pending(timer)) {
 		detach_timer(timer, 1);
+		if (timer->expires == base->next_timer &&
+		    !tbase_get_deferrable(timer->base))
+			base->next_timer = base->timer_jiffies;
 		ret = 1;
 	}
 out:
@@ -1134,7 +1150,9 @@ unsigned long get_next_timer_interrupt(unsigned long now)
 	unsigned long expires;
 
 	spin_lock(&base->lock);
-	expires = __next_timer_interrupt(base);
+	if (base->next_timer <= base->timer_jiffies)
+		base->next_timer = __next_timer_interrupt(base);
+	expires = base->next_timer;
 	spin_unlock(&base->lock);
 
 	if (time_before_eq(expires, now))
@@ -1523,6 +1541,7 @@ static int __cpuinit init_timers_cpu(int cpu)
 		INIT_LIST_HEAD(base->tv1.vec + j);
 
 	base->timer_jiffies = jiffies;
+	base->next_timer = base->timer_jiffies;
 	return 0;
 }
 
@@ -1535,6 +1554,9 @@ static void migrate_timer_list(struct tvec_base *new_base, struct list_head *hea
 		timer = list_first_entry(head, struct timer_list, entry);
 		detach_timer(timer, 0);
 		timer_set_base(timer, new_base);
+		if (timer->expires < new_base->next_timer &&
+		    !tbase_get_deferrable(timer->base))
+			new_base->next_timer = timer->expires;
 		internal_add_timer(new_base, timer);
 	}
 }
