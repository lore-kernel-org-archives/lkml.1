Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbZEQMoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbZEQMoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 08:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZEQMoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 08:44:09 -0400
Received: from ru.mvista.com ([213.79.90.228]:25911 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750906AbZEQMoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 08:44:07 -0400
Message-ID: <4A103EDF.7050108@ru.mvista.com>
Date: Sun, 17 May 2009 20:44:15 +0400
From: Konstantin Baydarov <kbaidarov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [PowerPC] Support For Initrd Loaded Into Highmem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello.

  Recently I faced following issue:
On PPC targets with uBoot monitor with RAM size more than 768 Mb, boot with
initrd(rootfs image that is loaded separately from uImage) fails. Kernel crashes very early. 

  It turned out that:
PPC uBoot always loads initrd image at the highest RAM address. So if board has
sufficient amount of RAM initrd will be loaded at highmem, at address that is
bigger than CONFIG_LOWMEM_SIZE=0x30000000. Kernel cannot work with highmem
addresses directly, ioremap is required. So initrd relocation to lowmem is
required to make kernel work correctly with initrd.

Also if initrd is in the highmem, uBoot adds initrd highmem region into the
initial_boot_params->off_mem_rsvmap. This leads to kernel crash, because kernel
assumes that regions from the initial_boot_params->off_mem_rsvmap are in the
lowmem. 

  How Solved:
Code was added that checks if initrd is in the highmem and relocates initrd
into lowmem if required.

Also if initrd is in the highmem, uBoot adds initrd highmem region into the
initial_boot_params->off_mem_rsvmap. This leads to kernel crash, because kernel
assumes that regions from the initial_boot_params->off_mem_rsvmap are in the
lowmem. So patch skips initrd highmem region when kernel reserves lowmem regions
in early_reserve_mem().

  This patch is for linux-2.6.30-rc6.

Signed-off-by: Konstantin Baydarov <kbaidarov@ru.mvista.com>

Index: linux-2.6.30-rc6/arch/powerpc/kernel/prom.c
===================================================================
--- linux-2.6.30-rc6.orig/arch/powerpc/kernel/prom.c
+++ linux-2.6.30-rc6/arch/powerpc/kernel/prom.c
@@ -763,28 +763,56 @@ static int __init early_init_dt_scan_cpu
 	return 0;
 }
 
+unsigned long orig_initrd_start, orig_initrd_end;
+int need_reloc_initrd = 0;
+static int need_to_fix_reserve_map = 0;
 #ifdef CONFIG_BLK_DEV_INITRD
 static void __init early_init_dt_check_for_initrd(unsigned long node)
 {
-	unsigned long l;
+	unsigned long l, initrd_size;
 	u32 *prop;
 
 	DBG("Looking for initrd properties... ");
 
+	initrd_start = 0;
+	initrd_end = 0;
 	prop = of_get_flat_dt_prop(node, "linux,initrd-start", &l);
-	if (prop) {
-		initrd_start = (unsigned long)__va(of_read_ulong(prop, l/4));
+	if (!prop)
+		return;
 
-		prop = of_get_flat_dt_prop(node, "linux,initrd-end", &l);
-		if (prop) {
-			initrd_end = (unsigned long)
-					__va(of_read_ulong(prop, l/4));
-			initrd_below_start_ok = 1;
-		} else {
-			initrd_start = 0;
-		}
-	}
+	orig_initrd_start = (unsigned long)(of_read_ulong(prop, l/4));
+	prop = of_get_flat_dt_prop(node, "linux,initrd-end", &l);
+	if (!prop)
+		return;
+
+	orig_initrd_end = (unsigned long)(of_read_ulong(prop, l/4));
+	initrd_below_start_ok = 1;
 
+#ifdef CONFIG_PPC32
+	need_to_fix_reserve_map = 1;
+	if (orig_initrd_end <= CONFIG_LOWMEM_SIZE) {
+		initrd_start = (unsigned long)__va(orig_initrd_start);
+		initrd_end = (unsigned long)__va(orig_initrd_end);
+		need_to_fix_reserve_map = 0;
+	}
+#ifdef CONFIG_HIGHMEM
+	else if (orig_initrd_start < CONFIG_LOWMEM_SIZE) {
+		/* TODO: add support for Initrd Image that is spread to
+		low and high mem */
+	} else {
+		/* Whole initrd is in highmem */
+		need_reloc_initrd = 1;
+		initrd_size = orig_initrd_end - orig_initrd_start;
+		initrd_start = CONFIG_LOWMEM_SIZE - initrd_size;
+		initrd_start &= PAGE_MASK;
+		initrd_start += KERNELBASE;
+		initrd_end = initrd_start + initrd_size;
+	}
+#endif
+#else
+	initrd_start = (unsigned long)__va(orig_initrd_start);
+	initrd_end = (unsigned long)__va(orig_initrd_end);
+#endif
 	DBG("initrd_start=0x%lx  initrd_end=0x%lx\n", initrd_start, initrd_end);
 }
 #else
