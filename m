Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbYJBCBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbYJBCBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 22:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbYJBCBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 22:01:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:36342 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbYJBCB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 22:01:26 -0400
Message-ID: <48E42AEB.40104@kernel.org>
Date: Thu, 02 Oct 2008 10:59:07 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: JosephChan@via.com.tw
CC: akpm@linux-foundation.org, scottpitcher@netspace.net.au,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: VIA SATA id 5372 & Pioneer DVR-215 DVD burner problem
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB807DC7F62@exchtp03.taipei.via.com.tw>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB807DC7F62@exchtp03.taipei.via.com.tw>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------080005090304000705080903"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Oct 2008 02:01:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080005090304000705080903
Content-Type: text/plain; charset=big5
Content-Transfer-Encoding: 7bit

JosephChan@via.com.tw wrote:
> Tejun.
> 
> Sorry, I'm not familiar with git. 
> Would you please send me a link to download? 
> 
> In addition, I'm on vacation between 10/3 ~ 10/12.
> I will test it after I'm back.

Okay, here's the patch from v2.6.27-rc7 to libata-dev#upstream.  I
sent you separated out patches with proper descriptions for review and
testing, so please review those.  This one is just combined patch of
them.

Eh... Also, is it possible for you to review before leaving for
vacation?  I really wanna include these in 2.6.28-rc1 window.

Thanks.

-- 
tejun

--------------080005090304000705080903
Content-Type: text/x-patch;
 name="v2.6.27-libata-dev_upstream.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="v2.6.27-libata-dev_upstream.patch"

diff --git a/Documentation/DMA-mapping.txt b/Documentation/DMA-mapping.txt
index b463ecd..c74fec8 100644
--- a/Documentation/DMA-mapping.txt
+++ b/Documentation/DMA-mapping.txt
@@ -740,7 +740,7 @@ failure can be determined by:
 	dma_addr_t dma_handle;
 
 	dma_handle = pci_map_single(pdev, addr, size, direction);
-	if (pci_dma_mapping_error(dma_handle)) {
+	if (pci_dma_mapping_error(pdev, dma_handle)) {
 		/*
 		 * reduce current DMA mapping usage,
 		 * delay and try again later or
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 276a7e6..e1ff0d9 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -351,9 +351,10 @@ kernel.  This value defaults to SHMMAX.
 
 softlockup_thresh:
 
-This value can be used to lower the softlockup tolerance
-threshold. The default threshold is 10s.  If a cpu is locked up
-for 10s, the kernel complains.  Valid values are 1-60s.
+This value can be used to lower the softlockup tolerance threshold.  The
+default threshold is 60 seconds.  If a cpu is locked up for 60 seconds,
+the kernel complains.  Valid values are 1-60 seconds.  Setting this
+tunable to zero will disable the softlockup detection altogether.
 
 ==============================================================
 
diff --git a/Documentation/usb/anchors.txt b/Documentation/usb/anchors.txt
index 7304bcf..5e6b64c 100644
--- a/Documentation/usb/anchors.txt
+++ b/Documentation/usb/anchors.txt
@@ -42,9 +42,21 @@ This function kills all URBs associated with an anchor. The URBs
 are called in the reverse temporal order they were submitted.
 This way no data can be reordered.
 
+usb_unlink_anchored_urbs()
+--------------------------
+
+This function unlinks all URBs associated with an anchor. The URBs
+are processed in the reverse temporal order they were submitted.
+This is similar to usb_kill_anchored_urbs(), but it will not sleep.
+Therefore no guarantee is made that the URBs have been unlinked when
+the call returns. They may be unlinked later but will be unlinked in
+finite time.
+
 usb_wait_anchor_empty_timeout()
 -------------------------------
 
 This function waits for all URBs associated with an anchor to finish
 or a timeout, whichever comes first. Its return value will tell you
 whether the timeout was reached.
+
+
diff --git a/MAINTAINERS b/MAINTAINERS
index cad81a2..3596d17 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1984,7 +1984,7 @@ S:	Maintained
 I2C/SMBUS STUB DRIVER
 P:	Mark M. Hoffman
 M:	mhoffman@lightlink.com
-L:	lm-sensors@lm-sensors.org
+L:	i2c@lm-sensors.org
 S:	Maintained
 
 I2C SUBSYSTEM
@@ -3726,7 +3726,7 @@ S:	Maintained
 SIS 96X I2C/SMBUS DRIVER
 P:	Mark M. Hoffman
 M:	mhoffman@lightlink.com
-L:	lm-sensors@lm-sensors.org
+L:	i2c@lm-sensors.org
 S:	Maintained
 
 SIS FRAMEBUFFER DRIVER
@@ -3833,11 +3833,12 @@ S:	Maintained
 
 SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEMENT
 P:	Liam Girdwood
-M:	liam.girdwood@wolfsonmicro.com
+M:	lrg@slimlogic.co.uk
 P:	Mark Brown
 M:	broonie@opensource.wolfsonmicro.com
 T:	git opensource.wolfsonmicro.com/linux-2.6-asoc
 L:	alsa-devel@alsa-project.org (subscribers-only)
+W:	http://alsa-project.org/main/index.php/ASoC
 S:	Supported
 
 SPI SUBSYSTEM
diff --git a/arch/arm/mach-pxa/time.c b/arch/arm/mach-pxa/time.c
index 67e1850..b0d6b32 100644
--- a/arch/arm/mach-pxa/time.c
+++ b/arch/arm/mach-pxa/time.c
@@ -17,9 +17,9 @@
 #include <linux/interrupt.h>
 #include <linux/clockchips.h>
 #include <linux/sched.h>
+#include <linux/cnt32_to_63.h>
 
 #include <asm/div64.h>
-#include <asm/cnt32_to_63.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/time.h>
 #include <mach/pxa-regs.h>
diff --git a/arch/arm/mach-sa1100/generic.c b/arch/arm/mach-sa1100/generic.c
index 1362994..b422526 100644
--- a/arch/arm/mach-sa1100/generic.c
+++ b/arch/arm/mach-sa1100/generic.c
@@ -18,9 +18,9 @@
 #include <linux/ioport.h>
 #include <linux/sched.h>	/* just for sched_clock() - funny that */
 #include <linux/platform_device.h>
+#include <linux/cnt32_to_63.h>
 
 #include <asm/div64.h>
-#include <asm/cnt32_to_63.h>
 #include <mach/hardware.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index d75e795..b638f10 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -28,8 +28,8 @@
 #include <linux/amba/clcd.h>
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
+#include <linux/cnt32_to_63.h>
 
-#include <asm/cnt32_to_63.h>
 #include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/io.h>
diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index d45f215..51b75ce 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -1232,9 +1232,10 @@ efi_initialize_iomem_resources(struct resource *code_resource,
 				if (md->attribute & EFI_MEMORY_WP) {
 					name = "System ROM";
 					flags |= IORESOURCE_READONLY;
-				} else {
+				} else if (md->attribute == EFI_MEMORY_UC)
+					name = "Uncached RAM";
+				else
 					name = "System RAM";
-				}
 				break;
 
 			case EFI_ACPI_MEMORY_NVS:
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index c27d5b2..de636b2 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -616,7 +616,9 @@ setup_arch (char **cmdline_p)
 		ia64_mca_init();
 
 	platform_setup(cmdline_p);
+#ifndef CONFIG_IA64_HP_SIM
 	check_sal_cache_flush();
+#endif
 	paging_init();
 }
 
diff --git a/arch/mips/au1000/common/gpio.c b/arch/mips/au1000/common/gpio.c
index b485d94..1f05843 100644
--- a/arch/mips/au1000/common/gpio.c
+++ b/arch/mips/au1000/common/gpio.c
@@ -61,7 +61,8 @@ static int au1xxx_gpio2_direction_input(unsigned gpio)
 static int au1xxx_gpio2_direction_output(unsigned gpio, int value)
 {
 	gpio -= AU1XXX_GPIO_BASE;
-	gpio2->dir = (0x01 << gpio) | (value << gpio);
+	gpio2->dir |= 0x01 << gpio;
+	gpio2->output = (GPIO2_OUTPUT_ENABLE_MASK << gpio) | (value << gpio);
 	return 0;
 }
 
@@ -90,6 +91,7 @@ static int au1xxx_gpio1_direction_input(unsigned gpio)
 static int au1xxx_gpio1_direction_output(unsigned gpio, int value)
 {
 	gpio1->trioutclr = (0x01 & gpio);
+	au1xxx_gpio1_write(gpio, value);
 	return 0;
 }
 
diff --git a/arch/mn10300/kernel/time.c b/arch/mn10300/kernel/time.c
index babb7c2..e460658 100644
--- a/arch/mn10300/kernel/time.c
+++ b/arch/mn10300/kernel/time.c
@@ -1,6 +1,6 @@
 /* MN10300 Low level time management
  *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2007-2008 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
  * - Derived from arch/i386/kernel/time.c
  *
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/profile.h>
+#include <linux/cnt32_to_63.h>
 #include <asm/irq.h>
 #include <asm/div64.h>
 #include <asm/processor.h>
@@ -40,27 +41,54 @@ static struct irqaction timer_irq = {
 	.name		= "timer",
 };
 
+static unsigned long sched_clock_multiplier;
+
 /*
  * scheduler clock - returns current time in nanosec units.
  */
 unsigned long long sched_clock(void)
 {
 	union {
-		unsigned long long l;
-		u32 w[2];
-	} quot;
+		unsigned long long ll;
+		unsigned l[2];
+	} tsc64, result;
+	unsigned long tsc, tmp;
+	unsigned product[3]; /* 96-bit intermediate value */
+
+	/* read the TSC value
+	 */
+	tsc = 0 - get_cycles(); /* get_cycles() counts down */
 
-	quot.w[0] = mn10300_last_tsc - get_cycles();
-	quot.w[1] = 1000000000;
+	/* expand to 64-bits.
+	 * - sched_clock() must be called once a minute or better or the
+	 *   following will go horribly wrong - see cnt32_to_63()
+	 */
+	tsc64.ll = cnt32_to_63(tsc) & 0x7fffffffffffffffULL;
 
-	asm("mulu %2,%3,%0,%1"
-	    : "=r"(quot.w[1]), "=r"(quot.w[0])
-	    : "0"(quot.w[1]), "1"(quot.w[0])
+	/* scale the 64-bit TSC value to a nanosecond value via a 96-bit
+	 * intermediate
+	 */
+	asm("mulu	%2,%0,%3,%0	\n"	/* LSW * mult ->  0:%3:%0 */
+	    "mulu	%2,%1,%2,%1	\n"	/* MSW * mult -> %2:%1:0 */
+	    "add	%3,%1		\n"
+	    "addc	0,%2		\n"	/* result in %2:%1:%0 */
+	    : "=r"(product[0]), "=r"(product[1]), "=r"(product[2]), "=r"(tmp)
+	    :  "0"(tsc64.l[0]),  "1"(tsc64.l[1]),  "2"(sched_clock_multiplier)
 	    : "cc");
 
-	do_div(quot.l, MN10300_TSCCLK);
+	result.l[0] = product[1] << 16 | product[0] >> 16;
+	result.l[1] = product[2] << 16 | product[1] >> 16;
 
-	return quot.l;
+	return result.ll;
+}
+
+/*
+ * initialise the scheduler clock
+ */
+static void __init mn10300_sched_clock_init(void)
+{
+	sched_clock_multiplier =
+		__muldiv64u(NSEC_PER_SEC, 1 << 16, MN10300_TSCCLK);
 }
 
 /*
@@ -128,4 +156,6 @@ void __init time_init(void)
 	/* start the watchdog timer */
 	watchdog_go();
 #endif
+
+	mn10300_sched_clock_init();
 }
