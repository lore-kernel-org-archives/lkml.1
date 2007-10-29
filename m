Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbXJ2XtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbXJ2XtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbXJ2XtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:49:17 -0400
Received: from www.tglx.de ([62.245.132.106]:37926 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbXJ2XtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:49:14 -0400
Date: Tue, 30 Oct 2007 00:48:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [Git pull] x86 update
Message-ID: <alpine.LFD.0.9999.0710300045010.3186@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

a couple of cleanups and bugfixes along with a compile/runtime
irrelevant doc change.

The iommu.h -> gart.h rename needs to go in before we have the
namespace polution all over the place.

Thanks,

	tglx

Adrian Bunk (4):
      x86: kernel/setup_32.c: unexport machine_id
      x86: mm/discontig_32.c: make code static
      x86: merge EARLY_PRINTK options
      remove the dead X86_REMOTE_DEBUG option

H. Peter Anvin (1):
      x86: additional CPUID strings; fix strings for AMD-ecx

Huang, Ying (1):
      x86 boot: document for 32 bit boot protocol

Joerg Roedel (4):
      x86 gart: rename iommu.h to gart.h
      x86 gart: rename CONFIG_IOMMU to CONFIG_GART_IOMMU
      x86 gart: make some variables and functions static
      x86 gart: rename symbols only used for the GART implementation

 Documentation/i386/boot.txt       |   38 ++++++++++++
 Documentation/i386/zero-page.txt  |  122 ++++++++----------------------------
 arch/x86/Kconfig.debug            |    8 +--
 arch/x86/Kconfig.x86_64           |   10 +--
 arch/x86/configs/x86_64_defconfig |    2 +-
 arch/x86/kernel/Makefile_64       |    2 +-
 arch/x86/kernel/aperture_64.c     |   15 +++--
 arch/x86/kernel/cpu/proc.c        |   10 ++--
 arch/x86/kernel/early-quirks.c    |   10 ++--
 arch/x86/kernel/pci-calgary_64.c  |    2 +-
 arch/x86/kernel/pci-dma_64.c      |   10 ++--
 arch/x86/kernel/pci-gart_64.c     |   18 +++---
 arch/x86/kernel/pci-nommu_64.c    |    2 +-
 arch/x86/kernel/pci-swiotlb_64.c  |    2 +-
 arch/x86/kernel/reboot_64.c       |    2 +-
 arch/x86/kernel/setup_32.c        |    3 -
 arch/x86/kernel/setup_64.c        |   10 ++--
 arch/x86/mm/discontig_32.c        |    4 +-
 drivers/char/agp/Kconfig          |    4 +-
 drivers/char/agp/amd64-agp.c      |    2 +-
 drivers/pci/intel-iommu.c         |    2 +-
 drivers/usb/core/message.c        |    2 +-
 include/asm-x86/gart.h            |   29 +++++++++
 include/asm-x86/iommu.h           |    4 +-
 include/asm-x86/pci_64.h          |    2 +-
 25 files changed, 152 insertions(+), 163 deletions(-)
 create mode 100644 include/asm-x86/gart.h
diff --git a/Documentation/i386/boot.txt b/Documentation/i386/boot.txt
index 2f75e75..fc49b79 100644
--- a/Documentation/i386/boot.txt
+++ b/Documentation/i386/boot.txt
@@ -785,3 +785,41 @@ IMPORTANT: All the hooks are required to preserve %esp, %ebp, %esi and
 	After completing your hook, you should jump to the address
 	that was in this field before your boot loader overwrote it
 	(relocated, if appropriate.)
+
+
+**** 32-bit BOOT PROTOCOL
+
+For machine with some new BIOS other than legacy BIOS, such as EFI,
+LinuxBIOS, etc, and kexec, the 16-bit real mode setup code in kernel
+based on legacy BIOS can not be used, so a 32-bit boot protocol needs
+to be defined.
+
+In 32-bit boot protocol, the first step in loading a Linux kernel
+should be to setup the boot parameters (struct boot_params,
+traditionally known as "zero page"). The memory for struct boot_params
+should be allocated and initialized to all zero. Then the setup header
+from offset 0x01f1 of kernel image on should be loaded into struct
+boot_params and examined. The end of setup header can be calculated as
+follow:
+
+	0x0202 + byte value at offset 0x0201
+
+In addition to read/modify/write the setup header of the struct
+boot_params as that of 16-bit boot protocol, the boot loader should
+also fill the additional fields of the struct boot_params as that
+described in zero-page.txt.
+
+After setupping the struct boot_params, the boot loader can load the
+32/64-bit kernel in the same way as that of 16-bit boot protocol.
+
+In 32-bit boot protocol, the kernel is started by jumping to the
+32-bit kernel entry point, which is the start address of loaded
+32/64-bit kernel.
+
+At entry, the CPU must be in 32-bit protected mode with paging
+disabled; a GDT must be loaded with the descriptors for selectors
+__BOOT_CS(0x10) and __BOOT_DS(0x18); both descriptors must be 4G flat
+segment; __BOOS_CS must have execute/read permission, and __BOOT_DS
+must have read/write permission; CS must be __BOOT_CS and DS, ES, SS
+must be __BOOT_DS; interrupt must be disabled; %esi must hold the base
+address of the struct boot_params; %ebp, %edi and %ebx must be zero.
diff --git a/Documentation/i386/zero-page.txt b/Documentation/i386/zero-page.txt
index 6c0817c..169ad42 100644
--- a/Documentation/i386/zero-page.txt
+++ b/Documentation/i386/zero-page.txt
@@ -1,99 +1,31 @@
----------------------------------------------------------------------------
-!!!!!!!!!!!!!!!WARNING!!!!!!!!
-The zero page is a kernel internal data structure, not a stable ABI.  It might change
-without warning and the kernel has no way to detect old version of it.
-If you're writing some external code like a boot loader you should only use
-the stable versioned real mode boot protocol described in boot.txt. Otherwise the kernel
-might break you at any time.
-!!!!!!!!!!!!!WARNING!!!!!!!!!!!
-----------------------------------------------------------------------------
+The additional fields in struct boot_params as a part of 32-bit boot
+protocol of kernel. These should be filled by bootloader or 16-bit
+real-mode setup code of the kernel. References/settings to it mainly
+are in:
 
-Summary of boot_params layout (kernel point of view)
-     ( collected by Hans Lermen and Martin Mares )
- 
-The contents of boot_params are used to pass parameters from the
-16-bit realmode code of the kernel to the 32-bit part. References/settings
-to it mainly are in:
+  include/asm-x86/bootparam.h
 
-  arch/i386/boot/setup.S
-  arch/i386/boot/video.S
-  arch/i386/kernel/head.S
-  arch/i386/kernel/setup.c
- 
 
-Offset	Type		Description
-------  ----		-----------
-    0	32 bytes	struct screen_info, SCREEN_INFO
-			ATTENTION, overlaps the following !!!
-    2	unsigned short	EXT_MEM_K, extended memory size in Kb (from int 0x15)
- 0x20	unsigned short	CL_MAGIC, commandline magic number (=0xA33F)
- 0x22	unsigned short	CL_OFFSET, commandline offset
-			Address of commandline is calculated:
-			  0x90000 + contents of CL_OFFSET
-			(only taken, when CL_MAGIC = 0xA33F)
- 0x40	20 bytes	struct apm_bios_info, APM_BIOS_INFO
- 0x60	16 bytes	Intel SpeedStep (IST) BIOS support information
- 0x80	16 bytes	hd0-disk-parameter from intvector 0x41
- 0x90	16 bytes	hd1-disk-parameter from intvector 0x46
+Offset	Proto	Name		Meaning
+/Size
 
- 0xa0	16 bytes	System description table truncated to 16 bytes.
-			( struct sys_desc_table_struct )
- 0xb0 - 0x13f		Free. Add more parameters here if you really need them.
- 0x140- 0x1be		EDID_INFO Video mode setup
-
-0x1c4	unsigned long	EFI system table pointer
-0x1c8	unsigned long	EFI memory descriptor size
-0x1cc	unsigned long	EFI memory descriptor version
-0x1d0	unsigned long	EFI memory descriptor map pointer
-0x1d4	unsigned long	EFI memory descriptor map size
-0x1e0	unsigned long	ALT_MEM_K, alternative mem check, in Kb
-0x1e4	unsigned long	Scratch field for the kernel setup code
-0x1e8	char		number of entries in E820MAP (below)
-0x1e9	unsigned char	number of entries in EDDBUF (below)
-0x1ea	unsigned char	number of entries in EDD_MBR_SIG_BUFFER (below)
-0x1f1	char		size of setup.S, number of sectors
-0x1f2	unsigned short	MOUNT_ROOT_RDONLY (if !=0)
-0x1f4	unsigned short	size of compressed kernel-part in the
-			(b)zImage-file (in 16 byte units, rounded up)
-0x1f6	unsigned short	swap_dev (unused AFAIK)
-0x1f8	unsigned short	RAMDISK_FLAGS
-0x1fa	unsigned short	VGA-Mode (old one)
-0x1fc	unsigned short	ORIG_ROOT_DEV (high=Major, low=minor)
-0x1ff	char		AUX_DEVICE_INFO
-
-0x200	short jump to start of setup code aka "reserved" field.
-0x202	4 bytes		Signature for SETUP-header, ="HdrS"
-0x206	unsigned short	Version number of header format
-			Current version is 0x0201...
-0x208	8 bytes		(used by setup.S for communication with boot loaders,
-			 look there)
-0x210	char		LOADER_TYPE, = 0, old one
-			else it is set by the loader:
-			0xTV: T=0 for LILO
-				1 for Loadlin
-				2 for bootsect-loader
-				3 for SYSLINUX
-				4 for ETHERBOOT
-				5 for ELILO
-				7 for GRuB
-				8 for U-BOOT
-				9 for Xen
-				V = version
-0x211	char		loadflags:
-			bit0 = 1: kernel is loaded high (bzImage)
-			bit7 = 1: Heap and pointer (see below) set by boot
-				  loader.
-0x212	unsigned short	(setup.S)
-0x214	unsigned long	KERNEL_START, where the loader started the kernel
-0x218	unsigned long	INITRD_START, address of loaded ramdisk image
-0x21c	unsigned long	INITRD_SIZE, size in bytes of ramdisk image
-0x220	4 bytes		(setup.S)
-0x224	unsigned short	setup.S heap end pointer
-0x226   unsigned short	zero_pad
-0x228   unsigned long	cmd_line_ptr
-0x22c   unsigned long	ramdisk_max
-0x230   16 bytes 	trampoline
-0x290 - 0x2cf		EDD_MBR_SIG_BUFFER (edd.S)
-0x2d0 - 0xd00		E820MAP
-0xd00 - 0xeff		EDDBUF (edd.S) for disk signature read sector
-0xd00 - 0xeeb		EDDBUF (edd.S) for edd data
+000/040	ALL	screen_info	Text mode or frame buffer information
+				(struct screen_info)
+040/014	ALL	apm_bios_info	APM BIOS information (struct apm_bios_info)
+060/010	ALL	ist_info	Intel SpeedStep (IST) BIOS support information
+				(struct ist_info)
+080/010	ALL	hd0_info	hd0 disk parameter, OBSOLETE!!
+090/010	ALL	hd1_info	hd1 disk parameter, OBSOLETE!!
+0A0/010	ALL	sys_desc_table	System description table (struct sys_desc_table)
+140/080	ALL	edid_info	Video mode setup (struct edid_info)
+1C0/020	ALL	efi_info	EFI 32 information (struct efi_info)
+1E0/004	ALL	alk_mem_k	Alternative mem check, in KB
+1E4/004	ALL	scratch		Scratch field for the kernel setup code
+1E8/001	ALL	e820_entries	Number of entries in e820_map (below)
+1E9/001	ALL	eddbuf_entries	Number of entries in eddbuf (below)
+1EA/001	ALL	edd_mbr_sig_buf_entries	Number of entries in edd_mbr_sig_buffer
+				(below)
+290/040	ALL	edd_mbr_sig_buffer EDD MBR signatures
+2D0/A00	ALL	e820_map	E820 memory map table
+				(array of struct e820entry)
+D00/1EC	ALL	eddbuf		EDD data (array of struct edd_info)
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 970b2de..761ca7b 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -6,9 +6,8 @@ config TRACE_IRQFLAGS_SUPPORT
 source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
-	bool "Early printk" if EMBEDDED && DEBUG_KERNEL
+	bool "Early printk" if EMBEDDED && DEBUG_KERNEL && X86_32
 	default y
-	depends on X86_32
 	help
 	  Write kernel log output directly into the VGA buffer or to a serial
 	  port.
@@ -91,7 +90,7 @@ config DOUBLEFAULT
 
 config IOMMU_DEBUG
 	bool "Enable IOMMU debugging"
-	depends on IOMMU && DEBUG_KERNEL
+	depends on GART_IOMMU && DEBUG_KERNEL
 	depends on X86_64
 	help
 	  Force the IOMMU to on even when you have less than 4GB of
@@ -113,7 +112,4 @@ config IOMMU_LEAK
 	  Add a simple leak tracer to the IOMMU code. This is useful when you
 	  are debugging a buggy device driver that leaks IOMMU mappings.
 
-#config X86_REMOTE_DEBUG
-#	bool "kgdb debugging stub"
-
 endmenu
diff --git a/arch/x86/Kconfig.x86_64 b/arch/x86/Kconfig.x86_64
index e2542e5..b45855c 100644
--- a/arch/x86/Kconfig.x86_64
+++ b/arch/x86/Kconfig.x86_64
@@ -97,10 +97,6 @@ config X86_CMPXCHG
 	bool
 	default y
 
-config EARLY_PRINTK
-	bool
-	default y
-
 config GENERIC_ISA_DMA
 	bool
 	default y
@@ -479,8 +475,8 @@ config HPET_EMULATE_RTC
 
 # Mark as embedded because too many people got it wrong.
 # The code disables itself when not needed.
-config IOMMU
-	bool "IOMMU support" if EMBEDDED
+config GART_IOMMU
+	bool "GART IOMMU support" if EMBEDDED
 	default y
 	select SWIOTLB
 	select AGP
@@ -687,7 +683,7 @@ source kernel/Kconfig.hz
 
 config K8_NB
 	def_bool y
-	depends on AGP_AMD64 || IOMMU || (PCI && NUMA)
+	depends on AGP_AMD64 || GART_IOMMU || (PCI && NUMA)
 
 endmenu
 
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index b091c5e..38a83f9 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -170,7 +170,7 @@ CONFIG_HOTPLUG_CPU=y
 CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
 CONFIG_HPET_TIMER=y
 CONFIG_HPET_EMULATE_RTC=y
-CONFIG_IOMMU=y
+CONFIG_GART_IOMMU=y
 # CONFIG_CALGARY_IOMMU is not set
 CONFIG_SWIOTLB=y
 CONFIG_X86_MCE=y
diff --git a/arch/x86/kernel/Makefile_64 b/arch/x86/kernel/Makefile_64
index 466337a..24671c3 100644
--- a/arch/x86/kernel/Makefile_64
+++ b/arch/x86/kernel/Makefile_64
@@ -25,7 +25,7 @@ obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_64.o
 obj-$(CONFIG_PM)		+= suspend_64.o
 obj-$(CONFIG_HIBERNATION)	+= suspend_asm_64.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
-obj-$(CONFIG_IOMMU)		+= pci-gart_64.o aperture_64.o
+obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
 obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
 obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb_64.o
 obj-$(CONFIG_KPROBES)		+= kprobes_64.o
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 8f681ca..5b69927 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -20,14 +20,14 @@
 #include <linux/ioport.h>
 #include <asm/e820.h>
 #include <asm/io.h>
-#include <asm/iommu.h>
+#include <asm/gart.h>
 #include <asm/pci-direct.h>
 #include <asm/dma.h>
 #include <asm/k8.h>
 
-int iommu_aperture;
-int iommu_aperture_disabled __initdata = 0;
-int iommu_aperture_allowed __initdata = 0;
+int gart_iommu_aperture;
+int gart_iommu_aperture_disabled __initdata = 0;
+int gart_iommu_aperture_allowed __initdata = 0;
 
 int fallback_aper_order __initdata = 1; /* 64MB */
 int fallback_aper_force __initdata = 0; 
@@ -204,14 +204,15 @@ static __u32 __init search_agp_bridge(u32 *order, int *valid_agp)
 	return 0;
 }
 
