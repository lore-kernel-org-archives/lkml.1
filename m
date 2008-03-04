Return-Path: <linux-kernel-owner+w=401wt.eu-S1763060AbYCDAIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763060AbYCDAIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 19:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbYCDAHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 19:07:38 -0500
Received: from relay2.sgi.com ([192.48.171.30]:47564 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752372AbYCDAHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 19:07:35 -0500
Message-Id: <20080304000733.017773882@sgi.com>
References: <20080304000452.514878384@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 03 Mar 2008 16:04:56 -0800
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: apw@shadowen.org
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org
Subject: [rfc 04/10] Pageflags: Use proper page flag functions in Xen
Content-Disposition: inline; filename=xen
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen uses bitops to manipulate page flags. Make it use proper page flag
functions.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/xen/mmu.c         |    4 ++--
 include/linux/page-flags.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/xen/mmu.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/mmu.c	2008-03-03 15:45:09.207335791 -0800
+++ linux-2.6/arch/x86/xen/mmu.c	2008-03-03 15:48:09.469801962 -0800
@@ -425,7 +425,7 @@ static void xen_do_pin(unsigned level, u
 
 static int pin_page(struct page *page, enum pt_level level)
 {
-	unsigned pgfl = test_and_set_bit(PG_pinned, &page->flags);
+	unsigned pgfl = TestSetPagePinned(page);
 	int flush;
 
 	if (pgfl)
@@ -506,7 +506,7 @@ void __init xen_mark_init_mm_pinned(void
 
 static int unpin_page(struct page *page, enum pt_level level)
 {
-	unsigned pgfl = test_and_clear_bit(PG_pinned, &page->flags);
+	unsigned pgfl = TestClearPagePinned(page);
 
 	if (pgfl && !PageHighMem(page)) {
 		void *pt = lowmem_page_address(page);
Index: linux-2.6/include/linux/page-flags.h
===================================================================
--- linux-2.6.orig/include/linux/page-flags.h	2008-03-03 15:46:15.848254180 -0800
+++ linux-2.6/include/linux/page-flags.h	2008-03-03 15:48:09.469801962 -0800
@@ -155,7 +155,7 @@ PAGEFLAG(LRU, lru) __CLEARPAGEFLAG(LRU, 
 PAGEFLAG(Active, active) __CLEARPAGEFLAG(Active, active)
 __PAGEFLAG(Slab, slab)
 PAGEFLAG(Checked, checked)		/* Used by some filesystems */
-PAGEFLAG(Pinned, pinned)		/* Xen pinned pagetable */
+PAGEFLAG(Pinned, pinned) TESTSCFLAG(Pinned, pinned) /* Xen pagetable */
 PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
 PAGEFLAG(Private, private) __CLEARPAGEFLAG(Private, private)
 	__SETPAGEFLAG(Private, private)

-- 
