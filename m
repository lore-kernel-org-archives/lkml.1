Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952Ab0AVDbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab0AVDbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 22:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816Ab0AVDae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 22:30:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:12184 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720Ab0AVDae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 22:30:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,322,1262592000"; 
   d="scan'208";a="589397793"
Message-Id: <20100122033004.470767217@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 11:21:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yinghai Lu <yinghai@kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
cc: shaohui.zheng@intel.com
Subject: [PATCH 3/3] x86: use the generic page_is_ram()
References: <20100122032102.137106635@intel.com>
Content-Disposition: inline; filename=x86-page-is-ram.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic resource based page_is_ram() works better with memory
hotplug/hotremove. So switch the x86 e820map based code to it.

CC: Andi Kleen <andi@firstfloor.org> 
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> 
CC: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 arch/x86/include/asm/page_types.h |    1 -
 arch/x86/mm/ioremap.c             |   21 ---------------------
 2 files changed, 22 deletions(-)

--- linux-mm.orig/arch/x86/include/asm/page_types.h	2010-01-22 11:20:29.000000000 +0800
+++ linux-mm/arch/x86/include/asm/page_types.h	2010-01-22 11:20:39.000000000 +0800
@@ -40,7 +40,6 @@
 
 #ifndef __ASSEMBLY__
 
-extern int page_is_ram(unsigned long pagenr);
 extern int devmem_is_allowed(unsigned long pagenr);
 
 extern unsigned long max_low_pfn_mapped;
--- linux-mm.orig/arch/x86/mm/ioremap.c	2010-01-22 11:20:37.000000000 +0800
+++ linux-mm/arch/x86/mm/ioremap.c	2010-01-22 11:20:39.000000000 +0800
@@ -24,27 +24,6 @@
 
 #include "physaddr.h"
 
-int page_is_ram(unsigned long pagenr)
-{
-	resource_size_t addr, end;
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		/*
-		 * Not usable memory:
-		 */
-		if (e820.map[i].type != E820_RAM)
-			continue;
-		addr = (e820.map[i].addr + PAGE_SIZE-1) >> PAGE_SHIFT;
-		end = (e820.map[i].addr + e820.map[i].size) >> PAGE_SHIFT;
-
-
-		if ((pagenr >= addr) && (pagenr < end))
-			return 1;
-	}
-	return 0;
-}
-
 /*
  * Fix up the linear direct mapping of the kernel to avoid cache attribute
  * conflicts.


