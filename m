Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbYFYINP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbYFYINP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 04:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYFYIM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 04:12:57 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:21091 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbYFYIMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 04:12:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=IyamA47loFLmqgdISqPMUEPUhUq/Fp/xm2kDWYY3/mr8OTehiTPm3iUX822cS2vF+i
         W0D5sS9KrqfsirgISMDeqzaDTd3PvyjWIPWaond9pCdHzPBDa6FGdX/NeUb3GPfxbIOb
         thELhg5LEkimeqkBdeQo+/Gx3AfS1DaCL8O1Y=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: Merge setup_32/64.c into setup.c
Date: Wed, 25 Jun 2008 01:14:09 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806242213.15310.yhlu.kernel@gmail.com> <200806242214.09503.yhlu.kernel@gmail.com>
In-Reply-To: <200806242214.09503.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806250114.09858.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/Makefile   |    2 
 arch/x86/kernel/setup.c    |  676 ++++++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/setup_32.c |  543 ------------------------------------
 arch/x86/kernel/setup_64.c |  381 -------------------------
 include/asm-x86/setup.h    |    2 
 5 files changed, 670 insertions(+), 934 deletions(-)

Index: linux-2.6/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile
+++ linux-2.6/arch/x86/kernel/Makefile
@@ -26,7 +26,7 @@ CFLAGS_paravirt.o	:= $(nostackp)
 obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
 obj-y			+= traps_$(BITS).o irq_$(BITS).o
 obj-y			+= time_$(BITS).o ioport.o ldt.o
-obj-y			+= setup_$(BITS).o i8259.o irqinit_$(BITS).o setup.o
+obj-y			+= i8259.o irqinit_$(BITS).o setup.o
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -1,19 +1,118 @@
-#include <linux/kernel.h>
+/*
+ *  Copyright (C) 1995  Linus Torvalds
+ *
+ *  Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999
+ *
+ *  Memory region support
+ *	David Parsons <orc@pell.chi.il.us>, July-August 1999
+ *
+ *  Added E820 sanitization routine (removes overlapping memory regions);
+ *  Brian Moyle <bmoyle@mvista.com>, February 2001
+ *
+ * Moved CPU detection code to cpu/${cpu}.c
+ *    Patrick Mochel <mochel@osdl.org>, March 2002
+ *
+ *  Provisions for empty E820 memory regions (reported by certain BIOSes).
+ *  Alex Achenbach <xela@slit.de>, December 2002.
+ *
+ */
+
+/*
+ * This file handles the architecture-dependent parts of initialization
+ */
+
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/mmzone.h>
+#include <linux/screen_info.h>
+#include <linux/ioport.h>
+#include <linux/acpi.h>
+#include <linux/apm_bios.h>
+#include <linux/initrd.h>
+#include <linux/bootmem.h>
+#include <linux/seq_file.h>
+#include <linux/console.h>
+#include <linux/mca.h>
+#include <linux/root_dev.h>
+#include <linux/highmem.h>
 #include <linux/module.h>
+#include <linux/efi.h>
 #include <linux/init.h>
-#include <linux/bootmem.h>
-#include <linux/percpu.h>
+#include <linux/edd.h>
+#include <linux/iscsi_ibft.h>
+#include <linux/nodemask.h>
+#include <linux/kexec.h>
+#include <linux/dmi.h>
+#include <linux/pfn.h>
+#include <linux/pci.h>
+#include <asm/pci-direct.h>
+#include <linux/init_ohci1394_dma.h>
+#include <linux/kvm_para.h>
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/stddef.h>
+#include <linux/unistd.h>
+#include <linux/ptrace.h>
+#include <linux/slab.h>
+#include <linux/user.h>
+#include <linux/delay.h>
+#include <linux/highmem.h>
+
+#include <linux/kallsyms.h>
+#include <linux/edd.h>
+#include <linux/iscsi_ibft.h>
 #include <linux/kexec.h>
+#include <linux/cpufreq.h>
+#include <linux/dma-mapping.h>
+#include <linux/ctype.h>
+#include <linux/uaccess.h>
+
+#include <linux/percpu.h>
 #include <linux/crash_dump.h>
+
+#include <video/edid.h>
+
+#include <asm/mtrr.h>
+#include <asm/apic.h>
+#include <asm/e820.h>
+#include <asm/mpspec.h>
+#include <asm/setup.h>
+#include <asm/arch_hooks.h>
+#include <asm/sections.h>
+#include <asm/dmi.h>
+#include <asm/io_apic.h>
+#include <asm/ist.h>
+#include <asm/vmi.h>
+#include <setup_arch.h>
+#include <asm/bios_ebda.h>
+#include <asm/cacheflush.h>
+#include <asm/processor.h>
+#include <asm/bugs.h>
+
+#include <asm/system.h>
+#include <asm/vsyscall.h>
 #include <asm/smp.h>
+#include <asm/desc.h>
+#include <asm/dma.h>
+#include <asm/gart.h>
+#include <asm/mmu_context.h>
+#include <asm/proto.h>
+
+#include <mach_apic.h>
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define ARCH_SETUP
+#endif
+
 #include <asm/percpu.h>
 #include <asm/sections.h>
-#include <asm/processor.h>
-#include <asm/setup.h>
 #include <asm/topology.h>
-#include <asm/mpspec.h>
 #include <asm/apicdef.h>
+#ifdef CONFIG_X86_32
 #include <asm/highmem.h>
+#endif
 
 #ifndef CONFIG_DEBUG_BOOT_PARAMS
 struct boot_params __initdata boot_params;
@@ -498,7 +597,7 @@ static struct resource standard_io_resou
 		.flags = IORESOURCE_BUSY | IORESOURCE_IO }
 };
 
