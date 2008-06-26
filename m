Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbYFZBD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbYFZBD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbYFZBBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:01:44 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:20470 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbYFZBBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:01:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=OVuD0POkQ/9SUSI9JjFuZpWJiDe3uhspmvKQflbSThFErl25YTk2ehJfOXyfShDrmT
         8NWNX0i55f/UZ5HNbFbCrH16PHeeJnikTb/XQZj5AGXT0L3+mZpy8UumRJGtxxvje1Gy
         HpoVBa/bz5Ptu2HgwRihVhxWr+XXwPK/r3C2g=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 06/16] x86: merge 64bit setup_arch into setup_32
Date: Wed, 25 Jun 2008 17:52:35 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com>
In-Reply-To: <200806251748.06743.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251752.35271.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -372,26 +372,38 @@ static void __init reserve_initrd(void)
  * global efi_enabled. This allows the same kernel image to be used on existing
  * systems (with a traditional BIOS) as well as on EFI systems.
  */
+/*
+ * setup_arch - architecture-specific boot-time initializations
+ *
+ * Note: On x86_64, fixmaps are ready for use even before this is called.
+ */
+
 void __init setup_arch(char **cmdline_p)
 {
+#ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	pre_setup_arch_hook();
 	early_cpu_init();
 	early_ioremap_init();
 	reserve_setup_data();
+#else
+	printk(KERN_INFO "Command line: %s\n", boot_command_line);
+#endif
 
 	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
 	screen_info = boot_params.screen_info;
 	edid_info = boot_params.edid_info;
+#ifdef CONFIG_X86_32
 	apm_info.bios = boot_params.apm_bios_info;
 	ist_info = boot_params.ist_info;
-	saved_video_mode = boot_params.hdr.vid_mode;
-	if( boot_params.sys_desc_table.length != 0 ) {
+	if (boot_params.sys_desc_table.length != 0) {
 		set_mca_bus(boot_params.sys_desc_table.table[3] & 0x2);
 		machine_id = boot_params.sys_desc_table.table[0];
 		machine_submodel_id = boot_params.sys_desc_table.table[1];
 		BIOS_revision = boot_params.sys_desc_table.table[2];
 	}
+#endif
+	saved_video_mode = boot_params.hdr.vid_mode;
 	bootloader_type = boot_params.hdr.type_of_loader;
 
 #ifdef CONFIG_BLK_DEV_RAM
@@ -401,7 +413,12 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #ifdef CONFIG_EFI
 	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-		     "EL32", 4)) {
+#ifdef CONFIG_X86_32
+		     "EL32",
+#else
+		     "EL64",
+#endif
+	 4)) {
 		efi_enabled = 1;
 		efi_reserve_early();
 	}
@@ -417,7 +434,11 @@ void __init setup_arch(char **cmdline_p)
 	init_mm.start_code = (unsigned long) _text;
 	init_mm.end_code = (unsigned long) _etext;
 	init_mm.end_data = (unsigned long) _edata;
+#ifdef CONFIG_X86_32
 	init_mm.brk = init_pg_tables_end + PAGE_OFFSET;
+#else
+	init_mm.brk = (unsigned long) &_end;
+#endif
 
 	code_resource.start = virt_to_phys(_text);
 	code_resource.end = virt_to_phys(_etext)-1;
@@ -426,6 +447,9 @@ void __init setup_arch(char **cmdline_p)
 	bss_resource.start = virt_to_phys(&__bss_start);
 	bss_resource.end = virt_to_phys(&__bss_stop)-1;
 
+#ifdef CONFIG_X86_64
+	early_cpu_init();
+#endif
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
@@ -433,16 +457,27 @@ void __init setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
-	if (acpi_mps_check()){
+	if (acpi_mps_check()) {
 #ifdef CONFIG_X86_LOCAL_APIC
+#ifdef CONFIG_X86_32
 		enable_local_apic = -1;
+#else
+		disable_apic = 1;
+#endif
 #endif
 		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 	}
 
 	finish_e820_parsing();
 
+#ifdef CONFIG_X86_32
 	probe_roms();
+#else
+# ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
+	if (init_ohci1394_dma_early)
+		init_ohci1394_dma_on_all_controllers();
+# endif
+#endif
 
 	/* after parse_early_param, so could debug it */
 	insert_resource(&iomem_resource, &code_resource);
@@ -452,6 +487,7 @@ void __init setup_arch(char **cmdline_p)
 	if (efi_enabled)
 		efi_init();
 
+#ifdef CONFIG_X86_32
 	if (ppro_with_ram_bug()) {
 		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,
 				  E820_RESERVED);
@@ -459,6 +495,9 @@ void __init setup_arch(char **cmdline_p)
 		printk(KERN_INFO "fixed physical RAM map:\n");
 		e820_print_map("bad_ppro");
 	}
