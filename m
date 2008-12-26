Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbYLZHYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbYLZHYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 02:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbYLZHYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 02:24:32 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:34752 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbYLZHYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 02:24:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VHtkOyCcVxnl1i/E9hUkdjc/C+nqivcMMUy3t8FJCm/9go0jKuQiVqZS11d2/VTpOR
         VGwD3nI1120GXuCY8GBwwPrZbKwESupgNIobxsypqYWcV7UPSvS0Z1IGSKO4RZnGV+tN
         yavyZJt+rbZw3gOBXx+Ivuif9FYS8Yt33ccFM=
Message-ID: <d36bb30d0812252324n512f4653of62f8b42684217d4@mail.gmail.com>
Date: Fri, 26 Dec 2008 15:24:30 +0800
From: "Yang Xi" <yangxilkm@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2.6.28-rc4]lock_stat: Add "con-hungry" to show that how many person-time fight for the ticket spinlock
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, chyyuu <chyyuu@gmail.com>
In-Reply-To: <1227404426.7685.19975.camel@twins>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*Add max-hungry to capture the max value of the number of threads who
fight on a ticket lock
*For non-ticketlock implementation,  spin_nr_contended(lock) is
(spin_is_contended(lock) ? 1 : 0), which means "con-hungry" represent
how many times there are more than two threads waiting for the
spinlock to be free.

Because the lock-stat and lock-dep is so heavy, this statistic result
is not very accurate :(

Here is the patch.

Signed-off-by: Yangxi <hiyangxi@gmail.com>
---

 arch/x86/Kconfig                |    1 +
 arch/x86/include/asm/spinlock.h |    7 +++++++
 include/linux/lockdep.h         |    5 ++++-
 include/linux/spinlock.h        |    6 ++++++
 kernel/lockdep.c                |   24 +++++++++++++++++++++---
 kernel/lockdep_proc.c           |   10 +++++++---
 lib/Kconfig.debug               |    3 +++
 lib/spinlock_debug.c            |    1 +
 8 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4cf0ab1..20fee72 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -34,6 +34,7 @@ config X86
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
+	select HAVE_TICKET_SPINLOCK

 config ARCH_DEFCONFIG
 	string
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index d17c919..da9cffc 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -172,6 +172,13 @@ static inline int
__ticket_spin_is_contended(raw_spinlock_t *lock)
 	return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) > 1;
 }

+static inline int __ticket_spin_nr_contended(raw_spinlock_t *lock)
+{
+	int tmp = ACCESS_ONCE(lock->slock);
+
+	return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) + 1;
+}
+
 #ifdef CONFIG_PARAVIRT
 /*
  * Define virtualization-friendly old-style lock byte lock, for use in
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 331e5f1..c45efc2 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -136,6 +136,8 @@ enum bounce_type {
 	bounce_acquired_read,
 	bounce_contended_write,
 	bounce_contended_read,
+	bounce_hungry,
+	bounce_max_hungry,
 	nr_bounce_types,

 	bounce_acquired = bounce_acquired_write,
@@ -164,7 +166,8 @@ struct lockdep_map {
 	struct lock_class		*class_cache;
 	const char			*name;
 #ifdef CONFIG_LOCK_STAT
-	int				cpu;
+	unsigned int			cpu:31;
+	unsigned int                    isticketspinlock:1;
 #endif
 };

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index e0c0fcc..c6be4bc 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -127,6 +127,12 @@ do {								\
 #define spin_is_contended(lock)	__raw_spin_is_contended(&(lock)->raw_lock)
 #endif

+#ifdef CONFIG_HAVE_TICKET_SPINLOCK
+#define spin_nr_contended(lock) __ticket_spin_nr_contended(&(lock)->raw_lock)
+#else
+#define spin_nr_contended(lock) (spin_is_contended(lock) ? 1 : 0)
+#endif
+
 /**
  * spin_unlock_wait - wait until the spinlock gets unlocked
  * @lock: the spinlock in question.
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 06e1571..8483e1e 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -191,8 +191,14 @@ struct lock_class_stats lock_stats(struct
lock_class *class)
 		lock_time_add(&pcs->read_holdtime, &stats.read_holdtime);
 		lock_time_add(&pcs->write_holdtime, &stats.write_holdtime);

-		for (i = 0; i < ARRAY_SIZE(stats.bounces); i++)
+		for (i = 0; i < ARRAY_SIZE(stats.bounces); i++) {
+			if (i == bounce_max_hungry) {
+				if (stats.bounces[i] < pcs->bounces[i])
+					stats.bounces[i] = pcs->bounces[i];
+				continue;
+			}
 			stats.bounces[i] += pcs->bounces[i];
+		}
 	}

 	return stats;
@@ -2588,7 +2594,6 @@ static int __lock_acquire(struct lockdep_map
*lock, unsigned int subclass,

 	if (check == 2 && !mark_irqflags(curr, hlock))
 		return 0;
-
 	/* mark it as used: */
 	if (!mark_lock(curr, hlock, LOCK_USED))
 		return 0;
