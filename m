Return-Path: <linux-kernel-owner+w=401wt.eu-S1756961AbYAYGDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbYAYGDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 01:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYAYGDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 01:03:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:25580 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbYAYGDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 01:03:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,248,1199692800"; 
   d="scan'208";a="507935442"
Subject: Re: [RFC] some page can't be migrated
From: Shaohua Li <shaohua.li@intel.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200801251517.02287.nickpiggin@yahoo.com.au>
References: <1201069357.32059.13.camel@sli10-desk.sh.intel.com>
	 <1201233590.28282.13.camel@sli10-desk.sh.intel.com>
	 <Pine.LNX.4.64.0801242000320.1932@schroedinger.engr.sgi.com>
	 <200801251517.02287.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Fri, 25 Jan 2008 14:03:25 +0800
Message-Id: <1201241005.24290.5.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-25 at 15:17 +1100, Nick Piggin wrote:
> On Friday 25 January 2008 15:01, Christoph Lameter wrote:
> > Acked-by: Christoph Lameter <clameter@sgi.com>
> >
> > Nick? Ok with you too?
> 
> Yeah, for memory hot remove that makes sense. A comment
> might be in order, at least a reference to the orphaned
> page code in vmscan.c.
> 
> Otherwise, it is OK by me.
Orphaned page might have fs-private metadata, the page is truncated. As
the page hasn't mapping, page migration refuse to migrate the page. It
appears the page is only freed in page reclaim and if zone watermark is
low, the page is never freed, as a result migration always fail. I
thought we could free the metadata so such page can be freed in
migration and make migration more reliable.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Acked-by: Christoph Lameter <clameter@sgi.com>

diff --git a/mm/migrate.c b/mm/migrate.c
index 6a207e8..2c1a48a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -646,14 +646,22 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 		rcu_locked = 1;
 	}
 	/*
-	 * This is a corner case handling.
-	 * When a new swap-cache is read into, it is linked to LRU
+	 * There are corner cases handling.
+	 * 1. When a new swap-cache is read into, it is linked to LRU
 	 * and treated as swapcache but has no rmap yet.
 	 * Calling try_to_unmap() against a page->mapping==NULL page is
 	 * BUG. So handle it here.
+	 * 2. Orphaned page (see truncate_complete_page) might have
+	 * fs-private metadata, the page is truncated. The page can be picked
+	 * up due to memory offlineing. Everywhere else except page reclaim,
+	 * the page is invisible to the vm, so the page can't be migrated. Try
+	 * to free metadata, so the page can be freed.
 	 */
-	if (!page->mapping)
+	if (!page->mapping) {
+		if (!PageAnon(page) && PagePrivate(page))
+			try_to_release_page(page, GFP_KERNEL);
 		goto rcu_unlock;
+	}
 	/* Establish migration ptes or remove ptes */
 	try_to_unmap(page, 1);
 
diff --git a/mm/truncate.c b/mm/truncate.c
index cadc156..62fd8cd 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -84,7 +84,7 @@ EXPORT_SYMBOL(cancel_dirty_page);
 
 /*
  * If truncate cannot remove the fs-private metadata from the page, the page
- * becomes anonymous.  It will be left on the LRU and may even be mapped into
+ * becomes orphaned.  It will be left on the LRU and may even be mapped into
  * user pagetables if we're racing with filemap_fault().
  *
  * We need to bale out if page->mapping is no longer equal to the original


