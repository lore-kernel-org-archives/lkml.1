Return-Path: <linux-kernel-owner+w=401wt.eu-S1758947AbZDQBd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbZDQBd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757511AbZDQBdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:33:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54289 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756272AbZDQBdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:33:18 -0400
Date: Fri, 17 Apr 2009 03:32:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: [GIT PULL] x86 fixes
Message-ID: <20090417013254.GA17588@elte.hu>
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

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

I wanted to wait one more day with the PAT bits ... but tomorrow 
might be too close to the next -rc? All PAT commits but the last one 
are old. This should also fix those memtype warnings on your box 
that you reported during the merge window.

The PAT changes are still larger than what we'd like - we originally 
had them queued up for the next merge window but then decided that 
these are fixes and cleanups are good and necessary for current 
mainline.

out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
drivers/char/mem.c                 # 0c3c8a1: x86, PAT: Remove duplicate memtyp

 Thanks,

	Ingo

------------------>
Dmitry Adamushko (1):
      x86: fix microcode driver newly spewing warnings

Ingo Molnar (1):
      x86: disable X86_PTRACE_BTS for now

Jaswinder Singh Rajput (2):
      x86: pci-swiotlb.c swiotlb_dma_ops should be static
      x86, documentation: kernel-parameters replace X86-32,X86-64 with X86

Pallipadi, Venkatesh (1):
      x86, PAT: Remove page granularity tracking for vm_insert_pfn maps

Suresh Siddha (3):
      x86, CPA: Change idmap attribute before ioremap attribute setup
      x86, PAT: Consolidate code in pat_x_mtrr_type() and reserve_memtype()
      x86, PAT: Remove duplicate memtype reserve in devmem mmap

venkatesh.pallipadi@intel.com (3):
      x86, PAT: Change order of cpa and free in set_memory_wb
      x86, PAT: Handle faults cleanly in set_memory_ APIs
      x86, PAT: Changing memtype to WC ensuring no WB alias


 Documentation/kernel-parameters.txt |   40 ++++----
 arch/x86/Kconfig.cpu                |    1 +
 arch/x86/include/asm/pat.h          |    4 -
 arch/x86/kernel/microcode_core.c    |    2 -
 arch/x86/kernel/pci-swiotlb.c       |    2 +-
 arch/x86/mm/ioremap.c               |   10 +-
 arch/x86/mm/pageattr.c              |  127 ++++++++++++++---------
 arch/x86/mm/pat.c                   |  189 ++++++-----------------------------
 drivers/char/mem.c                  |   27 -----
 9 files changed, 137 insertions(+), 265 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6172e43..a19f021 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -134,7 +134,7 @@ and is between 256 and 4096 characters. It is defined in the file
 ./include/asm/setup.h as COMMAND_LINE_SIZE.
 
 
-	acpi=		[HW,ACPI,X86-64,i386]
+	acpi=		[HW,ACPI,X86]
 			Advanced Configuration and Power Interface
 			Format: { force | off | ht | strict | noirq | rsdt }
 			force -- enable ACPI if default was off
@@ -218,7 +218,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			acpi_osi="!string2"	# remove built-in string2
 			acpi_osi=		# disable all strings
 
-	acpi_pm_good	[X86-32,X86-64]
+	acpi_pm_good	[X86]
 			Override the pmtimer bug detection: force the kernel
 			to assume that this machine's pmtimer latches its value
 			and always returns good values.
@@ -459,7 +459,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			Also note the kernel might malfunction if you disable
 			some critical bits.
 
-	code_bytes	[IA32/X86_64] How many bytes of object code to print
+	code_bytes	[X86] How many bytes of object code to print
 			in an oops report.
 			Range: 0 - 8192
 			Default: 64
@@ -592,7 +592,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			MTRR settings.  This parameter disables that behavior,
 			possibly causing your machine to run very slowly.
 
-	disable_timer_pin_1 [i386,x86-64]
+	disable_timer_pin_1 [X86]
 			Disable PIN 1 of APIC timer
 			Can be useful to work around chipset bugs.
 
