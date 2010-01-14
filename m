Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641Ab0ANWjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab0ANWjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623Ab0ANW2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:28:22 -0500
Received: from kroah.org ([198.145.64.141]:60512 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab0ANW2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:21 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Christoph Hellwig <hch@lst.de>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/52] nfsd: make sure data is on disk before calling ->fsync
Date: Thu, 14 Jan 2010 14:26:46 -0800
Message-Id: <1263508051-7868-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-6-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 7211a4e859ad070b28545c06e0a6cb60b3b8aa31 upstream.

nfsd is not using vfs_fsync, so I missed it when changing the calling
convention during the 2.6.32 window.  This patch fixes it to not only
start the data writeout, but also wait for it to complete before calling
into ->fsync.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/nfsd/vfs.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index a293f02..570dd1c 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -774,12 +774,9 @@ static inline int nfsd_dosync(struct file *filp, struct dentry *dp,
 	int (*fsync) (struct file *, struct dentry *, int);
 	int err;
 
-	err = filemap_fdatawrite(inode->i_mapping);
+	err = filemap_write_and_wait(inode->i_mapping);
 	if (err == 0 && fop && (fsync = fop->fsync))
 		err = fsync(filp, dp, 0);
-	if (err == 0)
-		err = filemap_fdatawait(inode->i_mapping);
-
 	return err;
 }
 
-- 
1.6.6

