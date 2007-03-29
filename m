Return-Path: <linux-kernel-owner+w=401wt.eu-S1750948AbXC2H51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948AbXC2H51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 03:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXC2H51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 03:57:27 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:36792
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948AbXC2H50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 03:57:26 -0400
Message-Id: <460B8DA8.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Thu, 29 Mar 2007 08:58:00 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Cc: <mark.langsdorf@amd.com>
Subject: [PATCH] fix amd64-agp aperture validation
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Under CONFIG_DISCONTIGMEM, assuming that a !pfn_valid() implies all
subsequent pfn-s are also invalid is wrong. Thus replace this by
explicitly checking against the E820 map.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Mark Langsdorf <mark.langsdorf@amd.com>

--- linux-2.6.21-rc5/arch/i386/kernel/e820.c	2007-03-26 15:20:01.000000000 +0200
+++ 2.6.21-rc5-amd64-agp/arch/i386/kernel/e820.c	2007-03-28 15:32:24.000000000 +0200
@@ -818,6 +818,26 @@ void __init limit_regions(unsigned long 
 	print_memory_map("limit_regions endfunc");
 }
 
+/*
+ * This function checks if any part of the range <start,end> is mapped
+ * with type.
+ */
+int
+e820_any_mapped(u64 start, u64 end, unsigned type)
+{
+	int i;
+	for (i = 0; i < e820.nr_map; i++) {
+		const struct e820entry *ei = &e820.map[i];
+		if (type && ei->type != type)
+			continue;
+		if (ei->addr >= end || ei->addr + ei->size <= start)
+			continue;
+		return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(e820_any_mapped);
+
  /*
   * This function checks if the entire range <start,end> is mapped with type.
   *
--- linux-2.6.21-rc5/arch/x86_64/kernel/e820.c	2007-03-26 15:20:12.000000000 +0200
+++ 2.6.21-rc5-amd64-agp/arch/x86_64/kernel/e820.c	2007-03-28 15:26:08.000000000 +0200
@@ -98,7 +98,7 @@ static inline int bad_addr(unsigned long
  * This function checks if any part of the range <start,end> is mapped
  * with type.
  */
-int __meminit
+int
 e820_any_mapped(unsigned long start, unsigned long end, unsigned type)
 { 
 	int i;
@@ -112,6 +112,7 @@ e820_any_mapped(unsigned long start, uns
 	} 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(e820_any_mapped);
 
 /*
  * This function checks if the entire range <start,end> is mapped with type.
--- linux-2.6.21-rc5/drivers/char/agp/amd64-agp.c	2007-03-26 15:20:14.000000000 +0200
+++ 2.6.21-rc5-amd64-agp/drivers/char/agp/amd64-agp.c	2007-03-28 15:20:49.000000000 +0200
@@ -14,6 +14,7 @@
 #include <linux/agp_backend.h>
 #include <linux/mmzone.h>
 #include <asm/page.h>		/* PAGE_SIZE */
+#include <asm/e820.h>
 #include <asm/k8.h>
 #include "agp.h"
 
@@ -259,7 +260,6 @@ static const struct agp_bridge_driver am
 /* Some basic sanity checks for the aperture. */
 static int __devinit aperture_valid(u64 aper, u32 size)
 {
-	u32 pfn, c;
 	if (aper == 0) {
 		printk(KERN_ERR PFX "No aperture\n");
 		return 0;
@@ -272,14 +272,9 @@ static int __devinit aperture_valid(u64 
 		printk(KERN_ERR PFX "Aperture out of bounds\n");
 		return 0;
 	}
-	pfn = aper >> PAGE_SHIFT;
-	for (c = 0; c < size/PAGE_SIZE; c++) {
-		if (!pfn_valid(pfn + c))
-			break;
-		if (!PageReserved(pfn_to_page(pfn + c))) {
-			printk(KERN_ERR PFX "Aperture pointing to RAM\n");
-			return 0;
-		}
+	if (e820_any_mapped(aper, aper + size, E820_RAM)) {
+		printk(KERN_ERR PFX "Aperture pointing to RAM\n");
+		return 0;
 	}
 
 	/* Request the Aperture. This catches cases when someone else
--- linux-2.6.21-rc5/include/asm-i386/e820.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-amd64-agp/include/asm-i386/e820.h	2007-03-28 15:21:47.000000000 +0200
@@ -38,6 +38,7 @@ extern struct e820map e820;
 
 extern int e820_all_mapped(unsigned long start, unsigned long end,
 			   unsigned type);
+extern int e820_any_mapped(u64 start, u64 end, unsigned type);
 extern void find_max_pfn(void);
 extern void register_bootmem_low_pages(unsigned long max_low_pfn);
 extern void e820_register_memory(void);


