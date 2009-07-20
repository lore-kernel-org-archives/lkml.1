Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbZGTIsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbZGTIsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 04:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZGTIsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 04:48:30 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:59571 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbZGTIs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 04:48:29 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [tip:sched/core] sched: Pull up the might_sleep() check into
 cond_resched()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090720081210.GA5309@nowhere>
References: <1247725694-6082-6-git-send-email-fweisbec@gmail.com>
	 <tip-613afbf83298efaead05ebcac23d2285609d7160@git.kernel.org>
	 <4A6413AB.2050807@cn.fujitsu.com>  <20090720081210.GA5309@nowhere>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 10:49:07 +0200
Message-Id: <1248079747.15751.8202.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 04:12 -0400, Frederic Weisbecker wrote:

> From: Frederic Weisbecker <fweisbec@gmail.com>
> Subject: [PATCH] sched: Check if the spinlock is locked in cond_resched_lock()
> 
> Some uses of cond_resched_lock() might involve an
> unlocked spinlock, resulting in spurious sleep in
> atomic warnings.
> Check whether the spinlock is actually locked and
> take that into account in the might_sleep() check.
> 
> Reported-by: Li Zefan <lizf@cn.fujitsu.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index cb070dc..2789658 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2294,9 +2294,10 @@ extern int _cond_resched(void);
>  
>  extern int __cond_resched_lock(spinlock_t *lock);
>  
> -#define cond_resched_lock(lock) ({				\
> -	__might_sleep(__FILE__, __LINE__, PREEMPT_OFFSET);	\
> -	__cond_resched_lock(lock);				\
> +#define cond_resched_lock(lock) ({				  \
> +	__might_sleep(__FILE__, __LINE__, spin_is_locked(lock) ?  \
> +					  PREEMPT_OFFSET : 0);	  \
> +	__cond_resched_lock(lock);				  \
>  })
>  
>  extern int __cond_resched_softirq(void);


No, this looks utterly broken.. who is to say it doesn't get unlocked
right after that spin_is_locked() check?

cond_resched_lock() callers must hold the lock they use it on, not doing
so is broken.

So I would suggest something like the below instead:

(utterly untested)

Almost-signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h |    8 ++++++++
 kernel/lockdep.c        |   33 +++++++++++++++++++++++++++++++++
 kernel/sched.c          |    2 ++
 3 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 12aabfc..920df42 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -296,6 +296,10 @@ extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 extern void lock_release(struct lockdep_map *lock, int nested,
 			 unsigned long ip);
 
+#define lockdep_is_held(lock)	lock_is_held(&(lock)->dep_map)
+
+extern int lock_is_held(struct lockdep_map *lock);
+
 extern void lock_set_class(struct lockdep_map *lock, const char *name,
 			   struct lock_class_key *key, unsigned int subclass,
 			   unsigned long ip);
@@ -314,6 +318,8 @@ extern void lockdep_trace_alloc(gfp_t mask);
 
 #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
 
+#define lockdep_assert_held(l)	WARN_ON(!lockdep_is_held(l))
+
 #else /* !LOCKDEP */
 
 static inline void lockdep_off(void)
@@ -358,6 +364,8 @@ struct lock_class_key { };
 
 #define lockdep_depth(tsk)	(0)
 
+#define lockdep_assert_held(l)			do { } while (0)
+
 #endif /* !LOCKDEP */
 
 #ifdef CONFIG_LOCK_STAT
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 3718a98..fd626ea 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3044,6 +3044,19 @@ __lock_release(struct lockdep_map *lock, int nested, unsigned long ip)
 	check_chain_key(curr);
 }
 
+static int __lock_is_held(struct lockdep_map *lock)
+{
+	struct task_struct *curr = current;
+	int i;
+
+	for (i = 0; i < curr->lockdep_depth; i++) {
+		if (curr->held_locks[i].instance == lock)
+			return 1;
+	}
+
+	return 0;
+}
+
 /*
  * Check whether we follow the irq-flags state precisely:
  */
@@ -3145,6 +3158,26 @@ void lock_release(struct lockdep_map *lock, int nested,
 }
 EXPORT_SYMBOL_GPL(lock_release);
 
+int lock_is_held(struct lockdep_map *lock)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	if (unlikely(current->lockdep_recursion))
+		return;
+
+	raw_local_irq_save(flags);
+	check_flags(flags);
+
+	current->lockdep_recursion = 1;
+	ret = __lock_is_held(lock);
+	current->lockdep_recursion = 0;
+	raw_local_irq_restore(flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lock_is_held);
+
 void lockdep_set_current_reclaim_state(gfp_t gfp_mask)
 {
 	current->lockdep_reclaim_gfp = gfp_mask;
diff --git a/kernel/sched.c b/kernel/sched.c
index 56fb225..6255f82 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6638,6 +6638,8 @@ int __cond_resched_lock(spinlock_t *lock)
 	int resched = should_resched();
 	int ret = 0;
 
+	lockdep_assert_held(lock);
+
 	if (spin_needbreak(lock) || resched) {
 		spin_unlock(lock);
 		if (resched)


