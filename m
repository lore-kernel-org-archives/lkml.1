Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935663Ab0CMAol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:44:41 -0500
Received: from kroah.org ([198.145.64.141]:47209 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935552Ab0CMAcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:32:31 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:16 2010
Message-Id: <20100313002716.650031704@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:27:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Maarten Maathuis <madman2003@gmail.com>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Dave Airlie <airlied@redhat.com>
Subject: [131/145] drm/ttm: handle OOM in ttm_tt_swapout
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Maarten Maathuis <madman2003@gmail.com>

commit 290e55056ec3d25c72088628245d8cae037b30db upstream.

- Without this change I get a general protection fault.
- Also use PTR_ERR where applicable.

Signed-off-by: Maarten Maathuis <madman2003@gmail.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Acked-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/ttm/ttm_tt.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -466,7 +466,7 @@ static int ttm_tt_swapin(struct ttm_tt *
 	void *from_virtual;
 	void *to_virtual;
 	int i;
-	int ret;
+	int ret = -ENOMEM;
 
 	if (ttm->page_flags & TTM_PAGE_FLAG_USER) {
 		ret = ttm_tt_set_user(ttm, ttm->tsk, ttm->start,
@@ -485,8 +485,10 @@ static int ttm_tt_swapin(struct ttm_tt *
 
 	for (i = 0; i < ttm->num_pages; ++i) {
 		from_page = read_mapping_page(swap_space, i, NULL);
-		if (IS_ERR(from_page))
+		if (IS_ERR(from_page)) {
+			ret = PTR_ERR(from_page);
 			goto out_err;
+		}
 		to_page = __ttm_tt_get_page(ttm, i);
 		if (unlikely(to_page == NULL))
 			goto out_err;
@@ -509,7 +511,7 @@ static int ttm_tt_swapin(struct ttm_tt *
 	return 0;
 out_err:
 	ttm_tt_free_alloced_pages(ttm);
-	return -ENOMEM;
+	return ret;
 }
 
 int ttm_tt_swapout(struct ttm_tt *ttm, struct file *persistant_swap_storage)
@@ -521,6 +523,7 @@ int ttm_tt_swapout(struct ttm_tt *ttm, s
 	void *from_virtual;
 	void *to_virtual;
 	int i;
+	int ret = -ENOMEM;
 
 	BUG_ON(ttm->state != tt_unbound && ttm->state != tt_unpopulated);
 	BUG_ON(ttm->caching_state != tt_cached);
@@ -543,7 +546,7 @@ int ttm_tt_swapout(struct ttm_tt *ttm, s
 						0);
 		if (unlikely(IS_ERR(swap_storage))) {
 			printk(KERN_ERR "Failed allocating swap storage.\n");
-			return -ENOMEM;
+			return PTR_ERR(swap_storage);
 		}
 	} else
 		swap_storage = persistant_swap_storage;
@@ -555,9 +558,10 @@ int ttm_tt_swapout(struct ttm_tt *ttm, s
 		if (unlikely(from_page == NULL))
 			continue;
 		to_page = read_mapping_page(swap_space, i, NULL);
-		if (unlikely(to_page == NULL))
+		if (unlikely(IS_ERR(to_page))) {
+			ret = PTR_ERR(to_page);
 			goto out_err;
-
+		}
 		preempt_disable();
 		from_virtual = kmap_atomic(from_page, KM_USER0);
 		to_virtual = kmap_atomic(to_page, KM_USER1);
@@ -581,5 +585,5 @@ out_err:
 	if (!persistant_swap_storage)
 		fput(swap_storage);
 
-	return -ENOMEM;
+	return ret;
 }


