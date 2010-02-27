Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968592Ab0B0Qjl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:39:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51226 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968550Ab0B0Qjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:39:39 -0500
Date: Sat, 27 Feb 2010 17:39:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/pci changes for v2.6.34
Message-ID: <20100227163915.GA12701@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-pci-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-pci-for-linus

Jesse, the PCI bits were fine to you, right?

out-of-topic modifications in x86-pci-for-linus:
------------------------------------------------
drivers/gpu/vga/Kconfig            # 36028f3: vgaarb: Add user selectability of
drivers/gpu/vga/vgaarb.c           # 36028f3: vgaarb: Add user selectability of
                                   # 773a38d: vgaarb: Fix VGA arbiter to accept
drivers/pci/pci.c                  # 95a8b6e: pci: Update pci_set_vga_state() t
include/linux/pci.h                # 95a8b6e: pci: Update pci_set_vga_state() t

 Thanks,

	Ingo

------------------>
Mike Travis (4):
      pci: Update pci_set_vga_state() to call arch functions
      x86, uv: Update UV arch to target Legacy VGA I/O correctly.
      vgaarb: Fix VGA arbiter to accept PCI domains other than 0
      vgaarb: Add user selectability of the number of GPUS in a system

Russ Anderson (1):
      x86: Enable NMI on all cpus on UV


 arch/x86/include/asm/uv/bios.h     |    4 +-
 arch/x86/include/asm/uv/uv.h       |    1 +
 arch/x86/include/asm/x86_init.h    |    2 +
 arch/x86/kernel/apic/x2apic_uv_x.c |   74 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/bios_uv.c          |   19 +++++++++
 arch/x86/kernel/smpboot.c          |    1 +
 arch/x86/kernel/x86_init.c         |    3 +
 drivers/gpu/vga/Kconfig            |    8 ++++
 drivers/gpu/vga/vgaarb.c           |   27 ++++++++++---
 drivers/pci/pci.c                  |   25 ++++++++++++-
 include/linux/pci.h                |    5 ++
 11 files changed, 161 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/uv/bios.h b/arch/x86/include/asm/uv/bios.h
index 2751f30..1634275 100644
--- a/arch/x86/include/asm/uv/bios.h
+++ b/arch/x86/include/asm/uv/bios.h
@@ -36,7 +36,8 @@ enum uv_bios_cmd {
 	UV_BIOS_WATCHLIST_ALLOC,
 	UV_BIOS_WATCHLIST_FREE,
 	UV_BIOS_MEMPROTECT,
-	UV_BIOS_GET_PARTITION_ADDR
+	UV_BIOS_GET_PARTITION_ADDR,
+	UV_BIOS_SET_LEGACY_VGA_TARGET
 };
 
 /*
@@ -96,6 +97,7 @@ extern int uv_bios_mq_watchlist_alloc(unsigned long, unsigned int,
 extern int uv_bios_mq_watchlist_free(int, int);
 extern s64 uv_bios_change_memprotect(u64, u64, enum uv_memprotect);
 extern s64 uv_bios_reserved_page_pa(u64, u64 *, u64 *, u64 *);
+extern int uv_bios_set_legacy_vga_target(bool decode, int domain, int bus);
 
 extern void uv_bios_init(void);
 
diff --git a/arch/x86/include/asm/uv/uv.h b/arch/x86/include/asm/uv/uv.h
index c0a01b5..3bb9491 100644
--- a/arch/x86/include/asm/uv/uv.h
+++ b/arch/x86/include/asm/uv/uv.h
@@ -11,6 +11,7 @@ struct mm_struct;
 extern enum uv_system_type get_uv_system_type(void);
 extern int is_uv_system(void);
 extern void uv_cpu_init(void);
+extern void uv_nmi_init(void);
 extern void uv_system_init(void);
 extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 						 struct mm_struct *mm,
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index ea0e8ea..60cc352 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -126,6 +126,7 @@ struct x86_cpuinit_ops {
  * @get_wallclock:		get time from HW clock like RTC etc.
  * @set_wallclock:		set time back to HW clock
  * @is_untracked_pat_range	exclude from PAT logic
+ * @nmi_init			enable NMI on cpus
  */
 struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
