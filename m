Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbXJ3Q02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbXJ3Q02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 12:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbXJ3QQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 12:16:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbXJ3QNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 12:13:40 -0400
Message-Id: <20071030160916.021029000@chello.nl>
References: <20071030160401.296770000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 30 Oct 2007 17:04:34 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 33/33] nfs: do not warn on radix tree node allocation failures
Content-Disposition: inline; filename=nfs_radix_nowarn.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

GFP_ATOMIC failures are rather common, no not warn about them.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/nfs/inode.c |    2 +-
 fs/nfs/write.c |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/nfs/inode.c
===================================================================
--- linux-2.6.orig/fs/nfs/inode.c
+++ linux-2.6/fs/nfs/inode.c
@@ -1172,7 +1172,7 @@ static void init_once(struct kmem_cache 
 	INIT_LIST_HEAD(&nfsi->open_files);
 	INIT_LIST_HEAD(&nfsi->access_cache_entry_lru);
 	INIT_LIST_HEAD(&nfsi->access_cache_inode_lru);
-	INIT_RADIX_TREE(&nfsi->nfs_page_tree, GFP_ATOMIC);
+	INIT_RADIX_TREE(&nfsi->nfs_page_tree, GFP_ATOMIC|__GFP_NOWARN);
 	nfsi->ncommit = 0;
 	nfsi->npages = 0;
 	nfs4_init_once(nfsi);
Index: linux-2.6/fs/nfs/write.c
===================================================================
--- linux-2.6.orig/fs/nfs/write.c
+++ linux-2.6/fs/nfs/write.c
@@ -652,6 +652,7 @@ static struct nfs_page * nfs_update_requ
 	struct inode *inode = mapping->host;
 	struct nfs_page		*req, *new = NULL;
 	pgoff_t		rqend, end;
+	int error;
 
 	end = offset + bytes;
 
@@ -659,6 +660,10 @@ static struct nfs_page * nfs_update_requ
 		/* Loop over all inode entries and see if we find
 		 * A request for the page we wish to update
 		 */
+		error = radix_tree_preload(GFP_NOIO);
+		if (error)
+			return ERR_PTR(error);
+
 		spin_lock(&inode->i_lock);
 		req = nfs_page_find_request_locked(NFS_I(inode), page);
 		if (req) {
@@ -666,6 +671,7 @@ static struct nfs_page * nfs_update_requ
 				int error;
 
 				spin_unlock(&inode->i_lock);
+				radix_tree_preload_end();
 				error = nfs_wait_on_request(req);
 				nfs_release_request(req);
 				if (error < 0) {
@@ -676,6 +682,7 @@ static struct nfs_page * nfs_update_requ
 				continue;
 			}
 			spin_unlock(&inode->i_lock);
+			radix_tree_preload_end();
 			if (new)
 				nfs_release_request(new);
 			break;
@@ -687,13 +694,16 @@ static struct nfs_page * nfs_update_requ
 			error = nfs_inode_add_request(inode, new);
 			if (error) {
 				spin_unlock(&inode->i_lock);
+				radix_tree_preload_end();
 				nfs_unlock_request(new);
 				return ERR_PTR(error);
 			}
 			spin_unlock(&inode->i_lock);
+			radix_tree_preload_end();
 			return new;
 		}
 		spin_unlock(&inode->i_lock);
+		radix_tree_preload_end();
 
 		new = nfs_create_request(ctx, inode, page, offset, bytes);
 		if (IS_ERR(new))

--

