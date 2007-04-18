Return-Path: <linux-kernel-owner+w=401wt.eu-S1161430AbXDRBsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161430AbXDRBsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 21:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161436AbXDRBsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 21:48:10 -0400
Received: from c-69-242-210-120.hsd1.mi.comcast.net ([69.242.210.120]:57967
	"EHLO heimdal.trondhjem.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161430AbXDRBsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 21:48:07 -0400
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 2/4] NFS: Don't clear PG_writeback until after we've processed unstable writes
Date: Tue, 17 Apr 2007 21:29:31 -0400
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Florin Iucha <florin@iucha.net>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Message-Id: <20070418012931.11679.60451.stgit@heimdal.trondhjem.org>
In-Reply-To: <20070418011946.11679.34920.stgit@heimdal.trondhjem.org>
References: <20070418011946.11679.34920.stgit@heimdal.trondhjem.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

Ensure that we don't release the PG_writeback lock until after the page has
either been redirtied, or queued on the nfs_inode 'commit' list.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/write.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 3ed4feb..8e94246 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -920,8 +920,8 @@ out_bad:
 		list_del(&data->pages);
 		nfs_writedata_release(data);
 	}
-	nfs_end_page_writeback(req->wb_page);
 	nfs_redirty_request(req);
+	nfs_end_page_writeback(req->wb_page);
 	nfs_clear_page_writeback(req);
 	return -ENOMEM;
 }
@@ -966,8 +966,8 @@ static int nfs_flush_one(struct inode *inode, struct list_head *head, int how)
 	while (!list_empty(head)) {
 		struct nfs_page *req = nfs_list_entry(head->next);
 		nfs_list_remove_request(req);
-		nfs_end_page_writeback(req->wb_page);
 		nfs_redirty_request(req);
+		nfs_end_page_writeback(req->wb_page);
 		nfs_clear_page_writeback(req);
 	}
 	return -ENOMEM;
@@ -1002,8 +1002,8 @@ out_err:
 	while (!list_empty(head)) {
 		req = nfs_list_entry(head->next);
 		nfs_list_remove_request(req);
-		nfs_end_page_writeback(req->wb_page);
 		nfs_redirty_request(req);
+		nfs_end_page_writeback(req->wb_page);
 		nfs_clear_page_writeback(req);
 	}
 	return error;
