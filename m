Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbXBEOJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbXBEOJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932671AbXBEOJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:09:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932664AbXBEOJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:09:29 -0500
Subject: [GFS2] Fail over to readpage for stuffed files [10/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Russell Cattelan <cattelan@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:17:32 +0000
Message-Id: <1170685052.11001.290.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 25a24a1f1feaf460920f2de7abf23e3e79258197 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Fri, 15 Dec 2006 16:49:51 -0500
Subject: [PATCH] [GFS2] Fail over to readpage for stuffed files

This is partially derrived from a patch written by Russell Cattelan.
It fixes a bug where there is a race between readpages and truncate
by ignoring readpages for stuffed files. This is ok because a stuffed
file will never be more than one block (minus sizeof(struct gfs2_dinode))
in size and block size is always less than page size, so we do not lose
anything efficiency-wise by not doing readahead for stuffed files. They
will have already been "read ahead" by the action of reading the inode
in, in the first place.

This is the remaining part of the fix for Red Hat bugzilla #218966
which had not yet made it upstream.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Russell Cattelan <cattelan@redhat.com>

diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 0118aa4..37bfeb9 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -256,7 +256,7 @@ out_unlock:
  *    the page lock and the glock) and return having done no I/O. Its
  *    obviously not something we'd want to do on too regular a basis.
  *    Any I/O we ignore at this time will be done via readpage later.
- * 2. We have to handle stuffed files here too.
+ * 2. We don't handle stuffed files here we let readpage do the honours.
  * 3. mpage_readpages() does most of the heavy lifting in the common case.
  * 4. gfs2_get_block() is relied upon to set BH_Boundary in the right places.
  * 5. We use LM_FLAG_TRY_1CB here, effectively we then have lock-ahead as
@@ -269,8 +269,7 @@ static int gfs2_readpages(struct file *file, struct address_space *mapping,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct gfs2_holder gh;
-	unsigned page_idx;
-	int ret;
+	int ret = 0;
 	int do_unlock = 0;
 
 	if (likely(file != &gfs2_internal_file_sentinel)) {
@@ -289,29 +288,8 @@ static int gfs2_readpages(struct file *file, struct address_space *mapping,
 			goto out_unlock;
 	}
 skip_lock:
-	if (gfs2_is_stuffed(ip)) {
-		struct pagevec lru_pvec;
-		pagevec_init(&lru_pvec, 0);
-		for (page_idx = 0; page_idx < nr_pages; page_idx++) {
-			struct page *page = list_entry(pages->prev, struct page, lru);
-			prefetchw(&page->flags);
-			list_del(&page->lru);
-			if (!add_to_page_cache(page, mapping,
-					       page->index, GFP_KERNEL)) {
-				ret = stuffed_readpage(ip, page);
-				unlock_page(page);
-				if (!pagevec_add(&lru_pvec, page))
-					 __pagevec_lru_add(&lru_pvec);
-			} else {
-				page_cache_release(page);
-			}
-		}
-		pagevec_lru_add(&lru_pvec);
-		ret = 0;
-	} else {
-		/* What we really want to do .... */
+	if (!gfs2_is_stuffed(ip))
 		ret = mpage_readpages(mapping, pages, nr_pages, gfs2_get_block);
-	}
 
 	if (do_unlock) {
 		gfs2_glock_dq_m(1, &gh);
-- 
1.4.4.2



