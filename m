Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbYKGL6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbYKGL6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 06:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbYKGL6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 06:58:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:5100 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbYKGL6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 06:58:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,564,1220252400"; 
   d="scan'208";a="357311741"
From: Maciej Sosnowski <maciej.sosnowski@intel.com>
Subject: [PATCH 2/4] I/OAT: fix dma_pin_iovec_pages() error handling
To: dan.j.williams@intel.com
Cc: tom.s.picard@intel.com, mark_rustad@Xiotech.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, stable@kernel.org
Date: Fri, 07 Nov 2008 12:46:33 +0100
Message-ID: <20081107114601.25190.27126.stgit@linux.site>
In-Reply-To: <20081107114325.25190.5419.stgit@linux.site>
References: <20081107114325.25190.5419.stgit@linux.site>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maciej Sosnowski <maciej.sosnowski@intel.com>

Error handling needs to be modified in dma_pin_iovec_pages().
It should return NULL instead of ERR_PTR
(pinned_list is checked for NULL in tcp_recvmsg() to determine
if iovec pages have been successfully pinned down).
In case of error for the first iovec,
local_list->nr_iovecs needs to be initialized.

Cc: <stable@kernel.org>
Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
---

 drivers/dma/iovlock.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/iovlock.c b/drivers/dma/iovlock.c
index e763d72..9f6fe46 100644
--- a/drivers/dma/iovlock.c
+++ b/drivers/dma/iovlock.c
@@ -55,7 +55,6 @@ struct dma_pinned_list *dma_pin_iovec_pa
 	int nr_iovecs = 0;
 	int iovec_len_used = 0;
 	int iovec_pages_used = 0;
-	long err;
 
 	/* don't pin down non-user-based iovecs */
 	if (segment_eq(get_fs(), KERNEL_DS))
@@ -72,23 +71,21 @@ struct dma_pinned_list *dma_pin_iovec_pa
 	local_list = kmalloc(sizeof(*local_list)
 		+ (nr_iovecs * sizeof (struct dma_page_list))
 		+ (iovec_pages_used * sizeof (struct page*)), GFP_KERNEL);
-	if (!local_list) {
-		err = -ENOMEM;
+	if (!local_list)
 		goto out;
-	}
 
 	/* list of pages starts right after the page list array */
 	pages = (struct page **) &local_list->page_list[nr_iovecs];
 
+	local_list->nr_iovecs = 0;
+
 	for (i = 0; i < nr_iovecs; i++) {
 		struct dma_page_list *page_list = &local_list->page_list[i];
 
 		len -= iov[i].iov_len;
 
-		if (!access_ok(VERIFY_WRITE, iov[i].iov_base, iov[i].iov_len)) {
-			err = -EFAULT;
+		if (!access_ok(VERIFY_WRITE, iov[i].iov_base, iov[i].iov_len))
 			goto unpin;
-		}
 
 		page_list->nr_pages = num_pages_spanned(&iov[i]);
 		page_list->base_address = iov[i].iov_base;
@@ -109,10 +106,8 @@ struct dma_pinned_list *dma_pin_iovec_pa
 			NULL);
 		up_read(&current->mm->mmap_sem);
 
-		if (ret != page_list->nr_pages) {
-			err = -ENOMEM;
+		if (ret != page_list->nr_pages)
 			goto unpin;
-		}
 
 		local_list->nr_iovecs = i + 1;
 	}
@@ -122,7 +117,7 @@ struct dma_pinned_list *dma_pin_iovec_pa
 unpin:
 	dma_unpin_iovec_pages(local_list);
 out:
-	return ERR_PTR(err);
+	return NULL;
 }
 
 void dma_unpin_iovec_pages(struct dma_pinned_list *pinned_list)

