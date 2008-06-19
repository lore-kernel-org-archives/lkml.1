Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYFSW5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYFSW5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 18:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbYFSW5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 18:57:32 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:37842 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752735AbYFSW5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 18:57:31 -0400
Subject: [PATCH 1/2] cleanup e820_setup_gap
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "Brown, Len" <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 19 Jun 2008 15:57:30 -0700
Message-Id: <1213916250.27983.35.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparatory patch for the next patch in series.
Moves some code from e820_setup_gap to a new function e820_search_gap.
This function will be used by the next patch in the series.

Signed-off-by: Alok N Kataria <akataria@vmware.com>

Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c	2008-06-12 10:42:22.000000000 -0700
+++ linux-2.6/arch/x86/kernel/e820_64.c	2008-06-13 14:05:18.000000000 -0700
@@ -872,26 +872,20 @@
 EXPORT_SYMBOL(pci_mem_start);
 
 /*
- * Search for the biggest gap in the low 32 bits of the e820
- * memory space.  We pass this space to PCI to assign MMIO resources
- * for hotplug or unconfigured devices in.
- * Hopefully the BIOS let enough space left.
+ * Search for a gap in the e820 memory space from start_addr to 2^32.
  */
-__init void e820_setup_gap(void)
+__init void e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
+			unsigned long start_addr)
 {
-	unsigned long gapstart, gapsize, round;
-	unsigned long last;
-	int i;
-	int found = 0;
+	unsigned long last = 0x100000000ull;
+	int i = e820.nr_map;
 
-	last = 0x100000000ull;
-	gapstart = 0x10000000;
-	gapsize = 0x400000;
-	i = e820.nr_map;
 	while (--i >= 0) {
 		unsigned long long start = e820.map[i].addr;
 		unsigned long long end = start + e820.map[i].size;
 
+		if (end < start_addr)
+			continue;
 		/*
 		 * Since "last" is at most 4GB, we know we'll
 		 * fit in 32 bits if this condition is true
@@ -899,17 +893,32 @@
 		if (last > end) {
 			unsigned long gap = last - end;
 
-			if (gap > gapsize) {
-				gapsize = gap;
-				gapstart = end;
-				found = 1;
+			if (gap >= *gapsize) {
+				*gapsize = gap;
+				*gapstart = end;
 			}
 		}
 		if (start < last)
 			last = start;
 	}
+}
+
+/*
+ * Search for the biggest gap in the low 32 bits of the e820
+ * memory space.  We pass this space to PCI to assign MMIO resources
+ * for hotplug or unconfigured devices in.
+ * Hopefully the BIOS let enough space left.
+ */
+__init void e820_setup_gap(void)
+{
+	unsigned long gapstart, gapsize, round;
+
+	gapstart = 0;
+	gapsize = 0x400000;
+
+	e820_search_gap(&gapstart, &gapsize, 0);
 
-	if (!found) {
+	if (!gapstart) {
 		gapstart = (end_pfn << PAGE_SHIFT) + 1024*1024;
 		printk(KERN_ERR "PCI: Warning: Cannot find a gap in the 32bit "
 		       "address range\n"
Index: linux-2.6/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_64.h	2008-06-12 10:42:22.000000000 -0700
+++ linux-2.6/include/asm-x86/e820_64.h	2008-06-12 10:55:09.000000000 -0700
@@ -39,6 +39,7 @@
 extern unsigned long e820_hole_size(unsigned long start, unsigned long end);
 
 extern void e820_setup_gap(void);
+extern void e820_search_gap(unsigned long *, unsigned long *, unsigned long);
 extern void e820_register_active_regions(int nid, unsigned long start_pfn,
 					 unsigned long end_pfn);
 


