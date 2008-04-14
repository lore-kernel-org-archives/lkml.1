Return-Path: <linux-kernel-owner+w=401wt.eu-S1758977AbYDNMmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977AbYDNMmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 08:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbYDNMmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 08:42:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53639 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbYDNMmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 08:42:32 -0400
Subject: Re: 2.6.25-rc9 -- INFO: possible circular locking dependency
	detected
From: Peter Zijlstra <peterz@infradead.org>
To: ego@in.ibm.com
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080414122741.GB7416@in.ibm.com>
References: <a44ae5cd0804132004v2bef54fek6e9634f8bce087ab@mail.gmail.com>
	 <1208156045.7427.16.camel@twins> <1208174767.7427.60.camel@twins>
	 <20080414122741.GB7416@in.ibm.com>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 14:42:27 +0200
Message-Id: <1208176947.7427.68.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-14 at 17:57 +0530, Gautham R Shenoy wrote:

> > Ok, so cpu_hotplug has a few issues imho:
> > 
> >  - access to active_writer isn't serialized and thus racey
> >  - holding the lock over the 'write' section generates the stuff above
> > 
> > So basically we want a reader/writer lock, where get/put_online_cpu is
> > the read side and cpu_hotplug_begin/done the write side.
> > 
> > We want:
> >  - readers to recurse in readers (code excluding cpu-hotplug can
> >    call code needing the same).
> > 
> >  - readers to recurse in the writer (the code changing the state can
> >    call code needing a stable state)
> > 
> > rwlock_t isn't quite suitable because it doesn't allow reader in writer
> > recursion and doesn't allow sleeping.
> > 
> > No lockdep annotation _yet_, because current lockdep recursive reader
> > support is:
> >  - broken (have a patch for that)
> >  - doesn't support reader in writer recursion (will have to do something
> >    about that)
> > 
> > Ok, so aside from the obviuos disclaimers, I've only compiled this and
> > might have made things way too complicated - but a slightly feverish
> > brain does that at times. What do people think?
> 
> You beat me to it! 
> 
> I just whipped up a similar patch, with slight differences, and lockdep
> annotations :)

lockdep doesn't quite acecpt reader in writer recursion without a little
patch like so:

(fold of two patches - one fixing the recursion another adding
reader-writer recursion)

cpu_hotplug should use 3.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6-2/kernel/lockdep.c
===================================================================
--- linux-2.6-2.orig/kernel/lockdep.c
+++ linux-2.6-2/kernel/lockdep.c
@@ -1281,6 +1281,13 @@ check_deadlock(struct task_struct *curr,
 		 */
 		if ((read == 2) && prev->read)
 			return 2;
+		/*
+		 * Allow read-after-write recursion of the same
+		 * lock class (i.e. write_lock(lock)+read_lock(lock)):
+		 */
+		if (read == 3)
+			return 2;
+
 		return print_deadlock_bug(curr, prev, next);
 	}
 	return 1;
