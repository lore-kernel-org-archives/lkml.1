Return-Path: <linux-kernel-owner+w=401wt.eu-S1762897AbXKIVgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762897AbXKIVgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759377AbXKIVaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:30:03 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757764AbXKIVaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:30:00 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 24/24] make vsmp a paravirt client
Date: Fri,  9 Nov 2007 16:43:05 -0200
Message-Id: <11946339142999-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11946339082711-git-send-email-gcosta@redhat.com>
References: <11946337851964-git-send-email-gcosta@redhat.com> <11946337933104-git-send-email-gcosta@redhat.com> <11946337991750-git-send-email-gcosta@redhat.com> <11946338053158-git-send-email-gcosta@redhat.com> <11946338103068-git-send-email-gcosta@redhat.com> <1194633815833-git-send-email-gcosta@redhat.com> <11946338212915-git-send-email-gcosta@redhat.com> <11946338263902-git-send-email-gcosta@redhat.com> <1194633831882-git-send-email-gcosta@redhat.com> <11946338361369-git-send-email-gcosta@redhat.com> <11946338413283-git-send-email-gcosta@redhat.com> <11946338473652-git-send-email-gcosta@redhat.com> <1194633852469-git-send-email-gcosta@redhat.com> <1194633857930-git-send-email-gcosta@redhat.com> <11946338621966-git-send-email-gcosta@redhat.com> <11946338683305-git-send-email-gcosta@redhat.com> <1194633873306-git-send-email-gcosta@redhat.com> <1194633878886-git-send-email-gcosta@redhat.com> <11946338832681-git-send-email-gcosta@redhat.com> <1194633888761-git-send-email-gco!
 sta@redhat.com> <11946338932611-git-send-email-gcosta@redhat.com> <1194633898545-git-send-email-gcosta@redhat.com> <11946339033567-git-send-email-gcosta@redhat.com> <11946339082711-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes vsmp a paravirt client. It now uses the whole
infrastructure provided by pvops. When we detect we're running
a vsmp box, we change the irq-related paravirt operations (and so,
it have to happen quite early), and the patching function

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/Kconfig.x86_64     |    3 +-
 arch/x86/kernel/Makefile_64 |    3 +-
 arch/x86/kernel/setup_64.c  |    2 +
 arch/x86/kernel/vsmp_64.c   |   82 +++++++++++++++++++++++++++++++++++++-----
 include/asm-x86/setup.h     |    6 ++-
 5 files changed, 80 insertions(+), 16 deletions(-)

diff --git a/arch/x86/Kconfig.x86_64 b/arch/x86/Kconfig.x86_64
index 568ba7a..fe4ef61 100644
--- a/arch/x86/Kconfig.x86_64
+++ b/arch/x86/Kconfig.x86_64
@@ -148,15 +148,14 @@ config X86_PC
 	bool "PC-compatible"
 	help
 	  Choose this option if your computer is a standard PC or compatible.
-
 config X86_VSMP
 	bool "Support for ScaleMP vSMP"
 	depends on PCI
+	select PARAVIRT
 	 help
 	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
 	  supposed to run on these EM64T-based machines.  Only choose this option
 	  if you have one of these machines.
-
 endchoice
 
 choice
diff --git a/arch/x86/kernel/Makefile_64 b/arch/x86/kernel/Makefile_64
index 0714528..34e5c7d 100644
--- a/arch/x86/kernel/Makefile_64
+++ b/arch/x86/kernel/Makefile_64
@@ -8,7 +8,7 @@ obj-y	:= process_64.o signal_64.o entry_64.o traps_64.o irq_64.o \
 		x8664_ksyms_64.o i387_64.o syscall_64.o vsyscall_64.o \
 		setup64.o bootflag.o e820_64.o reboot_64.o quirks.o i8237.o \
 		pci-dma_64.o pci-nommu_64.o alternative.o hpet.o tsc_64.o bugs_64.o \
-		i8253.o rtc.o
+		i8253.o rtc.o vsmp_64.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
@@ -29,7 +29,6 @@ obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
 obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb_64.o
 obj-$(CONFIG_KPROBES)		+= kprobes_64.o
 obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64.o
-obj-$(CONFIG_X86_VSMP)		+= vsmp_64.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_AUDIT)		+= audit_64.o
 
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 1c9f237..8cc5915 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -338,6 +338,8 @@ void __init setup_arch(char **cmdline_p)
 
 	init_memory_mapping(0, (end_pfn_map << PAGE_SHIFT));
 
+	vsmp_init();
+
 	dmi_scan_machine();
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index d971210..24b0541 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -8,31 +8,95 @@
  *
  * Ravikiran Thirumalai <kiran@scalemp.com>,
  * Shai Fultheim <shai@scalemp.com>
+ * Paravirt ops integration: Glauber de Oliveira Costa <gcosta@redhat.com>
  */