-void __init iommu_hole_init(void) 
+void __init gart_iommu_hole_init(void)
 { 
 	int fix, num; 
 	u32 aper_size, aper_alloc = 0, aper_order = 0, last_aper_order = 0;
 	u64 aper_base, last_aper_base = 0;
 	int valid_agp = 0;
 
-	if (iommu_aperture_disabled || !fix_aperture || !early_pci_allowed())
+	if (gart_iommu_aperture_disabled || !fix_aperture ||
+	    !early_pci_allowed())
 		return;
 
 	printk(KERN_INFO  "Checking aperture...\n");
@@ -222,7 +223,7 @@ void __init iommu_hole_init(void)
 			continue;
 
 		iommu_detected = 1;
-		iommu_aperture = 1; 
+		gart_iommu_aperture = 1;
 
 		aper_order = (read_pci_config(0, num, 3, 0x90) >> 1) & 7; 
 		aper_size = (32 * 1024 * 1024) << aper_order; 
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 2d42b41..066f8c6 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -49,7 +49,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		/* Intel-defined (#2) */
 		"pni", NULL, NULL, "monitor", "ds_cpl", "vmx", "smx", "est",
 		"tm2", "ssse3", "cid", NULL, NULL, "cx16", "xtpr", NULL,
-		NULL, NULL, "dca", NULL, NULL, NULL, NULL, "popcnt",
+		NULL, NULL, "dca", "sse4_1", "sse4_2", NULL, NULL, "popcnt",
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
 		/* VIA/Cyrix/Centaur-defined */
@@ -59,10 +59,10 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
 		/* AMD-defined (#2) */
-		"lahf_lm", "cmp_legacy", "svm", "extapic", "cr8_legacy",
-		"altmovcr8", "abm", "sse4a",
-		"misalignsse", "3dnowprefetch",
-		"osvw", "ibs", NULL, NULL, NULL, NULL,
+		"lahf_lm", "cmp_legacy", "svm", "extapic",
+		"cr8_legacy", "abm", "sse4a", "misalignsse",
+		"3dnowprefetch", "osvw", "ibs", "sse5",
+		"skinit", "wdt", NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 639e632..88bb83e 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -17,19 +17,19 @@
 #include <asm/io_apic.h>
 #include <asm/apic.h>
 
-#ifdef CONFIG_IOMMU
-#include <asm/iommu.h>
+#ifdef CONFIG_GART_IOMMU
+#include <asm/gart.h>
 #endif
 
 static void __init via_bugs(void)
 {
-#ifdef CONFIG_IOMMU
+#ifdef CONFIG_GART_IOMMU
 	if ((end_pfn > MAX_DMA32_PFN ||  force_iommu) &&
-	    !iommu_aperture_allowed) {
+	    !gart_iommu_aperture_allowed) {
 		printk(KERN_INFO
 		       "Looks like a VIA chipset. Disabling IOMMU."
 		       " Override with iommu=allowed\n");
-		iommu_aperture_disabled = 1;
+		gart_iommu_aperture_disabled = 1;
 	}
 #endif
 }
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 1a20fe3..6bf1f71 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -36,7 +36,7 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
-#include <asm/iommu.h>
+#include <asm/gart.h>
 #include <asm/calgary.h>
 #include <asm/tce.h>
 #include <asm/pci-direct.h>
diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index 393e272..aa805b1 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -9,7 +9,7 @@
 #include <linux/module.h>
 #include <linux/dmar.h>
 #include <asm/io.h>
-#include <asm/iommu.h>
+#include <asm/gart.h>
 #include <asm/calgary.h>
 
 int iommu_merge __read_mostly = 1;
@@ -275,7 +275,7 @@ __init int iommu_setup(char *p)
 			swiotlb = 1;
 #endif
 
-#ifdef CONFIG_IOMMU
+#ifdef CONFIG_GART_IOMMU
 		gart_parse_options(p);
 #endif
 
@@ -298,8 +298,8 @@ void __init pci_iommu_alloc(void)
 	 * The order of these functions is important for
 	 * fall-back/fail-over reasons
 	 */
-#ifdef CONFIG_IOMMU
-	iommu_hole_init();
+#ifdef CONFIG_GART_IOMMU
+	gart_iommu_hole_init();
 #endif
 
 #ifdef CONFIG_CALGARY_IOMMU
@@ -321,7 +321,7 @@ static int __init pci_iommu_init(void)
 
 	intel_iommu_init();
 
-#ifdef CONFIG_IOMMU
+#ifdef CONFIG_GART_IOMMU
 	gart_iommu_init();
 #endif
 
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 79b514b..06bcba5 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -30,17 +30,17 @@
 #include <asm/mtrr.h>
 #include <asm/pgtable.h>
 #include <asm/proto.h>
-#include <asm/iommu.h>
+#include <asm/gart.h>
 #include <asm/cacheflush.h>
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
 #include <asm/k8.h>
 
-unsigned long iommu_bus_base;	/* GART remapping area (physical) */
+static unsigned long iommu_bus_base;	/* GART remapping area (physical) */
 static unsigned long iommu_size; 	/* size of remapping area bytes */
 static unsigned long iommu_pages;	/* .. and in pages */
 
-u32 *iommu_gatt_base; 		/* Remapping table */
+static u32 *iommu_gatt_base; 		/* Remapping table */
 
 /* If this is disabled the IOMMU will use an optimized flushing strategy
    of only flushing when an mapping is reused. With it true the GART is flushed 
@@ -135,8 +135,8 @@ static void flush_gart(void)
 /* Debugging aid for drivers that don't free their IOMMU tables */
 static void **iommu_leak_tab; 
 static int leak_trace;
-int iommu_leak_pages = 20; 
-void dump_leak(void)
+static int iommu_leak_pages = 20;
+static void dump_leak(void)
 {
 	int i;
 	static int dump; 
@@ -627,12 +627,12 @@ void __init gart_iommu_init(void)
 		return;
 
 	/* Did we detect a different HW IOMMU? */
-	if (iommu_detected && !iommu_aperture)
+	if (iommu_detected && !gart_iommu_aperture)
 		return;
 
 	if (no_iommu ||
 	    (!force_iommu && end_pfn <= MAX_DMA32_PFN) ||
-	    !iommu_aperture ||
+	    !gart_iommu_aperture ||
 	    (no_agp && init_k8_gatt(&info) < 0)) {
 		if (end_pfn > MAX_DMA32_PFN) {
 			printk(KERN_ERR "WARNING more than 4GB of memory "
@@ -733,9 +733,9 @@ void __init gart_parse_options(char *p)
 		fix_aperture = 0;
 	/* duplicated from pci-dma.c */
 	if (!strncmp(p,"force",5))
-		iommu_aperture_allowed = 1;
+		gart_iommu_aperture_allowed = 1;
 	if (!strncmp(p,"allowed",7))
-		iommu_aperture_allowed = 1;
+		gart_iommu_aperture_allowed = 1;
 	if (!strncmp(p, "memaper", 7)) {
 		fallback_aper_force = 1;
 		p += 7;
diff --git a/arch/x86/kernel/pci-nommu_64.c b/arch/x86/kernel/pci-nommu_64.c
index faf70bd..ab08e18 100644
--- a/arch/x86/kernel/pci-nommu_64.c
+++ b/arch/x86/kernel/pci-nommu_64.c
@@ -7,7 +7,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/scatterlist.h>
 
-#include <asm/iommu.h>
+#include <asm/gart.h>
 #include <asm/processor.h>
 #include <asm/dma.h>
 
diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index b2f405e..102866d 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -5,7 +5,7 @@
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/iommu.h>
+#include <asm/gart.h>
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
 
diff --git a/arch/x86/kernel/reboot_64.c b/arch/x86/kernel/reboot_64.c
index 776eb06..71b13c5 100644
--- a/arch/x86/kernel/reboot_64.c
+++ b/arch/x86/kernel/reboot_64.c
@@ -17,7 +17,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/apic.h>
-#include <asm/iommu.h>
+#include <asm/gart.h>
 
 /*
  * Power off function, if any
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index cc0e914..e1e18c3 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -86,9 +86,6 @@ unsigned long mmu_cr4_features;
 
 /* for MCA, but anyone else can use it if they want */
 unsigned int machine_id;
-#ifdef CONFIG_MCA
-EXPORT_SYMBOL(machine_id);
-#endif
 unsigned int machine_submodel_id;
 unsigned int BIOS_revision;
 unsigned int mca_pentium_flag;
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index e7a9e36..238633d 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -1040,7 +1040,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		/* Intel-defined (#2) */
 		"pni", NULL, NULL, "monitor", "ds_cpl", "vmx", "smx", "est",
 		"tm2", "ssse3", "cid", NULL, NULL, "cx16", "xtpr", NULL,
-		NULL, NULL, "dca", NULL, NULL, NULL, NULL, "popcnt",
+		NULL, NULL, "dca", "sse4_1", "sse4_2", NULL, NULL, "popcnt",
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
 		/* VIA/Cyrix/Centaur-defined */
@@ -1050,10 +1050,10 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
 		/* AMD-defined (#2) */
-		"lahf_lm", "cmp_legacy", "svm", "extapic", "cr8_legacy",
-		"altmovcr8", "abm", "sse4a",
-		"misalignsse", "3dnowprefetch",
-		"osvw", "ibs", NULL, NULL, NULL, NULL,
+		"lahf_lm", "cmp_legacy", "svm", "extapic",
+		"cr8_legacy", "abm", "sse4a", "misalignsse",
+		"3dnowprefetch", "osvw", "ibs", "sse5",
+		"skinit", "wdt", NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
diff --git a/arch/x86/mm/discontig_32.c b/arch/x86/mm/discontig_32.c
index fe608a4..13a474d 100644
--- a/arch/x86/mm/discontig_32.c
+++ b/arch/x86/mm/discontig_32.c
@@ -40,7 +40,7 @@
 
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
-bootmem_data_t node0_bdata;
+static bootmem_data_t node0_bdata;
 
 /*
  * numa interface - we expect the numa architecture specific code to have
@@ -404,7 +404,7 @@ void __init set_highmem_pages_init(int bad_ppro)
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-int paddr_to_nid(u64 addr)
+static int paddr_to_nid(u64 addr)
 {
 	int nid;
 	unsigned long pfn = PFN_DOWN(addr);
diff --git a/drivers/char/agp/Kconfig b/drivers/char/agp/Kconfig
index f22c253..ccb1fa8 100644
--- a/drivers/char/agp/Kconfig
+++ b/drivers/char/agp/Kconfig
@@ -56,9 +56,9 @@ config AGP_AMD
 	  X on AMD Irongate, 761, and 762 chipsets.
 
 config AGP_AMD64
-	tristate "AMD Opteron/Athlon64 on-CPU GART support" if !IOMMU
+	tristate "AMD Opteron/Athlon64 on-CPU GART support" if !GART_IOMMU
 	depends on AGP && X86
-	default y if IOMMU
+	default y if GART_IOMMU
 	help
 	  This option gives you AGP support for the GLX component of
 	  X using the on-CPU northbridge of the AMD Athlon64/Opteron CPUs.
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index d95662e..d8200ac 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -787,7 +787,7 @@ static void __exit agp_amd64_cleanup(void)
 
 /* On AMD64 the PCI driver needs to initialize this driver early
    for the IOMMU, so it has to be called via a backdoor. */
-#ifndef CONFIG_IOMMU
+#ifndef CONFIG_GART_IOMMU
 module_init(agp_amd64_init);
 module_exit(agp_amd64_cleanup);
 #endif
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 9b35259..8af1d9a 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -34,7 +34,7 @@
 #include "intel-iommu.h"
 #include <asm/proto.h> /* force_iommu in this header in x86-64*/
 #include <asm/cacheflush.h>
-#include <asm/iommu.h>
+#include <asm/gart.h>
 #include "pci.h"
 
 #define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index eb4ac47..316a746 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -434,7 +434,7 @@ int usb_sg_init (
 		if (dma) {
 			io->urbs [i]->transfer_dma = sg_dma_address (sg + i);
 			len = sg_dma_len (sg + i);
-#if defined(CONFIG_HIGHMEM) || defined(CONFIG_IOMMU)
+#if defined(CONFIG_HIGHMEM) || defined(CONFIG_GART_IOMMU)
 			io->urbs[i]->transfer_buffer = NULL;
 #else
 			io->urbs[i]->transfer_buffer = sg_virt(&sg[i]);
diff --git a/include/asm-x86/gart.h b/include/asm-x86/gart.h
new file mode 100644
index 0000000..f704c50
--- /dev/null
+++ b/include/asm-x86/gart.h
@@ -0,0 +1,29 @@
+#ifndef _ASM_X8664_IOMMU_H
+#define _ASM_X8664_IOMMU_H 1
+
+extern void pci_iommu_shutdown(void);
+extern void no_iommu_init(void);
+extern int force_iommu, no_iommu;
+extern int iommu_detected;
+#ifdef CONFIG_GART_IOMMU
+extern void gart_iommu_init(void);
+extern void gart_iommu_shutdown(void);
+extern void __init gart_parse_options(char *);
+extern void gart_iommu_hole_init(void);
+extern int fallback_aper_order;
+extern int fallback_aper_force;
+extern int gart_iommu_aperture;
+extern int gart_iommu_aperture_allowed;
+extern int gart_iommu_aperture_disabled;
+extern int fix_aperture;
+#else
+#define gart_iommu_aperture 0
+#define gart_iommu_aperture_allowed 0
+
+static inline void gart_iommu_shutdown(void)
+{
+}
+
+#endif
+
+#endif
diff --git a/include/asm-x86/iommu.h b/include/asm-x86/iommu.h
index 5af471f..07862fd 100644
--- a/include/asm-x86/iommu.h
+++ b/include/asm-x86/iommu.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_X8664_IOMMU_H
-#define _ASM_X8664_IOMMU_H 1
+#ifndef _ASM_X8664_GART_H
+#define _ASM_X8664_GART_H 1
 
 extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
diff --git a/include/asm-x86/pci_64.h b/include/asm-x86/pci_64.h
index 9baa46d..ef54226 100644
--- a/include/asm-x86/pci_64.h
+++ b/include/asm-x86/pci_64.h
@@ -37,7 +37,7 @@ extern int iommu_setup(char *opt);
  */
 #define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
 
-#if defined(CONFIG_IOMMU) || defined(CONFIG_CALGARY_IOMMU)
+#if defined(CONFIG_GART_IOMMU) || defined(CONFIG_CALGARY_IOMMU)
 
 #define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	\
 	dma_addr_t ADDR_NAME;
