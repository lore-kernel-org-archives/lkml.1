Return-Path: <linux-kernel-owner+w=401wt.eu-S1758929AbYD0CZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929AbYD0CZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 22:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbYD0CZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 22:25:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:31254 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbYD0CZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 22:25:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:message-id;
        b=J9KJAF9cUpV0bq4SWHQ+784qMU7ENRG3rVh305K39XJFylzUX8XMxVDtKcSmKNRHB4WEgGfd7nPw7IT++Pm4NOOvx4D9/1UeFWNPxjFp5o/BSWlNBrUXuzowqqdSXV38IfJ3RiHqa7nJW40YludSbs+uiLaZb2sBp4/qp8nhwLQ=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Chinner <dgc@sgi.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] vfs: reduce stack usage in write_cache_pages()
Date: Sun, 27 Apr 2008 04:24:10 +0200
User-Agent: KMail/1.8.2
Cc: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_KP+EIUHH3dxBdol"
Message-Id: <200804270424.10343.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_KP+EIUHH3dxBdol
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Al, David,

vfs function write_cache_pages() appears on the xfs
writeout path. It's *the* path which causes 4k stack
overflows on i386 with xfs.

This function uses ~100 bytes of stack on 32-bit i386.

This patch transforms it a little so that it uses
a bit less stack - minus 8 bytes to be precise.

This isn't much, but it helps not only xfs,
but all filesystems.

Only compile tested.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_KP+EIUHH3dxBdol
Content-Type: text/x-diff;
  charset="us-ascii";
  name="stk3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="stk3.diff"

diff -urpN linux-2.6-xfs1/mm/page-writeback.c linux-2.6-xfs1.stk3/mm/page-writeback.c
--- linux-2.6-xfs1/mm/page-writeback.c	2008-03-30 03:27:55.000000000 +0200
+++ linux-2.6-xfs1.stk3/mm/page-writeback.c	2008-04-27 04:14:39.000000000 +0200
@@ -798,17 +798,14 @@ int write_cache_pages(struct address_spa
 		      struct writeback_control *wbc, writepage_t writepage,
 		      void *data)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	int ret = 0;
 	int done = 0;
 	struct pagevec pvec;
-	int nr_pages;
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	int scanned = 0;
-	int range_whole = 0;
 
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
+	if (wbc->nonblocking && bdi_write_congested(mapping->backing_dev_info)) {
 		wbc->encountered_congestion = 1;
 		return 0;
 	}
@@ -820,20 +817,30 @@ int write_cache_pages(struct address_spa
 	} else {
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
-		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
-			range_whole = 1;
 		scanned = 1;
 	}
+
+	/* Minimizing stack use:
+	 * "nr_pages" hopefully won't require a stack slot -
+	 * we reuse "scanned" to keep its value.
+	 */
+
 retry:
-	while (!done && (index <= end) &&
-	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-					      PAGECACHE_TAG_DIRTY,
-					      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
+	while (!done && (index <= end)) {
 		unsigned i;
+		int nr_pages;
 
-		scanned = 1;
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
+		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+					      PAGECACHE_TAG_DIRTY,
+					      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
+		if (!nr_pages)
+			break;
+		scanned = nr_pages;
+		/* "scanned" counts down to 1, and later acts as nonzero flag */
+
+		i = (unsigned)-1;
+		while (1) { /* for i in [0..nr_pages-1] */
+			struct page *page = pvec.pages[++i];
 
 			/*
 			 * At this point we hold neither mapping->tree_lock nor
@@ -872,10 +879,13 @@ retry:
 			}
 			if (ret || (--(wbc->nr_to_write) <= 0))
 				done = 1;
-			if (wbc->nonblocking && bdi_write_congested(bdi)) {
+			if (wbc->nonblocking && bdi_write_congested(mapping->backing_dev_info)) {
 				wbc->encountered_congestion = 1;
 				done = 1;
 			}
+			if (scanned == 1)
+				break;
+			scanned--;
 		}
 		pagevec_release(&pvec);
 		cond_resched();
@@ -889,7 +899,8 @@ retry:
 		index = 0;
 		goto retry;
 	}
-	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
+	if (wbc->range_cyclic || (wbc->range_start == 0 && wbc->range_end == LLONG_MAX /* whole range */
+	                         && wbc->nr_to_write > 0))
 		mapping->writeback_index = index;
 	return ret;
 }

--Boundary-00=_KP+EIUHH3dxBdol--
