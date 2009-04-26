Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZDZRKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZDZRKt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 13:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZDZRKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 13:10:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41384 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbZDZRKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 13:10:39 -0400
Date: Sun, 26 Apr 2009 19:10:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core fixes
Message-ID: <20090426171026.GA18520@elte.hu>
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

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      locking: clarify kernel-taint warning message

Peter Zijlstra (1):
      lockdep: more robust lockdep_map init sequence

Steven Rostedt (1):
      lockdep, x86: account for irqs enabled in paranoid_exit


 arch/x86/kernel/entry_64.S |    3 +++
 kernel/lockdep.c           |   22 ++++++++++++++--------
 kernel/panic.c             |    2 +-
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index a331ec3..38946c6 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1410,7 +1410,10 @@ ENTRY(paranoid_exit)
 paranoid_swapgs:
 	TRACE_IRQS_IRETQ 0
 	SWAPGS_UNSAFE_STACK
+	RESTORE_ALL 8
+	jmp irq_return
 paranoid_restore:
+	TRACE_IRQS_IRETQ 0
 	RESTORE_ALL 8
 	jmp irq_return
 paranoid_userspace:
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index b0f0118..accb40c 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2490,13 +2490,20 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 void lockdep_init_map(struct lockdep_map *lock, const char *name,
 		      struct lock_class_key *key, int subclass)
 {
-	if (unlikely(!debug_locks))
+	lock->class_cache = NULL;
+#ifdef CONFIG_LOCK_STAT
+	lock->cpu = raw_smp_processor_id();
+#endif
+
+	if (DEBUG_LOCKS_WARN_ON(!name)) {
+		lock->name = "NULL";
 		return;
+	}
+
+	lock->name = name;
 
 	if (DEBUG_LOCKS_WARN_ON(!key))
 		return;
-	if (DEBUG_LOCKS_WARN_ON(!name))
-		return;
 	/*
 	 * Sanity check, the lock-class key must be persistent:
 	 */
@@ -2505,12 +2512,11 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 		DEBUG_LOCKS_WARN_ON(1);
 		return;
 	}
-	lock->name = name;
 	lock->key = key;
-	lock->class_cache = NULL;
-#ifdef CONFIG_LOCK_STAT
-	lock->cpu = raw_smp_processor_id();
-#endif
+
+	if (unlikely(!debug_locks))
+		return;
+
 	if (subclass)
 		register_lock_class(lock, subclass, 1);
 }
diff --git a/kernel/panic.c b/kernel/panic.c
index 934fb37..3dcaa16 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -221,7 +221,7 @@ void add_taint(unsigned flag)
 	 * post-warning case.
 	 */
 	if (flag != TAINT_CRAP && flag != TAINT_WARN && __debug_locks_off())
-		printk(KERN_WARNING "Disabling lockdep due to kernel taint\n");
+		printk(KERN_WARNING "Disabling lock debugging due to kernel taint\n");
 
 	set_bit(flag, &tainted_mask);
 }