diff --git a/arch/sparc64/kernel/of_device.c b/arch/sparc64/kernel/of_device.c
index f845f15..100ebd5 100644
--- a/arch/sparc64/kernel/of_device.c
+++ b/arch/sparc64/kernel/of_device.c
@@ -169,7 +169,7 @@ static unsigned long of_bus_default_get_flags(const u32 *addr, unsigned long fla
 
 static int of_bus_pci_match(struct device_node *np)
 {
-	if (!strcmp(np->type, "pci") || !strcmp(np->type, "pciex")) {
+	if (!strcmp(np->name, "pci")) {
 		const char *model = of_get_property(np, "model", NULL);
 
 		if (model && !strcmp(model, "SUNW,simba"))
@@ -200,7 +200,7 @@ static int of_bus_simba_match(struct device_node *np)
 	/* Treat PCI busses lacking ranges property just like
 	 * simba.
 	 */
-	if (!strcmp(np->type, "pci") || !strcmp(np->type, "pciex")) {
+	if (!strcmp(np->name, "pci")) {
 		if (!of_find_property(np, "ranges", NULL))
 			return 1;
 	}
@@ -429,7 +429,7 @@ static int __init use_1to1_mapping(struct device_node *pp)
 	 * it lacks a ranges property, and this will include
 	 * cases like Simba.
 	 */
-	if (!strcmp(pp->type, "pci") || !strcmp(pp->type, "pciex"))
+	if (!strcmp(pp->name, "pci"))
 		return 0;
 
 	return 1;
@@ -714,8 +714,7 @@ static unsigned int __init build_one_device_irq(struct of_device *op,
 				break;
 			}
 		} else {
-			if (!strcmp(pp->type, "pci") ||
-			    !strcmp(pp->type, "pciex")) {
+			if (!strcmp(pp->name, "pci")) {
 				unsigned int this_orig_irq = irq;
 
 				irq = pci_irq_swizzle(dp, pp, irq);
diff --git a/arch/sparc64/kernel/pci.c b/arch/sparc64/kernel/pci.c
index 5509619..80dad76 100644
--- a/arch/sparc64/kernel/pci.c
+++ b/arch/sparc64/kernel/pci.c
@@ -425,7 +425,7 @@ struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
 	dev->current_state = 4;		/* unknown power state */
 	dev->error_state = pci_channel_io_normal;
 
-	if (!strcmp(type, "pci") || !strcmp(type, "pciex")) {
+	if (!strcmp(node->name, "pci")) {
 		/* a PCI-PCI bridge */
 		dev->hdr_type = PCI_HEADER_TYPE_BRIDGE;
 		dev->rom_base_reg = PCI_ROM_ADDRESS1;
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 69b4d06..042fdc2 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -101,10 +101,10 @@ static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
  */
 static int iommu_completion_wait(struct amd_iommu *iommu)
 {
-	int ret, ready = 0;
+	int ret = 0, ready = 0;
 	unsigned status = 0;
 	struct iommu_cmd cmd;
-	unsigned long i = 0;
+	unsigned long flags, i = 0;
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.data[0] = CMD_COMPL_WAIT_INT_MASK;
@@ -112,10 +112,12 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 
 	iommu->need_sync = 0;
 
-	ret = iommu_queue_command(iommu, &cmd);
+	spin_lock_irqsave(&iommu->lock, flags);
+
+	ret = __iommu_queue_command(iommu, &cmd);
 
 	if (ret)
-		return ret;
+		goto out;
 
 	while (!ready && (i < EXIT_LOOP_COUNT)) {
 		++i;
@@ -130,6 +132,8 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 
 	if (unlikely((i == EXIT_LOOP_COUNT) && printk_ratelimit()))
 		printk(KERN_WARNING "AMD IOMMU: Completion wait loop failed\n");
+out:
+	spin_unlock_irqrestore(&iommu->lock, flags);
 
 	return 0;
 }
@@ -140,6 +144,7 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 static int iommu_queue_inv_dev_entry(struct amd_iommu *iommu, u16 devid)
 {
 	struct iommu_cmd cmd;
+	int ret;
 
 	BUG_ON(iommu == NULL);
 
@@ -147,9 +152,11 @@ static int iommu_queue_inv_dev_entry(struct amd_iommu *iommu, u16 devid)
 	CMD_SET_TYPE(&cmd, CMD_INV_DEV_ENTRY);
 	cmd.data[0] = devid;
 
+	ret = iommu_queue_command(iommu, &cmd);
+
 	iommu->need_sync = 1;
 
-	return iommu_queue_command(iommu, &cmd);
+	return ret;
 }
 
 /*
@@ -159,6 +166,7 @@ static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
 		u64 address, u16 domid, int pde, int s)
 {
 	struct iommu_cmd cmd;
+	int ret;
 
 	memset(&cmd, 0, sizeof(cmd));
 	address &= PAGE_MASK;
@@ -171,9 +179,11 @@ static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
 	if (pde) /* PDE bit - we wan't flush everything not only the PTEs */
 		cmd.data[2] |= CMD_INV_IOMMU_PAGES_PDE_MASK;
 
+	ret = iommu_queue_command(iommu, &cmd);
+
 	iommu->need_sync = 1;
 
-	return iommu_queue_command(iommu, &cmd);
+	return ret;
 }
 
 /*
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 7fc4d5b..876e918 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -246,6 +246,14 @@ static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
 	return 1;
 }
 
+static cpumask_t c1e_mask = CPU_MASK_NONE;
+static int c1e_detected;
+
+void c1e_remove_cpu(int cpu)
+{
+	cpu_clear(cpu, c1e_mask);
+}
+
 /*
  * C1E aware idle routine. We check for C1E active in the interrupt
  * pending message MSR. If we detect C1E, then we handle it the same
@@ -253,9 +261,6 @@ static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
  */
 static void c1e_idle(void)
 {
-	static cpumask_t c1e_mask = CPU_MASK_NONE;
-	static int c1e_detected;
-
 	if (need_resched())
 		return;
 
@@ -265,8 +270,10 @@ static void c1e_idle(void)
 		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
 		if (lo & K8_INTP_C1E_ACTIVE_MASK) {
 			c1e_detected = 1;
-			mark_tsc_unstable("TSC halt in C1E");
-			printk(KERN_INFO "System has C1E enabled\n");
+			if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+				mark_tsc_unstable("TSC halt in AMD C1E");
+			printk(KERN_INFO "System has AMD C1E enabled\n");
+			set_cpu_cap(&boot_cpu_data, X86_FEATURE_AMDC1E);
 		}
 	}
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 3b7a1dd..31f40b2 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -55,6 +55,7 @@
 #include <asm/tlbflush.h>
 #include <asm/cpu.h>
 #include <asm/kdebug.h>
+#include <asm/idle.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -88,6 +89,7 @@ static void cpu_exit_clear(void)
 	cpu_clear(cpu, cpu_callin_map);
 
 	numa_remove_cpu(cpu);
+	c1e_remove_cpu(cpu);
 }
 
 /* We don't actually take CPU down, just spin without interrupts. */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 71553b6..e12e0e4 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -93,6 +93,8 @@ DECLARE_PER_CPU(int, cpu_state);
 static inline void play_dead(void)
 {
 	idle_task_exit();
+	c1e_remove_cpu(raw_smp_processor_id());
+
 	mb();
 	/* Ack it */
 	__get_cpu_var(cpu_state) = CPU_DEAD;
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 0c029e8..7766d36 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -61,7 +61,7 @@ static void vsmp_irq_enable(void)
 	native_restore_fl((flags | X86_EFLAGS_IF) & (~X86_EFLAGS_AC));
 }
 
-static unsigned __init vsmp_patch(u8 type, u16 clobbers, void *ibuf,
+static unsigned __init_or_module vsmp_patch(u8 type, u16 clobbers, void *ibuf,
 				  unsigned long addr, unsigned len)
 {
 	switch (type) {
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 0227694..8a5f161 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -295,10 +295,12 @@ static void nmi_cpu_shutdown(void *dummy)
 
 static void nmi_shutdown(void)
 {
-	struct op_msrs *msrs = &get_cpu_var(cpu_msrs);
+	struct op_msrs *msrs;
+
 	nmi_enabled = 0;
 	on_each_cpu(nmi_cpu_shutdown, NULL, 1);
 	unregister_die_notifier(&profile_exceptions_nb);
+	msrs = &get_cpu_var(cpu_msrs);
 	model->shutdown(msrs);
 	free_msrs();
 	put_cpu_var(cpu_msrs);
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 11c8c19..f17cd4b 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -663,7 +663,7 @@ config HAVE_PATA_PLATFORM
 
 config PATA_PLATFORM
 	tristate "Generic platform device PATA support"
-	depends on EMBEDDED || ARCH_RPC || PPC || HAVE_PATA_PLATFORM
+	depends on EMBEDDED || PPC || HAVE_PATA_PLATFORM
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems.
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 2e1a7cb..aeadd00 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -267,8 +267,8 @@ struct ahci_port_priv {
 					 	 * per PM slot */
 };
 
-static int ahci_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
-static int ahci_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
+static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
 static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
@@ -316,6 +316,7 @@ static struct device_attribute *ahci_shost_attrs[] = {
 
 static struct device_attribute *ahci_sdev_attrs[] = {
 	&dev_attr_sw_activity,
+	&dev_attr_unload_heads,
 	NULL
 };
 
@@ -820,10 +821,10 @@ static unsigned ahci_scr_offset(struct ata_port *ap, unsigned int sc_reg)
 	return 0;
 }
 
-static int ahci_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
 {
-	void __iomem *port_mmio = ahci_port_base(ap);
-	int offset = ahci_scr_offset(ap, sc_reg);
+	void __iomem *port_mmio = ahci_port_base(link->ap);
+	int offset = ahci_scr_offset(link->ap, sc_reg);
 
 	if (offset) {
 		*val = readl(port_mmio + offset);
@@ -832,10 +833,10 @@ static int ahci_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 	return -EINVAL;
 }
 
-static int ahci_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 {
-	void __iomem *port_mmio = ahci_port_base(ap);
-	int offset = ahci_scr_offset(ap, sc_reg);
+	void __iomem *port_mmio = ahci_port_base(link->ap);
+	int offset = ahci_scr_offset(link->ap, sc_reg);
 
 	if (offset) {
 		writel(val, port_mmio + offset);
@@ -973,7 +974,7 @@ static void ahci_disable_alpm(struct ata_port *ap)
 	writel(PORT_IRQ_PHYRDY, port_mmio + PORT_IRQ_STAT);
 
 	/* go ahead and clean out PhyRdy Change from Serror too */
-	ahci_scr_write(ap, SCR_ERROR, ((1 << 16) | (1 << 18)));
+	ahci_scr_write(&ap->link, SCR_ERROR, ((1 << 16) | (1 << 18)));
 
 	/*
  	 * Clear flag to indicate that we should ignore all PhyRdy
@@ -1937,8 +1938,8 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 	ata_ehi_push_desc(host_ehi, "irq_stat 0x%08x", irq_stat);
 
 	/* AHCI needs SError cleared; otherwise, it might lock up */
-	ahci_scr_read(ap, SCR_ERROR, &serror);
-	ahci_scr_write(ap, SCR_ERROR, serror);
+	ahci_scr_read(&ap->link, SCR_ERROR, &serror);
+	ahci_scr_write(&ap->link, SCR_ERROR, serror);
 	host_ehi->serror |= serror;
 
 	/* some controllers set IRQ_IF_ERR on device errors, ignore it */
@@ -2027,7 +2028,7 @@ static void ahci_port_intr(struct ata_port *ap)
 	if ((hpriv->flags & AHCI_HFLAG_NO_HOTPLUG) &&
 		(status & PORT_IRQ_PHYRDY)) {
 		status &= ~PORT_IRQ_PHYRDY;
-		ahci_scr_write(ap, SCR_ERROR, ((1 << 16) | (1 << 18)));
+		ahci_scr_write(&ap->link, SCR_ERROR, ((1 << 16) | (1 << 18)));
 	}
 
 	if (unlikely(status & PORT_IRQ_ERROR)) {
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index e6b4606..e9e32ed 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -165,8 +165,10 @@ static void piix_set_dmamode(struct ata_port *ap, struct ata_device *adev);
 static void ich_set_dmamode(struct ata_port *ap, struct ata_device *adev);
 static int ich_pata_cable_detect(struct ata_port *ap);
 static u8 piix_vmw_bmdma_status(struct ata_port *ap);
-static int piix_sidpr_scr_read(struct ata_port *ap, unsigned int reg, u32 *val);
-static int piix_sidpr_scr_write(struct ata_port *ap, unsigned int reg, u32 val);
+static int piix_sidpr_scr_read(struct ata_link *link,
+			       unsigned int reg, u32 *val);
+static int piix_sidpr_scr_write(struct ata_link *link,
+				unsigned int reg, u32 val);
 #ifdef CONFIG_PM
 static int piix_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 static int piix_pci_device_resume(struct pci_dev *pdev);
@@ -278,12 +280,15 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* SATA Controller IDE (PCH) */
 	{ 0x8086, 0x3b20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
 	/* SATA Controller IDE (PCH) */
+	{ 0x8086, 0x3b21, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (PCH) */
 	{ 0x8086, 0x3b26, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (PCH) */
+	{ 0x8086, 0x3b28, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	/* SATA Controller IDE (PCH) */
 	{ 0x8086, 0x3b2d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (PCH) */
 	{ 0x8086, 0x3b2e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
-
 	{ }	/* terminate list */
 };
 
@@ -582,6 +587,7 @@ static const struct ich_laptop ich_laptop[] = {
 	{ 0x27DF, 0x1025, 0x0110 },	/* ICH7 on Acer 3682WLMi */
 	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
 	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
+	{ 0x27DF, 0x1071, 0xD221 },	/* ICH7 on Hercules EC-900 */
 	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on ACER Aspire 2023WLMi */
 	{ 0x24CA, 0x1025, 0x003d },	/* ICH4 on ACER TM290 */
 	{ 0x266F, 0x1025, 0x0066 },	/* ICH6 on ACER Aspire 1694WLMi */
@@ -885,23 +891,9 @@ static void ich_set_dmamode(struct ata_port *ap, struct ata_device *adev)
  * Serial ATA Index/Data Pair Superset Registers access
  *
  * Beginning from ICH8, there's a sane way to access SCRs using index
- * and data register pair located at BAR5.  This creates an
- * interesting problem of mapping two SCRs to one port.
- *
- * Although they have separate SCRs, the master and slave aren't
- * independent enough to be treated as separate links - e.g. softreset
- * resets both.  Also, there's no protocol defined for hard resetting
- * singled device sharing the virtual port (no defined way to acquire
- * device signature).  This is worked around by merging the SCR values
- * into one sensible value and requesting follow-up SRST after
- * hardreset.
- *
- * SCR merging is perfomed in nibbles which is the unit contents in
- * SCRs are organized.  If two values are equal, the value is used.
- * When they differ, merge table which lists precedence of possible
- * values is consulted and the first match or the last entry when
- * nothing matches is used.  When there's no merge table for the
- * specific nibble, value from the first port is used.
+ * and data register pair located at BAR5 which means that we have
+ * separate SCRs for master and slave.  This is handled using libata
+ * slave_link facility.
  */
 static const int piix_sidx_map[] = {
 	[SCR_STATUS]	= 0,
@@ -909,120 +901,38 @@ static const int piix_sidx_map[] = {
 	[SCR_CONTROL]	= 1,
 };
 
-static void piix_sidpr_sel(struct ata_device *dev, unsigned int reg)
+static void piix_sidpr_sel(struct ata_link *link, unsigned int reg)
 {
-	struct ata_port *ap = dev->link->ap;
+	struct ata_port *ap = link->ap;
 	struct piix_host_priv *hpriv = ap->host->private_data;
 
-	iowrite32(((ap->port_no * 2 + dev->devno) << 8) | piix_sidx_map[reg],
+	iowrite32(((ap->port_no * 2 + link->pmp) << 8) | piix_sidx_map[reg],
 		  hpriv->sidpr + PIIX_SIDPR_IDX);
 }
 
-static int piix_sidpr_read(struct ata_device *dev, unsigned int reg)
-{
-	struct piix_host_priv *hpriv = dev->link->ap->host->private_data;
-
-	piix_sidpr_sel(dev, reg);
-	return ioread32(hpriv->sidpr + PIIX_SIDPR_DATA);
-}
-
-static void piix_sidpr_write(struct ata_device *dev, unsigned int reg, u32 val)
-{
-	struct piix_host_priv *hpriv = dev->link->ap->host->private_data;
-
-	piix_sidpr_sel(dev, reg);
-	iowrite32(val, hpriv->sidpr + PIIX_SIDPR_DATA);
-}
-
-static u32 piix_merge_scr(u32 val0, u32 val1, const int * const *merge_tbl)
-{
-	u32 val = 0;
-	int i, mi;
-
-	for (i = 0, mi = 0; i < 32 / 4; i++) {
-		u8 c0 = (val0 >> (i * 4)) & 0xf;
-		u8 c1 = (val1 >> (i * 4)) & 0xf;
-		u8 merged = c0;
-		const int *cur;
-
-		/* if no merge preference, assume the first value */
-		cur = merge_tbl[mi];
-		if (!cur)
-			goto done;
-		mi++;
-
-		/* if two values equal, use it */
-		if (c0 == c1)
-			goto done;
-
-		/* choose the first match or the last from the merge table */
-		while (*cur != -1) {
-			if (c0 == *cur || c1 == *cur)
-				break;
-			cur++;
-		}
-		if (*cur == -1)
-			cur--;
-		merged = *cur;
-	done:
-		val |= merged << (i * 4);
-	}
-
-	return val;
-}
-
-static int piix_sidpr_scr_read(struct ata_port *ap, unsigned int reg, u32 *val)
+static int piix_sidpr_scr_read(struct ata_link *link,
+			       unsigned int reg, u32 *val)
 {
-	const int * const sstatus_merge_tbl[] = {
-		/* DET */ (const int []){ 1, 3, 0, 4, 3, -1 },
-		/* SPD */ (const int []){ 2, 1, 0, -1 },
-		/* IPM */ (const int []){ 6, 2, 1, 0, -1 },
-		NULL,
-	};
-	const int * const scontrol_merge_tbl[] = {
-		/* DET */ (const int []){ 1, 0, 4, 0, -1 },
-		/* SPD */ (const int []){ 0, 2, 1, 0, -1 },
-		/* IPM */ (const int []){ 0, 1, 2, 3, 0, -1 },
-		NULL,
-	};
-	u32 v0, v1;
+	struct piix_host_priv *hpriv = link->ap->host->private_data;
 
 	if (reg >= ARRAY_SIZE(piix_sidx_map))
 		return -EINVAL;
 
-	if (!(ap->flags & ATA_FLAG_SLAVE_POSS)) {
-		*val = piix_sidpr_read(&ap->link.device[0], reg);
-		return 0;
-	}
-
-	v0 = piix_sidpr_read(&ap->link.device[0], reg);
-	v1 = piix_sidpr_read(&ap->link.device[1], reg);
-
-	switch (reg) {
-	case SCR_STATUS:
-		*val = piix_merge_scr(v0, v1, sstatus_merge_tbl);
-		break;
-	case SCR_ERROR:
-		*val = v0 | v1;
-		break;
-	case SCR_CONTROL:
-		*val = piix_merge_scr(v0, v1, scontrol_merge_tbl);
-		break;
-	}
-
+	piix_sidpr_sel(link, reg);
+	*val = ioread32(hpriv->sidpr + PIIX_SIDPR_DATA);
 	return 0;
 }
 
-static int piix_sidpr_scr_write(struct ata_port *ap, unsigned int reg, u32 val)
+static int piix_sidpr_scr_write(struct ata_link *link,
+				unsigned int reg, u32 val)
 {
+	struct piix_host_priv *hpriv = link->ap->host->private_data;
+
 	if (reg >= ARRAY_SIZE(piix_sidx_map))
 		return -EINVAL;
 
-	piix_sidpr_write(&ap->link.device[0], reg, val);
-
-	if (ap->flags & ATA_FLAG_SLAVE_POSS)
-		piix_sidpr_write(&ap->link.device[1], reg, val);
-
+	piix_sidpr_sel(link, reg);
+	iowrite32(val, hpriv->sidpr + PIIX_SIDPR_DATA);
 	return 0;
 }
 
@@ -1363,28 +1273,28 @@ static const int *__devinit piix_init_sata_map(struct pci_dev *pdev,
 	return map;
 }
 
-static void __devinit piix_init_sidpr(struct ata_host *host)
+static int __devinit piix_init_sidpr(struct ata_host *host)
 {
 	struct pci_dev *pdev = to_pci_dev(host->dev);
 	struct piix_host_priv *hpriv = host->private_data;
-	struct ata_device *dev0 = &host->ports[0]->link.device[0];
+	struct ata_link *link0 = &host->ports[0]->link;
 	u32 scontrol;
-	int i;
+	int i, rc;
 
 	/* check for availability */
 	for (i = 0; i < 4; i++)
 		if (hpriv->map[i] == IDE)
-			return;
+			return 0;
 
 	if (!(host->ports[0]->flags & PIIX_FLAG_SIDPR))
-		return;
+		return 0;
 
 	if (pci_resource_start(pdev, PIIX_SIDPR_BAR) == 0 ||
 	    pci_resource_len(pdev, PIIX_SIDPR_BAR) != PIIX_SIDPR_LEN)
-		return;
+		return 0;
 
 	if (pcim_iomap_regions(pdev, 1 << PIIX_SIDPR_BAR, DRV_NAME))
-		return;
+		return 0;
 
 	hpriv->sidpr = pcim_iomap_table(pdev)[PIIX_SIDPR_BAR];
 
@@ -1392,7 +1302,7 @@ static void __devinit piix_init_sidpr(struct ata_host *host)
 	 * Give it a test drive by inhibiting power save modes which
 	 * we'll do anyway.
 	 */
-	scontrol = piix_sidpr_read(dev0, SCR_CONTROL);
+	piix_sidpr_scr_read(link0, SCR_CONTROL, &scontrol);
 
 	/* if IPM is already 3, SCR access is probably working.  Don't
 	 * un-inhibit power save modes as BIOS might have inhibited
@@ -1400,18 +1310,30 @@ static void __devinit piix_init_sidpr(struct ata_host *host)
 	 */
 	if ((scontrol & 0xf00) != 0x300) {
 		scontrol |= 0x300;
-		piix_sidpr_write(dev0, SCR_CONTROL, scontrol);
-		scontrol = piix_sidpr_read(dev0, SCR_CONTROL);
+		piix_sidpr_scr_write(link0, SCR_CONTROL, scontrol);
+		piix_sidpr_scr_read(link0, SCR_CONTROL, &scontrol);
 
 		if ((scontrol & 0xf00) != 0x300) {
 			dev_printk(KERN_INFO, host->dev, "SCR access via "
 				   "SIDPR is available but doesn't work\n");
-			return;
+			return 0;
 		}
 	}
 
-	host->ports[0]->ops = &piix_sidpr_sata_ops;
-	host->ports[1]->ops = &piix_sidpr_sata_ops;
+	/* okay, SCRs available, set ops and ask libata for slave_link */
+	for (i = 0; i < 2; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		ap->ops = &piix_sidpr_sata_ops;
+
+		if (ap->flags & ATA_FLAG_SLAVE_POSS) {
+			rc = ata_slave_link_init(ap);
+			if (rc)
+				return rc;
+		}
+	}
+
+	return 0;
 }
 
 static void piix_iocfg_bit18_quirk(struct pci_dev *pdev)
@@ -1521,7 +1443,9 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 	/* initialize controller */
 	if (port_flags & ATA_FLAG_SATA) {
 		piix_init_pcs(host, piix_map_db_table[ent->driver_data]);
-		piix_init_sidpr(host);
+		rc = piix_init_sidpr(host);
+		if (rc)
+			return rc;
 	}
 
 	/* apply IOCFG bit18 quirk */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 79e3a8e..1ee9499 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -163,6 +163,67 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
 
+/*
+ * Iterator helpers.  Don't use directly.
+ *
+ * LOCKING:
+ * Host lock or EH context.
+ */
+struct ata_link *__ata_port_next_link(struct ata_port *ap,
+				      struct ata_link *link, bool dev_only)
+{
+	/* NULL link indicates start of iteration */
+	if (!link) {
+		if (dev_only && sata_pmp_attached(ap))
+			return ap->pmp_link;
+		return &ap->link;
+	}
+
+	/* we just iterated over the host master link, what's next? */
+	if (link == &ap->link) {
+		if (!sata_pmp_attached(ap)) {
+			if (unlikely(ap->slave_link) && !dev_only)
+				return ap->slave_link;
+			return NULL;
+		}
+		return ap->pmp_link;
+	}
+
+	/* slave_link excludes PMP */
+	if (unlikely(link == ap->slave_link))
+		return NULL;
+
+	/* iterate to the next PMP link */
+	if (++link < ap->pmp_link + ap->nr_pmp_links)
+		return link;
+	return NULL;
+}
+
+/**
+ *	ata_dev_phys_link - find physical link for a device
+ *	@dev: ATA device to look up physical link for
+ *
+ *	Look up physical link which @dev is attached to.  Note that
+ *	this is different from @dev->link only when @dev is on slave
+ *	link.  For all other cases, it's the same as @dev->link.
+ *
+ *	LOCKING:
+ *	Don't care.
+ *
+ *	RETURNS:
+ *	Pointer to the found physical link.
+ */
+struct ata_link *ata_dev_phys_link(struct ata_device *dev)
+{
+	struct ata_port *ap = dev->link->ap;
+
+	if (!ap->slave_link)
+		return dev->link;
+	if (!dev->devno)
+		return &ap->link;
+	return ap->slave_link;
+}
+
 /**
  *	ata_force_cbl - force cable type according to libata.force
  *	@ap: ATA port of interest
@@ -206,7 +267,8 @@ void ata_force_cbl(struct ata_port *ap)
  *	the host link and all fan-out ports connected via PMP.  If the
  *	device part is specified as 0 (e.g. 1.00:), it specifies the
  *	first fan-out link not the host link.  Device number 15 always
- *	points to the host link whether PMP is attached or not.
+ *	points to the host link whether PMP is attached or not.  If the
+ *	controller has slave link, device number 16 points to it.
  *
  *	LOCKING:
  *	EH context.
@@ -214,12 +276,11 @@ void ata_force_cbl(struct ata_port *ap)
 static void ata_force_link_limits(struct ata_link *link)
 {
 	bool did_spd = false;
-	int linkno, i;
+	int linkno = link->pmp;
+	int i;
 
 	if (ata_is_host_link(link))
-		linkno = 15;
-	else
-		linkno = link->pmp;
+		linkno += 15;
 
 	for (i = ata_force_tbl_size - 1; i >= 0; i--) {
 		const struct ata_force_ent *fe = &ata_force_tbl[i];
@@ -266,9 +327,9 @@ static void ata_force_xfermask(struct ata_device *dev)
 	int alt_devno = devno;
 	int i;
 
-	/* allow n.15 for the first device attached to host port */
-	if (ata_is_host_link(dev->link) && devno == 0)
-		alt_devno = 15;
+	/* allow n.15/16 for devices attached to host port */
+	if (ata_is_host_link(dev->link))
+		alt_devno += 15;
 
 	for (i = ata_force_tbl_size - 1; i >= 0; i--) {
 		const struct ata_force_ent *fe = &ata_force_tbl[i];
@@ -320,9 +381,9 @@ static void ata_force_horkage(struct ata_device *dev)
 	int alt_devno = devno;
 	int i;
 
-	/* allow n.15 for the first device attached to host port */
-	if (ata_is_host_link(dev->link) && devno == 0)
-		alt_devno = 15;
+	/* allow n.15/16 for devices attached to host port */
+	if (ata_is_host_link(dev->link))
+		alt_devno += 15;
 
 	for (i = 0; i < ata_force_tbl_size; i++) {
 		const struct ata_force_ent *fe = &ata_force_tbl[i];
@@ -2681,7 +2742,7 @@ static void sata_print_link_status(struct ata_link *link)
 		return;
 	sata_scr_read(link, SCR_CONTROL, &scontrol);
 
-	if (ata_link_online(link)) {
+	if (ata_phys_link_online(link)) {
 		tmp = (sstatus >> 4) & 0xf;
 		ata_link_printk(link, KERN_INFO,
 				"SATA link up %s (SStatus %X SControl %X)\n",
@@ -3372,6 +3433,12 @@ int ata_wait_ready(struct ata_link *link, unsigned long deadline,
 	unsigned long nodev_deadline = ata_deadline(start, ATA_TMOUT_FF_WAIT);
 	int warned = 0;
 
+	/* Slave readiness can't be tested separately from master.  On
+	 * M/S emulation configuration, this function should be called
+	 * only on the master and it will handle both master and slave.
+	 */
+	WARN_ON(link == link->ap->slave_link);
+
 	if (time_after(nodev_deadline, deadline))
 		nodev_deadline = deadline;
 
@@ -3593,7 +3660,7 @@ int ata_std_prereset(struct ata_link *link, unsigned long deadline)
 	}
 
 	/* no point in trying softreset on offline link */
-	if (ata_link_offline(link))
+	if (ata_phys_link_offline(link))
 		ehc->i.action &= ~ATA_EH_SOFTRESET;
 
 	return 0;
@@ -3671,7 +3738,7 @@ int sata_link_hardreset(struct ata_link *link, const unsigned long *timing,
 	if (rc)
 		goto out;
 	/* if link is offline nothing more to do */
-	if (ata_link_offline(link))
+	if (ata_phys_link_offline(link))
 		goto out;
 
 	/* Link is online.  From this point, -ENODEV too is an error. */
@@ -4868,10 +4935,8 @@ int sata_scr_valid(struct ata_link *link)
 int sata_scr_read(struct ata_link *link, int reg, u32 *val)
 {
 	if (ata_is_host_link(link)) {
-		struct ata_port *ap = link->ap;
-
 		if (sata_scr_valid(link))
-			return ap->ops->scr_read(ap, reg, val);
+			return link->ap->ops->scr_read(link, reg, val);
 		return -EOPNOTSUPP;
 	}
 
@@ -4897,10 +4962,8 @@ int sata_scr_read(struct ata_link *link, int reg, u32 *val)
 int sata_scr_write(struct ata_link *link, int reg, u32 val)
 {
 	if (ata_is_host_link(link)) {
-		struct ata_port *ap = link->ap;
-
 		if (sata_scr_valid(link))
-			return ap->ops->scr_write(ap, reg, val);
+			return link->ap->ops->scr_write(link, reg, val);
 		return -EOPNOTSUPP;
 	}
 
@@ -4925,13 +4988,12 @@ int sata_scr_write(struct ata_link *link, int reg, u32 val)
 int sata_scr_write_flush(struct ata_link *link, int reg, u32 val)
 {
 	if (ata_is_host_link(link)) {
-		struct ata_port *ap = link->ap;
 		int rc;
 
 		if (sata_scr_valid(link)) {
-			rc = ap->ops->scr_write(ap, reg, val);
+			rc = link->ap->ops->scr_write(link, reg, val);
 			if (rc == 0)
-				rc = ap->ops->scr_read(ap, reg, &val);
+				rc = link->ap->ops->scr_read(link, reg, &val);
 			return rc;
 		}
 		return -EOPNOTSUPP;
@@ -4941,7 +5003,7 @@ int sata_scr_write_flush(struct ata_link *link, int reg, u32 val)
 }
 
 /**
- *	ata_link_online - test whether the given link is online
+ *	ata_phys_link_online - test whether the given link is online
  *	@link: ATA link to test
  *
  *	Test whether @link is online.  Note that this function returns
@@ -4952,20 +5014,20 @@ int sata_scr_write_flush(struct ata_link *link, int reg, u32 val)
  *	None.
  *
  *	RETURNS:
- *	1 if the port online status is available and online.
+ *	True if the port online status is available and online.
  */
-int ata_link_online(struct ata_link *link)
+bool ata_phys_link_online(struct ata_link *link)
 {
 	u32 sstatus;
 
 	if (sata_scr_read(link, SCR_STATUS, &sstatus) == 0 &&
 	    (sstatus & 0xf) == 0x3)
-		return 1;
-	return 0;
+		return true;
+	return false;
 }
 
 /**
- *	ata_link_offline - test whether the given link is offline
+ *	ata_phys_link_offline - test whether the given link is offline
  *	@link: ATA link to test
  *
  *	Test whether @link is offline.  Note that this function
@@ -4976,16 +5038,68 @@ int ata_link_online(struct ata_link *link)
  *	None.
  *
  *	RETURNS:
- *	1 if the port offline status is available and offline.
+ *	True if the port offline status is available and offline.
  */
-int ata_link_offline(struct ata_link *link)
+bool ata_phys_link_offline(struct ata_link *link)
 {
 	u32 sstatus;
 
 	if (sata_scr_read(link, SCR_STATUS, &sstatus) == 0 &&
 	    (sstatus & 0xf) != 0x3)
-		return 1;
-	return 0;
+		return true;
+	return false;
+}
+
+/**
+ *	ata_link_online - test whether the given link is online
+ *	@link: ATA link to test
+ *
+ *	Test whether @link is online.  This is identical to
+ *	ata_phys_link_online() when there's no slave link.  When
+ *	there's a slave link, this function should only be called on
+ *	the master link and will return true if any of M/S links is
+ *	online.
+ *
+ *	LOCKING:
+ *	None.
+ *
+ *	RETURNS:
+ *	True if the port online status is available and online.
+ */
+bool ata_link_online(struct ata_link *link)
+{
+	struct ata_link *slave = link->ap->slave_link;
+
+	WARN_ON(link == slave);	/* shouldn't be called on slave link */
+
+	return ata_phys_link_online(link) ||
+		(slave && ata_phys_link_online(slave));
+}
+
+/**
+ *	ata_link_offline - test whether the given link is offline
+ *	@link: ATA link to test
+ *
+ *	Test whether @link is offline.  This is identical to
+ *	ata_phys_link_offline() when there's no slave link.  When
+ *	there's a slave link, this function should only be called on
+ *	the master link and will return true if both M/S links are
+ *	offline.
+ *
+ *	LOCKING:
+ *	None.
+ *
+ *	RETURNS:
+ *	True if the port offline status is available and offline.
+ */
+bool ata_link_offline(struct ata_link *link)
+{
+	struct ata_link *slave = link->ap->slave_link;
+
+	WARN_ON(link == slave);	/* shouldn't be called on slave link */
+
+	return ata_phys_link_offline(link) &&
+		(!slave || ata_phys_link_offline(slave));
 }
 
 #ifdef CONFIG_PM
@@ -5127,11 +5241,11 @@ int ata_port_start(struct ata_port *ap)
  */
 void ata_dev_init(struct ata_device *dev)
 {
-	struct ata_link *link = dev->link;
+	struct ata_link *link = ata_dev_phys_link(dev);
 	struct ata_port *ap = link->ap;
 	unsigned long flags;
 
-	/* SATA spd limit is bound to the first device */
+	/* SATA spd limit is bound to the attached device, reset together */
 	link->sata_spd_limit = link->hw_sata_spd_limit;
 	link->sata_spd = 0;
 
@@ -5264,6 +5378,7 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	INIT_WORK(&ap->scsi_rescan_task, ata_scsi_dev_rescan);
 	INIT_LIST_HEAD(&ap->eh_done_q);
 	init_waitqueue_head(&ap->eh_wait_q);
+	init_completion(&ap->park_req_pending);
 	init_timer_deferrable(&ap->fastdrain_timer);
 	ap->fastdrain_timer.function = ata_eh_fastdrain_timerfn;
 	ap->fastdrain_timer.data = (unsigned long)ap;
@@ -5294,6 +5409,7 @@ static void ata_host_release(struct device *gendev, void *res)
 			scsi_host_put(ap->scsi_host);
 
 		kfree(ap->pmp_link);
+		kfree(ap->slave_link);
 		kfree(ap);
 		host->ports[i] = NULL;
 	}
@@ -5414,6 +5530,68 @@ struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 	return host;
 }
 
+/**
+ *	ata_slave_link_init - initialize slave link
+ *	@ap: port to initialize slave link for
+ *
+ *	Create and initialize slave link for @ap.  This enables slave
+ *	link handling on the port.
+ *
+ *	In libata, a port contains links and a link contains devices.
+ *	There is single host link but if a PMP is attached to it,
+ *	there can be multiple fan-out links.  On SATA, there's usually
+ *	a single device connected to a link but PATA and SATA
+ *	controllers emulating TF based interface can have two - master
+ *	and slave.
+ *
+ *	However, there are a few controllers which don't fit into this
+ *	abstraction too well - SATA controllers which emulate TF
+ *	interface with both master and slave devices but also have
+ *	separate SCR register sets for each device.  These controllers
+ *	need separate links for physical link handling
+ *	(e.g. onlineness, link speed) but should be treated like a
+ *	traditional M/S controller for everything else (e.g. command
+ *	issue, softreset).
+ *
+ *	slave_link is libata's way of handling this class of
+ *	controllers without impacting core layer too much.  For
+ *	anything other than physical link handling, the default host
+ *	link is used for both master and slave.  For physical link
+ *	handling, separate @ap->slave_link is used.  All dirty details
+ *	are implemented inside libata core layer.  From LLD's POV, the
+ *	only difference is that prereset, hardreset and postreset are
+ *	called once more for the slave link, so the reset sequence
+ *	looks like the following.
+ *
+ *	prereset(M) -> prereset(S) -> hardreset(M) -> hardreset(S) ->
+ *	softreset(M) -> postreset(M) -> postreset(S)
+ *
+ *	Note that softreset is called only for the master.  Softreset
+ *	resets both M/S by definition, so SRST on master should handle
+ *	both (the standard method will work just fine).
+ *
+ *	LOCKING:
+ *	Should be called before host is registered.
+ *
+ *	RETURNS:
+ *	0 on success, -errno on failure.
+ */
+int ata_slave_link_init(struct ata_port *ap)
+{
+	struct ata_link *link;
+
+	WARN_ON(ap->slave_link);
+	WARN_ON(ap->flags & ATA_FLAG_PMP);
+
+	link = kzalloc(sizeof(*link), GFP_KERNEL);
+	if (!link)
+		return -ENOMEM;
+
+	ata_link_init(ap, link, 1);
+	ap->slave_link = link;
+	return 0;
+}
+
 static void ata_host_stop(struct device *gendev, void *res)
 {
 	struct ata_host *host = dev_get_drvdata(gendev);
@@ -5640,6 +5818,8 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 
 		/* init sata_spd_limit to the current value */
 		sata_link_init_spd(&ap->link);
+		if (ap->slave_link)
+			sata_link_init_spd(ap->slave_link);
 
 		/* print per-port info to dmesg */
 		xfer_mask = ata_pack_xfermask(ap->pio_mask, ap->mwdma_mask,
@@ -6260,10 +6440,12 @@ EXPORT_SYMBOL_GPL(ata_base_port_ops);
 EXPORT_SYMBOL_GPL(sata_port_ops);
 EXPORT_SYMBOL_GPL(ata_dummy_port_ops);
 EXPORT_SYMBOL_GPL(ata_dummy_port_info);
+EXPORT_SYMBOL_GPL(__ata_port_next_link);
 EXPORT_SYMBOL_GPL(ata_std_bios_param);
 EXPORT_SYMBOL_GPL(ata_host_init);
 EXPORT_SYMBOL_GPL(ata_host_alloc);
 EXPORT_SYMBOL_GPL(ata_host_alloc_pinfo);
+EXPORT_SYMBOL_GPL(ata_slave_link_init);
 EXPORT_SYMBOL_GPL(ata_host_start);
 EXPORT_SYMBOL_GPL(ata_host_register);
 EXPORT_SYMBOL_GPL(ata_host_activate);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index c1db2f2..f2dd991 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -79,6 +79,8 @@ enum {
 	 */
 	ATA_EH_PRERESET_TIMEOUT		= 10000,
 	ATA_EH_FASTDRAIN_INTERVAL	=  3000,
+
+	ATA_EH_UA_TRIES			= 5,
 };
 
 /* The following table determines how we sequence resets.  Each entry
@@ -1357,6 +1359,37 @@ static int ata_eh_read_log_10h(struct ata_device *dev,
 }
 
 /**
+ *	atapi_eh_tur - perform ATAPI TEST_UNIT_READY
+ *	@dev: target ATAPI device
+ *	@r_sense_key: out parameter for sense_key
+ *
+ *	Perform ATAPI TEST_UNIT_READY.
+ *
+ *	LOCKING:
+ *	EH context (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success, AC_ERR_* mask on failure.
+ */
+static unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key)
+{
+	u8 cdb[ATAPI_CDB_LEN] = { TEST_UNIT_READY, 0, 0, 0, 0, 0 };
+	struct ata_taskfile tf;
+	unsigned int err_mask;
+
+	ata_tf_init(dev, &tf);
+
+	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	tf.command = ATA_CMD_PACKET;
+	tf.protocol = ATAPI_PROT_NODATA;
+
+	err_mask = ata_exec_internal(dev, &tf, cdb, DMA_NONE, NULL, 0, 0);
+	if (err_mask == AC_ERR_DEV)
+		*r_sense_key = tf.feature >> 4;
+	return err_mask;
+}
+
+/**
  *	atapi_eh_request_sense - perform ATAPI REQUEST_SENSE
  *	@dev: device to perform REQUEST_SENSE to
  *	@sense_buf: result sense data buffer (SCSI_SENSE_BUFFERSIZE bytes long)
@@ -1756,7 +1789,7 @@ static unsigned int ata_eh_speed_down_verdict(struct ata_device *dev)
 static unsigned int ata_eh_speed_down(struct ata_device *dev,
 				unsigned int eflags, unsigned int err_mask)
 {
-	struct ata_link *link = dev->link;
+	struct ata_link *link = ata_dev_phys_link(dev);
 	int xfer_ok = 0;
 	unsigned int verdict;
 	unsigned int action = 0;
@@ -1880,7 +1913,8 @@ static void ata_eh_link_autopsy(struct ata_link *link)
 	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
 		struct ata_queued_cmd *qc = __ata_qc_from_tag(ap, tag);
 
-		if (!(qc->flags & ATA_QCFLAG_FAILED) || qc->dev->link != link)
+		if (!(qc->flags & ATA_QCFLAG_FAILED) ||
+		    ata_dev_phys_link(qc->dev) != link)
 			continue;
 
 		/* inherit upper level err_mask */
@@ -1967,6 +2001,23 @@ void ata_eh_autopsy(struct ata_port *ap)
 	ata_port_for_each_link(link, ap)
 		ata_eh_link_autopsy(link);
 
+	/* Handle the frigging slave link.  Autopsy is done similarly
+	 * but actions and flags are transferred over to the master
+	 * link and handled from there.
+	 */
+	if (ap->slave_link) {
+		struct ata_eh_context *mehc = &ap->link.eh_context;
+		struct ata_eh_context *sehc = &ap->slave_link->eh_context;
+
+		ata_eh_link_autopsy(ap->slave_link);
+
+		ata_eh_about_to_do(ap->slave_link, NULL, ATA_EH_ALL_ACTIONS);
+		mehc->i.action		|= sehc->i.action;
+		mehc->i.dev_action[1]	|= sehc->i.dev_action[1];
+		mehc->i.flags		|= sehc->i.flags;
+		ata_eh_done(ap->slave_link, NULL, ATA_EH_ALL_ACTIONS);
+	}
+
 	/* Autopsy of fanout ports can affect host link autopsy.
 	 * Perform host link autopsy last.
 	 */
@@ -2001,7 +2052,8 @@ static void ata_eh_link_report(struct ata_link *link)
 	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
 		struct ata_queued_cmd *qc = __ata_qc_from_tag(ap, tag);
 
-		if (!(qc->flags & ATA_QCFLAG_FAILED) || qc->dev->link != link ||
+		if (!(qc->flags & ATA_QCFLAG_FAILED) ||
+		    ata_dev_phys_link(qc->dev) != link ||
 		    ((qc->flags & ATA_QCFLAG_QUIET) &&
 		     qc->err_mask == AC_ERR_DEV))
 			continue;
@@ -2068,7 +2120,7 @@ static void ata_eh_link_report(struct ata_link *link)
 		char cdb_buf[70] = "";
 
 		if (!(qc->flags & ATA_QCFLAG_FAILED) ||
-		    qc->dev->link != link || !qc->err_mask)
+		    ata_dev_phys_link(qc->dev) != link || !qc->err_mask)
 			continue;
 
 		if (qc->dma_dir != DMA_NONE) {
@@ -2160,12 +2212,14 @@ void ata_eh_report(struct ata_port *ap)
 }
 
 static int ata_do_reset(struct ata_link *link, ata_reset_fn_t reset,
-			unsigned int *classes, unsigned long deadline)
+			unsigned int *classes, unsigned long deadline,
+			bool clear_classes)
 {
 	struct ata_device *dev;
 
-	ata_link_for_each_dev(dev, link)
-		classes[dev->devno] = ATA_DEV_UNKNOWN;
+	if (clear_classes)
+		ata_link_for_each_dev(dev, link)
+			classes[dev->devno] = ATA_DEV_UNKNOWN;
 
 	return reset(link, classes, deadline);
 }
@@ -2187,17 +2241,20 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		 ata_reset_fn_t hardreset, ata_postreset_fn_t postreset)
 {
 	struct ata_port *ap = link->ap;
+	struct ata_link *slave = ap->slave_link;
 	struct ata_eh_context *ehc = &link->eh_context;
+	struct ata_eh_context *sehc = &slave->eh_context;
 	unsigned int *classes = ehc->classes;
 	unsigned int lflags = link->flags;
 	int verbose = !(ehc->i.flags & ATA_EHI_QUIET);
 	int max_tries = 0, try = 0;
+	struct ata_link *failed_link;
 	struct ata_device *dev;
 	unsigned long deadline, now;
 	ata_reset_fn_t reset;
 	unsigned long flags;
 	u32 sstatus;
-	int nr_known, rc;
+	int nr_unknown, rc;
 
 	/*
 	 * Prepare to reset
@@ -2252,8 +2309,30 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	}
 
 	if (prereset) {
-		rc = prereset(link,
-			      ata_deadline(jiffies, ATA_EH_PRERESET_TIMEOUT));
+		unsigned long deadline = ata_deadline(jiffies,
+						      ATA_EH_PRERESET_TIMEOUT);
+
+		if (slave) {
+			sehc->i.action &= ~ATA_EH_RESET;
+			sehc->i.action |= ehc->i.action;
+		}
+
+		rc = prereset(link, deadline);
+
+		/* If present, do prereset on slave link too.  Reset
+		 * is skipped iff both master and slave links report
+		 * -ENOENT or clear ATA_EH_RESET.
+		 */
+		if (slave && (rc == 0 || rc == -ENOENT)) {
+			int tmp;
+
+			tmp = prereset(slave, deadline);
+			if (tmp != -ENOENT)
+				rc = tmp;
+
+			ehc->i.action |= sehc->i.action;
+		}
+
 		if (rc) {
 			if (rc == -ENOENT) {
 				ata_link_printk(link, KERN_DEBUG,
@@ -2302,25 +2381,51 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		else
 			ehc->i.flags |= ATA_EHI_DID_SOFTRESET;
 
-		rc = ata_do_reset(link, reset, classes, deadline);
-		if (rc && rc != -EAGAIN)
+		rc = ata_do_reset(link, reset, classes, deadline, true);
+		if (rc && rc != -EAGAIN) {
+			failed_link = link;
 			goto fail;
+		}
+
+		/* hardreset slave link if existent */
+		if (slave && reset == hardreset) {
+			int tmp;
+
+			if (verbose)
+				ata_link_printk(slave, KERN_INFO,
+						"hard resetting link\n");
 
+			ata_eh_about_to_do(slave, NULL, ATA_EH_RESET);
+			tmp = ata_do_reset(slave, reset, classes, deadline,
+					   false);
+			switch (tmp) {
+			case -EAGAIN:
+				rc = -EAGAIN;
+			case 0:
+				break;
+			default:
+				failed_link = slave;
+				rc = tmp;
+				goto fail;
+			}
+		}
+
+		/* perform follow-up SRST if necessary */
 		if (reset == hardreset &&
 		    ata_eh_followup_srst_needed(link, rc, classes)) {
-			/* okay, let's do follow-up softreset */
 			reset = softreset;
 
 			if (!reset) {
 				ata_link_printk(link, KERN_ERR,
 						"follow-up softreset required "
 						"but no softreset avaliable\n");
+				failed_link = link;
 				rc = -EINVAL;
 				goto fail;
 			}
 
 			ata_eh_about_to_do(link, NULL, ATA_EH_RESET);
-			rc = ata_do_reset(link, reset, classes, deadline);
+			rc = ata_do_reset(link, reset, classes, deadline, true);
 		}
 	} else {
 		if (verbose)
@@ -2341,7 +2446,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		dev->pio_mode = XFER_PIO_0;
 		dev->flags &= ~ATA_DFLAG_SLEEPING;
 
-		if (ata_link_offline(link))
+		if (ata_phys_link_offline(ata_dev_phys_link(dev)))
 			continue;
 
 		/* apply class override */
@@ -2354,6 +2459,8 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	/* record current link speed */
 	if (sata_scr_read(link, SCR_STATUS, &sstatus) == 0)
 		link->sata_spd = (sstatus >> 4) & 0xf;
+	if (slave && sata_scr_read(slave, SCR_STATUS, &sstatus) == 0)
+		slave->sata_spd = (sstatus >> 4) & 0xf;
 
 	/* thaw the port */
 	if (ata_is_host_link(link))
@@ -2366,12 +2473,17 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	 * reset and here.  This race is mediated by cross checking
 	 * link onlineness and classification result later.
 	 */
-	if (postreset)
+	if (postreset) {
 		postreset(link, classes);
+		if (slave)
+			postreset(slave, classes);
+	}
 
 	/* clear cached SError */
 	spin_lock_irqsave(link->ap->lock, flags);
 	link->eh_info.serror = 0;
+	if (slave)
+		slave->eh_info.serror = 0;
 	spin_unlock_irqrestore(link->ap->lock, flags);
 
 	/* Make sure onlineness and classification result correspond.
@@ -2381,19 +2493,21 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	 * link onlineness and classification result, those conditions
 	 * can be reliably detected and retried.
 	 */
-	nr_known = 0;
+	nr_unknown = 0;
 	ata_link_for_each_dev(dev, link) {
 		/* convert all ATA_DEV_UNKNOWN to ATA_DEV_NONE */
-		if (classes[dev->devno] == ATA_DEV_UNKNOWN)
+		if (classes[dev->devno] == ATA_DEV_UNKNOWN) {
 			classes[dev->devno] = ATA_DEV_NONE;
-		else
-			nr_known++;
+			if (ata_phys_link_online(ata_dev_phys_link(dev)))
+				nr_unknown++;
+		}
 	}
 
-	if (classify && !nr_known && ata_link_online(link)) {
+	if (classify && nr_unknown) {
 		if (try < max_tries) {
 			ata_link_printk(link, KERN_WARNING, "link online but "
 				       "device misclassified, retrying\n");
+			failed_link = link;
 			rc = -EAGAIN;
 			goto fail;
 		}
@@ -2404,6 +2518,8 @@ int ata_eh_reset(struct ata_link *link, int classify,
 
 	/* reset successful, schedule revalidation */
 	ata_eh_done(link, NULL, ATA_EH_RESET);
+	if (slave)
+		ata_eh_done(slave, NULL, ATA_EH_RESET);
 	ehc->last_reset = jiffies;
 	ehc->i.action |= ATA_EH_REVALIDATE;
 
@@ -2411,6 +2527,8 @@ int ata_eh_reset(struct ata_link *link, int classify,
  out:
 	/* clear hotplug flag */
 	ehc->i.flags &= ~ATA_EHI_HOTPLUGGED;
+	if (slave)
+		sehc->i.flags &= ~ATA_EHI_HOTPLUGGED;
 
 	spin_lock_irqsave(ap->lock, flags);
 	ap->pflags &= ~ATA_PFLAG_RESETTING;
@@ -2431,7 +2549,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	if (time_before(now, deadline)) {
 		unsigned long delta = deadline - now;
 
-		ata_link_printk(link, KERN_WARNING,
+		ata_link_printk(failed_link, KERN_WARNING,
 			"reset failed (errno=%d), retrying in %u secs\n",
 			rc, DIV_ROUND_UP(jiffies_to_msecs(delta), 1000));
 
@@ -2439,13 +2557,92 @@ int ata_eh_reset(struct ata_link *link, int classify,
 			delta = schedule_timeout_uninterruptible(delta);
 	}
 
-	if (rc == -EPIPE || try == max_tries - 1)
+	if (try == max_tries - 1) {
 		sata_down_spd_limit(link);
+		if (slave)
+			sata_down_spd_limit(slave);
+	} else if (rc == -EPIPE)
+		sata_down_spd_limit(failed_link);
+
 	if (hardreset)
 		reset = hardreset;
 	goto retry;
 }
 
+static inline void ata_eh_pull_park_action(struct ata_port *ap)
+{
+	struct ata_link *link;
+	struct ata_device *dev;
+	unsigned long flags;
+
+	/*
+	 * This function can be thought of as an extended version of
+	 * ata_eh_about_to_do() specially crafted to accommodate the
+	 * requirements of ATA_EH_PARK handling. Since the EH thread
+	 * does not leave the do {} while () loop in ata_eh_recover as
+	 * long as the timeout for a park request to *one* device on
+	 * the port has not expired, and since we still want to pick
+	 * up park requests to other devices on the same port or
+	 * timeout updates for the same device, we have to pull
+	 * ATA_EH_PARK actions from eh_info into eh_context.i
+	 * ourselves at the beginning of each pass over the loop.
+	 *
+	 * Additionally, all write accesses to &ap->park_req_pending
+	 * through INIT_COMPLETION() (see below) or complete_all()
+	 * (see ata_scsi_park_store()) are protected by the host lock.
+	 * As a result we have that park_req_pending.done is zero on
+	 * exit from this function, i.e. when ATA_EH_PARK actions for
+	 * *all* devices on port ap have been pulled into the
+	 * respective eh_context structs. If, and only if,
+	 * park_req_pending.done is non-zero by the time we reach
+	 * wait_for_completion_timeout(), another ATA_EH_PARK action
+	 * has been scheduled for at least one of the devices on port
+	 * ap and we have to cycle over the do {} while () loop in
+	 * ata_eh_recover() again.
+	 */
+
+	spin_lock_irqsave(ap->lock, flags);
+	INIT_COMPLETION(ap->park_req_pending);
+	ata_port_for_each_link(link, ap) {
+		ata_link_for_each_dev(dev, link) {
+			struct ata_eh_info *ehi = &link->eh_info;
+
+			link->eh_context.i.dev_action[dev->devno] |=
+				ehi->dev_action[dev->devno] & ATA_EH_PARK;
+			ata_eh_clear_action(link, dev, ehi, ATA_EH_PARK);
+		}
+	}
+	spin_unlock_irqrestore(ap->lock, flags);
+}
+
+static void ata_eh_park_issue_cmd(struct ata_device *dev, int park)
+{
+	struct ata_eh_context *ehc = &dev->link->eh_context;
+	struct ata_taskfile tf;
+	unsigned int err_mask;
+
+	ata_tf_init(dev, &tf);
+	if (park) {
+		ehc->unloaded_mask |= 1 << dev->devno;
+		tf.command = ATA_CMD_IDLEIMMEDIATE;
+		tf.feature = 0x44;
+		tf.lbal = 0x4c;
+		tf.lbam = 0x4e;
+		tf.lbah = 0x55;
+	} else {
+		ehc->unloaded_mask &= ~(1 << dev->devno);
+		tf.command = ATA_CMD_CHK_POWER;
+	}
+
+	tf.flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
+	tf.protocol |= ATA_PROT_NODATA;
+	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
+	if (park && (err_mask || tf.lbal != 0xc4)) {
+		ata_dev_printk(dev, KERN_ERR, "head unload failed!\n");
+		ehc->unloaded_mask &= ~(1 << dev->devno);
+	}
+}
+
 static int ata_eh_revalidate_and_attach(struct ata_link *link,
 					struct ata_device **r_failed_dev)
 {
@@ -2472,7 +2669,7 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 		if ((action & ATA_EH_REVALIDATE) && ata_dev_enabled(dev)) {
 			WARN_ON(dev->class == ATA_DEV_PMP);
 
-			if (ata_link_offline(link)) {
+			if (ata_phys_link_offline(ata_dev_phys_link(dev))) {
 				rc = -EIO;
 				goto err;
 			}
@@ -2610,6 +2807,53 @@ int ata_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 	return rc;
 }
 
+/**
+ *	atapi_eh_clear_ua - Clear ATAPI UNIT ATTENTION after reset
+ *	@dev: ATAPI device to clear UA for
+ *
+ *	Resets and other operations can make an ATAPI device raise
+ *	UNIT ATTENTION which causes the next operation to fail.  This
+ *	function clears UA.
+ *
+ *	LOCKING:
+ *	EH context (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success, -errno on failure.
+ */
+static int atapi_eh_clear_ua(struct ata_device *dev)
+{
+	int i;
+
+	for (i = 0; i < ATA_EH_UA_TRIES; i++) {
+		u8 sense_buffer[SCSI_SENSE_BUFFERSIZE];
+		u8 sense_key = 0;
+		unsigned int err_mask;
+
+		err_mask = atapi_eh_tur(dev, &sense_key);
+		if (err_mask != 0 && err_mask != AC_ERR_DEV) {
+			ata_dev_printk(dev, KERN_WARNING, "TEST_UNIT_READY "
+				"failed (err_mask=0x%x)\n", err_mask);
+			return -EIO;
+		}
+
+		if (!err_mask || sense_key != UNIT_ATTENTION)
+			return 0;
+
+		err_mask = atapi_eh_request_sense(dev, sense_buffer, sense_key);
+		if (err_mask) {
+			ata_dev_printk(dev, KERN_WARNING, "failed to clear "
+				"UNIT ATTENTION (err_mask=0x%x)\n", err_mask);
+			return -EIO;
+		}
+	}
+
+	ata_dev_printk(dev, KERN_WARNING,
+		"UNIT ATTENTION persists after %d tries\n", ATA_EH_UA_TRIES);
+
+	return 0;
+}
+
 static int ata_link_nr_enabled(struct ata_link *link)
 {
 	struct ata_device *dev;
@@ -2697,7 +2941,7 @@ static int ata_eh_handle_dev_fail(struct ata_device *dev, int err)
 			/* This is the last chance, better to slow
 			 * down than lose it.
 			 */
-			sata_down_spd_limit(dev->link);
+			sata_down_spd_limit(ata_dev_phys_link(dev));
 			ata_down_xfermask_limit(dev, ATA_DNXFER_PIO);
 		}
 	}
@@ -2707,7 +2951,7 @@ static int ata_eh_handle_dev_fail(struct ata_device *dev, int err)
 		ata_dev_disable(dev);
 
 		/* detach if offline */
-		if (ata_link_offline(dev->link))
+		if (ata_phys_link_offline(ata_dev_phys_link(dev)))
 			ata_eh_detach_dev(dev);
 
 		/* schedule probe if necessary */
@@ -2755,7 +2999,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 	struct ata_device *dev;
 	int nr_failed_devs;
 	int rc;
-	unsigned long flags;
+	unsigned long flags, deadline;
 
 	DPRINTK("ENTER\n");
 
@@ -2829,6 +3073,56 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 		}
 	}
 
+	do {
+		unsigned long now;
+
+		/*
+		 * clears ATA_EH_PARK in eh_info and resets
+		 * ap->park_req_pending
+		 */
+		ata_eh_pull_park_action(ap);
+
+		deadline = jiffies;
+		ata_port_for_each_link(link, ap) {
+			ata_link_for_each_dev(dev, link) {
+				struct ata_eh_context *ehc = &link->eh_context;
+				unsigned long tmp;
+
+				if (dev->class != ATA_DEV_ATA)
+					continue;
+				if (!(ehc->i.dev_action[dev->devno] &
+				      ATA_EH_PARK))
+					continue;
+				tmp = dev->unpark_deadline;
+				if (time_before(deadline, tmp))
+					deadline = tmp;
+				else if (time_before_eq(tmp, jiffies))
+					continue;
+				if (ehc->unloaded_mask & (1 << dev->devno))
+					continue;
+
+				ata_eh_park_issue_cmd(dev, 1);
+			}
+		}
+
+		now = jiffies;
+		if (time_before_eq(deadline, now))
+			break;
+
+		deadline = wait_for_completion_timeout(&ap->park_req_pending,
+						       deadline - now);
+	} while (deadline);
+	ata_port_for_each_link(link, ap) {
+		ata_link_for_each_dev(dev, link) {
+			if (!(link->eh_context.unloaded_mask &
+			      (1 << dev->devno)))
+				continue;
+
+			ata_eh_park_issue_cmd(dev, 0);
+			ata_eh_done(link, dev, ATA_EH_PARK);
+		}
+	}
+
 	/* the rest */
 	ata_port_for_each_link(link, ap) {
 		struct ata_eh_context *ehc = &link->eh_context;
@@ -2852,6 +3146,20 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 			ehc->i.flags &= ~ATA_EHI_SETMODE;
 		}
 
+		/* If reset has been issued, clear UA to avoid
+		 * disrupting the current users of the device.
+		 */
+		if (ehc->i.flags & ATA_EHI_DID_RESET) {
+			ata_link_for_each_dev(dev, link) {
+				if (dev->class != ATA_DEV_ATAPI)
+					continue;
+				rc = atapi_eh_clear_ua(dev);
+				if (rc)
+					goto dev_fail;
+			}
+		}
+
+		/* configure link power saving */
 		if (ehc->i.action & ATA_EH_LPM)
 			ata_link_for_each_dev(dev, link)
 				ata_dev_enable_pm(dev, ap->pm_policy);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b9d3ba4..fccd5e4 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -183,6 +183,105 @@ DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
 		ata_scsi_lpm_show, ata_scsi_lpm_put);
 EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);
 
+static ssize_t ata_scsi_park_show(struct device *device,
+				  struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct ata_port *ap;
+	struct ata_link *link;
+	struct ata_device *dev;
+	unsigned long flags;
+	unsigned int uninitialized_var(msecs);
+	int rc = 0;
+
+	ap = ata_shost_to_port(sdev->host);
+
+	spin_lock_irqsave(ap->lock, flags);
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (!dev) {
+		rc = -ENODEV;
+		goto unlock;
+	}
+	if (dev->flags & ATA_DFLAG_NO_UNLOAD) {
+		rc = -EOPNOTSUPP;
+		goto unlock;
+	}
+
+	link = dev->link;
+	if (ap->pflags & ATA_PFLAG_EH_IN_PROGRESS &&
+	    link->eh_context.unloaded_mask & (1 << dev->devno) &&
+	    time_after(dev->unpark_deadline, jiffies))
+		msecs = jiffies_to_msecs(dev->unpark_deadline - jiffies);
+	else
+		msecs = 0;
+
+unlock:
+	spin_unlock_irq(ap->lock);
+
+	return rc ? rc : snprintf(buf, 20, "%u\n", msecs);
+}
+
+static ssize_t ata_scsi_park_store(struct device *device,
+				   struct device_attribute *attr,
+				   const char *buf, size_t len)
+{
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct ata_port *ap;
+	struct ata_device *dev;
+	long int input;
+	unsigned long flags;
+	int rc;
+
+	rc = strict_strtol(buf, 10, &input);
+	if (rc || input < -2)
+		return -EINVAL;
+	if (input > ATA_TMOUT_MAX_PARK) {
+		rc = -EOVERFLOW;
+		input = ATA_TMOUT_MAX_PARK;
+	}
+
+	ap = ata_shost_to_port(sdev->host);
+
+	spin_lock_irqsave(ap->lock, flags);
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (unlikely(!dev)) {
+		rc = -ENODEV;
+		goto unlock;
+	}
+	if (dev->class != ATA_DEV_ATA) {
+		rc = -EOPNOTSUPP;
+		goto unlock;
+	}
+
+	if (input >= 0) {
+		if (dev->flags & ATA_DFLAG_NO_UNLOAD) {
+			rc = -EOPNOTSUPP;
+			goto unlock;
+		}
+
+		dev->unpark_deadline = ata_deadline(jiffies, input);
+		dev->link->eh_info.dev_action[dev->devno] |= ATA_EH_PARK;
+		ata_port_schedule_eh(ap);
+		complete(&ap->park_req_pending);
+	} else {
+		switch (input) {
+		case -1:
+			dev->flags &= ~ATA_DFLAG_NO_UNLOAD;
+			break;
+		case -2:
+			dev->flags |= ATA_DFLAG_NO_UNLOAD;
+			break;
+		}
+	}
+unlock:
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	return rc ? rc : len;
+}
+DEVICE_ATTR(unload_heads, S_IRUGO | S_IWUSR,
+	    ata_scsi_park_show, ata_scsi_park_store);
+EXPORT_SYMBOL_GPL(dev_attr_unload_heads);
+
 static void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
 {
 	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
@@ -269,6 +368,12 @@ DEVICE_ATTR(sw_activity, S_IWUGO | S_IRUGO, ata_scsi_activity_show,
 			ata_scsi_activity_store);
 EXPORT_SYMBOL_GPL(dev_attr_sw_activity);
 
+struct device_attribute *ata_common_sdev_attrs[] = {
+	&dev_attr_unload_heads,
+	NULL
+};
+EXPORT_SYMBOL_GPL(ata_common_sdev_attrs);
+
 static void ata_scsi_invalid_field(struct scsi_cmnd *cmd,
 				   void (*done)(struct scsi_cmnd *))
 {
@@ -954,6 +1059,9 @@ static int atapi_drain_needed(struct request *rq)
 static int ata_scsi_dev_config(struct scsi_device *sdev,
 			       struct ata_device *dev)
 {
+	if (!ata_id_has_unload(dev->id))
+		dev->flags |= ATA_DFLAG_NO_UNLOAD;
+
 	/* configure max sectors */
 	blk_queue_max_sectors(sdev->request_queue, dev->max_sectors);
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index ade5c75..e96de96 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -70,6 +70,7 @@ extern int atapi_passthru16;
 extern int libata_fua;
 extern int libata_noacpi;
 extern int libata_allow_tpm;
+extern struct ata_link *ata_dev_phys_link(struct ata_device *dev);
 extern void ata_force_cbl(struct ata_port *ap);
 extern u64 ata_tf_to_lba(const struct ata_taskfile *tf);
 extern u64 ata_tf_to_lba48(const struct ata_taskfile *tf);
@@ -107,6 +108,8 @@ extern void ata_qc_issue(struct ata_queued_cmd *qc);
 extern void __ata_qc_complete(struct ata_queued_cmd *qc);
 extern int atapi_check_dma(struct ata_queued_cmd *qc);
 extern void swap_buf_le16(u16 *buf, unsigned int buf_words);
+extern bool ata_phys_link_online(struct ata_link *link);
+extern bool ata_phys_link_offline(struct ata_link *link);
 extern void ata_dev_init(struct ata_device *dev);
 extern void ata_link_init(struct ata_port *ap, struct ata_link *link, int pmp);
 extern int sata_link_init_spd(struct ata_link *link);
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index d393290..1266924 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1632,6 +1632,8 @@ static int __devinit bfin_atapi_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	dev_set_drvdata(&pdev->dev, host);
+
 	return 0;
 }
 
@@ -1648,6 +1650,7 @@ static int __devexit bfin_atapi_remove(struct platform_device *pdev)
 	struct ata_host *host = dev_get_drvdata(dev);
 
 	ata_host_detach(host);
+	dev_set_drvdata(&pdev->dev, NULL);
 
 	peripheral_free_list(atapi_io_port);
 
@@ -1655,27 +1658,44 @@ static int __devexit bfin_atapi_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-int bfin_atapi_suspend(struct platform_device *pdev, pm_message_t state)
+static int bfin_atapi_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	return 0;
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	if (host)
+		return ata_host_suspend(host, state);
+	else
+		return 0;
 }
 
-int bfin_atapi_resume(struct platform_device *pdev)
+static int bfin_atapi_resume(struct platform_device *pdev)
 {
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int ret;
+
+	if (host) {
+		ret = bfin_reset_controller(host);
+		if (ret) {
+			printk(KERN_ERR DRV_NAME ": Error during HW init\n");
+			return ret;
+		}
+		ata_host_resume(host);
+	}
+
 	return 0;
 }
+#else
+#define bfin_atapi_suspend NULL
+#define bfin_atapi_resume NULL
 #endif
 
 static struct platform_driver bfin_atapi_driver = {
 	.probe			= bfin_atapi_probe,
 	.remove			= __devexit_p(bfin_atapi_remove),
+	.suspend		= bfin_atapi_suspend,
+	.resume			= bfin_atapi_resume,
 	.driver = {
 		.name		= DRV_NAME,
 		.owner		= THIS_MODULE,
-#ifdef CONFIG_PM
-		.suspend	= bfin_atapi_suspend,
-		.resume		= bfin_atapi_resume,
-#endif
 	},
 };
 
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index e970b22..a598bb3 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -230,7 +230,7 @@ static u8 sil680_init_chip(struct pci_dev *pdev, int *try_mmio)
 		tmpbyte & 1, tmpbyte & 0x30);
 
 	*try_mmio = 0;
-#ifdef CONFIG_PPC_MERGE
+#ifdef CONFIG_PPC
 	if (machine_is(cell))
 		*try_mmio = (tmpbyte & 1) || pci_resource_start(pdev, 5);
 #endif
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 3924e72..1a56db9 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -469,10 +469,10 @@ static bool sata_fsl_qc_fill_rtf(struct ata_queued_cmd *qc)
 	return true;
 }
 
-static int sata_fsl_scr_write(struct ata_port *ap, unsigned int sc_reg_in,
-			       u32 val)
+static int sata_fsl_scr_write(struct ata_link *link,
+			      unsigned int sc_reg_in, u32 val)
 {
-	struct sata_fsl_host_priv *host_priv = ap->host->private_data;
+	struct sata_fsl_host_priv *host_priv = link->ap->host->private_data;
 	void __iomem *ssr_base = host_priv->ssr_base;
 	unsigned int sc_reg;
 
@@ -493,10 +493,10 @@ static int sata_fsl_scr_write(struct ata_port *ap, unsigned int sc_reg_in,
 	return 0;
 }
 
-static int sata_fsl_scr_read(struct ata_port *ap, unsigned int sc_reg_in,
-			u32 *val)
+static int sata_fsl_scr_read(struct ata_link *link,
+			     unsigned int sc_reg_in, u32 *val)
 {
-	struct sata_fsl_host_priv *host_priv = ap->host->private_data;
+	struct sata_fsl_host_priv *host_priv = link->ap->host->private_data;
 	void __iomem *ssr_base = host_priv->ssr_base;
 	unsigned int sc_reg;
 
@@ -645,12 +645,12 @@ static int sata_fsl_port_start(struct ata_port *ap)
 	 * Workaround for 8315DS board 3gbps link-up issue,
 	 * currently limit SATA port to GEN1 speed
 	 */
-	sata_fsl_scr_read(ap, SCR_CONTROL, &temp);
+	sata_fsl_scr_read(&ap->link, SCR_CONTROL, &temp);
 	temp &= ~(0xF << 4);
 	temp |= (0x1 << 4);
-	sata_fsl_scr_write(ap, SCR_CONTROL, temp);
+	sata_fsl_scr_write(&ap->link, SCR_CONTROL, temp);
 
-	sata_fsl_scr_read(ap, SCR_CONTROL, &temp);
+	sata_fsl_scr_read(&ap->link, SCR_CONTROL, &temp);
 	dev_printk(KERN_WARNING, dev, "scr_control, speed limited to %x\n",
 			temp);
 #endif
@@ -868,7 +868,7 @@ issue_srst:
 			ioread32(CQ + hcr_base),
 			ioread32(CA + hcr_base), ioread32(CC + hcr_base));
 
-		sata_fsl_scr_read(ap, SCR_ERROR, &Serror);
+		sata_fsl_scr_read(&ap->link, SCR_ERROR, &Serror);
 
 		DPRINTK("HStatus = 0x%x\n", ioread32(hcr_base + HSTATUS));
 		DPRINTK("HControl = 0x%x\n", ioread32(hcr_base + HCONTROL));
@@ -972,9 +972,9 @@ static void sata_fsl_error_intr(struct ata_port *ap)
 	 * Handle & Clear SError
 	 */
 
-	sata_fsl_scr_read(ap, SCR_ERROR, &SError);
+	sata_fsl_scr_read(&ap->link, SCR_ERROR, &SError);
 	if (unlikely(SError & 0xFFFF0000)) {
-		sata_fsl_scr_write(ap, SCR_ERROR, SError);
+		sata_fsl_scr_write(&ap->link, SCR_ERROR, SError);
 	}
 
 	DPRINTK("error_intr,hStat=0x%x,CE=0x%x,DE =0x%x,SErr=0x%x\n",
@@ -1091,7 +1091,7 @@ static void sata_fsl_host_intr(struct ata_port *ap)
 
 	hstatus = ioread32(hcr_base + HSTATUS);
 
-	sata_fsl_scr_read(ap, SCR_ERROR, &SError);
+	sata_fsl_scr_read(&ap->link, SCR_ERROR, &SError);
 
 	if (unlikely(SError & 0xFFFF0000)) {
 		DPRINTK("serror @host_intr : 0x%x\n", SError);
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 5032c32..fbbd87c 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -269,9 +269,9 @@ static void inic_reset_port(void __iomem *port_base)
 	writeb(0xff, port_base + PORT_IRQ_STAT);
 }
 
-static int inic_scr_read(struct ata_port *ap, unsigned sc_reg, u32 *val)
+static int inic_scr_read(struct ata_link *link, unsigned sc_reg, u32 *val)
 {
-	void __iomem *scr_addr = inic_port_base(ap) + PORT_SCR;
+	void __iomem *scr_addr = inic_port_base(link->ap) + PORT_SCR;
 	void __iomem *addr;
 
 	if (unlikely(sc_reg >= ARRAY_SIZE(scr_map)))
@@ -286,9 +286,9 @@ static int inic_scr_read(struct ata_port *ap, unsigned sc_reg, u32 *val)
 	return 0;
 }
 
-static int inic_scr_write(struct ata_port *ap, unsigned sc_reg, u32 val)
+static int inic_scr_write(struct ata_link *link, unsigned sc_reg, u32 val)
 {
-	void __iomem *scr_addr = inic_port_base(ap) + PORT_SCR;
+	void __iomem *scr_addr = inic_port_base(link->ap) + PORT_SCR;
 
 	if (unlikely(sc_reg >= ARRAY_SIZE(scr_map)))
 		return -EINVAL;
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index c815f8e..2b24ae5 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -493,10 +493,10 @@ struct mv_hw_ops {
 	void (*reset_bus)(struct ata_host *host, void __iomem *mmio);
 };
 
-static int mv_scr_read(struct ata_port *ap, unsigned int sc_reg_in, u32 *val);
-static int mv_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val);
-static int mv5_scr_read(struct ata_port *ap, unsigned int sc_reg_in, u32 *val);
-static int mv5_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val);
+static int mv_scr_read(struct ata_link *link, unsigned int sc_reg_in, u32 *val);
+static int mv_scr_write(struct ata_link *link, unsigned int sc_reg_in, u32 val);
+static int mv5_scr_read(struct ata_link *link, unsigned int sc_reg_in, u32 *val);
+static int mv5_scr_write(struct ata_link *link, unsigned int sc_reg_in, u32 val);
 static int mv_port_start(struct ata_port *ap);
 static void mv_port_stop(struct ata_port *ap);
 static int mv_qc_defer(struct ata_queued_cmd *qc);
@@ -1070,23 +1070,23 @@ static unsigned int mv_scr_offset(unsigned int sc_reg_in)
 	return ofs;
 }
 
-static int mv_scr_read(struct ata_port *ap, unsigned int sc_reg_in, u32 *val)
+static int mv_scr_read(struct ata_link *link, unsigned int sc_reg_in, u32 *val)
 {
 	unsigned int ofs = mv_scr_offset(sc_reg_in);
 
 	if (ofs != 0xffffffffU) {
-		*val = readl(mv_ap_base(ap) + ofs);
+		*val = readl(mv_ap_base(link->ap) + ofs);
 		return 0;
 	} else
 		return -EINVAL;
 }
 
-static int mv_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val)
+static int mv_scr_write(struct ata_link *link, unsigned int sc_reg_in, u32 val)
 {
 	unsigned int ofs = mv_scr_offset(sc_reg_in);
 
 	if (ofs != 0xffffffffU) {
-		writelfl(val, mv_ap_base(ap) + ofs);
+		writelfl(val, mv_ap_base(link->ap) + ofs);
 		return 0;
 	} else
 		return -EINVAL;
@@ -2251,11 +2251,11 @@ static unsigned int mv5_scr_offset(unsigned int sc_reg_in)
 	return ofs;
 }
 
-static int mv5_scr_read(struct ata_port *ap, unsigned int sc_reg_in, u32 *val)
+static int mv5_scr_read(struct ata_link *link, unsigned int sc_reg_in, u32 *val)
 {
-	struct mv_host_priv *hpriv = ap->host->private_data;
+	struct mv_host_priv *hpriv = link->ap->host->private_data;
 	void __iomem *mmio = hpriv->base;
-	void __iomem *addr = mv5_phy_base(mmio, ap->port_no);
+	void __iomem *addr = mv5_phy_base(mmio, link->ap->port_no);
 	unsigned int ofs = mv5_scr_offset(sc_reg_in);
 
 	if (ofs != 0xffffffffU) {
@@ -2265,11 +2265,11 @@ static int mv5_scr_read(struct ata_port *ap, unsigned int sc_reg_in, u32 *val)
 		return -EINVAL;
 }
 
-static int mv5_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val)
+static int mv5_scr_write(struct ata_link *link, unsigned int sc_reg_in, u32 val)
 {
-	struct mv_host_priv *hpriv = ap->host->private_data;
+	struct mv_host_priv *hpriv = link->ap->host->private_data;
 	void __iomem *mmio = hpriv->base;
-	void __iomem *addr = mv5_phy_base(mmio, ap->port_no);
+	void __iomem *addr = mv5_phy_base(mmio, link->ap->port_no);
 	unsigned int ofs = mv5_scr_offset(sc_reg_in);
 
 	if (ofs != 0xffffffffU) {
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 1e1f3f3..88fd4ae 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -302,8 +302,8 @@ static void nv_ck804_host_stop(struct ata_host *host);
 static irqreturn_t nv_generic_interrupt(int irq, void *dev_instance);
 static irqreturn_t nv_nf2_interrupt(int irq, void *dev_instance);
 static irqreturn_t nv_ck804_interrupt(int irq, void *dev_instance);
-static int nv_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
-static int nv_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int nv_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
+static int nv_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 
 static void nv_nf2_freeze(struct ata_port *ap);
 static void nv_nf2_thaw(struct ata_port *ap);
@@ -1492,21 +1492,21 @@ static irqreturn_t nv_ck804_interrupt(int irq, void *dev_instance)
 	return ret;
 }
 
-static int nv_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int nv_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
 
-	*val = ioread32(ap->ioaddr.scr_addr + (sc_reg * 4));
+	*val = ioread32(link->ap->ioaddr.scr_addr + (sc_reg * 4));
 	return 0;
 }
 
-static int nv_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int nv_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
 
-	iowrite32(val, ap->ioaddr.scr_addr + (sc_reg * 4));
+	iowrite32(val, link->ap->ioaddr.scr_addr + (sc_reg * 4));
 	return 0;
 }
 
@@ -2184,9 +2184,9 @@ static void nv_swncq_host_interrupt(struct ata_port *ap, u16 fis)
 	if (!pp->qc_active)
 		return;
 
-	if (ap->ops->scr_read(ap, SCR_ERROR, &serror))
+	if (ap->ops->scr_read(&ap->link, SCR_ERROR, &serror))
 		return;
-	ap->ops->scr_write(ap, SCR_ERROR, serror);
+	ap->ops->scr_write(&ap->link, SCR_ERROR, serror);
 
 	if (ata_stat & ATA_ERR) {
 		ata_ehi_clear_desc(ehi);
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 030665b..750d8cd 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -137,8 +137,8 @@ struct pdc_port_priv {
 	dma_addr_t		pkt_dma;
 };
 
-static int pdc_sata_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
-static int pdc_sata_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int pdc_sata_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
+static int pdc_sata_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static int pdc_ata_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static int pdc_common_port_start(struct ata_port *ap);
 static int pdc_sata_port_start(struct ata_port *ap);
@@ -386,19 +386,21 @@ static int pdc_sata_cable_detect(struct ata_port *ap)
 	return ATA_CBL_SATA;
 }
 
-static int pdc_sata_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int pdc_sata_scr_read(struct ata_link *link,
+			     unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
-	*val = readl(ap->ioaddr.scr_addr + (sc_reg * 4));
+	*val = readl(link->ap->ioaddr.scr_addr + (sc_reg * 4));
 	return 0;
 }
 
-static int pdc_sata_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int pdc_sata_scr_write(struct ata_link *link,
+			      unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
-	writel(val, ap->ioaddr.scr_addr + (sc_reg * 4));
+	writel(val, link->ap->ioaddr.scr_addr + (sc_reg * 4));
 	return 0;
 }
 
@@ -731,7 +733,7 @@ static void pdc_error_intr(struct ata_port *ap, struct ata_queued_cmd *qc,
 	if (sata_scr_valid(&ap->link)) {
 		u32 serror;
 
-		pdc_sata_scr_read(ap, SCR_ERROR, &serror);
+		pdc_sata_scr_read(&ap->link, SCR_ERROR, &serror);
 		ehi->serror |= serror;
 	}
 
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 1600107..a000c86 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -111,8 +111,8 @@ struct qs_port_priv {
 	qs_state_t		state;
 };
 
-static int qs_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
-static int qs_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int qs_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
+static int qs_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static int qs_ata_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static int qs_port_start(struct ata_port *ap);
 static void qs_host_stop(struct ata_host *host);
@@ -242,11 +242,11 @@ static int qs_prereset(struct ata_link *link, unsigned long deadline)
 	return ata_sff_prereset(link, deadline);
 }
 
-static int qs_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int qs_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
-	*val = readl(ap->ioaddr.scr_addr + (sc_reg * 8));
+	*val = readl(link->ap->ioaddr.scr_addr + (sc_reg * 8));
 	return 0;
 }
 
@@ -256,11 +256,11 @@ static void qs_error_handler(struct ata_port *ap)
 	ata_std_error_handler(ap);
 }
 
-static int qs_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int qs_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
-	writel(val, ap->ioaddr.scr_addr + (sc_reg * 8));
+	writel(val, link->ap->ioaddr.scr_addr + (sc_reg * 8));
 	return 0;
 }
 
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 88bf421..031d7b7 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -115,8 +115,8 @@ static int sil_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static int sil_pci_device_resume(struct pci_dev *pdev);
 #endif
 static void sil_dev_config(struct ata_device *dev);
-static int sil_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
-static int sil_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int sil_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
+static int sil_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static int sil_set_mode(struct ata_link *link, struct ata_device **r_failed);
 static void sil_freeze(struct ata_port *ap);
 static void sil_thaw(struct ata_port *ap);
@@ -317,9 +317,9 @@ static inline void __iomem *sil_scr_addr(struct ata_port *ap,
 	return NULL;
 }
 
-static int sil_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int sil_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
 {
-	void __iomem *mmio = sil_scr_addr(ap, sc_reg);
+	void __iomem *mmio = sil_scr_addr(link->ap, sc_reg);
 
 	if (mmio) {
 		*val = readl(mmio);
@@ -328,9 +328,9 @@ static int sil_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 	return -EINVAL;
 }
 
-static int sil_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int sil_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 {
-	void __iomem *mmio = sil_scr_addr(ap, sc_reg);
+	void __iomem *mmio = sil_scr_addr(link->ap, sc_reg);
 
 	if (mmio) {
 		writel(val, mmio);
@@ -352,8 +352,8 @@ static void sil_host_intr(struct ata_port *ap, u32 bmdma2)
 		 * controllers continue to assert IRQ as long as
 		 * SError bits are pending.  Clear SError immediately.
 		 */
-		sil_scr_read(ap, SCR_ERROR, &serror);
-		sil_scr_write(ap, SCR_ERROR, serror);
+		sil_scr_read(&ap->link, SCR_ERROR, &serror);
+		sil_scr_write(&ap->link, SCR_ERROR, serror);
 
 		/* Sometimes spurious interrupts occur, double check
 		 * it's PHYRDY CHG.
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 84ffcc2..4621807 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -340,8 +340,8 @@ struct sil24_port_priv {
 };
 
 static void sil24_dev_config(struct ata_device *dev);
-static int sil24_scr_read(struct ata_port *ap, unsigned sc_reg, u32 *val);
-static int sil24_scr_write(struct ata_port *ap, unsigned sc_reg, u32 val);
+static int sil24_scr_read(struct ata_link *link, unsigned sc_reg, u32 *val);
+static int sil24_scr_write(struct ata_link *link, unsigned sc_reg, u32 val);
 static int sil24_qc_defer(struct ata_queued_cmd *qc);
 static void sil24_qc_prep(struct ata_queued_cmd *qc);
 static unsigned int sil24_qc_issue(struct ata_queued_cmd *qc);
@@ -504,9 +504,9 @@ static int sil24_scr_map[] = {
 	[SCR_ACTIVE]	= 3,
 };
 
-static int sil24_scr_read(struct ata_port *ap, unsigned sc_reg, u32 *val)
+static int sil24_scr_read(struct ata_link *link, unsigned sc_reg, u32 *val)
 {
-	void __iomem *scr_addr = sil24_port_base(ap) + PORT_SCONTROL;
+	void __iomem *scr_addr = sil24_port_base(link->ap) + PORT_SCONTROL;
 
 	if (sc_reg < ARRAY_SIZE(sil24_scr_map)) {
 		void __iomem *addr;
@@ -517,9 +517,9 @@ static int sil24_scr_read(struct ata_port *ap, unsigned sc_reg, u32 *val)
 	return -EINVAL;
 }
 
-static int sil24_scr_write(struct ata_port *ap, unsigned sc_reg, u32 val)
+static int sil24_scr_write(struct ata_link *link, unsigned sc_reg, u32 val)
 {
-	void __iomem *scr_addr = sil24_port_base(ap) + PORT_SCONTROL;
+	void __iomem *scr_addr = sil24_port_base(link->ap) + PORT_SCONTROL;
 
 	if (sc_reg < ARRAY_SIZE(sil24_scr_map)) {
 		void __iomem *addr;
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 1010b30..9c43b4e 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -64,8 +64,8 @@ enum {
 };
 
 static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
-static int sis_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
-static int sis_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int sis_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
+static int sis_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 
 static const struct pci_device_id sis_pci_tbl[] = {
 	{ PCI_VDEVICE(SI, 0x0180), sis_180 },	/* SiS 964/180 */
@@ -134,10 +134,11 @@ static unsigned int get_scr_cfg_addr(struct ata_port *ap, unsigned int sc_reg)
 	return addr;
 }
 
-static u32 sis_scr_cfg_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static u32 sis_scr_cfg_read(struct ata_link *link,
+			    unsigned int sc_reg, u32 *val)
 {
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	unsigned int cfg_addr = get_scr_cfg_addr(ap, sc_reg);
+	struct pci_dev *pdev = to_pci_dev(link->ap->host->dev);
+	unsigned int cfg_addr = get_scr_cfg_addr(link->ap, sc_reg);
 	u32 val2 = 0;
 	u8 pmr;
 
@@ -158,10 +159,11 @@ static u32 sis_scr_cfg_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 	return 0;
 }
 
-static int sis_scr_cfg_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int sis_scr_cfg_write(struct ata_link *link,
+			     unsigned int sc_reg, u32 val)
 {
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	unsigned int cfg_addr = get_scr_cfg_addr(ap, sc_reg);
+	struct pci_dev *pdev = to_pci_dev(link->ap->host->dev);
+	unsigned int cfg_addr = get_scr_cfg_addr(link->ap, sc_reg);
 	u8 pmr;
 
 	if (sc_reg == SCR_ERROR) /* doesn't exist in PCI cfg space */
@@ -178,8 +180,9 @@ static int sis_scr_cfg_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
 	return 0;
 }
 
-static int sis_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int sis_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
 {
+	struct ata_port *ap = link->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 pmr;
 
@@ -187,7 +190,7 @@ static int sis_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 		return -EINVAL;
 
 	if (ap->flags & SIS_FLAG_CFGSCR)
-		return sis_scr_cfg_read(ap, sc_reg, val);
+		return sis_scr_cfg_read(link, sc_reg, val);
 
 	pci_read_config_byte(pdev, SIS_PMR, &pmr);
 
@@ -202,8 +205,9 @@ static int sis_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 	return 0;
 }
 
-static int sis_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int sis_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 {
+	struct ata_port *ap = link->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 pmr;
 
@@ -213,7 +217,7 @@ static int sis_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
 	pci_read_config_byte(pdev, SIS_PMR, &pmr);
 
 	if (ap->flags & SIS_FLAG_CFGSCR)
-		return sis_scr_cfg_write(ap, sc_reg, val);
+		return sis_scr_cfg_write(link, sc_reg, val);
 	else {
 		iowrite32(val, ap->ioaddr.scr_addr + (sc_reg * 4));
 		if ((pdev->device == 0x0182) || (pdev->device == 0x0183) ||
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index fb13b82..609d147 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -123,20 +123,22 @@ static int k2_sata_check_atapi_dma(struct ata_queued_cmd *qc)
 	}
 }
 
-static int k2_sata_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int k2_sata_scr_read(struct ata_link *link,
+			    unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
-	*val = readl(ap->ioaddr.scr_addr + (sc_reg * 4));
+	*val = readl(link->ap->ioaddr.scr_addr + (sc_reg * 4));
 	return 0;
 }
 
 
-static int k2_sata_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int k2_sata_scr_write(struct ata_link *link,
+			     unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
-	writel(val, ap->ioaddr.scr_addr + (sc_reg * 4));
+	writel(val, link->ap->ioaddr.scr_addr + (sc_reg * 4));
 	return 0;
 }
 
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index db529b8..019575b 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -57,8 +57,8 @@ struct uli_priv {
 };
 
 static int uli_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
-static int uli_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
-static int uli_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int uli_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
+static int uli_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 
 static const struct pci_device_id uli_pci_tbl[] = {
 	{ PCI_VDEVICE(AL, 0x5289), uli_5289 },
@@ -107,39 +107,39 @@ static unsigned int get_scr_cfg_addr(struct ata_port *ap, unsigned int sc_reg)
 	return hpriv->scr_cfg_addr[ap->port_no] + (4 * sc_reg);
 }
 
-static u32 uli_scr_cfg_read(struct ata_port *ap, unsigned int sc_reg)
+static u32 uli_scr_cfg_read(struct ata_link *link, unsigned int sc_reg)
 {
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	unsigned int cfg_addr = get_scr_cfg_addr(ap, sc_reg);
+	struct pci_dev *pdev = to_pci_dev(link->ap->host->dev);
+	unsigned int cfg_addr = get_scr_cfg_addr(link->ap, sc_reg);
 	u32 val;
 
 	pci_read_config_dword(pdev, cfg_addr, &val);
 	return val;
 }
 
-static void uli_scr_cfg_write(struct ata_port *ap, unsigned int scr, u32 val)
+static void uli_scr_cfg_write(struct ata_link *link, unsigned int scr, u32 val)
 {
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	unsigned int cfg_addr = get_scr_cfg_addr(ap, scr);
+	struct pci_dev *pdev = to_pci_dev(link->ap->host->dev);
+	unsigned int cfg_addr = get_scr_cfg_addr(link->ap, scr);
 
 	pci_write_config_dword(pdev, cfg_addr, val);
 }
 
-static int uli_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int uli_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
 
-	*val = uli_scr_cfg_read(ap, sc_reg);
+	*val = uli_scr_cfg_read(link, sc_reg);
 	return 0;
 }
 
-static int uli_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int uli_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL) //SCR_CONTROL=2, SCR_ERROR=1, SCR_STATUS=0
 		return -EINVAL;
 
-	uli_scr_cfg_write(ap, sc_reg, val);
+	uli_scr_cfg_write(link, sc_reg, val);
 	return 0;
 }
 
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 96deeb3..1cfa745 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -68,8 +68,8 @@ enum {
 };
 
 static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
-static int svia_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
-static int svia_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int svia_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
+static int svia_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static void svia_noop_freeze(struct ata_port *ap);
 static int vt6420_prereset(struct ata_link *link, unsigned long deadline);
 static int vt6421_pata_cable_detect(struct ata_port *ap);
@@ -152,19 +152,19 @@ MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, svia_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 
-static int svia_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int svia_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
-	*val = ioread32(ap->ioaddr.scr_addr + (4 * sc_reg));
+	*val = ioread32(link->ap->ioaddr.scr_addr + (4 * sc_reg));
 	return 0;
 }
 
-static int svia_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int svia_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
-	iowrite32(val, ap->ioaddr.scr_addr + (4 * sc_reg));
+	iowrite32(val, link->ap->ioaddr.scr_addr + (4 * sc_reg));
 	return 0;
 }
 
@@ -210,20 +210,20 @@ static int vt6420_prereset(struct ata_link *link, unsigned long deadline)
 		goto skip_scr;
 
 	/* Resume phy.  This is the old SATA resume sequence */
-	svia_scr_write(ap, SCR_CONTROL, 0x300);
-	svia_scr_read(ap, SCR_CONTROL, &scontrol); /* flush */
+	svia_scr_write(link, SCR_CONTROL, 0x300);
+	svia_scr_read(link, SCR_CONTROL, &scontrol); /* flush */
 
 	/* wait for phy to become ready, if necessary */
 	do {
 		msleep(200);
-		svia_scr_read(ap, SCR_STATUS, &sstatus);
+		svia_scr_read(link, SCR_STATUS, &sstatus);
 		if ((sstatus & 0xf) != 1)
 			break;
 	} while (time_before(jiffies, timeout));
 
 	/* open code sata_print_link_status() */
-	svia_scr_read(ap, SCR_STATUS, &sstatus);
-	svia_scr_read(ap, SCR_CONTROL, &scontrol);
+	svia_scr_read(link, SCR_STATUS, &sstatus);
+	svia_scr_read(link, SCR_CONTROL, &scontrol);
 
 	online = (sstatus & 0xf) == 0x3;
 
@@ -232,7 +232,7 @@ static int vt6420_prereset(struct ata_link *link, unsigned long deadline)
 			online ? "up" : "down", sstatus, scontrol);
 
 	/* SStatus is read one more time */
-	svia_scr_read(ap, SCR_STATUS, &sstatus);
+	svia_scr_read(link, SCR_STATUS, &sstatus);
 
 	if (!online) {
 		/* tell EH to bail */
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index f3d635c..c57cdff 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -98,20 +98,22 @@ enum {
 			      VSC_SATA_INT_PHY_CHANGE),
 };
 
-static int vsc_sata_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int vsc_sata_scr_read(struct ata_link *link,
+			     unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
-	*val = readl(ap->ioaddr.scr_addr + (sc_reg * 4));
+	*val = readl(link->ap->ioaddr.scr_addr + (sc_reg * 4));
 	return 0;
 }
 
 
-static int vsc_sata_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int vsc_sata_scr_write(struct ata_link *link,
+			      unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
-	writel(val, ap->ioaddr.scr_addr + (sc_reg * 4));
+	writel(val, link->ap->ioaddr.scr_addr + (sc_reg * 4));
 	return 0;
 }
 
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 6a01068..29ae998 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -104,6 +104,9 @@ static struct usb_device_id blacklist_table[] = {
 	/* Broadcom BCM2046 */
 	{ USB_DEVICE(0x0a5c, 0x2151), .driver_info = BTUSB_RESET },
 
+	/* Apple MacBook Pro with Broadcom chip */
+	{ USB_DEVICE(0x05ac, 0x820f), .driver_info = BTUSB_RESET },
+
 	/* IBM/Lenovo ThinkPad with Broadcom chip */
 	{ USB_DEVICE(0x0a5c, 0x201e), .driver_info = BTUSB_RESET | BTUSB_WRONG_SCO_MTU },
 	{ USB_DEVICE(0x0a5c, 0x2110), .driver_info = BTUSB_RESET | BTUSB_WRONG_SCO_MTU },
@@ -169,6 +172,7 @@ static struct usb_device_id blacklist_table[] = {
 struct btusb_data {
 	struct hci_dev       *hdev;
 	struct usb_device    *udev;
+	struct usb_interface *intf;
 	struct usb_interface *isoc;
 
 	spinlock_t lock;
@@ -516,7 +520,7 @@ static int btusb_open(struct hci_dev *hdev)
 
 	err = btusb_submit_intr_urb(hdev);
 	if (err < 0) {
-		clear_bit(BTUSB_INTR_RUNNING, &hdev->flags);
+		clear_bit(BTUSB_INTR_RUNNING, &data->flags);
 		clear_bit(HCI_RUNNING, &hdev->flags);
 	}
 
@@ -532,8 +536,10 @@ static int btusb_close(struct hci_dev *hdev)
 	if (!test_and_clear_bit(HCI_RUNNING, &hdev->flags))
 		return 0;
 
+	cancel_work_sync(&data->work);
+
 	clear_bit(BTUSB_ISOC_RUNNING, &data->flags);
-	usb_kill_anchored_urbs(&data->intr_anchor);
+	usb_kill_anchored_urbs(&data->isoc_anchor);
 
 	clear_bit(BTUSB_BULK_RUNNING, &data->flags);
 	usb_kill_anchored_urbs(&data->bulk_anchor);
@@ -821,6 +827,7 @@ static int btusb_probe(struct usb_interface *intf,
 	}
 
 	data->udev = interface_to_usbdev(intf);
+	data->intf = intf;
 
 	spin_lock_init(&data->lock);
 
@@ -889,7 +896,7 @@ static int btusb_probe(struct usb_interface *intf,
 
 	if (data->isoc) {
 		err = usb_driver_claim_interface(&btusb_driver,
-							data->isoc, NULL);
+							data->isoc, data);
 		if (err < 0) {
 			hci_free_dev(hdev);
 			kfree(data);
@@ -921,13 +928,22 @@ static void btusb_disconnect(struct usb_interface *intf)
 
 	hdev = data->hdev;
 
-	if (data->isoc)
-		usb_driver_release_interface(&btusb_driver, data->isoc);
+	__hci_dev_hold(hdev);
 
-	usb_set_intfdata(intf, NULL);
+	usb_set_intfdata(data->intf, NULL);
+
+	if (data->isoc)
+		usb_set_intfdata(data->isoc, NULL);
 
 	hci_unregister_dev(hdev);
 
+	if (intf == data->isoc)
+		usb_driver_release_interface(&btusb_driver, data->intf);
+	else if (data->isoc)
+		usb_driver_release_interface(&btusb_driver, data->isoc);
+
+	__hci_dev_put(hdev);
+
 	hci_free_dev(hdev);
 }
 
diff --git a/drivers/i2c/busses/i2c-powermac.c b/drivers/i2c/busses/i2c-powermac.c
index 22f6d5c..0e7b1c6 100644
--- a/drivers/i2c/busses/i2c-powermac.c
+++ b/drivers/i2c/busses/i2c-powermac.c
@@ -180,7 +180,7 @@ static const struct i2c_algorithm i2c_powermac_algorithm = {
 };
 
 
-static int i2c_powermac_remove(struct platform_device *dev)
+static int __devexit i2c_powermac_remove(struct platform_device *dev)
 {
 	struct i2c_adapter	*adapter = platform_get_drvdata(dev);
 	struct pmac_i2c_bus	*bus = i2c_get_adapdata(adapter);
@@ -200,7 +200,7 @@ static int i2c_powermac_remove(struct platform_device *dev)
 }
 
 
-static int __devexit i2c_powermac_probe(struct platform_device *dev)
+static int __devinit i2c_powermac_probe(struct platform_device *dev)
 {
 	struct pmac_i2c_bus *bus = dev->dev.platform_data;
 	struct device_node *parent = NULL;
diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index af4491f..307d976 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -583,8 +583,10 @@ static int __init i2c_dev_init(void)
 		goto out;
 
 	i2c_dev_class = class_create(THIS_MODULE, "i2c-dev");
-	if (IS_ERR(i2c_dev_class))
+	if (IS_ERR(i2c_dev_class)) {
+		res = PTR_ERR(i2c_dev_class);
 		goto out_unreg_chrdev;
+	}
 
 	res = i2c_add_driver(&i2cdev_driver);
 	if (res)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 1b1df5c..e9ca3cb 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -404,7 +404,7 @@ static void path_rec_completion(int status,
 	struct net_device *dev = path->dev;
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_ah *ah = NULL;
-	struct ipoib_ah *old_ah;
+	struct ipoib_ah *old_ah = NULL;
 	struct ipoib_neigh *neigh, *tn;
 	struct sk_buff_head skqueue;
 	struct sk_buff *skb;
@@ -428,12 +428,12 @@ static void path_rec_completion(int status,
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	old_ah   = path->ah;
-	path->ah = ah;
-
 	if (ah) {
 		path->pathrec = *pathrec;
 
+		old_ah   = path->ah;
+		path->ah = ah;
+
 		ipoib_dbg(priv, "created address handle %p for LID 0x%04x, SL %d\n",
 			  ah, be16_to_cpu(pathrec->dlid), pathrec->sl);
 
diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 18f4d7f..2998a6a 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -351,8 +351,9 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 #define BCM5974_WELLSPRING_MODE_REQUEST_VALUE		0x300
 #define BCM5974_WELLSPRING_MODE_REQUEST_INDEX		0
 #define BCM5974_WELLSPRING_MODE_VENDOR_VALUE		0x01
+#define BCM5974_WELLSPRING_MODE_NORMAL_VALUE		0x08
 
-static int bcm5974_wellspring_mode(struct bcm5974 *dev)
+static int bcm5974_wellspring_mode(struct bcm5974 *dev, bool on)
 {
 	char *data = kmalloc(8, GFP_KERNEL);
 	int retval = 0, size;
@@ -377,7 +378,9 @@ static int bcm5974_wellspring_mode(struct bcm5974 *dev)
 	}
 
 	/* apply the mode switch */
-	data[0] = BCM5974_WELLSPRING_MODE_VENDOR_VALUE;
+	data[0] = on ?
+		BCM5974_WELLSPRING_MODE_VENDOR_VALUE :
+		BCM5974_WELLSPRING_MODE_NORMAL_VALUE;
 
 	/* write configuration */
 	size = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
@@ -392,7 +395,8 @@ static int bcm5974_wellspring_mode(struct bcm5974 *dev)
 		goto out;
 	}
 
-	dprintk(2, "bcm5974: switched to wellspring mode.\n");
+	dprintk(2, "bcm5974: switched to %s mode.\n",
+		on ? "wellspring" : "normal");
 
  out:
 	kfree(data);
@@ -481,7 +485,7 @@ exit:
  */
 static int bcm5974_start_traffic(struct bcm5974 *dev)
 {
-	if (bcm5974_wellspring_mode(dev)) {
+	if (bcm5974_wellspring_mode(dev, true)) {
 		dprintk(1, "bcm5974: mode switch failed\n");
 		goto error;
 	}
@@ -504,6 +508,7 @@ static void bcm5974_pause_traffic(struct bcm5974 *dev)
 {
 	usb_kill_urb(dev->tp_urb);
 	usb_kill_urb(dev->bt_urb);
+	bcm5974_wellspring_mode(dev, false);
 }
 
 /*
diff --git a/drivers/input/touchscreen/jornada720_ts.c b/drivers/input/touchscreen/jornada720_ts.c
index bf44f9d..c8b7e8a 100644
--- a/drivers/input/touchscreen/jornada720_ts.c
+++ b/drivers/input/touchscreen/jornada720_ts.c
@@ -119,8 +119,8 @@ static int __devinit jornada720_ts_probe(struct platform_device *pdev)
 	input_dev->id.bustype = BUS_HOST;
 	input_dev->dev.parent = &pdev->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
-	input_dev->keybit[LONG(BTN_TOUCH)] = BIT(BTN_TOUCH);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 	input_set_abs_params(input_dev, ABS_X, 270, 3900, 0, 0);
 	input_set_abs_params(input_dev, ABS_Y, 180, 3700, 0, 0);
 
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index f6c4528..87e37bc 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -294,8 +294,6 @@ static int ath_stop(struct ath_softc *sc)
 	 * hardware is gone (invalid).
 	 */
 
-	if (!sc->sc_invalid)
-		ath9k_hw_set_interrupts(ah, 0);
 	ath_draintxq(sc, false);
 	if (!sc->sc_invalid) {
 		ath_stoprecv(sc);
@@ -797,6 +795,12 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
 		sc->sc_imask |= ATH9K_INT_CST;
 
+	/* Note: We disable MIB interrupts for now as we don't yet
+	 * handle processing ANI, otherwise you will get an interrupt
+	 * storm after about 7 hours of usage making the system unusable
+	 * with huge latency. Once we do have ANI processing included
+	 * we can re-enable this interrupt. */
+#if 0
 	/*
 	 * Enable MIB interrupts when there are hardware phy counters.
 	 * Note we only do this (at the moment) for station mode.
@@ -804,6 +808,7 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	if (ath9k_hw_phycounters(ah) &&
 	    ((sc->sc_opmode == ATH9K_M_STA) || (sc->sc_opmode == ATH9K_M_IBSS)))
 		sc->sc_imask |= ATH9K_INT_MIB;
+#endif
 	/*
 	 * Some hardware processes the TIM IE and fires an
 	 * interrupt when the TIM bit is set.  For hardware
@@ -1336,6 +1341,8 @@ void ath_deinit(struct ath_softc *sc)
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s\n", __func__);
 
+	tasklet_kill(&sc->intr_tq);
+	tasklet_kill(&sc->bcon_tasklet);
 	ath_stop(sc);
 	if (!sc->sc_invalid)
 		ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 4ee695b..2f84093 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -974,7 +974,6 @@ struct ath_softc {
 	u32 sc_keymax;		/* size of key cache */
 	DECLARE_BITMAP(sc_keymap, ATH_KEYMAX);	/* key use bit map */
 	u8 sc_splitmic;		/* split TKIP MIC keys */
-	int sc_keytype;
 
 	/* RX */
 	struct list_head sc_rxbuf;
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 99badf1..acebdf1 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -206,8 +206,6 @@ static int ath_key_config(struct ath_softc *sc,
 	if (!ret)
 		return -EIO;
 
-	if (mac)
-		sc->sc_keytype = hk.kv_type;
 	return 0;
 }
 
@@ -778,7 +776,6 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	case DISABLE_KEY:
 		ath_key_delete(sc, key);
 		clear_bit(key->keyidx, sc->sc_keymap);
-		sc->sc_keytype = ATH9K_CIPHER_CLR;
 		break;
 	default:
 		ret = -EINVAL;
@@ -1414,10 +1411,17 @@ static void ath_pci_remove(struct pci_dev *pdev)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath_softc *sc = hw->priv;
+	enum ath9k_int status;
 
-	if (pdev->irq)
+	if (pdev->irq) {
+		ath9k_hw_set_interrupts(sc->sc_ah, 0);
+		/* clear the ISR */
+		ath9k_hw_getisr(sc->sc_ah, &status);
+		sc->sc_invalid = 1;
 		free_irq(pdev->irq, sc);
+	}
 	ath_detach(sc);
+
 	pci_iounmap(pdev, sc->mem);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 550129f..8b332e1 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -315,11 +315,11 @@ static int ath_tx_prepare(struct ath_softc *sc,
 		txctl->keyix = tx_info->control.hw_key->hw_key_idx;
 		txctl->frmlen += tx_info->control.icv_len;
 
-		if (sc->sc_keytype == ATH9K_CIPHER_WEP)
+		if (tx_info->control.hw_key->alg == ALG_WEP)
 			txctl->keytype = ATH9K_KEY_TYPE_WEP;
-		else if (sc->sc_keytype == ATH9K_CIPHER_TKIP)
+		else if (tx_info->control.hw_key->alg == ALG_TKIP)
 			txctl->keytype = ATH9K_KEY_TYPE_TKIP;
-		else if (sc->sc_keytype == ATH9K_CIPHER_AES_CCM)
+		else if (tx_info->control.hw_key->alg == ALG_CCMP)
 			txctl->keytype = ATH9K_KEY_TYPE_AES;
 	}
 
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index da8b743..a60ae86 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -58,6 +58,7 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x0586, 0x3407), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x129b, 0x1666), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x157e, 0x300a), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x0105, 0x145f), .driver_info = DEVICE_ZD1211 },
 	/* ZD1211B */
 	{ USB_DEVICE(0x0ace, 0x1215), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x157e, 0x300d), .driver_info = DEVICE_ZD1211B },
diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 9a7c9e1..851f5b8 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -527,7 +527,7 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
 		 */
 		pci_read_config_dword(child_dev, child_pos + PCI_EXP_DEVCAP,
 			&reg32);
-		if (!(reg32 & PCI_EXP_DEVCAP_RBER && !aspm_force)) {
+		if (!(reg32 & PCI_EXP_DEVCAP_RBER) && !aspm_force) {
 			printk("Pre-1.1 PCIe device detected, "
 				"disable ASPM for %s. It can be enabled forcedly"
 				" with 'pcie_aspm=force'\n", pci_name(pdev));
diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 3b3b5f1..4edfc47 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -162,7 +162,7 @@ EXPORT_SYMBOL(pci_find_slot);
  * time.
  */
 struct pci_dev *pci_find_device(unsigned int vendor, unsigned int device,
-				const struct pci_dev *from)
+				struct pci_dev *from)
 {
 	struct pci_dev *pdev;
 
@@ -263,7 +263,7 @@ static int match_pci_dev_by_id(struct device *dev, void *data)
  * this file.
  */
 static struct pci_dev *pci_get_dev_by_id(const struct pci_device_id *id,
-					 const struct pci_dev *from)
+					 struct pci_dev *from)
 {
 	struct device *dev;
 	struct device *dev_start = NULL;
@@ -303,7 +303,7 @@ static struct pci_dev *pci_get_dev_by_id(const struct pci_device_id *id,
  */
 struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
 			       unsigned int ss_vendor, unsigned int ss_device,
-			       const struct pci_dev *from)
+			       struct pci_dev *from)
 {
 	struct pci_dev *pdev;
 	struct pci_device_id *id;
diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 4174d96..34c83d3 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -427,6 +427,18 @@ static int pcmcia_device_probe(struct device * dev)
 	p_drv = to_pcmcia_drv(dev->driver);
 	s = p_dev->socket;
 
+	/* The PCMCIA code passes the match data in via dev->driver_data
+	 * which is an ugly hack. Once the driver probe is called it may
+	 * and often will overwrite the match data so we must save it first
+	 *
+	 * handle pseudo multifunction devices:
+	 * there are at most two pseudo multifunction devices.
+	 * if we're matching against the first, schedule a
+	 * call which will then check whether there are two
+	 * pseudo devices, and if not, add the second one.
+	 */
+	did = p_dev->dev.driver_data;
+
 	ds_dbg(1, "trying to bind %s to %s\n", p_dev->dev.bus_id,
 	       p_drv->drv.name);
 
@@ -455,21 +467,14 @@ static int pcmcia_device_probe(struct device * dev)
 		goto put_module;
 	}
 
-	/* handle pseudo multifunction devices:
-	 * there are at most two pseudo multifunction devices.
-	 * if we're matching against the first, schedule a
-	 * call which will then check whether there are two
-	 * pseudo devices, and if not, add the second one.
-	 */
-	did = p_dev->dev.driver_data;
 	if (did && (did->match_flags & PCMCIA_DEV_ID_MATCH_DEVICE_NO) &&
 	    (p_dev->socket->device_count == 1) && (p_dev->device_no == 0))
 		pcmcia_add_device_later(p_dev->socket, 0);
 
- put_module:
+put_module:
 	if (ret)
 		module_put(p_drv->owner);
- put_dev:
+put_dev:
 	if (ret)
 		put_device(dev);
 	return (ret);
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 48ee8c7..e187298 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -294,10 +294,10 @@ static void sas_ata_post_internal(struct ata_queued_cmd *qc)
 	}
 }
 
-static int sas_ata_scr_write(struct ata_port *ap, unsigned int sc_reg_in,
+static int sas_ata_scr_write(struct ata_link *link, unsigned int sc_reg_in,
 			      u32 val)
 {
-	struct domain_device *dev = ap->private_data;
+	struct domain_device *dev = link->ap->private_data;
 
 	SAS_DPRINTK("STUB %s\n", __func__);
 	switch (sc_reg_in) {
@@ -319,10 +319,10 @@ static int sas_ata_scr_write(struct ata_port *ap, unsigned int sc_reg_in,
 	return 0;
 }
 
-static int sas_ata_scr_read(struct ata_port *ap, unsigned int sc_reg_in,
+static int sas_ata_scr_read(struct ata_link *link, unsigned int sc_reg_in,
 			    u32 *val)
 {
-	struct domain_device *dev = ap->private_data;
+	struct domain_device *dev = link->ap->private_data;
 
 	SAS_DPRINTK("STUB %s\n", __func__);
 	switch (sc_reg_in) {
diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 3a6da80..61fb8b6 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -131,7 +131,8 @@ struct atmel_uart_char {
 struct atmel_uart_port {
 	struct uart_port	uart;		/* uart */
 	struct clk		*clk;		/* uart clock */
-	unsigned short		suspended;	/* is port suspended? */
+	int			may_wakeup;	/* cached value of device_may_wakeup for times we need to disable it */
+	u32			backup_imr;	/* IMR saved during suspend */
 	int			break_active;	/* break being received */
 
 	short			use_dma_rx;	/* enable PDC receiver */
@@ -984,8 +985,15 @@ static void atmel_serial_pm(struct uart_port *port, unsigned int state,
 		 * This is called on uart_open() or a resume event.
 		 */
 		clk_enable(atmel_port->clk);
+
+		/* re-enable interrupts if we disabled some on suspend */
+		UART_PUT_IER(port, atmel_port->backup_imr);
 		break;
 	case 3:
+		/* Back up the interrupt mask and disable all interrupts */
+		atmel_port->backup_imr = UART_GET_IMR(port);
+		UART_PUT_IDR(port, -1);
+
 		/*
 		 * Disable the peripheral clock for this serial port.
 		 * This is called on uart_close() or a suspend event.
@@ -1475,13 +1483,12 @@ static int atmel_serial_suspend(struct platform_device *pdev,
 			cpu_relax();
 	}
 
-	if (device_may_wakeup(&pdev->dev)
-	    && !atmel_serial_clk_will_stop())
-		enable_irq_wake(port->irq);
-	else {
-		uart_suspend_port(&atmel_uart, port);
-		atmel_port->suspended = 1;
-	}
+	/* we can not wake up if we're running on slow clock */
+	atmel_port->may_wakeup = device_may_wakeup(&pdev->dev);
+	if (atmel_serial_clk_will_stop())
+		device_set_wakeup_enable(&pdev->dev, 0);
+
+	uart_suspend_port(&atmel_uart, port);
 
 	return 0;
 }
@@ -1491,11 +1498,8 @@ static int atmel_serial_resume(struct platform_device *pdev)
 	struct uart_port *port = platform_get_drvdata(pdev);
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
-	if (atmel_port->suspended) {
-		uart_resume_port(&atmel_uart, port);
-		atmel_port->suspended = 0;
-	} else
-		disable_irq_wake(port->irq);
+	uart_resume_port(&atmel_uart, port);
+	device_set_wakeup_enable(&pdev->dev, atmel_port->may_wakeup);
 
 	return 0;
 }
@@ -1513,6 +1517,8 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
 	BUILD_BUG_ON(!is_power_of_2(ATMEL_SERIAL_RINGSIZE));
 
 	port = &atmel_ports[pdev->id];
+	port->backup_imr = 0;
+
 	atmel_init_port(port, pdev);
 
 	if (!atmel_use_dma_rx(&port->uart)) {
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 8abd4e5..8ab389d 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1876,7 +1876,8 @@ int usb_add_hcd(struct usb_hcd *hcd,
 		 * with IRQF_SHARED. As usb_hcd_irq() will always disable
 		 * interrupts we can remove it here.
 		 */
-		irqflags &= ~IRQF_DISABLED;
+		if (irqflags & IRQF_SHARED)
+			irqflags &= ~IRQF_DISABLED;
 
 		snprintf(hcd->irq_descr, sizeof(hcd->irq_descr), "%s:usb%d",
 				hcd->driver->description, hcd->self.busnum);
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 6a5cb01..d999638 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2683,35 +2683,17 @@ static void hub_port_connect_change(struct usb_hub *hub, int port1,
 				USB_PORT_STAT_C_ENABLE);
 #endif
 
-	/* Try to use the debounce delay for protection against
-	 * port-enable changes caused, for example, by EMI.
-	 */
-	if (portchange & (USB_PORT_STAT_C_CONNECTION |
-				USB_PORT_STAT_C_ENABLE)) {
-		status = hub_port_debounce(hub, port1);
-		if (status < 0) {
-			if (printk_ratelimit())
-				dev_err (hub_dev, "connect-debounce failed, "
-						"port %d disabled\n", port1);
-			portstatus &= ~USB_PORT_STAT_CONNECTION;
-		} else {
-			portstatus = status;
-		}
-	}
-
 	/* Try to resuscitate an existing device */
 	udev = hdev->children[port1-1];
 	if ((portstatus & USB_PORT_STAT_CONNECTION) && udev &&
 			udev->state != USB_STATE_NOTATTACHED) {
-
 		usb_lock_device(udev);
 		if (portstatus & USB_PORT_STAT_ENABLE) {
 			status = 0;		/* Nothing to do */
-		} else if (!udev->persist_enabled) {
-			status = -ENODEV;	/* Mustn't resuscitate */
 
 #ifdef CONFIG_USB_SUSPEND
-		} else if (udev->state == USB_STATE_SUSPENDED) {
+		} else if (udev->state == USB_STATE_SUSPENDED &&
+				udev->persist_enabled) {
 			/* For a suspended device, treat this as a
 			 * remote wakeup event.
 			 */
@@ -2726,7 +2708,7 @@ static void hub_port_connect_change(struct usb_hub *hub, int port1,
 #endif
 
 		} else {
-			status = usb_reset_device(udev);
+			status = -ENODEV;	/* Don't resuscitate */
 		}
 		usb_unlock_device(udev);
 
@@ -2741,6 +2723,19 @@ static void hub_port_connect_change(struct usb_hub *hub, int port1,
 		usb_disconnect(&hdev->children[port1-1]);
 	clear_bit(port1, hub->change_bits);
 
+	if (portchange & (USB_PORT_STAT_C_CONNECTION |
+				USB_PORT_STAT_C_ENABLE)) {
+		status = hub_port_debounce(hub, port1);
+		if (status < 0) {
+			if (printk_ratelimit())
+				dev_err(hub_dev, "connect-debounce failed, "
+						"port %d disabled\n", port1);
+			portstatus &= ~USB_PORT_STAT_CONNECTION;
+		} else {
+			portstatus = status;
+		}
+	}
+
 	/* Return now if debouncing failed or nothing is connected */
 	if (!(portstatus & USB_PORT_STAT_CONNECTION)) {
 
@@ -2748,7 +2743,7 @@ static void hub_port_connect_change(struct usb_hub *hub, int port1,
 		if ((wHubCharacteristics & HUB_CHAR_LPSM) < 2
 				&& !(portstatus & (1 << USB_PORT_FEAT_POWER)))
 			set_port_feature(hdev, port1, USB_PORT_FEAT_POWER);
- 
+
 		if (portstatus & USB_PORT_STAT_ENABLE)
   			goto done;
 		return;
diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index 1cfccf1..45ad556 100644
--- a/drivers/usb/gadget/fsl_usb2_udc.c
+++ b/drivers/usb/gadget/fsl_usb2_udc.c
@@ -223,7 +223,7 @@ static int dr_controller_setup(struct fsl_udc *udc)
 	fsl_writel(tmp, &dr_regs->endpointlistaddr);
 
 	VDBG("vir[qh_base] is %p phy[qh_base] is 0x%8x reg is 0x%8x",
-		(int)udc->ep_qh, (int)tmp,
+		udc->ep_qh, (int)tmp,
 		fsl_readl(&dr_regs->endpointlistaddr));
 
 	/* Config PHY interface */
diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index 574c538..bb54cca 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -787,7 +787,7 @@ static void dma_channel_claim(struct omap_ep *ep, unsigned channel)
 			omap_set_dma_dest_params(ep->lch,
 				OMAP_DMA_PORT_TIPB,
 				OMAP_DMA_AMODE_CONSTANT,
-				(unsigned long) io_v2p(UDC_DATA_DMA),
+				UDC_DATA_DMA,
 				0, 0);
 		}
 	} else {
@@ -804,7 +804,7 @@ static void dma_channel_claim(struct omap_ep *ep, unsigned channel)
 			omap_set_dma_src_params(ep->lch,
 				OMAP_DMA_PORT_TIPB,
 				OMAP_DMA_AMODE_CONSTANT,
-				(unsigned long) io_v2p(UDC_DATA_DMA),
+				UDC_DATA_DMA,
 				0, 0);
 			/* EMIFF or SDRC */
 			omap_set_dma_dest_burst_mode(ep->lch,
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index d9d53f2..8409e07 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -145,16 +145,6 @@ static int handshake (struct ehci_hcd *ehci, void __iomem *ptr,
 	return -ETIMEDOUT;
 }
 
-static int handshake_on_error_set_halt(struct ehci_hcd *ehci, void __iomem *ptr,
-				       u32 mask, u32 done, int usec)
-{
-	int error = handshake(ehci, ptr, mask, done, usec);
-	if (error)
-		ehci_to_hcd(ehci)->state = HC_STATE_HALT;
-
-	return error;
-}
-
 /* force HC to halt state from unknown (EHCI spec section 2.3) */
 static int ehci_halt (struct ehci_hcd *ehci)
 {
@@ -173,6 +163,22 @@ static int ehci_halt (struct ehci_hcd *ehci)
 			  STS_HALT, STS_HALT, 16 * 125);
 }
 
+static int handshake_on_error_set_halt(struct ehci_hcd *ehci, void __iomem *ptr,
+				       u32 mask, u32 done, int usec)
+{
+	int error;
+
+	error = handshake(ehci, ptr, mask, done, usec);
+	if (error) {
+		ehci_halt(ehci);
+		ehci_to_hcd(ehci)->state = HC_STATE_HALT;
+		ehci_err(ehci, "force halt; handhake %p %08x %08x -> %d\n",
+			ptr, mask, done, error);
+	}
+
+	return error;
+}
+
 /* put TDI/ARC silicon into EHCI mode */
 static void tdi_reset (struct ehci_hcd *ehci)
 {
diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index b7853c8..4a0c5a7 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -437,6 +437,9 @@ static int enable_periodic (struct ehci_hcd *ehci)
 	u32	cmd;
 	int	status;
 
+	if (ehci->periodic_sched++)
+		return 0;
+
 	/* did clearing PSE did take effect yet?
 	 * takes effect only at frame boundaries...
 	 */
@@ -461,6 +464,9 @@ static int disable_periodic (struct ehci_hcd *ehci)
 	u32	cmd;
 	int	status;
 
+	if (--ehci->periodic_sched)
+		return 0;
+
 	/* did setting PSE not take effect yet?
 	 * takes effect only at frame boundaries...
 	 */
@@ -544,13 +550,10 @@ static int qh_link_periodic (struct ehci_hcd *ehci, struct ehci_qh *qh)
 		: (qh->usecs * 8);
 
 	/* maybe enable periodic schedule processing */
-	if (!ehci->periodic_sched++)
-		return enable_periodic (ehci);
-
-	return 0;
+	return enable_periodic(ehci);
 }
 
-static void qh_unlink_periodic (struct ehci_hcd *ehci, struct ehci_qh *qh)
+static int qh_unlink_periodic(struct ehci_hcd *ehci, struct ehci_qh *qh)
 {
 	unsigned	i;
 	unsigned	period;
@@ -586,9 +589,7 @@ static void qh_unlink_periodic (struct ehci_hcd *ehci, struct ehci_qh *qh)
 	qh_put (qh);
 
 	/* maybe turn off periodic schedule */
-	ehci->periodic_sched--;
-	if (!ehci->periodic_sched)
-		(void) disable_periodic (ehci);
+	return disable_periodic(ehci);
 }
 
 static void intr_deschedule (struct ehci_hcd *ehci, struct ehci_qh *qh)
@@ -1562,9 +1563,7 @@ itd_link_urb (
 	urb->hcpriv = NULL;
 
 	timer_action (ehci, TIMER_IO_WATCHDOG);
-	if (unlikely (!ehci->periodic_sched++))
-		return enable_periodic (ehci);
-	return 0;
+	return enable_periodic(ehci);
 }
 
 #define	ISO_ERRS (EHCI_ISOC_BUF_ERR | EHCI_ISOC_BABBLE | EHCI_ISOC_XACTERR)
@@ -1642,7 +1641,7 @@ itd_complete (
 	ehci_urb_done(ehci, urb, 0);
 	retval = true;
 	urb = NULL;
-	ehci->periodic_sched--;
+	(void) disable_periodic(ehci);
 	ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs--;
 
 	if (unlikely (list_empty (&stream->td_list))) {
@@ -1951,9 +1950,7 @@ sitd_link_urb (
 	urb->hcpriv = NULL;
 
 	timer_action (ehci, TIMER_IO_WATCHDOG);
-	if (!ehci->periodic_sched++)
-		return enable_periodic (ehci);
-	return 0;
+	return enable_periodic(ehci);
 }
 
 /*-------------------------------------------------------------------------*/
@@ -2019,7 +2016,7 @@ sitd_complete (
 	ehci_urb_done(ehci, urb, 0);
 	retval = true;
 	urb = NULL;
-	ehci->periodic_sched--;
+	(void) disable_periodic(ehci);
 	ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs--;
 
 	if (list_empty (&stream->td_list)) {
@@ -2243,8 +2240,7 @@ restart:
 			if (unlikely (modified)) {
 				if (likely(ehci->periodic_sched > 0))
 					goto restart;
-				/* maybe we can short-circuit this scan! */
-				disable_periodic(ehci);
+				/* short-circuit this scan */
 				now_uframe = clock;
 				break;
 			}
diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index a001748..58b2b8f 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -9,6 +9,7 @@ comment "Enable Host or Gadget support to see Inventra options"
 # (M)HDRC = (Multipoint) Highspeed Dual-Role Controller
 config USB_MUSB_HDRC
 	depends on (USB || USB_GADGET) && HAVE_CLK
+	depends on !SUPERH
 	select TWL4030_USB if MACH_OMAP_3430SDP
 	tristate 'Inventra Highspeed Dual Role Controller (TI, ...)'
 	help
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index c5b8f02..128e949 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -100,8 +100,8 @@
 #include <linux/io.h>
 
 #ifdef	CONFIG_ARM
-#include <asm/arch/hardware.h>
-#include <asm/arch/memory.h>
+#include <mach/hardware.h>
+#include <mach/memory.h>
 #include <asm/mach-types.h>
 #endif
 
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 298b22e..9d2dcb1 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -35,8 +35,8 @@
 #include <linux/io.h>
 
 #include <asm/mach-types.h>
-#include <asm/arch/hardware.h>
-#include <asm/arch/mux.h>
+#include <mach/hardware.h>
+#include <mach/mux.h>
 
 #include "musb_core.h"
 #include "omap2430.h"
diff --git a/drivers/usb/musb/omap2430.h b/drivers/usb/musb/omap2430.h
index 786a620..dc76707 100644
--- a/drivers/usb/musb/omap2430.h
+++ b/drivers/usb/musb/omap2430.h
@@ -11,8 +11,8 @@
 #define __MUSB_OMAP243X_H__
 
 #if defined(CONFIG_ARCH_OMAP2430) || defined(CONFIG_ARCH_OMAP3430)
-#include <asm/arch/hardware.h>
-#include <asm/arch/usb.h>
+#include <mach/hardware.h>
+#include <mach/usb.h>
 
 /*
  * OMAP2430-specific definitions
diff --git a/drivers/usb/serial/cp2101.c b/drivers/usb/serial/cp2101.c
index 442cba6..1279553 100644
--- a/drivers/usb/serial/cp2101.c
+++ b/drivers/usb/serial/cp2101.c
@@ -72,6 +72,7 @@ static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x10C4, 0x80CA) }, /* Degree Controls Inc */
 	{ USB_DEVICE(0x10C4, 0x80DD) }, /* Tracient RFID */
 	{ USB_DEVICE(0x10C4, 0x80F6) }, /* Suunto sports instrument */
+	{ USB_DEVICE(0x10C4, 0x8115) }, /* Arygon NFC/Mifare Reader */
 	{ USB_DEVICE(0x10C4, 0x813D) }, /* Burnside Telecom Deskmobile */
 	{ USB_DEVICE(0x10C4, 0x814A) }, /* West Mountain Radio RIGblaster P&P */
 	{ USB_DEVICE(0x10C4, 0x814B) }, /* West Mountain Radio RIGtalk */
@@ -83,6 +84,7 @@ static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x10C4, 0x81E7) }, /* Aerocomm Radio */
 	{ USB_DEVICE(0x10C4, 0x8218) }, /* Lipowsky Industrie Elektronik GmbH, HARP-1 */
 	{ USB_DEVICE(0x10c4, 0x8293) }, /* Telegesys ETRX2USB */
+	{ USB_DEVICE(0x10C4, 0x8341) }, /* Siemens MC35PU GPRS Modem */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA61) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xF001) }, /* Elan Digital Systems USBscope50 */
@@ -93,6 +95,7 @@ static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x13AD, 0x9999) }, /* Baltech card reader */
 	{ USB_DEVICE(0x166A, 0x0303) }, /* Clipsal 5500PCU C-Bus USB interface */
 	{ USB_DEVICE(0x16D6, 0x0001) }, /* Jablotron serial interface */
+	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
 	{ } /* Terminating Entry */
 };
 
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 984f6ef..3dc93b5 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -654,6 +654,9 @@ static struct usb_device_id id_table_combined [] = {
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
 	{ USB_DEVICE(FTDI_VID, FTDI_REU_TINY_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO4x4_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DGQG_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DUSB_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio.h b/drivers/usb/serial/ftdi_sio.h
index 382265b..8a5b6df 100644
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -750,6 +750,7 @@
 
 #define PAPOUCH_VID			0x5050	/* Vendor ID */
 #define PAPOUCH_TMU_PID			0x0400	/* TMU USB Thermometer */
+#define PAPOUCH_QUIDO4x4_PID		0x0900	/* Quido 4/4 Module */
 
 /*
  * ACG Identification Technologies GmbH products (http://www.acg.de/).
@@ -838,6 +839,10 @@
 /* Rig Expert Ukraine devices */
 #define FTDI_REU_TINY_PID		0xED22	/* RigExpert Tiny */
 
+/* Domintell products  http://www.domintell.com */
+#define FTDI_DOMINTELL_DGQG_PID	0xEF50	/* Master */
+#define FTDI_DOMINTELL_DUSB_PID	0xEF51	/* DUSB01 module */
+
 /* Commands */
 #define FTDI_SIO_RESET 		0 /* Reset the port */
 #define FTDI_SIO_MODEM_CTRL 	1 /* Set the modem control register */
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 9f9cd36..73f8277 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -218,6 +218,7 @@ static int  option_send_setup(struct tty_struct *tty, struct usb_serial_port *po
 /* ZTE PRODUCTS */
 #define ZTE_VENDOR_ID				0x19d2
 #define ZTE_PRODUCT_MF628			0x0015
+#define ZTE_PRODUCT_CDMA_TECH			0xfffe
 
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
@@ -347,6 +348,7 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(MAXON_VENDOR_ID, 0x6280) }, /* BP3-USB & BP3-EXT HSDPA */
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864E) },
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF628) },
+	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 7060337..ea1a103 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -14,7 +14,7 @@
   Whom based his on the Keyspan driver by Hugh Blemings <hugh@blemings.org>
 */
 
-#define DRIVER_VERSION "v.1.2.13a"
+#define DRIVER_VERSION "v.1.3.2"
 #define DRIVER_AUTHOR "Kevin Lloyd <klloyd@sierrawireless.com>"
 #define DRIVER_DESC "USB Driver for Sierra Wireless USB modems"
 
@@ -30,9 +30,6 @@
 
 #define SWIMS_USB_REQUEST_SetPower	0x00
 #define SWIMS_USB_REQUEST_SetNmea	0x07
-#define SWIMS_USB_REQUEST_SetMode	0x0B
-#define SWIMS_USB_REQUEST_GetSwocInfo	0x0A
-#define SWIMS_SET_MODE_Modem		0x0001
 
 /* per port private data */
 #define N_IN_URB	4
@@ -163,7 +160,7 @@ static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x1199, 0x0017) },	/* Sierra Wireless EM5625 */
 	{ USB_DEVICE(0x1199, 0x0018) },	/* Sierra Wireless MC5720 */
 	{ USB_DEVICE(0x1199, 0x0218) },	/* Sierra Wireless MC5720 */
-	{ USB_DEVICE(0x0f30, 0x1b1d) },	/* Sierra Wireless MC5720 */
+	{ USB_DEVICE(0x03f0, 0x1b1d) }, /* HP ev2200 a.k.a MC5720 */
 	{ USB_DEVICE(0x1199, 0x0020) },	/* Sierra Wireless MC5725 */
 	{ USB_DEVICE(0x1199, 0x0024) },	/* Sierra Wireless MC5727 */
 	{ USB_DEVICE(0x1199, 0x0220) },	/* Sierra Wireless MC5725 */
@@ -175,6 +172,8 @@ static struct usb_device_id id_table [] = {
 	 /* Sierra Wireless Device */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x0025, 0xFF, 0xFF, 0xFF) },
 	{ USB_DEVICE(0x1199, 0x0026) }, /* Sierra Wireless Device */
+	{ USB_DEVICE(0x1199, 0x0027) }, /* Sierra Wireless Device */
+	{ USB_DEVICE(0x1199, 0x0028) }, /* Sierra Wireless Device */
 
 	{ USB_DEVICE(0x1199, 0x6802) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6804) },	/* Sierra Wireless MC8755 */
@@ -187,6 +186,7 @@ static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x1199, 0x6821) },	/* Sierra Wireless AirCard 875U */
 	{ USB_DEVICE(0x1199, 0x6832) },	/* Sierra Wireless MC8780 */
 	{ USB_DEVICE(0x1199, 0x6833) },	/* Sierra Wireless MC8781 */
+	{ USB_DEVICE(0x1199, 0x683A) },	/* Sierra Wireless MC8785 */
 	{ USB_DEVICE(0x1199, 0x683B) },	/* Sierra Wireless MC8785 Composite */
 	{ USB_DEVICE(0x1199, 0x683C) },	/* Sierra Wireless MC8790 */
 	{ USB_DEVICE(0x1199, 0x683D) },	/* Sierra Wireless MC8790 */
@@ -204,6 +204,8 @@ static struct usb_device_id id_table [] = {
 	/* Sierra Wireless Device */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x6890, 0xFF, 0xFF, 0xFF)},
 	/* Sierra Wireless Device */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x6891, 0xFF, 0xFF, 0xFF)},
+	/* Sierra Wireless Device */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x6892, 0xFF, 0xFF, 0xFF)},
 
 	{ USB_DEVICE(0x1199, 0x0112) }, /* Sierra Wireless AirCard 580 */
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index e39c779..9a3e495 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1744,7 +1744,7 @@ static int ti_download_firmware(struct ti_device *tdev, int type)
 	if (buffer) {
 		memcpy(buffer, fw_p->data, fw_p->size);
 		memset(buffer + fw_p->size, 0xff, buffer_size - fw_p->size);
-		ti_do_download(dev, pipe, buffer, fw_p->size);
+		status = ti_do_download(dev, pipe, buffer, fw_p->size);
 		kfree(buffer);
 	}
 	release_firmware(fw_p);
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index b157c48..4f7f9e3 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -733,7 +733,9 @@ int usb_serial_probe(struct usb_interface *interface,
 	    ((le16_to_cpu(dev->descriptor.idVendor) == ATEN_VENDOR_ID) &&
 	     (le16_to_cpu(dev->descriptor.idProduct) == ATEN_PRODUCT_ID)) ||
 	    ((le16_to_cpu(dev->descriptor.idVendor) == ALCOR_VENDOR_ID) &&
-	     (le16_to_cpu(dev->descriptor.idProduct) == ALCOR_PRODUCT_ID))) {
+	     (le16_to_cpu(dev->descriptor.idProduct) == ALCOR_PRODUCT_ID)) ||
+	    ((le16_to_cpu(dev->descriptor.idVendor) == SIEMENS_VENDOR_ID) &&
+	     (le16_to_cpu(dev->descriptor.idProduct) == SIEMENS_PRODUCT_ID_EF81))) {
 		if (interface != dev->actconfig->interface[0]) {
 			/* check out the endpoints of the other interface*/
 			iface_desc = dev->actconfig->interface[0]->cur_altsetting;
diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
index c760346..3d92496 100644
--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -146,18 +146,6 @@ config USB_STORAGE_KARMA
 	  on the resulting scsi device node returns the Karma to normal
 	  operation.
 
-config USB_STORAGE_SIERRA
-	bool "Sierra Wireless TRU-Install Feature Support"
-	depends on USB_STORAGE
-	help
-	  Say Y here to include additional code to support Sierra Wireless
-	  products with the TRU-Install feature (e.g., AC597E, AC881U).
-
-	  This code switches the Sierra Wireless device from being in
-	  Mass Storage mode to Modem mode. It also has the ability to
-	  support host software upgrades should full Linux support be added
-	  to TRU-Install.
-
 config USB_STORAGE_CYPRESS_ATACB
 	bool "SAT emulation on Cypress USB/ATA Bridge with ATACB"
 	depends on USB_STORAGE
diff --git a/drivers/usb/storage/Makefile b/drivers/usb/storage/Makefile
index bc3415b..7f8beb5 100644
--- a/drivers/usb/storage/Makefile
+++ b/drivers/usb/storage/Makefile
@@ -21,11 +21,10 @@ usb-storage-obj-$(CONFIG_USB_STORAGE_JUMPSHOT)	+= jumpshot.o
 usb-storage-obj-$(CONFIG_USB_STORAGE_ALAUDA)	+= alauda.o
 usb-storage-obj-$(CONFIG_USB_STORAGE_ONETOUCH)	+= onetouch.o
 usb-storage-obj-$(CONFIG_USB_STORAGE_KARMA)	+= karma.o
-usb-storage-obj-$(CONFIG_USB_STORAGE_SIERRA)	+= sierra_ms.o
 usb-storage-obj-$(CONFIG_USB_STORAGE_CYPRESS_ATACB) += cypress_atacb.o
 
 usb-storage-objs :=	scsiglue.o protocol.o transport.o usb.o \
-			initializers.o $(usb-storage-obj-y)
+			initializers.o sierra_ms.o $(usb-storage-obj-y)
 
 ifneq ($(CONFIG_USB_LIBUSUAL),)
 	obj-$(CONFIG_USB)	+= libusual.o
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index ba412e6..cd15547 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -160,6 +160,13 @@ UNUSUAL_DEV(  0x0421, 0x0019, 0x0592, 0x0592,
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_MAX_SECTORS_64 ),
 
+/* Reported by Filip Joelsson <filip@blueturtle.nu> */
+UNUSUAL_DEV(  0x0421, 0x005d, 0x0001, 0x0600,
+		"Nokia",
+		"Nokia 3110c",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY ),
+
 /* Reported by Mario Rettig <mariorettig@web.de> */
 UNUSUAL_DEV(  0x0421, 0x042e, 0x0100, 0x0100,
 		"Nokia",
@@ -232,6 +239,20 @@ UNUSUAL_DEV(  0x0421, 0x04b9, 0x0551, 0x0551,
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY ),
 
+/* Reported by Richard Nauber <RichardNauber@web.de> */
+UNUSUAL_DEV(  0x0421, 0x04fa, 0x0601, 0x0601,
+		"Nokia",
+		"6300",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY ),
+
+/* Patch for Nokia 5310 capacity */
+UNUSUAL_DEV(  0x0421, 0x006a, 0x0000, 0x0591,
+	"Nokia",
+	"5310",
+	US_SC_DEVICE, US_PR_DEVICE, NULL,
+	US_FL_FIX_CAPACITY ),
+
 /* Reported by Olaf Hering <olh@suse.de> from novell bug #105878 */
 UNUSUAL_DEV(  0x0424, 0x0fdc, 0x0210, 0x0210,
 		"SMSC",
@@ -987,6 +1008,13 @@ UNUSUAL_DEV(  0x069b, 0x3004, 0x0001, 0x0001,
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY ),
 
+/* Reported by Adrian Pilchowiec <adi1981@epf.pl> */
+UNUSUAL_DEV(  0x071b, 0x3203, 0x0000, 0x0000,
+		"RockChip",
+		"MP3",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_NO_WP_DETECT | US_FL_MAX_SECTORS_64),
+
 /* Reported by Massimiliano Ghilardi <massimiliano.ghilardi@gmail.com>
  * This USB MP3/AVI player device fails and disconnects if more than 128
  * sectors (64kB) are read/written in a single command, and may be present
@@ -1576,7 +1604,6 @@ UNUSUAL_DEV(  0x10d6, 0x2200, 0x0100, 0x0100,
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		0),
 
-#ifdef CONFIG_USB_STORAGE_SIERRA
 /* Reported by Kevin Lloyd <linux@sierrawireless.com>
  * Entry is needed for the initializer function override,
  * which instructs the device to load as a modem
@@ -1587,7 +1614,6 @@ UNUSUAL_DEV(  0x1199, 0x0fff, 0x0000, 0x9999,
 		"USB MMC Storage",
 		US_SC_DEVICE, US_PR_DEVICE, sierra_ms_init,
 		0),
-#endif
 
 /* Reported by Jaco Kroon <jaco@kroon.co.za>
  * The usb-storage module found on the Digitech GNX4 (and supposedly other
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 73679aa..27016fd 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -102,9 +102,7 @@
 #ifdef CONFIG_USB_STORAGE_CYPRESS_ATACB
 #include "cypress_atacb.h"
 #endif
-#ifdef CONFIG_USB_STORAGE_SIERRA
 #include "sierra_ms.h"
-#endif
 
 /* Some informational data */
 MODULE_AUTHOR("Matthew Dharm <mdharm-usb@one-eyed-alien.net>");
diff --git a/drivers/watchdog/geodewdt.c b/drivers/watchdog/geodewdt.c
index 614a5c7..6799a6d 100644
--- a/drivers/watchdog/geodewdt.c
+++ b/drivers/watchdog/geodewdt.c
@@ -130,8 +130,8 @@ static ssize_t geodewdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static int geodewdt_ioctl(struct inode *inode, struct file *file,
-				unsigned int cmd, unsigned long arg)
+static long geodewdt_ioctl(struct file *file, unsigned int cmd,
+				unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -198,7 +198,7 @@ static const struct file_operations geodewdt_fops = {
 	.owner          = THIS_MODULE,
 	.llseek         = no_llseek,
 	.write          = geodewdt_write,
-	.ioctl          = geodewdt_ioctl,
+	.unlocked_ioctl = geodewdt_ioctl,
 	.open           = geodewdt_open,
 	.release        = geodewdt_release,
 };
diff --git a/drivers/watchdog/ibmasr.c b/drivers/watchdog/ibmasr.c
index b82405c..89fcefc 100644
--- a/drivers/watchdog/ibmasr.c
+++ b/drivers/watchdog/ibmasr.c
@@ -85,7 +85,6 @@ static void __asr_toggle(void)
 
 	outb(reg & ~asr_toggle_mask, asr_write_addr);
 	reg = inb(asr_read_addr);
-	spin_unlock(&asr_lock);
 }
 
 static void asr_toggle(void)
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 0ed8416..6d9f3d4 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -173,8 +173,8 @@ static const struct watchdog_info ident = {
 	.identity = "PNX4008 Watchdog",
 };
 
-static long pnx4008_wdt_ioctl(struct inode *inode, struct file *file,
-					unsigned int cmd, unsigned long arg)
+static long pnx4008_wdt_ioctl(struct file *file, unsigned int cmd,
+				unsigned long arg)
 {
 	int ret = -ENOTTY;
 	int time;
diff --git a/drivers/watchdog/rc32434_wdt.c b/drivers/watchdog/rc32434_wdt.c
index 6756bcb..c9c73b6 100644
--- a/drivers/watchdog/rc32434_wdt.c
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -182,8 +182,8 @@ static ssize_t rc32434_wdt_write(struct file *file, const char *data,
 	return 0;
 }
 
-static int rc32434_wdt_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long rc32434_wdt_ioctl(struct file *file, unsigned int cmd,
+				unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int new_timeout;
@@ -242,7 +242,7 @@ static struct file_operations rc32434_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= rc32434_wdt_write,
-	.ioctl		= rc32434_wdt_ioctl,
+	.unlocked_ioctl	= rc32434_wdt_ioctl,
 	.open		= rc32434_wdt_open,
 	.release	= rc32434_wdt_release,
 };
diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index 9108efa..bf92802 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -144,8 +144,8 @@ static int rdc321x_wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int rdc321x_wdt_ioctl(struct inode *inode, struct file *file,
-				unsigned int cmd, unsigned long arg)
+static long rdc321x_wdt_ioctl(struct file *file, unsigned int cmd,
+				unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	unsigned int value;
@@ -204,7 +204,7 @@ static ssize_t rdc321x_wdt_write(struct file *file, const char __user *buf,
 static const struct file_operations rdc321x_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.ioctl		= rdc321x_wdt_ioctl,
+	.unlocked_ioctl	= rdc321x_wdt_ioctl,
 	.open		= rdc321x_wdt_open,
 	.write		= rdc321x_wdt_write,
 	.release	= rdc321x_wdt_release,
diff --git a/drivers/watchdog/wdt285.c b/drivers/watchdog/wdt285.c
index db362c3..191ea63 100644
--- a/drivers/watchdog/wdt285.c
+++ b/drivers/watchdog/wdt285.c
@@ -115,8 +115,8 @@ static int watchdog_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t watchdog_write(struct file *file, const char *data,
-						size_t len, loff_t *ppos)
+static ssize_t watchdog_write(struct file *file, const char __user *data,
+			      size_t len, loff_t *ppos)
 {
 	/*
 	 *	Refresh the timer.
@@ -133,21 +133,22 @@ static const struct watchdog_info ident = {
 };
 
 static long watchdog_ioctl(struct file *file, unsigned int cmd,
-							unsigned long arg)
+			   unsigned long arg)
 {
 	unsigned int new_margin;
+	int __user *int_arg = (int __user *)arg;
 	int ret = -ENOTTY;
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		ret = 0;
-		if (copy_to_user((void *)arg, &ident, sizeof(ident)))
+		if (copy_to_user((void __user *)arg, &ident, sizeof(ident)))
 			ret = -EFAULT;
 		break;
 
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(0, (int *)arg);
+		ret = put_user(0, int_arg);
 		break;
 
 	case WDIOC_KEEPALIVE:
@@ -156,7 +157,7 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 		break;
 
 	case WDIOC_SETTIMEOUT:
-		ret = get_user(new_margin, (int *)arg);
+		ret = get_user(new_margin, int_arg);
 		if (ret)
 			break;
 
@@ -171,7 +172,7 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 		watchdog_ping();
 		/* Fall */
 	case WDIOC_GETTIMEOUT:
-		ret = put_user(soft_margin, (int *)arg);
+		ret = put_user(soft_margin, int_arg);
 		break;
 	}
 	return ret;
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index c95295c..e83aa5e 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -626,8 +626,7 @@ static struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 	return NULL;
 
 error:
-	if (fid)
-		p9_client_clunk(fid);
+	p9_client_clunk(fid);
 
 	return ERR_PTR(result);
 }
diff --git a/include/asm-mips/pgtable-32.h b/include/asm-mips/pgtable-32.h
index 4396e9f..55813d6 100644
--- a/include/asm-mips/pgtable-32.h
+++ b/include/asm-mips/pgtable-32.h
@@ -57,7 +57,7 @@ extern int add_temporary_entry(unsigned long entrylo0, unsigned long entrylo1,
 #define PMD_ORDER	1
 #define PTE_ORDER	0
 
-#define PTRS_PER_PGD	((PAGE_SIZE << PGD_ORDER) / sizeof(pgd_t))
+#define PTRS_PER_PGD	(USER_PTRS_PER_PGD * 2)
 #define PTRS_PER_PTE	((PAGE_SIZE << PTE_ORDER) / sizeof(pte_t))
 
 #define USER_PTRS_PER_PGD	(0x80000000UL/PGDIR_SIZE)
diff --git a/include/asm-x86/acpi.h b/include/asm-x86/acpi.h
index 635d764..35d1743 100644
--- a/include/asm-x86/acpi.h
+++ b/include/asm-x86/acpi.h
@@ -140,6 +140,8 @@ static inline unsigned int acpi_processor_cstate_check(unsigned int max_cstate)
 	    boot_cpu_data.x86_model <= 0x05 &&
 	    boot_cpu_data.x86_mask < 0x0A)
 		return 1;
+	else if (boot_cpu_has(X86_FEATURE_AMDC1E))
+		return 1;
 	else
 		return max_cstate;
 }
diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index 9489283..cfcfb0a 100644
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -81,6 +81,7 @@
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* Lfence synchronizes RDTSC */
 #define X86_FEATURE_11AP	(3*32+19) /* Bad local APIC aka 11AP */
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
+#define X86_FEATURE_AMDC1E	(3*32+21) /* AMD C1E detected */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
diff --git a/include/asm-x86/idle.h b/include/asm-x86/idle.h
index d240e5b..cbb6491 100644
--- a/include/asm-x86/idle.h
+++ b/include/asm-x86/idle.h
@@ -10,4 +10,6 @@ void idle_notifier_register(struct notifier_block *n);
 void enter_idle(void);
 void exit_idle(void);
 
+void c1e_remove_cpu(int cpu);
+
 #endif
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 8a12d71..a26ebd2 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -667,6 +667,15 @@ static inline int ata_id_has_dword_io(const u16 *id)
 	return 0;
 }
 
+static inline int ata_id_has_unload(const u16 *id)
+{
+	if (ata_id_major_version(id) >= 7 &&
+	    (id[ATA_ID_CFSSE] & 0xC000) == 0x4000 &&
+	    id[ATA_ID_CFSSE] & (1 << 13))
+		return 1;
+	return 0;
+}
+
 static inline int ata_id_current_chs_valid(const u16 *id)
 {
 	/* For ATA-1 devices, if the INITIALIZE DEVICE PARAMETERS command
diff --git a/include/linux/cnt32_to_63.h b/include/linux/cnt32_to_63.h
new file mode 100644
index 0000000..8c0f950
--- /dev/null
+++ b/include/linux/cnt32_to_63.h
@@ -0,0 +1,80 @@
+/*
+ *  Extend a 32-bit counter to 63 bits
+ *
+ *  Author:	Nicolas Pitre
+ *  Created:	December 3, 2006
+ *  Copyright:	MontaVista Software, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ */
+
+#ifndef __LINUX_CNT32_TO_63_H__
+#define __LINUX_CNT32_TO_63_H__
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <asm/byteorder.h>
+
+/* this is used only to give gcc a clue about good code generation */
+union cnt32_to_63 {
+	struct {
+#if defined(__LITTLE_ENDIAN)
+		u32 lo, hi;
+#elif defined(__BIG_ENDIAN)
+		u32 hi, lo;
+#endif
+	};
+	u64 val;
+};
+
+
+/**
+ * cnt32_to_63 - Expand a 32-bit counter to a 63-bit counter
+ * @cnt_lo: The low part of the counter
+ *
+ * Many hardware clock counters are only 32 bits wide and therefore have
+ * a relatively short period making wrap-arounds rather frequent.  This
+ * is a problem when implementing sched_clock() for example, where a 64-bit
+ * non-wrapping monotonic value is expected to be returned.
+ *
+ * To overcome that limitation, let's extend a 32-bit counter to 63 bits
+ * in a completely lock free fashion. Bits 0 to 31 of the clock are provided
+ * by the hardware while bits 32 to 62 are stored in memory.  The top bit in
+ * memory is used to synchronize with the hardware clock half-period.  When
+ * the top bit of both counters (hardware and in memory) differ then the
+ * memory is updated with a new value, incrementing it when the hardware
+ * counter wraps around.
+ *
+ * Because a word store in memory is atomic then the incremented value will
+ * always be in synch with the top bit indicating to any potential concurrent
+ * reader if the value in memory is up to date or not with regards to the
+ * needed increment.  And any race in updating the value in memory is harmless
+ * as the same value would simply be stored more than once.
+ *
+ * The only restriction for the algorithm to work properly is that this
+ * code must be executed at least once per each half period of the 32-bit
+ * counter to properly update the state bit in memory. This is usually not a
+ * problem in practice, but if it is then a kernel timer could be scheduled
+ * to manage for this code to be executed often enough.
+ *
+ * Note that the top bit (bit 63) in the returned value should be considered
+ * as garbage.  It is not cleared here because callers are likely to use a
+ * multiplier on the returned value which can get rid of the top bit
+ * implicitly by making the multiplier even, therefore saving on a runtime
+ * clear-bit instruction. Otherwise caller must remember to clear the top
+ * bit explicitly.
+ */
+#define cnt32_to_63(cnt_lo) \
+({ \
+	static volatile u32 __m_cnt_hi; \
+	union cnt32_to_63 __x; \
+	__x.hi = __m_cnt_hi; \
+	__x.lo = (cnt_lo); \
+	if (unlikely((s32)(__x.hi ^ __x.lo) < 0)) \
+		__m_cnt_hi = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); \
+	__x.val; \
+})
+
+#endif
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 225bfc5..947cf84 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -146,6 +146,7 @@ enum {
 	ATA_DFLAG_SPUNDOWN	= (1 << 14), /* XXX: for spindown_compat */
 	ATA_DFLAG_SLEEPING	= (1 << 15), /* device is sleeping */
 	ATA_DFLAG_DUBIOUS_XFER	= (1 << 16), /* data transfer not verified */
+	ATA_DFLAG_NO_UNLOAD	= (1 << 17), /* device doesn't support unload */
 	ATA_DFLAG_INIT_MASK	= (1 << 24) - 1,
 
 	ATA_DFLAG_DETACH	= (1 << 24),
@@ -244,6 +245,7 @@ enum {
 	ATA_TMOUT_BOOT		= 30000,	/* heuristic */
 	ATA_TMOUT_BOOT_QUICK	=  7000,	/* heuristic */
 	ATA_TMOUT_INTERNAL_QUICK = 5000,
+	ATA_TMOUT_MAX_PARK	= 30000,
 
 	/* FIXME: GoVault needs 2s but we can't afford that without
 	 * parallel probing.  800ms is enough for iVDR disk
@@ -319,8 +321,11 @@ enum {
 	ATA_EH_RESET		= ATA_EH_SOFTRESET | ATA_EH_HARDRESET,
 	ATA_EH_ENABLE_LINK	= (1 << 3),
 	ATA_EH_LPM		= (1 << 4),  /* link power management action */
+	ATA_EH_PARK		= (1 << 5), /* unload heads and stop I/O */
 
-	ATA_EH_PERDEV_MASK	= ATA_EH_REVALIDATE,
+	ATA_EH_PERDEV_MASK	= ATA_EH_REVALIDATE | ATA_EH_PARK,
+	ATA_EH_ALL_ACTIONS	= ATA_EH_REVALIDATE | ATA_EH_RESET |
+				  ATA_EH_ENABLE_LINK | ATA_EH_LPM,
 
 	/* ata_eh_info->flags */
 	ATA_EHI_HOTPLUGGED	= (1 << 0),  /* could have been hotplugged */
@@ -452,6 +457,7 @@ enum link_pm {
 	MEDIUM_POWER,
 };
 extern struct device_attribute dev_attr_link_power_management_policy;
+extern struct device_attribute dev_attr_unload_heads;
 extern struct device_attribute dev_attr_em_message_type;
 extern struct device_attribute dev_attr_em_message;
 extern struct device_attribute dev_attr_sw_activity;
@@ -554,8 +560,8 @@ struct ata_ering {
 struct ata_device {
 	struct ata_link		*link;
 	unsigned int		devno;		/* 0 or 1 */
-	unsigned long		flags;		/* ATA_DFLAG_xxx */
 	unsigned int		horkage;	/* List of broken features */
+	unsigned long		flags;		/* ATA_DFLAG_xxx */
 	struct scsi_device	*sdev;		/* attached SCSI device */
 #ifdef CONFIG_ATA_ACPI
 	acpi_handle		acpi_handle;
@@ -564,6 +570,7 @@ struct ata_device {
 	/* n_sector is used as CLEAR_OFFSET, read comment above CLEAR_OFFSET */
 	u64			n_sectors;	/* size of device, if ATA */
 	unsigned int		class;		/* ATA_DEV_xxx */
+	unsigned long		unpark_deadline;
 
 	u8			pio_mode;
 	u8			dma_mode;
@@ -621,6 +628,7 @@ struct ata_eh_context {
 					       [ATA_EH_CMD_TIMEOUT_TABLE_SIZE];
 	unsigned int		classes[ATA_MAX_DEVICES];
 	unsigned int		did_probe_mask;
+	unsigned int		unloaded_mask;
 	unsigned int		saved_ncq_enabled;
 	u8			saved_xfer_mode[ATA_MAX_DEVICES];
 	/* timestamp for the last reset attempt or success */
@@ -688,7 +696,8 @@ struct ata_port {
 	unsigned int		qc_active;
 	int			nr_active_links; /* #links with active qcs */
 
-	struct ata_link		link;	/* host default link */
+	struct ata_link		link;		/* host default link */
+	struct ata_link		*slave_link;	/* see ata_slave_link_init() */
 
 	int			nr_pmp_links;	/* nr of available PMP links */
 	struct ata_link		*pmp_link;	/* array of PMP links */
@@ -709,6 +718,7 @@ struct ata_port {
 	struct list_head	eh_done_q;
 	wait_queue_head_t	eh_wait_q;
 	int			eh_tries;
+	struct completion	park_req_pending;
 
 	pm_message_t		pm_mesg;
 	int			*pm_result;
@@ -772,8 +782,8 @@ struct ata_port_operations {
 	/*
 	 * Optional features
 	 */
-	int  (*scr_read)(struct ata_port *ap, unsigned int sc_reg, u32 *val);
-	int  (*scr_write)(struct ata_port *ap, unsigned int sc_reg, u32 val);
+	int  (*scr_read)(struct ata_link *link, unsigned int sc_reg, u32 *val);
+	int  (*scr_write)(struct ata_link *link, unsigned int sc_reg, u32 val);
 	void (*pmp_attach)(struct ata_port *ap);
 	void (*pmp_detach)(struct ata_port *ap);
 	int  (*enable_pm)(struct ata_port *ap, enum link_pm policy);
@@ -895,6 +905,7 @@ extern void ata_port_disable(struct ata_port *);
 extern struct ata_host *ata_host_alloc(struct device *dev, int max_ports);
 extern struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 			const struct ata_port_info * const * ppi, int n_ports);
+extern int ata_slave_link_init(struct ata_port *ap);
 extern int ata_host_start(struct ata_host *host);
 extern int ata_host_register(struct ata_host *host,
 			     struct scsi_host_template *sht);
@@ -920,8 +931,8 @@ extern int sata_scr_valid(struct ata_link *link);
 extern int sata_scr_read(struct ata_link *link, int reg, u32 *val);
 extern int sata_scr_write(struct ata_link *link, int reg, u32 val);
 extern int sata_scr_write_flush(struct ata_link *link, int reg, u32 val);
-extern int ata_link_online(struct ata_link *link);
-extern int ata_link_offline(struct ata_link *link);
+extern bool ata_link_online(struct ata_link *link);
+extern bool ata_link_offline(struct ata_link *link);
 #ifdef CONFIG_PM
 extern int ata_host_suspend(struct ata_host *host, pm_message_t mesg);
 extern void ata_host_resume(struct ata_host *host);
@@ -1098,6 +1109,7 @@ extern void ata_std_error_handler(struct ata_port *ap);
  */
 extern const struct ata_port_operations ata_base_port_ops;
 extern const struct ata_port_operations sata_port_ops;
+extern struct device_attribute *ata_common_sdev_attrs[];
 
 #define ATA_BASE_SHT(drv_name)					\
 	.module			= THIS_MODULE,			\
@@ -1112,7 +1124,8 @@ extern const struct ata_port_operations sata_port_ops;
 	.proc_name		= drv_name,			\
 	.slave_configure	= ata_scsi_slave_config,	\
 	.slave_destroy		= ata_scsi_slave_destroy,	\
-	.bios_param		= ata_std_bios_param
+	.bios_param		= ata_std_bios_param,		\
+	.sdev_attrs		= ata_common_sdev_attrs
 
 #define ATA_NCQ_SHT(drv_name)					\
 	ATA_BASE_SHT(drv_name),					\
@@ -1134,7 +1147,7 @@ static inline bool sata_pmp_attached(struct ata_port *ap)
 
 static inline int ata_is_host_link(const struct ata_link *link)
 {
-	return link == &link->ap->link;
+	return link == &link->ap->link || link == link->ap->slave_link;
 }
 #else /* CONFIG_SATA_PMP */
 static inline bool sata_pmp_supported(struct ata_port *ap)
@@ -1167,7 +1180,7 @@ static inline int sata_srst_pmp(struct ata_link *link)
 	printk("%sata%u: "fmt, lv, (ap)->print_id , ##args)
 
 #define ata_link_printk(link, lv, fmt, args...) do { \
-	if (sata_pmp_attached((link)->ap)) \
+	if (sata_pmp_attached((link)->ap) || (link)->ap->slave_link)	\
 		printk("%sata%u.%02u: "fmt, lv, (link)->ap->print_id,	\
 		       (link)->pmp , ##args); \
 	else \
@@ -1265,34 +1278,17 @@ static inline int ata_link_active(struct ata_link *link)
 	return ata_tag_valid(link->active_tag) || link->sactive;
 }
 
-static inline struct ata_link *ata_port_first_link(struct ata_port *ap)
-{
-	if (sata_pmp_attached(ap))
-		return ap->pmp_link;
-	return &ap->link;
-}
-
-static inline struct ata_link *ata_port_next_link(struct ata_link *link)
-{
-	struct ata_port *ap = link->ap;
-
-	if (ata_is_host_link(link)) {
-		if (!sata_pmp_attached(ap))
-			return NULL;
-		return ap->pmp_link;
-	}
-
-	if (++link < ap->nr_pmp_links + ap->pmp_link)
-		return link;
-	return NULL;
-}
+extern struct ata_link *__ata_port_next_link(struct ata_port *ap,
+					     struct ata_link *link,
+					     bool dev_only);
 
-#define __ata_port_for_each_link(lk, ap) \
-	for ((lk) = &(ap)->link; (lk); (lk) = ata_port_next_link(lk))
+#define __ata_port_for_each_link(link, ap) \
+	for ((link) = __ata_port_next_link((ap), NULL, false); (link); \
+	     (link) = __ata_port_next_link((ap), (link), false))
 
 #define ata_port_for_each_link(link, ap) \
-	for ((link) = ata_port_first_link(ap); (link); \
-	     (link) = ata_port_next_link(link))
+	for ((link) = __ata_port_next_link((ap), NULL, true); (link); \
+	     (link) = __ata_port_next_link((ap), (link), true))
 
 #define ata_link_for_each_dev(dev, link) \
 	for ((dev) = (link)->device; \
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c0e1400..98dc624 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -534,7 +534,7 @@ extern void pci_sort_breadthfirst(void);
 #ifdef CONFIG_PCI_LEGACY
 struct pci_dev __deprecated *pci_find_device(unsigned int vendor,
 					     unsigned int device,
-					     const struct pci_dev *from);
+					     struct pci_dev *from);
 struct pci_dev __deprecated *pci_find_slot(unsigned int bus,
 					   unsigned int devfn);
 #endif /* CONFIG_PCI_LEGACY */
@@ -550,7 +550,7 @@ struct pci_dev *pci_get_device(unsigned int vendor, unsigned int device,
 				struct pci_dev *from);
 struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
 				unsigned int ss_vendor, unsigned int ss_device,
-				const struct pci_dev *from);
+				struct pci_dev *from);
 struct pci_dev *pci_get_slot(struct pci_bus *bus, unsigned int devfn);
 struct pci_dev *pci_get_bus_and_slot(unsigned int bus, unsigned int devfn);
 struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from);
@@ -816,7 +816,7 @@ _PCI_NOP_ALL(write,)
 
 static inline struct pci_dev *pci_find_device(unsigned int vendor,
 					      unsigned int device,
-					      const struct pci_dev *from)
+					      struct pci_dev *from)
 {
 	return NULL;
 }
@@ -838,7 +838,7 @@ static inline struct pci_dev *pci_get_subsys(unsigned int vendor,
 					     unsigned int device,
 					     unsigned int ss_vendor,
 					     unsigned int ss_device,
-					     const struct pci_dev *from)
+					     struct pci_dev *from)
 {
 	return NULL;
 }
diff --git a/include/linux/smb.h b/include/linux/smb.h
index caa43b2..82fefdd 100644
--- a/include/linux/smb.h
+++ b/include/linux/smb.h
@@ -11,7 +11,9 @@
 
 #include <linux/types.h>
 #include <linux/magic.h>
+#ifdef __KERNEL__
 #include <linux/time.h>
+#endif
 
 enum smb_protocol { 
 	SMB_PROTOCOL_NONE, 
diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index b3d3e27..c3626c0 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -596,4 +596,5 @@ int p9_idpool_check(int id, struct p9_idpool *p);
 int p9_error_init(void);
 int p9_errstr2errno(char *, int);
 int p9_trans_fd_init(void);
+void p9_trans_fd_exit(void);
 #endif /* NET_9P_H */
diff --git a/include/net/9p/transport.h b/include/net/9p/transport.h
index 0db3a40..3ca7371 100644
--- a/include/net/9p/transport.h
+++ b/include/net/9p/transport.h
@@ -26,6 +26,8 @@
 #ifndef NET_9P_TRANSPORT_H
 #define NET_9P_TRANSPORT_H
 
+#include <linux/module.h>
+
 /**
  * enum p9_trans_status - different states of underlying transports
  * @Connected: transport is connected and healthy
@@ -91,9 +93,12 @@ struct p9_trans_module {
 	int maxsize;		/* max message size of transport */
 	int def;		/* this transport should be default */
 	struct p9_trans * (*create)(const char *, char *, int, unsigned char);
+	struct module *owner;
 };
 
 void v9fs_register_trans(struct p9_trans_module *m);
-struct p9_trans_module *v9fs_match_trans(const substring_t *name);
-struct p9_trans_module *v9fs_default_trans(void);
+void v9fs_unregister_trans(struct p9_trans_module *m);
+struct p9_trans_module *v9fs_get_trans_by_name(const substring_t *name);
+struct p9_trans_module *v9fs_get_default_trans(void);
+void v9fs_put_trans(struct p9_trans_module *m);
 #endif /* NET_9P_TRANSPORT_H */
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 59f3f0d..aef2653 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -753,8 +753,14 @@ static struct page *kimage_alloc_page(struct kimage *image,
 			*old = addr | (*old & ~PAGE_MASK);
 
 			/* The old page I have found cannot be a
-			 * destination page, so return it.
+			 * destination page, so return it if it's
+			 * gfp_flags honor the ones passed in.
 			 */
+			if (!(gfp_mask & __GFP_HIGHMEM) &&
+			    PageHighMem(old_page)) {
+				kimage_free_pages(old_page);
+				continue;
+			}
 			addr = old_addr;
 			page = old_page;
 			break;
diff --git a/kernel/sched.c b/kernel/sched.c
index 9889080..13dd2db 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1087,7 +1087,7 @@ hotplug_hrtick(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	return NOTIFY_DONE;
 }
 
-static void init_hrtick(void)
+static __init void init_hrtick(void)
 {
 	hotcpu_notifier(hotplug_hrtick, 0);
 }
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f1f3eee..bd70345 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -235,7 +235,7 @@ static void tick_do_broadcast_on_off(void *why)
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
 		if (!cpu_isset(cpu, tick_broadcast_mask)) {
 			cpu_set(cpu, tick_broadcast_mask);
-			if (td->mode == TICKDEV_MODE_PERIODIC)
+			if (bc->mode == TICKDEV_MODE_PERIODIC)
 				clockevents_shutdown(dev);
 		}
 		if (*reason == CLOCK_EVT_NOTIFY_BROADCAST_FORCE)
@@ -245,7 +245,7 @@ static void tick_do_broadcast_on_off(void *why)
 		if (!tick_broadcast_force &&
 		    cpu_isset(cpu, tick_broadcast_mask)) {
 			cpu_clear(cpu, tick_broadcast_mask);
-			if (td->mode == TICKDEV_MODE_PERIODIC)
+			if (bc->mode == TICKDEV_MODE_PERIODIC)
 				tick_setup_periodic(dev, 0);
 		}
 		break;
@@ -575,4 +575,12 @@ void tick_shutdown_broadcast_oneshot(unsigned int *cpup)
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
+/*
+ * Check, whether the broadcast device is in one shot mode
+ */
+int tick_broadcast_oneshot_active(void)
+{
+	return tick_broadcast_device.mode == TICKDEV_MODE_ONESHOT;
+}
+
 #endif
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 019315e..df12434 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -33,7 +33,7 @@ DEFINE_PER_CPU(struct tick_device, tick_cpu_device);
  */
 ktime_t tick_next_period;
 ktime_t tick_period;
-int tick_do_timer_cpu __read_mostly = -1;
+int tick_do_timer_cpu __read_mostly = TICK_DO_TIMER_BOOT;
 DEFINE_SPINLOCK(tick_device_lock);
 
 /*
@@ -109,7 +109,8 @@ void tick_setup_periodic(struct clock_event_device *dev, int broadcast)
 	if (!tick_device_is_functional(dev))
 		return;
 
-	if (dev->features & CLOCK_EVT_FEAT_PERIODIC) {
+	if ((dev->features & CLOCK_EVT_FEAT_PERIODIC) &&
+	    !tick_broadcast_oneshot_active()) {
 		clockevents_set_mode(dev, CLOCK_EVT_MODE_PERIODIC);
 	} else {
 		unsigned long seq;
@@ -148,7 +149,7 @@ static void tick_setup_device(struct tick_device *td,
 		 * If no cpu took the do_timer update, assign it to
 		 * this cpu:
 		 */
-		if (tick_do_timer_cpu == -1) {
+		if (tick_do_timer_cpu == TICK_DO_TIMER_BOOT) {
 			tick_do_timer_cpu = cpu;
 			tick_next_period = ktime_get();
 			tick_period = ktime_set(0, NSEC_PER_SEC / HZ);
@@ -300,7 +301,8 @@ static void tick_shutdown(unsigned int *cpup)
 	if (*cpup == tick_do_timer_cpu) {
 		int cpu = first_cpu(cpu_online_map);
 
-		tick_do_timer_cpu = (cpu != NR_CPUS) ? cpu : -1;
+		tick_do_timer_cpu = (cpu != NR_CPUS) ? cpu :
+			TICK_DO_TIMER_NONE;
 	}
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 }
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 6e9db97..4692487 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -1,6 +1,10 @@
 /*
  * tick internal variable and functions used by low/high res code
  */
+
+#define TICK_DO_TIMER_NONE	-1
+#define TICK_DO_TIMER_BOOT	-2
+
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 extern spinlock_t tick_device_lock;
 extern ktime_t tick_next_period;
@@ -31,6 +35,7 @@ extern void tick_broadcast_oneshot_control(unsigned long reason);
 extern void tick_broadcast_switch_to_oneshot(void);
 extern void tick_shutdown_broadcast_oneshot(unsigned int *cpup);
 extern int tick_resume_broadcast_oneshot(struct clock_event_device *bc);
+extern int tick_broadcast_oneshot_active(void);
 # else /* BROADCAST */
 static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
@@ -39,6 +44,7 @@ static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
 static inline void tick_broadcast_switch_to_oneshot(void) { }
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
+static inline int tick_broadcast_oneshot_active(void) { return 0; }
 # endif /* !BROADCAST */
 
 #else /* !ONESHOT */
@@ -68,6 +74,7 @@ static inline int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 {
 	return 0;
 }
+static inline int tick_broadcast_oneshot_active(void) { return 0; }
 #endif /* !TICK_ONESHOT */
 
 /*
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a87b046..39019b3 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -75,6 +75,9 @@ static void tick_do_update_jiffies64(ktime_t now)
 							   incr * ticks);
 		}
 		do_timer(++ticks);
+
+		/* Keep the tick_next_period variable up to date */
+		tick_next_period = ktime_add(last_jiffies_update, tick_period);
 	}
 	write_sequnlock(&xtime_lock);
 }
@@ -221,7 +224,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	 */
 	if (unlikely(!cpu_online(cpu))) {
 		if (cpu == tick_do_timer_cpu)
-			tick_do_timer_cpu = -1;
+			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
 	}
 
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
@@ -303,7 +306,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 		 * invoked.
 		 */
 		if (cpu == tick_do_timer_cpu)
-			tick_do_timer_cpu = -1;
+			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
 
 		ts->idle_sleeps++;
 
@@ -468,7 +471,7 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 	 * this duty, then the jiffies update is still serialized by
 	 * xtime_lock.
 	 */
-	if (unlikely(tick_do_timer_cpu == -1))
+	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
 		tick_do_timer_cpu = cpu;
 
 	/* Check, if the jiffies need an update */
@@ -570,7 +573,7 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 	 * this duty, then the jiffies update is still serialized by
 	 * xtime_lock.
 	 */
-	if (unlikely(tick_do_timer_cpu == -1))
+	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
 		tick_do_timer_cpu = cpu;
 #endif
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0f1f7a7..c0500e4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -806,6 +806,7 @@ int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask)
 
 	do {
 		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask);
+		progress += res_counter_check_under_limit(&mem->res);
 	} while (!progress && --retry);
 
 	css_put(&mem->css);
diff --git a/mm/tiny-shmem.c b/mm/tiny-shmem.c
index ae532f5..d17cb6f 100644
--- a/mm/tiny-shmem.c
+++ b/mm/tiny-shmem.c
@@ -65,31 +65,25 @@ struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
 	if (!dentry)
 		goto put_memory;
 
-	error = -ENOSPC;
-	inode = ramfs_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0);
-	if (!inode)
-		goto put_dentry;
-
-	d_instantiate(dentry, inode);
 	error = -ENFILE;
-	file = alloc_file(shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
-			&ramfs_file_operations);
+	file = get_empty_filp();
 	if (!file)
 		goto put_dentry;
 
-	inode->i_nlink = 0;	/* It is unlinked */
-
-	/* notify everyone as to the change of file size */
-	error = do_truncate(dentry, size, 0, file);
-	if (error < 0)
+	error = -ENOSPC;
+	inode = ramfs_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0);
+	if (!inode)
 		goto close_file;
 
+	d_instantiate(dentry, inode);
+	inode->i_size = size;
+	inode->i_nlink = 0;	/* It is unlinked */
+	init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
+			&ramfs_file_operations);
 	return file;
 
 close_file:
 	put_filp(file);
-	return ERR_PTR(error);
-
 put_dentry:
 	dput(dentry);
 put_memory:
diff --git a/net/9p/client.c b/net/9p/client.c
index 2ffe40c..10e3203 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -75,7 +75,6 @@ static int parse_opts(char *opts, struct p9_client *clnt)
 	int option;
 	int ret = 0;
 
-	clnt->trans_mod = v9fs_default_trans();
 	clnt->dotu = 1;
 	clnt->msize = 8192;
 
@@ -108,7 +107,7 @@ static int parse_opts(char *opts, struct p9_client *clnt)
 			clnt->msize = option;
 			break;
 		case Opt_trans:
-			clnt->trans_mod = v9fs_match_trans(&args[0]);
+			clnt->trans_mod = v9fs_get_trans_by_name(&args[0]);
 			break;
 		case Opt_legacy:
 			clnt->dotu = 0;
@@ -117,6 +116,10 @@ static int parse_opts(char *opts, struct p9_client *clnt)
 			continue;
 		}
 	}
+
+	if (!clnt->trans_mod)
+		clnt->trans_mod = v9fs_get_default_trans();
+
 	kfree(options);
 	return ret;
 }
@@ -150,6 +153,7 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	if (!clnt)
 		return ERR_PTR(-ENOMEM);
 
+	clnt->trans_mod = NULL;
 	clnt->trans = NULL;
 	spin_lock_init(&clnt->lock);
 	INIT_LIST_HEAD(&clnt->fidlist);
@@ -235,6 +239,8 @@ void p9_client_destroy(struct p9_client *clnt)
 		clnt->trans = NULL;
 	}
 
+	v9fs_put_trans(clnt->trans_mod);
+
 	list_for_each_entry_safe(fid, fidptr, &clnt->fidlist, flist)
 		p9_fid_destroy(fid);
 
diff --git a/net/9p/conv.c b/net/9p/conv.c
index 4454720..5ad3a3b 100644
--- a/net/9p/conv.c
+++ b/net/9p/conv.c
@@ -451,8 +451,10 @@ p9_put_data(struct cbuf *bufp, const char *data, int count,
 		   unsigned char **pdata)
 {
 	*pdata = buf_alloc(bufp, count);
+	if (*pdata == NULL)
+		return -ENOMEM;
 	memmove(*pdata, data, count);
-	return count;
+	return 0;
 }
 
 static int
@@ -460,6 +462,8 @@ p9_put_user_data(struct cbuf *bufp, const char __user *data, int count,
 		   unsigned char **pdata)
 {
 	*pdata = buf_alloc(bufp, count);
+	if (*pdata == NULL)
+		return -ENOMEM;
 	return copy_from_user(*pdata, data, count);
 }
 
diff --git a/net/9p/mod.c b/net/9p/mod.c
index bdee1fb..1084feb 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -31,6 +31,7 @@
 #include <linux/parser.h>
 #include <net/9p/transport.h>
 #include <linux/list.h>
+#include <linux/spinlock.h>
 
 #ifdef CONFIG_NET_9P_DEBUG
 unsigned int p9_debug_level = 0;	/* feature-rific global debug level  */
@@ -44,8 +45,8 @@ MODULE_PARM_DESC(debug, "9P debugging level");
  *
  */
 
+static DEFINE_SPINLOCK(v9fs_trans_lock);
 static LIST_HEAD(v9fs_trans_list);
-static struct p9_trans_module *v9fs_default_transport;
 
 /**
  * v9fs_register_trans - register a new transport with 9p
@@ -54,48 +55,87 @@ static struct p9_trans_module *v9fs_default_transport;
  */
 void v9fs_register_trans(struct p9_trans_module *m)
 {
+	spin_lock(&v9fs_trans_lock);
 	list_add_tail(&m->list, &v9fs_trans_list);
-	if (m->def)
-		v9fs_default_transport = m;
+	spin_unlock(&v9fs_trans_lock);
 }
 EXPORT_SYMBOL(v9fs_register_trans);
 
 /**
- * v9fs_match_trans - match transport versus registered transports
+ * v9fs_unregister_trans - unregister a 9p transport
+ * @m: the transport to remove
+ *
+ */
+void v9fs_unregister_trans(struct p9_trans_module *m)
+{
+	spin_lock(&v9fs_trans_lock);
+	list_del_init(&m->list);
+	spin_unlock(&v9fs_trans_lock);
+}
+EXPORT_SYMBOL(v9fs_unregister_trans);
+
+/**
+ * v9fs_get_trans_by_name - get transport with the matching name
  * @name: string identifying transport
  *
  */
-struct p9_trans_module *v9fs_match_trans(const substring_t *name)
+struct p9_trans_module *v9fs_get_trans_by_name(const substring_t *name)
 {
-	struct list_head *p;
-	struct p9_trans_module *t = NULL;
-
-	list_for_each(p, &v9fs_trans_list) {
-		t = list_entry(p, struct p9_trans_module, list);
-		if (strncmp(t->name, name->from, name->to-name->from) == 0)
-			return t;
-	}
-	return NULL;
+	struct p9_trans_module *t, *found = NULL;
+
+	spin_lock(&v9fs_trans_lock);
+
+	list_for_each_entry(t, &v9fs_trans_list, list)
+		if (strncmp(t->name, name->from, name->to-name->from) == 0 &&
+		    try_module_get(t->owner)) {
+			found = t;
+			break;
+		}
+
+	spin_unlock(&v9fs_trans_lock);
+	return found;
 }
-EXPORT_SYMBOL(v9fs_match_trans);
+EXPORT_SYMBOL(v9fs_get_trans_by_name);
 
 /**
- * v9fs_default_trans - returns pointer to default transport
+ * v9fs_get_default_trans - get the default transport
  *
  */
 
-struct p9_trans_module *v9fs_default_trans(void)
+struct p9_trans_module *v9fs_get_default_trans(void)
 {
-	if (v9fs_default_transport)
-		return v9fs_default_transport;
-	else if (!list_empty(&v9fs_trans_list))
-		return list_first_entry(&v9fs_trans_list,
-					struct p9_trans_module, list);
-	else
-		return NULL;
+	struct p9_trans_module *t, *found = NULL;
+
+	spin_lock(&v9fs_trans_lock);
+
+	list_for_each_entry(t, &v9fs_trans_list, list)
+		if (t->def && try_module_get(t->owner)) {
+			found = t;
+			break;
+		}
+
+	if (!found)
+		list_for_each_entry(t, &v9fs_trans_list, list)
+			if (try_module_get(t->owner)) {
+				found = t;
+				break;
+			}
+
+	spin_unlock(&v9fs_trans_lock);
+	return found;
 }
-EXPORT_SYMBOL(v9fs_default_trans);
+EXPORT_SYMBOL(v9fs_get_default_trans);
 
+/**
+ * v9fs_put_trans - put trans
+ * @m: transport to put
+ *
+ */
+void v9fs_put_trans(struct p9_trans_module *m)
+{
+	if (m)
+		module_put(m->owner);
+}
 
 /**
  * v9fs_init - Initialize module
@@ -120,6 +160,8 @@ static int __init init_p9(void)
 static void __exit exit_p9(void)
 {
 	printk(KERN_INFO "Unloading 9P2000 support\n");
+
+	p9_trans_fd_exit();
 }
 
 module_init(init_p9)
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index cdf137a..d652baf 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -151,7 +151,6 @@ struct p9_mux_poll_task {
  * @trans: reference to transport instance for this connection
  * @tagpool: id accounting for transactions
  * @err: error state
- * @equeue: event wait_q (?)
  * @req_list: accounting for requests which have been sent
  * @unsent_req_list: accounting for requests that haven't been sent
  * @rcall: current response &p9_fcall structure
@@ -178,7 +177,6 @@ struct p9_conn {
 	struct p9_trans *trans;
 	struct p9_idpool *tagpool;
 	int err;
-	wait_queue_head_t equeue;
 	struct list_head req_list;
 	struct list_head unsent_req_list;
 	struct p9_fcall *rcall;
@@ -240,22 +238,6 @@ static int p9_conn_rpcnb(struct p9_conn *m, struct p9_fcall *tc,
 
 static void p9_conn_cancel(struct p9_conn *m, int err);
 
-static int p9_mux_global_init(void)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(p9_mux_poll_tasks); i++)
-		p9_mux_poll_tasks[i].task = NULL;
-
-	p9_mux_wq = create_workqueue("v9fs");
-	if (!p9_mux_wq) {
-		printk(KERN_WARNING "v9fs: mux: creating workqueue failed\n");
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
 static u16 p9_mux_get_tag(struct p9_conn *m)
 {
 	int tag;
@@ -409,11 +391,11 @@ static void p9_mux_poll_stop(struct p9_conn *m)
 static struct p9_conn *p9_conn_create(struct p9_trans *trans)
 {
 	int i, n;
-	struct p9_conn *m, *mtmp;
+	struct p9_conn *m;
 
 	P9_DPRINTK(P9_DEBUG_MUX, "transport %p msize %d\n", trans,
 								trans->msize);
-	m = kmalloc(sizeof(struct p9_conn), GFP_KERNEL);
+	m = kzalloc(sizeof(struct p9_conn), GFP_KERNEL);
 	if (!m)
 		return ERR_PTR(-ENOMEM);
 
@@ -424,25 +406,14 @@ static struct p9_conn *p9_conn_create(struct p9_trans *trans)
 	m->trans = trans;
 	m->tagpool = p9_idpool_create();
 	if (IS_ERR(m->tagpool)) {
-		mtmp = ERR_PTR(-ENOMEM);
 		kfree(m);
-		return mtmp;
+		return ERR_PTR(-ENOMEM);
 	}
 
-	m->err = 0;
-	init_waitqueue_head(&m->equeue);
 	INIT_LIST_HEAD(&m->req_list);
 	INIT_LIST_HEAD(&m->unsent_req_list);
-	m->rcall = NULL;
-	m->rpos = 0;
-	m->rbuf = NULL;
-	m->wpos = m->wsize = 0;
-	m->wbuf = NULL;
 	INIT_WORK(&m->rq, p9_read_work);
 	INIT_WORK(&m->wq, p9_write_work);
-	m->wsched = 0;
-	memset(&m->poll_waddr, 0, sizeof(m->poll_waddr));
-	m->poll_task = NULL;
 	n = p9_mux_poll_start(m);
 	if (n) {
 		kfree(m);
@@ -463,10 +434,8 @@ static struct p9_conn *p9_conn_create(struct p9_trans *trans)
 	for (i = 0; i < ARRAY_SIZE(m->poll_waddr); i++) {
 		if (IS_ERR(m->poll_waddr[i])) {
 			p9_mux_poll_stop(m);
-			mtmp = (void *)m->poll_waddr;	/* the error code */
 			kfree(m);
-			m = mtmp;
-			break;
+			return (void *)m->poll_waddr;	/* the error code */
 		}
 	}
 
@@ -483,18 +452,13 @@ static void p9_conn_destroy(struct p9_conn *m)
 {
 	P9_DPRINTK(P9_DEBUG_MUX, "mux %p prev %p next %p\n", m,
 		m->mux_list.prev, m->mux_list.next);
-	p9_conn_cancel(m, -ECONNRESET);
-
-	if (!list_empty(&m->req_list)) {
-		/* wait until all processes waiting on this session exit */
-		P9_DPRINTK(P9_DEBUG_MUX,
-			"mux %p waiting for empty request queue\n", m);
-		wait_event_timeout(m->equeue, (list_empty(&m->req_list)), 5000);
-		P9_DPRINTK(P9_DEBUG_MUX, "mux %p request queue empty: %d\n", m,
-			list_empty(&m->req_list));
-	}
 
 	p9_mux_poll_stop(m);
+	cancel_work_sync(&m->rq);
+	cancel_work_sync(&m->wq);
+
+	p9_conn_cancel(m, -ECONNRESET);
+
 	m->trans = NULL;
 	p9_idpool_destroy(m->tagpool);
 	kfree(m);
@@ -840,8 +804,6 @@ static void p9_read_work(struct work_struct *work)
 					(*req->cb) (req, req->cba);
 				else
 					kfree(req->rcall);
-
-				wake_up(&m->equeue);
 			}
 		} else {
 			if (err >= 0 && rcall->id != P9_RFLUSH)
@@ -908,8 +870,10 @@ static struct p9_req *p9_send_request(struct p9_conn *m,
 	else
 		n = p9_mux_get_tag(m);
 
-	if (n < 0)
+	if (n < 0) {
+		kfree(req);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	p9_set_tag(tc, n);
 
@@ -984,8 +948,6 @@ static void p9_mux_flush_cb(struct p9_req *freq, void *a)
 			(*req->cb) (req, req->cba);
 		else
 			kfree(req->rcall);
-
-		wake_up(&m->equeue);
 	}
 
 	kfree(freq->tcall);
@@ -1191,8 +1153,6 @@ void p9_conn_cancel(struct p9_conn *m, int err)
 		else
 			kfree(req->rcall);
 	}
-
-	wake_up(&m->equeue);
 }
 
 /**
@@ -1370,7 +1330,6 @@ p9_fd_poll(struct p9_trans *trans, struct poll_table_struct *pt)
 {
 	int ret, n;
 	struct p9_trans_fd *ts = NULL;
-	mm_segment_t oldfs;
 
 	if (trans && trans->status == Connected)
 		ts = trans->priv;
@@ -1384,24 +1343,17 @@ p9_fd_poll(struct p9_trans *trans, struct poll_table_struct *pt)
 	if (!ts->wr->f_op || !ts->wr->f_op->poll)
 		return -EIO;
 
-	oldfs = get_fs();
-	set_fs(get_ds());
-
 	ret = ts->rd->f_op->poll(ts->rd, pt);
 	if (ret < 0)
-		goto end;
+		return ret;
 
 	if (ts->rd != ts->wr) {
 		n = ts->wr->f_op->poll(ts->wr, pt);
-		if (n < 0) {
-			ret = n;
-			goto end;
-		}
+		if (n < 0)
+			return n;
 		ret = (ret & ~POLLOUT) | (n & ~POLLIN);
 	}
 
-end:
-	set_fs(oldfs);
 	return ret;
 }
 
@@ -1629,6 +1581,7 @@ static struct p9_trans_module p9_tcp_trans = {
 	.maxsize = MAX_SOCK_BUF,
 	.def = 1,
 	.create = p9_trans_create_tcp,
+	.owner = THIS_MODULE,
 };
 
 static struct p9_trans_module p9_unix_trans = {
@@ -1636,6 +1589,7 @@ static struct p9_trans_module p9_unix_trans = {
 	.maxsize = MAX_SOCK_BUF,
 	.def = 0,
 	.create = p9_trans_create_unix,
+	.owner = THIS_MODULE,
 };
 
 static struct p9_trans_module p9_fd_trans = {
@@ -1643,14 +1597,20 @@ static struct p9_trans_module p9_fd_trans = {
 	.maxsize = MAX_SOCK_BUF,
 	.def = 0,
 	.create = p9_trans_create_fd,
+	.owner = THIS_MODULE,
 };
 
 int p9_trans_fd_init(void)
 {
-	int ret = p9_mux_global_init();
-	if (ret) {
-		printk(KERN_WARNING "9p: starting mux failed\n");
-		return ret;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(p9_mux_poll_tasks); i++)
+		p9_mux_poll_tasks[i].task = NULL;
+
+	p9_mux_wq = create_workqueue("v9fs");
+	if (!p9_mux_wq) {
+		printk(KERN_WARNING "v9fs: mux: creating workqueue failed\n");
+		return -ENOMEM;
 	}
 
 	v9fs_register_trans(&p9_tcp_trans);
@@ -1659,4 +1619,12 @@ int p9_trans_fd_init(void)
 
 	return 0;
 }
-EXPORT_SYMBOL(p9_trans_fd_init);
+
+void p9_trans_fd_exit(void)
+{
+	v9fs_unregister_trans(&p9_tcp_trans);
+	v9fs_unregister_trans(&p9_unix_trans);
+	v9fs_unregister_trans(&p9_fd_trans);
+
+	destroy_workqueue(p9_mux_wq);
+}
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 42adc05..94912e0 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -528,6 +528,7 @@ static struct p9_trans_module p9_virtio_trans = {
 	.create = p9_virtio_create,
 	.maxsize = PAGE_SIZE*16,
 	.def = 0,
+	.owner = THIS_MODULE,
 };
 
 /* The standard init function */
@@ -545,6 +546,7 @@ static int __init p9_virtio_init(void)
 static void __exit p9_virtio_cleanup(void)
 {
 	unregister_virtio_driver(&p9_virtio_drv);
+	v9fs_unregister_trans(&p9_virtio_trans);
 }
 
 module_init(p9_virtio_init);
diff --git a/net/core/dev.c b/net/core/dev.c
index e719ed2..e8eb2b4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -122,6 +122,7 @@
 #include <linux/if_arp.h>
 #include <linux/if_vlan.h>
 #include <linux/ip.h>
+#include <net/ip.h>
 #include <linux/ipv6.h>
 #include <linux/in.h>
 #include <linux/jhash.h>
@@ -1667,7 +1668,7 @@ static u16 simple_tx_hash(struct net_device *dev, struct sk_buff *skb)
 {
 	u32 addr1, addr2, ports;
 	u32 hash, ihl;
-	u8 ip_proto;
+	u8 ip_proto = 0;
 
 	if (unlikely(!simple_tx_hashrnd_initialized)) {
 		get_random_bytes(&simple_tx_hashrnd, 4);
@@ -1676,7 +1677,8 @@ static u16 simple_tx_hash(struct net_device *dev, struct sk_buff *skb)
 
 	switch (skb->protocol) {
 	case __constant_htons(ETH_P_IP):
-		ip_proto = ip_hdr(skb)->protocol;
+		if (!(ip_hdr(skb)->frag_off & htons(IP_MF | IP_OFFSET)))
+			ip_proto = ip_hdr(skb)->protocol;
 		addr1 = ip_hdr(skb)->saddr;
 		addr2 = ip_hdr(skb)->daddr;
 		ihl = ip_hdr(skb)->ihl;
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 62e39ac..26654b2 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -97,8 +97,6 @@ hbh_mt6(const struct sk_buff *skb, const struct net_device *in,
 	hdrlen -= 2;
 	if (!(optinfo->flags & IP6T_OPTS_OPTS)) {
 		return ret;
-	} else if (optinfo->flags & IP6T_OPTS_NSTRICT) {
-		pr_debug("Not strict - not implemented");
 	} else {
 		pr_debug("Strict ");
 		pr_debug("#%d ", optinfo->optsnr);
@@ -177,6 +175,12 @@ hbh_mt6_check(const char *tablename, const void *entry,
 		pr_debug("ip6t_opts: unknown flags %X\n", optsinfo->invflags);
 		return false;
 	}
+
+	if (optsinfo->flags & IP6T_OPTS_NSTRICT) {
+		pr_debug("ip6t_opts: Not strict - not implemented");
+		return false;
+	}
+
 	return true;
 }
 
diff --git a/net/socket.c b/net/socket.c
index 8ef8ba8..3e8d4e3 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1511,6 +1511,7 @@ out_fd:
 	goto out_put;
 }
 
+#if 0
 #ifdef HAVE_SET_RESTORE_SIGMASK
 asmlinkage long sys_paccept(int fd, struct sockaddr __user *upeer_sockaddr,
 			    int __user *upeer_addrlen,
@@ -1564,6 +1565,7 @@ asmlinkage long sys_paccept(int fd, struct sockaddr __user *upeer_sockaddr,
 	return do_accept(fd, upeer_sockaddr, upeer_addrlen, flags);
 }
 #endif
+#endif
 
 asmlinkage long sys_accept(int fd, struct sockaddr __user *upeer_sockaddr,
 			   int __user *upeer_addrlen)
diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index ff787e6..44ee94d 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -781,6 +781,7 @@ sub output_struct_xml(%) {
     print " <refsect1>\n";
     print "  <title>Members</title>\n";
 
+    if ($#{$args{'parameterlist'}} >= 0) {
     print "  <variablelist>\n";
     foreach $parameter (@{$args{'parameterlist'}}) {
       ($parameter =~ /^#/) && next;
@@ -798,6 +799,9 @@ sub output_struct_xml(%) {
       print "    </varlistentry>\n";
     }
     print "  </variablelist>\n";
+    } else {
+	print " <para>\n  None\n </para>\n";
+    }
     print " </refsect1>\n";
 
     output_section_xml(@_);
diff --git a/sound/soc/at32/at32-pcm.c b/sound/soc/at32/at32-pcm.c
index 435f1da..c83584f 100644
--- a/sound/soc/at32/at32-pcm.c
+++ b/sound/soc/at32/at32-pcm.c
@@ -434,7 +434,8 @@ static int at32_pcm_suspend(struct platform_device *pdev,
 	params = prtd->params;
 
 	/* Disable the PDC and save the PDC registers */
-	ssc_writex(params->ssc->regs, PDC_PTCR, params->mask->pdc_disable);
+	ssc_writex(params->ssc->regs, ATMEL_PDC_PTCR,
+		   params->mask->pdc_disable);
 
 	prtd->pdc_xpr_save = ssc_readx(params->ssc->regs, params->pdc->xpr);
 	prtd->pdc_xcr_save = ssc_readx(params->ssc->regs, params->pdc->xcr);
@@ -464,7 +465,7 @@ static int at32_pcm_resume(struct platform_device *pdev,
 	ssc_writex(params->ssc->regs, params->pdc->xnpr, prtd->pdc_xnpr_save);
 	ssc_writex(params->ssc->regs, params->pdc->xncr, prtd->pdc_xncr_save);
 
-	ssc_writex(params->ssc->regs, PDC_PTCR, params->mask->pdc_enable);
+	ssc_writex(params->ssc->regs, ATMEL_PDC_PTCR, params->mask->pdc_enable);
 	return 0;
 }
 #else /* CONFIG_PM */

--------------080005090304000705080903--
