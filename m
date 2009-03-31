Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbZCaMEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbZCaMEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 08:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZCaMEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 08:04:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57976 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbZCaMEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 08:04:43 -0400
Date: Tue, 31 Mar 2009 14:04:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] locking updates for v2.6.30, phase #2
Message-ID: <20090331120421.GA22148@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git locking-for-linus

No known regressions.

 Thanks,

	Ingo

------------------>
David Rientjes (1):
      lockdep: remove duplicate CONFIG_DEBUG_LOCKDEP definitions

Ingo Molnar (1):
      locking: rename trace_softirq_[enter|exit] => lockdep_softirq_[enter|exit]

Peter Zijlstra (3):
      lockdep: fix incorrect state name
      lockdep: remove extra "irq" string
      lockdep: require framepointers for x86


 include/linux/irqflags.h |    8 ++++----
 kernel/lockdep.c         |   16 +++++-----------
 kernel/softirq.c         |    4 ++--
 lib/locking-selftest.c   |    4 ++--
 4 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
index 74bde13..b02a3f1 100644
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -24,8 +24,8 @@
 # define trace_softirqs_enabled(p)	((p)->softirqs_enabled)
 # define trace_hardirq_enter()	do { current->hardirq_context++; } while (0)
 # define trace_hardirq_exit()	do { current->hardirq_context--; } while (0)
-# define trace_softirq_enter()	do { current->softirq_context++; } while (0)
-# define trace_softirq_exit()	do { current->softirq_context--; } while (0)
+# define lockdep_softirq_enter()	do { current->softirq_context++; } while (0)
+# define lockdep_softirq_exit()	do { current->softirq_context--; } while (0)
 # define INIT_TRACE_IRQFLAGS	.softirqs_enabled = 1,
 #else
 # define trace_hardirqs_on()		do { } while (0)
@@ -38,8 +38,8 @@
 # define trace_softirqs_enabled(p)	0
 # define trace_hardirq_enter()		do { } while (0)
 # define trace_hardirq_exit()		do { } while (0)
-# define trace_softirq_enter()		do { } while (0)
-# define trace_softirq_exit()		do { } while (0)
+# define lockdep_softirq_enter()	do { } while (0)
+# define lockdep_softirq_exit()		do { } while (0)
 # define INIT_TRACE_IRQFLAGS
 #endif
 
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 3673a3f..981cd48 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -433,13 +433,6 @@ atomic_t nr_find_usage_forwards_checks;
 atomic_t nr_find_usage_forwards_recursions;
 atomic_t nr_find_usage_backwards_checks;
 atomic_t nr_find_usage_backwards_recursions;
-# define debug_atomic_inc(ptr)		atomic_inc(ptr)
-# define debug_atomic_dec(ptr)		atomic_dec(ptr)
-# define debug_atomic_read(ptr)		atomic_read(ptr)
-#else
-# define debug_atomic_inc(ptr)		do { } while (0)
-# define debug_atomic_dec(ptr)		do { } while (0)
-# define debug_atomic_read(ptr)		0
 #endif
 
 /*
@@ -1900,9 +1893,9 @@ print_irq_inversion_bug(struct task_struct *curr, struct lock_class *other,
 		curr->comm, task_pid_nr(curr));
 	print_lock(this);
 	if (forwards)
-		printk("but this lock took another, %s-irq-unsafe lock in the past:\n", irqclass);
+		printk("but this lock took another, %s-unsafe lock in the past:\n", irqclass);
 	else
-		printk("but this lock was taken by another, %s-irq-safe lock in the past:\n", irqclass);
+		printk("but this lock was taken by another, %s-safe lock in the past:\n", irqclass);
 	print_lock_name(other);
 	printk("\n\nand interrupts could create inverse lock ordering between them.\n\n");
 
@@ -2015,7 +2008,8 @@ typedef int (*check_usage_f)(struct task_struct *, struct held_lock *,
 			     enum lock_usage_bit bit, const char *name);
 
 static int
-mark_lock_irq(struct task_struct *curr, struct held_lock *this, int new_bit)
+mark_lock_irq(struct task_struct *curr, struct held_lock *this,
+		enum lock_usage_bit new_bit)
 {
 	int excl_bit = exclusive_bit(new_bit);
 	int read = new_bit & 1;
@@ -2043,7 +2037,7 @@ mark_lock_irq(struct task_struct *curr, struct held_lock *this, int new_bit)
 	 * states.
 	 */
 	if ((!read || !dir || STRICT_READ_CHECKS) &&
-			!usage(curr, this, excl_bit, state_name(new_bit)))
+			!usage(curr, this, excl_bit, state_name(new_bit & ~1)))
 		return 0;
 
 	/*
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 57d3f67..4877516 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -180,7 +180,7 @@ asmlinkage void __do_softirq(void)
 	account_system_vtime(current);
 
 	__local_bh_disable((unsigned long)__builtin_return_address(0));
-	trace_softirq_enter();
+	lockdep_softirq_enter();
 
 	cpu = smp_processor_id();
 restart:
@@ -220,7 +220,7 @@ restart:
 	if (pending)
 		wakeup_softirqd();
 
-	trace_softirq_exit();
+	lockdep_softirq_exit();
 
 	account_system_vtime(current);
 	_local_bh_enable();
diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 280332c..619313e 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -157,11 +157,11 @@ static void init_shared_classes(void)
 #define SOFTIRQ_ENTER()				\
 		local_bh_disable();		\
 		local_irq_disable();		\
-		trace_softirq_enter();		\
+		lockdep_softirq_enter();	\
 		WARN_ON(!in_softirq());
 
 #define SOFTIRQ_EXIT()				\
-		trace_softirq_exit();		\
+		lockdep_softirq_exit();		\
 		local_irq_enable();		\
 		local_bh_enable();
 