@@ -1557,12 +1564,11 @@ static int validate_chain(struct task_st
 		if (!ret)
 			return 0;
 		/*
-		 * Mark recursive read, as we jump over it when
-		 * building dependencies (just like we jump over
-		 * trylock entries):
+		 * If we are the first recursive read, don't jump over our
+		 * dependency.
 		 */
-		if (ret == 2)
-			hlock->read = 2;
+		if (hlock->read >= 2 && ret != 2)
+			hlock->read = 1;
 		/*
 		 * Add dependency only if this lock is not the head
 		 * of the chain, and if it's not a secondary read-lock:
Index: linux-2.6-2/lib/locking-selftest.c
===================================================================
--- linux-2.6-2.orig/lib/locking-selftest.c
+++ linux-2.6-2/lib/locking-selftest.c
@@ -1135,12 +1135,12 @@ void locking_selftest(void)
 	debug_locks_silent = !debug_locks_verbose;
 
 	DO_TESTCASE_6R("A-A deadlock", AA);
-	DO_TESTCASE_6R("A-B-B-A deadlock", ABBA);
-	DO_TESTCASE_6R("A-B-B-C-C-A deadlock", ABBCCA);
-	DO_TESTCASE_6R("A-B-C-A-B-C deadlock", ABCABC);
-	DO_TESTCASE_6R("A-B-B-C-C-D-D-A deadlock", ABBCCDDA);
-	DO_TESTCASE_6R("A-B-C-D-B-D-D-A deadlock", ABCDBDDA);
-	DO_TESTCASE_6R("A-B-C-D-B-C-D-A deadlock", ABCDBCDA);
+	DO_TESTCASE_6("A-B-B-A deadlock", ABBA);
+	DO_TESTCASE_6("A-B-B-C-C-A deadlock", ABBCCA);
+	DO_TESTCASE_6("A-B-C-A-B-C deadlock", ABCABC);
+	DO_TESTCASE_6("A-B-B-C-C-D-D-A deadlock", ABBCCDDA);
+	DO_TESTCASE_6("A-B-C-D-B-D-D-A deadlock", ABCDBDDA);
+	DO_TESTCASE_6("A-B-C-D-B-C-D-A deadlock", ABCDBCDA);
 	DO_TESTCASE_6("double unlock", double_unlock);
 	DO_TESTCASE_6("initialize held", init_held);
 	DO_TESTCASE_6_SUCCESS("bad unlock order", bad_unlock_order);
Index: linux-2.6-2/include/linux/lockdep.h
===================================================================
--- linux-2.6-2.orig/include/linux/lockdep.h
+++ linux-2.6-2/include/linux/lockdep.h
@@ -291,6 +291,7 @@ extern void lockdep_init_map(struct lock
  *   0: exclusive (write) acquire
  *   1: read-acquire (no recursion allowed)
  *   2: read-acquire with same-instance recursion allowed
+ *   3: 2 + reader in writer recursion
  *
  * Values for check:
  *

> comments below
> 
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> > diff --git a/kernel/cpu.c b/kernel/cpu.c
> > index 2011ad8..119d837 100644
> > --- a/kernel/cpu.c
> > +++ b/kernel/cpu.c
> > @@ -27,12 +27,13 @@ static int cpu_hotplug_disabled;
> > 
> >  static struct {
> >  	struct task_struct *active_writer;
> > -	struct mutex lock; /* Synchronizes accesses to refcount, */
> > +	spinlock_t lock; /* Synchronizes accesses to refcount, */
> >  	/*
> >  	 * Also blocks the new readers during
> >  	 * an ongoing cpu hotplug operation.
> >  	 */
> >  	int refcount;
> > +	wait_queue_head_t reader_queue;
> >  	wait_queue_head_t writer_queue;
> >  } cpu_hotplug;
> > 
> > @@ -41,8 +42,9 @@ static struct {
> >  void __init cpu_hotplug_init(void)
> >  {
> >  	cpu_hotplug.active_writer = NULL;
> > -	mutex_init(&cpu_hotplug.lock);
> > +	spin_lock_init(&cpu_hotplug.lock);
> >  	cpu_hotplug.refcount = 0;
> > +	init_waitqueue_head(&cpu_hotplug.reader_queue);
> >  	init_waitqueue_head(&cpu_hotplug.writer_queue);
> >  }
> > 
> > @@ -51,27 +53,42 @@ void __init cpu_hotplug_init(void)
> >  void get_online_cpus(void)
> >  {
> >  	might_sleep();
> > +
> > +	spin_lock(&cpu_hotplug.lock);
> >  	if (cpu_hotplug.active_writer == current)
> > -		return;
> We don't need to perform this check holding the spinlock.
> The reason being, this check should succeed only for get_online_cpus()
> invoked from the CPU-hotplug callback path. and by that time,
> the writer thread would have set active_writer to it's task struct
> value.
> 
> For every other thread, when it's trying to check if it is the
> active_writer, the value is either NULL, or the value of the currently
> active writer's task_struct, but never current.
> 
> Am I missing something ?

I guess you're right - inside makes me feel better though :-) And its
not like its a fast path or something like that.

> > -	mutex_lock(&cpu_hotplug.lock);
> > +		goto unlock;
> > +
> > +	if (cpu_hotplug.active_writer) {
> > +		DEFINE_WAIT(wait);
> > +
> > +		for (;;) {
> > +			prepare_to_wait(&cpu_hotplug.reader_queue, &wait,
> > +					TASK_UNINTERRUPTIBLE);
> > +			if (!cpu_hotplug.active_writer)
> > +				break;
> > +			spin_unlock(&cpu_hotplug.lock);
> > +			schedule();
> > +			spin_lock(&cpu_hotplug.lock);
> > +		}
> > +		finish_wait(&cpu_hotplug.reader_queue, &wait);
> > +	}
> >  	cpu_hotplug.refcount++;
> > -	mutex_unlock(&cpu_hotplug.lock);
> > -
> > + unlock:
> > +	spin_unlock(&cpu_hotplug.lock);
> >  }
> >  EXPORT_SYMBOL_GPL(get_online_cpus);
> > 
> >  void put_online_cpus(void)
> >  {
> > +	spin_lock(&cpu_hotplug.lock);
> >  	if (cpu_hotplug.active_writer == current)
> > -		return;
> 
> ditto!
> 
> > -	mutex_lock(&cpu_hotplug.lock);
> > -	cpu_hotplug.refcount--;
> > +		goto unlock;
> > 
> > -	if (unlikely(writer_exists()) && !cpu_hotplug.refcount)
> > +	cpu_hotplug.refcount--;
> > +	if (!cpu_hotplug.refcount)
> >  		wake_up(&cpu_hotplug.writer_queue);
> 	hmm.. when there is no active writer, can't we avoid this
> 	additional wake up ??
> > -
> > -	mutex_unlock(&cpu_hotplug.lock);
> > -
> > + unlock:
> > +	spin_unlock(&cpu_hotplug.lock);
> >  }
> >  EXPORT_SYMBOL_GPL(put_online_cpus);
> > 
> > @@ -95,45 +112,41 @@ void cpu_maps_update_done(void)
> >   * This ensures that the hotplug operation can begin only when the
> >   * refcount goes to zero.
> >   *
> > - * Note that during a cpu-hotplug operation, the new readers, if any,
> > - * will be blocked by the cpu_hotplug.lock
> > - *
> > - * Since cpu_maps_update_begin is always called after invoking
> > - * cpu_maps_update_begin, we can be sure that only one writer is active.
> > - *
> > - * Note that theoretically, there is a possibility of a livelock:
> > - * - Refcount goes to zero, last reader wakes up the sleeping
> > - *   writer.
> > - * - Last reader unlocks the cpu_hotplug.lock.
> > - * - A new reader arrives at this moment, bumps up the refcount.
> > - * - The writer acquires the cpu_hotplug.lock finds the refcount
> > - *   non zero and goes to sleep again.
> > - *
> > - * However, this is very difficult to achieve in practice since
> > - * get_online_cpus() not an api which is called all that often.
> > - *
> > + * cpu_hotplug is basically an unfair recursive reader/writer lock that
> > + * allows reader in writer recursion.
> >   */
> >  static void cpu_hotplug_begin(void)
> >  {
> > -	DECLARE_WAITQUEUE(wait, current);
> > -
> > -	mutex_lock(&cpu_hotplug.lock);
> > +	might_sleep();
> > 
> > -	cpu_hotplug.active_writer = current;
> > -	add_wait_queue_exclusive(&cpu_hotplug.writer_queue, &wait);
> > -	while (cpu_hotplug.refcount) {
> > -		set_current_state(TASK_UNINTERRUPTIBLE);
> > -		mutex_unlock(&cpu_hotplug.lock);
> > -		schedule();
> > -		mutex_lock(&cpu_hotplug.lock);
> > +	spin_lock(&cpu_hotplug.lock);
> > +	if (cpu_hotplug.refcount || cpu_hotplug.active_writer) {
> 	if we reach this point, there can be only one writer, i.e.
> 	ourselves!
> 
> 	Because, the other writers are serialized by the
> 	cpu_add_remove_lock in cpu_up()/cpu_down().
> 
> 	Hence we can safely assign cpu_hotplug.active_writer to current.

Ah, missed that. Does it make sense to keep it like this, in case this
outer lock goes away?

> > +		DEFINE_WAIT(wait);
> > +
> > +		for (;;) {
> > +			prepare_to_wait(&cpu_hotplug.writer_queue, &wait,
> > +					TASK_UNINTERRUPTIBLE);
> > +			if (!cpu_hotplug.refcount && !cpu_hotplug.active_writer)
> > +				break;
> > +			spin_unlock(&cpu_hotplug.lock);
> > +			schedule();
> > +			spin_lock(&cpu_hotplug.lock);
> > +		}
> > +		finish_wait(&cpu_hotplug.writer_queue, &wait);
> >  	}
> > -	remove_wait_queue_locked(&cpu_hotplug.writer_queue, &wait);
> > +	cpu_hotplug.active_writer = current;
> 
> 
> > +	spin_unlock(&cpu_hotplug.lock);
> >  }
> > 
> >  static void cpu_hotplug_done(void)
> >  {
> > +	spin_lock(&cpu_hotplug.lock);
> >  	cpu_hotplug.active_writer = NULL;
> > -	mutex_unlock(&cpu_hotplug.lock);
> > +	if (!list_empty(&cpu_hotplug.writer_queue.task_list))
> > +		wake_up(&cpu_hotplug.writer_queue);
> > +	else
> > +		wake_up_all(&cpu_hotplug.reader_queue);
> > +	spin_unlock(&cpu_hotplug.lock);
> >  }
> >  /* Need to know about CPUs going up/down? */
> >  int __cpuinit register_cpu_notifier(struct notifier_block *nb)
> >
> 
> Looks good otherwise!

Thanks..

lockdep annotations:

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6-2/include/linux/lockdep.h
===================================================================
--- linux-2.6-2.orig/include/linux/lockdep.h
+++ linux-2.6-2/include/linux/lockdep.h
@@ -458,4 +458,19 @@ static inline void print_irqtrace_events
 # define rwsem_release(l, n, i)			do { } while (0)
 #endif
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# ifdef CONFIG_PROVE_LOCKING
+#  define cpu_hotplug_acquire(l, s, t, i)	lock_acquire(l, s, t, 0, 2,
i)
+#  define cpu_hotplug_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 3,
2, i)
+# else
+#  define cpu_hotplug_acquire(l, s, t, i)	lock_acquire(l, s, t, 0, 1,
i)
+#  define cpu_hotplug_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 3,
1, i)
+# endif
+# define cpu_hotplug_release(l, n, i)		lock_release(l, n, i)
+#else
+# define cpu_hotplug_acquire(l, s, t, i)	do { } while (0)
+# define cpu_hotplug_acquire_read(l, s, t, i)	do { } while (0)
+# define cpu_hotplug_release(l, n, i)		do { } while (0)
+#endif
+
 #endif /* __LINUX_LOCKDEP_H */