@@ -624,7 +624,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			UART at the specified I/O port or MMIO address.
 			The options are the same as for ttyS, above.
 
-	earlyprintk=	[X86-32,X86-64,SH,BLACKFIN]
+	earlyprintk=	[X86,SH,BLACKFIN]
 			earlyprintk=vga
 			earlyprintk=serial[,ttySn[,baudrate]]
 			earlyprintk=dbgp
@@ -659,7 +659,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			See Documentation/block/as-iosched.txt and
 			Documentation/block/deadline-iosched.txt for details.
 
-	elfcorehdr=	[IA64,PPC,SH,X86-32,X86_64]
+	elfcorehdr=	[IA64,PPC,SH,X86]
 			Specifies physical address of start of kernel core
 			image elf header. Generally kexec loader will
 			pass this option to capture kernel.
@@ -938,7 +938,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			See comment before marvel_specify_io7 in
 			arch/alpha/kernel/core_marvel.c.
 
-	io_delay=	[X86-32,X86-64] I/O delay method
+	io_delay=	[X86] I/O delay method
 		0x80
 			Standard port 0x80 based delay
 		0xed
@@ -1000,7 +1000,7 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	keepinitrd	[HW,ARM]
 
-	kernelcore=nn[KMG]	[KNL,X86-32,IA-64,PPC,X86-64] This parameter
+	kernelcore=nn[KMG]	[KNL,X86,IA-64,PPC] This parameter
 			specifies the amount of memory usable by the kernel
 			for non-movable allocations.  The requested amount is
 			spread evenly throughout all nodes in the system. The
@@ -1034,7 +1034,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			Configure the RouterBoard 532 series on-chip
 			Ethernet adapter MAC address.
 
-	kstack=N	[X86-32,X86-64] Print N words from the kernel stack
+	kstack=N	[X86] Print N words from the kernel stack
 			in oops dumps.
 
 	l2cr=		[PPC]
@@ -1044,7 +1044,7 @@ and is between 256 and 4096 characters. It is defined in the file
 	lapic		[X86-32,APIC] Enable the local APIC even if BIOS
 			disabled it.
 
-	lapic_timer_c2_ok	[X86-32,x86-64,APIC] trust the local apic timer
+	lapic_timer_c2_ok	[X86,APIC] trust the local apic timer
 			in C2 power state.
 
 	libata.dma=	[LIBATA] DMA control
@@ -1229,7 +1229,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			[KNL,SH] Allow user to override the default size for
 			per-device physically contiguous DMA buffers.
 
-	memmap=exactmap	[KNL,X86-32,X86_64] Enable setting of an exact
+	memmap=exactmap	[KNL,X86] Enable setting of an exact
 			E820 memory map, as specified by the user.
 			Such memmap=exactmap lines can be constructed based on
 			BIOS output or other requirements. See the memmap=nn@ss
@@ -1320,7 +1320,7 @@ and is between 256 and 4096 characters. It is defined in the file
 	mousedev.yres=	[MOUSE] Vertical screen resolution, used for devices
 			reporting absolute coordinates, such as tablets
 
-	movablecore=nn[KMG]	[KNL,X86-32,IA-64,PPC,X86-64] This parameter
+	movablecore=nn[KMG]	[KNL,X86,IA-64,PPC] This parameter
 			is similar to kernelcore except it specifies the
 			amount of memory used for migratable allocations.
 			If both kernelcore and movablecore is specified,
@@ -1422,7 +1422,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			when a NMI is triggered.
 			Format: [state][,regs][,debounce][,die]
 
-	nmi_watchdog=	[KNL,BUGS=X86-32,X86-64] Debugging features for SMP kernels
+	nmi_watchdog=	[KNL,BUGS=X86] Debugging features for SMP kernels
 			Format: [panic,][num]
 			Valid num: 0,1,2
 			0 - turn nmi_watchdog off
