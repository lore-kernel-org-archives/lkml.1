Return-Path: <linux-kernel-owner+w=401wt.eu-S1758466AbXJDECl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbXJDECl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 00:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbXJDEAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 00:00:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37858 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750714AbXJDEAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 00:00:05 -0400
Message-Id: <20071004040003.082188692@sgi.com>
References: <20071004035935.042951211@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 03 Oct 2007 20:59:41 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: [06/18] Vcompound: Update page address determination
Content-Disposition: inline; filename=vcompound_page_address
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make page_address() correctly determine the address of a potentially
virtually mapped compound page.

There are 3 cases to consider:

1. !HASHED_PAGE_VIRTUAL && !WANT_PAGE_VIRTUAL

Call vmalloc_address() directly from the page_address function
defined in mm.h.

2. HASHED_PAGE_VIRTUAL

Modify page_address() in highmem.c to call vmalloc_address().

3. WANT_PAGE_VIRTUAL

set_page_address() is used to set up the virtual addresses of
all pages that are part of the virtual compound.

Cc: apw@shadowen.org
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mm.h |    9 ++++++++-
 mm/highmem.c       |   10 ++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2007-10-03 19:39:52.000000000 -0700
+++ linux-2.6/include/linux/mm.h	2007-10-03 19:40:29.000000000 -0700
@@ -605,7 +605,14 @@ void page_address_init(void);
 #endif
 
 #if !defined(HASHED_PAGE_VIRTUAL) && !defined(WANT_PAGE_VIRTUAL)
-#define page_address(page) lowmem_page_address(page)
+
+static inline void *page_address(struct page *page)
+{
+	if (unlikely(PageVcompound(page)))
+		return vmalloc_address(page);
+	return lowmem_page_address(page);
+}
+
 #define set_page_address(page, address)  do { } while(0)
 #define page_address_init()  do { } while(0)
 #endif
Index: linux-2.6/mm/highmem.c
===================================================================
--- linux-2.6.orig/mm/highmem.c	2007-10-03 19:39:25.000000000 -0700
+++ linux-2.6/mm/highmem.c	2007-10-03 19:40:29.000000000 -0700
@@ -265,8 +265,11 @@ void *page_address(struct page *page)
 	void *ret;
 	struct page_address_slot *pas;
 
-	if (!PageHighMem(page))
+	if (!PageHighMem(page)) {
+		if (PageVcompound(page))
+			return vmalloc_address(page);
 		return lowmem_page_address(page);
+	}
 
 	pas = page_slot(page);
 	ret = NULL;
@@ -294,7 +297,10 @@ void set_page_address(struct page *page,
 	struct page_address_slot *pas;
 	struct page_address_map *pam;
 
-	BUG_ON(!PageHighMem(page));
+	if (!PageHighMem(page)) {
+		BUG_ON(!PageVcompound(page));
+		return;
+	}
 
 	pas = page_slot(page);
 	if (virtual) {		/* Add */

-- 
