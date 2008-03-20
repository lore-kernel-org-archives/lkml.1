Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbYCTSxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbYCTSxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 14:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYCTSxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 14:53:09 -0400
Received: from mx2.netapp.com ([216.240.18.37]:24279 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbYCTSxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 14:53:08 -0400
X-IronPort-AV: E=Sophos;i="4.25,532,1199692800"; 
   d="scan'208";a="12786716"
Subject: [GIT] Please pull another NFS client fix for 2.6.25...
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Thu, 20 Mar 2008 14:53:03 -0400
Message-Id: <1206039185.15027.21.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 20 Mar 2008 18:53:07.0491 (UTC) FILETIME=[A2CCD730:01C88ABB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the "hotfixes" branch of the repository at

   git pull git://git.linux-nfs.org/projects/trondmy/nfs-2.6.git hotfixes

This will update the following files through the appended changesets.

  Cheers,
    Trond

----
 fs/nfs/read.c  |    5 ++++-
 fs/nfs/write.c |    8 +++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

commit f8512ad0da16cbe156f3a7627971cdf0b39c4138
Author: Fred Isaman <iisaman@citi.umich.edu>
Date:   Wed Mar 19 11:24:39 2008 -0400

    nfs: don't ignore return value from nfs_pageio_add_request
    
    Ignoring the return value from nfs_pageio_add_request can cause deadlocks.
    
    In read path:
      call nfs_pageio_add_request from readpage_async_filler
      assume at this point that there are requests already in desc, that
        can't be merged with the current request.
      so nfs_pageio_doio is fired up to clear out desc.
      assume something goes wrong in setting up the io, so desc->pg_error is set.
      This causes nfs_pageio_add_request to return 0, *WITHOUT* adding the original
        request.
      BUT, since return code is ignored, readpage_async_filler assumes it has
        been added, and does nothing further, leaving page locked.
      do_generic_mapping_read will eventually call lock_page, resulting in deadlock
    
    In write path:
      page is marked dirty by generic_perform_write
      nfs_writepages is called
      call nfs_pageio_add_request from nfs_page_async_flush
      assume at this point that there are requests already in desc, that
        can't be merged with the current request.
      so nfs_pageio_doio is fired up to clear out desc.
      assume something goes wrong in setting up the io, so desc->pg_error is set.
      This causes nfs_page_async_flush to return 0, *WITHOUT* adding the original
        request, yet marking the request as locked (PG_BUSY) and in writeback,
        clearing dirty marks.
      The next time a write is done to the page, deadlock will result as
        nfs_write_end calls nfs_update_request
    
    Signed-off-by: Fred Isaman <iisaman@citi.umich.edu>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 3d7d963..5a70be5 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -533,7 +533,10 @@ readpage_async_filler(void *data, struct page *page)
 
 	if (len < PAGE_CACHE_SIZE)
 		zero_user_segment(page, len, PAGE_CACHE_SIZE);
-	nfs_pageio_add_request(desc->pgio, new);
+	if (!nfs_pageio_add_request(desc->pgio, new)) {
+		error = desc->pgio->pg_error;
+		goto out_unlock;
+	}
 	return 0;
 out_error:
 	error = PTR_ERR(new);
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 80c61fd..bed6341 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -39,6 +39,7 @@ static struct nfs_page * nfs_update_request(struct nfs_open_context*,
 					    unsigned int, unsigned int);
 static void nfs_pageio_init_write(struct nfs_pageio_descriptor *desc,
 				  struct inode *inode, int ioflags);
+static void nfs_redirty_request(struct nfs_page *req);
 static const struct rpc_call_ops nfs_write_partial_ops;
 static const struct rpc_call_ops nfs_write_full_ops;
 static const struct rpc_call_ops nfs_commit_ops;
@@ -288,7 +289,12 @@ static int nfs_page_async_flush(struct nfs_pageio_descriptor *pgio,
 		BUG();
 	}
 	spin_unlock(&inode->i_lock);
-	nfs_pageio_add_request(pgio, req);
+	if (!nfs_pageio_add_request(pgio, req)) {
+		nfs_redirty_request(req);
+		nfs_end_page_writeback(page);
+		nfs_clear_page_tag_locked(req);
+		return pgio->pg_error;
+	}
 	return 0;
 }
 

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