@@ -1475,11 +1475,11 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	nodsp		[SH] Disable hardware DSP at boot time.
 
-	noefi		[X86-32,X86-64] Disable EFI runtime services support.
+	noefi		[X86] Disable EFI runtime services support.
 
 	noexec		[IA-64]
 
-	noexec		[X86-32,X86-64]
+	noexec		[X86]
 			On X86-32 available only on PAE configured kernels.
 			noexec=on: enable non-executable mappings (default)
 			noexec=off: disable non-executable mappings
@@ -1525,7 +1525,7 @@ and is between 256 and 4096 characters. It is defined in the file
 	noirqdebug	[X86-32] Disables the code which attempts to detect and
 			disable unhandled interrupt sources.
 
-	no_timer_check	[X86-32,X86_64,APIC] Disables the code which tests for
+	no_timer_check	[X86,APIC] Disables the code which tests for
 			broken timer IRQ sources.
 
 	noisapnp	[ISAPNP] Disables ISA PnP code.
@@ -1689,7 +1689,7 @@ and is between 256 and 4096 characters. It is defined in the file
 				disable the use of PCIE advanced error reporting.
 		nodomains	[PCI] Disable support for multiple PCI
 				root domains (aka PCI segments, in ACPI-speak).
-		nommconf	[X86-32,X86_64] Disable use of MMCONFIG for PCI
+		nommconf	[X86] Disable use of MMCONFIG for PCI
 				Configuration
 		nomsi		[MSI] If the PCI_MSI kernel config parameter is
 				enabled, this kernel boot option can be used to
@@ -2380,7 +2380,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			reported either.
 
 	unknown_nmi_panic
-			[X86-32,X86-64]
+			[X86]
 			Set unknown_nmi_panic=1 early on boot.
 
 	usbcore.autosuspend=
@@ -2447,12 +2447,12 @@ and is between 256 and 4096 characters. It is defined in the file
 					medium is write-protected).
 			Example: quirks=0419:aaf5:rl,0421:0433:rc
 
-	vdso=		[X86-32,SH,x86-64]
+	vdso=		[X86,SH]
 			vdso=2: enable compat VDSO (default with COMPAT_VDSO)
 			vdso=1: enable VDSO (default)
 			vdso=0: disable VDSO mapping
 
-	vdso32=		[X86-32,X86-64]
+	vdso32=		[X86]
 			vdso32=2: enable compat VDSO (default with COMPAT_VDSO)
 			vdso32=1: enable 32-bit VDSO (default)
 			vdso32=0: disable 32-bit VDSO mapping
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 924e156..8130334 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -506,6 +506,7 @@ config X86_PTRACE_BTS
 	bool "Branch Trace Store"
 	default y
 	depends on X86_DEBUGCTLMSR
+	depends on BROKEN
 	---help---
 	  This adds a ptrace interface to the hardware's branch trace store.
 
diff --git a/arch/x86/include/asm/pat.h b/arch/x86/include/asm/pat.h
index 2cd07b9..7af14e5 100644
--- a/arch/x86/include/asm/pat.h
+++ b/arch/x86/include/asm/pat.h
@@ -18,9 +18,5 @@ extern int free_memtype(u64 start, u64 end);
 
 extern int kernel_map_sync_memtype(u64 base, unsigned long size,
 		unsigned long flag);
-extern void map_devmem(unsigned long pfn, unsigned long size,
-		       struct pgprot vma_prot);
-extern void unmap_devmem(unsigned long pfn, unsigned long size,
-			 struct pgprot vma_prot);
 
 #endif /* _ASM_X86_PAT_H */
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index a0f3851..4d420de 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -391,8 +391,6 @@ static int mc_sysdev_add(struct sys_device *sys_dev)
 		return err;
 
 	err = microcode_init_cpu(cpu);
-	if (err)
-		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
 
 	return err;
 }
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 34f12e9..221a385 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -50,7 +50,7 @@ static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	return swiotlb_alloc_coherent(hwdev, size, dma_handle, flags);
 }
 
