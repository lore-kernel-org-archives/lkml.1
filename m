Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbXJ3QQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbXJ3QQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 12:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbXJ3QOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 12:14:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010AbXJ3QN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 12:13:56 -0400
Message-Id: <20071030160915.636328000@chello.nl>
References: <20071030160401.296770000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 30 Oct 2007 17:04:31 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 30/33] nfs: swap vs nfs_writepage
Content-Disposition: inline; filename=nfs-fix-writepage.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For now just use the ->writepage() path for swap traffic. Trond would like
to see ->swap_page() or some such additional a_op.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/nfs/write.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

Index: linux-2.6/fs/nfs/write.c
===================================================================
--- linux-2.6.orig/fs/nfs/write.c
+++ linux-2.6/fs/nfs/write.c
@@ -336,6 +336,29 @@ static int nfs_do_writepage(struct page 
 	nfs_inc_stats(inode, NFSIOS_VFSWRITEPAGE);
 	nfs_add_stats(inode, NFSIOS_WRITEPAGES, 1);
 
+	if (unlikely(IS_SWAPFILE(inode))) {
+		struct rpc_cred *cred;
+		struct nfs_open_context *ctx;
+		int status;
+
+		cred = rpcauth_lookupcred(NFS_CLIENT(inode)->cl_auth, 0);
+		if (IS_ERR(cred))
+			return PTR_ERR(cred);
+
+		ctx = nfs_find_open_context(inode, cred, FMODE_WRITE);
+		if (!ctx)
+			return -EBADF;
+
+		status = nfs_writepage_setup(ctx, page, 0, nfs_page_length(page));
+
+		put_nfs_open_context(ctx);
+
+		if (status < 0) {
+			nfs_set_pageerror(page);
+			return status;
+		}
+	}
+
 	nfs_pageio_cond_complete(pgio, page->index);
 	return nfs_page_async_flush(pgio, page);
 }

--

