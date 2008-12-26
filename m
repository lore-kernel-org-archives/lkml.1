Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbYLZNNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbYLZNNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 08:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYLZNNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 08:13:24 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:19052 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbYLZNNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 08:13:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IqwOC5CGiaBEI00QYRcOsWXbo5lnuU3G2In6d3Dr5dghwFzI+yRx+ESJzhJZ3XriRH
         7W97osAjpc+Y3VTZA4ceZH7B+iHrwILEK3mG8EAAh7z2MULrXGvqODIVrvws7x2RrUEl
         QSHDCd2gIHzqOH7lsVUhxxUBbTenQoDOearjQ=
Message-ID: <d36bb30d0812260513t13957a90h181060b8b2032eb9@mail.gmail.com>
Date: Fri, 26 Dec 2008 21:13:22 +0800
From: "Yang Xi" <yangxilkm@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 2.6.28-rc4]lock_stat: Add "con-hungry" to show that how many person-time fight for the ticket spinlock
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       chyyuu <chyyuu@gmail.com>
In-Reply-To: <20081226083431.GA755@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d36bb30d0811180300r77c3a13ld0a4881a8261a40@mail.gmail.com>
	 <1227025232.29743.23.camel@lappy.programming.kicks-ass.net>
	 <d36bb30d0811182118x1e394780n8a257fd4c44f4836@mail.gmail.com>
	 <1227112785.29743.37.camel@lappy.programming.kicks-ass.net>
	 <d36bb30d0811200009j742416a6nbc0519ff8d95970b@mail.gmail.com>
	 <1227404426.7685.19975.camel@twins>
	 <d36bb30d0812252324n512f4653of62f8b42684217d4@mail.gmail.com>
	 <20081226083431.GA755@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> #ifndef spin_nr_contended
> # define spin_nr_contended(lock) (spin_is_contended(lock) ? 1 : 0)
> #endif
And I change the spin_nr_contended to spin_nr_contender
> do we need the ->isticketspinlock distinction? Cannot we call
> spin_nr_contended() for all spinlocks? (it's just that for ticket
> spinlocks we get a real value out of it - for normal spinlocks we only get
> 0/1 out of it. But that is not a problem really.)
Not only the spin lock invokes lock_contended(). So we have to know
the invoker is spin lock. I have changed the isticketspinlock to
isspinlock to avoid the confusion.
>
> also, please rename 'hungry' to something more descriptive: for example
> 'nr_contended' fits pretty well?
I changed hungry to contender. con-hungry to nr-contender, max hungry
to max-contender.

Here is the patch

Signed-off-by: Yangxi <hiyangxi@gmail.com>
---
arch/x86/include/asm/spinlock.h |    9 +++++++++
 include/linux/lockdep.h         |    5 ++++-
 include/linux/spinlock.h        |    4 ++++
 kernel/lockdep.c                |   21 ++++++++++++++++++++-
 kernel/lockdep_proc.c           |   10 +++++++---
 lib/spinlock_debug.c            |    1 +
 6 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index d17c919..5c52960 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -172,6 +172,15 @@ static inline int
__ticket_spin_is_contended(raw_spinlock_t *lock)
 	return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) > 1;
 }