-struct dma_map_ops swiotlb_dma_ops = {
+static struct dma_map_ops swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
 	.alloc_coherent = x86_swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 0dfa09d..d4c4b2c 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -280,15 +280,16 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		return NULL;
 	area->phys_addr = phys_addr;
 	vaddr = (unsigned long) area->addr;
-	if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot)) {
+
+	if (kernel_map_sync_memtype(phys_addr, size, prot_val)) {
 		free_memtype(phys_addr, phys_addr + size);
 		free_vm_area(area);
 		return NULL;
 	}
 
-	if (ioremap_change_attr(vaddr, size, prot_val) < 0) {
+	if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot)) {
 		free_memtype(phys_addr, phys_addr + size);
-		vunmap(area->addr);
+		free_vm_area(area);
 		return NULL;
 	}
 
@@ -374,7 +375,8 @@ static void __iomem *ioremap_default(resource_size_t phys_addr,
 	 * - UC_MINUS for non-WB-able memory with no other conflicting mappings
 	 * - Inherit from confliting mappings otherwise
 	 */
-	err = reserve_memtype(phys_addr, phys_addr + size, -1, &flags);
+	err = reserve_memtype(phys_addr, phys_addr + size,
+				_PAGE_CACHE_WB, &flags);
 	if (err < 0)
 		return NULL;
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index d71e1b6..797f9f1 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -945,71 +945,94 @@ int _set_memory_uc(unsigned long addr, int numpages)
 
 int set_memory_uc(unsigned long addr, int numpages)
 {
+	int ret;
+
 	/*
 	 * for now UC MINUS. see comments in ioremap_nocache()
 	 */
-	if (reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
-			    _PAGE_CACHE_UC_MINUS, NULL))
-		return -EINVAL;
+	ret = reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
+			    _PAGE_CACHE_UC_MINUS, NULL);
+	if (ret)
+		goto out_err;
+
+	ret = _set_memory_uc(addr, numpages);
+	if (ret)
+		goto out_free;
 
-	return _set_memory_uc(addr, numpages);
+	return 0;
+
+out_free:
+	free_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE);
+out_err:
+	return ret;
 }
 EXPORT_SYMBOL(set_memory_uc);
 
 int set_memory_array_uc(unsigned long *addr, int addrinarray)
 {
-	unsigned long start;
-	unsigned long end;
-	int i;
+	int i, j;
+	int ret;
+
 	/*
 	 * for now UC MINUS. see comments in ioremap_nocache()
 	 */
 	for (i = 0; i < addrinarray; i++) {
-		start = __pa(addr[i]);
-		for (end = start + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
-			if (end != __pa(addr[i + 1]))
-				break;
-			i++;
-		}
-		if (reserve_memtype(start, end, _PAGE_CACHE_UC_MINUS, NULL))
-			goto out;
+		ret = reserve_memtype(__pa(addr[i]), __pa(addr[i]) + PAGE_SIZE,
+					_PAGE_CACHE_UC_MINUS, NULL);
+		if (ret)
+			goto out_free;
 	}
 
-	return change_page_attr_set(addr, addrinarray,
+	ret = change_page_attr_set(addr, addrinarray,
 				    __pgprot(_PAGE_CACHE_UC_MINUS), 1);
-out:
-	for (i = 0; i < addrinarray; i++) {
-		unsigned long tmp = __pa(addr[i]);
-
-		if (tmp == start)
-			break;
-		for (end = tmp + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
-			if (end != __pa(addr[i + 1]))
-				break;
-			i++;
-		}
-		free_memtype(tmp, end);
-	}
-	return -EINVAL;
+	if (ret)
+		goto out_free;
+
+	return 0;
+
+out_free:
+	for (j = 0; j < i; j++)
+		free_memtype(__pa(addr[j]), __pa(addr[j]) + PAGE_SIZE);
+
+	return ret;
 }
 EXPORT_SYMBOL(set_memory_array_uc);
 
 int _set_memory_wc(unsigned long addr, int numpages)
 {
-	return change_page_attr_set(&addr, numpages,
+	int ret;
+	ret = change_page_attr_set(&addr, numpages,
+				    __pgprot(_PAGE_CACHE_UC_MINUS), 0);
+
+	if (!ret) {
+		ret = change_page_attr_set(&addr, numpages,
 				    __pgprot(_PAGE_CACHE_WC), 0);
+	}
+	return ret;
 }
 
 int set_memory_wc(unsigned long addr, int numpages)
 {
+	int ret;
+
 	if (!pat_enabled)
 		return set_memory_uc(addr, numpages);
 
-	if (reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
-		_PAGE_CACHE_WC, NULL))
-		return -EINVAL;
+	ret = reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
+		_PAGE_CACHE_WC, NULL);
+	if (ret)
+		goto out_err;
+
+	ret = _set_memory_wc(addr, numpages);
+	if (ret)
+		goto out_free;
+
+	return 0;
 
-	return _set_memory_wc(addr, numpages);
+out_free:
+	free_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE);
+out_err:
+	return ret;
 }
 EXPORT_SYMBOL(set_memory_wc);
 
