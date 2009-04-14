Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbZDNLLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbZDNLLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 07:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbZDNLKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 07:10:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbZDNLKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 07:10:03 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
Subject: [PATCH 4/6] Handle possible bio_alloc failure in jfs
Date: Tue, 14 Apr 2009 16:36:42 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
MIME-Version: 1.0
Content-Disposition: inline
To: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       jfs-discussion@lists.sourceforge.net
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200904141636.42874.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle bio_alloc failure in jfs.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

Index: linux-2.6/fs/jfs/jfs_logmgr.c
===================================================================
--- linux-2.6.orig/fs/jfs/jfs_logmgr.c
+++ linux-2.6/fs/jfs/jfs_logmgr.c
@@ -2003,6 +2003,8 @@ static int lbmRead(struct jfs_log * log,
 	bp->l_flag |= lbmREAD;
 
 	bio = bio_alloc(GFP_NOFS, 1);
+	if (unlikely(!bio))
+		return -ENOMEM;
 
 	bio->bi_sector = bp->l_blkno << (log->l2bsize - 9);
 	bio->bi_bdev = log->bdev;
@@ -2145,6 +2147,9 @@ static void lbmStartIO(struct lbuf * bp)
 	jfs_info("lbmStartIO\n");
 
 	bio = bio_alloc(GFP_NOFS, 1);
+	if (unlikely(!bio))
+		panic("Unable to allocate bio\n");
+
 	bio->bi_sector = bp->l_blkno << (log->l2bsize - 9);
 	bio->bi_bdev = log->bdev;
 	bio->bi_io_vec[0].bv_page = bp->l_page;
Index: linux-2.6/fs/jfs/jfs_metapage.c
===================================================================
--- linux-2.6.orig/fs/jfs/jfs_metapage.c
+++ linux-2.6/fs/jfs/jfs_metapage.c
@@ -436,6 +436,9 @@ static int metapage_writepage(struct pag
 		len = min(xlen, (int)JFS_SBI(inode->i_sb)->nbperpage);
 
 		bio = bio_alloc(GFP_NOFS, 1);
+		if (unlikely(!bio))
+			return -ENOMEM;
+
 		bio->bi_bdev = inode->i_sb->s_bdev;
 		bio->bi_sector = pblock << (inode->i_blkbits - 9);
 		bio->bi_end_io = metapage_write_end_io;
@@ -515,6 +518,9 @@ static int metapage_readpage(struct file
 				submit_bio(READ, bio);
 
 			bio = bio_alloc(GFP_NOFS, 1);
+			if (unlikely(!bio))
+				return -ENOMEM;
+
 			bio->bi_bdev = inode->i_sb->s_bdev;
 			bio->bi_sector = pblock << (inode->i_blkbits - 9);
 			bio->bi_end_io = metapage_read_end_io;


