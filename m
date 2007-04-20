Return-Path: <linux-kernel-owner+w=401wt.eu-S1767247AbXDTUe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767247AbXDTUe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 16:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767246AbXDTUeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 16:34:16 -0400
Received: from dh166.citi.umich.edu ([141.211.133.166]:47385 "EHLO
	heimdal.trondhjem.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767248AbXDTUeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 16:34:10 -0400
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 4/5] NFS: Fix race in nfs_set_page_dirty
Date: Fri, 20 Apr 2007 16:12:50 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Florin Iucha <florin@iucha.net>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Chuck Lever <chuck.lever@oracle.com>, linux-kernel@vger.kernel.org,
       nfs@lists.sourceforge.net
Message-Id: <20070420201250.7897.77055.stgit@heimdal.trondhjem.org>
In-Reply-To: <20070420200358.7897.75870.stgit@heimdal.trondhjem.org>
References: <20070420200358.7897.75870.stgit@heimdal.trondhjem.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

Protect nfs_set_page_dirty() against races with nfs_inode_add_request.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/write.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index ce5b4a9..7975589 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -388,6 +388,8 @@ static int nfs_inode_add_request(struct inode *inode, struct nfs_page *req)
 	}
 	SetPagePrivate(req->wb_page);
 	set_page_private(req->wb_page, (unsigned long)req);
+	if (PageDirty(req->wb_page))
+		set_bit(PG_NEED_FLUSH, &req->wb_flags);
 	nfsi->npages++;
 	atomic_inc(&req->wb_count);
 	return 0;
@@ -407,6 +409,8 @@ static void nfs_inode_remove_request(struct nfs_page *req)
 	set_page_private(req->wb_page, 0);
 	ClearPagePrivate(req->wb_page);
 	radix_tree_delete(&nfsi->nfs_page_tree, req->wb_index);
+	if (test_and_clear_bit(PG_NEED_FLUSH, &req->wb_flags))
+		__set_page_dirty_nobuffers(req->wb_page);
 	nfsi->npages--;
 	if (!nfsi->npages) {
 		spin_unlock(&nfsi->req_lock);
@@ -1527,15 +1531,22 @@ int nfs_wb_page(struct inode *inode, struct page* page)
 
 int nfs_set_page_dirty(struct page *page)
 {
+	spinlock_t *req_lock = &NFS_I(page->mapping->host)->req_lock;
 	struct nfs_page *req;
+	int ret;
 
-	req = nfs_page_find_request(page);
+	spin_lock(req_lock);
+	req = nfs_page_find_request_locked(page);
 	if (req != NULL) {
 		/* Mark any existing write requests for flushing */
-		set_bit(PG_NEED_FLUSH, &req->wb_flags);
+		ret = !test_and_set_bit(PG_NEED_FLUSH, &req->wb_flags);
+		spin_unlock(req_lock);
 		nfs_release_request(req);
+		return ret;
 	}
-	return __set_page_dirty_nobuffers(page);
+	ret = __set_page_dirty_nobuffers(page);
+	spin_unlock(req_lock);
+	return ret;
 }
 
 
