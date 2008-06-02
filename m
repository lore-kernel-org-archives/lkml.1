Return-Path: <linux-kernel-owner+w=401wt.eu-S1757674AbYFBGYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbYFBGYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYFBGYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:24:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:22599 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbYFBGYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:24:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,576,1204531200"; 
   d="scan'208";a="334832516"
Subject: [PATCH 2/5] x86_64 boot: reserve highmem pages via reserve_early
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 02 Jun 2008 14:26:18 +0800
Message-Id: <1212387978.301.27.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 02 Jun 2008 06:24:30.0455 (UTC) FILETIME=[50BA9070:01C8C479]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes early reserved highmem pages become reserved
pages. This can be used for highmem pages allocated by bootloader such
as EFI memory map, linked list of setup_data, etc.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/e820.c |   11 +++++++++++
 arch/x86/mm/init_32.c  |    3 ++-
 include/asm-x86/e820.h |    1 +
 3 files changed, 14 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -612,6 +612,17 @@ void __init free_early(u64 start, u64 en
 	early_res[j - 1].end = 0;
 }
 
+int __init page_is_reserved_early(unsigned long pagenr)
+{
+	u64 start = (u64)pagenr << PAGE_SHIFT;
+	int i;
+	struct early_res *r;
+
+	i = find_overlapped_early(start, start + PAGE_SIZE);
+	r = &early_res[i];
+	return (i < MAX_EARLY_RES && r->end);
+}
+
 void __init early_res_to_bootmem(u64 start, u64 end)
 {
 	int i;
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -294,7 +294,8 @@ static void __init permanent_kmaps_init(
 
 void __init add_one_highpage_init(struct page *page, int pfn, int bad_ppro)
 {
-	if (page_is_ram(pfn) && !(bad_ppro && page_kills_ppro(pfn))) {
+	if (page_is_ram(pfn) && !(bad_ppro && page_kills_ppro(pfn)) &&
+	    !page_is_reserved_early(pfn)) {
 		ClearPageReserved(page);
 		init_page_count(page);
 		__free_page(page);
--- a/include/asm-x86/e820.h
+++ b/include/asm-x86/e820.h
@@ -83,6 +83,7 @@ extern u64 find_e820_area(u64 start, u64
 extern u64 find_e820_area_size(u64 start, u64 *sizep, u64 align);
 extern void reserve_early(u64 start, u64 end, char *name);
 extern void free_early(u64 start, u64 end);
+extern int page_is_reserved_early(unsigned long pagenr);
 extern void early_res_to_bootmem(u64 start, u64 end);
 
 #endif /* __ASSEMBLY__ */

