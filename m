Return-Path: <linux-kernel-owner+w=401wt.eu-S1759443AbZCBGxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbZCBGxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 01:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbZCBGwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 01:52:51 -0500
Received: from mx1.suse.de ([195.135.220.2]:35397 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbZCBGwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 01:52:50 -0500
Date: Mon, 2 Mar 2009 07:52:47 +0100
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 2/2] slqb: x86 cleanup
Message-ID: <20090302065247.GB1257@wotan.suse.de>
References: <20090302064735.GA1257@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090302064735.GA1257@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


My virt_to_page_fast speedup for x86-64 snuck in to the slqb patch, where it
does not belong. Oops.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/arch/x86/include/asm/page.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/page.h	2009-03-02 17:41:56.000000000 +1100
+++ linux-2.6/arch/x86/include/asm/page.h	2009-03-02 17:42:02.000000000 +1100
@@ -193,7 +193,6 @@ static inline pteval_t native_pte_flags(
  * virt_addr_valid(kaddr) returns true.
  */
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
-#define virt_to_page_fast(kaddr) pfn_to_page(((unsigned long)(kaddr) - PAGE_OFFSET) >> PAGE_SHIFT)
 #define pfn_to_kaddr(pfn)      __va((pfn) << PAGE_SHIFT)
 extern bool __virt_addr_valid(unsigned long kaddr);
 #define virt_addr_valid(kaddr)	__virt_addr_valid((unsigned long) (kaddr))
Index: linux-2.6/mm/slqb.c
===================================================================
--- linux-2.6.orig/mm/slqb.c	2009-03-02 17:41:56.000000000 +1100
+++ linux-2.6/mm/slqb.c	2009-03-02 17:42:09.000000000 +1100
@@ -156,11 +156,7 @@ static inline struct zone *slqb_page_zon
 
 static inline int virt_to_nid(const void *addr)
 {
-#ifdef virt_to_page_fast
-	return page_to_nid(virt_to_page_fast(addr));
-#else
 	return page_to_nid(virt_to_page(addr));
-#endif
 }
 
 static inline struct slqb_page *virt_to_head_slqb_page(const void *addr)
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2009-03-02 17:42:59.000000000 +1100
+++ linux-2.6/include/linux/mm.h	2009-03-02 17:43:09.000000000 +1100
@@ -305,11 +305,7 @@ static inline void get_page(struct page 
 
 static inline struct page *virt_to_head_page(const void *x)
 {
-#ifdef virt_to_page_fast
-	struct page *page = virt_to_page_fast(x);
-#else
 	struct page *page = virt_to_page(x);
-#endif
 	return compound_head(page);
 }
 
