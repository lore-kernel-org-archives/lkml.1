Return-Path: <linux-kernel-owner+w=401wt.eu-S1764851AbXEYSek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764851AbXEYSek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 14:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763684AbXEYSee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 14:34:34 -0400
Received: from 2.0-25.235.16.216.in-addr.arpa ([216.16.235.2]:46014 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1763628AbXEYSed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 14:34:33 -0400
X-Originating-Ip: 72.143.65.211
Date: Fri, 25 May 2007 14:32:28 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH] MIPS: Transform old-style macros to newer "__noreturn"
 standard.
Message-ID: <Pine.LNX.4.64.0705251418050.13623@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Convert old/obsolete NORET_TYPE and ATTRIB_NORET macros to use the
newer standard of "__noreturn" as defined in compiler-gcc.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  since there were a number of these old macros under the MIPS
directory alone, i thought it would be useful to do that subsystem as
a patch by itself, and define the standards for this cleanup:

1) in a function declaration, the "__noreturn" will go at the end of
the declaration.

2) in a definition, "__noreturn" will go between the return type and
the function name

3) in a function typedef, "__noreturn" will go immediately after the
return type, just like with definitions.

4) if a function definition already includes "__noreturn", there's no
point in having any external references to it also say the same thing.
(right?)

  does all that sound reasonable?  if it does, i can deal with the
rest of them in the same way.

 arch/mips/dec/prom/init.c       |    2 +-
 arch/mips/dec/reset.c           |   10 +++++-----
 arch/mips/kernel/process.c      |    4 ++--
 arch/mips/kernel/smp.c          |    2 +-
 arch/mips/kernel/traps.c        |    2 +-
 arch/mips/sgi-ip22/ip22-reset.c |    6 +++---
 arch/mips/sibyte/cfe/setup.c    |    6 +++---
 7 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/mips/dec/prom/init.c b/arch/mips/dec/prom/init.c
index a217aaf..4828cac 100644
--- a/arch/mips/dec/prom/init.c
+++ b/arch/mips/dec/prom/init.c
@@ -86,7 +86,7 @@ void __init which_prom(s32 magic, s32 *prom_vec)

 void __init prom_init(void)
 {
-	extern void ATTRIB_NORET dec_machine_halt(void);
+	extern void dec_machine_halt(void);
 	static char cpu_msg[] __initdata =
 		"Sorry, this kernel is compiled for a wrong CPU type!\n";
 	s32 argc = fw_arg0;
diff --git a/arch/mips/dec/reset.c b/arch/mips/dec/reset.c
index 5639722..c15a879 100644
--- a/arch/mips/dec/reset.c
+++ b/arch/mips/dec/reset.c
@@ -9,26 +9,26 @@

 #include <asm/addrspace.h>

-typedef void ATTRIB_NORET (* noret_func_t)(void);
+typedef void __noreturn (* noret_func_t)(void);

-static inline void ATTRIB_NORET back_to_prom(void)
+static inline void __noreturn back_to_prom(void)
 {
 	noret_func_t func = (void *)CKSEG1ADDR(0x1fc00000);

 	func();
 }

-void ATTRIB_NORET dec_machine_restart(char *command)
+void __noreturn dec_machine_restart(char *command)
 {
 	back_to_prom();
 }

-void ATTRIB_NORET dec_machine_halt(void)
+void __noreturn dec_machine_halt(void)
 {
 	back_to_prom();
 }

-void ATTRIB_NORET dec_machine_power_off(void)
+void __noreturn dec_machine_power_off(void)
 {
     /* DECstations don't have a software power switch */
 	back_to_prom();
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index 6bdfb5a..8f4cf27 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -46,7 +46,7 @@
  * power and have a low exit latency (ie sit in a loop waiting for somebody to
  * say that they'd like to reschedule)
  */
-ATTRIB_NORET void cpu_idle(void)
+void __noreturn cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
@@ -213,7 +213,7 @@ int dump_task_fpu (struct task_struct *t, elf_fpregset_t *fpr)
 /*
  * Create a kernel thread
  */
-static ATTRIB_NORET void kernel_thread_helper(void *arg, int (*fn)(void *))
+static void __noreturn kernel_thread_helper(void *arg, int (*fn)(void *))
 {
 	do_exit(fn(arg));
 }
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index c46e479..fa63727 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -62,7 +62,7 @@ static void smp_tune_scheduling (void)
 }

 extern void __init calibrate_delay(void);
-extern ATTRIB_NORET void cpu_idle(void);
+extern void cpu_idle(void);

 /*
  * First C code run on the secondary CPUs after being started up by
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 200de02..0c72b2c 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -310,7 +310,7 @@ void show_registers(struct pt_regs *regs)

 static DEFINE_SPINLOCK(die_lock);

-NORET_TYPE void ATTRIB_NORET die(const char * str, struct pt_regs * regs)
+void __noreturn die(const char * str, struct pt_regs * regs)
 {
 	static int die_counter;
 #ifdef CONFIG_MIPS_MT_SMTC
diff --git a/arch/mips/sgi-ip22/ip22-reset.c b/arch/mips/sgi-ip22/ip22-reset.c
index 66df5ac..63afd7e 100644
--- a/arch/mips/sgi-ip22/ip22-reset.c
+++ b/arch/mips/sgi-ip22/ip22-reset.c
@@ -46,7 +46,7 @@ static struct timer_list power_timer, blink_timer, debounce_timer, volume_timer;

 static int machine_state;

-static void ATTRIB_NORET sgi_machine_power_off(void)
+static void __noreturn sgi_machine_power_off(void)
 {
 	unsigned int tmp;

@@ -68,7 +68,7 @@ static void ATTRIB_NORET sgi_machine_power_off(void)
 	}
 }

-static void ATTRIB_NORET sgi_machine_restart(char *command)
+static void __noreturn sgi_machine_restart(char *command)
 {
 	if (machine_state & MACHINE_SHUTTING_DOWN)
 		sgi_machine_power_off();
@@ -76,7 +76,7 @@ static void ATTRIB_NORET sgi_machine_restart(char *command)
 	while (1);
 }

-static void ATTRIB_NORET sgi_machine_halt(void)
+static void __noreturn sgi_machine_halt(void)
 {
 	if (machine_state & MACHINE_SHUTTING_DOWN)
 		sgi_machine_power_off();
diff --git a/arch/mips/sibyte/cfe/setup.c b/arch/mips/sibyte/cfe/setup.c
index ae4a92c..51898dd 100644
--- a/arch/mips/sibyte/cfe/setup.c
+++ b/arch/mips/sibyte/cfe/setup.c
@@ -62,7 +62,7 @@ extern unsigned long initrd_start, initrd_end;
 extern int kgdb_port;
 #endif

-static void ATTRIB_NORET cfe_linux_exit(void *arg)
+static void __noreturn cfe_linux_exit(void *arg)
 {
 	int warm = *(int *)arg;

@@ -83,14 +83,14 @@ static void ATTRIB_NORET cfe_linux_exit(void *arg)
 	while (1);
 }

-static void ATTRIB_NORET cfe_linux_restart(char *command)
+static void __noreturn cfe_linux_restart(char *command)
 {
 	static const int zero;

 	cfe_linux_exit((void *)&zero);
 }

-static void ATTRIB_NORET cfe_linux_halt(void)
+static void __noreturn cfe_linux_halt(void)
 {
 	static const int one = 1;


-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