@@ -2623,7 +2628,6 @@ static int __lock_acquire(struct lockdep_map
*lock, unsigned int subclass,

 	if (!validate_chain(curr, lock, hlock, chain_head, chain_key))
 		return 0;
-
 	curr->curr_chain_key = chain_key;
 	curr->lockdep_depth++;
 	check_chain_key(curr);
@@ -3000,6 +3004,13 @@ __lock_contended(struct lockdep_map *lock,
unsigned long ip)
 	struct lock_class_stats *stats;
 	unsigned int depth;
 	int i, point;
+	spinlock_t *lock_ptr;
+	unsigned long hungry = 0;
+
+	if (lock->isticketspinlock) {
+		lock_ptr = container_of(lock, spinlock_t, dep_map);
+		hungry = spin_nr_contended(lock_ptr);
+	}

 	depth = curr->lockdep_depth;
 	if (DEBUG_LOCKS_WARN_ON(!depth))
@@ -3030,9 +3041,16 @@ found_it:
 		stats->contention_point[point]++;
 	if (lock->cpu != smp_processor_id())
 		stats->bounces[bounce_contended + !!hlock->read]++;
+	stats->bounces[bounce_hungry] += hungry;
+	if (lock->isticketspinlock) {
+		if (stats->bounces[bounce_max_hungry] < hungry)
+			stats->bounces[bounce_max_hungry] = hungry;
+	}
+
 	put_lock_stats(stats);
 }

+
 static void
 __lock_acquired(struct lockdep_map *lock)
 {
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 20dbcbf..d5f94e5 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -535,6 +535,8 @@ static void seq_stats(struct seq_file *m, struct
lock_stat_data *data)
 			seq_printf(m, "%40s:", name);

 		seq_printf(m, "%14lu ", stats->bounces[bounce_contended_write]);
+		seq_printf(m, "%14lu ", stats->bounces[bounce_hungry]);
+		seq_printf(m, "%14lu ", stats->bounces[bounce_max_hungry]);
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
+			"con-hungry",
+			"max-hungry",
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

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index b0f239e..b9eb62a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -318,6 +318,9 @@ config RT_MUTEX_TESTER
 	help
 	  This option enables a rt-mutex tester.

+config HAVE_TICKET_SPINLOCK
+       bool
+
 config DEBUG_SPINLOCK
 	bool "Spinlock and rw-lock debugging: basic checks"
 	depends on DEBUG_KERNEL
diff --git a/lib/spinlock_debug.c b/lib/spinlock_debug.c
index 9c4b025..bba8d3e 100644
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -27,6 +27,7 @@ void __spin_lock_init(spinlock_t *lock, const char *name,
 	lock->magic = SPINLOCK_MAGIC;
 	lock->owner = SPINLOCK_OWNER_INIT;
 	lock->owner_cpu = -1;
+	lock->dep_map.isticketspinlock = 1;
 }

 EXPORT_SYMBOL(__spin_lock_init);
