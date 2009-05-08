Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbZEHHjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbZEHHjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 03:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbZEHHjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 03:39:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:46668 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbZEHHjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 03:39:02 -0400
Message-ID: <4A03E13E.6050107@kernel.org>
Date: Fri, 08 May 2009 00:37:34 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Mel Gorman <mel@csn.ul.ie>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] x86: Allow 1MB of slack between the e820 map and SRAT,
 not 4GB
References: <4A01C08F.8020607@kernel.org> <20090507134723.GA32409@csn.ul.ie> <20090507142121.GL481@elte.hu> <4A03E10C.60906@kernel.org>
In-Reply-To: <4A03E10C.60906@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It is expected that there be slight differences between the e820 map and
the SRAT table and the intention was that 1MB of slack be allowed. The
calculation comparing e820ram and pxmram assumes the units are bytes,
when they are in fact pages. This means 4GB of slack is being allowed,
not 1MB. This patch makes the correct comparison

comment is from Mel.

[ Impact: don't accept the srat that could dump 2g etc ram ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>

---
 arch/x86/mm/srat_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_64.c
+++ linux-2.6/arch/x86/mm/srat_64.c
@@ -346,8 +346,8 @@ static int __init nodes_cover_memory(con
 	}
 
 	e820ram = max_pfn - (e820_hole_size(0, max_pfn<<PAGE_SHIFT)>>PAGE_SHIFT);
-	/* We seem to lose 3 pages somewhere. Allow a bit of slack. */
-	if ((long)(e820ram - pxmram) >= 1*1024*1024) {
+	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
+	if ((long)(e820ram - pxmram) >= (1<<(20 - PAGE_SHIFT))) {
 		printk(KERN_ERR
 	"SRAT: PXMs only cover %luMB of your %luMB e820 RAM. Not used.\n",
 			(pxmram << PAGE_SHIFT) >> 20,