@@ -1021,29 +1044,31 @@ int _set_memory_wb(unsigned long addr, int numpages)
 
 int set_memory_wb(unsigned long addr, int numpages)
 {
-	free_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE);
+	int ret;
+
+	ret = _set_memory_wb(addr, numpages);
+	if (ret)
+		return ret;
 
-	return _set_memory_wb(addr, numpages);
+	free_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE);
+	return 0;
 }
 EXPORT_SYMBOL(set_memory_wb);
 
 int set_memory_array_wb(unsigned long *addr, int addrinarray)
 {
 	int i;
+	int ret;
 
-	for (i = 0; i < addrinarray; i++) {
-		unsigned long start = __pa(addr[i]);
-		unsigned long end;
-
-		for (end = start + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
-			if (end != __pa(addr[i + 1]))
-				break;
-			i++;
-		}
-		free_memtype(start, end);
-	}
-	return change_page_attr_clear(addr, addrinarray,
+	ret = change_page_attr_clear(addr, addrinarray,
 				      __pgprot(_PAGE_CACHE_MASK), 1);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < addrinarray; i++)
+		free_memtype(__pa(addr[i]), __pa(addr[i]) + PAGE_SIZE);
+
+	return 0;
 }
 EXPORT_SYMBOL(set_memory_array_wb);
 
@@ -1136,6 +1161,8 @@ int set_pages_array_wb(struct page **pages, int addrinarray)
 
 	retval = cpa_clear_pages_array(pages, addrinarray,
 			__pgprot(_PAGE_CACHE_MASK));
+	if (retval)
+		return retval;
 
 	for (i = 0; i < addrinarray; i++) {
 		start = (unsigned long)page_address(pages[i]);
@@ -1143,7 +1170,7 @@ int set_pages_array_wb(struct page **pages, int addrinarray)
 		free_memtype(start, end);
 	}
 
-	return retval;
+	return 0;
 }
 EXPORT_SYMBOL(set_pages_array_wb);
 
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 640339e..41c8057 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -182,10 +182,10 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
 		u8 mtrr_type;
 
 		mtrr_type = mtrr_type_lookup(start, end);
-		if (mtrr_type == MTRR_TYPE_UNCACHABLE)
-			return _PAGE_CACHE_UC;
-		if (mtrr_type == MTRR_TYPE_WRCOMB)
-			return _PAGE_CACHE_WC;
+		if (mtrr_type != MTRR_TYPE_WRBACK)
+			return _PAGE_CACHE_UC_MINUS;
+
+		return _PAGE_CACHE_WB;
 	}
 
 	return req_type;
@@ -352,23 +352,13 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 		return 0;
 	}
 