@@ -133,6 +134,7 @@ struct x86_platform_ops {
 	int (*set_wallclock)(unsigned long nowtime);
 	void (*iommu_shutdown)(void);
 	bool (*is_untracked_pat_range)(u64 start, u64 end);
+	void (*nmi_init)(void);
 };
 
 extern struct x86_init_ops x86_init;
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 21db3cb..4b8dbb2 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -20,6 +20,8 @@
 #include <linux/cpu.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/pci.h>
+#include <linux/kdebug.h>
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
@@ -34,10 +36,13 @@
 
 DEFINE_PER_CPU(int, x2apic_extra_bits);
 
+#define PR_DEVEL(fmt, args...)	pr_devel("%s: " fmt, __func__, args)
+
 static enum uv_system_type uv_system_type;
 static u64 gru_start_paddr, gru_end_paddr;
 int uv_min_hub_revision_id;
 EXPORT_SYMBOL_GPL(uv_min_hub_revision_id);
+static DEFINE_SPINLOCK(uv_nmi_lock);
 
 static inline bool is_GRU_range(u64 start, u64 end)
 {
@@ -71,6 +76,7 @@ static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	if (!strcmp(oem_id, "SGI")) {
 		nodeid = early_get_nodeid();
 		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
+		x86_platform.nmi_init = uv_nmi_init;
 		if (!strcmp(oem_table_id, "UVL"))
 			uv_system_type = UV_LEGACY_APIC;
 		else if (!strcmp(oem_table_id, "UVX"))
@@ -553,6 +559,30 @@ late_initcall(uv_init_heartbeat);
 
 #endif /* !CONFIG_HOTPLUG_CPU */
 
+/* Direct Legacy VGA I/O traffic to designated IOH */
+int uv_set_vga_state(struct pci_dev *pdev, bool decode,
+		      unsigned int command_bits, bool change_bridge)
+{
+	int domain, bus, rc;
+
+	PR_DEVEL("devfn %x decode %d cmd %x chg_brdg %d\n",
+			pdev->devfn, decode, command_bits, change_bridge);
+
+	if (!change_bridge)
+		return 0;
+
+	if ((command_bits & PCI_COMMAND_IO) == 0)
+		return 0;
+
+	domain = pci_domain_nr(pdev->bus);
+	bus = pdev->bus->number;
+
+	rc = uv_bios_set_legacy_vga_target(decode, domain, bus);
+	PR_DEVEL("vga decode %d %x:%x, rc: %d\n", decode, domain, bus, rc);
+
+	return rc;
+}
+
 /*
  * Called on each cpu to initialize the per_cpu UV data area.
  * FIXME: hotplug not supported yet
@@ -569,6 +599,46 @@ void __cpuinit uv_cpu_init(void)
 		set_x2apic_extra_bits(uv_hub_info->pnode);
 }
 
+/*
+ * When NMI is received, print a stack trace.
+ */
+int uv_handle_nmi(struct notifier_block *self, unsigned long reason, void *data)
+{
+	if (reason != DIE_NMI_IPI)
+		return NOTIFY_OK;
+	/*
+	 * Use a lock so only one cpu prints at a time
+	 * to prevent intermixed output.
+	 */
+	spin_lock(&uv_nmi_lock);
+	pr_info("NMI stack dump cpu %u:\n", smp_processor_id());
+	dump_stack();
+	spin_unlock(&uv_nmi_lock);
+
+	return NOTIFY_STOP;
+}
+
+static struct notifier_block uv_dump_stack_nmi_nb = {
+	.notifier_call	= uv_handle_nmi
+};
+
+void uv_register_nmi_notifier(void)
+{
+	if (register_die_notifier(&uv_dump_stack_nmi_nb))
+		printk(KERN_WARNING "UV NMI handler failed to register\n");
+}
+
+void uv_nmi_init(void)
+{
+	unsigned int value;
+
+	/*
+	 * Unmask NMI on all cpus
+	 */
+	value = apic_read(APIC_LVT1) | APIC_DM_NMI;
+	value &= ~APIC_LVT_MASKED;
+	apic_write(APIC_LVT1, value);
+}
 
 void __init uv_system_init(void)
 {
@@ -690,5 +760,9 @@ void __init uv_system_init(void)
 
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
+	uv_register_nmi_notifier();
 	proc_mkdir("sgi_uv", NULL);
+
+	/* register Legacy VGA I/O redirection handler */
+	pci_register_set_vga_state(uv_set_vga_state);
 }
diff --git a/arch/x86/kernel/bios_uv.c b/arch/x86/kernel/bios_uv.c
index b0206a2..575127a 100644
--- a/arch/x86/kernel/bios_uv.c
+++ b/arch/x86/kernel/bios_uv.c
@@ -154,6 +154,25 @@ s64 uv_bios_freq_base(u64 clock_type, u64 *ticks_per_second)
 }
 EXPORT_SYMBOL_GPL(uv_bios_freq_base);
 
+/*
+ * uv_bios_set_legacy_vga_target - Set Legacy VGA I/O Target
+ * @decode: true to enable target, false to disable target
+ * @domain: PCI domain number
+ * @bus: PCI bus number
+ *
+ * Returns:
+ *    0: Success
+ *    -EINVAL: Invalid domain or bus number
+ *    -ENOSYS: Capability not available
+ *    -EBUSY: Legacy VGA I/O cannot be retargeted at this time
+ */
+int uv_bios_set_legacy_vga_target(bool decode, int domain, int bus)
+{
+	return uv_bios_call(UV_BIOS_SET_LEGACY_VGA_TARGET,
+				(u64)decode, (u64)domain, (u64)bus, 0, 0);
+}
+EXPORT_SYMBOL_GPL(uv_bios_set_legacy_vga_target);
+
 
 #ifdef CONFIG_EFI
 void uv_bios_init(void)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 678d0b8..838a118 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -320,6 +320,7 @@ notrace static void __cpuinit start_secondary(void *unused)
 	unlock_vector_lock();
 	ipi_call_unlock();
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
+	x86_platform.nmi_init();
 
 	/* enable local interrupts */
 	local_irq_enable();
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index ccd179d..ee5746c 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -76,10 +76,13 @@ struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
 	.setup_percpu_clockev		= setup_secondary_APIC_clock,
 };
 
