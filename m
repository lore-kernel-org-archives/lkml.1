Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbYBJHX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbYBJHX5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbYBJHUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:20:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56841 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757223AbYBJHUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:20:43 -0500
Date: Sun, 10 Feb 2008 08:20:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Steven Rostedt <rostedt@goodmis.org>
Subject: [09/19] ftrace: add notrace annotations for NMI routines
Message-ID: <20080210072030.GJ4100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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

From: Steven Rostedt <srostedt@redhat.com>

This annotates NMI functions with notrace. Some tracers may be able
to live with this, but some cannot. The safest is to turn it off,
it's not particularly interesting anyway.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/nmi_32.c   |    3 ++-
 arch/x86/kernel/nmi_64.c   |    6 ++++--
 arch/x86/kernel/traps_32.c |   12 ++++++------
 arch/x86/kernel/traps_64.c |   11 ++++++-----
 4 files changed, 18 insertions(+), 14 deletions(-)

Index: linux/arch/x86/kernel/nmi_32.c
===================================================================
--- linux.orig/arch/x86/kernel/nmi_32.c
+++ linux/arch/x86/kernel/nmi_32.c
@@ -320,7 +320,8 @@ EXPORT_SYMBOL(touch_nmi_watchdog);
 
 extern void die_nmi(struct pt_regs *, const char *msg);
 
-__kprobes int nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
+notrace __kprobes int
+nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 {
 
 	/*
Index: linux/arch/x86/kernel/nmi_64.c
===================================================================
--- linux.orig/arch/x86/kernel/nmi_64.c
+++ linux/arch/x86/kernel/nmi_64.c
@@ -314,7 +314,8 @@ void touch_nmi_watchdog(void)
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
 
-int __kprobes nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
+notrace __kprobes int
+nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 {
 	int sum;
 	int touched = 0;
@@ -385,7 +386,8 @@ int __kprobes nmi_watchdog_tick(struct p
 
 static unsigned ignore_nmis;
 
-asmlinkage __kprobes void do_nmi(struct pt_regs * regs, long error_code)
+asmlinkage notrace __kprobes void
+do_nmi(struct pt_regs *regs, long error_code)
 {
 	nmi_enter();
 	add_pda(__nmi_count,1);
Index: linux/arch/x86/kernel/traps_32.c
===================================================================
--- linux.orig/arch/x86/kernel/traps_32.c
+++ linux/arch/x86/kernel/traps_32.c
@@ -665,7 +665,7 @@ gp_in_kernel:
 	}
 }
 
-static __kprobes void
+static notrace __kprobes void
 mem_parity_error(unsigned char reason, struct pt_regs * regs)
 {
 	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x on "
@@ -688,7 +688,7 @@ mem_parity_error(unsigned char reason, s
 	clear_mem_error(reason);
 }
 
-static __kprobes void
+static notrace __kprobes void
 io_check_error(unsigned char reason, struct pt_regs * regs)
 {
 	unsigned long i;
@@ -705,7 +705,7 @@ io_check_error(unsigned char reason, str
 	outb(reason, 0x61);
 }
 
-static __kprobes void
+static notrace __kprobes void
 unknown_nmi_error(unsigned char reason, struct pt_regs * regs)
 {
 #ifdef CONFIG_MCA
@@ -727,7 +727,7 @@ unknown_nmi_error(unsigned char reason, 
 
 static DEFINE_SPINLOCK(nmi_print_lock);
 
-void __kprobes die_nmi(struct pt_regs *regs, const char *msg)
+void notrace __kprobes die_nmi(struct pt_regs *regs, const char *msg)
 {
 	if (notify_die(DIE_NMIWATCHDOG, msg, regs, 0, 2, SIGINT) ==
 	    NOTIFY_STOP)
@@ -758,7 +758,7 @@ void __kprobes die_nmi(struct pt_regs *r
 	do_exit(SIGSEGV);
 }
 
-static __kprobes void default_do_nmi(struct pt_regs * regs)
+static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
 
@@ -798,7 +798,7 @@ static __kprobes void default_do_nmi(str
 
 static int ignore_nmis;
 
-__kprobes void do_nmi(struct pt_regs * regs, long error_code)
+notrace __kprobes void do_nmi(struct pt_regs *regs, long error_code)
 {
 	int cpu;
 
Index: linux/arch/x86/kernel/traps_64.c
===================================================================
--- linux.orig/arch/x86/kernel/traps_64.c
+++ linux/arch/x86/kernel/traps_64.c
@@ -598,7 +598,8 @@ void die(const char * str, struct pt_reg
 	oops_end(flags, regs, SIGSEGV);
 }
 
-void __kprobes die_nmi(char *str, struct pt_regs *regs, int do_panic)
+notrace __kprobes void
+die_nmi(char *str, struct pt_regs *regs, int do_panic)
 {
 	unsigned long flags = oops_begin();
 
@@ -765,7 +766,7 @@ asmlinkage void __kprobes do_general_pro
 	die("general protection fault", regs, error_code);
 }
 
-static __kprobes void
+static notrace __kprobes void
 mem_parity_error(unsigned char reason, struct pt_regs * regs)
 {
 	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x.\n",
@@ -789,7 +790,7 @@ mem_parity_error(unsigned char reason, s
 	outb(reason, 0x61);
 }
 
-static __kprobes void
+static notrace __kprobes void
 io_check_error(unsigned char reason, struct pt_regs * regs)
 {
 	printk("NMI: IOCK error (debug interrupt?)\n");
@@ -803,7 +804,7 @@ io_check_error(unsigned char reason, str
 	outb(reason, 0x61);
 }
 
-static __kprobes void
+static notrace __kprobes void
 unknown_nmi_error(unsigned char reason, struct pt_regs * regs)
 {
 	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x.\n",
@@ -818,7 +819,7 @@ unknown_nmi_error(unsigned char reason, 
 
 /* Runs on IST stack. This code must keep interrupts off all the time.
    Nested NMIs are prevented by the CPU. */
-asmlinkage __kprobes void default_do_nmi(struct pt_regs *regs)
+asmlinkage notrace  __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
 	int cpu;
