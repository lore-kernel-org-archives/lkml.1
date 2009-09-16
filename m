Return-Path: <linux-kernel-owner+w=401wt.eu-S1760560AbZIPWom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760560AbZIPWom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760378AbZIPWo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:44:27 -0400
Received: from kroah.org ([198.145.64.141]:49014 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760403AbZIPWkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:40:09 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:17 2009
Message-Id: <20090916223717.810489941@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nicolas Pitre <nico@marvell.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch 31/45] ARM: 5691/1: fix cache aliasing issues between kmap() and kmap_atomic() with highmem
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=arm-5691-1-fix-cache-aliasing-issues-between-kmap-and-kmap_atomic-with-highmem.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Nicolas Pitre <nico@cam.org>

commit 7929eb9cf643ae416e5081b2a6fa558d37b9854c upstream.

Let's suppose a highmem page is kmap'd with kmap().  A pkmap entry is
used, the page mapped to it, and the virtual cache is dirtied.  Then
kunmap() is used which does virtually nothing except for decrementing a
usage count.

Then, let's suppose the _same_ page gets mapped using kmap_atomic().
It is therefore mapped onto a fixmap entry instead, which has a
different virtual address unaware of the dirty cache data for that page
sitting in the pkmap mapping.

Fortunately it is easy to know if a pkmap mapping still exists for that
page and use it directly with kmap_atomic(), thanks to kmap_high_get().

And actual testing with a printk in the added code path shows that this
condition is actually met *extremely* frequently.  Seems that we've been
quite lucky that things have worked so well with highmem so far.

Signed-off-by: Nicolas Pitre <nico@marvell.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/arch/arm/mm/highmem.c
+++ b/arch/arm/mm/highmem.c
@@ -40,11 +40,16 @@ void *kmap_atomic(struct page *page, enum km_type type)
 {
 	unsigned int idx;
 	unsigned long vaddr;
+	void *kmap;
 
 	pagefault_disable();
 	if (!PageHighMem(page))
 		return page_address(page);
 
+	kmap = kmap_high_get(page);
+	if (kmap)
+		return kmap;
+
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
@@ -80,6 +85,9 @@ void kunmap_atomic(void *kvaddr, enum km_type type)
 #else
 		(void) idx;  /* to kill a warning */
 #endif
+	} else if (vaddr >= PKMAP_ADDR(0) && vaddr < PKMAP_ADDR(LAST_PKMAP)) {
+		/* this address was obtained through kmap_high_get() */
+		kunmap_high(pte_page(pkmap_page_table[PKMAP_NR(vaddr)]));
 	}
 	pagefault_enable();
 }


