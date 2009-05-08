Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbZEHHii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbZEHHii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 03:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbZEHHi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 03:38:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:46642 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbZEHHi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 03:38:28 -0400
Message-ID: <4A03E10C.60906@kernel.org>
Date: Fri, 08 May 2009 00:36:44 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Mel Gorman <mel@csn.ul.ie>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] x86: Sanity check the e820 against the SRAT table using
 e820 map only
References: <4A01C08F.8020607@kernel.org> <20090507134723.GA32409@csn.ul.ie> <20090507142121.GL481@elte.hu>
In-Reply-To: <20090507142121.GL481@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


node_cover_memory() sanity checks the SRAT table by ensuring that all
PXMs cover the memory reported in the e820. However, when calculating
the size of the holes in the e820, it uses the early_node_map[] which
contains information taken from both SRAT and e820. If the SRAT is
missing an entry, then it is not detected that the SRAT table is
incorrect and missing entries.

This patch uses the e820 map to calculate the holes instead of
early_node_map[].

comment is from Mel.

[ Impact: reject wrong SRAT tables ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>

---
 arch/x86/mm/srat_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_64.c
+++ linux-2.6/arch/x86/mm/srat_64.c
@@ -345,7 +345,7 @@ static int __init nodes_cover_memory(con
 			pxmram = 0;
 	}
 
-	e820ram = max_pfn - absent_pages_in_range(0, max_pfn);
+	e820ram = max_pfn - (e820_hole_size(0, max_pfn<<PAGE_SHIFT)>>PAGE_SHIFT);
 	/* We seem to lose 3 pages somewhere. Allow a bit of slack. */
 	if ((long)(e820ram - pxmram) >= 1*1024*1024) {
 		printk(KERN_ERR
