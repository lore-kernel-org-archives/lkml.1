Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbYAHFIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbYAHFIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 00:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbYAHFIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 00:08:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48476 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbYAHFI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 00:08:29 -0500
Date: Mon, 7 Jan 2008 21:02:53 -0800
Message-Id: <200801080502.m0852rhW017142@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixer <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, vgoyal@redhat.com,
       hbabu@us.ibm.com, kexec@lists.infradead.org
Subject: [PATCH] i386: handle an initrd in highmem (version 2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The boot protocol has until now required that the initrd be located in
lowmem, which makes the lowmem/highmem boundary visible to the boot
loader.  This was exported to the bootloader via a compile-time
field.  Unfortunately, the vmalloc= command-line option breaks this
part of the protocol; instead of adding yet another hack that affects
the bootloader, have the kernel relocate the initrd down below the
lowmem boundary inside the kernel itself.

Note that this does not rely on HIGHMEM being enabled in the kernel.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
Fix crash on NUMA reported by Dhaval Giani (reported as being a kexec issue.)

 arch/x86/boot/header.S     |    5 ++-
 arch/x86/kernel/setup_32.c |  128 ++++++++++++++++++++++++++++++++++++--------
 arch/x86/mm/discontig_32.c |    4 +-
 3 files changed, 111 insertions(+), 26 deletions(-)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 4cc5b04..64ad901 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -195,10 +195,13 @@ cmd_line_ptr:	.long	0		# (Header version 0x0202 or later)
 					# can be located anywhere in
 					# low memory 0x10000 or higher.
 
-ramdisk_max:	.long (-__PAGE_OFFSET-(512 << 20)-1) & 0x7fffffff
+ramdisk_max:	.long 0x7fffffff
 					# (Header version 0x0203 or later)
 					# The highest safe address for
 					# the contents of an initrd
+					# The current kernel allows up to 4 GB,
+					# but leave it at 2 GB to avoid
+					# possible bootloader bugs.
 
 kernel_alignment:  .long CONFIG_PHYSICAL_ALIGN	#physical addr alignment
 						#required for protected mode
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index 9c24b45..8a8b13d 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -116,9 +116,9 @@ extern int root_mountflags;
 
 unsigned long saved_videomode;
 
-#define RAMDISK_IMAGE_START_MASK  	0x07FF
+#define RAMDISK_IMAGE_START_MASK	0x07FF
 #define RAMDISK_PROMPT_FLAG		0x8000
-#define RAMDISK_LOAD_FLAG		0x4000	
+#define RAMDISK_LOAD_FLAG		0x4000
 
 static char __initdata command_line[COMMAND_LINE_SIZE];
 
@@ -176,7 +176,7 @@ static int __init parse_mem(char *arg)
 		 * trim the existing memory map.
 		 */
 		unsigned long long mem_size;
- 
+
 		mem_size = memparse(arg, &arg);
 		limit_regions(mem_size);
 		user_defined_memmap = 1;
@@ -315,7 +315,7 @@ static void __init reserve_ebda_region(void)
 	unsigned int addr;
 	addr = get_bios_ebda();
 	if (addr)
-		reserve_bootmem(addr, PAGE_SIZE);	
+		reserve_bootmem(addr, PAGE_SIZE);
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
@@ -420,6 +420,100 @@ static inline void __init reserve_crashkernel(void)
 {}
 #endif
 
+#ifdef CONFIG_BLK_DEV_INITRD
+
+static bool do_relocate_initrd = false;
+
+static void __init reserve_initrd(void)
+{
+	unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
+	unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
+	unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
+	unsigned long end_of_lowmem = max_low_pfn << PAGE_SHIFT;
+	unsigned long ramdisk_here;
+
+	initrd_start = 0;
+
+	if (!boot_params.hdr.type_of_loader ||
+	    !ramdisk_image || !ramdisk_size)
+		return;		/* No initrd provided by bootloader */
+
+	if (ramdisk_end < ramdisk_image) {
+		printk(KERN_ERR "initrd wraps around end of memory, "
+		       "disabling initrd\n");
+		return;
+	}
+	if (ramdisk_size >= end_of_lowmem/2) {
+		printk(KERN_ERR "initrd too large to handle, "
+		       "disabling initrd\n");
+		return;
+	}
+	if (ramdisk_end <= end_of_lowmem) {
+		/* All in lowmem, easy case */
+		reserve_bootmem(ramdisk_image, ramdisk_size);
+		initrd_start = ramdisk_image + PAGE_OFFSET;
+		initrd_end = initrd_start+ramdisk_size;
+		return;
+	}
+
+	/* We need to move the initrd down into lowmem */
+	ramdisk_here = (end_of_lowmem - ramdisk_size) & PAGE_MASK;
+
+	/* Note: this includes all the lowmem currently occupied by
+	   the initrd, we rely on that fact to keep the data intact. */
+	reserve_bootmem(ramdisk_here, ramdisk_size);
+	initrd_start = ramdisk_here + PAGE_OFFSET;
+	initrd_end   = initrd_start + ramdisk_size;
+
+	do_relocate_initrd = true;
+}
+
+#define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
+
+static void __init relocate_initrd(void)
+{
+	unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
+	unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
+	unsigned long end_of_lowmem = max_low_pfn << PAGE_SHIFT;
+	unsigned long ramdisk_here;
+	unsigned long slop, clen, mapaddr;
+	char *p, *q;
+
+	if (!do_relocate_initrd)
+		return;
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
+		p = bt_ioremap(mapaddr, clen+slop);
+		memcpy(q, p+slop, clen);
+		bt_iounmap(p, clen+slop);
+		q += clen;
+		ramdisk_image += clen;
+		ramdisk_size  -= clen;
+	}
+}
+
+#endif /* CONFIG_BLK_DEV_INITRD */
+
 void __init setup_bootmem_allocator(void)
 {
 	unsigned long bootmap_size;
@@ -475,26 +569,10 @@ void __init setup_bootmem_allocator(void)
 	 */
 	find_smp_config();
 #endif
-	numa_kva_reserve();
 #ifdef CONFIG_BLK_DEV_INITRD
-	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
-		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
-		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
-		unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
-		unsigned long end_of_lowmem = max_low_pfn << PAGE_SHIFT;
-
-		if (ramdisk_end <= end_of_lowmem) {
-			reserve_bootmem(ramdisk_image, ramdisk_size);
-			initrd_start = ramdisk_image + PAGE_OFFSET;
-			initrd_end = initrd_start+ramdisk_size;
-		} else {
-			printk(KERN_ERR "initrd extends beyond end of memory "
-			       "(0x%08lx > 0x%08lx)\ndisabling initrd\n",
-			       ramdisk_end, end_of_lowmem);
-			initrd_start = 0;
-		}
-	}
+	reserve_initrd();
 #endif
