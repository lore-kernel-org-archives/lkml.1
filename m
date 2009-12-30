Return-Path: <linux-kernel-owner+w=401wt.eu-S1751507AbZL3JOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbZL3JOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 04:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbZL3JOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 04:14:36 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55432 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbZL3JOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 04:14:35 -0500
Date: Wed, 30 Dec 2009 10:14:34 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [Bug #14894] pohmelfs: NULL pointer dereference
Message-ID: <20091230091433.GU4489@kernel.dk>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <srmJ8vMxKPH.A.iAC.TwhOLB@chimera> <20091229163512.GA4958@ioremap.net> <200912292237.54182.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912292237.54182.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29 2009, Rafael J. Wysocki wrote:
> On Tuesday 29 December 2009, Evgeniy Polyakov wrote:
> > On Tue, Dec 29, 2009 at 04:28:52PM +0100, Rafael J. Wysocki (rjw@sisk.pl) wrote:
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.31 and 2.6.32.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > > be listed and let me know (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14894
> > > Subject		: pohmelfs: NULL pointer dereference
> > > Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
> > > Date		: 2009-12-02 1:11 (28 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=125971633107940&w=4
> > > Handled-By	: Evgeniy Polyakov <zbr@ioremap.net>
> > 
> > Yes, I saw this regression and there is a patch to handle this, but it
> > kind of disables sync at all. Jens Axboe, who introduced per-bdi
> > writeback patches, did not yet reply.
> 
> Well, Jens, what's your opinion about that?

Since pohmelfs isn't tied to a single block device, it needs to setup a
backing dev like nfs/btrfs/etc do. Here's a completely untested patch.

diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index f69b778..cd25811 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -36,6 +36,7 @@
 #define POHMELFS_MAGIC_NUM	0x504f482e
 
 static struct kmem_cache *pohmelfs_inode_cache;
+static atomic_t psb_bdi_num = ATOMIC_INIT(0);
 
 /*
  * Removes inode from all trees, drops local name cache and removes all queued
@@ -1331,6 +1332,8 @@ static void pohmelfs_put_super(struct super_block *sb)
 	pohmelfs_crypto_exit(psb);
 	pohmelfs_state_exit(psb);
 
+	bdi_destroy(&psb->bdi);
+
 	kfree(psb);
 	sb->s_fs_info = NULL;
 }
@@ -1815,11 +1818,22 @@ static int pohmelfs_fill_super(struct super_block *sb, void *data, int silent)
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
 
@@ -1863,11 +1877,11 @@ static int pohmelfs_fill_super(struct super_block *sb, void *data, int silent)
 
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
diff --git a/drivers/staging/pohmelfs/netfs.h b/drivers/staging/pohmelfs/netfs.h
index 623a07d..01cba00 100644
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

-- 
Jens Axboe

