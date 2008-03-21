Return-Path: <linux-kernel-owner+w=401wt.eu-S932385AbYCUWyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbYCUWyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763656AbYCUWuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:50:01 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59112 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762960AbYCUWuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:50:00 -0400
Message-Id: <20080321224402.117570915@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:25 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andy Whitcroft <apw@shadowen.org>, Adam Litke <agl@us.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 35/76] hugetlb: ensure we do not reference a surplus page after handing it to buddy
Content-Disposition: inline; filename=hugetlb-ensure-we-do-not-reference-a-surplus-page-after-handing-it-to-buddy.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Andy Whitcroft <apw@shadowen.org>

When we free a page via free_huge_page and we detect that we are in surplus
the page will be returned to the buddy.  After this we no longer own the page.

However at the end free_huge_page we clear out our mapping pointer from
page private.  Even where the page is not a surplus we free the page to
the hugepage pool, drop the pool locks and then clear page private.  In
either case the page may have been reallocated.  BAD.

Make sure we clear out page private before we free the page.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Adam Litke <agl@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -119,6 +119,7 @@ static void free_huge_page(struct page *
 	struct address_space *mapping;
 
 	mapping = (struct address_space *) page_private(page);
+	set_page_private(page, 0);
 	BUG_ON(page_count(page));
 	INIT_LIST_HEAD(&page->lru);
 
@@ -133,7 +134,6 @@ static void free_huge_page(struct page *
 	spin_unlock(&hugetlb_lock);
 	if (mapping)
 		hugetlb_put_quota(mapping, 1);
-	set_page_private(page, 0);
 }
 
 /*

-- 
