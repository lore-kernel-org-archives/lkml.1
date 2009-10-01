Return-Path: <linux-kernel-owner+w=401wt.eu-S932615AbZJAOJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbZJAOJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932580AbZJAOJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:09:42 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:50559 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932594AbZJAOJj (ORCPT
	<rfc822;groupwise-SJayaraman@novell.com;0:0>);
	Thu, 1 Oct 2009 10:09:39 -0400
From: Suresh Jayaraman <sjayaraman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Cc: netdev@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Miklos Szeredi <mszeredi@suse.cz>, Wouter Verhelst <w@uter.be>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, trond.myklebust@fys.uio.no,
       Suresh Jayaraman <sjayaraman@suse.de>
Subject: [PATCH 29/31] Cope with racy nature of sync_page in swap_sync_page
Date: Thu,  1 Oct 2009 19:40:45 +0530
Message-Id: <1254406245-16699-1-git-send-email-sjayaraman@suse.de>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

sync_page is called without that PageLock held.  This means that,
for example, PageSwapCache can be cleared at any time.
We need to be careful not to put much trust any any part of the page.

So allow page_swap_info to return NULL of the page is no longer
in a SwapCache, and handle the NULL gracefully in swap_sync_page.

No other calls need to handle the NULL as that all hold PageLock,
so PageSwapCache cannot be cleared by surprise.  Add a WARN_ON to 
document this fact and help find out if I am wrong.

Acked-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---
 mm/page_io.c  |    2 ++
 mm/swapfile.c |    8 +++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

Index: mmotm/mm/page_io.c
===================================================================
--- mmotm.orig/mm/page_io.c
+++ mmotm/mm/page_io.c
@@ -137,6 +137,8 @@ void swap_sync_page(struct page *page)
 {
 	struct swap_info_struct *sis = page_swap_info(page);
 
+	if (!sis)
+		return;
 	if (sis->flags & SWP_FILE) {
 		struct address_space *mapping = sis->swap_file->f_mapping;
 
Index: mmotm/mm/swapfile.c
===================================================================
--- mmotm.orig/mm/swapfile.c
+++ mmotm/mm/swapfile.c
@@ -2185,7 +2185,13 @@ get_swap_info_struct(unsigned type)
 struct swap_info_struct *page_swap_info(struct page *page)
 {
 	swp_entry_t swap = { .val = page_private(page) };
-	BUG_ON(!PageSwapCache(page));
+	if (!PageSwapCache(page) || !swap.val) {
+		/* This should only happen from sync_page.
+		 * In other cases the page should be locked and
+		 * should be in a SwapCache
+		 */
+		return NULL;
+	}
 	return &swap_info[swp_type(swap)];
 }
 
