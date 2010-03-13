Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936503Ab0CMBcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:32:00 -0500
Received: from kroah.org ([198.145.64.141]:60625 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934860Ab0CMATt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:49 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:07 2010
Message-Id: <20100313001507.363526069@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jens Axboe <axboe@kernel.dk>, Evgeniy Polyakov <zbr@ioremap.net>
Subject: [patch 025/123] Staging: Fixed pohmelfs regression because of per-bdi writeback.
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Jens Axboe <axboe@kernel.dk>

commit 182374a0bddeef46769d2f8ab56fcccc433b96f3 upstream.

Since pohmelfs isn't tied to a single block device, it needs to setup a
backing dev like nfs/btrfs/etc do.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/pohmelfs/inode.c |   20 ++++++++++++++++++--
 drivers/staging/pohmelfs/netfs.h |    3 +++
 2 files changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -36,6 +36,7 @@
 #define POHMELFS_MAGIC_NUM	0x504f482e
 
 static struct kmem_cache *pohmelfs_inode_cache;
+static atomic_t psb_bdi_num = ATOMIC_INIT(0);
 
 /*
  * Removes inode from all trees, drops local name cache and removes all queued
@@ -1331,6 +1332,8 @@ static void pohmelfs_put_super(struct su
 	pohmelfs_crypto_exit(psb);
 	pohmelfs_state_exit(psb);
 
+	bdi_destroy(&psb->bdi);
+
 	kfree(psb);
 	sb->s_fs_info = NULL;
 }
@@ -1815,11 +1818,22 @@ static int pohmelfs_fill_super(struct su
 	if (!psb)
 		goto err_out_exit;
 
+	err = bdi_init(&psb->bdi);
+	if (err)
+		goto err_out_free_sb;
+
+	err = bdi_register(&psb->bdi, NULL, "pfs-%d", atomic_inc_return(&psb_bdi_num));
+	if (err) {
+		bdi_destroy(&psb->bdi);
+		goto err_out_free_sb;
+	}
+
 	sb->s_fs_info = psb;
 	sb->s_op = &pohmelfs_sb_ops;
 	sb->s_magic = POHMELFS_MAGIC_NUM;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_blocksize = PAGE_SIZE;
+	sb->s_bdi = &psb->bdi;
 
 	psb->sb = sb;
 
@@ -1863,11 +1877,11 @@ static int pohmelfs_fill_super(struct su
 
 	err = pohmelfs_parse_options((char *) data, psb, 0);
 	if (err)
-		goto err_out_free_sb;
+		goto err_out_free_bdi;
 
 	err = pohmelfs_copy_crypto(psb);
 	if (err)
-		goto err_out_free_sb;
+		goto err_out_free_bdi;
 
 	err = pohmelfs_state_init(psb);
 	if (err)
@@ -1916,6 +1930,8 @@ err_out_state_exit:
 err_out_free_strings:
 	kfree(psb->cipher_string);
 	kfree(psb->hash_string);
+err_out_free_bdi:
+	bdi_destroy(&psb->bdi);
 err_out_free_sb:
 	kfree(psb);
 err_out_exit:
--- a/drivers/staging/pohmelfs/netfs.h
+++ b/drivers/staging/pohmelfs/netfs.h
@@ -18,6 +18,7 @@
 
 #include <linux/types.h>
 #include <linux/connector.h>
+#include <linux/backing-dev.h>
 
 #define POHMELFS_CN_IDX			5
 #define POHMELFS_CN_VAL			0
@@ -624,6 +625,8 @@ struct pohmelfs_sb {
 
 	struct super_block	*sb;
 
+	struct backing_dev_info	bdi;
+
 	/*
 	 * Algorithm strings.
 	 */


