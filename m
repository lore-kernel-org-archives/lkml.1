Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbYGZTPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbYGZTPw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 15:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbYGZTPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 15:15:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36235 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbYGZTPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 15:15:44 -0400
Date: Sat, 26 Jul 2008 21:15:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] x86 fixes
Message-ID: <20080726191524.GA26907@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Linus,

Please pull the latest x86 fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
include/linux/crash_dump.h         # 36ac261: crashdump: fix undefined referenc

Thanks,

	Ingo

------------------>
Chris McDermott (1):
      x86: fix IBM Summit based systems' phys_cpu_present_map on 32-bit kernels

Ingo Molnar (3):
      crashdump: fix undefined reference to `elfcorehdr_addr'
      x86, RDC321x: add to mach-default
      x86, RDC321x: remove gpio.h complications

Joerg Roedel (1):
      x86, AMD IOMMU: include amd_iommu_last_bdf in device initialization

Wang Chen (1):
      flag parameters: fix compile error of sys_epoll_create1


 arch/x86/Kconfig                        |   26 +++++++++++---------------
 arch/x86/Makefile                       |    5 -----
 arch/x86/kernel/amd_iommu.c             |    4 ++--
 arch/x86/kernel/amd_iommu_init.c        |    4 ++--
 include/asm-x86/gpio.h                  |    6 ------
 include/asm-x86/mach-summit/mach_apic.h |    2 +-
 include/linux/crash_dump.h              |    6 ++++++
 7 files changed, 22 insertions(+), 31 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e3cba0b..39ae679 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -23,7 +23,7 @@ config X86
 	select HAVE_OPROFILE
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
-	select ARCH_WANT_OPTIONAL_GPIOLIB if !X86_RDC321X
+	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_KRETPROBES
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE
@@ -332,20 +332,6 @@ config X86_BIGSMP
 
 endif
 
-config X86_RDC321X
-	bool "RDC R-321x SoC"
-	depends on X86_32
-	select M486
-	select X86_REBOOTFIXUPS
-	select GENERIC_GPIO
-	select LEDS_CLASS
-	select LEDS_GPIO
-	select NEW_LEDS
-	help
-	  This option is needed for RDC R-321x system-on-chip, also known
-	  as R-8610-(G).
-	  If you don't have one of these chips, you should say N here.
-
 config X86_VSMP
 	bool "Support for ScaleMP vSMP"
 	select PARAVIRT
@@ -369,6 +355,16 @@ config X86_VISWS
 	  A kernel compiled for the Visual Workstation will run on general
 	  PCs as well. See <file:Documentation/sgi-visws.txt> for details.
 
+config X86_RDC321X
+	bool "RDC R-321x SoC"
+	depends on X86_32
+	select M486
+	select X86_REBOOTFIXUPS
+	help
+	  This option is needed for RDC R-321x system-on-chip, also known
+	  as R-8610-(G).
+	  If you don't have one of these chips, you should say N here.
+
 config SCHED_NO_NO_OMIT_FRAME_POINTER
 	def_bool y
 	prompt "Single-depth WCHAN output"
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 919ce21..f5631da 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -118,11 +118,6 @@ mflags-$(CONFIG_X86_GENERICARCH):= -Iinclude/asm-x86/mach-generic
 fcore-$(CONFIG_X86_GENERICARCH)	+= arch/x86/mach-generic/
 mcore-$(CONFIG_X86_GENERICARCH)	:= arch/x86/mach-default/
 
-# RDC R-321x subarch support
-mflags-$(CONFIG_X86_RDC321X)	:= -Iinclude/asm-x86/mach-rdc321x
-mcore-$(CONFIG_X86_RDC321X)	:= arch/x86/mach-default/
-core-$(CONFIG_X86_RDC321X)	+= arch/x86/mach-rdc321x/
-
 # default subarch .h files
 mflags-y += -Iinclude/asm-x86/mach-default
 
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index c25210e..7469740 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -667,7 +667,7 @@ static int get_device_resources(struct device *dev,
 	_bdf = calc_devid(pcidev->bus->number, pcidev->devfn);
 
 	/* device not translated by any IOMMU in the system? */
-	if (_bdf >= amd_iommu_last_bdf) {
+	if (_bdf > amd_iommu_last_bdf) {
 		*iommu = NULL;
 		*domain = NULL;
 		*bdf = 0xffff;
@@ -1085,7 +1085,7 @@ void prealloc_protection_domains(void)
 
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
 		devid = (dev->bus->number << 8) | dev->devfn;
-		if (devid >= amd_iommu_last_bdf)
+		if (devid > amd_iommu_last_bdf)
 			continue;
 		devid = amd_iommu_alias_table[devid];
 		if (domain_for_device(devid))
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index c9d8ff2..d9a9da5 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -732,7 +732,7 @@ static int __init init_exclusion_range(struct ivmd_header *m)
 		set_device_exclusion_range(m->devid, m);
 		break;
 	case ACPI_IVMD_TYPE_ALL:
-		for (i = 0; i < amd_iommu_last_bdf; ++i)
+		for (i = 0; i <= amd_iommu_last_bdf; ++i)
 			set_device_exclusion_range(i, m);
 		break;
 	case ACPI_IVMD_TYPE_RANGE:
@@ -934,7 +934,7 @@ int __init amd_iommu_init(void)
 	/*
 	 * let all alias entries point to itself
 	 */
-	for (i = 0; i < amd_iommu_last_bdf; ++i)
+	for (i = 0; i <= amd_iommu_last_bdf; ++i)
 		amd_iommu_alias_table[i] = i;
 
 	/*
diff --git a/include/asm-x86/gpio.h b/include/asm-x86/gpio.h
index 116e914..c4c91b3 100644
--- a/include/asm-x86/gpio.h
+++ b/include/asm-x86/gpio.h
@@ -16,10 +16,6 @@
 #ifndef _ASM_I386_GPIO_H
 #define _ASM_I386_GPIO_H
 
-#ifdef CONFIG_X86_RDC321X
-#include <gpio.h>
-#else /* CONFIG_X86_RDC321X */
-
 #include <asm-generic/gpio.h>
 
 #ifdef CONFIG_GPIOLIB
@@ -57,6 +53,4 @@ static inline int irq_to_gpio(unsigned int irq)
 
 #endif /* CONFIG_GPIOLIB */
 
-#endif /* CONFIG_X86_RDC321X */
-
 #endif /* _ASM_I386_GPIO_H */
diff --git a/include/asm-x86/mach-summit/mach_apic.h b/include/asm-x86/mach-summit/mach_apic.h
index 75d2c95..c47e2ab 100644
--- a/include/asm-x86/mach-summit/mach_apic.h
+++ b/include/asm-x86/mach-summit/mach_apic.h
@@ -122,7 +122,7 @@ static inline physid_mask_t ioapic_phys_id_map(physid_mask_t phys_id_map)
 
 static inline physid_mask_t apicid_to_cpu_present(int apicid)
 {
-	return physid_mask_of_physid(0);
+	return physid_mask_of_physid(apicid);
 }
 
 static inline void setup_portio_remap(void)
diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 6cd39a9..025e4f5 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -8,7 +8,13 @@
 #include <linux/proc_fs.h>
 
 #define ELFCORE_ADDR_MAX	(-1ULL)
+
+#ifdef CONFIG_PROC_VMCORE
 extern unsigned long long elfcorehdr_addr;
+#else
+static const unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
+#endif
+
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
 extern const struct file_operations proc_vmcore_operations;
