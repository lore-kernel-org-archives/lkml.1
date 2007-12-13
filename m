Return-Path: <linux-kernel-owner+w=401wt.eu-S1761672AbXLMKe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761672AbXLMKe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 05:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756202AbXLMKet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 05:34:49 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:35694
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753904AbXLMKes convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 05:34:48 -0500
Message-Id: <47611905.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 13 Dec 2007 10:35:33 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: various function/data attribute adjustments
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change to mtrr_ap_init() depends on the previously submitted
Makefile change altering the condition for building of two files from
CONFIG_PM to CONFIG_PM_SLEEP (the latter implies CONFIG_HOTPLUG_CPU).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/x86/kernel/cpu/mcheck/mce_64.c |    6 +++---
 arch/x86/kernel/cpu/mtrr/generic.c  |    2 +-
 arch/x86/kernel/cpu/mtrr/main.c     |    2 +-
 arch/x86/kernel/early_printk.c      |    4 ++--
 arch/x86/kernel/setup64.c           |    2 +-
 arch/x86/kernel/smpboot_64.c        |    4 ++--
 6 files changed, 10 insertions(+), 10 deletions(-)

--- linux-2.6.24-rc5/arch/x86/kernel/cpu/mcheck/mce_64.c	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-x86-cpuinit/arch/x86/kernel/cpu/mcheck/mce_64.c	2007-12-04 16:09:33.000000000 +0100
@@ -840,7 +840,7 @@ error:
 	return err;
 }
 
-static void mce_remove_device(unsigned int cpu)
+static __cpuinit void mce_remove_device(unsigned int cpu)
 {
 	int i;
 
@@ -855,7 +855,7 @@ static void mce_remove_device(unsigned i
 }
 
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
-static int
+static __cpuinit int
 mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
@@ -873,7 +873,7 @@ mce_cpu_callback(struct notifier_block *
 	return NOTIFY_OK;
 }
 
-static struct notifier_block mce_cpu_notifier = {
+static __cpuinitdata struct notifier_block mce_cpu_notifier = {
 	.notifier_call = mce_cpu_callback,
 };
 
--- linux-2.6.24-rc5/arch/x86/kernel/cpu/mtrr/generic.c	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-x86-cpuinit/arch/x86/kernel/cpu/mtrr/generic.c	2007-12-04 16:09:33.000000000 +0100
@@ -69,7 +69,7 @@ void mtrr_save_fixed_ranges(void *info)
 		get_fixed_ranges(mtrr_state.fixed_ranges);
 }
 
-static void print_fixed(unsigned base, unsigned step, const mtrr_type*types)
+static void __init print_fixed(unsigned base, unsigned step, const mtrr_type*types)
 {
 	unsigned i;
 
--- linux-2.6.24-rc5/arch/x86/kernel/cpu/mtrr/main.c	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-x86-cpuinit/arch/x86/kernel/cpu/mtrr/main.c	2007-12-04 16:09:33.000000000 +0100
@@ -710,7 +710,7 @@ void __init mtrr_bp_init(void)
 	}
 }
 
-void mtrr_ap_init(void)
+void __cpuinit mtrr_ap_init(void)
 {
 	unsigned long flags;
 
--- linux-2.6.24-rc5/arch/x86/kernel/early_printk.c	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-x86-cpuinit/arch/x86/kernel/early_printk.c	2007-12-04 16:09:33.000000000 +0100
@@ -111,7 +111,7 @@ static __init void early_serial_init(cha
 		if (!strncmp(s,"0x",2)) {
 			early_serial_base = simple_strtoul(s, &e, 16);
 		} else {
-			static int bases[] = { 0x3f8, 0x2f8 };
+			static int __initdata bases[] = { 0x3f8, 0x2f8 };
 
 			if (!strncmp(s,"ttyS",4))
 				s += 4;
@@ -194,7 +194,7 @@ static struct console simnow_console = {
 
 /* Direct interface for emergencies */
 struct console *early_console = &early_vga_console;
-static int early_console_initialized = 0;
+static int __initdata early_console_initialized;
 
 void early_printk(const char *fmt, ...)
 {
--- linux-2.6.24-rc5/arch/x86/kernel/setup64.c	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-x86-cpuinit/arch/x86/kernel/setup64.c	2007-12-04 16:09:33.000000000 +0100
@@ -114,7 +114,7 @@ void __init setup_per_cpu_areas(void)
 	}
 } 
 
-void pda_init(int cpu)
+void __cpuinit pda_init(int cpu)
 { 
 	struct x8664_pda *pda = cpu_pda(cpu);
 
--- linux-2.6.24-rc5/arch/x86/kernel/smpboot_64.c	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-x86-cpuinit/arch/x86/kernel/smpboot_64.c	2007-12-07 16:12:17.000000000 +0100
@@ -152,7 +152,7 @@ static atomic_t init_deasserted __cpuini
  * Report back to the Boot Processor.
  * Running on AP.
  */
-void __cpuinit smp_callin(void)
+static void __cpuinit smp_callin(void)
 {
 	int cpuid, phys_id;
 	unsigned long timeout;
@@ -526,7 +526,7 @@ struct create_idle {
 	int cpu;
 };
 
-void do_fork_idle(struct work_struct *work)
+static void __cpuinit do_fork_idle(struct work_struct *work)
 {
 	struct create_idle *c_idle =
 		container_of(work, struct create_idle, work);


