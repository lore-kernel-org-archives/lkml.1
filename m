Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbYFZG3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbYFZG3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 02:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbYFZG3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 02:29:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:50547 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbYFZG3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 02:29:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,707,1204531200"; 
   d="scan'208";a="299706564"
Subject: [PATCH 1/2] x86 boot: add E820_RESVD_KERN
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 26 Jun 2008 14:32:58 +0800
Message-Id: <1214461978.10809.6.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
X-OriginalArrivalTime: 26 Jun 2008 06:29:12.0503 (UTC) FILETIME=[F2C1AC70:01C8D755]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a new type to E820 table named E820_RESVD_KERN, which
is used for memory area reserved for kernel itself instead of BIOS.

This patch is based on latest x86/master branch of git-x86 tree and
has been tested on i386 and x86_64 platform.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/e820.c |    6 ++++--
 include/asm-x86/e820.h |    3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/include/asm-x86/e820.h
+++ b/include/asm-x86/e820.h
@@ -44,6 +44,9 @@
 #define E820_ACPI	3
 #define E820_NVS	4
 
+/* reserved RAM used by kernel itself */
+#define E820_RESVD_KERN	128
+
 #ifndef __ASSEMBLY__
 struct e820entry {
 	__u64 addr;	/* start of memory segment */
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -120,6 +120,7 @@ void __init e820_print_map(char *who)
 		       (e820.map[i].addr + e820.map[i].size));
 		switch (e820.map[i].type) {
 		case E820_RAM:
+		case E820_RESVD_KERN:
 			printk(KERN_CONT "(usable)\n");
 			break;
 		case E820_RESERVED:
@@ -611,7 +612,7 @@ void __init e820_mark_nosave_regions(uns
 			register_nosave_region(pfn, PFN_UP(ei->addr));
 
 		pfn = PFN_DOWN(ei->addr + ei->size);
-		if (ei->type != E820_RAM)
+		if (ei->type != E820_RAM && ei->type != E820_RESVD_KERN)
 			register_nosave_region(PFN_UP(ei->addr), pfn);
 
 		if (pfn >= limit_pfn)
@@ -977,7 +978,7 @@ u64 __init early_reserve_e820(u64 startt
 		return 0;
 
 	addr = round_down(start + size - sizet, align);
-	e820_update_range(addr, sizet, E820_RAM, E820_RESERVED);
+	e820_update_range(addr, sizet, E820_RAM, E820_RESVD_KERN);
 	printk(KERN_INFO "update e820 for early_reserve_e820\n");
 	update_e820();
 
@@ -1191,6 +1192,7 @@ void __init e820_reserve_resources(void)
 	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
 	for (i = 0; i < e820.nr_map; i++) {
 		switch (e820.map[i].type) {
+		case E820_RESVD_KERN:
 		case E820_RAM:	res->name = "System RAM"; break;
 		case E820_ACPI:	res->name = "ACPI Tables"; break;
 		case E820_NVS:	res->name = "ACPI Non-volatile Storage"; break;

