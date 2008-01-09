Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbYAIDes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbYAIDes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 22:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYAIDel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 22:34:41 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:9878 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYAIDek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 22:34:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZGkc2FaVpItFVTZzPRsk2OTTwrwHdItKPQ/f3/dprjQKscdUn/8dRJQ908T6fbKtazffYkS9s9cNe1hP4SCM5pC4pttQMKnYKIIY3oME2NWvsx7DDLjcyppawDeinux1gmTylJ1+rx6g+c86YHKx5srZz5Vafby9ceao8fv4Kzw=
Subject: [RFC] x86: Add oops_begin, oops_end to X86_32
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 19:34:41 -0800
Message-Id: <1199849681.6424.34.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some more work is needed on this patch, but I'm looking for
some feedback about the general direction.  X86_64's
implementation seems nicer and it would be useful to use
a common base for further unification in the oops handling.

Modify the X86_32 implementation of die() using helpers
oops_begin()/oops_end().  Small whitespace change in
traps_64.c for easier comparison between the two.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/traps_32.c |  137 +++++++++++++++++++++++---------------------
 arch/x86/kernel/traps_64.c |   11 +--
 2 files changed, 76 insertions(+), 72 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 5f2b38e..a4092ed 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -352,10 +352,61 @@ int is_valid_bugaddr(unsigned long ip)
 	return ud2 == 0x0b0f;
 }
 
-static int die_counter;
+static raw_spinlock_t die_lock = __RAW_SPIN_LOCK_UNLOCKED;
+static int die_owner = -1;
+static unsigned int die_nest_count;
+
+unsigned long __kprobes oops_begin(void)
+{
+	int cpu;
+	unsigned long flags;
+
+	oops_enter();
+
+	raw_local_irq_save(flags);
+	cpu = smp_processor_id();
+	/* racy, but better than risking deadlock. */
+	if (!__raw_spin_trylock(&die_lock) && cpu != die_owner) {
+		__raw_spin_lock(&die_lock);
+	}
+	die_nest_count++;
+	die_owner = cpu;
+	console_verbose();
+	bust_spinlocks(1);
+	return flags;
+}
+
+void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
+{ 
+	die_owner = -1;
+	bust_spinlocks(0);
+	die_nest_count--;
+	if (!die_nest_count)
+		/* Nest count reaches zero, release the lock. */
+		__raw_spin_unlock(&die_lock);
+	raw_local_irq_restore(flags);
+
+	if (!regs) {
+		oops_exit();
+		return;
+	}
+
+	if (kexec_should_crash(current))
+		crash_kexec(regs);
+
+	if (in_interrupt())
+		panic("Fatal exception in interrupt");
+
+	if (panic_on_oops)
+		panic("Fatal exception");
+
+	oops_exit();
+	do_exit(signr);
+}
 
 int __kprobes __die(const char * str, struct pt_regs * regs, long err)
 {
+	static int die_counter;
 	unsigned long sp;
 	unsigned short ss;
 
@@ -371,24 +422,23 @@ int __kprobes __die(const char * str, struct pt_regs * regs, long err)
 #endif
 	printk("\n");
 
-	if (notify_die(DIE_OOPS, str, regs, err,
-				current->thread.trap_no, SIGSEGV) !=
-			NOTIFY_STOP) {
-		show_registers(regs);
-		/* Executive summary in case the oops scrolled away */
-		sp = (unsigned long) (&regs->sp);
-		savesegment(ss, ss);
-		if (user_mode(regs)) {
-			sp = regs->sp;
-			ss = regs->ss & 0xffff;
-		}
-		printk(KERN_EMERG "EIP: [<%08lx>] ", regs->ip);
-		print_symbol("%s", regs->ip);
-		printk(" SS:ESP %04x:%08lx\n", ss, sp);
-		return 0;
-	} else {
+	if (notify_die(DIE_OOPS, str, regs, err, current->thread.trap_no,
+	    SIGSEGV) == NOTIFY_STOP)
 		return 1;
+
+	show_registers(regs);
+	add_taint(TAINT_DIE);
+	/* Executive summary in case the oops scrolled away */
+	sp = (unsigned long) (&regs->sp);
+	savesegment(ss, ss);
+	if (user_mode(regs)) {
+		sp = regs->sp;
+		ss = regs->ss & 0xffff;
 	}
+	printk(KERN_EMERG "EIP: [<%08lx>] ", regs->ip);
+	print_symbol("%s", regs->ip);
+	printk(" SS:ESP %04x:%08lx\n", ss, sp);
+	return 0;
 }
 
 /*
@@ -397,58 +447,15 @@ int __kprobes __die(const char * str, struct pt_regs * regs, long err)
  */
 void die(const char * str, struct pt_regs * regs, long err)
 {
-	static struct {
-		raw_spinlock_t lock;
-		u32 lock_owner;
-		int lock_owner_depth;
-	} die = {
-		.lock =			__RAW_SPIN_LOCK_UNLOCKED,
-		.lock_owner =		-1,
-		.lock_owner_depth =	0
-	};
-	unsigned long flags;
+	unsigned long flags = oops_begin();
 
-	oops_enter();
-
-	if (die.lock_owner != raw_smp_processor_id()) {
-		console_verbose();
-		raw_local_irq_save(flags);
-		__raw_spin_lock(&die.lock);
-		die.lock_owner = smp_processor_id();
-		die.lock_owner_depth = 0;
-		bust_spinlocks(1);
-	} else
-		raw_local_irq_save(flags);
-
-	if (++die.lock_owner_depth < 3) {
+	if (!user_mode(regs))
 		report_bug(regs->ip, regs);
 
-		if (__die(str, regs, err))
-			regs = NULL;
-	} else {
-		printk(KERN_EMERG "Recursive die() failure, output suppressed\n");
-	}
+	if (__die(str, regs, err))
+		regs = NULL;
 
-	bust_spinlocks(0);
-	die.lock_owner = -1;
-	add_taint(TAINT_DIE);
-	__raw_spin_unlock(&die.lock);
-	raw_local_irq_restore(flags);
-
-	if (!regs)
-		return;
-
-	if (kexec_should_crash(current))
-		crash_kexec(regs);
-
-	if (in_interrupt())
-		panic("Fatal exception in interrupt");
-
-	if (panic_on_oops)
-		panic("Fatal exception");
-
-	oops_exit();
-	do_exit(SIGSEGV);
+	oops_end(flags, regs, SIGSEGV);
 }
 
 static inline void die_if_kernel(const char * str, struct pt_regs * regs, long err)
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index c173687..c50549e 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -465,21 +465,18 @@ static raw_spinlock_t die_lock = __RAW_SPIN_LOCK_UNLOCKED;
 static int die_owner = -1;
 static unsigned int die_nest_count;
 
-unsigned __kprobes long oops_begin(void)
+unsigned long __kprobes oops_begin(void)
 {
 	int cpu;
 	unsigned long flags;
 
 	oops_enter();
 
-	/* racy, but better than risking deadlock. */
 	raw_local_irq_save(flags);
 	cpu = smp_processor_id();
-	if (!__raw_spin_trylock(&die_lock)) {
-		if (cpu == die_owner) 
-			/* nested oops. should stop eventually */;
-		else
-			__raw_spin_lock(&die_lock);
+	/* racy, but better than risking deadlock. */
+	if (!__raw_spin_trylock(&die_lock) && cpu != die_owner) {
+		__raw_spin_lock(&die_lock);
 	}
 	die_nest_count++;
 	die_owner = cpu;
-- 
1.5.4.rc2.1164.g6451