+static void default_nmi_init(void) { };
+
 struct x86_platform_ops x86_platform = {
 	.calibrate_tsc			= native_calibrate_tsc,
 	.get_wallclock			= mach_get_cmos_time,
 	.set_wallclock			= mach_set_rtc_mmss,
 	.iommu_shutdown			= iommu_shutdown_noop,
 	.is_untracked_pat_range		= is_ISA_range,
+	.nmi_init			= default_nmi_init
 };
diff --git a/drivers/gpu/vga/Kconfig b/drivers/gpu/vga/Kconfig
index 790e675..0920492 100644
--- a/drivers/gpu/vga/Kconfig
+++ b/drivers/gpu/vga/Kconfig
@@ -8,3 +8,11 @@ config VGA_ARB
 	  are accessed at same time they need some kind of coordination. Please
 	  see Documentation/vgaarbiter.txt for more details. Select this to
 	  enable VGA arbiter.
+
+config VGA_ARB_MAX_GPUS
+	int "Maximum number of GPUs"
+	default 16
+	depends on VGA_ARB
+	help
+	  Reserves space in the kernel to maintain resource locking for
+	  multiple GPUS.  The overhead for each GPU is very small.
diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 1ac0c93..325a533 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -688,7 +688,7 @@ EXPORT_SYMBOL(vga_client_register);
  * the arbiter.
  */
 