-	if (req_type == -1) {
-		/*
-		 * Call mtrr_lookup to get the type hint. This is an
-		 * optimization for /dev/mem mmap'ers into WB memory (BIOS
-		 * tools and ACPI tools). Use WB request for WB memory and use
-		 * UC_MINUS otherwise.
-		 */
-		u8 mtrr_type = mtrr_type_lookup(start, end);
-
-		if (mtrr_type == MTRR_TYPE_WRBACK)
-			actual_type = _PAGE_CACHE_WB;
-		else
-			actual_type = _PAGE_CACHE_UC_MINUS;
-	} else {
-		actual_type = pat_x_mtrr_type(start, end,
-					      req_type & _PAGE_CACHE_MASK);
-	}
+	/*
+	 * Call mtrr_lookup to get the type hint. This is an
+	 * optimization for /dev/mem mmap'ers into WB memory (BIOS
+	 * tools and ACPI tools). Use WB request for WB memory and use
+	 * UC_MINUS otherwise.
+	 */
+	actual_type = pat_x_mtrr_type(start, end, req_type & _PAGE_CACHE_MASK);
 
 	if (new_type)
 		*new_type = actual_type;
@@ -546,9 +536,7 @@ static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t *vma_prot)
 {
-	u64 offset = ((u64) pfn) << PAGE_SHIFT;
-	unsigned long flags = -1;
-	int retval;
+	unsigned long flags = _PAGE_CACHE_WB;
 
 	if (!range_is_allowed(pfn, size))
 		return 0;
@@ -576,64 +564,11 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 	}
 #endif
 
-	/*
-	 * With O_SYNC, we can only take UC_MINUS mapping. Fail if we cannot.
-	 *
-	 * Without O_SYNC, we want to get
-	 * - WB for WB-able memory and no other conflicting mappings
-	 * - UC_MINUS for non-WB-able memory with no other conflicting mappings
-	 * - Inherit from confliting mappings otherwise
-	 */
-	if (flags != -1) {
-		retval = reserve_memtype(offset, offset + size, flags, NULL);
-	} else {
-		retval = reserve_memtype(offset, offset + size, -1, &flags);
-	}
-
-	if (retval < 0)
-		return 0;
-
-	if (((pfn < max_low_pfn_mapped) ||
-	     (pfn >= (1UL<<(32 - PAGE_SHIFT)) && pfn < max_pfn_mapped)) &&
-	    ioremap_change_attr((unsigned long)__va(offset), size, flags) < 0) {
-		free_memtype(offset, offset + size);
-		printk(KERN_INFO
-		"%s:%d /dev/mem ioremap_change_attr failed %s for %Lx-%Lx\n",
-			current->comm, current->pid,
-			cattr_name(flags),
-			offset, (unsigned long long)(offset + size));
-		return 0;
-	}
-
 	*vma_prot = __pgprot((pgprot_val(*vma_prot) & ~_PAGE_CACHE_MASK) |
 			     flags);
 	return 1;
 }
 
