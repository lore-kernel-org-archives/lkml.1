Return-Path: <linux-kernel-owner+w=401wt.eu-S1762284AbXJQNlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762284AbXJQNlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 09:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbXJQNlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 09:41:02 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57133 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbXJQNlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 09:41:01 -0400
Subject: [PATCH] nfs: fix nfs_writepage()
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 15:40:58 +0200
Message-Id: <1192628458.27435.119.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that ->writepage() didn't actually do anything since it
doesn't generate a write request for the given page.

The below is an attempt at fixing it, and it works for me. Although I'm
not quite sure its the proper fix.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/nfs/write.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

Index: linux-2.6/fs/nfs/write.c
===================================================================
--- linux-2.6.orig/fs/nfs/write.c
+++ linux-2.6/fs/nfs/write.c
@@ -332,10 +332,30 @@ static int nfs_page_async_flush(struct n
 static int nfs_do_writepage(struct page *page, struct writeback_control *wbc, struct nfs_pageio_descriptor *pgio)
 {
 	struct inode *inode = page_file_mapping(page)->host;
+	struct rpc_cred *cred;
+	struct nfs_open_context *ctx;
+	int status;
 
 	nfs_inc_stats(inode, NFSIOS_VFSWRITEPAGE);
 	nfs_add_stats(inode, NFSIOS_WRITEPAGES, 1);
 
+	cred = rpcauth_lookupcred(NFS_CLIENT(inode)->cl_auth, 0);
+	if (IS_ERR(cred))
+		return PTR_ERR(cred);
+
+	ctx = nfs_find_open_context(inode, cred, FMODE_WRITE);
+	if (!ctx)
+		return -EBADF;
+
+	status = nfs_writepage_setup(ctx, page, 0, nfs_page_length(page));
+
+	put_nfs_open_context(ctx);
+
+	if (status < 0) {
+		nfs_set_pageerror(page);
+		return status;
+	}
+
 	nfs_pageio_cond_complete(pgio, page_file_index(page));
 	return nfs_page_async_flush(pgio, page);
 }


