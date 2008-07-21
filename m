Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbYGUTy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbYGUTy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbYGUTyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:54:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45978 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbYGUTyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:54:49 -0400
Date: Mon, 21 Jul 2008 21:54:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] x86 updates for v2.6.27, phase #2
Message-ID: <20080721195432.GA7107@elte.hu>
References: <20080721150415.GA19921@elte.hu> <20080721153256.GA13557@elte.hu> <alpine.LFD.1.10.0807211041530.31863@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807211041530.31863@woody.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.3 required=5.9 tests=BAYES_00,FRT_LEVITRA autolearn=no SpamAssassin version=3.2.3
	1.8 FRT_LEVITRA            BODY: ReplaceTags: Levitra
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 21 Jul 2008, Ingo Molnar wrote:
> > 
> > i'll fix it ... Dprintk in apic.h is historic and ugly. Should i 
> > redo the tree and the pull request?
> 
> I already pulled it, so please just send a (tested) patch. But it 
> would have ben _so_ much better to have noticed this before-the-fact.

yeah, sorry about that. Thomas has fixed up that old mess and i've 
tested it, please pull the fix from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Thanks,

	Ingo

------------------>
Thomas Gleixner (1):
      x86: convert Dprintk to pr_debug


 arch/x86/kernel/acpi/boot.c                  |    6 +-
 arch/x86/kernel/cpu/perfctr-watchdog.c       |    4 +-
 arch/x86/kernel/setup_percpu.c               |    6 +-
 arch/x86/kernel/smpboot.c                    |   52 +++++++++++++-------------
 arch/x86/mm/numa_64.c                        |    4 --
 arch/x86/pci/early.c                         |   16 +++----
 include/asm-x86/apic.h                       |    2 -
 include/asm-x86/mach-default/smpboot_hooks.h |    6 +-
 8 files changed, 44 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index f489d7a..fa88a1d 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1021,7 +1021,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 	mp_bus_id_to_type[MP_ISA_BUS] = MP_BUS_ISA;
 #endif
 	set_bit(MP_ISA_BUS, mp_bus_not_pci);
-	Dprintk("Bus #%d is ISA\n", MP_ISA_BUS);
+	pr_debug("Bus #%d is ISA\n", MP_ISA_BUS);
 
 #ifdef CONFIG_X86_ES7000
 	/*
@@ -1127,8 +1127,8 @@ int mp_register_gsi(u32 gsi, int triggering, int polarity)
 		return gsi;
 	}
 	if (test_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed)) {
-		Dprintk(KERN_DEBUG "Pin %d-%d already programmed\n",
-			mp_ioapic_routing[ioapic].apic_id, ioapic_pin);
+		pr_debug(KERN_DEBUG "Pin %d-%d already programmed\n",
+			 mp_ioapic_routing[ioapic].apic_id, ioapic_pin);
 #ifdef CONFIG_X86_32
 		return (gsi < IRQ_COMPRESSION_START ? gsi : gsi_to_irq[gsi]);
 #else
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index 6d4bdc0..de7439f 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -250,7 +250,7 @@ static void write_watchdog_counter(unsigned int perfctr_msr,
 
 	do_div(count, nmi_hz);
 	if(descr)
-		Dprintk("setting %s to -0x%08Lx\n", descr, count);
+		pr_debug("setting %s to -0x%08Lx\n", descr, count);
 	wrmsrl(perfctr_msr, 0 - count);
 }
 
@@ -261,7 +261,7 @@ static void write_watchdog_counter32(unsigned int perfctr_msr,
 
 	do_div(count, nmi_hz);
 	if(descr)
-		Dprintk("setting %s to -0x%08Lx\n", descr, count);
+		pr_debug("setting %s to -0x%08Lx\n", descr, count);
 	wrmsr(perfctr_msr, (u32)(-count), 0);
 }
 
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index cac6843..f7745f9 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -227,8 +227,8 @@ static void __init setup_node_to_cpumask_map(void)
 	/* allocate the map */
 	map = alloc_bootmem_low(nr_node_ids * sizeof(cpumask_t));
 
-	Dprintk(KERN_DEBUG "Node to cpumask map at %p for %d nodes\n",
-		map, nr_node_ids);
+	pr_debug(KERN_DEBUG "Node to cpumask map at %p for %d nodes\n",
+		 map, nr_node_ids);
 
 	/* node_to_cpumask() will now work */
 	node_to_cpumask_map = map;