@@ -1061,8 +1089,15 @@ static void __init early_reserve_mem(voi
 			/* skip if the reservation is for the blob */
 			if (base_32 == self_base && size_32 == self_size)
 				continue;
-			DBG("reserving: %x -> %x\n", base_32, size_32);
-			lmb_reserve(base_32, size_32);
+			/* Skip reserving initrd region if it's in highmem,
+			 * Because kernel assumes that regions are from lowmem.
+			 * Entry from high mem leads to kernel crash.
+			 */
+			if (!need_to_fix_reserve_map ||
+				(base_32 != orig_initrd_start)) {
+				DBG("reserving: %x -> %x\n", base_32, size_32);
+				lmb_reserve(base_32, size_32);
+			}
 		}
 		return;
 	}
@@ -1072,8 +1107,15 @@ static void __init early_reserve_mem(voi
 		size = *(reserve_map++);
 		if (size == 0)
 			break;
-		DBG("reserving: %llx -> %llx\n", base, size);
-		lmb_reserve(base, size);
+		/* Skip reserving initrd region if it's in highmem,
+		 * Because kernel assumes that regions are from lowmem.
+		 * Entry from high mem leads to kernel crash.
+		 */
+		if (!need_to_fix_reserve_map ||
+			(base != orig_initrd_start)) {
+			DBG("reserving: %llx -> %llx\n", base, size);
+			lmb_reserve(base, size);
+		}
 	}
 }
 
Index: linux-2.6.30-rc6/arch/powerpc/kernel/setup-common.c
===================================================================
--- linux-2.6.30-rc6.orig/arch/powerpc/kernel/setup-common.c
+++ linux-2.6.30-rc6/arch/powerpc/kernel/setup-common.c
@@ -335,6 +335,46 @@ struct seq_operations cpuinfo_op = {
 	.show =	show_cpuinfo,
 };
 
+#if defined (CONFIG_BLK_DEV_INITRD) && (CONFIG_PPC32)
+extern unsigned long orig_initrd_start, orig_initrd_end;
+extern int need_reloc_initrd;
+
+/**
+ * relocate_initrd - if initrd is loaded into highmem, relocate it
+ * to lowmem.
+ */
+static void relocate_initrd(void)
+{
+	unsigned long src = orig_initrd_start;
+	unsigned long size = orig_initrd_end - orig_initrd_start;
+	char *src_ptr;
+	char *dest = (char *) initrd_start;
+
+	if (!need_reloc_initrd)
+		return;
+
+	/* Map the physical address in and copy the
+	 * data from it, in page-size chunks. */
+	while (size) {
+		src_ptr = ioremap(src, PAGE_SIZE);
+		if (src_ptr) {
+			int amount_to_copy = min(size, PAGE_SIZE);
+			memcpy(dest, src_ptr, amount_to_copy);
+			iounmap(src_ptr);
+			src += amount_to_copy;
+			dest += amount_to_copy;
+			size -= amount_to_copy;
+		} else {
+			printk(KERN_CRIT
+			       "Can't map memory to copy ramdisk\n");
+			break;
+		}
+	}
+}
+#elif defined (CONFIG_BLK_DEV_INITRD)
+#define relocate_initrd()
+#endif
+
 void __init check_for_initrd(void)
 {
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -345,9 +385,10 @@ void __init check_for_initrd(void)
 	 * look sensible. If not, clear initrd reference.
 	 */
 	if (is_kernel_addr(initrd_start) && is_kernel_addr(initrd_end) &&
-	    initrd_end > initrd_start)
+	    initrd_end > initrd_start) {
+		relocate_initrd();
 		ROOT_DEV = Root_RAM0;
-	else
+	} else
 		initrd_start = initrd_end = 0;
 
 	if (initrd_start)
