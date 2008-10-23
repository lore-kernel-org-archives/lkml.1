Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbYJWTdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbYJWTdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 15:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYJWTdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 15:33:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41446 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbYJWTdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 15:33:39 -0400
Date: Thu, 23 Oct 2008 21:33:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20081023193328.GA5640@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
MAINTAINERS                        # 8d433c4: x86: MAINTAINERS change for AMD m

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      MCE: Don't run 32bit machine checks with interrupts on

Andreas Herrmann (2):
      x86: SB600: skip IRQ0 override if it is not routed to INT2 of IOAPIC
      x86: call dmi-quirks for HP Laptops after early-quirks are executed

Cyrill Gorcunov (1):
      x86: do_boot_cpu - check if we have ESR register

Daniele Calore (1):
      x86: memtest fix use of reserve_early()

Gustavo F. Padovan (1):
      x86: remove redundant KERN_DEBUG on pr_debug

Jeremy Fitzhardinge (1):
      x86/tlb_uv: remove strange mc146818rtc include

Lai Jiangshan (1):
      x86/proc: fix /proc/cpuinfo cpu offline bug

Marcin Slusarz (5):
      x86: fix section mismatch warning - apic_flat
      x86: fix section mismatch warning - apic_physflat
      x86: fix section mismatch warning - apic_x2apic_uv_x
      x86: fix section mismatch warning - apic_x2apic_cluster
      x86: fix section mismatch warning - apic_x2apic_phys

Neil Horman (1):
      x86, kexec: fix hang on i386 when panic occurs while console_sem is held

Peter Oruba (1):
      x86: MAINTAINERS change for AMD microcode patch loader

Roland McGrath (1):
      x86 syscall.h: fix argument order

roel kluin (1):
      x86: make variables static


 MAINTAINERS                         |    5 +-
 arch/x86/boot/video-bios.c          |    4 +-
 arch/x86/boot/video-vesa.c          |    4 +-
 arch/x86/kernel/acpi/boot.c         |   10 +++-
 arch/x86/kernel/cpu/proc.c          |    6 +-
 arch/x86/kernel/dumpstack_32.c      |    2 +-
 arch/x86/kernel/early-quirks.c      |   55 +++++++++++++++++-
 arch/x86/kernel/entry_32.S          |    2 +-
 arch/x86/kernel/genapic_flat_64.c   |    4 +-
 arch/x86/kernel/genx2apic_cluster.c |    2 +-
 arch/x86/kernel/genx2apic_phys.c    |    2 +-
 arch/x86/kernel/genx2apic_uv_x.c    |    2 +-
 arch/x86/kernel/setup_percpu.c      |    2 +-
 arch/x86/kernel/smpboot.c           |    8 ++-
 arch/x86/kernel/tlb_uv.c            |    2 +-
 arch/x86/kernel/traps.c             |    8 ---
 arch/x86/kernel/xsave.c             |    2 +-
 arch/x86/mm/memtest.c               |    7 +-
 include/asm-x86/syscall.h           |  106 ++++++++++++++++++-----------------
 19 files changed, 144 insertions(+), 89 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5c3f79c..b0244fb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -378,8 +378,9 @@ T:	git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git
 S:	Supported
 
 AMD MICROCODE UPDATE SUPPORT
-P:      Peter Oruba
-M:      peter.oruba@amd.com
+P:      Andreas Herrmann
+M:      andeas.herrmann3@amd.com
+L:      amd64-microcode@amd64.org
 S:      Supported
 
 AMS (Apple Motion Sensor) DRIVER
diff --git a/arch/x86/boot/video-bios.c b/arch/x86/boot/video-bios.c
index 49f26aa..3fa979c 100644
--- a/arch/x86/boot/video-bios.c
+++ b/arch/x86/boot/video-bios.c
@@ -17,7 +17,7 @@
 #include "boot.h"
 #include "video.h"
 
-__videocard video_bios;
+static __videocard video_bios;
 
 /* Set a conventional BIOS mode */
 static int set_bios_mode(u8 mode);