-void __init reserve_standard_io_resources(void)
+static void __init reserve_standard_io_resources(void)
 {
 	int i;
 
@@ -523,3 +622,566 @@ static int __init setup_elfcorehdr(char 
 }
 early_param("elfcorehdr", setup_elfcorehdr);
 #endif
+
+/* real setup */
+
+/* This value is set up by the early boot code to point to the value
+   immediately after the boot time page tables.  It contains a *physical*
+   address, and must not be in the .bss segment! */
+unsigned long init_pg_tables_start __initdata = ~0UL;
+unsigned long init_pg_tables_end __initdata = ~0UL;
+
+/*
+ * Machine setup..
+ */
+static struct resource data_resource = {
+	.name	= "Kernel data",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
+};
+
+static struct resource code_resource = {
+	.name	= "Kernel code",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
+};
+
+static struct resource bss_resource = {
+	.name	= "Kernel bss",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
+};
+
+
+#ifdef CONFIG_X86_32
+static struct resource video_ram_resource = {
+	.name	= "Video RAM area",
+	.start	= 0xa0000,
+	.end	= 0xbffff,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
+};
+
+/* cpu data as detected by the assembly code in head.S */
+struct cpuinfo_x86 new_cpu_data __cpuinitdata = {0, 0, 0, 0, -1, 1, 0, 0, -1};
+/* common cpu data for all cpus */
+struct cpuinfo_x86 boot_cpu_data __read_mostly = {0, 0, 0, 0, -1, 1, 0, 0, -1};
+EXPORT_SYMBOL(boot_cpu_data);
+static void set_mca_bus(int x)
+{
+#ifdef CONFIG_MCA
+	MCA_bus = x;
+#endif
+}
+
+unsigned int def_to_bigsmp;
+
+/* for MCA, but anyone else can use it if they want */
+unsigned int machine_id;
+unsigned int machine_submodel_id;
+unsigned int BIOS_revision;
+
+struct apm_info apm_info;
+EXPORT_SYMBOL(apm_info);
+
+#if defined(CONFIG_X86_SPEEDSTEP_SMI) || \
+	defined(CONFIG_X86_SPEEDSTEP_SMI_MODULE)
+struct ist_info ist_info;
+EXPORT_SYMBOL(ist_info);
+#else
+struct ist_info ist_info;
+#endif
+
+#else
+struct cpuinfo_x86 boot_cpu_data __read_mostly;
+EXPORT_SYMBOL(boot_cpu_data);
+#endif
+
+
+#if !defined(CONFIG_X86_PAE) || defined(CONFIG_X86_64)
+unsigned long mmu_cr4_features;
+#else
+unsigned long mmu_cr4_features = X86_CR4_PAE;
+#endif
+
+/* Boot loader ID as an integer, for the benefit of proc_dointvec */
+int bootloader_type;
+
+/*
+ * Early DMI memory
+ */
+int dmi_alloc_index;
+char dmi_alloc_data[DMI_MAX_DATA];
+
+/*
+ * Setup options
+ */
+struct screen_info screen_info;
+EXPORT_SYMBOL(screen_info);
+struct edid_info edid_info;
+EXPORT_SYMBOL_GPL(edid_info);
+
+extern int root_mountflags;
+
+unsigned long saved_video_mode;
+
+#define RAMDISK_IMAGE_START_MASK	0x07FF
+#define RAMDISK_PROMPT_FLAG		0x8000
+#define RAMDISK_LOAD_FLAG		0x4000
+
+static char __initdata command_line[COMMAND_LINE_SIZE];
+
+#if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
+struct edd edd;
+#ifdef CONFIG_EDD_MODULE
+EXPORT_SYMBOL(edd);
+#endif
+/**
+ * copy_edd() - Copy the BIOS EDD information
+ *              from boot_params into a safe place.
+ *
+ */
+static inline void copy_edd(void)
+{
+     memcpy(edd.mbr_signature, boot_params.edd_mbr_sig_buffer,
+	    sizeof(edd.mbr_signature));
+     memcpy(edd.edd_info, boot_params.eddbuf, sizeof(edd.edd_info));
+     edd.mbr_signature_nr = boot_params.edd_mbr_sig_buf_entries;
+     edd.edd_info_nr = boot_params.eddbuf_entries;
+}
+#else
+static inline void copy_edd(void)
+{
+}
+#endif
+
+#ifdef CONFIG_BLK_DEV_INITRD
+
+#define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
+
+static void __init relocate_initrd(void)
+{
+#ifdef CONFIG_X86_32
+	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
+	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
+	u64 end_of_lowmem = max_low_pfn << PAGE_SHIFT;
+	u64 ramdisk_here;
+	unsigned long slop, clen, mapaddr;
+	char *p, *q;
+
+	ramdisk_here = initrd_start - PAGE_OFFSET;
+
+	q = (char *)initrd_start;
+
+	/* Copy any lowmem portion of the initrd */
+	if (ramdisk_image < end_of_lowmem) {
+		clen = end_of_lowmem - ramdisk_image;
+		p = (char *)__va(ramdisk_image);
+		memcpy(q, p, clen);
+		q += clen;
+		ramdisk_image += clen;
+		ramdisk_size  -= clen;
+	}
+
+	/* Copy the highmem portion of the initrd */
+	while (ramdisk_size) {
+		slop = ramdisk_image & ~PAGE_MASK;
+		clen = ramdisk_size;
+		if (clen > MAX_MAP_CHUNK-slop)
+			clen = MAX_MAP_CHUNK-slop;
+		mapaddr = ramdisk_image & PAGE_MASK;
+		p = early_ioremap(mapaddr, clen+slop);
+		memcpy(q, p+slop, clen);
+		early_iounmap(p, clen+slop);
+		q += clen;
+		ramdisk_image += clen;
+		ramdisk_size  -= clen;
+	}
+	/* high pages is not converted by early_res_to_bootmem */
+	ramdisk_image = boot_params.hdr.ramdisk_image;
+	ramdisk_size  = boot_params.hdr.ramdisk_size;
+	printk(KERN_INFO "Move RAMDISK from %016llx - %016llx to"
+		" %08llx - %08llx\n",
+		ramdisk_image, ramdisk_image + ramdisk_size - 1,
+		ramdisk_here, ramdisk_here + ramdisk_size - 1);
+#endif
+}
+
+static void __init reserve_initrd(void)
+{
+	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
+	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
+	u64 ramdisk_end   = ramdisk_image + ramdisk_size;
+	u64 end_of_lowmem = max_low_pfn << PAGE_SHIFT;
+#ifdef CONFIG_X86_32
+	u64 ramdisk_here;
+#endif
+
+	if (!boot_params.hdr.type_of_loader ||
+	    !ramdisk_image || !ramdisk_size)
+		return;		/* No initrd provided by bootloader */
+
+	initrd_start = 0;
+
+	if (ramdisk_size >= (end_of_lowmem>>1)) {
+		free_early(ramdisk_image, ramdisk_end);
+		printk(KERN_ERR "initrd too large to handle, "
+		       "disabling initrd\n");
+		return;
+	}
+
+	printk(KERN_INFO "RAMDISK: %08llx - %08llx\n", ramdisk_image,
+			ramdisk_end);
+
+
+	if (ramdisk_end <= end_of_lowmem) {
+		/* All in lowmem, easy case */
+		/*
+		 * don't need to reserve again, already reserved early
+		 * in i386_start_kernel
+		 */
+		initrd_start = ramdisk_image + PAGE_OFFSET;
+		initrd_end = initrd_start + ramdisk_size;
+		return;
+	}
+
+#ifdef CONFIG_X86_64
+	printk(KERN_ERR "initrd extends beyond end of memory "
+	       "(0x%08llx > 0x%08llx)\ndisabling initrd\n",
+	       ramdisk_end, end_of_lowmem);
+	initrd_start = 0;
+#else
+
+	/* We need to move the initrd down into lowmem */
+	ramdisk_here = find_e820_area(0, end_of_lowmem, ramdisk_size,
+					 PAGE_SIZE);
+
+	if (ramdisk_here == -1ULL)
+		panic("Cannot find place for new RAMDISK of size %lld\n",
+			 ramdisk_size);
+
+	/* Note: this includes all the lowmem currently occupied by
+	   the initrd, we rely on that fact to keep the data intact. */
+	reserve_early(ramdisk_here, ramdisk_here + ramdisk_size,
+			 "NEW RAMDISK");
+	initrd_start = ramdisk_here + PAGE_OFFSET;
+	initrd_end   = initrd_start + ramdisk_size;
+	printk(KERN_INFO "Allocated new RAMDISK: %08llx - %08llx\n",
+			 ramdisk_here, ramdisk_here + ramdisk_size);
+
+#endif
+	relocate_initrd();
+	free_early(ramdisk_image, ramdisk_end);
+}
+#else
+void __init reserve_initrd(void)
+{
+}
+#endif /* CONFIG_BLK_DEV_INITRD */
+
+/*
+ * Determine if we were loaded by an EFI loader.  If so, then we have also been
+ * passed the efi memmap, systab, etc., so we should use these data structures
+ * for initialization.  Note, the efi init code path is determined by the
+ * global efi_enabled. This allows the same kernel image to be used on existing
+ * systems (with a traditional BIOS) as well as on EFI systems.
+ */
+/*
+ * setup_arch - architecture-specific boot-time initializations
+ *
+ * Note: On x86_64, fixmaps are ready for use even before this is called.
+ */
+
+void __init setup_arch(char **cmdline_p)
+{
+#ifdef CONFIG_X86_32
+	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
+	pre_setup_arch_hook();
+	early_cpu_init();
+	early_ioremap_init();
+	reserve_setup_data();
+#else
+	printk(KERN_INFO "Command line: %s\n", boot_command_line);
+#endif
+
+	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
+	screen_info = boot_params.screen_info;
+	edid_info = boot_params.edid_info;
+#ifdef CONFIG_X86_32
+	apm_info.bios = boot_params.apm_bios_info;
+	ist_info = boot_params.ist_info;
+	if (boot_params.sys_desc_table.length != 0) {
+		set_mca_bus(boot_params.sys_desc_table.table[3] & 0x2);
+		machine_id = boot_params.sys_desc_table.table[0];
+		machine_submodel_id = boot_params.sys_desc_table.table[1];
+		BIOS_revision = boot_params.sys_desc_table.table[2];
+	}
+#endif
+	saved_video_mode = boot_params.hdr.vid_mode;
+	bootloader_type = boot_params.hdr.type_of_loader;
+
+#ifdef CONFIG_BLK_DEV_RAM
+	rd_image_start = boot_params.hdr.ram_size & RAMDISK_IMAGE_START_MASK;
+	rd_prompt = ((boot_params.hdr.ram_size & RAMDISK_PROMPT_FLAG) != 0);
+	rd_doload = ((boot_params.hdr.ram_size & RAMDISK_LOAD_FLAG) != 0);
+#endif
+#ifdef CONFIG_EFI
+	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
+#ifdef CONFIG_X86_32
+		     "EL32",
+#else
+		     "EL64",
+#endif
+	 4)) {
+		efi_enabled = 1;
+		efi_reserve_early();
+	}
+#endif
+
+	ARCH_SETUP
+
+	setup_memory_map();
+	copy_edd();
+
+	if (!boot_params.hdr.root_flags)
+		root_mountflags &= ~MS_RDONLY;
+	init_mm.start_code = (unsigned long) _text;
+	init_mm.end_code = (unsigned long) _etext;
+	init_mm.end_data = (unsigned long) _edata;
+#ifdef CONFIG_X86_32
+	init_mm.brk = init_pg_tables_end + PAGE_OFFSET;
+#else
+	init_mm.brk = (unsigned long) &_end;
+#endif
+
+	code_resource.start = virt_to_phys(_text);
+	code_resource.end = virt_to_phys(_etext)-1;
+	data_resource.start = virt_to_phys(_etext);
+	data_resource.end = virt_to_phys(_edata)-1;
+	bss_resource.start = virt_to_phys(&__bss_start);
+	bss_resource.end = virt_to_phys(&__bss_stop)-1;
+
+#ifdef CONFIG_X86_64
+	early_cpu_init();
+#endif
+	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
+	*cmdline_p = command_line;
+
+	parse_setup_data();
+
+	parse_early_param();
+
+	if (acpi_mps_check()) {
+#ifdef CONFIG_X86_LOCAL_APIC
+#ifdef CONFIG_X86_32
+		enable_local_apic = -1;
+#else
+		disable_apic = 1;
+#endif
+#endif
+		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
+	}
+
+	finish_e820_parsing();
+
+#ifdef CONFIG_X86_32
+	probe_roms();
+#else
+# ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
+	if (init_ohci1394_dma_early)
+		init_ohci1394_dma_on_all_controllers();
+# endif
+#endif
+
+	/* after parse_early_param, so could debug it */
+	insert_resource(&iomem_resource, &code_resource);
+	insert_resource(&iomem_resource, &data_resource);
+	insert_resource(&iomem_resource, &bss_resource);
+
+	if (efi_enabled)
+		efi_init();
+
+#ifdef CONFIG_X86_32
+	if (ppro_with_ram_bug()) {
+		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,
+				  E820_RESERVED);
+		sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+		printk(KERN_INFO "fixed physical RAM map:\n");
+		e820_print_map("bad_ppro");
+	}
+#else
+	early_gart_iommu_check();
+#endif
+
+	e820_register_active_regions(0, 0, -1UL);
+	/*
+	 * partially used pages are not usable - thus
+	 * we are rounding upwards:
+	 */
+	max_pfn = e820_end_of_ram();
+
+	/* preallocate 4k for mptable mpc */
+	early_reserve_e820_mpc_new();
+	/* update e820 for memory not covered by WB MTRRs */
+	mtrr_bp_init();
+	if (mtrr_trim_uncached_memory(max_pfn)) {
+		remove_all_active_ranges();
+		e820_register_active_regions(0, 0, -1UL);
+		max_pfn = e820_end_of_ram();
+	}
+
+#ifdef CONFIG_X86_32
+	/* max_low_pfn get updated here */
+	find_low_pfn_range();
+#else
+	num_physpages = max_pfn;
+
+	check_efer();
+
+	/* How many end-of-memory variables you have, grandma! */
+	/* need this before calling reserve_initrd */
+	max_low_pfn = max_pfn;
+	high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
+#endif
+
+	/* max_pfn_mapped is updated here */
+#ifdef CONFIG_X86_64
+	max_pfn_mapped =
+#endif
+	init_memory_mapping(0, (max_low_pfn << PAGE_SHIFT));
+
+	reserve_initrd();
+
+#ifdef CONFIG_X86_64
+	vsmp_init();
+#endif
+
+	dmi_scan_machine();
+
+	io_delay_init();
+
+	/*
+	 * Parse the ACPI tables for possible boot-time SMP configuration.
+	 */
+	acpi_boot_table_init();
+
+#ifdef CONFIG_X86_64
+	/* Remove active ranges so rediscovery with NUMA-awareness happens */
+	remove_all_active_ranges();
+#endif
+
+#ifdef CONFIG_ACPI_NUMA
+	/*
+	 * Parse SRAT to discover nodes.
+	 */
+	acpi_numa_init();
+#endif
+
+	initmem_init(0, max_pfn);
+
+#ifdef CONFIG_X86_64
+	dma32_reserve_bootmem();
+#endif
+
+#ifdef CONFIG_ACPI_SLEEP
+	/*
+	 * Reserve low memory region for sleep support.
+	 */
+	acpi_reserve_bootmem();
+#endif
+#if defined(CONFIG_X86_FIND_SMP_CONFIG) && defined(CONFIG_X86_32) || \
+    defined(CONFIG_X86_MPPARSE) && defined(CONFIG_X86_64)
+	/*
+	 * Find and reserve possible boot-time SMP configuration:
+	 */
+	find_smp_config();
+#endif
+	reserve_crashkernel();
+
+	reserve_ibft_region();
+
+#ifdef CONFIG_KVM_CLOCK
+	kvmclock_init();
+#endif
+
+#if defined(CONFIG_VMI) && defined(CONFIG_X86_32)
+	/*
+	 * Must be after max_low_pfn is determined, and before kernel
+	 * pagetables are setup.
+	 */
+	vmi_init();
+#endif
+
+	paging_init();
+
+#ifdef CONFIG_X86_64
+	map_vsyscall();
+#endif
+
+	/*
+	 * NOTE: On x86-32, only from this point on, fixmaps are ready for use.
+	 */
+
+#if defined(CONFIG_PROVIDE_OHCI1394_DMA_INIT) && defined(CONFIG_X86_32)
+	if (init_ohci1394_dma_early)
+		init_ohci1394_dma_on_all_controllers();
+#endif
+
+#ifdef CONFIG_X86_GENERICARCH
+	generic_apic_probe();
+#endif
+
+	early_quirks();
+
+	/*
+	 * Read APIC and some other early information from ACPI tables.
+	 */
+	acpi_boot_init();
+
+#ifdef CONFIG_X86_64
+	init_cpu_to_node();
+#endif
+
+#if defined(CONFIG_X86_MPPARSE) || defined(CONFIG_X86_VISWS)
+	/*
+	 * get boot-time SMP configuration:
+	 */
+	if (smp_found_config)
+		get_smp_config();
+#endif
+
+#ifdef CONFIG_X86_64
+	init_apic_mappings();
+	ioapic_init_mappings();
+#else
+# if defined(CONFIG_SMP) && defined(CONFIG_X86_PC)
+	if (def_to_bigsmp)
+		printk(KERN_WARNING "More than 8 CPUs detected and "
+			"CONFIG_X86_PC cannot handle it.\nUse "
+			"CONFIG_X86_GENERICARCH or CONFIG_X86_BIGSMP.\n");
+# endif
+#endif
+	kvm_guest_init();
+
+	e820_reserve_resources();
+	e820_mark_nosave_regions(max_low_pfn);
+
+#ifdef CONFIG_X86_32
+	request_resource(&iomem_resource, &video_ram_resource);
+#endif
+	reserve_standard_io_resources();
+
+	e820_setup_gap();
+
+#ifdef CONFIG_VT
+#if defined(CONFIG_VGA_CONSOLE)
+	if (!efi_enabled || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY))
+		conswitchp = &vga_con;
+#elif defined(CONFIG_DUMMY_CONSOLE)
+	conswitchp = &dummy_con;
+#endif
+#endif
+}
+
Index: linux-2.6/include/asm-x86/setup.h
===================================================================
--- linux-2.6.orig/include/asm-x86/setup.h
+++ linux-2.6/include/asm-x86/setup.h
@@ -38,8 +38,6 @@ void reserve_crashkernel(void);
 #ifndef __ASSEMBLY__
 #include <asm/bootparam.h>
 
