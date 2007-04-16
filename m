Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbXDPKSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbXDPKSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 06:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030360AbXDPKSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 06:18:53 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:34527 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030325AbXDPKSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 06:18:34 -0400
Message-ID: <46234E9E.6080107@sw.ru>
Date: Mon, 16 Apr 2007 14:23:26 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
CC: devel@openvz.org
Subject: [PATCH] Report that kernel is tainted if there were an OOPS before
Content-Type: multipart/mixed;
 boundary="------------050907060909040107060603"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050907060909040107060603
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

If the kernel OOPS-ed or BUG-ed then it probably should
considered as tainted. Use die_counter introduced by many
architectures to determine whether or not the kernel died.

This saves a lot of time explaining oddities in the
calltrace seen via SysRq-P.

--------------050907060909040107060603
Content-Type: text/plain;
 name="diff-show-tainted-show-kernel-died-once"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff-show-tainted-show-kernel-died-once"

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index b3ffba1..764526c 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -207,7 +207,6 @@ void show_stack(struct task_struct *tsk,
 static void __die(const char *str, int err, struct thread_info *thread, struct pt_regs *regs)
 {
 	struct task_struct *tsk = thread->task;
-	static int die_counter;
 
 	printk("Internal error: %s: %x [#%d]\n", str, err, ++die_counter);
 	print_modules();
diff --git a/arch/avr32/kernel/traps.c b/arch/avr32/kernel/traps.c
index c8b7153..0829ebc 100644
--- a/arch/avr32/kernel/traps.c
+++ b/arch/avr32/kernel/traps.c
@@ -156,8 +156,6 @@ static DEFINE_SPINLOCK(die_lock);
 
 void NORET_TYPE die(const char *str, struct pt_regs *regs, long err)
 {
-	static int die_counter;
-
 	console_verbose();
 	spin_lock_irq(&die_lock);
 	bust_spinlocks(1);
diff --git a/arch/i386/kernel/traps.c b/arch/i386/kernel/traps.c
index 35d1c38..8531901 100644
--- a/arch/i386/kernel/traps.c
+++ b/arch/i386/kernel/traps.c
@@ -438,7 +438,6 @@ void die(const char * str, struct pt_reg
 		.lock_owner =		-1,
 		.lock_owner_depth =	0
 	};
-	static int die_counter;
 	unsigned long flags;
 
 	oops_enter();
diff --git a/arch/ia64/kernel/traps.c b/arch/ia64/kernel/traps.c
index 5bfb8be..7a1e8d8 100644
--- a/arch/ia64/kernel/traps.c
+++ b/arch/ia64/kernel/traps.c
@@ -47,7 +47,6 @@ die (const char *str, struct pt_regs *re
 		.lock_owner =		-1,
 		.lock_owner_depth =	0
 	};
-	static int die_counter;
 	int cpu = get_cpu();
 
 	if (die.lock_owner != cpu) {
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 27c53f1..2c65120 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -312,7 +312,6 @@ static DEFINE_SPINLOCK(die_lock);
 
 NORET_TYPE void ATTRIB_NORET die(const char * str, struct pt_regs * regs)
 {
-	static int die_counter;
 #ifdef CONFIG_MIPS_MT_SMTC
 	unsigned long dvpret = dvpe();
 #endif /* CONFIG_MIPS_MT_SMTC */
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index bf6445a..13bc4c7 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -105,7 +105,6 @@ int die(const char *str, struct pt_regs 
 		.lock_owner =		-1,
 		.lock_owner_depth =	0
 	};
-	static int die_counter;
 	unsigned long flags;
 
 	if (debugger(regs))
diff --git a/arch/ppc/kernel/traps.c b/arch/ppc/kernel/traps.c
index 810f7aa..3a058fb 100644
--- a/arch/ppc/kernel/traps.c
+++ b/arch/ppc/kernel/traps.c
@@ -76,7 +76,6 @@ DEFINE_SPINLOCK(die_lock);
 
 int die(const char * str, struct pt_regs * fp, long err)
 {
-	static int die_counter;
 	int nl = 0;
 	console_verbose();
 	spin_lock_irq(&die_lock);
diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index 90ca82b..659f41c 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -251,8 +251,6 @@ static DEFINE_SPINLOCK(die_lock);
 
 void die(const char * str, struct pt_regs * regs, long err)
 {
-	static int die_counter;
-
 	debug_stop_all();
 	console_verbose();
 	spin_lock_irq(&die_lock);
diff --git a/arch/sh/kernel/traps.c b/arch/sh/kernel/traps.c
index e9f168f..38ae9de 100644
--- a/arch/sh/kernel/traps.c
+++ b/arch/sh/kernel/traps.c
@@ -78,8 +78,6 @@ DEFINE_SPINLOCK(die_lock);
 
 void die(const char * str, struct pt_regs * regs, long err)
 {
-	static int die_counter;
-
 	console_verbose();
 	spin_lock_irq(&die_lock);
 	bust_spinlocks(1);
diff --git a/arch/sparc/kernel/traps.c b/arch/sparc/kernel/traps.c
index dc9ffea..b9b4ddd 100644
--- a/arch/sparc/kernel/traps.c
+++ b/arch/sparc/kernel/traps.c
@@ -89,7 +89,6 @@ void instruction_dump (unsigned long *pc
 
 void die_if_kernel(char *str, struct pt_regs *regs)
 {
-	static int die_counter;
 	int count = 0;
 
 	/* Amuse the user. */
diff --git a/arch/sparc64/kernel/traps.c b/arch/sparc64/kernel/traps.c
index dc652f2..556189b 100644
--- a/arch/sparc64/kernel/traps.c
+++ b/arch/sparc64/kernel/traps.c
@@ -2208,7 +2208,6 @@ static inline struct reg_window *kernel_
 
 void die_if_kernel(char *str, struct pt_regs *regs)
 {
-	static int die_counter;
 	extern void smp_report_regs(void);
 	int count = 0;
 	
diff --git a/arch/x86_64/kernel/traps.c b/arch/x86_64/kernel/traps.c
index e5403dc..93c4215 100644
--- a/arch/x86_64/kernel/traps.c
+++ b/arch/x86_64/kernel/traps.c
@@ -570,7 +570,6 @@ void __kprobes oops_end(unsigned long fl
 
 void __kprobes __die(const char * str, struct pt_regs * regs, long err)
 {
-	static int die_counter;
 	printk(KERN_EMERG "%s: %04lx [%u] ", str, err & 0xffff,++die_counter);
 #ifdef CONFIG_PREEMPT
 	printk("PREEMPT ");
diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index 693ab26..97cc4e2 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -465,7 +465,6 @@ DEFINE_SPINLOCK(die_lock);
 
 void die(const char * str, struct pt_regs * regs, long err)
 {
-	static int die_counter;
 	int nl = 0;
 
 	console_verbose();
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index b8f8252..54c4fc4 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -202,6 +202,7 @@ extern enum system_states {
 #define TAINT_USER			(1<<6)
 
 extern void dump_stack(void);
+extern int die_counter;
 
 #ifdef DEBUG
 /* If you are writing a driver, please use dev_dbg instead */
diff --git a/kernel/panic.c b/kernel/panic.c
index 623d182..3afa425 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -150,23 +150,27 @@ EXPORT_SYMBOL(panic);
  *  'R' - User forced a module unload.
  *  'M' - Machine had a machine check experience.
  *  'B' - System has hit bad_page.
+ *  'D' - An OOPS has hapened.
  *  'U' - Userspace-defined naughtiness.
  *
  *	The string is overwritten by the next call to print_taint().
  */
+
+int die_counter;
  
 const char *print_tainted(void)
 {
 	static char buf[20];
-	if (tainted) {
-		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c",
+	if (tainted || die_counter) {
+		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c%c",
 			tainted & TAINT_PROPRIETARY_MODULE ? 'P' : 'G',
 			tainted & TAINT_FORCED_MODULE ? 'F' : ' ',
 			tainted & TAINT_UNSAFE_SMP ? 'S' : ' ',
 			tainted & TAINT_FORCED_RMMOD ? 'R' : ' ',
  			tainted & TAINT_MACHINE_CHECK ? 'M' : ' ',
 			tainted & TAINT_BAD_PAGE ? 'B' : ' ',
-			tainted & TAINT_USER ? 'U' : ' ');
+			tainted & TAINT_USER ? 'U' : ' ',
+			die_counter ? 'D' : ' ');
 	}
 	else
 		snprintf(buf, sizeof(buf), "Not tainted");

--------------050907060909040107060603--