-void map_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
-{
-	unsigned long want_flags = (pgprot_val(vma_prot) & _PAGE_CACHE_MASK);
-	u64 addr = (u64)pfn << PAGE_SHIFT;
-	unsigned long flags;
-
-	reserve_memtype(addr, addr + size, want_flags, &flags);
-	if (flags != want_flags) {
-		printk(KERN_INFO
-		"%s:%d /dev/mem expected mapping type %s for %Lx-%Lx, got %s\n",
-			current->comm, current->pid,
-			cattr_name(want_flags),
-			addr, (unsigned long long)(addr + size),
-			cattr_name(flags));
-	}
-}
-
-void unmap_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
-{
-	u64 addr = (u64)pfn << PAGE_SHIFT;
-
-	free_memtype(addr, addr + size);
-}
-
 /*
  * Change the memory type for the physial address range in kernel identity
  * mapping space if that range is a part of identity map.
@@ -671,8 +606,8 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
 {
 	int is_ram = 0;
 	int ret;
-	unsigned long flags;
 	unsigned long want_flags = (pgprot_val(*vma_prot) & _PAGE_CACHE_MASK);
+	unsigned long flags = want_flags;
 
 	is_ram = pat_pagerange_is_ram(paddr, paddr + size);
 
@@ -734,29 +669,28 @@ static void free_pfn_range(u64 paddr, unsigned long size)
  *
  * If the vma has a linear pfn mapping for the entire range, we get the prot
  * from pte and reserve the entire vma range with single reserve_pfn_range call.
- * Otherwise, we reserve the entire vma range, my ging through the PTEs page
- * by page to get physical address and protection.
  */
 int track_pfn_vma_copy(struct vm_area_struct *vma)
 {
-	int retval = 0;
-	unsigned long i, j;
 	resource_size_t paddr;
 	unsigned long prot;
-	unsigned long vma_start = vma->vm_start;
-	unsigned long vma_end = vma->vm_end;
-	unsigned long vma_size = vma_end - vma_start;
+	unsigned long vma_size = vma->vm_end - vma->vm_start;
 	pgprot_t pgprot;
 
 	if (!pat_enabled)
 		return 0;
 
+	/*
+	 * For now, only handle remap_pfn_range() vmas where
+	 * is_linear_pfn_mapping() == TRUE. Handling of
+	 * vm_insert_pfn() is TBD.
+	 */
 	if (is_linear_pfn_mapping(vma)) {
 		/*
 		 * reserve the whole chunk covered by vma. We need the
 		 * starting address and protection from pte.
 		 */
-		if (follow_phys(vma, vma_start, 0, &prot, &paddr)) {
+		if (follow_phys(vma, vma->vm_start, 0, &prot, &paddr)) {
 			WARN_ON_ONCE(1);
 			return -EINVAL;
 		}
@@ -764,28 +698,7 @@ int track_pfn_vma_copy(struct vm_area_struct *vma)
 		return reserve_pfn_range(paddr, vma_size, &pgprot, 1);
 	}
 
-	/* reserve entire vma page by page, using pfn and prot from pte */
-	for (i = 0; i < vma_size; i += PAGE_SIZE) {
-		if (follow_phys(vma, vma_start + i, 0, &prot, &paddr))
-			continue;
-
-		pgprot = __pgprot(prot);
-		retval = reserve_pfn_range(paddr, PAGE_SIZE, &pgprot, 1);
-		if (retval)
-			goto cleanup_ret;
-	}
 	return 0;
-
-cleanup_ret:
-	/* Reserve error: Cleanup partial reservation and return error */
-	for (j = 0; j < i; j += PAGE_SIZE) {
-		if (follow_phys(vma, vma_start + j, 0, &prot, &paddr))
-			continue;
-
-		free_pfn_range(paddr, PAGE_SIZE);
-	}
-
-	return retval;
 }
 
 /*
@@ -795,50 +708,28 @@ cleanup_ret:
  * prot is passed in as a parameter for the new mapping. If the vma has a
  * linear pfn mapping for the entire range reserve the entire vma range with
  * single reserve_pfn_range call.
- * Otherwise, we look t the pfn and size and reserve only the specified range
- * page by page.
- *
- * Note that this function can be called with caller trying to map only a
- * subrange/page inside the vma.
  */
 int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 			unsigned long pfn, unsigned long size)
 {
-	int retval = 0;
-	unsigned long i, j;
-	resource_size_t base_paddr;
 	resource_size_t paddr;
-	unsigned long vma_start = vma->vm_start;
-	unsigned long vma_end = vma->vm_end;
-	unsigned long vma_size = vma_end - vma_start;
+	unsigned long vma_size = vma->vm_end - vma->vm_start;
 
 	if (!pat_enabled)
 		return 0;
 
+	/*
+	 * For now, only handle remap_pfn_range() vmas where
+	 * is_linear_pfn_mapping() == TRUE. Handling of
+	 * vm_insert_pfn() is TBD.
+	 */
 	if (is_linear_pfn_mapping(vma)) {
 		/* reserve the whole chunk starting from vm_pgoff */
 		paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
 		return reserve_pfn_range(paddr, vma_size, prot, 0);
 	}
 
-	/* reserve page by page using pfn and size */
-	base_paddr = (resource_size_t)pfn << PAGE_SHIFT;
-	for (i = 0; i < size; i += PAGE_SIZE) {
-		paddr = base_paddr + i;
-		retval = reserve_pfn_range(paddr, PAGE_SIZE, prot, 0);
-		if (retval)
-			goto cleanup_ret;
-	}
 	return 0;
-
-cleanup_ret:
-	/* Reserve error: Cleanup partial reservation and return error */
-	for (j = 0; j < i; j += PAGE_SIZE) {
-		paddr = base_paddr + j;
-		free_pfn_range(paddr, PAGE_SIZE);
-	}
-
-	return retval;
 }
 
 /*
@@ -849,39 +740,23 @@ cleanup_ret:
 void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
 			unsigned long size)
 {
-	unsigned long i;
 	resource_size_t paddr;
-	unsigned long prot;
-	unsigned long vma_start = vma->vm_start;
-	unsigned long vma_end = vma->vm_end;
-	unsigned long vma_size = vma_end - vma_start;
+	unsigned long vma_size = vma->vm_end - vma->vm_start;
 
 	if (!pat_enabled)
 		return;
 
+	/*
+	 * For now, only handle remap_pfn_range() vmas where
+	 * is_linear_pfn_mapping() == TRUE. Handling of
+	 * vm_insert_pfn() is TBD.
+	 */
 	if (is_linear_pfn_mapping(vma)) {
 		/* free the whole chunk starting from vm_pgoff */
 		paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
 		free_pfn_range(paddr, vma_size);
 		return;
 	}
