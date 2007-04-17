Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbXDQHWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbXDQHWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbXDQHWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:22:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbXDQHWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:22:51 -0400
Message-Id: <20070417071703.710381113@chello.nl>
References: <20070417071046.318415445@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 17 Apr 2007 09:10:55 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
Subject: [PATCH 09/12] mm: count unstable pages per BDI
Content-Disposition: inline; filename=bdi_stat_unstable.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Count per BDI unstable pages.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/nfs/write.c              |    4 ++++
 include/linux/backing-dev.h |    1 +
 2 files changed, 5 insertions(+)

Index: linux-2.6-mm/fs/nfs/write.c
===================================================================
--- linux-2.6-mm.orig/fs/nfs/write.c
+++ linux-2.6-mm/fs/nfs/write.c
@@ -449,6 +449,7 @@ nfs_mark_request_commit(struct nfs_page 
 	nfsi->ncommit++;
 	spin_unlock(&nfsi->req_lock);
 	inc_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
+	inc_bdi_stat(req->wb_page->mapping->backing_dev_info, BDI_UNSTABLE);
 	__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
 }
 #endif
@@ -509,6 +510,7 @@ static void nfs_cancel_commit_list(struc
 	while(!list_empty(head)) {
 		req = nfs_list_entry(head->next);
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
+		dec_bdi_stat(req->wb_page->mapping->backing_dev_info, BDI_UNSTABLE);
 		nfs_list_remove_request(req);
 		nfs_inode_remove_request(req);
 		nfs_unlock_request(req);
@@ -1234,6 +1236,7 @@ nfs_commit_list(struct inode *inode, str
 		nfs_list_remove_request(req);
 		nfs_mark_request_commit(req);
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
+		dec_bdi_stat(req->wb_page->mapping->backing_dev_info, BDI_UNSTABLE);
 		nfs_clear_page_writeback(req);
 	}
 	return -ENOMEM;
@@ -1258,6 +1261,7 @@ static void nfs_commit_done(struct rpc_t
 		req = nfs_list_entry(data->pages.next);
 		nfs_list_remove_request(req);
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
+		dec_bdi_stat(req->wb_page->mapping->backing_dev_info, BDI_UNSTABLE);
 
 		dprintk("NFS: commit (%s/%Ld %d@%Ld)",
 			req->wb_context->dentry->d_inode->i_sb->s_id,
Index: linux-2.6-mm/include/linux/backing-dev.h
===================================================================
--- linux-2.6-mm.orig/include/linux/backing-dev.h
+++ linux-2.6-mm/include/linux/backing-dev.h
@@ -28,6 +28,7 @@ typedef int (congested_fn)(void *, int);
 enum bdi_stat_item {
 	BDI_DIRTY,
 	BDI_WRITEBACK,
+	BDI_UNSTABLE,
 	NR_BDI_STAT_ITEMS
 };
 

-- 