@@ -119,7 +119,7 @@ static int bios_probe(void)
 	return nmodes;
 }
 
-__videocard video_bios =
+static __videocard video_bios =
 {
 	.card_name	= "BIOS",
 	.probe		= bios_probe,
diff --git a/arch/x86/boot/video-vesa.c b/arch/x86/boot/video-vesa.c
index 99b3079..7511584 100644
--- a/arch/x86/boot/video-vesa.c
+++ b/arch/x86/boot/video-vesa.c
@@ -20,7 +20,7 @@
 static struct vesa_general_info vginfo;
 static struct vesa_mode_info vminfo;
 
-__videocard video_vesa;
+static __videocard video_vesa;
 
 #ifndef _WAKEUP
 static void vesa_store_mode_params_graphics(void);
@@ -293,7 +293,7 @@ void vesa_store_edid(void)
 
 #endif /* not _WAKEUP */
 
-__videocard video_vesa =
+static __videocard video_vesa =
 {
 	.card_name	= "VESA",
 	.probe		= vesa_probe,
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 0d1c26a..dc3eac3 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1136,7 +1136,7 @@ int mp_register_gsi(u32 gsi, int triggering, int polarity)
 		return gsi;
 	}
 	if (test_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed)) {
-		pr_debug(KERN_DEBUG "Pin %d-%d already programmed\n",
+		pr_debug("Pin %d-%d already programmed\n",
 			 mp_ioapic_routing[ioapic].apic_id, ioapic_pin);
 #ifdef CONFIG_X86_32
 		return (gsi < IRQ_COMPRESSION_START ? gsi : gsi_to_irq[gsi]);
@@ -1598,6 +1598,11 @@ static struct dmi_system_id __initdata acpi_dmi_table[] = {
 		     DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 360"),
 		     },
 	 },
+	{}
+};
+
+/* second table for DMI checks that should run after early-quirks */
+static struct dmi_system_id __initdata acpi_dmi_table_late[] = {
 	/*
 	 * HP laptops which use a DSDT reporting as HP/SB400/10000,
 	 * which includes some code which overrides all temperature
@@ -1726,6 +1731,9 @@ int __init early_acpi_boot_init(void)
 
 int __init acpi_boot_init(void)
 {
+	/* those are executed after early-quirks are executed */
+	dmi_check_system(acpi_dmi_table_late);
+
 	/*
 	 * If acpi_disabled, bail out
 	 * One exception: acpi=ht continues far enough to enumerate LAPICs
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index a26c480..01b1244 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -160,14 +160,16 @@ static void *c_start(struct seq_file *m, loff_t *pos)
 {
 	if (*pos == 0)	/* just in case, cpu 0 is not the first */
 		*pos = first_cpu(cpu_online_map);
-	if ((*pos) < nr_cpu_ids && cpu_online(*pos))
+	else
+		*pos = next_cpu_nr(*pos - 1, cpu_online_map);
+	if ((*pos) < nr_cpu_ids)
 		return &cpu_data(*pos);
 	return NULL;
 }
 
 static void *c_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	*pos = next_cpu(*pos, cpu_online_map);
+	(*pos)++;
 	return c_start(m, pos);
 }
 
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 1a78180..b361475 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -405,7 +405,6 @@ die_nmi(char *str, struct pt_regs *regs, int do_panic)
 		panic("Non maskable interrupt");
 	console_silent();
 	spin_unlock(&nmi_print_lock);
