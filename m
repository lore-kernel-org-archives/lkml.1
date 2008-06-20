Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYFTT7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYFTT7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbYFTT7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:59:05 -0400
Received: from mail-sin.bigfish.com ([207.46.51.74]:14699 "EHLO
	mail126-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbYFTT7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:59:04 -0400
X-BigFish: VPS6(z34a4lzzz10d3izzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0K2S25U-01-8B7-01
Date: Fri, 20 Jun 2008 21:58:46 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 1/7] x86: introduce macro to check whether an address range
	is in the ISA range
Message-ID: <20080620195846.GC4105@alberich.amd.com>
References: <20080620195503.GB4105@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620195503.GB4105@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Jun 2008 19:58:49.0002 (UTC) FILETIME=[0E20B0A0:01C8D310]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/ioremap.c  |    2 +-
 arch/x86/mm/pat.c      |    5 ++---
 include/asm-x86/e820.h |    1 +
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 7452eb3..6d9960d 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -142,7 +142,7 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	/*
 	 * Don't remap the low PCI/ISA area, it's always mapped..
 	 */
-	if (phys_addr >= ISA_START_ADDRESS && last_addr < ISA_END_ADDRESS)
+	if (is_ISA_range(phys_addr, last_addr))
 		return (__force void __iomem *)phys_to_virt(phys_addr);
 
 	/*
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 227df3c..5bbc22e 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -215,7 +215,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	}
 
 	/* Low ISA region is always mapped WB in page table. No need to track */
-	if (start >= ISA_START_ADDRESS && (end - 1) <= ISA_END_ADDRESS) {
+	if (is_ISA_range(start, end - 1)) {
 		if (ret_type)
 			*ret_type = _PAGE_CACHE_WB;
 
@@ -415,9 +415,8 @@ int free_memtype(u64 start, u64 end)
 	}
 
 	/* Low ISA region is always mapped WB. No need to track */
-	if (start >= ISA_START_ADDRESS && end <= ISA_END_ADDRESS) {
+	if (is_ISA_range(start, end - 1))
 		return 0;
-	}
 
 	spin_lock(&memtype_lock);
 	list_for_each_entry(ml, &memtype_list, nd) {
diff --git a/include/asm-x86/e820.h b/include/asm-x86/e820.h
index 7004251..5103d0b 100644
--- a/include/asm-x86/e820.h
+++ b/include/asm-x86/e820.h
@@ -24,6 +24,7 @@ struct e820map {
 
 #define ISA_START_ADDRESS	0xa0000
 #define ISA_END_ADDRESS		0x100000
+#define is_ISA_range(s, e) ((s) >= ISA_START_ADDRESS && (e) < ISA_END_ADDRESS)
 
 #define BIOS_BEGIN		0x000a0000
 #define BIOS_END		0x00100000
-- 
1.5.5.4



