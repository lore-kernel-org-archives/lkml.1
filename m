Return-Path: <linux-kernel-owner+w=401wt.eu-S935960AbYBWA6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935960AbYBWA6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYBWA6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:58:44 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42488 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYBWA6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:58:42 -0500
Date: Fri, 22 Feb 2008 17:07:16 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: clean up e820_reserve_resources
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802221707.17164.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


e820_resource_resources could use insert_resource instead of request_resource
also move code_resource, data_resource, bss_resource, and crashk_res
out of e820_reserve_resources.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6/arch/x86/kernel/e820_64.c
@@ -229,8 +229,7 @@ unsigned long __init e820_end_of_ram(voi
 /*
  * Mark e820 reserved areas as busy for the resource manager.
  */
-void __init e820_reserve_resources(struct resource *code_resource,
-		struct resource *data_resource, struct resource *bss_resource)
+void __init e820_reserve_resources(void)
 {
 	int i;
 	for (i = 0; i < e820.nr_map; i++) {
@@ -245,21 +244,7 @@ void __init e820_reserve_resources(struc
 		res->start = e820.map[i].addr;
 		res->end = res->start + e820.map[i].size - 1;
 		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-		request_resource(&iomem_resource, res);
-		if (e820.map[i].type == E820_RAM) {
-			/*
-			 * We don't know which RAM region contains kernel data,
-			 * so we try it repeatedly and let the resource manager
-			 * test it.
-			 */
-			request_resource(res, code_resource);
-			request_resource(res, data_resource);
-			request_resource(res, bss_resource);
-#ifdef CONFIG_KEXEC
-			if (crashk_res.start != crashk_res.end)
-				request_resource(res, &crashk_res);
-#endif
-		}
+		insert_resource(&iomem_resource, res);
 	}
 }
 
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -250,6 +250,7 @@ static void __init reserve_crashkernel(v
 				(unsigned long)(total_mem >> 20));
 		crashk_res.start = crash_base;
 		crashk_res.end   = crash_base + crash_size - 1;
+		insert_resource(&iomem_resource, &crashk_res);
 	}
 }
 #else
@@ -324,6 +325,11 @@ void __init setup_arch(char **cmdline_p)
 
 	finish_e820_parsing();
 
+	/* after parse_early_param, so could debug it */
+	insert_resource(&iomem_resource, &code_resource);
+	insert_resource(&iomem_resource, &data_resource);
+	insert_resource(&iomem_resource, &bss_resource);
+
 	early_gart_iommu_check();
 
 	e820_register_active_regions(0, 0, -1UL);
@@ -456,7 +462,7 @@ void __init setup_arch(char **cmdline_p)
 	/*
 	 * We trust e820 completely. No explicit ROM probing in memory.
 	 */
-	e820_reserve_resources(&code_resource, &data_resource, &bss_resource);
+	e820_reserve_resources();
 	e820_mark_nosave_regions();
 
 	/* request I/O space for devices used on all i[345]86 PCs */
Index: linux-2.6/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_64.h
+++ linux-2.6/include/asm-x86/e820_64.h
@@ -21,8 +21,7 @@ extern void add_memory_region(unsigned l
 extern void setup_memory_region(void);
 extern void contig_e820_setup(void); 
 extern unsigned long e820_end_of_ram(void);
-extern void e820_reserve_resources(struct resource *code_resource,
-		struct resource *data_resource, struct resource *bss_resource);
+extern void e820_reserve_resources(void);
 extern void e820_mark_nosave_regions(void);
 extern int e820_any_mapped(unsigned long start, unsigned long end, unsigned type);
 extern int e820_all_mapped(unsigned long start, unsigned long end, unsigned type);