-
-	if (size != 0 && size != vma_size) {
-		/* free page by page, using pfn and size */
-		paddr = (resource_size_t)pfn << PAGE_SHIFT;
-		for (i = 0; i < size; i += PAGE_SIZE) {
-			paddr = paddr + i;
-			free_pfn_range(paddr, PAGE_SIZE);
-		}
-	} else {
-		/* free entire vma, page by page, using the pfn from pte */
-		for (i = 0; i < vma_size; i += PAGE_SIZE) {
-			if (follow_phys(vma, vma_start + i, 0, &prot, &paddr))
-				continue;
-
-			free_pfn_range(paddr, PAGE_SIZE);
-		}
-	}
 }
 
 pgprot_t pgprot_writecombine(pgprot_t prot)
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 3586b3b..8f05c38 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -301,33 +301,7 @@ static inline int private_mapping_ok(struct vm_area_struct *vma)
 }
 #endif
 
-void __attribute__((weak))
-map_devmem(unsigned long pfn, unsigned long len, pgprot_t prot)
-{
-	/* nothing. architectures can override. */
-}
-
-void __attribute__((weak))
-unmap_devmem(unsigned long pfn, unsigned long len, pgprot_t prot)
-{
-	/* nothing. architectures can override. */
-}
-
-static void mmap_mem_open(struct vm_area_struct *vma)
-{
-	map_devmem(vma->vm_pgoff,  vma->vm_end - vma->vm_start,
-			vma->vm_page_prot);
-}
-
-static void mmap_mem_close(struct vm_area_struct *vma)
-{
-	unmap_devmem(vma->vm_pgoff,  vma->vm_end - vma->vm_start,
-			vma->vm_page_prot);
-}
-
 static struct vm_operations_struct mmap_mem_ops = {
-	.open  = mmap_mem_open,
-	.close = mmap_mem_close,
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 	.access = generic_access_phys
 #endif
@@ -362,7 +336,6 @@ static int mmap_mem(struct file * file, struct vm_area_struct * vma)
 			    vma->vm_pgoff,
 			    size,
 			    vma->vm_page_prot)) {
-		unmap_devmem(vma->vm_pgoff, size, vma->vm_page_prot);
 		return -EAGAIN;
 	}
 	return 0;
