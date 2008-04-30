Return-Path: <linux-kernel-owner+w=401wt.eu-S1765813AbYD3VZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765813AbYD3VZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760202AbYD3VZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:25:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51123 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759681AbYD3VZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:25:08 -0400
Date: Wed, 30 Apr 2008 23:24:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20080430212449.GA31888@elte.hu>
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


Linus, please pull the latest x86 miscellany fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-fixes3.git for-linus

this is a fresh tree but it has been built and booted about 10 times 
already, and the commits themselves were tested more over the day 
against a slightly older -git.

One out of tree commit: consensus was for the drivers/char/toshiba.c 
change to go via x86.git.

	Ingo

------------------>
Adrian Bunk (2):
      x86: remove Xgt_desc_struct
      x86: unexport kmap_atomic_to_page

Alan Cox (1):
      toshiba: use ioremap_cached

Andi Kleen (1):
      fix: x86: support for new UV apic

Andres Salomon (1):
      x86: ioremap ram check fix

Dmitri Vorobiev (2):
      x86: add proper header for reboot_force
      x86: iommu_sac_force can become static

Hugh Dickins (1):
      x86: fix HT cpu booting on 32-bit

Ingo Molnar (9):
      hpet: fix
      x86, voyager: fix ioremap_nocache()
      x86 VISWS: build fix
      revert: "x86: ioremap(), extend check to all RAM pages"
      x86: Kconfig fix
      x86: CONFIG_X86_ELAN fix
      x86: optimize inlining off
      x86: 8K stacks by default
      x86: numaq fix

Jeremy Fitzhardinge (1):
      x86: don't bother printing compat vdso address

