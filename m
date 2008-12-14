Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbYLNS0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbYLNS0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 13:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYLNS0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 13:26:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbYLNS0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 13:26:41 -0500
Message-ID: <49455170.6080307@suse.de>
Date: Mon, 15 Dec 2008 02:33:20 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] avoid unnecessary assignment in lookup_bdev()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In normal cases, lookup_bdev() should return successfully, therefore it's not a good idea to always
assign error values before checking truth/false conditions. This patch modifies code to only assign
error value in necessary false conditions.

If I missed something, please correct me.

Signed-off-by: Coly Li <coly.li@suse.de>
---
 fs/block_dev.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 99e0ae1..10b656f 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1282,16 +1282,19 @@ struct block_device *lookup_bdev(const char *pathname)
 		return ERR_PTR(error);

 	inode = path.dentry->d_inode;
-	error = -ENOTBLK;
-	if (!S_ISBLK(inode->i_mode))
+	if (!S_ISBLK(inode->i_mode)) {
+		error = -ENOTBLK;
 		goto fail;
-	error = -EACCES;
-	if (path.mnt->mnt_flags & MNT_NODEV)
+	}
+	if (path.mnt->mnt_flags & MNT_NODEV) {
+		error = -EACCES;
 		goto fail;
-	error = -ENOMEM;
+	}
 	bdev = bd_acquire(inode);
-	if (!bdev)
+	if (!bdev) {
+		error = -ENOMEM;
 		goto fail;
+	}
 out:
 	path_put(&path);
 	return bdev;
-- 
Coly Li
SuSE PRC Labs
