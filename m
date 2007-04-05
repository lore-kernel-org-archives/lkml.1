Return-Path: <linux-kernel-owner+w=401wt.eu-S1767175AbXDESDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767175AbXDESDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 14:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767182AbXDESC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 14:02:59 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:27347 "EHLO
	amsfep13-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1767175AbXDESCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 14:02:30 -0400
Message-Id: <20070405174318.741850566@programming.kicks-ass.net>
References: <20070405174209.498059336@programming.kicks-ass.net>
User-Agent: quilt/0.45-1
Date: Thu, 05 Apr 2007 19:42:14 +0200
From: root@programming.kicks-ass.net
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com
Subject: [PATCH 05/12] mm: count unstable pages per BDI
Content-Disposition: inline; filename=bdi_stat_unstable.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Count per BDI unstable pages.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/nfs/write.c              |    4 ++++
 include/linux/backing-dev.h |    1 +
 2 files changed, 5 insertions(+)

Index: linux-2.6/fs/nfs/write.c
===================================================================
--- linux-2.6.orig/fs/nfs/write.c
+++ linux-2.6/fs/nfs/write.c
@@ -451,6 +451,7 @@ nfs_mark_request_commit(struct nfs_page 
 	nfsi->ncommit++;
 	spin_unlock(&nfsi->req_lock);
 	inc_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
+	inc_bdi_stat(req->wb_page->mapping->backing_dev_info, BDI_UNSTABLE);
 	__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
 }
 #endif
@@ -511,6 +512,7 @@ static void nfs_cancel_commit_list(struc
 	while(!list_empty(head)) {
 		req = nfs_list_entry(head->next);
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
+		dec_bdi_stat(req->wb_page->mapping->backing_dev_info, BDI_UNSTABLE);
 		nfs_list_remove_request(req);
 		nfs_inode_remove_request(req);
 		nfs_unlock_request(req);
@@ -1236,6 +1238,7 @@ nfs_commit_list(struct inode *inode, str
 		nfs_list_remove_request(req);
 		nfs_mark_request_commit(req);
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
+		dec_bdi_stat(req->wb_page->mapping->backing_dev_info, BDI_UNSTABLE);
 		nfs_clear_page_writeback(req);
 	}
 	return -ENOMEM;
@@ -1260,6 +1263,7 @@ static void nfs_commit_done(struct rpc_t
 		req = nfs_list_entry(data->pages.next);
 		nfs_list_remove_request(req);
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
+		dec_bdi_stat(req->wb_page->mapping->backing_dev_info, BDI_UNSTABLE);
 
 		dprintk("NFS: commit (%s/%Ld %d@%Ld)",
 			req->wb_context->dentry->d_inode->i_sb->s_id,
Index: linux-2.6/include/linux/backing-dev.h
===================================================================
--- linux-2.6.orig/include/linux/backing-dev.h
+++ linux-2.6/include/linux/backing-dev.h
@@ -26,6 +26,7 @@ enum bdi_state {
 enum bdi_stat_item {
 	BDI_DIRTY,
 	BDI_WRITEBACK,
+	BDI_UNSTABLE,
 	NR_BDI_STAT_ITEMS
 };
 

--

