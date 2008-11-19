Return-Path: <linux-kernel-owner+w=401wt.eu-S1752133AbYKSFSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbYKSFSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 00:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbYKSFSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 00:18:37 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:13784 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbYKSFSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 00:18:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xwH2IR0seCM7Nr08TYRQSJKJ7W74hNr3GB8X2+CKS3BKhgP1OD2Jyi2NvOri2JartW
         RxiFM71+zx6sUNZqs6xMWzGS+vzksnVPgRTd/ijISRYdPZhAwoY7wBQcikZZ3ZqicyN1
         4NCdHx88Yv4W1NxMPsZ4NvTSflpTyPhhHdjYE=
Message-ID: <d36bb30d0811182118x1e394780n8a257fd4c44f4836@mail.gmail.com>
Date: Wed, 19 Nov 2008 13:18:34 +0800
From: "Yang Xi" <yangxilkm@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2.6.28-rc4]lock_stat: Add "con-hungry" to show that how many person-time fight for the ticket spinlock
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <1227025232.29743.23.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d36bb30d0811180300r77c3a13ld0a4881a8261a40@mail.gmail.com>
	 <1227025232.29743.23.camel@lappy.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks. This should be better. I add __ticket_spin_nm_contended in
x86/include/asm/spinlock.h to return the number of threads
waiting/holding for the ticket spinlock(Note: The number contains the
holder). If the spinlock is ticket lock, "spin_nm_contended" will be
__ticket_spin_nm_contended, otherwise, it will be 0.

Signed-off-by: Yang Xi <hiyangxi@gmail.com>

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index d17c919..88c3774 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -172,6 +172,13 @@ static inline int
__ticket_spin_is_contended(raw_spinlock_t *lock)
        return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) > 1;
 }

+static inline int __ticket_spin_nm_contended(raw_spinlock_t *lock)
+{
+       int tmp = ACCESS_ONCE(lock->slock);
+
+       return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) + 1;
+}
+
 #ifdef CONFIG_PARAVIRT
 /*
  * Define virtualization-friendly old-style lock byte lock, for use in
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 331e5f1..5bc0a2f 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -136,6 +136,7 @@ enum bounce_type {
        bounce_acquired_read,
        bounce_contended_write,
        bounce_contended_read,
+       bounce_hungry,
        nr_bounce_types,

        bounce_acquired = bounce_acquired_write,
@@ -165,6 +166,7 @@ struct lockdep_map {
        const char                      *name;
 #ifdef CONFIG_LOCK_STAT
        int                             cpu;
+       unsigned int                    isspinlock:1;
 #endif
 };

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index e0c0fcc..322190d 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -127,6 +127,12 @@ do {
                 \
 #define spin_is_contended(lock)
__raw_spin_is_contended(&(lock)->raw_lock)
 #endif

+#ifdef TICKET_SHIFT
+#define spin_nm_contended(lock) __ticket_spin_nm_contended(&(lock)->raw_lock)
+#else
+#define spin_nm_contended(lock) (0)
+#endif
+
 /**
  * spin_unlock_wait - wait until the spinlock gets unlocked
  * @lock: the spinlock in question.
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 06e1571..5fe9e8a 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3000,7 +3000,14 @@ __lock_contended(struct lockdep_map *lock,
unsigned long ip)
        struct lock_class_stats *stats;
        unsigned int depth;
        int i, point;
-
+       spinlock_t * lock_ptr;
+       unsigned long hungry = 0;
+
+       if (lock->isspinlock) {
+               lock_ptr = container_of(lock,spinlock_t,dep_map);
+               hungry = spin_nm_contended(lock_ptr);
+       }
+
        depth = curr->lockdep_depth;
        if (DEBUG_LOCKS_WARN_ON(!depth))
                return;
@@ -3029,10 +3036,13 @@ found_it:
        if (point < ARRAY_SIZE(stats->contention_point))
                stats->contention_point[point]++;
        if (lock->cpu != smp_processor_id())
-               stats->bounces[bounce_contended + !!hlock->read]++;
+               stats->bounces[bounce_contended + !!hlock->read]++;
+       stats->bounces[bounce_hungry]+=hungry;
+
        put_lock_stats(stats);
 }

+
 static void
 __lock_acquired(struct lockdep_map *lock)
 {
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 20dbcbf..2fc3ca0 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -534,7 +534,8 @@ static void seq_stats(struct seq_file *m, struct
lock_stat_data *data)
                else
                        seq_printf(m, "%40s:", name);

-               seq_printf(m, "%14lu ", stats->bounces[bounce_contended_write]);
+               seq_printf(m, "%14lu ",
stats->bounces[bounce_contended_write]);
+               seq_printf(m, "%14lu ", stats->bounces[bounce_hungry]);
                seq_lock_time(m, &stats->write_waittime);
                seq_printf(m, " %14lu ", stats->bounces[bounce_acquired_write]);
                seq_lock_time(m, &stats->write_holdtime);
@@ -584,10 +585,11 @@ static void seq_header(struct seq_file *m)
 {
        seq_printf(m, "lock_stat version 0.2\n");
        seq_line(m, '-', 0, 40 + 1 + 10 * (14 + 1));
-       seq_printf(m, "%40s %14s %14s %14s %14s %14s %14s %14s %14s "
+       seq_printf(m, "%40s %14s %14s %14s %14s %14s %14s %14s %14s %14s "
                        "%14s %14s\n",
                        "class name",
                        "con-bounces",
+                       "con-hungry",
                        "contentions",
                        "waittime-min",
                        "waittime-max",
@@ -597,7 +599,7 @@ static void seq_header(struct seq_file *m)
                        "holdtime-min",
                        "holdtime-max",
                        "holdtime-total");
-       seq_line(m, '-', 0, 40 + 1 + 10 * (14 + 1));
+       seq_line(m, '-', 0, 40 + 1 + 11 * (14 + 1));
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
+       lock->dep_map.isspinlock = 1;
 }

 EXPORT_SYMBOL(__spin_lock_init);
