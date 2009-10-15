Return-Path: <linux-kernel-owner+w=401wt.eu-S934802AbZJOG7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934802AbZJOG7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 02:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbZJOG7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 02:59:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662AbZJOG7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 02:59:16 -0400
Date: Thu, 15 Oct 2009 08:58:39 +0200
From: Nick Piggin <npiggin@suse.de>
To: linux-arch@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: [rfc][patch 4a/6] brlock: "fast" brlocks
Message-ID: <20091015065839.GA4262@wotan.suse.de>
References: <20091015044026.319860788@suse.de> <20091015050048.777261867@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015050048.777261867@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Not for merge. Stop reading if you're not interested in locking minutiae.]

OK, this is untested but I think the theory is right. Basically it is taking
the idea from Dave M's cool brlock optimisation stuff with one further
optimisation in that the read locker does not check the spinlock but
rather we keep another wlocked variable together inthe same cacheline per
CPU, so the read locker only has to touch one cacheline rather than 2.

This actually will reduce the number of atomics by 2 per path lookup,
however we have an smp_mb() there now which is really nasty on some
architectures (like ia64 and ppc64), and not that nice on x86 either.
We can probably do something interesting on ia64 and ppc64 so that we
take advantage of the fact rlocked and wlocked are in the same cacheline
so cache coherency (rather than memory consistency) should always provide
a strict ordering there. We still do need an acquire barrier -- but it is
a much nicer lwsync or st.acq on ppc and ia64.

But: is the avoidance of the atomic RMW a big win? On x86 cores I've tested
IIRC mfence is about as costly as a locked instruction which includes the
mfence...

So long story short: it might be a small win but it is going to be very
arch specific and will require arch specific code to do the barriers and
things. The generic spinlock brlock isn't bad at all, so I'll just post
this as a curiosity for the time being.
 
---
 include/linux/brlock.h |   97 +++++++++++++++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 34 deletions(-)

Index: linux-2.6/include/linux/brlock.h
===================================================================
--- linux-2.6.orig/include/linux/brlock.h
+++ linux-2.6/include/linux/brlock.h
@@ -13,37 +13,45 @@
 #include <asm/atomic.h>
 
 #if defined(CONFIG_SMP) && !defined(CONFIG_LOCKDEP)
+
+struct brlock_node {
+	unsigned int rlocked;
+	unsigned int wlocked;
+};
+
 #define DECLARE_BRLOCK(name)						\
- DECLARE_PER_CPU(spinlock_t, name##_lock);				\
- static inline void name##_lock_init(void) {				\
-	int i;								\
-	for_each_possible_cpu(i) {					\
-		spinlock_t *lock;					\
-		lock = &per_cpu(name##_lock, i);			\
-		spin_lock_init(lock);					\
-	}								\
- }									\
+ DECLARE_PER_CPU_ALIGNED(struct brlock_node, name##_lock);		\
  static inline void name##_rlock(void) {				\
-	spinlock_t *lock;						\
-	lock = &get_cpu_var(name##_lock);				\
-	spin_lock(lock);						\
+	struct brlock_node *n;						\
+	n = &get_cpu_var(name##_lock);					\
+again:									\
+	n->rlocked++;							\
+	smp_mb(); /* ensure rlocked store before wlocked load */	\
+	if (unlikely(n->wlocked)) {					\
+		n->rlocked--;						\
+		while (n->wlocked)					\
+			cpu_relax();					\
+		goto again;						\
+	}								\
+	/* smp_mb() above also prevents crit stores leaking up */	\
  }									\
  static inline void name##_runlock(void) {				\
-	spinlock_t *lock;						\
-	lock = &__get_cpu_var(name##_lock);				\
-	spin_unlock(lock);						\
+	struct brlock_node *n;						\
+	smp_wmb(); /* prevent crit stores leaking out (XXX: should really be a release barrier because some architectures might leak crit loads out past the store, but I want to test x86 performance here) */				\
+	n = &__get_cpu_var(name##_lock);				\
+	n->rlocked--;							\
 	put_cpu_var(name##_lock);					\
  }									\
  extern void name##_wlock(void);					\
  extern void name##_wunlock(void);					\
  static inline int name##_atomic_dec_and_rlock(atomic_t *a) {		\
-	int ret;							\
-	spinlock_t *lock;						\
-	lock = &get_cpu_var(name##_lock);				\
-	ret = atomic_dec_and_lock(a, lock);				\
-	if (!ret)							\
-		put_cpu_var(name##_lock);				\
-	return ret;							\
+	if (likely(atomic_add_unless(a, -1, 1)))			\
+		return 0;						\
+	name##_rlock();							\
+	if (atomic_dec_and_test(a))					\
+		return 1;						\
+	name##_runlock();						\
+	return 0;							\
  }									\
  extern int name##_atomic_dec_and_wlock__failed(atomic_t *a);		\
  static inline int name##_atomic_dec_and_wlock(atomic_t *a) {		\
@@ -53,30 +61,51 @@
  }
 
 #define DEFINE_BRLOCK(name)						\
- DEFINE_PER_CPU(spinlock_t, name##_lock);				\
+ DEFINE_PER_CPU_ALIGNED(struct brlock_node, name##_lock);		\
+ static DEFINE_SPINLOCK(name##_wlock_lock);				\
+ static void name##_lock_init(void) {					\
+	int i;								\
+	for_each_possible_cpu(i) {					\
+		struct brlock_node *n;					\
+		n = &per_cpu(name##_lock, i);				\
+		n->rlocked = 0;						\
+		n->wlocked = 0;						\
+	}								\
+	spin_lock_init(&name##_wlock_lock);				\
+ }									\
  void name##_wlock(void) {						\
 	int i;								\
+	spin_lock(&name##_wlock_lock);					\
 	for_each_online_cpu(i) {					\
-		spinlock_t *lock;					\
-		lock = &per_cpu(name##_lock, i);			\
-		spin_lock(lock);					\
+		struct brlock_node *n;					\
+		n = &per_cpu(name##_lock, i);				\
+		n->wlocked = 1;						\
 	}								\
+	smp_mb(); /* ensure wlocked store before rlocked load */	\
+	for_each_online_cpu(i) {					\
+		struct brlock_node *n;					\
+		n = &per_cpu(name##_lock, i);				\
+		while (n->rlocked)					\
+			cpu_relax();					\
+	}								\
+	smp_mb(); /* prevent crit ops leaking above rlocked check */	\
  }									\
  void name##_wunlock(void) {						\
 	int i;								\
+	smp_mb(); /* prevent crit ops leaking past wlocked = 0 */	\
 	for_each_online_cpu(i) {					\
-		spinlock_t *lock;					\
-		lock = &per_cpu(name##_lock, i);			\
-		spin_unlock(lock);					\
+		struct brlock_node *n;					\
+		n = &per_cpu(name##_lock, i);				\
+		n->wlocked = 0;						\
 	}								\
+	spin_unlock(&name##_wlock_lock);				\
  }									\
  int name##_atomic_dec_and_wlock__failed(atomic_t *a) {			\
 	name##_wlock();							\
-	if (!atomic_dec_and_test(a)) {					\
-		name##_wunlock();					\
-		return 0;						\
-	}								\
-	return 1;							\
+	if (atomic_dec_and_test(a))					\
+		return 1;						\
+	name##_wunlock();						\
+	return 0;							\
  }
 
 #else
