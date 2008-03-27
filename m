Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbYC0UDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbYC0UDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 16:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756349AbYC0UDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 16:03:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41254 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755874AbYC0UDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 16:03:35 -0400
Date: Thu, 27 Mar 2008 21:03:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] x86 fixes
Message-ID: <20080327200309.GA18550@elte.hu>
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


Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git for-linus

Thanks,

	Ingo

------------------>
Andrew Morton (1):
      x86: ptrace.c: fix defined-but-unused warnings

Christoph Lameter (1):
      x86: stricter check in follow_huge_addr()

Florian Fainelli (1):
      rdc321x: GPIO routines bugfixes

Ingo Molnar (1):
      x86: fix prefetch workaround

Jeremy Fitzhardinge (2):
      xen: fix RMW when unmasking events
      xen: fix UP setup of shared_info

Marcin Slusarz (1):
      x86, documentation: nmi_watchdog=2 works on x86_64

 Documentation/nmi_watchdog.txt              |    3 +-
 arch/x86/kernel/ptrace.c                    |  169 ++++++++++++-----------
 arch/x86/mach-rdc321x/gpio.c                |  199 ++++++++++++++++++++-------
 arch/x86/mach-rdc321x/platform.c            |    2 +
 arch/x86/mm/fault.c                         |    3 +-
 arch/x86/mm/hugetlbpage.c                   |    2 +-
 arch/x86/xen/enlighten.c                    |   47 ++++---
 arch/x86/xen/xen-asm.S                      |    9 +-
 include/asm-x86/mach-rdc321x/gpio.h         |    9 +-
 include/asm-x86/mach-rdc321x/rdc321x_defs.h |    8 +-
 10 files changed, 287 insertions(+), 164 deletions(-)

diff --git a/Documentation/nmi_watchdog.txt b/Documentation/nmi_watchdog.txt
index c025a45..757c729 100644
--- a/Documentation/nmi_watchdog.txt
+++ b/Documentation/nmi_watchdog.txt
@@ -23,8 +23,7 @@ kernel debugging options, such as Kernel Stack Meter or Kernel Tracer,
 may implicitly disable the NMI watchdog.]
 
 For x86-64, the needed APIC is always compiled in, and the NMI watchdog is
-always enabled with I/O-APIC mode (nmi_watchdog=1). Currently, local APIC
-mode (nmi_watchdog=2) does not work on x86-64.
+always enabled with I/O-APIC mode (nmi_watchdog=1).
 
 Using local APIC (nmi_watchdog=2) needs the first performance register, so
 you can't use it for other purposes (such as high precision performance
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index d5904ee..eb92ccb 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -600,21 +600,6 @@ static int ptrace_bts_read_record(struct task_struct *child,
 	return sizeof(ret);
 }
 