-	bust_spinlocks(0);
 
 	/*
 	 * If we are in kernel we are probably nested up pretty bad
@@ -416,6 +415,7 @@ die_nmi(char *str, struct pt_regs *regs, int do_panic)
 		crash_kexec(regs);
 	}
 
+	bust_spinlocks(0);
 	do_exit(SIGSEGV);
 }
 
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 733c4f8..3ce029f 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -95,7 +95,8 @@ static void __init nvidia_bugs(int num, int slot, int func)
 
 }
 
-static u32 ati_ixp4x0_rev(int num, int slot, int func)
+#if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
+static u32 __init ati_ixp4x0_rev(int num, int slot, int func)
 {
 	u32 d;
 	u8  b;
@@ -115,7 +116,6 @@ static u32 ati_ixp4x0_rev(int num, int slot, int func)
 
 static void __init ati_bugs(int num, int slot, int func)
 {
-#if defined(CONFIG_ACPI) && defined (CONFIG_X86_IO_APIC)
 	u32 d;
 	u8  b;
 
@@ -138,9 +138,56 @@ static void __init ati_bugs(int num, int slot, int func)
 		printk(KERN_INFO "If you got timer trouble "
 		       "try acpi_use_timer_override\n");
 	}
-#endif
 }
 
+static u32 __init ati_sbx00_rev(int num, int slot, int func)
+{
+	u32 old, d;
+
+	d = read_pci_config(num, slot, func, 0x70);
+	old = d;
+	d &= ~(1<<8);
+	write_pci_config(num, slot, func, 0x70, d);
+	d = read_pci_config(num, slot, func, 0x8);
+	d &= 0xff;
+	write_pci_config(num, slot, func, 0x70, old);
+
+	return d;
+}
+
+static void __init ati_bugs_contd(int num, int slot, int func)
+{
+	u32 d, rev;
+
+	if (acpi_use_timer_override)
+		return;
+
+	rev = ati_sbx00_rev(num, slot, func);
+	if (rev > 0x13)
+		return;
+
+	/* check for IRQ0 interrupt swap */
+	d = read_pci_config(num, slot, func, 0x64);
+	if (!(d & (1<<14)))
+		acpi_skip_timer_override = 1;
+
+	if (acpi_skip_timer_override) {
+		printk(KERN_INFO "SB600 revision 0x%x\n", rev);
+		printk(KERN_INFO "Ignoring ACPI timer override.\n");
+		printk(KERN_INFO "If you got timer trouble "
+		       "try acpi_use_timer_override\n");
+	}
+}
+#else
+static void __init ati_bugs(int num, int slot, int func)
+{
+}
+
+static void __init ati_bugs_contd(int num, int slot, int func)
+{
+}
+#endif
+
 #ifdef CONFIG_DMAR
 static void __init intel_g33_dmar(int num, int slot, int func)
 {
@@ -176,6 +223,8 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, fix_hypertransport_config },
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS,
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
+	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
+	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
 #ifdef CONFIG_DMAR
 	{ PCI_VENDOR_ID_INTEL, 0x29c0,
 	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, intel_g33_dmar },
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c356423..dd65143 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1024,7 +1024,7 @@ ENTRY(machine_check)
 	RING0_INT_FRAME
 	pushl $0
 	CFI_ADJUST_CFA_OFFSET 4
-	pushl $do_machine_check
+	pushl machine_check_vector
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index 2ec2de8..c026279 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -25,7 +25,7 @@
 #include <acpi/acpi_bus.h>
 #endif
 
-static int __init flat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int flat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return 1;
 }
