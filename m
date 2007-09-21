Return-Path: <linux-kernel-owner+w=401wt.eu-S932968AbXIUWqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbXIUWqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763864AbXIUWcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:43 -0400
Received: from ns2.suse.de ([195.135.220.15]:40501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763964AbXIUWch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:37 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [36/50] x86: Use raw locks during oopses
Message-Id: <20070921223236.26E361479D@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Don't want any lockdep or other fragile machinery to run during oopses.
Use raw spinlocks directly for oops locking.
Also disables irq flag tracing there.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/traps.c   |   12 +++++++-----
 arch/x86_64/kernel/traps.c |   17 ++++++++---------
 2 files changed, 15 insertions(+), 14 deletions(-)

Index: linux/arch/i386/kernel/traps.c
===================================================================
--- linux.orig/arch/i386/kernel/traps.c
+++ linux/arch/i386/kernel/traps.c
@@ -447,11 +447,11 @@ void ler_enable(void) {
 void die(const char * str, struct pt_regs * regs, long err)
 {
 	static struct {
-		spinlock_t lock;
+		raw_spinlock_t lock;
 		u32 lock_owner;
 		int lock_owner_depth;
 	} die = {
-		.lock =			__SPIN_LOCK_UNLOCKED(die.lock),
+		.lock =			__RAW_SPIN_LOCK_UNLOCKED,
 		.lock_owner =		-1,
 		.lock_owner_depth =	0
 	};
@@ -462,13 +462,14 @@ void die(const char * str, struct pt_reg
 
 	if (die.lock_owner != raw_smp_processor_id()) {
 		console_verbose();
-		spin_lock_irqsave(&die.lock, flags);
+		__raw_spin_lock(&die.lock);
+		raw_local_save_flags(flags);
 		die.lock_owner = smp_processor_id();
 		die.lock_owner_depth = 0;
 		bust_spinlocks(1);
 	}
 	else
-		local_save_flags(flags);
+		raw_local_save_flags(flags);
 
 	if (++die.lock_owner_depth < 3) {
 		unsigned long esp;
@@ -511,7 +512,8 @@ void die(const char * str, struct pt_reg
 	bust_spinlocks(0);
 	die.lock_owner = -1;
 	add_taint(TAINT_DIE);
-	spin_unlock_irqrestore(&die.lock, flags);
+	__raw_spin_unlock(&die.lock);
+	raw_local_irq_restore(flags);
 
 	if (!regs)
 		return;
Index: linux/arch/x86_64/kernel/traps.c
===================================================================
--- linux.orig/arch/x86_64/kernel/traps.c
+++ linux/arch/x86_64/kernel/traps.c
@@ -556,7 +556,7 @@ void ler_enable(void) {
 	}
 }
 
-static DEFINE_SPINLOCK(die_lock);
+static raw_spinlock_t die_lock = __RAW_SPIN_LOCK_UNLOCKED;
 static int die_owner = -1;
 static unsigned int die_nest_count;
 
@@ -568,13 +568,13 @@ unsigned __kprobes long oops_begin(void)
 	oops_enter();
 
 	/* racy, but better than risking deadlock. */
-	local_irq_save(flags);
+	raw_local_irq_save(flags);
 	cpu = smp_processor_id();
-	if (!spin_trylock(&die_lock)) { 
+	if (!__raw_spin_trylock(&die_lock)) {
 		if (cpu == die_owner) 
 			/* nested oops. should stop eventually */;
 		else
-			spin_lock(&die_lock);
+			__raw_spin_lock(&die_lock);
 	}
 	die_nest_count++;
 	die_owner = cpu;
@@ -588,12 +588,11 @@ void __kprobes oops_end(unsigned long fl
 	die_owner = -1;
 	bust_spinlocks(0);
 	die_nest_count--;
-	if (die_nest_count)
-		/* We still own the lock */
-		local_irq_restore(flags);
-	else
+	if (!die_nest_count) {
 		/* Nest count reaches zero, release the lock. */
-		spin_unlock_irqrestore(&die_lock, flags);
+		__raw_spin_unlock(&die_lock);
+	}
+	raw_local_irq_restore(flags);
 	if (!regs) {
 		oops_exit();
 		return;
