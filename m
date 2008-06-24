Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbYFXSsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbYFXSsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 14:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbYFXSsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 14:48:32 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:41559 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751793AbYFXSsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 14:48:31 -0400
Subject: [PATCH 1/2] cleanup e820_setup_gap v2
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>, lenb@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 24 Jun 2008 11:48:30 -0700
Message-Id: <1214333310.27577.26.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparatory patch for the next patch in series.
Moves some code from e820_setup_gap to a new function e820_search_gap.
This patch is a part of a bug fix where we walk the ACPI table to calculate
a gap for PCI optional devices.

v1->v2: Patch on top of tip/master.
	Fixes a bug introduced in the last patch about the typeof "last".
	Also the new function e820_search_gap now returns if we found a gap in
	e820_map.

Signed-off-by: Alok N Kataria <akataria@vmware.com>

Index: linux-x86-tree.git/arch/x86/kernel/e820.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/e820.c	2008-06-23 17:24:07.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/e820.c	2008-06-24 10:27:38.000000000 -0700
@@ -477,26 +477,22 @@
 }
 
 /*
- * Search for the biggest gap in the low 32 bits of the e820
- * memory space.  We pass this space to PCI to assign MMIO resources
- * for hotplug or unconfigured devices in.
- * Hopefully the BIOS let enough space left.
+ * Search for a gap in the e820 memory space from start_addr to 2^32.
  */
-__init void e820_setup_gap(void)
+__init int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
+		unsigned long start_addr)
 {
-	unsigned long gapstart, gapsize, round;
-	unsigned long long last;
-	int i;
+	unsigned long long last = 0x100000000ull;
+	int i = e820.nr_map;
 	int found = 0;
 
-	last = 0x100000000ull;
-	gapstart = 0x10000000;
-	gapsize = 0x400000;
-	i = e820.nr_map;
 	while (--i >= 0) {
 		unsigned long long start = e820.map[i].addr;
 		unsigned long long end = start + e820.map[i].size;
 
+		if (end < start_addr)
+			continue;
+
 		/*
 		 * Since "last" is at most 4GB, we know we'll
 		 * fit in 32 bits if this condition is true
@@ -504,15 +500,32 @@
 		if (last > end) {
 			unsigned long gap = last - end;
 
-			if (gap > gapsize) {
-				gapsize = gap;
-				gapstart = end;
+			if (gap >= *gapsize) {
+				*gapsize = gap;
+				*gapstart = end;
 				found = 1;
 			}
 		}
 		if (start < last)
 			last = start;
 	}
+	return found;
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
+	int found;
+
+	gapstart = 0x10000000;
+	gapsize = 0x400000;
+	found  = e820_search_gap(&gapstart, &gapsize, 0);
 
 #ifdef CONFIG_X86_64
 	if (!found) {
Index: linux-x86-tree.git/include/asm-x86/e820.h
===================================================================
--- linux-x86-tree.git.orig/include/asm-x86/e820.h	2008-06-23 17:24:26.000000000 -0700
+++ linux-x86-tree.git/include/asm-x86/e820.h	2008-06-24 10:27:38.000000000 -0700
@@ -71,6 +71,8 @@
 			     int checktype);
 extern void update_e820(void);
 extern void e820_setup_gap(void);
+extern int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
+				unsigned long start_addr);
 struct setup_data;
 extern void parse_e820_ext(struct setup_data *data, unsigned long pa_data);
 