@@ -248,7 +248,7 @@ void __cpuinit numa_set_node(int cpu, int node)
 		per_cpu(x86_cpu_to_node_map, cpu) = node;
 
 	else
-		Dprintk(KERN_INFO "Setting node for non-present cpu %d\n", cpu);
+		pr_debug("Setting node for non-present cpu %d\n", cpu);
 }
 
 void __cpuinit numa_clear_node(int cpu)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2764019..4b53a64 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -216,7 +216,7 @@ static void __cpuinit smp_callin(void)
 		panic("%s: phys CPU#%d, CPU#%d already present??\n", __func__,
 					phys_id, cpuid);
 	}
-	Dprintk("CPU#%d (phys ID: %d) waiting for CALLOUT\n", cpuid, phys_id);
+	pr_debug("CPU#%d (phys ID: %d) waiting for CALLOUT\n", cpuid, phys_id);
 
 	/*
 	 * STARTUP IPIs are fragile beasts as they might sometimes
@@ -251,7 +251,7 @@ static void __cpuinit smp_callin(void)
 	 * boards)
 	 */
 
-	Dprintk("CALLIN, before setup_local_APIC().\n");
+	pr_debug("CALLIN, before setup_local_APIC().\n");
 	smp_callin_clear_local_apic();
 	setup_local_APIC();
 	end_local_APIC_setup();
@@ -266,7 +266,7 @@ static void __cpuinit smp_callin(void)
 	local_irq_enable();
 	calibrate_delay();
 	local_irq_disable();
-	Dprintk("Stack at about %p\n", &cpuid);
+	pr_debug("Stack at about %p\n", &cpuid);
 
 	/*
 	 * Save our processor parameters
@@ -513,7 +513,7 @@ static void impress_friends(void)
 	/*
 	 * Allow the user to impress friends.
 	 */
-	Dprintk("Before bogomips.\n");
+	pr_debug("Before bogomips.\n");
 	for_each_possible_cpu(cpu)
 		if (cpu_isset(cpu, cpu_callout_map))
 			bogosum += cpu_data(cpu).loops_per_jiffy;
@@ -523,7 +523,7 @@ static void impress_friends(void)
 		bogosum/(500000/HZ),
 		(bogosum/(5000/HZ))%100);
 
-	Dprintk("Before bogocount - setting activated=1.\n");
+	pr_debug("Before bogocount - setting activated=1.\n");
 }
 
 static inline void __inquire_remote_apic(int apicid)
@@ -585,7 +585,7 @@ wakeup_secondary_cpu(int logical_apicid, unsigned long start_eip)
 	/* Kick the second */
 	apic_write(APIC_ICR, APIC_DM_NMI | APIC_DEST_LOGICAL);
 
-	Dprintk("Waiting for send to finish...\n");
+	pr_debug("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
 
 	/*
@@ -596,7 +596,7 @@ wakeup_secondary_cpu(int logical_apicid, unsigned long start_eip)
 	if (maxlvt > 3)			/* Due to the Pentium erratum 3AP.  */
 		apic_write(APIC_ESR, 0);
 	accept_status = (apic_read(APIC_ESR) & 0xEF);
-	Dprintk("NMI sent.\n");
+	pr_debug("NMI sent.\n");
 
 	if (send_status)
 		printk(KERN_ERR "APIC never delivered???\n");
@@ -631,7 +631,7 @@ wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
 		apic_read(APIC_ESR);
 	}
 
-	Dprintk("Asserting INIT.\n");
+	pr_debug("Asserting INIT.\n");
 
 	/*
 	 * Turn INIT on target chip
@@ -644,12 +644,12 @@ wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
 	apic_write(APIC_ICR,
 		   APIC_INT_LEVELTRIG | APIC_INT_ASSERT | APIC_DM_INIT);
 
-	Dprintk("Waiting for send to finish...\n");
+	pr_debug("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
 
 	mdelay(10);
 
-	Dprintk("Deasserting INIT.\n");
+	pr_debug("Deasserting INIT.\n");
 
 	/* Target chip */
 	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
@@ -657,7 +657,7 @@ wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
 	/* Send IPI */
 	apic_write(APIC_ICR, APIC_INT_LEVELTRIG | APIC_DM_INIT);
 
