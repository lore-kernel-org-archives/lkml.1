Return-Path: <linux-kernel-owner+w=401wt.eu-S1161613AbXD2XvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161613AbXD2XvG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161607AbXD2XvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:51:00 -0400
Received: from ns1.suse.de ([195.135.220.2]:41926 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161578AbXD2XqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:16 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: "Jan Beulich" <jbeulich@novell.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [6/26] x86: fix amd64-agp aperture validation
Message-Id: <20070429234615.1B9EB151D2@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
Under CONFIG_DISCONTIGMEM, assuming that a !pfn_valid() implies all
subsequent pfn-s are also invalid is wrong. Thus replace this by
explicitly checking against the E820 map.

AK: make e820 on x86-64 not initdata

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Mark Langsdorf <mark.langsdorf@amd.com>

---
 arch/i386/kernel/e820.c      |   20 ++++++++++++++++++++
 arch/x86_64/kernel/e820.c    |    5 +++--
 drivers/char/agp/amd64-agp.c |   13 ++++---------
 include/asm-i386/e820.h      |    1 +
 4 files changed, 28 insertions(+), 11 deletions(-)

Index: linux/arch/i386/kernel/e820.c
===================================================================
--- linux.orig/arch/i386/kernel/e820.c
+++ linux/arch/i386/kernel/e820.c
@@ -825,6 +825,26 @@ void __init limit_regions(unsigned long 
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
Index: linux/arch/x86_64/kernel/e820.c
===================================================================
--- linux.orig/arch/x86_64/kernel/e820.c
+++ linux/arch/x86_64/kernel/e820.c
@@ -25,7 +25,7 @@
 #include <asm/bootsetup.h>
 #include <asm/sections.h>
 
-struct e820map e820 __initdata;
+struct e820map e820;
 
 /* 
  * PFN of last memory page.
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
Index: linux/drivers/char/agp/amd64-agp.c
===================================================================
--- linux.orig/drivers/char/agp/amd64-agp.c
+++ linux/drivers/char/agp/amd64-agp.c
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
Index: linux/include/asm-i386/e820.h
===================================================================
--- linux.orig/include/asm-i386/e820.h
+++ linux/include/asm-i386/e820.h
@@ -38,6 +38,7 @@ extern struct e820map e820;
 
 extern int e820_all_mapped(unsigned long start, unsigned long end,
 			   unsigned type);
+extern int e820_any_mapped(u64 start, u64 end, unsigned type);
 extern void find_max_pfn(void);
 extern void register_bootmem_low_pages(unsigned long max_low_pfn);
 extern void e820_register_memory(void);