@@ -170,7 +170,7 @@ struct genapic apic_flat =  {
  * We cannot use logical delivery in this case because the mask
  * overflows, so use physical mode.
  */
-static int __init physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 #ifdef CONFIG_ACPI
 	/*
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index e4bf2cc..f6a2c8e 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -12,7 +12,7 @@
 
 DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
 
-static int __init x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (cpu_has_x2apic)
 		return 1;
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index 8f1343d..d042211 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -19,7 +19,7 @@ static int set_x2apic_phys_mode(char *arg)
 }
 early_param("x2apic_phys", set_x2apic_phys_mode);
 
-static int __init x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (cpu_has_x2apic && x2apic_phys)
 		return 1;
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index bfd5328..680a065 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -30,7 +30,7 @@ DEFINE_PER_CPU(int, x2apic_extra_bits);
 
 static enum uv_system_type uv_system_type;
 
-static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (!strcmp(oem_id, "SGI")) {
 		if (!strcmp(oem_table_id, "UVL"))
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 410c88f..ae0c0d3 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -218,7 +218,7 @@ static void __init setup_node_to_cpumask_map(void)
 	/* allocate the map */
 	map = alloc_bootmem_low(nr_node_ids * sizeof(cpumask_t));
 
-	pr_debug(KERN_DEBUG "Node to cpumask map at %p for %d nodes\n",
+	pr_debug("Node to cpumask map at %p for %d nodes\n",
 		 map, nr_node_ids);
 
 	/* node_to_cpumask() will now work */
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7ece815..7b10933 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -893,9 +893,11 @@ do_rest:
 		smpboot_setup_warm_reset_vector(start_ip);
 		/*
 		 * Be paranoid about clearing APIC errors.
-	 	*/
-		apic_write(APIC_ESR, 0);
-		apic_read(APIC_ESR);
+		*/
+		if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
+			apic_write(APIC_ESR, 0);
+			apic_read(APIC_ESR);
+		}
 	}
 
 	/*
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 8b8c0d6..04431f3 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -6,7 +6,7 @@
  *	This code is released under the GNU General Public License version 2 or
  *	later.
  */
-#include <linux/mc146818rtc.h>
+#include <linux/seq_file.h>
 #include <linux/proc_fs.h>
 #include <linux/kernel.h>
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index e062974..04d242a 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -931,14 +931,6 @@ do_device_not_available(struct pt_regs *regs, long error)
 }
 
 #ifdef CONFIG_X86_32
