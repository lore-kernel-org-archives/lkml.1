Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbYKRLBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbYKRLBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 06:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbYKRLA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 06:00:59 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:15115 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbYKRLA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 06:00:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=dRnTOU2n6AqEfarGgabID/cMS7vMmYOWRvr/WCLudvHw5fZHes8PtInlB8fFrpVCX/
         VoIM9OyycQqPXqwRqHYeiyGoUchZHE16FjvxON93Qxp/WSAeTVGZqfLxI1k1PhDyXLrw
         2NfJlqv/aXqes50p5fM1saeD99U4NrybkAyew=
Message-ID: <d36bb30d0811180300r77c3a13ld0a4881a8261a40@mail.gmail.com>
Date: Tue, 18 Nov 2008 19:00:56 +0800
From: "Yang Xi" <yangxilkm@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.28-rc4]lock_stat: Add "con-hungry" to show that how many person-time fight for the ticket spinlock
Cc: mingo@elte.hu
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the implementation of X86 spinlock adopts ticket lock, we can
know how many threads are waiting for the lock when there is a
contention on the spinlock. We add the number of these threads to the
bounces[bounce_hungry] and name "bounces[bounce_hungry]" as
"con-hungry". Finally, we can use this number to show that "the number
of threads waiting for a spinlock/ a contention". From it, we can know
that whether it is valuable to replace the spinlock  with more
scalable spinlock since the design principle of scalability spinlock
is to decrease the cache invalid cost, if the "con-hungry/contentions"
is not high, we cannot benefit from more scalable spinlocks.


Signed-off-by: Yang Xi <hiyangxi@gmail.com>


diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 331e5f1..a71398e 100644
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
+       int                             isspinlock;
 #endif
 };

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 06e1571..b3314ed 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3000,6 +3000,20 @@ __lock_contended(struct lockdep_map *lock,
unsigned long ip)
        struct lock_class_stats *stats;
        unsigned int depth;
        int i, point;
+       spinlock_t * lock_ptr;
+       unsigned long hungry;
+
+       if (lock->isspinlock){
+               lock_ptr = container_of(lock,spinlock_t,dep_map);
+
+#if (NR_CPUS < 256)
+               hungry=(unsigned
char)((lock_ptr->raw_lock.slock>>8&0xff)-(lock_ptr->raw_lock.slock&0xff));
+
+#else
+               hungry=(unsigned
short)((lock_ptr->raw_lock.slock>>16&0xffff)-(lock_ptr->raw_lock.slock&0xffff));
+
+#endif
+       }

        depth = curr->lockdep_depth;
        if (DEBUG_LOCKS_WARN_ON(!depth))
@@ -3030,9 +3044,13 @@ found_it:
                stats->contention_point[point]++;
        if (lock->cpu != smp_processor_id())
                stats->bounces[bounce_contended + !!hlock->read]++;
+       if (lock->isspinlock){
+               stats->bounces[bounce_hungry]+=hungry+1;
+       }
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
index 9c4b025..2ec34ec 100644
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -27,6 +27,10 @@ void __spin_lock_init(spinlock_t *lock, const char *name,
        lock->magic = SPINLOCK_MAGIC;
        lock->owner = SPINLOCK_OWNER_INIT;
        lock->owner_cpu = -1;
+       lock->dep_map.isspinlock = 0;
+#if ((defined(CONFIG_X86) || defined(CONFIG_X86_64))&&
defined(CONFIG_LOCK_STAT))
+       lock->dep_map.isspinlock = 1;
+#endif
 }

 EXPORT_SYMBOL(__spin_lock_init);
coder@coder-desktop:~/work/linux/linux-2.6$ git diff -u -p
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 331e5f1..a71398e 100644
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
+       int                             isspinlock;
 #endif
 };

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 06e1571..b3314ed 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3000,6 +3000,20 @@ __lock_contended(struct lockdep_map *lock,
unsigned long ip)
        struct lock_class_stats *stats;
        unsigned int depth;
        int i, point;
+       spinlock_t * lock_ptr;
+       unsigned long hungry;
+
+       if (lock->isspinlock){
+               lock_ptr = container_of(lock,spinlock_t,dep_map);
+
+#if (NR_CPUS < 256)
+               hungry=(unsigned
char)((lock_ptr->raw_lock.slock>>8&0xff)-(lock_ptr->raw_lock.slock&0xff));
+
+#else
+               hungry=(unsigned
short)((lock_ptr->raw_lock.slock>>16&0xffff)-(lock_ptr->raw_lock.slock&0xffff));
+
+#endif
+       }

        depth = curr->lockdep_depth;
        if (DEBUG_LOCKS_WARN_ON(!depth))
@@ -3030,9 +3044,13 @@ found_it:
                stats->contention_point[point]++;
        if (lock->cpu != smp_processor_id())
                stats->bounces[bounce_contended + !!hlock->read]++;
+       if (lock->isspinlock){
+               stats->bounces[bounce_hungry]+=hungry+1;
+       }
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
index 9c4b025..2ec34ec 100644
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -27,6 +27,10 @@ void __spin_lock_init(spinlock_t *lock, const char *name,
        lock->magic = SPINLOCK_MAGIC;
        lock->owner = SPINLOCK_OWNER_INIT;
        lock->owner_cpu = -1;
+       lock->dep_map.isspinlock = 0;
+#if ((defined(CONFIG_X86) || defined(CONFIG_X86_64))&&
defined(CONFIG_LOCK_STAT))
+       lock->dep_map.isspinlock = 1;
+#endif
 }

 EXPORT_SYMBOL(__spin_lock_init);