-#define MAX_USER_CARDS         16
+#define MAX_USER_CARDS         CONFIG_VGA_ARB_MAX_GPUS
 #define PCI_INVALID_CARD       ((struct pci_dev *)-1UL)
 
 /*
@@ -954,6 +954,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 		}
 
 	} else if (strncmp(curr_pos, "target ", 7) == 0) {
+		struct pci_bus *pbus;
 		unsigned int domain, bus, devfn;
 		struct vga_device *vgadev;
 
@@ -969,18 +970,31 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 				ret_val = -EPROTO;
 				goto done;
 			}
-
-			pdev = pci_get_bus_and_slot(bus, devfn);
+			pr_devel("vgaarb: %s ==> %x:%x:%x.%x\n", curr_pos,
+				domain, bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
+
+			pbus = pci_find_bus(domain, bus);
+			pr_devel("vgaarb: pbus %p\n", pbus);
+			if (pbus == NULL) {
+				pr_err("vgaarb: invalid PCI domain and/or bus address %x:%x\n",
+					domain, bus);
+				ret_val = -ENODEV;
+				goto done;
+			}
+			pdev = pci_get_slot(pbus, devfn);
+			pr_devel("vgaarb: pdev %p\n", pdev);
 			if (!pdev) {
-				pr_info("vgaarb: invalid PCI address!\n");
+				pr_err("vgaarb: invalid PCI address %x:%x\n",
+					bus, devfn);
 				ret_val = -ENODEV;
 				goto done;
 			}
 		}
 
 		vgadev = vgadev_find(pdev);
+		pr_devel("vgaarb: vgadev %p\n", vgadev);
 		if (vgadev == NULL) {
-			pr_info("vgaarb: this pci device is not a vga device\n");
+			pr_err("vgaarb: this pci device is not a vga device\n");
 			pci_dev_put(pdev);
 			ret_val = -ENODEV;
 			goto done;
@@ -998,7 +1012,8 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 			}
 		}
 		if (i == MAX_USER_CARDS) {
-			pr_err("vgaarb: maximum user cards number reached!\n");
+			pr_err("vgaarb: maximum user cards (%d) number reached!\n",
+				MAX_USER_CARDS);
 			pci_dev_put(pdev);
 			/* XXX: which value to return? */
 			ret_val =  -ENOMEM;
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 315fea4..ac2a576 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2615,6 +2615,23 @@ int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type)
 	return 0;
 }
 
+/* Some architectures require additional programming to enable VGA */
+static arch_set_vga_state_t arch_set_vga_state;
+
+void __init pci_register_set_vga_state(arch_set_vga_state_t func)
+{
+	arch_set_vga_state = func;	/* NULL disables */
+}
+
+static int pci_set_vga_state_arch(struct pci_dev *dev, bool decode,
+		      unsigned int command_bits, bool change_bridge)
+{
+	if (arch_set_vga_state)
+		return arch_set_vga_state(dev, decode, command_bits,
+						change_bridge);
+	return 0;
+}
+
 /**
  * pci_set_vga_state - set VGA decode state on device and parents if requested
  * @dev: the PCI device
@@ -2628,9 +2645,15 @@ int pci_set_vga_state(struct pci_dev *dev, bool decode,
 	struct pci_bus *bus;
 	struct pci_dev *bridge;
 	u16 cmd;
+	int rc;
 
 	WARN_ON(command_bits & ~(PCI_COMMAND_IO|PCI_COMMAND_MEMORY));
 
+	/* ARCH specific VGA enables */
+	rc = pci_set_vga_state_arch(dev, decode, command_bits, change_bridge);
+	if (rc)
+		return rc;
+
 	pci_read_config_word(dev, PCI_COMMAND, &cmd);
 	if (decode == true)
 		cmd |= command_bits;
@@ -2845,6 +2868,7 @@ EXPORT_SYMBOL(pcim_pin_device);
 EXPORT_SYMBOL(pci_disable_device);
 EXPORT_SYMBOL(pci_find_capability);
 EXPORT_SYMBOL(pci_bus_find_capability);
+EXPORT_SYMBOL(pci_register_set_vga_state);
 EXPORT_SYMBOL(pci_release_regions);
 EXPORT_SYMBOL(pci_request_regions);
 EXPORT_SYMBOL(pci_request_regions_exclusive);
@@ -2877,4 +2901,3 @@ EXPORT_SYMBOL(pci_target_state);
 EXPORT_SYMBOL(pci_prepare_to_sleep);
 EXPORT_SYMBOL(pci_back_from_sleep);
 EXPORT_SYMBOL_GPL(pci_set_pcie_reset_state);
-
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 174e539..5da166e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -955,6 +955,11 @@ static inline int pci_proc_domain(struct pci_bus *bus)
 }
 #endif /* CONFIG_PCI_DOMAINS */
 
+/* some architectures require additional setup to direct VGA traffic */
+typedef int (*arch_set_vga_state_t)(struct pci_dev *pdev, bool decode,
+		      unsigned int command_bits, bool change_bridge);
+extern void pci_register_set_vga_state(arch_set_vga_state_t func);
+
 #else /* CONFIG_PCI is not enabled */
 
 /*