-#ifdef CONFIG_X86_MCE
-dotraplinkage void __kprobes do_machine_check(struct pt_regs *regs, long error)
-{
-	conditional_sti(regs);
-	machine_check_vector(regs, error);
-}
-#endif
-
 dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
 {
 	siginfo_t info;
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 9abac8a..b13acb7 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -248,7 +248,7 @@ clear:
  * This will be saved when ever the FP and extended state context is
  * saved on the user stack during the signal handler delivery to the user.
  */
-void prepare_fx_sw_frame(void)
+static void prepare_fx_sw_frame(void)
 {
 	int size_extended = (xstate_size - sizeof(struct i387_fxsave_struct)) +
 			     FP_XSTATE_MAGIC2_SIZE;
diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 672e17f..9cab18b 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -61,9 +61,9 @@ static void __init memtest(unsigned long start_phys, unsigned long size,
 				last_bad += incr;
 			} else {
 				if (start_bad) {
-					printk(KERN_CONT "\n  %010lx bad mem addr %010lx - %010lx reserved",
+					printk(KERN_CONT "\n  %016lx bad mem addr %010lx - %010lx reserved",
 						val, start_bad, last_bad + incr);
-					reserve_early(start_bad, last_bad - start_bad, "BAD RAM");
+					reserve_early(start_bad, last_bad + incr, "BAD RAM");
 				}
 				start_bad = last_bad = start_phys_aligned;
 			}
@@ -72,9 +72,8 @@ static void __init memtest(unsigned long start_phys, unsigned long size,
 	if (start_bad) {
 		printk(KERN_CONT "\n  %016lx bad mem addr %010lx - %010lx reserved",
 			val, start_bad, last_bad + incr);
-		reserve_early(start_bad, last_bad - start_bad, "BAD RAM");
+		reserve_early(start_bad, last_bad + incr, "BAD RAM");
 	}
-
 }
 
 /* default is disabled */
diff --git a/include/asm-x86/syscall.h b/include/asm-x86/syscall.h
index 04c47dc..ec2a95e 100644
--- a/include/asm-x86/syscall.h
+++ b/include/asm-x86/syscall.h
@@ -93,26 +93,26 @@ static inline void syscall_get_arguments(struct task_struct *task,
 {
 # ifdef CONFIG_IA32_EMULATION
 	if (task_thread_info(task)->status & TS_COMPAT)
-		switch (i + n) {
-		case 6:
+		switch (i) {
+		case 0:
 			if (!n--) break;
-			*args++ = regs->bp;
-		case 5:
+			*args++ = regs->bx;
+		case 1:
 			if (!n--) break;
-			*args++ = regs->di;
-		case 4:
+			*args++ = regs->cx;
+		case 2:
 			if (!n--) break;
-			*args++ = regs->si;
+			*args++ = regs->dx;
 		case 3:
 			if (!n--) break;
-			*args++ = regs->dx;
-		case 2:
+			*args++ = regs->si;
+		case 4:
 			if (!n--) break;
-			*args++ = regs->cx;
-		case 1:
+			*args++ = regs->di;
+		case 5:
 			if (!n--) break;
-			*args++ = regs->bx;
-		case 0:
+			*args++ = regs->bp;
+		case 6:
 			if (!n--) break;
 		default:
 			BUG();
@@ -120,26 +120,26 @@ static inline void syscall_get_arguments(struct task_struct *task,
 		}
 	else
 # endif
-		switch (i + n) {
-		case 6:
+		switch (i) {
+		case 0:
 			if (!n--) break;
-			*args++ = regs->r9;
-		case 5:
+			*args++ = regs->di;
+		case 1:
 			if (!n--) break;
-			*args++ = regs->r8;
-		case 4:
+			*args++ = regs->si;
+		case 2:
 			if (!n--) break;
-			*args++ = regs->r10;
+			*args++ = regs->dx;
 		case 3:
 			if (!n--) break;
-			*args++ = regs->dx;
-		case 2:
+			*args++ = regs->r10;
+		case 4:
 			if (!n--) break;
-			*args++ = regs->si;
-		case 1:
+			*args++ = regs->r8;
+		case 5:
 			if (!n--) break;
-			*args++ = regs->di;
-		case 0:
+			*args++ = regs->r9;
+		case 6:
 			if (!n--) break;
 		default:
 			BUG();
@@ -154,55 +154,57 @@ static inline void syscall_set_arguments(struct task_struct *task,
 {
 # ifdef CONFIG_IA32_EMULATION
 	if (task_thread_info(task)->status & TS_COMPAT)
-		switch (i + n) {
-		case 6:
+		switch (i) {
+		case 0:
 			if (!n--) break;
-			regs->bp = *args++;
-		case 5:
+			regs->bx = *args++;
+		case 1:
 			if (!n--) break;
-			regs->di = *args++;
-		case 4:
+			regs->cx = *args++;
+		case 2:
 			if (!n--) break;
-			regs->si = *args++;
+			regs->dx = *args++;
 		case 3:
 			if (!n--) break;
-			regs->dx = *args++;
-		case 2:
+			regs->si = *args++;
+		case 4:
 			if (!n--) break;
-			regs->cx = *args++;
-		case 1:
+			regs->di = *args++;
+		case 5:
 			if (!n--) break;
-			regs->bx = *args++;
-		case 0:
+			regs->bp = *args++;
+		case 6:
 			if (!n--) break;
 		default:
 			BUG();
+			break;
 		}
 	else
 # endif
-		switch (i + n) {
-		case 6:
+		switch (i) {
+		case 0:
 			if (!n--) break;
-			regs->r9 = *args++;
-		case 5:
+			regs->di = *args++;
+		case 1:
 			if (!n--) break;
-			regs->r8 = *args++;
-		case 4:
+			regs->si = *args++;
+		case 2:
 			if (!n--) break;
-			regs->r10 = *args++;
+			regs->dx = *args++;
 		case 3:
 			if (!n--) break;
-			regs->dx = *args++;
-		case 2:
+			regs->r10 = *args++;
+		case 4:
 			if (!n--) break;
-			regs->si = *args++;
-		case 1:
+			regs->r8 = *args++;
+		case 5:
 			if (!n--) break;
-			regs->di = *args++;
-		case 0:
+			regs->r9 = *args++;
+		case 6:
 			if (!n--) break;
 		default:
 			BUG();
+			break;
 		}
 }
 
