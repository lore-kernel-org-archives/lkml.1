Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbYAYD6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbYAYD6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 22:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYAYD6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 22:58:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:13941 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbYAYD6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 22:58:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,247,1199692800"; 
   d="scan'208";a="507903505"
Subject: Re: [RFC] some page can't be migrated
From: Shaohua Li <shaohua.li@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0801241931500.32043@schroedinger.engr.sgi.com>
References: <1201069357.32059.13.camel@sli10-desk.sh.intel.com>
	 <Pine.LNX.4.64.0801241931500.32043@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 25 Jan 2008 11:59:50 +0800
Message-Id: <1201233590.28282.13.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-24 at 19:37 -0800, Christoph Lameter wrote:
> On Wed, 23 Jan 2008, Shaohua Li wrote:
> 
> > +
> > +	/*
> > +	 * See truncate_complete_page(). Anonymous page might have
> > +	 * fs-private metadata, the page is truncated. Such page can't be
> > +	 * migrated. Try to free metadata, so the page can be freed.
> > +	 */
> 
> Well maybe you should change the comment to refer to an orphaned page. 
> That is what Nick used. Also change the comment in truncate_complete_page. 
> Anonymous page is confusing here because you check that it is *not* an 
> anonymous page.
> 
> > +	if (!page->mapping && !PageAnon(page) && PagePrivate(page)) {
> > +		try_to_release_page(page, GFP_KERNEL);
> > +		goto unlock;
> > +	}
> > +
> 
> 
> Could you move that into the corner case handling that follows?
> 
> So it would be something like
> 
> if (!page->mapping) {
> 	if (!PageAnon(page) && PagePrivate(page))
> 		try_to_relase_page(page, GFP_KERNEL);
> 	goto rcu_unlock;
> }
Ok, changed.

Orphaned page might have fs-private metadata, the page is truncated. As
the page hasn't mapping, page migration refuse to migrate the page. It
appears the page is only freed in page reclaim and if zone watermark is
low, the page is never freed, as a result migration always fail. I
thought we could free the metadata so such page can be freed in
migration and make migration more reliable.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/mm/migrate.c b/mm/migrate.c
index 6a207e8..e82acc9 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -652,8 +652,16 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 	 * Calling try_to_unmap() against a page->mapping==NULL page is
 	 * BUG. So handle it here.
 	 */
-	if (!page->mapping)
+	if (!page->mapping) {
+		/*
+		 * See truncate_complete_page(). Orphaned page might have
+		 * fs-private metadata, the page is truncated. Such page can't
+		 * be migrated. Try to free metadata, so the page can be freed.
+		 */
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


