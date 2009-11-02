Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZKBKLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZKBKLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbZKBKHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:07:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbZKBKHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:04 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Bernd Schmidt <bernd.schmidt@analog.com>, Julia Lawall <julia@diku.dk>
Subject: [PATCH 24/27] BKL: Remove BKL from romfs
Date: Mon,  2 Nov 2009 11:05:04 +0100
Message-Id: <1257156307-24175-25-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL is only used in fill_super. It is safe to remove it.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/romfs/super.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index 7342617..c117fa8 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -468,8 +468,6 @@ static int romfs_fill_super(struct super_block *sb, void *data, int silent)
 	size_t len;
 	int ret;
 
-	lock_kernel();
-
 #ifdef CONFIG_BLOCK
 	if (!sb->s_mtd) {
 		sb_set_blocksize(sb, ROMBSIZE);
@@ -486,10 +484,8 @@ static int romfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* read the image superblock and check it */
 	rsb = kmalloc(512, GFP_KERNEL);
-	if (!rsb) {
-		unlock_kernel();
+	if (!rsb)
 		return -ENOMEM;
-	}
 
 	sb->s_fs_info = (void *) 512;
 	ret = romfs_dev_read(sb, 0, rsb, 512);
@@ -539,18 +535,15 @@ static int romfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!sb->s_root)
 		goto error_i;
 
-	unlock_kernel();
 	return 0;
 
 error_i:
 	iput(root);
 error:
-	unlock_kernel();
 	return -EINVAL;
 error_rsb_inval:
 	ret = -EINVAL;
 error_rsb:
-	unlock_kernel();
 	return ret;
 }
 
-- 
1.6.4.2

