Return-Path: <linux-kernel-owner+w=401wt.eu-S1753037AbXLZUnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbXLZUnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 15:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbXLZUnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 15:43:05 -0500
Received: from relay1.sgi.com ([192.48.171.29]:41978 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751401AbXLZUnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 15:43:04 -0500
Date: Wed, 26 Dec 2007 12:43:01 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: tlb_finish_mmu() bogisity
In-Reply-To: <Pine.LNX.4.64.0712241054210.8299@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0712261236390.15176@schroedinger.engr.sgi.com>
References: <20071223093241.GR8181@ftp.linux.org.uk>
 <alpine.LFD.0.9999.0712231311530.21557@woody.linux-foundation.org>
 <Pine.LNX.4.64.0712241054210.8299@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh. This is indeed bogus. The one reporting the problem states that the 
patch did not address the issue. The report was regarding pgd freeing 
which is handled slightly differently from pte frees.

[PATCH] Revert quicklist need->flush fix

Did not fix the reported issue. Apart from other weirdness this causes a 
bad link between the TLB flushing logic and the quicklists. If there is 
indeed an issue that an arch needs a tlb flush before free then the arch 
code needs to set tlb->need_flush before calling quicklist_free.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6/include/asm-generic/tlb.h
===================================================================
--- linux-2.6.orig/include/asm-generic/tlb.h	2007-12-26 12:26:32.000000000 -0800
+++ linux-2.6/include/asm-generic/tlb.h	2007-12-26 12:26:39.000000000 -0800
@@ -86,9 +86,6 @@ tlb_flush_mmu(struct mmu_gather *tlb, un
 static inline void
 tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 {
-#ifdef CONFIG_QUICKLIST
-	tlb->need_flush += &__get_cpu_var(quicklist)[0].nr_pages != 0;
-#endif
 	tlb_flush_mmu(tlb, start, end);
 
 	/* keep the page table cache within bounds */