+#else
+	early_gart_iommu_check();
+#endif
 
 	e820_register_active_regions(0, 0, -1UL);
 	/*
@@ -477,14 +516,32 @@ void __init setup_arch(char **cmdline_p)
 		max_pfn = e820_end_of_ram();
 	}
 
+#ifdef CONFIG_X86_32
 	/* max_low_pfn get updated here */
 	find_low_pfn_range();
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
 
 	/* max_pfn_mapped is updated here */
+#ifdef CONFIG_X86_64
+	max_pfn_mapped =
+#endif
 	init_memory_mapping(0, (max_low_pfn << PAGE_SHIFT));
 
 	reserve_initrd();
 
+#ifdef CONFIG_X86_64
+	vsmp_init();
+#endif
+
 	dmi_scan_machine();
 
 	io_delay_init();
@@ -494,6 +551,11 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	acpi_boot_table_init();
 
+#ifdef CONFIG_X86_64
+	/* Remove active ranges so rediscovery with NUMA-awareness happens */
+	remove_all_active_ranges();
+#endif
+
 #ifdef CONFIG_ACPI_NUMA
         /*
          * Parse SRAT to discover nodes.
@@ -503,13 +565,18 @@ void __init setup_arch(char **cmdline_p)
 
 	initmem_init(0, max_pfn);
 
+#ifdef CONFIG_X86_64
+	dma32_reserve_bootmem();
+#endif
+
 #ifdef CONFIG_ACPI_SLEEP
 	/*
 	 * Reserve low memory region for sleep support.
 	 */
 	acpi_reserve_bootmem();
 #endif
-#ifdef CONFIG_X86_FIND_SMP_CONFIG
+#if defined(CONFIG_X86_FIND_SMP_CONFIG) && defined(CONFIG_X86_32) || \
+    defined(CONFIG_X86_MPPARSE) && defined(CONFIG_X86_64)
 	/*
 	 * Find and reserve possible boot-time SMP configuration:
 	 */
@@ -523,7 +590,7 @@ void __init setup_arch(char **cmdline_p)
 	kvmclock_init();
 #endif
 
-#ifdef CONFIG_VMI
+#if defined(CONFIG_VMI) && defined(CONFIG_X86_32)
 	/*
 	 * Must be after max_low_pfn is determined, and before kernel
 	 * pagetables are setup.
@@ -533,11 +600,15 @@ void __init setup_arch(char **cmdline_p)
 
 	paging_init();
 
+#ifdef CONFIG_X86_64
+	map_vsyscall();
+#endif
+
 	/*
 	 * NOTE: On x86-32, only from this point on, fixmaps are ready for use.
 	 */
 
-#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
+#if defined(CONFIG_PROVIDE_OHCI1394_DMA_INIT) && defined(CONFIG_X86_32)
 	if (init_ohci1394_dma_early)
 		init_ohci1394_dma_on_all_controllers();
 #endif
@@ -553,6 +624,10 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	acpi_boot_init();
 
+#ifdef CONFIG_X86_64
+	init_cpu_to_node();
+#endif
+
 #if defined(CONFIG_X86_MPPARSE) || defined(CONFIG_X86_VISWS)
 	/*
 	 * get boot-time SMP configuration:
@@ -560,18 +635,26 @@ void __init setup_arch(char **cmdline_p)
 	if (smp_found_config)
 		get_smp_config();
 #endif
-#if defined(CONFIG_SMP) && defined(CONFIG_X86_PC)
+
+#ifdef CONFIG_X86_64
+	init_apic_mappings();
+	ioapic_init_mappings();
+#else
+# if defined(CONFIG_SMP) && defined(CONFIG_X86_PC)
 	if (def_to_bigsmp)
 		printk(KERN_WARNING "More than 8 CPUs detected and "
 			"CONFIG_X86_PC cannot handle it.\nUse "
 			"CONFIG_X86_GENERICARCH or CONFIG_X86_BIGSMP.\n");
+# endif
 #endif
 	kvm_guest_init();
 
 	e820_reserve_resources();
 	e820_mark_nosave_regions(max_low_pfn);
 
+#ifdef CONFIG_X86_32
 	request_resource(&iomem_resource, &video_ram_resource);
+#endif
 	reserve_standard_io_resources();
 
 	e820_setup_gap();
