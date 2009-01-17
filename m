Return-Path: <linux-kernel-owner+w=401wt.eu-S1762231AbZAQPEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762231AbZAQPEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 10:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760897AbZAQPDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 10:03:48 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:5105 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918AbZAQPDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 10:03:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:bcc:subject:date:user-agent;
        b=kz4wQCh1YNKP4rEqmuuoersD0bwmkKwy4Uv7GCIG/25kHOndesppu8rCxY6+vMFUVk
         dacDIr8QXc+Hmc/MjpKyLyYD+c5CHWZHPovdEGbiSE9VouJpz+Q5OsaUDtwObdmGrnZJ
         oWphh50jIVWXxwm3WGVGGPkmgrmiQ8P6Ng8bs=
Message-ID: <4971f34f.011e6e0a.3bb4.ffff8ae9@mx.google.com>
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: chris.mason@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix bug in open_ctree()
Date: Sat, 17 Jan 2009 23:03:38 +0800
User-Agent: sniper-patch-carrier/1.06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a bug in open_ctree:

struct btrfs_root *open_ctree(..)
{
....
	if (!extent_root || !tree_root || !fs_info ||
	    !chunk_root || !dev_root || !csum_root) {
		err = -ENOMEM;
		goto fail;
//When code flow goes to "fail", fs_info may be NULL or uninitialized.
	}
....

fail:
	btrfs_close_devices(fs_info->fs_devices);// !
	btrfs_mapping_tree_free(&fs_info->mapping_tree);// !

	kfree(extent_root);
	kfree(tree_root);
	bdi_destroy(&fs_info->bdi);// !
...
)

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 81a3138..f860087 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1828,13 +1828,14 @@ fail_sb_buffer:
 fail_iput:
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 	iput(fs_info->btree_inode);
-fail:
+
 	btrfs_close_devices(fs_info->fs_devices);
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
+	bdi_destroy(&fs_info->bdi);
 
+fail:
 	kfree(extent_root);
 	kfree(tree_root);
-	bdi_destroy(&fs_info->bdi);
 	kfree(fs_info);
 	kfree(chunk_root);
 	kfree(dev_root);