Index: linux-2.6-2/kernel/cpu.c
===================================================================
--- linux-2.6-2.orig/kernel/cpu.c
+++ linux-2.6-2/kernel/cpu.c
@@ -35,12 +35,20 @@ static struct {
 	int refcount;
 	wait_queue_head_t reader_queue;
 	wait_queue_head_t writer_queue;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	dep_map;
+#endif
 } cpu_hotplug;
 
 #define writer_exists() (cpu_hotplug.active_writer != NULL)
 
 void __init cpu_hotplug_init(void)
 {
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	static struct lockdep_class_key __key;
+
+	lockdep_init_map(&cpu_hotplug.dep_map, "cpu_hotplug", &__key, 0);
+#endif
 	cpu_hotplug.active_writer = NULL;
 	spin_lock_init(&cpu_hotplug.lock);
 	cpu_hotplug.refcount = 0;
@@ -54,6 +62,8 @@ void get_online_cpus(void)
 {
 	might_sleep();
 
+	cpu_hotplug_acquire_read(&cpu_hotplug.dep_map, 0, 0, _THIS_IP_);
+
 	spin_lock(&cpu_hotplug.lock);
 	if (cpu_hotplug.active_writer == current)
 		goto unlock;
@@ -80,6 +90,8 @@ EXPORT_SYMBOL_GPL(get_online_cpus);
 
 void put_online_cpus(void)
 {
+	cpu_hotplug_release(&cpu_hotplug.lock, 1, _THIS_IP_);
+
 	spin_lock(&cpu_hotplug.lock);
 	if (cpu_hotplug.active_writer == current)
 		goto unlock;
@@ -119,6 +131,8 @@ static void cpu_hotplug_begin(void)
 {
 	might_sleep();
 
+	cpu_hotplug_acquire(&cpu_hotplug.dep_map, 0, 0, _THIS_IP_);
+
 	spin_lock(&cpu_hotplug.lock);
 	if (cpu_hotplug.refcount || cpu_hotplug.active_writer) {
 		DEFINE_WAIT(wait);
@@ -140,6 +154,8 @@ static void cpu_hotplug_begin(void)
 
 static void cpu_hotplug_done(void)
 {
+	cpu_hotplug_release(&cpu_hotplug.lock, 1, _THIS_IP_);
+
 	spin_lock(&cpu_hotplug.lock);
 	cpu_hotplug.active_writer = NULL;
 	if (!list_empty(&cpu_hotplug.writer_queue.task_list))