-void reserve_standard_io_resources(void);
-
 #ifndef _SETUP
 
 /*
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ /dev/null
@@ -1,381 +0,0 @@
-/*
- *  Copyright (C) 1995  Linus Torvalds
- */
-
-/*
- * This file handles the architecture-dependent parts of initialization
- */
-
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/stddef.h>
-#include <linux/unistd.h>
-#include <linux/ptrace.h>
-#include <linux/slab.h>
-#include <linux/user.h>
-#include <linux/screen_info.h>
-#include <linux/ioport.h>
-#include <linux/delay.h>
-#include <linux/init.h>
-#include <linux/initrd.h>
-#include <linux/highmem.h>
-#include <linux/bootmem.h>
-#include <linux/module.h>
-#include <asm/processor.h>
-#include <linux/console.h>
-#include <linux/seq_file.h>
-#include <linux/root_dev.h>
-#include <linux/pci.h>
-#include <asm/pci-direct.h>
-#include <linux/efi.h>
-#include <linux/acpi.h>
-#include <linux/kallsyms.h>
-#include <linux/edd.h>
-#include <linux/iscsi_ibft.h>
-#include <linux/mmzone.h>
-#include <linux/kexec.h>
-#include <linux/cpufreq.h>
-#include <linux/dmi.h>
-#include <linux/dma-mapping.h>
-#include <linux/ctype.h>
-#include <linux/uaccess.h>
-#include <linux/init_ohci1394_dma.h>
-#include <linux/kvm_para.h>
-
-#include <asm/mtrr.h>
-#include <asm/uaccess.h>
-#include <asm/system.h>
-#include <asm/vsyscall.h>
-#include <asm/io.h>
-#include <asm/smp.h>
-#include <asm/desc.h>
-#include <video/edid.h>
-#include <asm/e820.h>
-#include <asm/mpspec.h>
-#include <asm/dma.h>
-#include <asm/gart.h>
-#include <asm/mpspec.h>
-#include <asm/mmu_context.h>
-#include <asm/proto.h>
-#include <asm/setup.h>
-#include <asm/numa.h>
-#include <asm/sections.h>
-#include <asm/dmi.h>
-#include <asm/cacheflush.h>
-
-#include <mach_apic.h>
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else
-#define ARCH_SETUP
-#endif
-
-/*
- * Machine setup..
- */
-
-struct cpuinfo_x86 boot_cpu_data __read_mostly;
-EXPORT_SYMBOL(boot_cpu_data);
-
-unsigned long mmu_cr4_features;
-
-/* Boot loader ID as an integer, for the benefit of proc_dointvec */
-int bootloader_type;
-
-unsigned long saved_video_mode;
-
-/*
- * Early DMI memory
- */
-int dmi_alloc_index;
-char dmi_alloc_data[DMI_MAX_DATA];
-
-/*
- * Setup options
- */
-struct screen_info screen_info;
-EXPORT_SYMBOL(screen_info);
-struct sys_desc_table_struct {
-	unsigned short length;
-	unsigned char table[0];
-};
-
-struct edid_info edid_info;
-EXPORT_SYMBOL_GPL(edid_info);
-
-extern int root_mountflags;
-
-static char __initdata command_line[COMMAND_LINE_SIZE];
-
-#define IORESOURCE_RAM (IORESOURCE_BUSY | IORESOURCE_MEM)
-
-static struct resource data_resource = {
-	.name = "Kernel data",
-	.start = 0,
-	.end = 0,
-	.flags = IORESOURCE_RAM,
-};
-static struct resource code_resource = {
-	.name = "Kernel code",
-	.start = 0,
-	.end = 0,
-	.flags = IORESOURCE_RAM,
-};
-static struct resource bss_resource = {
-	.name = "Kernel bss",
-	.start = 0,
-	.end = 0,
-	.flags = IORESOURCE_RAM,
-};
-
-#if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
-struct edd edd;
-#ifdef CONFIG_EDD_MODULE
-EXPORT_SYMBOL(edd);
-#endif
-/**
- * copy_edd() - Copy the BIOS EDD information
- *              from boot_params into a safe place.
- *
- */
-static inline void copy_edd(void)
-{
-     memcpy(edd.mbr_signature, boot_params.edd_mbr_sig_buffer,
-	    sizeof(edd.mbr_signature));
-     memcpy(edd.edd_info, boot_params.eddbuf, sizeof(edd.edd_info));
-     edd.mbr_signature_nr = boot_params.edd_mbr_sig_buf_entries;
-     edd.edd_info_nr = boot_params.eddbuf_entries;
-}
-#else
-static inline void copy_edd(void)
-{
-}
-#endif
-
-static void __init reserve_initrd(void)
-{
-#ifdef CONFIG_BLK_DEV_INITRD
-	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
-		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
-		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
-		unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
-		unsigned long end_of_mem    = max_pfn << PAGE_SHIFT;
-
-		if (ramdisk_end <= end_of_mem) {
-			/*
-			 * don't need to reserve again, already reserved early
-			 * in x86_64_start_kernel, and early_res_to_bootmem
-			 * will convert that to reserved in bootmem
-			 */
-			initrd_start = ramdisk_image + PAGE_OFFSET;
-			initrd_end = initrd_start+ramdisk_size;
-		} else {
-			free_early(ramdisk_image, ramdisk_end);
-			printk(KERN_ERR "initrd extends beyond end of memory "
-			       "(0x%08lx > 0x%08lx)\ndisabling initrd\n",
-			       ramdisk_end, end_of_mem);
-			initrd_start = 0;
-		}
-	}
-#endif
-}
-
-/*
- * setup_arch - architecture-specific boot-time initializations
- *
- * Note: On x86_64, fixmaps are ready for use even before this is called.
- */
-void __init setup_arch(char **cmdline_p)
-{
-	printk(KERN_INFO "Command line: %s\n", boot_command_line);
-
-	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
-	screen_info = boot_params.screen_info;
-	edid_info = boot_params.edid_info;
-	saved_video_mode = boot_params.hdr.vid_mode;
-	bootloader_type = boot_params.hdr.type_of_loader;
-
-#ifdef CONFIG_BLK_DEV_RAM
-	rd_image_start = boot_params.hdr.ram_size & RAMDISK_IMAGE_START_MASK;
-	rd_prompt = ((boot_params.hdr.ram_size & RAMDISK_PROMPT_FLAG) != 0);
-	rd_doload = ((boot_params.hdr.ram_size & RAMDISK_LOAD_FLAG) != 0);
-#endif
-#ifdef CONFIG_EFI
-	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-		     "EL64", 4)) {
-		efi_enabled = 1;
-		efi_reserve_early();
-	}
-#endif
-
-	ARCH_SETUP
-
-	setup_memory_map();
-	copy_edd();
-
-	if (!boot_params.hdr.root_flags)
-		root_mountflags &= ~MS_RDONLY;
-	init_mm.start_code = (unsigned long) &_text;
-	init_mm.end_code = (unsigned long) &_etext;
-	init_mm.end_data = (unsigned long) &_edata;
-	init_mm.brk = (unsigned long) &_end;
-
-	code_resource.start = virt_to_phys(&_text);
-	code_resource.end = virt_to_phys(&_etext)-1;
-	data_resource.start = virt_to_phys(&_etext);
-	data_resource.end = virt_to_phys(&_edata)-1;
-	bss_resource.start = virt_to_phys(&__bss_start);
-	bss_resource.end = virt_to_phys(&__bss_stop)-1;
-
-	early_cpu_init();
-
-	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
-	*cmdline_p = command_line;
-
-	parse_setup_data();
-
-	parse_early_param();
-
-	if (acpi_mps_check()) {
-		disable_apic = 1;
-		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
-	}
-
-#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
-	if (init_ohci1394_dma_early)
-		init_ohci1394_dma_on_all_controllers();
-#endif
-
-	finish_e820_parsing();
-
-	/* after parse_early_param, so could debug it */
-	insert_resource(&iomem_resource, &code_resource);
-	insert_resource(&iomem_resource, &data_resource);
-	insert_resource(&iomem_resource, &bss_resource);
-
-	if (efi_enabled)
-		efi_init();
-
-	early_gart_iommu_check();
-
-	e820_register_active_regions(0, 0, -1UL);
-	/*
-	 * partially used pages are not usable - thus
-	 * we are rounding upwards:
-	 */
-	max_pfn = e820_end_of_ram();
-
-	/* pre allocte 4k for mptable mpc */
-	early_reserve_e820_mpc_new();
-	/* update e820 for memory not covered by WB MTRRs */
-	mtrr_bp_init();
-	if (mtrr_trim_uncached_memory(max_pfn)) {
-		remove_all_active_ranges();
-		e820_register_active_regions(0, 0, -1UL);
-		max_pfn = e820_end_of_ram();
-	}
-
-	reserve_initrd();
-
-	num_physpages = max_pfn;
-
-	check_efer();
-
-	max_pfn_mapped = init_memory_mapping(0, (max_pfn << PAGE_SHIFT));
-
-	vsmp_init();
-
-	dmi_scan_machine();
-
-	io_delay_init();
-
-	/*
-	 * Initialize the ACPI boot-time table parser (gets the RSDP and SDT).
-	 * Call this early for SRAT node setup.
-	 */
-	acpi_boot_table_init();
-
-	/* How many end-of-memory variables you have, grandma! */
-	max_low_pfn = max_pfn;
-	high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
-
-	/* Remove active ranges so rediscovery with NUMA-awareness happens */
-	remove_all_active_ranges();
-
-#ifdef CONFIG_ACPI_NUMA
-	/*
-	 * Parse SRAT to discover nodes.
-	 */
-	acpi_numa_init();
-#endif
-
-	initmem_init(0, max_pfn);
-
-	dma32_reserve_bootmem();
-
-#ifdef CONFIG_ACPI_SLEEP
-	/*
-	 * Reserve low memory region for sleep support.
-	 */
-       acpi_reserve_bootmem();
-#endif
-
-#ifdef CONFIG_X86_MPPARSE
-       /*
-	* Find and reserve possible boot-time SMP configuration:
-	*/
-	find_smp_config();
-#endif
-	reserve_crashkernel();
-
-	reserve_ibft_region();
-
-#ifdef CONFIG_KVM_CLOCK
-	kvmclock_init();
-#endif
-	paging_init();
-	map_vsyscall();
-
-	early_quirks();
-
-	/*
-	 * Read APIC and some other early information from ACPI tables.
-	 */
-	acpi_boot_init();
-
-	init_cpu_to_node();
-
-#ifdef CONFIG_X86_MPPARSE
-	/*
-	 * get boot-time SMP configuration:
-	 */
-	if (smp_found_config)
-		get_smp_config();
-#endif
-	init_apic_mappings();
-	ioapic_init_mappings();
-
-	kvm_guest_init();
-
-	/*
-	 * We trust e820 completely. No explicit ROM probing in memory.
-	 */
-	e820_reserve_resources();
-	e820_mark_nosave_regions(max_pfn);
-
-	reserve_standard_io_resources();
-
-	e820_setup_gap();
-
-#ifdef CONFIG_VT
-#if defined(CONFIG_VGA_CONSOLE)
-	if (!efi_enabled || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY))
-		conswitchp = &vga_con;
-#elif defined(CONFIG_DUMMY_CONSOLE)
-	conswitchp = &dummy_con;
-#endif
-#endif
-}
-
Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ /dev/null
@@ -1,543 +0,0 @@
-/*
- *  Copyright (C) 1995  Linus Torvalds
- *
- *  Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999
- *
- *  Memory region support
- *	David Parsons <orc@pell.chi.il.us>, July-August 1999
- *
- *  Added E820 sanitization routine (removes overlapping memory regions);
- *  Brian Moyle <bmoyle@mvista.com>, February 2001
- *
- * Moved CPU detection code to cpu/${cpu}.c
- *    Patrick Mochel <mochel@osdl.org>, March 2002
- *
- *  Provisions for empty E820 memory regions (reported by certain BIOSes).
- *  Alex Achenbach <xela@slit.de>, December 2002.
- *
- */
-
-/*
- * This file handles the architecture-dependent parts of initialization
- */
-
-#include <linux/sched.h>
-#include <linux/mm.h>
-#include <linux/mmzone.h>
-#include <linux/screen_info.h>
-#include <linux/ioport.h>
-#include <linux/acpi.h>
-#include <linux/apm_bios.h>
-#include <linux/initrd.h>
-#include <linux/bootmem.h>
-#include <linux/seq_file.h>
-#include <linux/console.h>
-#include <linux/mca.h>
-#include <linux/root_dev.h>
-#include <linux/highmem.h>
-#include <linux/module.h>
-#include <linux/efi.h>
-#include <linux/init.h>
-#include <linux/edd.h>
-#include <linux/iscsi_ibft.h>
-#include <linux/nodemask.h>
-#include <linux/kexec.h>
-#include <linux/dmi.h>
-#include <linux/pfn.h>
-#include <linux/pci.h>
-#include <linux/init_ohci1394_dma.h>
-#include <linux/kvm_para.h>
-
-#include <video/edid.h>
-
-#include <asm/mtrr.h>
-#include <asm/apic.h>
-#include <asm/e820.h>
-#include <asm/mpspec.h>
-#include <asm/mmzone.h>
-#include <asm/setup.h>
-#include <asm/arch_hooks.h>
-#include <asm/sections.h>
-#include <asm/dmi.h>
-#include <asm/io_apic.h>
-#include <asm/ist.h>
-#include <asm/io.h>
-#include <asm/vmi.h>
-#include <setup_arch.h>
-#include <asm/bios_ebda.h>
-#include <asm/cacheflush.h>
-#include <asm/processor.h>
-#include <asm/efi.h>
-#include <asm/bugs.h>
-
-/* This value is set up by the early boot code to point to the value
-   immediately after the boot time page tables.  It contains a *physical*
-   address, and must not be in the .bss segment! */
-unsigned long init_pg_tables_start __initdata = ~0UL;
-unsigned long init_pg_tables_end __initdata = ~0UL;
-
-/*
- * Machine setup..
- */
-static struct resource data_resource = {
-	.name	= "Kernel data",
-	.start	= 0,
-	.end	= 0,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
-};
-
-static struct resource code_resource = {
-	.name	= "Kernel code",
-	.start	= 0,
-	.end	= 0,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
-};
-
-static struct resource bss_resource = {
-	.name	= "Kernel bss",
-	.start	= 0,
-	.end	= 0,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
-};
-
-static struct resource video_ram_resource = {
-	.name	= "Video RAM area",
-	.start	= 0xa0000,
-	.end	= 0xbffff,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
-};
-
-/* cpu data as detected by the assembly code in head.S */
-struct cpuinfo_x86 new_cpu_data __cpuinitdata = { 0, 0, 0, 0, -1, 1, 0, 0, -1 };
-/* common cpu data for all cpus */
-struct cpuinfo_x86 boot_cpu_data __read_mostly = { 0, 0, 0, 0, -1, 1, 0, 0, -1 };
-EXPORT_SYMBOL(boot_cpu_data);
-
-unsigned int def_to_bigsmp;
-
-#ifndef CONFIG_X86_PAE
-unsigned long mmu_cr4_features;
-#else
-unsigned long mmu_cr4_features = X86_CR4_PAE;
-#endif
-
-/* for MCA, but anyone else can use it if they want */
-unsigned int machine_id;
-unsigned int machine_submodel_id;
-unsigned int BIOS_revision;
-
-/* Boot loader ID as an integer, for the benefit of proc_dointvec */
-int bootloader_type;
-
-/*
- * Early DMI memory
- */
-int dmi_alloc_index;
-char dmi_alloc_data[DMI_MAX_DATA];
-
-/*
- * Setup options
- */
-struct screen_info screen_info;
-EXPORT_SYMBOL(screen_info);
-struct apm_info apm_info;
-EXPORT_SYMBOL(apm_info);
-struct edid_info edid_info;
-EXPORT_SYMBOL_GPL(edid_info);
-struct ist_info ist_info;
-#if defined(CONFIG_X86_SPEEDSTEP_SMI) || \
-	defined(CONFIG_X86_SPEEDSTEP_SMI_MODULE)
-EXPORT_SYMBOL(ist_info);
-#endif
-
-extern int root_mountflags;
-
-unsigned long saved_video_mode;
-
-#define RAMDISK_IMAGE_START_MASK	0x07FF
-#define RAMDISK_PROMPT_FLAG		0x8000
-#define RAMDISK_LOAD_FLAG		0x4000
-
-static char __initdata command_line[COMMAND_LINE_SIZE];
-
-#if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
-struct edd edd;
-#ifdef CONFIG_EDD_MODULE
-EXPORT_SYMBOL(edd);
-#endif
-/**
- * copy_edd() - Copy the BIOS EDD information
- *              from boot_params into a safe place.
- *
- */
-static inline void copy_edd(void)
-{
-     memcpy(edd.mbr_signature, boot_params.edd_mbr_sig_buffer,
-	    sizeof(edd.mbr_signature));
-     memcpy(edd.edd_info, boot_params.eddbuf, sizeof(edd.edd_info));
-     edd.mbr_signature_nr = boot_params.edd_mbr_sig_buf_entries;
-     edd.edd_info_nr = boot_params.eddbuf_entries;
-}
-#else
-static inline void copy_edd(void)
-{
-}
-#endif
-
-#ifdef CONFIG_BLK_DEV_INITRD
-
-static void __init relocate_initrd(void);
-
-static void __init reserve_initrd(void)
-{
-	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
-	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
-	u64 ramdisk_end   = ramdisk_image + ramdisk_size;
-	u64 end_of_lowmem = max_low_pfn << PAGE_SHIFT;
-	u64 ramdisk_here;
-
-	if (!boot_params.hdr.type_of_loader ||
-	    !ramdisk_image || !ramdisk_size)
-		return;		/* No initrd provided by bootloader */
-
-	initrd_start = 0;
-
-	if (ramdisk_size >= (end_of_lowmem>>1)) {
-		free_early(ramdisk_image, ramdisk_end);
-		printk(KERN_ERR "initrd too large to handle, "
-		       "disabling initrd\n");
-		return;
-	}
-
-	printk(KERN_INFO "old RAMDISK: %08llx - %08llx\n", ramdisk_image,
-			ramdisk_end);
-
-
-	if (ramdisk_end <= end_of_lowmem) {
-		/* All in lowmem, easy case */
-		/*
-		 * don't need to reserve again, already reserved early
-		 * in i386_start_kernel
-		 */
-		initrd_start = ramdisk_image + PAGE_OFFSET;
-		initrd_end = initrd_start + ramdisk_size;
-		return;
-	}
-
-	/* We need to move the initrd down into lowmem */
-	ramdisk_here = find_e820_area(0, end_of_lowmem, ramdisk_size,
-					 PAGE_SIZE);
-
-	if (ramdisk_here == -1ULL)
-		panic("Cannot find place for new RAMDISK of size %lld\n",
-			 ramdisk_size);
-
-	/* Note: this includes all the lowmem currently occupied by
-	   the initrd, we rely on that fact to keep the data intact. */
-	reserve_early(ramdisk_here, ramdisk_here + ramdisk_size,
-			 "NEW RAMDISK");
-	initrd_start = ramdisk_here + PAGE_OFFSET;
-	initrd_end   = initrd_start + ramdisk_size;
-	printk(KERN_INFO "Allocated new RAMDISK: %08llx - %08llx\n",
-			 ramdisk_here, ramdisk_here + ramdisk_size);
-
-	relocate_initrd();
-}
-
-#define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
-
-static void __init relocate_initrd(void)
-{
-	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
-	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
-	u64 end_of_lowmem = max_low_pfn << PAGE_SHIFT;
-	u64 ramdisk_here;
-	unsigned long slop, clen, mapaddr;
-	char *p, *q;
-
-	ramdisk_here = initrd_start - PAGE_OFFSET;
-
-	q = (char *)initrd_start;
-
-	/* Copy any lowmem portion of the initrd */
-	if (ramdisk_image < end_of_lowmem) {
-		clen = end_of_lowmem - ramdisk_image;
-		p = (char *)__va(ramdisk_image);
-		memcpy(q, p, clen);
-		q += clen;
-		ramdisk_image += clen;
-		ramdisk_size  -= clen;
-	}
-
-	/* Copy the highmem portion of the initrd */
-	while (ramdisk_size) {
-		slop = ramdisk_image & ~PAGE_MASK;
-		clen = ramdisk_size;
-		if (clen > MAX_MAP_CHUNK-slop)
-			clen = MAX_MAP_CHUNK-slop;
-		mapaddr = ramdisk_image & PAGE_MASK;
-		p = early_ioremap(mapaddr, clen+slop);
-		memcpy(q, p+slop, clen);
-		early_iounmap(p, clen+slop);
-		q += clen;
-		ramdisk_image += clen;
-		ramdisk_size  -= clen;
-	}
-	/* high pages is not converted by early_res_to_bootmem */
-	ramdisk_image = boot_params.hdr.ramdisk_image;
-	ramdisk_size  = boot_params.hdr.ramdisk_size;
-	printk(KERN_INFO "Copied RAMDISK from %016llx - %016llx to %08llx - %08llx\n",
-		ramdisk_image, ramdisk_image + ramdisk_size - 1,
-		ramdisk_here, ramdisk_here + ramdisk_size - 1);
-
-	/*
-	 * need to free old one, otherwise init cross max_low_pfn could be
-	 * converted to bootmem
-	 */
-	free_early(ramdisk_image, ramdisk_image+ramdisk_size);
-}
-#else
-void __init reserve_initrd(void)
-{
-}
-#endif /* CONFIG_BLK_DEV_INITRD */
-
-#ifdef CONFIG_MCA
-static void set_mca_bus(int x)
-{
-	MCA_bus = x;
-}
-#else
-static void set_mca_bus(int x) { }
-#endif
-
-/*
- * Determine if we were loaded by an EFI loader.  If so, then we have also been
- * passed the efi memmap, systab, etc., so we should use these data structures
- * for initialization.  Note, the efi init code path is determined by the
- * global efi_enabled. This allows the same kernel image to be used on existing
- * systems (with a traditional BIOS) as well as on EFI systems.
- */
-void __init setup_arch(char **cmdline_p)
-{
-	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
-	pre_setup_arch_hook();
-	early_cpu_init();
-	early_ioremap_init();
-	reserve_setup_data();
-
-	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
-	screen_info = boot_params.screen_info;
-	edid_info = boot_params.edid_info;
-	apm_info.bios = boot_params.apm_bios_info;
-	ist_info = boot_params.ist_info;
-	saved_video_mode = boot_params.hdr.vid_mode;
-	if( boot_params.sys_desc_table.length != 0 ) {
-		set_mca_bus(boot_params.sys_desc_table.table[3] & 0x2);
-		machine_id = boot_params.sys_desc_table.table[0];
-		machine_submodel_id = boot_params.sys_desc_table.table[1];
-		BIOS_revision = boot_params.sys_desc_table.table[2];
-	}
-	bootloader_type = boot_params.hdr.type_of_loader;
-
-#ifdef CONFIG_BLK_DEV_RAM
-	rd_image_start = boot_params.hdr.ram_size & RAMDISK_IMAGE_START_MASK;
-	rd_prompt = ((boot_params.hdr.ram_size & RAMDISK_PROMPT_FLAG) != 0);
-	rd_doload = ((boot_params.hdr.ram_size & RAMDISK_LOAD_FLAG) != 0);
-#endif
-#ifdef CONFIG_EFI
-	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-		     "EL32", 4)) {
-		efi_enabled = 1;
-		efi_reserve_early();
-	}
-#endif
-
-	ARCH_SETUP
-
-	setup_memory_map();
-	copy_edd();
-
-	if (!boot_params.hdr.root_flags)
-		root_mountflags &= ~MS_RDONLY;
-	init_mm.start_code = (unsigned long) _text;
-	init_mm.end_code = (unsigned long) _etext;
-	init_mm.end_data = (unsigned long) _edata;
-	init_mm.brk = init_pg_tables_end + PAGE_OFFSET;
-
-	code_resource.start = virt_to_phys(_text);
-	code_resource.end = virt_to_phys(_etext)-1;
-	data_resource.start = virt_to_phys(_etext);
-	data_resource.end = virt_to_phys(_edata)-1;
-	bss_resource.start = virt_to_phys(&__bss_start);
-	bss_resource.end = virt_to_phys(&__bss_stop)-1;
-
-	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
-	*cmdline_p = command_line;
-
-	parse_setup_data();
-
-	parse_early_param();
-
-	if (acpi_mps_check()){
-#ifdef CONFIG_X86_LOCAL_APIC
-		enable_local_apic = -1;
-#endif
-		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
-	}
-
-	finish_e820_parsing();
-
-	probe_roms();
-
-	/* after parse_early_param, so could debug it */
-	insert_resource(&iomem_resource, &code_resource);
-	insert_resource(&iomem_resource, &data_resource);
-	insert_resource(&iomem_resource, &bss_resource);
-
-	if (efi_enabled)
-		efi_init();
-
-	if (ppro_with_ram_bug()) {
-		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,
-				  E820_RESERVED);
-		sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
-		printk(KERN_INFO "fixed physical RAM map:\n");
-		e820_print_map("bad_ppro");
-	}
-
-	e820_register_active_regions(0, 0, -1UL);
-	/*
-	 * partially used pages are not usable - thus
-	 * we are rounding upwards:
-	 */
-	max_pfn = e820_end_of_ram();
-
-	/* preallocate 4k for mptable mpc */
-	early_reserve_e820_mpc_new();
-	/* update e820 for memory not covered by WB MTRRs */
-	mtrr_bp_init();
-	if (mtrr_trim_uncached_memory(max_pfn)) {
-		remove_all_active_ranges();
-		e820_register_active_regions(0, 0, -1UL);
-		max_pfn = e820_end_of_ram();
-	}
-
-	/* max_low_pfn get updated here */
-	find_low_pfn_range();
-
-	/* max_pfn_mapped is updated here */
-	init_memory_mapping(0, (max_low_pfn << PAGE_SHIFT));
-
-	reserve_initrd();
-
-	dmi_scan_machine();
-
-	io_delay_init();
-
-	/*
-	 * Parse the ACPI tables for possible boot-time SMP configuration.
-	 */
-	acpi_boot_table_init();
-
-#ifdef CONFIG_ACPI_NUMA
-        /*
-         * Parse SRAT to discover nodes.
-         */
-        acpi_numa_init();
-#endif
-
-	initmem_init(0, max_pfn);
-
-#ifdef CONFIG_ACPI_SLEEP
-	/*
-	 * Reserve low memory region for sleep support.
-	 */
-	acpi_reserve_bootmem();
-#endif
-#ifdef CONFIG_X86_FIND_SMP_CONFIG
-	/*
-	 * Find and reserve possible boot-time SMP configuration:
-	 */
-	find_smp_config();
-#endif
-	reserve_crashkernel();
-
-	reserve_ibft_region();
-
-#ifdef CONFIG_KVM_CLOCK
-	kvmclock_init();
-#endif
-
-#ifdef CONFIG_VMI
-	/*
-	 * Must be after max_low_pfn is determined, and before kernel
-	 * pagetables are setup.
-	 */
-	vmi_init();
-#endif
-	/*
-	 * NOTE: before this point _nobody_ is allowed to allocate
-	 * any memory using the bootmem allocator.  Although the
-	 * allocator is now initialised only the first 8Mb of the kernel
-	 * virtual address space has been mapped.  All allocations before
-	 * paging_init() has completed must use the alloc_bootmem_low_pages()
-	 * variant (which allocates DMA'able memory) and care must be taken
-	 * not to exceed the 8Mb limit.
-	 */
-
-	paging_init();
-
-	/*
-	 * NOTE: On x86-32, only from this point on, fixmaps are ready for use.
-	 */
-
-#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
-	if (init_ohci1394_dma_early)
-		init_ohci1394_dma_on_all_controllers();
-#endif
-
-#ifdef CONFIG_X86_GENERICARCH
-	generic_apic_probe();
-#endif
-
-	early_quirks();
-
-	/*
-	 * Read APIC and some other early information from ACPI tables.
-	 */
-	acpi_boot_init();
-
-#if defined(CONFIG_X86_MPPARSE) || defined(CONFIG_X86_VISWS)
-	/*
-	 * get boot-time SMP configuration:
-	 */
-	if (smp_found_config)
-		get_smp_config();
-#endif
-#if defined(CONFIG_SMP) && defined(CONFIG_X86_PC)
-	if (def_to_bigsmp)
-		printk(KERN_WARNING "More than 8 CPUs detected and "
-			"CONFIG_X86_PC cannot handle it.\nUse "
-			"CONFIG_X86_GENERICARCH or CONFIG_X86_BIGSMP.\n");
-#endif
-	kvm_guest_init();
-
-	e820_reserve_resources();
-	e820_mark_nosave_regions(max_low_pfn);
-
-	request_resource(&iomem_resource, &video_ram_resource);
-	reserve_standard_io_resources();
-
-	e820_setup_gap();
-
-#ifdef CONFIG_VT
-#if defined(CONFIG_VGA_CONSOLE)
-	if (!efi_enabled || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY))
-		conswitchp = &vga_con;
-#elif defined(CONFIG_DUMMY_CONSOLE)
-	conswitchp = &dummy_con;
-#endif
-#endif
-}
-