-	Dprintk("Waiting for send to finish...\n");
+	pr_debug("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
 
 	mb();
@@ -684,14 +684,14 @@ wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
 	/*
 	 * Run STARTUP IPI loop.
 	 */
-	Dprintk("#startup loops: %d.\n", num_starts);
+	pr_debug("#startup loops: %d.\n", num_starts);
 
 	for (j = 1; j <= num_starts; j++) {
-		Dprintk("Sending STARTUP #%d.\n", j);
+		pr_debug("Sending STARTUP #%d.\n", j);
 		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP.  */
 			apic_write(APIC_ESR, 0);
 		apic_read(APIC_ESR);
-		Dprintk("After apic_write.\n");
+		pr_debug("After apic_write.\n");
 
 		/*
 		 * STARTUP IPI
@@ -709,9 +709,9 @@ wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
 		 */
 		udelay(300);
 
-		Dprintk("Startup point 1.\n");
+		pr_debug("Startup point 1.\n");
 
-		Dprintk("Waiting for send to finish...\n");
+		pr_debug("Waiting for send to finish...\n");
 		send_status = safe_apic_wait_icr_idle();
 
 		/*
@@ -724,7 +724,7 @@ wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
 		if (send_status || accept_status)
 			break;
 	}
-	Dprintk("After Startup.\n");
+	pr_debug("After Startup.\n");
 
 	if (send_status)
 		printk(KERN_ERR "APIC never delivered???\n");
@@ -875,7 +875,7 @@ do_rest:
 
 	if (get_uv_system_type() != UV_NON_UNIQUE_APIC) {
 
-		Dprintk("Setting warm reset code and vector.\n");
+		pr_debug("Setting warm reset code and vector.\n");
 
 		store_NMI_vector(&nmi_high, &nmi_low);
 
@@ -896,9 +896,9 @@ do_rest:
 		/*
 		 * allow APs to start initializing.
 		 */
-		Dprintk("Before Callout %d.\n", cpu);
+		pr_debug("Before Callout %d.\n", cpu);
 		cpu_set(cpu, cpu_callout_map);
-		Dprintk("After Callout %d.\n", cpu);
+		pr_debug("After Callout %d.\n", cpu);
 
 		/*
 		 * Wait 5s total for a response
@@ -911,10 +911,10 @@ do_rest:
 
 		if (cpu_isset(cpu, cpu_callin_map)) {
 			/* number CPUs logically, starting from 1 (BSP is 0) */
-			Dprintk("OK.\n");
+			pr_debug("OK.\n");
 			printk(KERN_INFO "CPU%d: ", cpu);
 			print_cpu_info(&cpu_data(cpu));
-			Dprintk("CPU has booted.\n");
+			pr_debug("CPU has booted.\n");
 		} else {
 			boot_error = 1;
 			if (*((volatile unsigned char *)trampoline_base)
@@ -959,7 +959,7 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 
 	WARN_ON(irqs_disabled());
 
-	Dprintk("++++++++++++++++++++=_---CPU UP  %u\n", cpu);
+	pr_debug("++++++++++++++++++++=_---CPU UP  %u\n", cpu);
 
 	if (apicid == BAD_APICID || apicid == boot_cpu_physical_apicid ||
 	    !physid_isset(apicid, phys_cpu_present_map)) {
@@ -971,7 +971,7 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 	 * Already booted CPU?
 	 */
 	if (cpu_isset(cpu, cpu_callin_map)) {
-		Dprintk("do_boot_cpu %d Already started\n", cpu);
+		pr_debug("do_boot_cpu %d Already started\n", cpu);
 		return -ENOSYS;
 	}
 
@@ -998,7 +998,7 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 	err = do_boot_cpu(apicid, cpu);
 #endif
 	if (err) {
-		Dprintk("do_boot_cpu failed %d\n", err);
+		pr_debug("do_boot_cpu failed %d\n", err);
 		return -EIO;
 	}
 
@@ -1202,7 +1202,7 @@ void __init native_smp_prepare_boot_cpu(void)
 
 void __init native_smp_cpus_done(unsigned int max_cpus)
 {
-	Dprintk("Boot done.\n");
+	pr_debug("Boot done.\n");
 
 	impress_friends();
 	smp_checks();
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index b432d57..9782f42 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -20,10 +20,6 @@
 #include <asm/acpi.h>
 #include <asm/k8.h>
 
-#ifndef Dprintk
-#define Dprintk(x...)
-#endif
-
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
 
diff --git a/arch/x86/pci/early.c b/arch/x86/pci/early.c
index 858dbe3..86631cc 100644
--- a/arch/x86/pci/early.c
+++ b/arch/x86/pci/early.c
@@ -7,15 +7,13 @@
 /* Direct PCI access. This is used for PCI accesses in early boot before
    the PCI subsystem works. */
 
-#define PDprintk(x...)
-
 u32 read_pci_config(u8 bus, u8 slot, u8 func, u8 offset)
 {
 	u32 v;
 	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
 	v = inl(0xcfc);
 	if (v != 0xffffffff)
-		PDprintk("%x reading 4 from %x: %x\n", slot, offset, v);
+		pr_debug("%x reading 4 from %x: %x\n", slot, offset, v);
 	return v;
 }
 
@@ -24,7 +22,7 @@ u8 read_pci_config_byte(u8 bus, u8 slot, u8 func, u8 offset)
 	u8 v;
 	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
 	v = inb(0xcfc + (offset&3));
-	PDprintk("%x reading 1 from %x: %x\n", slot, offset, v);
+	pr_debug("%x reading 1 from %x: %x\n", slot, offset, v);
 	return v;
 }
 
@@ -33,28 +31,28 @@ u16 read_pci_config_16(u8 bus, u8 slot, u8 func, u8 offset)
 	u16 v;
 	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
 	v = inw(0xcfc + (offset&2));
-	PDprintk("%x reading 2 from %x: %x\n", slot, offset, v);
+	pr_debug("%x reading 2 from %x: %x\n", slot, offset, v);
 	return v;
 }
 
 void write_pci_config(u8 bus, u8 slot, u8 func, u8 offset,
 				    u32 val)
 {
-	PDprintk("%x writing to %x: %x\n", slot, offset, val);
+	pr_debug("%x writing to %x: %x\n", slot, offset, val);
 	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
 	outl(val, 0xcfc);
 }
 
 void write_pci_config_byte(u8 bus, u8 slot, u8 func, u8 offset, u8 val)
 {
-	PDprintk("%x writing to %x: %x\n", slot, offset, val);
+	pr_debug("%x writing to %x: %x\n", slot, offset, val);
 	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
 	outb(val, 0xcfc + (offset&3));
 }
 
 void write_pci_config_16(u8 bus, u8 slot, u8 func, u8 offset, u16 val)
 {
-	PDprintk("%x writing to %x: %x\n", slot, offset, val);
+	pr_debug("%x writing to %x: %x\n", slot, offset, val);
 	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
 	outw(val, 0xcfc + (offset&2));
 }
@@ -71,7 +69,7 @@ void early_dump_pci_device(u8 bus, u8 slot, u8 func)
 	int j;
 	u32 val;
 
-	printk("PCI: %02x:%02x:%02x", bus, slot, func);
+	printk(KERN_INFO "PCI: %02x:%02x:%02x", bus, slot, func);
 
 	for (i = 0; i < 256; i += 4) {
 		if (!(i & 0x0f))
diff --git a/include/asm-x86/apic.h b/include/asm-x86/apic.h
index b96460a..133c998 100644
--- a/include/asm-x86/apic.h
+++ b/include/asm-x86/apic.h
@@ -12,8 +12,6 @@
 
 #define ARCH_APICTIMER_STOPS_ON_C3	1
 
-#define Dprintk printk
-
 /*
  * Debugging macros
  */
diff --git a/include/asm-x86/mach-default/smpboot_hooks.h b/include/asm-x86/mach-default/smpboot_hooks.h
index 56d001b..dbab36d 100644
--- a/include/asm-x86/mach-default/smpboot_hooks.h
+++ b/include/asm-x86/mach-default/smpboot_hooks.h
@@ -12,11 +12,11 @@ static inline void smpboot_setup_warm_reset_vector(unsigned long start_eip)
 {
 	CMOS_WRITE(0xa, 0xf);
 	local_flush_tlb();
-	Dprintk("1.\n");
+	pr_debug("1.\n");
 	*((volatile unsigned short *) TRAMPOLINE_HIGH) = start_eip >> 4;
-	Dprintk("2.\n");
+	pr_debug("2.\n");
 	*((volatile unsigned short *) TRAMPOLINE_LOW) = start_eip & 0xf;
-	Dprintk("3.\n");
+	pr_debug("3.\n");
 }
 
 static inline void smpboot_restore_warm_reset_vector(void)