Sam Ravnborg (1):
      x86: use defconfigs from x86/configs/*

Suresh Siddha (1):
      x86 PAT: fix performance drop for glx, use UC minus for ioremap(), ioremap_nocache() and pci_mmap_page_range()

Vegard Nossum (1):
      x86: fix early-BUG message

 arch/x86/Kconfig                         |   16 ++++++++++++++--
 arch/x86/Kconfig.cpu                     |   10 +++++-----
 arch/x86/Kconfig.debug                   |    7 +++----
 arch/x86/kernel/Makefile                 |    1 -
 arch/x86/kernel/genapic_64.c             |    2 +-
 arch/x86/kernel/head_32.S                |   19 ++++++++++---------
 arch/x86/kernel/hpet.c                   |    5 +++--
 arch/x86/kernel/pci-dma.c                |    2 +-
 arch/x86/kernel/reboot.c                 |    1 +
 arch/x86/mach-voyager/voyager_cat.c      |    2 +-
 arch/x86/mm/highmem_32.c                 |    1 -
 arch/x86/mm/ioremap.c                    |   23 ++++++++++++++++++-----
 arch/x86/mm/pageattr.c                   |   10 ++++++++--
 arch/x86/pci/Makefile_32                 |    4 ++--
 arch/x86/pci/i386.c                      |   12 +++++++++---
 arch/x86/vdso/vdso32-setup.c             |    2 --
 drivers/char/toshiba.c                   |    2 +-
 include/asm-x86/mach-default/mach_apic.h |    7 +------
 include/asm-x86/processor.h              |    3 ---
 include/asm-x86/proto.h                  |    4 ++++
 20 files changed, 82 insertions(+), 51 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f70e3e3..c3f8809 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -25,6 +25,18 @@ config X86
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
 
+config DEFCONFIG_LIST
+	string
+	depends on X86_32
+	option defconfig_list
+	default "arch/x86/configs/i386_defconfig"
+
+config DEFCONFIG_LIST
+	string
+	depends on X86_64
+	option defconfig_list
+	default "arch/x86/configs/x86_64_defconfig"
+
 
 config GENERIC_LOCKBREAK
 	def_bool n
@@ -180,7 +192,7 @@ config X86_HT
 
 config X86_BIOS_REBOOT
 	bool
-	depends on X86_32 && !(X86_VISWS || X86_VOYAGER)
+	depends on !X86_VISWS && !X86_VOYAGER
 	default y
 
 config X86_TRAMPOLINE
@@ -1161,7 +1173,7 @@ source kernel/Kconfig.hz
 
 config KEXEC
 	bool "kexec system call"
-	depends on X86_64 || X86_BIOS_REBOOT
+	depends on X86_BIOS_REBOOT
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 7ef18b0..2ad6301 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -278,11 +278,6 @@ config GENERIC_CPU
 
 endchoice
 
-config X86_CPU
-	def_bool y
-	select GENERIC_FIND_FIRST_BIT
-	select GENERIC_FIND_NEXT_BIT
-
 config X86_GENERIC
 	bool "Generic x86 support"
 	depends on X86_32
@@ -297,6 +292,11 @@ config X86_GENERIC
 
 endif
 
+config X86_CPU
+	def_bool y
+	select GENERIC_FIND_FIRST_BIT
+	select GENERIC_FIND_NEXT_BIT
+
 #
 # Define implied options from the CPU selection here
 config X86_L1_CACHE_BYTES
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 5b1979a..5fc8d0b 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -118,7 +118,6 @@ config DEBUG_NX_TEST
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
 	depends on X86_32
-	default y
 	help
 	  If you say Y here the kernel will use a 4Kb stacksize for the
 	  kernel stack attached to each process/thread. This facilitates
@@ -256,11 +255,8 @@ config CPA_DEBUG
 	help
 	  Do change_page_attr() self-tests every 30 seconds.
 
-endmenu
-
 config OPTIMIZE_INLINING
 	bool "Allow gcc to uninline functions marked 'inline'"
-	default y
 	help
 	  This option determines if the kernel forces gcc to inline the functions
 	  developers have marked 'inline'. Doing so takes away freedom from gcc to
@@ -270,3 +266,6 @@ config OPTIMIZE_INLINING
 	  this algorithm is so good that allowing gcc4 to make the decision can
 	  become the default in the future, until then this option is there to
 	  test gcc for this.
+
+endmenu
+
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 30d54ed..bbdacb3 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -40,7 +40,6 @@ obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
 obj-y				+= acpi/
 obj-$(CONFIG_X86_BIOS_REBOOT)	+= reboot.o
-obj-$(CONFIG_X86_64)		+= reboot.o
 obj-$(CONFIG_MCA)		+= mca_32.o
 obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
diff --git a/arch/x86/kernel/genapic_64.c b/arch/x86/kernel/genapic_64.c
index 021624c..cbaaf69 100644
--- a/arch/x86/kernel/genapic_64.c
+++ b/arch/x86/kernel/genapic_64.c
@@ -83,7 +83,7 @@ unsigned int read_apic_id(void)
 {
 	unsigned int id;
 
-	WARN_ON(preemptible());
+	WARN_ON(preemptible() && num_online_cpus() > 1);
 	id = apic_read(APIC_ID);
 	if (uv_system_type >= UV_X2APIC)
 		id  |= __get_cpu_var(x2apic_extra_bits);
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 90f038a..b2cc737 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -656,15 +656,16 @@ int_msg:
 	.asciz "Unknown interrupt or fault at EIP %p %p %p\n"
 
 fault_msg:
-	.asciz								\
-/* fault info: */	"BUG: Int %d: CR2 %p\n"				\
-/* pusha regs: */	"     EDI %p  ESI %p  EBP %p  ESP %p\n"		\
-			"     EBX %p  EDX %p  ECX %p  EAX %p\n"		\
-/* fault frame: */	"     err %p  EIP %p   CS %p  flg %p\n"		\
-									\
-			"Stack: %p %p %p %p %p %p %p %p\n"		\
-			"       %p %p %p %p %p %p %p %p\n"		\
-			"       %p %p %p %p %p %p %p %p\n"
+/* fault info: */
+	.ascii "BUG: Int %d: CR2 %p\n"
+/* pusha regs: */
+	.ascii "     EDI %p  ESI %p  EBP %p  ESP %p\n"
+	.ascii "     EBX %p  EDX %p  ECX %p  EAX %p\n"
+/* fault frame: */
+	.ascii "     err %p  EIP %p   CS %p  flg %p\n"
+	.ascii "Stack: %p %p %p %p %p %p %p %p\n"
+	.ascii "       %p %p %p %p %p %p %p %p\n"
+	.asciz "       %p %p %p %p %p %p %p %p\n"
 
 #include "../../x86/xen/xen-head.S"
 
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 9007f9e..9b5cfcd 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -137,9 +137,10 @@ static void hpet_reserve_platform_timers(unsigned long id)
 	hd.hd_irq[0] = HPET_LEGACY_8254;
 	hd.hd_irq[1] = HPET_LEGACY_RTC;
 
-	for (i = 2; i < nrtimers; timer++, i++)
-		hd.hd_irq[i] = (timer->hpet_config & Tn_INT_ROUTE_CNF_MASK) >>
+	for (i = 2; i < nrtimers; timer++, i++) {
+		hd.hd_irq[i] = (readl(&timer->hpet_config) & Tn_INT_ROUTE_CNF_MASK) >>
 			Tn_INT_ROUTE_CNF_SHIFT;
+	}
 
 	hpet_alloc(&hd);
 
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 388b113..0c37f16 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -14,7 +14,7 @@ EXPORT_SYMBOL(forbid_dac);
 const struct dma_mapping_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
