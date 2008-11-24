Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbYKXV0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbYKXV0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 16:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbYKXV00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 16:26:26 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38195 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbYKXV0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 16:26:25 -0500
Subject: [Patch][RFC] Supress Buffer I/O errors when SCSI REQ_QUIET flag set
From: Keith Mannthey <kmannth@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, Chandra Seetharaman <sekharan@us.ibm.com>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 13:26:23 -0800
Message-Id: <1227561983.6487.32.camel@keith-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the scsi request REQ_QUIET flag to be propagated to the buffer
file system layer. The basic ideas is to pass the flag from the scsi
request to the bio (block IO) and then to the buffer layer.  The buffer
layer can then suppress needless printks. 

This patch declutters the kernel log by removed the 40-50 (per lun)
buffer io error messages seen during a boot in my multipath setup . It
is a good chance any real errors will be missed in the "noise" it the
logs without this patch. 

During boot I see blocks of messages like 
"
__ratelimit: 211 callbacks suppressed
Buffer I/O error on device sdm, logical block 5242879
Buffer I/O error on device sdm, logical block 5242879
Buffer I/O error on device sdm, logical block 5242847
Buffer I/O error on device sdm, logical block 1
Buffer I/O error on device sdm, logical block 5242878
Buffer I/O error on device sdm, logical block 5242879
Buffer I/O error on device sdm, logical block 5242879
Buffer I/O error on device sdm, logical block 5242879
Buffer I/O error on device sdm, logical block 5242879
Buffer I/O error on device sdm, logical block 5242872
"
in my logs. 

My disk environment is multipath fiber channel using the SCSI_DH_RDAC
code and multipathd.  This topology includes an "active" and "ghost"
path for each lun. IO's to the "ghost" path will never complete and the
SCSI layer, via the scsi device handler rdac code, quick returns the IOs
to theses paths and sets the REQ_QUIET scsi flag to suppress the scsi
layer messages. 

 I am wanting to extend the QUIET behavior to include the buffer file
system layer to deal with these errors as well. I have been running this
patch for a while now on several boxes without issue.  A few runs of
bonnie++ show no noticeable difference in performance in my setup. 

Thanks for John Stultz for the quiet_error finalization. 

Submitted-by:  Keith Mannthey <kmannth@us.ibm.com>

---

diff -urN linux-2.6.28-rc4-orig/block/blk-core.c linux-2.6.28-rc4/block/blk-core.c
--- linux-2.6.28-rc4-orig/block/blk-core.c	2008-11-18 11:17:59.000000000 -0800
+++ linux-2.6.28-rc4/block/blk-core.c	2008-11-17 16:48:06.000000000 -0800
@@ -139,6 +139,9 @@
 			nbytes = bio->bi_size;
 		}
 
+		if (unlikely(rq->cmd_flags & REQ_QUIET)) {
+			set_bit(BIO_QUIET, &bio->bi_flags);
+		}
 		bio->bi_size -= nbytes;
 		bio->bi_sector += (nbytes >> 9);
 
diff -urN linux-2.6.28-rc4-orig/fs/buffer.c linux-2.6.28-rc4/fs/buffer.c
--- linux-2.6.28-rc4-orig/fs/buffer.c	2008-11-18 11:18:01.000000000 -0800
+++ linux-2.6.28-rc4/fs/buffer.c	2008-11-18 12:02:59.000000000 -0800
@@ -99,10 +99,18 @@
 	page_cache_release(page);
 }
 
+
+static int quiet_error(struct buffer_head *bh)
+{
+	if (!test_bit(BH_Quiet, &bh->b_state) && printk_ratelimit())
+		return 0;
+	return 1;
+}
+
+
 static void buffer_io_error(struct buffer_head *bh)
 {
 	char b[BDEVNAME_SIZE];
-
 	printk(KERN_ERR "Buffer I/O error on device %s, logical block %Lu\n",
 			bdevname(bh->b_bdev, b),
 			(unsigned long long)bh->b_blocknr);
@@ -144,7 +152,7 @@
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 	} else {
-		if (!buffer_eopnotsupp(bh) && printk_ratelimit()) {
+		if (!buffer_eopnotsupp(bh) && !quiet_error(bh)) {
 			buffer_io_error(bh);
 			printk(KERN_WARNING "lost page write due to "
 					"I/O error on %s\n",
@@ -394,7 +402,7 @@
 		set_buffer_uptodate(bh);
 	} else {
 		clear_buffer_uptodate(bh);
-		if (printk_ratelimit())
+		if (!quiet_error(bh))
 			buffer_io_error(bh);
 		SetPageError(page);
 	}
@@ -455,7 +463,7 @@
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 	} else {
-		if (printk_ratelimit()) {
+		if (!quiet_error(bh)) {
 			buffer_io_error(bh);
 			printk(KERN_WARNING "lost page write due to "
 					"I/O error on %s\n",
@@ -2912,6 +2920,9 @@
 		set_bit(BH_Eopnotsupp, &bh->b_state);
 	}
 
+	if (unlikely (test_bit(BIO_QUIET,&bio->bi_flags)))
+		set_bit(BH_Quiet, &bh->b_state);
+
 	bh->b_end_io(bh, test_bit(BIO_UPTODATE, &bio->bi_flags));
 	bio_put(bio);
 }
diff -urN linux-2.6.28-rc4-orig/include/linux/bio.h linux-2.6.28-rc4/include/linux/bio.h
--- linux-2.6.28-rc4-orig/include/linux/bio.h	2008-11-18 11:18:02.000000000 -0800
+++ linux-2.6.28-rc4/include/linux/bio.h	2008-11-18 11:32:51.000000000 -0800
@@ -117,6 +117,7 @@
 #define BIO_CPU_AFFINE	8	/* complete bio on same CPU as submitted */
 #define BIO_NULL_MAPPED 9	/* contains invalid user pages */
 #define BIO_FS_INTEGRITY 10	/* fs owns integrity data, not block layer */
+#define BIO_QUIET	11	/* Make BIO Quiet */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
diff -urN linux-2.6.28-rc4-orig/include/linux/buffer_head.h linux-2.6.28-rc4/include/linux/buffer_head.h
--- linux-2.6.28-rc4-orig/include/linux/buffer_head.h	2008-11-18 11:18:02.000000000 -0800
+++ linux-2.6.28-rc4/include/linux/buffer_head.h	2008-11-17 16:48:06.000000000 -0800
@@ -35,6 +35,7 @@
 	BH_Ordered,	/* ordered write */
 	BH_Eopnotsupp,	/* operation not supported (barrier) */
 	BH_Unwritten,	/* Buffer is allocated on disk but not written */
+	BH_Quiet,	/* Buffer Error Prinks to be quiet */
 
 	BH_PrivateStart,/* not a state bit, but the first bit available
 			 * for private allocation by other entities