+	numa_kva_reserve();
 	reserve_crashkernel();
 }
 
@@ -644,13 +722,17 @@ void __init setup_arch(char **cmdline_p)
 	 * NOTE: at this point the bootmem allocator is fully available.
 	 */
 
+#ifdef CONFIG_BLK_DEV_INITRD
+	relocate_initrd();
+#endif
+
 	paravirt_post_allocator_init();
 
 	dmi_scan_machine();
 
 #ifdef CONFIG_X86_GENERICARCH
 	generic_apic_probe();
-#endif	
+#endif
 	if (efi_enabled)
 		efi_map_memmap();
 
diff --git a/arch/x86/mm/discontig_32.c b/arch/x86/mm/discontig_32.c
index 13a474d..88a7499 100644
--- a/arch/x86/mm/discontig_32.c
+++ b/arch/x86/mm/discontig_32.c
@@ -288,8 +288,8 @@ unsigned long __init setup_memory(void)
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Numa kva area is below the initrd */
-	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image)
-		kva_start_pfn = PFN_DOWN(boot_params.hdr.ramdisk_image)
+	if (initrd_start)
+		kva_start_pfn = PFN_DOWN(initrd_start - PAGE_OFFSET)
 			- kva_pages;
 #endif
 	kva_start_pfn -= kva_start_pfn & (PTRS_PER_PTE-1);
-- 
1.5.3.6