-int iommu_sac_force __read_mostly = 0;
+static int iommu_sac_force __read_mostly;
 
 #ifdef CONFIG_IOMMU_DEBUG
 int panic_on_overflow __read_mostly = 1;
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index a4a8383..07c6d42 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -9,6 +9,7 @@
 #include <asm/desc.h>
 #include <asm/hpet.h>
 #include <asm/pgtable.h>
+#include <asm/proto.h>
 #include <asm/reboot_fixups.h>
 #include <asm/reboot.h>
 
diff --git a/arch/x86/mach-voyager/voyager_cat.c b/arch/x86/mach-voyager/voyager_cat.c
index ecab9ff..2ad598c 100644
--- a/arch/x86/mach-voyager/voyager_cat.c
+++ b/arch/x86/mach-voyager/voyager_cat.c
@@ -877,7 +877,7 @@ void __init voyager_cat_init(void)
 			request_resource(&iomem_resource, res);
 		}
 
-		qic_addr = (unsigned long)ioremap(qic_addr, 0x400);
+		qic_addr = (unsigned long)ioremap_cache(qic_addr, 0x400);
 
 		for (j = 0; j < 4; j++) {
 			__u8 cpu;
diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 9cf33d3..165c871 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -155,4 +155,3 @@ EXPORT_SYMBOL(kmap);
 EXPORT_SYMBOL(kunmap);
 EXPORT_SYMBOL(kmap_atomic);
 EXPORT_SYMBOL(kunmap_atomic);
-EXPORT_SYMBOL(kmap_atomic_to_page);
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 804de18..71bb315 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -149,7 +149,8 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
 	for (pfn = phys_addr >> PAGE_SHIFT;
-				(pfn << PAGE_SHIFT) < last_addr; pfn++) {
+				(pfn << PAGE_SHIFT) < (last_addr & PAGE_MASK);
+				pfn++) {
 
 		int is_ram = page_is_ram(pfn);
 
@@ -176,11 +177,11 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		/*
 		 * Do not fallback to certain memory types with certain
 		 * requested type:
-		 * - request is uncached, return cannot be write-back
-		 * - request is uncached, return cannot be write-combine
+		 * - request is uc-, return cannot be write-back
+		 * - request is uc-, return cannot be write-combine
 		 * - request is write-combine, return cannot be write-back
 		 */
-		if ((prot_val == _PAGE_CACHE_UC &&
+		if ((prot_val == _PAGE_CACHE_UC_MINUS &&
 		     (new_prot_val == _PAGE_CACHE_WB ||
 		      new_prot_val == _PAGE_CACHE_WC)) ||
 		    (prot_val == _PAGE_CACHE_WC &&
@@ -201,6 +202,9 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	default:
 		prot = PAGE_KERNEL_NOCACHE;
 		break;
+	case _PAGE_CACHE_UC_MINUS:
+		prot = PAGE_KERNEL_UC_MINUS;
+		break;
 	case _PAGE_CACHE_WC:
 		prot = PAGE_KERNEL_WC;
 		break;
@@ -255,7 +259,16 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
  */
 void __iomem *ioremap_nocache(resource_size_t phys_addr, unsigned long size)
 {
-	return __ioremap_caller(phys_addr, size, _PAGE_CACHE_UC,
+	/*
+	 * Ideally, this should be:
+	 *	pat_wc_enabled ? _PAGE_CACHE_UC : _PAGE_CACHE_UC_MINUS;
+	 *
+	 * Till we fix all X drivers to use ioremap_wc(), we will use
+	 * UC MINUS.
+	 */
+	unsigned long val = _PAGE_CACHE_UC_MINUS;
+
+	return __ioremap_caller(phys_addr, size, val,
 				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(ioremap_nocache);
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index bd5e05c..60bcb5b 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -777,14 +777,20 @@ static inline int change_page_attr_clear(unsigned long addr, int numpages,
 
 int _set_memory_uc(unsigned long addr, int numpages)
 {
+	/*
+	 * for now UC MINUS. see comments in ioremap_nocache()
+	 */
 	return change_page_attr_set(addr, numpages,
-				    __pgprot(_PAGE_CACHE_UC));
+				    __pgprot(_PAGE_CACHE_UC_MINUS));
 }
 
 int set_memory_uc(unsigned long addr, int numpages)
 {
+	/*
+	 * for now UC MINUS. see comments in ioremap_nocache()
+	 */
 	if (reserve_memtype(addr, addr + numpages * PAGE_SIZE,
-	                    _PAGE_CACHE_UC, NULL))
+			    _PAGE_CACHE_UC_MINUS, NULL))
 		return -EINVAL;
 
 	return _set_memory_uc(addr, numpages);
diff --git a/arch/x86/pci/Makefile_32 b/arch/x86/pci/Makefile_32
index 2a1516e..7fa5198 100644
--- a/arch/x86/pci/Makefile_32
+++ b/arch/x86/pci/Makefile_32
@@ -9,8 +9,8 @@ pci-y				:= fixup.o
 pci-$(CONFIG_ACPI)		+= acpi.o
 pci-y				+= legacy.o irq.o
 
-pci-$(CONFIG_X86_VISWS)		:= visws.o fixup.o
-pci-$(CONFIG_X86_NUMAQ)		:= numa.o irq.o
+pci-$(CONFIG_X86_VISWS)		+= visws.o fixup.o
+pci-$(CONFIG_X86_NUMAQ)		+= numa.o irq.o
 pci-$(CONFIG_NUMA)		+= mp_bus_to_node.o
 
 obj-y				+= $(pci-y) common.o early.o
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 94f6c73..8af0f0b 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -301,6 +301,13 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 	prot = pgprot_val(vma->vm_page_prot);
 	if (pat_wc_enabled && write_combine)
 		prot |= _PAGE_CACHE_WC;
+	else if (pat_wc_enabled)
+		/*
+		 * ioremap() and ioremap_nocache() defaults to UC MINUS for now.
+		 * To avoid attribute conflicts, request UC MINUS here
+		 * aswell.
+		 */
+		prot |= _PAGE_CACHE_UC_MINUS;
 	else if (boot_cpu_data.x86 > 3)
 		prot |= _PAGE_CACHE_UC;
 
@@ -319,9 +326,8 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 		 * - request is uncached, return cannot be write-combine
 		 * - request is write-combine, return cannot be write-back
 		 */
-		if ((flags == _PAGE_CACHE_UC &&
-		     (new_flags == _PAGE_CACHE_WB ||
-		      new_flags == _PAGE_CACHE_WC)) ||
+		if ((flags == _PAGE_CACHE_UC_MINUS &&
+		     (new_flags == _PAGE_CACHE_WB)) ||
 		    (flags == _PAGE_CACHE_WC &&
 		     new_flags == _PAGE_CACHE_WB)) {
 			free_memtype(addr, addr+len);
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index e2af8ee..4dceeb1 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -303,8 +303,6 @@ int __init sysenter_setup(void)
 
 #ifdef CONFIG_X86_32
 	gate_vma_init();
-
-	printk("Compat vDSO mapped to %08lx.\n", __fix_to_virt(FIX_VDSO));
 #endif
 
 	if (!vdso32_sysenter()) {
diff --git a/drivers/char/toshiba.c b/drivers/char/toshiba.c
index 64f1cee..663cd15 100644
--- a/drivers/char/toshiba.c
+++ b/drivers/char/toshiba.c
@@ -426,7 +426,7 @@ static int tosh_probe(void)
 	int i,major,minor,day,year,month,flag;
 	unsigned char signature[7] = { 0x54,0x4f,0x53,0x48,0x49,0x42,0x41 };
 	SMMRegisters regs;
-	void __iomem *bios = ioremap(0xf0000, 0x10000);
+	void __iomem *bios = ioremap_cache(0xf0000, 0x10000);
 
 	if (!bios)
 		return -ENOMEM;
diff --git a/include/asm-x86/mach-default/mach_apic.h b/include/asm-x86/mach-default/mach_apic.h
index 0a6634f..21003b5 100644
--- a/include/asm-x86/mach-default/mach_apic.h
+++ b/include/asm-x86/mach-default/mach_apic.h
@@ -109,13 +109,8 @@ static inline int cpu_to_logical_apicid(int cpu)
 
 static inline int cpu_present_to_apicid(int mps_cpu)
 {
-#ifdef CONFIG_X86_64
-	if (cpu_present(mps_cpu))
+	if (mps_cpu < NR_CPUS && cpu_present(mps_cpu))
 		return (int)per_cpu(x86_bios_cpu_apicid, mps_cpu);
-#else
-	if (mps_cpu < get_physical_broadcast())
-		return  mps_cpu;
-#endif
 	else
 		return BAD_APICID;
 }
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 2e7974e..5591052 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -3,9 +3,6 @@
 
 #include <asm/processor-flags.h>
 
-/* migration helper, for KVM - will be removed in 2.6.25: */
-#define Xgt_desc_struct	desc_ptr
-
 /* Forward declaration, a strange C thing */
 struct task_struct;
 struct mm_struct;
diff --git a/include/asm-x86/proto.h b/include/asm-x86/proto.h
index 1e17bcc..6c8b41b 100644
--- a/include/asm-x86/proto.h
+++ b/include/asm-x86/proto.h
@@ -20,7 +20,11 @@ extern void syscall32_cpu_init(void);
 
 extern void check_efer(void);
 
+#ifdef CONFIG_X86_BIOS_REBOOT
 extern int reboot_force;
+#else
+static const int reboot_force = 0;
+#endif
 
 long do_arch_prctl(struct task_struct *task, int code, unsigned long addr);
 