+static inline int __ticket_spin_nr_contender(raw_spinlock_t *lock)
+{
+	int tmp = ACCESS_ONCE(lock->slock);
+
+	return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) + 1;
+}
+
+#define spin_nr_contender(lock) __ticket_spin_nr_contender(&(lock)->raw_lock)
+
 #ifdef CONFIG_PARAVIRT
 /*
  * Define virtualization-friendly old-style lock byte lock, for use in
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 331e5f1..d777102 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -136,6 +136,8 @@ enum bounce_type {
 	bounce_acquired_read,
 	bounce_contended_write,
 	bounce_contended_read,
+	nr_contender,
+	max_contender,
 	nr_bounce_types,

 	bounce_acquired = bounce_acquired_write,
@@ -164,7 +166,8 @@ struct lockdep_map {
 	struct lock_class		*class_cache;
 	const char			*name;
 #ifdef CONFIG_LOCK_STAT
-	int				cpu;
+	unsigned int			cpu:32;
+	unsigned int                    isspinlock:1;
 #endif
 };

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index e0c0fcc..54b8a88 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -127,6 +127,10 @@ do {								\
 #define spin_is_contended(lock)	__raw_spin_is_contended(&(lock)->raw_lock)
 #endif

+#ifndef spin_nr_contender
+#define spin_nr_contender(lock) (spin_is_contended(lock) ? 1 : 0)
+#endif
+
 /**
  * spin_unlock_wait - wait until the spinlock gets unlocked
  * @lock: the spinlock in question.
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 06e1571..9a9e7d7 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -191,8 +191,14 @@ struct lock_class_stats lock_stats(struct
lock_class *class)
 		lock_time_add(&pcs->read_holdtime, &stats.read_holdtime);
 		lock_time_add(&pcs->write_holdtime, &stats.write_holdtime);

-		for (i = 0; i < ARRAY_SIZE(stats.bounces); i++)
+		for (i = 0; i < ARRAY_SIZE(stats.bounces); i++) {
+			if (i == max_contender) {
+				if (stats.bounces[i] < pcs->bounces[i])
+					stats.bounces[i] = pcs->bounces[i];
+				continue;
+			}
 			stats.bounces[i] += pcs->bounces[i];
+		}
 	}

 	return stats;
@@ -2998,9 +3004,16 @@ __lock_contended(struct lockdep_map *lock,
unsigned long ip)
 	struct task_struct *curr = current;
 	struct held_lock *hlock, *prev_hlock;
 	struct lock_class_stats *stats;
+	unsigned long contender;
+	spinlock_t *lock_ptr;
 	unsigned int depth;
 	int i, point;

+	if (lock->isspinlock) {
+		lock_ptr = container_of(lock, spinlock_t, dep_map);
+		contender = spin_nr_contender(lock_ptr);
+	}
+
 	depth = curr->lockdep_depth;
 	if (DEBUG_LOCKS_WARN_ON(!depth))
 		return;
@@ -3030,6 +3043,12 @@ found_it:
 		stats->contention_point[point]++;
 	if (lock->cpu != smp_processor_id())
 		stats->bounces[bounce_contended + !!hlock->read]++;
+	stats->bounces[nr_contender] += contender;
+	if (lock->isspinlock) {
+		if (stats->bounces[max_contender] < contender)
+			stats->bounces[max_contender] = contender;
+	}
+
 	put_lock_stats(stats);
 }

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 20dbcbf..c87b42c 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -535,6 +535,8 @@ static void seq_stats(struct seq_file *m, struct
lock_stat_data *data)
 			seq_printf(m, "%40s:", name);

 		seq_printf(m, "%14lu ", stats->bounces[bounce_contended_write]);
+		seq_printf(m, "%14lu ", stats->bounces[nr_contender]);
+		seq_printf(m, "%14lu ", stats->bounces[max_contender]);
 		seq_lock_time(m, &stats->write_waittime);
 		seq_printf(m, " %14lu ", stats->bounces[bounce_acquired_write]);
 		seq_lock_time(m, &stats->write_holdtime);
@@ -583,11 +585,13 @@ static void seq_stats(struct seq_file *m, struct
lock_stat_data *data)
 static void seq_header(struct seq_file *m)
 {
 	seq_printf(m, "lock_stat version 0.2\n");
-	seq_line(m, '-', 0, 40 + 1 + 10 * (14 + 1));
-	seq_printf(m, "%40s %14s %14s %14s %14s %14s %14s %14s %14s "
+	seq_line(m, '-', 0, 40 + 1 + 12 * (14 + 1));
+	seq_printf(m, "%40s %14s %14s %14s %14s %14s %14s %14s %14s %14s %14s "
 			"%14s %14s\n",
 			"class name",
 			"con-bounces",
+			"nr-contender",
+			"max-contender",
 			"contentions",
 			"waittime-min",
 			"waittime-max",
@@ -597,7 +601,7 @@ static void seq_header(struct seq_file *m)
 			"holdtime-min",
 			"holdtime-max",
 			"holdtime-total");
-	seq_line(m, '-', 0, 40 + 1 + 10 * (14 + 1));
+	seq_line(m, '-', 0, 40 + 1 + 12 * (14 + 1));
 	seq_printf(m, "\n");
 }

diff --git a/lib/spinlock_debug.c b/lib/spinlock_debug.c
index 9c4b025..5c6e06f 100644
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -27,6 +27,7 @@ void __spin_lock_init(spinlock_t *lock, const char *name,
 	lock->magic = SPINLOCK_MAGIC;
 	lock->owner = SPINLOCK_OWNER_INIT;
 	lock->owner_cpu = -1;
+	lock->dep_map.isspinlock = 1;
 }

 EXPORT_SYMBOL(__spin_lock_init);
