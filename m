Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYFZG33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYFZG33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 02:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbYFZG3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 02:29:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:43531 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbYFZG3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 02:29:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,707,1204531200"; 
   d="scan'208";a="582119813"
Subject: [PATCH 2/2] x86 boot: early_res_to_e820
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 26 Jun 2008 14:33:00 +0800
Message-Id: <1214461980.10809.7.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
X-OriginalArrivalTime: 26 Jun 2008 06:29:13.0696 (UTC) FILETIME=[F377B600:01C8D755]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reserves some memory areas of early_res in E820 as
E820_RESVD_KERN. This is used mainly on i386, for some memory area
from boot-loader and in highmem, such as linked list of setup_data,
EFI memory map, etc.

This patch is based on latest x86/master branch of git-x86 tree and
has been tested on i386 and x86_64 platform.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/e820.c     |   22 ++++++++++++++++++++++
 arch/x86/kernel/setup_32.c |    2 ++
 include/asm-x86/e820.h     |    1 +
 3 files changed, 25 insertions(+)

--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -844,6 +844,28 @@ void __init early_res_to_bootmem(u64 sta
 	}
 }
 
+void __init early_res_to_e820(u64 start, u64 end)
+{
+	int i, changed = 0;
+	u64 final_start, final_end;
+	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
+		struct early_res *r = &early_res[i];
+		final_start = max(start, r->start);
+		final_end = min(end, r->end);
+		if (final_start >= final_end)
+			continue;
+		printk(KERN_INFO "  early res: %d [%llx-%llx] %s\n", i,
+			final_start, final_end - 1, r->name);
+		e820_update_range(final_start, final_end - final_start,
+				  E820_RAM, E820_RESVD_KERN);
+		changed = 1;
+	}
+	if (changed) {
+		printk(KERN_INFO "update e820 for early_res\n");
+		update_e820();
+	}
+}
+
 /* Check for already reserved areas */
 static inline int __init bad_addr(u64 *addrp, u64 size, u64 align)
 {
--- a/include/asm-x86/e820.h
+++ b/include/asm-x86/e820.h
@@ -96,6 +96,7 @@ extern void reserve_early(u64 start, u64
 extern void reserve_early_overlap_ok(u64 start, u64 end, char *name);
 extern void free_early(u64 start, u64 end);
 extern void early_res_to_bootmem(u64 start, u64 end);
+extern void early_res_to_e820(u64 start, u64 end);
 extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
 
 extern unsigned long e820_end_of_ram(void);
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -447,6 +447,8 @@ void __init setup_arch(char **cmdline_p)
         acpi_numa_init();
 #endif
 
+	early_res_to_e820(max_low_pfn<<PAGE_SHIFT, -1);
+
 	initmem_init(0, max_pfn);
 
 #ifdef CONFIG_ACPI_SLEEP

