Return-Path: <linux-kernel-owner+w=401wt.eu-S933250AbZLJHea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250AbZLJHea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933270AbZLJHeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:34:24 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44163 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252AbZLJHeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:34:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH v2  7/8] Try to mark PG_mlocked if wipe_page_reference find VM_LOCKED vma
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>
In-Reply-To: <20091210154822.2550.A69D9226@jp.fujitsu.com>
References: <20091210154822.2550.A69D9226@jp.fujitsu.com>
Message-Id: <20091210163331.2565.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 10 Dec 2009 16:34:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both try_to_unmap() and wipe_page_reference() walk each ptes, but
latter doesn't mark PG_mlocked altough find VM_LOCKED vma.

This patch does it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
---
 mm/rmap.c   |   14 ++++++++++++++
 mm/vmscan.c |    2 ++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 5ae7c81..cfda0a0 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -376,6 +376,7 @@ int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma)
  *
  * SWAP_SUCCESS  - success
  * SWAP_AGAIN    - give up to take lock, try later again
+ * SWAP_MLOCK    - the page is mlocked
  */
 int wipe_page_reference_one(struct page *page,
 			    struct page_reference_context *refctx,
@@ -401,6 +402,7 @@ int wipe_page_reference_one(struct page *page,
 	if (IS_ERR(pte)) {
 		if (PTR_ERR(pte) == -EAGAIN) {
 			ret = SWAP_AGAIN;
+			goto out_mlock;
 		}
 		goto out;
 	}
@@ -430,6 +432,17 @@ int wipe_page_reference_one(struct page *page,
 
 out:
 	return ret;
+
+out_mlock:
+	if (refctx->is_page_locked &&
+	    down_read_trylock(&vma->vm_mm->mmap_sem)) {
+		if (vma->vm_flags & VM_LOCKED) {
+			mlock_vma_page(page);
+			ret = SWAP_MLOCK;
+		}
+		up_read(&vma->vm_mm->mmap_sem);
+	}
+	return ret;
 }
 
 static int wipe_page_reference_anon(struct page *page,
@@ -550,6 +563,7 @@ static int wipe_page_reference_file(struct page *page,
  *
  * SWAP_SUCCESS  - success to wipe all ptes
  * SWAP_AGAIN    - temporary busy, try again later
+ * SWAP_MLOCK    - the page is mlocked
  */
 int wipe_page_reference(struct page *page,
 			struct mem_cgroup *memcg,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c235059..4738a12 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -625,6 +625,8 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		ret = wipe_page_reference(page, sc->mem_cgroup, &refctx);
 		if (ret == SWAP_AGAIN)
 			goto keep_locked;
+		else if (ret == SWAP_MLOCK)
+			goto cull_mlocked;
 		VM_BUG_ON(ret != SWAP_SUCCESS);
 
 		/*
-- 
1.6.5.2