-
 #include <linux/init.h>
 #include <linux/pci_ids.h>
 #include <linux/pci_regs.h>
 #include <asm/pci-direct.h>
 #include <asm/io.h>
+#include <asm/paravirt.h>
+
+/*
+ * Interrupt control for the VSMP architecture:
+ */
+
+static inline unsigned long vsmp_save_fl(void)
+{
+	unsigned long flags = native_save_fl();
+
+	if (!(flags & X86_EFLAGS_AC))
+		return X86_EFLAGS_IF;
+	return 0;
+}
+
+static inline void vsmp_restore_fl(unsigned long flags)
+{
+	if (flags & X86_EFLAGS_IF)
+		flags &= ~X86_EFLAGS_AC;
+	if (!(flags & X86_EFLAGS_IF))
+		flags &= X86_EFLAGS_AC;
+	native_restore_fl(flags);
+}
+
+static inline void vsmp_irq_disable(void)
+{
+	unsigned long flags = native_save_fl();
 
-static int __init vsmp_init(void)
+	vsmp_restore_fl(flags & ~X86_EFLAGS_IF);
+}
+
+static inline void vsmp_irq_enable(void)
+{
+	unsigned long flags = native_save_fl();
+
+	vsmp_restore_fl(flags | X86_EFLAGS_IF);
+}
+
+#ifdef CONFIG_PARAVIRT
+static unsigned __init vsmp_patch(u8 type, u16 clobbers, void *ibuf,
+				  unsigned long addr, unsigned len)
+{
+	switch (type) {
+	case PARAVIRT_PATCH(pv_irq_ops.irq_enable):
+	case PARAVIRT_PATCH(pv_irq_ops.irq_disable):
+	case PARAVIRT_PATCH(pv_irq_ops.save_fl):
+	case PARAVIRT_PATCH(pv_irq_ops.restore_fl):
+		return paravirt_patch_default(type, clobbers, ibuf, addr, len);
+	default:
+		return native_patch(type, clobbers, ibuf, addr, len);
+	}
+
+}
+#endif
+
+void __init vsmp_init(void)
 {
 	void *address;
-	unsigned int cap, ctl;
+	unsigned int cap, ctl, cfg;
 
 	if (!early_pci_allowed())
-		return 0;
+		return;
 
 	/* Check if we are running on a ScaleMP vSMP box */
 	if ((read_pci_config_16(0, 0x1f, 0, PCI_VENDOR_ID) !=
 	     PCI_VENDOR_ID_SCALEMP) ||
 	    (read_pci_config_16(0, 0x1f, 0, PCI_DEVICE_ID) !=
 	     PCI_DEVICE_ID_SCALEMP_VSMP_CTL))
-		return 0;
+		return;
+
+#ifdef CONFIG_PARAVIRT
+	/* If we are, use the distinguished irq functions */
+	pv_irq_ops.irq_disable = vsmp_irq_disable;
+	pv_irq_ops.irq_enable  = vsmp_irq_enable;
+	pv_irq_ops.save_fl  = vsmp_save_fl;
+	pv_irq_ops.restore_fl  = vsmp_restore_fl;
+	pv_init_ops.patch = vsmp_patch;
+#endif
 
 	/* set vSMP magic bits to indicate vSMP capable kernel */
-	address = ioremap(read_pci_config(0, 0x1f, 0, PCI_BASE_ADDRESS_0), 8);
+	cfg = read_pci_config(0, 0x1f, 0, PCI_BASE_ADDRESS_0);
+	address = early_ioremap(cfg, 8);
 	cap = readl(address);
 	ctl = readl(address + 4);
 	printk(KERN_INFO "vSMP CTL: capabilities:0x%08x  control:0x%08x\n",
@@ -45,8 +109,6 @@ static int __init vsmp_init(void)
 		printk(KERN_INFO "vSMP CTL: control set to:0x%08x\n", ctl);
 	}
 
-	iounmap(address);
-	return 0;
+	early_iounmap(address, 8);
+	return;
 }
-
-core_initcall(vsmp_init);
diff --git a/include/asm-x86/setup.h b/include/asm-x86/setup.h
index 071e054..8f532fa 100644
--- a/include/asm-x86/setup.h
+++ b/include/asm-x86/setup.h
@@ -4,6 +4,10 @@
 #define COMMAND_LINE_SIZE 2048
 
 #ifndef __ASSEMBLY__
+
+/* For EM64T-based VSMP machines */
+void vsmp_init(void);
+
 char *machine_specific_memory_setup(void);
 #ifndef CONFIG_PARAVIRT
 #define paravirt_post_allocator_init()	do {} while (0)
@@ -58,8 +62,6 @@ void __init add_memory_region(unsigned long long start,
 
 extern unsigned long init_pg_tables_end;
 
-
-
 #endif /* __i386__ */
 #endif /* _SETUP */
 #endif /* __ASSEMBLY__ */
-- 
1.4.4.2

