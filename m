Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbXBZSht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbXBZSht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbXBZShs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:37:48 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:48602 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbXBZShr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:37:47 -0500
Date: Mon, 26 Feb 2007 19:38:00 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH,RFC] fix section mismatch warning in lib/swiotlb.c
Message-ID: <20070226183800.GA15669@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kbuild spits outs following warning on a 
defconfig x86_64 build:
WARNING: swiotlb.o - Section mismatch: reference to .init.text:swiotlb_init from __ksymtab between '__ksymtab_swiotlb_init' (at offset 0xa0) and '__ksymtab_swiotlb_free_coherent'

This warning happens because the function 
swiotlb_init is marked __init and EXPORT_SYMBOL().
A 'git grep swiotlb_init' showed no users in drivers/
so maybe the EXPORT_SYMBOL can be deleted which would cure the warning?

I took the pragmatic approach and made it non-__init.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 623a68a..3133495 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -160,7 +160,7 @@ __setup("swiotlb=", setup_io_tlb_npages);
  * Statically reserve bounce buffer space and initialize bounce buffer data
  * structures for the software IO TLB used to implement the DMA API.
  */
-void __init
+void
 swiotlb_init_with_default_size(size_t default_size)
 {
 	unsigned long i, bytes;
@@ -211,7 +211,7 @@ swiotlb_init_with_default_size(size_t default_size)
 #define __swiotlb_init_with_default_size swiotlb_init_with_default_size
 #endif
 
-void __init
+void
 swiotlb_init(void)
 {
 	__swiotlb_init_with_default_size(64 * (1<<20)); /* default to 64MB */
