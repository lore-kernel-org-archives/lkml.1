Return-Path: <linux-kernel-owner+w=401wt.eu-S1760641AbYGJTSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760641AbYGJTSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYGJTSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:18:06 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:8681 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbYGJTSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:18:04 -0400
Date: Thu, 10 Jul 2008 21:14:52 +0200
From: Alexander van Heukelum <heukelum@sleipnir.lusi.uni-sb.de>
To: Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] x86: traps_xx: refactor die() like in x86_64
Message-ID: <20080710191452.GA19475@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Thu, 10 Jul 2008 21:17:16 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.0.64; VDF: 7.0.5.95; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the diff between the traps_32.c and traps_64.c a bit smaller.

Change traps_32.c to look more like traps_64.c:
 - move lock information to file scope
 - split out oops_begin() and oops_end() from die()
 - increment nest counter in oops_begin

Only whitespace change in traps_64.c

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |   95 +++++++++++++++++++++++--------------------
 arch/x86/kernel/traps_64.c |    2 +-
 2 files changed, 52 insertions(+), 45 deletions(-)

Still, no functional changes intended.

Cyrill Acked "x86: traps_xx: modify default_do_nmi" of my first
series. I'm not quite sure if he intended that for the whole set.
I welcome him to look at these too patches, though ;).

Created on top of tip/core

Greetings,
    Alexander

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 8a76897..51cccde 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -383,6 +383,54 @@ int is_valid_bugaddr(unsigned long ip)
 	return ud2 == 0x0b0f;
 }
 
+static raw_spinlock_t die_lock = __RAW_SPIN_LOCK_UNLOCKED;
+static int die_owner = -1;
+static unsigned int die_nest_count;
+
+unsigned __kprobes long oops_begin(void)
+{
+	unsigned long flags;
+
+	oops_enter();
+
+	if (die_owner != raw_smp_processor_id()) {
+		console_verbose();
+		raw_local_irq_save(flags);
+		__raw_spin_lock(&die_lock);
+		die_owner = smp_processor_id();
+		die_nest_count = 0;
+		bust_spinlocks(1);
+	} else {
+		raw_local_irq_save(flags);
+	}
+	die_nest_count++;
+	return flags;
+}
+
+void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
+{
+	bust_spinlocks(0);
+	die_owner = -1;
+	add_taint(TAINT_DIE);
+	__raw_spin_unlock(&die_lock);
+	raw_local_irq_restore(flags);
+
+	if (!regs)
+		return;
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
+
 int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 {
 	unsigned short ss;
@@ -423,31 +471,9 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
  */
 void die(const char *str, struct pt_regs *regs, long err)
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
-
-	oops_enter();
-
-	if (die.lock_owner != raw_smp_processor_id()) {
-		console_verbose();
-		raw_local_irq_save(flags);
-		__raw_spin_lock(&die.lock);
-		die.lock_owner = smp_processor_id();
-		die.lock_owner_depth = 0;
-		bust_spinlocks(1);
-	} else {
-		raw_local_irq_save(flags);
-	}
+	unsigned long flags = oops_begin();
 
-	if (++die.lock_owner_depth < 3) {
+	if (die_nest_count < 3) {
 		report_bug(regs->ip, regs);
 
 		if (__die(str, regs, err))
@@ -456,26 +482,7 @@ void die(const char *str, struct pt_regs *regs, long err)
 		printk(KERN_EMERG "Recursive die() failure, output suppressed\n");
 	}
 
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
 
 static inline void
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 74e9929..58b1619 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -541,7 +541,7 @@ unsigned __kprobes long oops_begin(void)
 }
 
 void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
-{ 
+{
 	die_owner = -1;
 	bust_spinlocks(0);
 	die_nest_count--;
-- 
1.5.4.3

