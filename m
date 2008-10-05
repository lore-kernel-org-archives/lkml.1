Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbYJEWRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbYJEWRq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 18:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbYJEWRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 18:17:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbYJEWRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 18:17:37 -0400
Date: Sun, 5 Oct 2008 18:16:59 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, agk@redhat.com, mbroz@redhat.com,
       chris@arachsys.com
Subject: [PATCH 3/3] Fix fsync-vs-write misbehavior
In-Reply-To: <20081001225404.4e973465.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0810051814540.23248@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
 <Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com>
 <20080923154905.50d4b0fa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0809231902010.19496@hs20-bc2-1.build.redhat.com>
 <20080923164623.ce82c1c2.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0809241451320.18811@hs20-bc2-1.build.redhat.com>
 <20081001225404.4e973465.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix violation of sync()/fsync() semantics. Previous code walked up to
mapping->nrpages * 2 pages. Because pages could be created while
__filemap_fdatawrite_range was in progress, it could lead to a
misbehavior.  Example: there are two pages in address space with indices
4, 5. Both are dirty.  Someone calls __filemap_fdatawrite_range, it sets
.nr_to_write = 4.  Meanwhile, some other process creates dirty pages 0,
1, 2, 3.  __filemap_fdatawrite_range writes pages 0, 1, 2, 3, finds out
that it reached the limit and exits.

Result: pages that were dirty before __filemap_fdatawrite_range was
invoked were not written.

With starvation protection from the previous patch, this
mapping->nrpages * 2 logic is no longer needed.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 mm/filemap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6.27-rc7-devel/mm/filemap.c
===================================================================
--- linux-2.6.27-rc7-devel.orig/mm/filemap.c	2008-09-24 14:47:01.000000000 +0200
+++ linux-2.6.27-rc7-devel/mm/filemap.c	2008-09-24 15:01:23.000000000 +0200
@@ -202,6 +202,11 @@ static int sync_page_killable(void *word
  * opposed to a regular memory cleansing writeback.  The difference between
  * these two operations is that if a dirty page/buffer is encountered, it must
  * be waited upon, and not just skipped over.
+ *
+ * Because new pages dirty can be created while this is executing, that
+ * mapping->nrpages * 2 condition is unsafe. If we are doing data integrity
+ * write, we must write all the pages. AS_STARVATION bit will eventually prevent
+ * creating more dirty pages to avoid starvation.
  */
 int __filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
 				loff_t end, int sync_mode)
@@ -209,7 +214,7 @@ int __filemap_fdatawrite_range(struct ad
 	int ret;
 	struct writeback_control wbc = {
 		.sync_mode = sync_mode,
-		.nr_to_write = mapping->nrpages * 2,
+		.nr_to_write = sync_mode == WB_SYNC_NONE ? mapping->nrpages * 2 : LONG_MAX,
 		.range_start = start,
 		.range_end = end,
 	};
