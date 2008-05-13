Return-Path: <linux-kernel-owner+w=401wt.eu-S1759532AbYEMQFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532AbYEMQFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 12:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758167AbYEMQFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 12:05:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757605AbYEMQFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 12:05:09 -0400
Date: Tue, 13 May 2008 12:04:17 -0400
From: Rik van Riel <riel@redhat.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: [PATCH] take pageout refcount into account for
 remove_exclusive_swap_page
Message-ID: <20080513120417.0833cec1@cuia.bos.redhat.com>
In-Reply-To: <482990FC.3020303@mxp.nes.nec.co.jp>
References: <20080428181835.502876582@redhat.com>
	<20080428181852.620969450@redhat.com>
	<4828283C.4000803@mxp.nes.nec.co.jp>
	<20080512093307.2ace3096@bree.surriel.com>
	<482990FC.3020303@mxp.nes.nec.co.jp>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pageout code takes a reference count to the page, which means
that remove_exclusive_swap_page (when called from the pageout code)
needs to take that extra refcount into account for mapped pages.

Introduces a remove_exclusive_swap_page_ref function to avoid
exposing too much magic to the rest of the VM.

Signed-off-by: Rik van Riel <riel@redhat.com>
Debugged-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

---
Daisuke: thank you for pointing out the problem.  Does this patch look like
a reasonable fix to you?

Andrew: this patch is incremental to my patch
	"[PATCH -mm 05/15] free swap space on swap-in/activation"


Index: linux-2.6.25-mm1/mm/vmscan.c
===================================================================
--- linux-2.6.25-mm1.orig/mm/vmscan.c	2008-05-13 11:59:34.000000000 -0400
+++ linux-2.6.25-mm1/mm/vmscan.c	2008-05-13 11:54:03.000000000 -0400
@@ -621,7 +621,7 @@ free_it:
 activate_locked:
 		/* Not a candidate for swapping, so reclaim swap space. */
 		if (PageSwapCache(page) && vm_swap_full())
-			remove_exclusive_swap_page(page);
+			remove_exclusive_swap_page_ref(page);
 		SetPageActive(page);
 		pgactivate++;
 keep_locked:
Index: linux-2.6.25-mm1/mm/swap.c
===================================================================
--- linux-2.6.25-mm1.orig/mm/swap.c	2008-05-13 11:59:34.000000000 -0400
+++ linux-2.6.25-mm1/mm/swap.c	2008-05-13 11:53:47.000000000 -0400
@@ -455,7 +455,7 @@ void pagevec_swap_free(struct pagevec *p
 
 		if (PageSwapCache(page) && !TestSetPageLocked(page)) {
 			if (PageSwapCache(page))
-				remove_exclusive_swap_page(page);
+				remove_exclusive_swap_page_ref(page);
 			unlock_page(page);
 		}
 	}
Index: linux-2.6.25-mm1/include/linux/swap.h
===================================================================
--- linux-2.6.25-mm1.orig/include/linux/swap.h	2008-05-13 11:20:46.000000000 -0400
+++ linux-2.6.25-mm1/include/linux/swap.h	2008-05-13 11:47:31.000000000 -0400
@@ -266,6 +266,7 @@ extern sector_t swapdev_block(int, pgoff
 extern struct swap_info_struct *get_swap_info_struct(unsigned);
 extern int can_share_swap_page(struct page *);
 extern int remove_exclusive_swap_page(struct page *);
+extern int remove_exclusive_swap_page_ref(struct page *);
 struct backing_dev_info;
 
 extern spinlock_t swap_lock;
Index: linux-2.6.25-mm1/mm/swapfile.c
===================================================================
--- linux-2.6.25-mm1.orig/mm/swapfile.c	2008-04-22 10:33:45.000000000 -0400
+++ linux-2.6.25-mm1/mm/swapfile.c	2008-05-13 11:53:32.000000000 -0400
@@ -343,7 +343,7 @@ int can_share_swap_page(struct page *pag
  * Work out if there are any other processes sharing this
  * swap cache page. Free it if you can. Return success.
  */
-int remove_exclusive_swap_page(struct page *page)
+static int remove_exclusive_swap_page_count(struct page *page, int count)
 {
 	int retval;
 	struct swap_info_struct * p;
@@ -356,7 +356,7 @@ int remove_exclusive_swap_page(struct pa
 		return 0;
 	if (PageWriteback(page))
 		return 0;
-	if (page_count(page) != 2) /* 2: us + cache */
+	if (page_count(page) != count) /* 2: us + cache */
 		return 0;
 
 	entry.val = page_private(page);
@@ -369,7 +369,7 @@ int remove_exclusive_swap_page(struct pa
 	if (p->swap_map[swp_offset(entry)] == 1) {
 		/* Recheck the page count with the swapcache lock held.. */
 		write_lock_irq(&swapper_space.tree_lock);
-		if ((page_count(page) == 2) && !PageWriteback(page)) {
+		if ((page_count(page) == count) && !PageWriteback(page)) {
 			__delete_from_swap_cache(page);
 			SetPageDirty(page);
 			retval = 1;
@@ -387,6 +387,25 @@ int remove_exclusive_swap_page(struct pa
 }
 
 /*
+ * Most of the time the page should have two references: one for the
+ * process and one for the swap cache.
+ */
+int remove_exclusive_swap_page(struct page *page)
+{
+	return remove_exclusive_swap_page_count(page, 2);
+}
+
+/*
+ * The pageout code holds an extra reference to the page.  That raises
+ * the reference count to test for to 2 for a page that is only in the
+ * swap cache and 3 for a page that is mapped by a process.
+ */
+int remove_exclusive_swap_page_ref(struct page *page)
+{
+	return remove_exclusive_swap_page_count(page, 2 + page_mapped(page));
+}
+
+/*
  * Free the swap entry like above, but also try to
  * free the page cache entry if it is the last user.
  */

All Rights Reversed