-static int ptrace_bts_write_record(struct task_struct *child,
-				   const struct bts_struct *in)
-{
-	int retval;
-
-	if (!child->thread.ds_area_msr)
-		return -ENXIO;
-
-	retval = ds_write_bts((void *)child->thread.ds_area_msr, in);
-	if (retval)
-		return retval;
-
-	return sizeof(*in);
-}
-
 static int ptrace_bts_clear(struct task_struct *child)
 {
 	if (!child->thread.ds_area_msr)
@@ -657,75 +642,6 @@ static int ptrace_bts_drain(struct task_struct *child,
 	return end;
 }
 
-static int ptrace_bts_realloc(struct task_struct *child,
-			      int size, int reduce_size)
-{
-	unsigned long rlim, vm;
-	int ret, old_size;
-
-	if (size < 0)
-		return -EINVAL;
-
-	old_size = ds_get_bts_size((void *)child->thread.ds_area_msr);
-	if (old_size < 0)
-		return old_size;
-
-	ret = ds_free((void **)&child->thread.ds_area_msr);
-	if (ret < 0)
-		goto out;
-
-	size >>= PAGE_SHIFT;
-	old_size >>= PAGE_SHIFT;
-
-	current->mm->total_vm  -= old_size;
-	current->mm->locked_vm -= old_size;
-
-	if (size == 0)
-		goto out;
-
-	rlim = current->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
-	vm = current->mm->total_vm  + size;
-	if (rlim < vm) {
-		ret = -ENOMEM;
-
-		if (!reduce_size)
-			goto out;
-
-		size = rlim - current->mm->total_vm;
-		if (size <= 0)
-			goto out;
-	}
-
-	rlim = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
-	vm = current->mm->locked_vm  + size;
-	if (rlim < vm) {
-		ret = -ENOMEM;
-
-		if (!reduce_size)
-			goto out;
-
-		size = rlim - current->mm->locked_vm;
-		if (size <= 0)
-			goto out;
-	}
-
-	ret = ds_allocate((void **)&child->thread.ds_area_msr,
-			  size << PAGE_SHIFT);
-	if (ret < 0)
-		goto out;
-
-	current->mm->total_vm  += size;
-	current->mm->locked_vm += size;
-
-out:
-	if (child->thread.ds_area_msr)
-		set_tsk_thread_flag(child, TIF_DS_AREA_MSR);
-	else
-		clear_tsk_thread_flag(child, TIF_DS_AREA_MSR);
-
-	return ret;
-}
-
 static int ptrace_bts_config(struct task_struct *child,
 			     long cfg_size,
 			     const struct ptrace_bts_config __user *ucfg)
@@ -828,6 +744,91 @@ static int ptrace_bts_status(struct task_struct *child,
 	return sizeof(cfg);
 }
 
+
+static int ptrace_bts_write_record(struct task_struct *child,
+				   const struct bts_struct *in)
+{
+	int retval;
+
+	if (!child->thread.ds_area_msr)
+		return -ENXIO;
+
+	retval = ds_write_bts((void *)child->thread.ds_area_msr, in);
+	if (retval)
+		return retval;
+
+	return sizeof(*in);
+}
+
+static int ptrace_bts_realloc(struct task_struct *child,
+			      int size, int reduce_size)
+{
+	unsigned long rlim, vm;
+	int ret, old_size;
+
+	if (size < 0)
+		return -EINVAL;
+
+	old_size = ds_get_bts_size((void *)child->thread.ds_area_msr);
+	if (old_size < 0)
+		return old_size;
+
+	ret = ds_free((void **)&child->thread.ds_area_msr);
+	if (ret < 0)
+		goto out;
+
+	size >>= PAGE_SHIFT;
+	old_size >>= PAGE_SHIFT;
+
+	current->mm->total_vm  -= old_size;
+	current->mm->locked_vm -= old_size;
+
+	if (size == 0)
+		goto out;
+
+	rlim = current->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
+	vm = current->mm->total_vm  + size;
+	if (rlim < vm) {
+		ret = -ENOMEM;
+
+		if (!reduce_size)
+			goto out;
+
+		size = rlim - current->mm->total_vm;
+		if (size <= 0)
+			goto out;
+	}
+
+	rlim = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
+	vm = current->mm->locked_vm  + size;
+	if (rlim < vm) {
+		ret = -ENOMEM;
+
+		if (!reduce_size)
+			goto out;
+
+		size = rlim - current->mm->locked_vm;
+		if (size <= 0)
+			goto out;
+	}
+
+	ret = ds_allocate((void **)&child->thread.ds_area_msr,
+			  size << PAGE_SHIFT);
+	if (ret < 0)
+		goto out;
+
+	current->mm->total_vm  += size;
+	current->mm->locked_vm += size;
+
+out:
+	if (child->thread.ds_area_msr)
+		set_tsk_thread_flag(child, TIF_DS_AREA_MSR);
+	else
+		clear_tsk_thread_flag(child, TIF_DS_AREA_MSR);
+
+	return ret;
+}
+
 void ptrace_bts_take_timestamp(struct task_struct *tsk,
 			       enum bts_qualifier qualifier)
 {
diff --git a/arch/x86/mach-rdc321x/gpio.c b/arch/x86/mach-rdc321x/gpio.c
index 0312691..247f33d 100644
--- a/arch/x86/mach-rdc321x/gpio.c
+++ b/arch/x86/mach-rdc321x/gpio.c
@@ -1,91 +1,194 @@
 /*
- *  Copyright (C) 2007, OpenWrt.org, Florian Fainelli <florian@openwrt.org>
- *  	RDC321x architecture specific GPIO support
+ *  GPIO support for RDC SoC R3210/R8610
+ *
+ *  Copyright (C) 2007, Florian Fainelli <florian@openwrt.org>
+ *  Copyright (C) 2008, Volker Weiss <dev@tintuc.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
  */
 
-#include <linux/autoconf.h>
-#include <linux/init.h>
+
+#include <linux/spinlock.h>
 #include <linux/io.h>
 #include <linux/types.h>
 #include <linux/module.h>
-#include <linux/delay.h>
 
+#include <asm/gpio.h>
 #include <asm/mach-rdc321x/rdc321x_defs.h>
 
-static inline int rdc_gpio_is_valid(unsigned gpio)
+
+/* spin lock to protect our private copy of GPIO data register plus
+   the access to PCI conf registers. */
+static DEFINE_SPINLOCK(gpio_lock);
+
+/* copy of GPIO data registers */
+static u32 gpio_data_reg1;
+static u32 gpio_data_reg2;
+
+static u32 gpio_request_data[2];
+
+
+static inline void rdc321x_conf_write(unsigned addr, u32 value)
 {
-	return (gpio <= RDC_MAX_GPIO);
+	outl((1 << 31) | (7 << 11) | addr, RDC3210_CFGREG_ADDR);
+	outl(value, RDC3210_CFGREG_DATA);
 }
 
-static unsigned int rdc_gpio_read(unsigned gpio)
+static inline void rdc321x_conf_or(unsigned addr, u32 value)
 {
-	unsigned int val;
-
-	val = 0x80000000 | (7 << 11) | ((gpio&0x20?0x84:0x48));
-	outl(val, RDC3210_CFGREG_ADDR);
-	udelay(10);
-	val = inl(RDC3210_CFGREG_DATA);
-	val |= (0x1 << (gpio & 0x1F));
-	outl(val, RDC3210_CFGREG_DATA);
-	udelay(10);
-	val = 0x80000000 | (7 << 11) | ((gpio&0x20?0x88:0x4C));
-	outl(val, RDC3210_CFGREG_ADDR);
-	udelay(10);
-	val = inl(RDC3210_CFGREG_DATA);
-
-	return val;
+	outl((1 << 31) | (7 << 11) | addr, RDC3210_CFGREG_ADDR);
+	value |= inl(RDC3210_CFGREG_DATA);
+	outl(value, RDC3210_CFGREG_DATA);
 }
 
-static void rdc_gpio_write(unsigned int val)
+static inline u32 rdc321x_conf_read(unsigned addr)
 {
-	if (val) {
-		outl(val, RDC3210_CFGREG_DATA);
-		udelay(10);
-	}
+	outl((1 << 31) | (7 << 11) | addr, RDC3210_CFGREG_ADDR);
+
+	return inl(RDC3210_CFGREG_DATA);
 }
 
-int rdc_gpio_get_value(unsigned gpio)
+/* configure pin as GPIO */
+static void rdc321x_configure_gpio(unsigned gpio)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+	rdc321x_conf_or(gpio < 32
+		? RDC321X_GPIO_CTRL_REG1 : RDC321X_GPIO_CTRL_REG2,
+		1 << (gpio & 0x1f));
+	spin_unlock_irqrestore(&gpio_lock, flags);
+}
+
+/* initially setup the 2 copies of the gpio data registers.
+   This function must be called by the platform setup code. */
+void __init rdc321x_gpio_setup()
+{
+	/* this might not be, what others (BIOS, bootloader, etc.)
+	   wrote to these registers before, but it's a good guess. Still
+	   better than just using 0xffffffff. */
+
+	gpio_data_reg1 = rdc321x_conf_read(RDC321X_GPIO_DATA_REG1);
+	gpio_data_reg2 = rdc321x_conf_read(RDC321X_GPIO_DATA_REG2);
+}
+
+/* determine, if gpio number is valid */
+static inline int rdc321x_is_gpio(unsigned gpio)
+{
+	return gpio <= RDC321X_MAX_GPIO;
+}
+
+/* request GPIO */
+int rdc_gpio_request(unsigned gpio, const char *label)
 {
-	if (rdc_gpio_is_valid(gpio))
-		return (int)rdc_gpio_read(gpio);
-	else
+	unsigned long flags;
+
+	if (!rdc321x_is_gpio(gpio))
 		return -EINVAL;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+	if (gpio_request_data[(gpio & 0x20) ? 1 : 0] & (1 << (gpio & 0x1f)))
+		goto inuse;
+	gpio_request_data[(gpio & 0x20) ? 1 : 0] |= (1 << (gpio & 0x1f));
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	return 0;
+inuse:
+	spin_unlock_irqrestore(&gpio_lock, flags);
+	return -EINVAL;
 }
-EXPORT_SYMBOL(rdc_gpio_get_value);
+EXPORT_SYMBOL(rdc_gpio_request);
 
-void rdc_gpio_set_value(unsigned gpio, int value)
+/* release previously-claimed GPIO */
+void rdc_gpio_free(unsigned gpio)
 {
-	unsigned int val;
+	unsigned long flags;
 
-	if (!rdc_gpio_is_valid(gpio))
+	if (!rdc321x_is_gpio(gpio))
 		return;
 
-	val = rdc_gpio_read(gpio);
+	spin_lock_irqsave(&gpio_lock, flags);
+	gpio_request_data[(gpio & 0x20) ? 1 : 0] &= ~(1 << (gpio & 0x1f));
+	spin_unlock_irqrestore(&gpio_lock, flags);
+}
+EXPORT_SYMBOL(rdc_gpio_free);
+
+/* read GPIO pin */
+int rdc_gpio_get_value(unsigned gpio)
+{
+	u32 reg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+	reg = rdc321x_conf_read(gpio < 32
+		? RDC321X_GPIO_DATA_REG1 : RDC321X_GPIO_DATA_REG2);
+	spin_unlock_irqrestore(&gpio_lock, flags);
 
-	if (value)
-		val &= ~(0x1 << (gpio & 0x1F));
-	else
-		val |= (0x1 << (gpio & 0x1F));
+	return (1 << (gpio & 0x1f)) & reg ? 1 : 0;
+}
+EXPORT_SYMBOL(rdc_gpio_get_value);
 
-	rdc_gpio_write(val);
+/* set GPIO pin to value */
+void rdc_gpio_set_value(unsigned gpio, int value)
+{
+	unsigned long flags;
+	u32 reg;
+
+	reg = 1 << (gpio & 0x1f);
+	if (gpio < 32) {
+		spin_lock_irqsave(&gpio_lock, flags);
+		if (value)
+			gpio_data_reg1 |= reg;
+		else
+			gpio_data_reg1 &= ~reg;
+		rdc321x_conf_write(RDC321X_GPIO_DATA_REG1, gpio_data_reg1);
+		spin_unlock_irqrestore(&gpio_lock, flags);
+	} else {
+		spin_lock_irqsave(&gpio_lock, flags);
+		if (value)
+			gpio_data_reg2 |= reg;
+		else
+			gpio_data_reg2 &= ~reg;
+		rdc321x_conf_write(RDC321X_GPIO_DATA_REG2, gpio_data_reg2);
+		spin_unlock_irqrestore(&gpio_lock, flags);
+	}
 }
 EXPORT_SYMBOL(rdc_gpio_set_value);
 
+/* configure GPIO pin as input */
 int rdc_gpio_direction_input(unsigned gpio)
 {
+	if (!rdc321x_is_gpio(gpio))
+		return -EINVAL;
+
+	rdc321x_configure_gpio(gpio);
+
 	return 0;
 }
 EXPORT_SYMBOL(rdc_gpio_direction_input);
 
+/* configure GPIO pin as output and set value */
 int rdc_gpio_direction_output(unsigned gpio, int value)
 {
+	if (!rdc321x_is_gpio(gpio))
+		return -EINVAL;
+
+	gpio_set_value(gpio, value);
+	rdc321x_configure_gpio(gpio);
+
 	return 0;
 }
 EXPORT_SYMBOL(rdc_gpio_direction_output);
-
-
diff --git a/arch/x86/mach-rdc321x/platform.c b/arch/x86/mach-rdc321x/platform.c
index dda6024..a037041 100644
--- a/arch/x86/mach-rdc321x/platform.c
+++ b/arch/x86/mach-rdc321x/platform.c
@@ -62,6 +62,8 @@ static struct platform_device *rdc321x_devs[] = {
 
 static int __init rdc_board_setup(void)
 {
+	rdc321x_gpio_setup();
+
 	return platform_add_devices(rdc321x_devs, ARRAY_SIZE(rdc321x_devs));
 }
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index fdc6674..c0c82bc 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -92,7 +92,8 @@ static int is_prefetch(struct pt_regs *regs, unsigned long addr,
 	unsigned char *max_instr;
 
 #ifdef CONFIG_X86_32
-	if (!(__supported_pte_mask & _PAGE_NX))
+	/* Catch an obscure case of prefetch inside an NX page: */
+	if ((__supported_pte_mask & _PAGE_NX) && (error_code & 16))
 		return 0;
 #endif
 
diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index 4fbafb4..0b3d567 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -178,7 +178,7 @@ follow_huge_addr(struct mm_struct *mm, unsigned long address, int write)
 
 	page = &pte_page(*pte)[vpfn % (HPAGE_SIZE/PAGE_SIZE)];
 
-	WARN_ON(!PageCompound(page));
+	WARN_ON(!PageHead(page));
 
 	return page;
 }
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 8b9ee27..de4e6f0 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -95,7 +95,7 @@ struct shared_info *HYPERVISOR_shared_info = (void *)&dummy_shared_info;
  *
  * 0: not available, 1: available
  */
-static int have_vcpu_info_placement = 0;
+static int have_vcpu_info_placement = 1;
 
 static void __init xen_vcpu_setup(int cpu)
 {
@@ -103,6 +103,7 @@ static void __init xen_vcpu_setup(int cpu)
 	int err;
 	struct vcpu_info *vcpup;
 
+	BUG_ON(HYPERVISOR_shared_info == &dummy_shared_info);
 	per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
 
 	if (!have_vcpu_info_placement)
@@ -805,33 +806,43 @@ static __init void xen_pagetable_setup_start(pgd_t *base)
 			  PFN_DOWN(__pa(xen_start_info->pt_base)));
 }
 
-static __init void xen_pagetable_setup_done(pgd_t *base)
+static __init void setup_shared_info(void)
 {
-	/* This will work as long as patching hasn't happened yet
-	   (which it hasn't) */
-	pv_mmu_ops.alloc_pt = xen_alloc_pt;
-	pv_mmu_ops.alloc_pd = xen_alloc_pd;
-	pv_mmu_ops.release_pt = xen_release_pt;
-	pv_mmu_ops.release_pd = xen_release_pt;
-	pv_mmu_ops.set_pte = xen_set_pte;
-
 	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
+		unsigned long addr = fix_to_virt(FIX_PARAVIRT_BOOTMAP);
+
 		/*
 		 * Create a mapping for the shared info page.
 		 * Should be set_fixmap(), but shared_info is a machine
 		 * address with no corresponding pseudo-phys address.
 		 */
-		set_pte_mfn(fix_to_virt(FIX_PARAVIRT_BOOTMAP),
+		set_pte_mfn(addr,
 			    PFN_DOWN(xen_start_info->shared_info),
 			    PAGE_KERNEL);
 
-		HYPERVISOR_shared_info =
-			(struct shared_info *)fix_to_virt(FIX_PARAVIRT_BOOTMAP);
-
+		HYPERVISOR_shared_info = (struct shared_info *)addr;
 	} else
 		HYPERVISOR_shared_info =
 			(struct shared_info *)__va(xen_start_info->shared_info);
 
+#ifndef CONFIG_SMP
+	/* In UP this is as good a place as any to set up shared info */
+	xen_setup_vcpu_info_placement();
+#endif
+}
+
+static __init void xen_pagetable_setup_done(pgd_t *base)
+{
+	/* This will work as long as patching hasn't happened yet
+	   (which it hasn't) */
+	pv_mmu_ops.alloc_pt = xen_alloc_pt;
+	pv_mmu_ops.alloc_pd = xen_alloc_pd;
+	pv_mmu_ops.release_pt = xen_release_pt;
+	pv_mmu_ops.release_pd = xen_release_pt;
+	pv_mmu_ops.set_pte = xen_set_pte;
+
+	setup_shared_info();
+
 	/* Actually pin the pagetable down, but we can't set PG_pinned
 	   yet because the page structures don't exist yet. */
 	{
@@ -1182,15 +1193,9 @@ asmlinkage void __init xen_start_kernel(void)
 	x86_write_percpu(xen_cr3, __pa(pgd));
 	x86_write_percpu(xen_current_cr3, __pa(pgd));
 
-#ifdef CONFIG_SMP
 	/* Don't do the full vcpu_info placement stuff until we have a
-	   possible map. */
+	   possible map and a non-dummy shared_info. */
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
-#else
-	/* May as well do it now, since there's no good time to call
-	   it later on UP. */
-	xen_setup_vcpu_info_placement();
-#endif
 
 	pv_info.kernel_rpl = 1;
 	if (xen_feature(XENFEAT_supervisor_mode_kernel))
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index 1a43b60..6b71904 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -33,12 +33,17 @@
 	events, then enter the hypervisor to get them handled.
  */
 ENTRY(xen_irq_enable_direct)
-	/* Clear mask and test pending */
-	andw $0x00ff, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_pending
+	/* Unmask events */
+	movb $0, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_mask
+
 	/* Preempt here doesn't matter because that will deal with
 	   any pending interrupts.  The pending check may end up being
 	   run on the wrong CPU, but that doesn't hurt. */
+
+	/* Test for pending */
+	testb $0xff, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_pending
 	jz 1f
+
 2:	call check_events
 1:
 ENDPATCH(xen_irq_enable_direct)
diff --git a/include/asm-x86/mach-rdc321x/gpio.h b/include/asm-x86/mach-rdc321x/gpio.h
index db31b92..acce0b7 100644
--- a/include/asm-x86/mach-rdc321x/gpio.h
+++ b/include/asm-x86/mach-rdc321x/gpio.h
@@ -5,19 +5,20 @@ extern int rdc_gpio_get_value(unsigned gpio);
 extern void rdc_gpio_set_value(unsigned gpio, int value);
 extern int rdc_gpio_direction_input(unsigned gpio);
 extern int rdc_gpio_direction_output(unsigned gpio, int value);
-
+extern int rdc_gpio_request(unsigned gpio, const char *label);
+extern void rdc_gpio_free(unsigned gpio);
+extern void __init rdc321x_gpio_setup(void);
 
 /* Wrappers for the arch-neutral GPIO API */
 
 static inline int gpio_request(unsigned gpio, const char *label)
 {
-	/* Not yet implemented */
-	return 0;
+	return rdc_gpio_request(gpio, label);
 }
 
 static inline void gpio_free(unsigned gpio)
 {
-	/* Not yet implemented */
+	rdc_gpio_free(gpio);
 }
 
 static inline int gpio_direction_input(unsigned gpio)
diff --git a/include/asm-x86/mach-rdc321x/rdc321x_defs.h b/include/asm-x86/mach-rdc321x/rdc321x_defs.h
index 838ba8f..c8e9c8b 100644
--- a/include/asm-x86/mach-rdc321x/rdc321x_defs.h
+++ b/include/asm-x86/mach-rdc321x/rdc321x_defs.h
@@ -3,4 +3,10 @@
 /* General purpose configuration and data registers */
 #define RDC3210_CFGREG_ADDR     0x0CF8
 #define RDC3210_CFGREG_DATA     0x0CFC
-#define RDC_MAX_GPIO		0x3A
+
+#define RDC321X_GPIO_CTRL_REG1	0x48
+#define RDC321X_GPIO_CTRL_REG2	0x84
+#define RDC321X_GPIO_DATA_REG1	0x4c
+#define RDC321X_GPIO_DATA_REG2	0x88
+
+#define RDC321X_MAX_GPIO	58
