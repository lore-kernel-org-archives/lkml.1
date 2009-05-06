Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbZEFQzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbZEFQzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 12:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbZEFQzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 12:55:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:56747 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbZEFQzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 12:55:20 -0400
Message-ID: <4A01C08F.8020607@kernel.org>
Date: Wed, 06 May 2009 09:53:35 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: mel@csn.ul.ie,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix nodes_cover_memory
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


found one system that missed one entry for one node in SRAT, and that SRAT is not
rejected by nodes_cover_memory()

it turns out that we can not use absent_page_in_range to calaulate
e820ram, bacause that will use early_node_map and that is AND result of
e820 and SRAT.

revert back to use e820_hole_size instead.

also change that difference checking to 1M instead of 4G,
because e820ram, and pxmram are in pages.

[ Impact: reject wrong SRAT tables ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>

---
 arch/x86/mm/srat_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_64.c
+++ linux-2.6/arch/x86/mm/srat_64.c
@@ -345,9 +345,9 @@ static int __init nodes_cover_memory(con
 			pxmram = 0;
 	}
 
-	e820ram = max_pfn - absent_pages_in_range(0, max_pfn);
+	e820ram = max_pfn - (e820_hole_size(0, max_pfn<<PAGE_SHIFT)>>PAGE_SHIFT);
 	/* We seem to lose 3 pages somewhere. Allow a bit of slack. */
-	if ((long)(e820ram - pxmram) >= 1*1024*1024) {
+	if ((long)(e820ram - pxmram) >= (1<<(20 - PAGE_SHIFT))) {
 		printk(KERN_ERR
 	"SRAT: PXMs only cover %luMB of your %luMB e820 RAM. Not used.\n",
 			(pxmram << PAGE_SHIFT) >> 20,
