Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbZCIIqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbZCIIqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 04:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbZCIIqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 04:46:24 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:48955 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751939AbZCIIqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 04:46:23 -0400
X-Sasl-enc: euJLq5QKOICXgaSb3Q7nF5AW4O+gCcf/Kw4v1VCy6xTi 1236588380
Message-ID: <49B4D758.8000304@ladisch.de>
Date: Mon, 09 Mar 2009 09:46:16 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] udf: use hardware sector size
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the UDF FS driver use the hardware sector size as the
default logical block size, which is required by the UDF specifications.
While the previous default of 2048 bytes was correct for optical disks,
it was not for hard disks or USB storage devices, and made it impossible
to use such a device with the default mount options.  (The Linux mkudffs
tool uses a default block size of 2048 bytes even on devices with
smaller hardware sectors, so this bug is unlikely to be noticed unless
UDF-formatted USB storage devices are exchanged with other OSs.)

To avoid regressions for people who use loopback optical disk images or
who used the (sometimes wrong) defaults of mkudffs, we also try with
a block size of 2048 bytes if no anchor was found with the hardware
sector size.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

--- linux-2.6.orig/fs/udf/udf_sb.h
+++ linux-2.6/fs/udf/udf_sb.h
@@ -30,6 +30,7 @@
 #define UDF_FLAG_GID_SET	16
 #define UDF_FLAG_SESSION_SET	17
 #define UDF_FLAG_LASTBLOCK_SET	18
+#define UDF_FLAG_BLOCKSIZE_SET	19
 
 #define UDF_PART_FLAG_UNALLOC_BITMAP	0x0001
 #define UDF_PART_FLAG_UNALLOC_TABLE	0x0002
--- linux-2.6.orig/fs/udf/super.c
+++ linux-2.6/fs/udf/super.c
@@ -86,7 +86,7 @@ static int udf_remount_fs(struct super_b
 static int udf_check_valid(struct super_block *, int, int);
 static int udf_vrs(struct super_block *sb, int silent);
 static void udf_load_logicalvolint(struct super_block *, kernel_extent_ad);
-static void udf_find_anchor(struct super_block *);
+static int udf_find_anchor(struct super_block *);
 static int udf_find_fileset(struct super_block *, kernel_lb_addr *,
 			    kernel_lb_addr *);
 static void udf_load_fileset(struct super_block *, struct buffer_head *,
@@ -258,7 +258,7 @@ static int udf_show_options(struct seq_f
 
 	if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT))
 		seq_puts(seq, ",nostrict");
-	if (sb->s_blocksize != UDF_DEFAULT_BLOCKSIZE)
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_BLOCKSIZE_SET))
 		seq_printf(seq, ",bs=%lu", sb->s_blocksize);
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UNHIDE))
 		seq_puts(seq, ",unhide");
@@ -405,7 +405,6 @@ static int udf_parse_options(char *optio
 	int option;
 
 	uopt->novrs = 0;
-	uopt->blocksize = UDF_DEFAULT_BLOCKSIZE;
 	uopt->partition = 0xFFFF;
 	uopt->session = 0xFFFFFFFF;
 	uopt->lastblock = 0;
@@ -433,6 +432,7 @@ static int udf_parse_options(char *optio
 			if (match_int(&args[0], &option))
 				return 0;
 			uopt->blocksize = option;
+			uopt->flags |= (1 << UDF_FLAG_BLOCKSIZE_SET);
 			break;
 		case Opt_unhide:
 			uopt->flags |= (1 << UDF_FLAG_UNHIDE);
@@ -761,12 +761,13 @@ static sector_t udf_scan_anchors(struct 
  * Return 1 if not found, 0 if ok
  *
  */
-static void udf_find_anchor(struct super_block *sb)
+static int udf_find_anchor(struct super_block *sb)
 {
 	sector_t lastblock;
 	struct buffer_head *bh = NULL;
 	uint16_t ident;
 	int i;
+	int anchor_found = 0;
 	struct udf_sb_info *sbi = UDF_SB(sb);
 
 	lastblock = udf_scan_anchors(sb, sbi->s_last_block);
@@ -804,10 +805,13 @@ check_anchor:
 			brelse(bh);
 			if (ident != TAG_IDENT_AVDP)
 				sbi->s_anchor[i] = 0;
+			else
+				anchor_found = 1;
 		}
 	}
 
 	sbi->s_last_block = lastblock;
+	return !anchor_found;
 }
 
 static int udf_find_fileset(struct super_block *sb,
@@ -1679,6 +1683,32 @@ static int udf_check_valid(struct super_
 	return !block;
 }
 
+static int udf_check_blocksize(struct super_block *sb,
+			       struct udf_options *uopt, int silent)
+{
+	struct udf_sb_info *sbi = UDF_SB(sb);
+
+	if (!sb_set_blocksize(sb, uopt->blocksize)) {
+		if (!silent)
+			printk(KERN_WARNING "UDF-fs: Bad block size\n");
+		return 1;
+	}
+	sbi->s_last_block = uopt->lastblock;
+	if (udf_check_valid(sb, uopt->novrs, silent)) {
+		if (!silent)
+			printk(KERN_WARNING "UDF-fs: No VRS found\n");
+		return 1;
+	}
+	sbi->s_anchor[0] = sbi->s_anchor[1] = 0;
+	sbi->s_anchor[2] = uopt->anchor;
+	if (udf_find_anchor(sb)) {
+		if (!silent)
+			printk(KERN_WARNING "UDF-fs: No anchor found\n");
+		return 1;
+	}
+	return 0;
+}
+
 static int udf_load_sequence(struct super_block *sb, kernel_lb_addr *fileset)
 {
 	struct anchorVolDescPtr *anchor;
@@ -1847,6 +1877,8 @@ static void udf_free_partition(struct ud
 static int udf_fill_super(struct super_block *sb, void *options, int silent)
 {
 	int i;
+	int no_anchor;
+	int is_default_blocksize;
 	struct inode *inode = NULL;
 	struct udf_options uopt;
 	kernel_lb_addr rootdir, fileset;
@@ -1895,13 +1927,6 @@ static int udf_fill_super(struct super_b
 	sbi->s_umask = uopt.umask;
 	sbi->s_nls_map = uopt.nls_map;
 
-	/* Set the block size for all transfers */
-	if (!sb_min_blocksize(sb, uopt.blocksize)) {
-		udf_debug("Bad block size (%d)\n", uopt.blocksize);
-		printk(KERN_ERR "udf: bad block size (%d)\n", uopt.blocksize);
-		goto error_out;
-	}
-
 	if (uopt.session == 0xFFFFFFFF)
 		sbi->s_session = udf_get_last_session(sb);
 	else
@@ -1909,17 +1934,20 @@ static int udf_fill_super(struct super_b
 
 	udf_debug("Multi-session=%d\n", sbi->s_session);
 
-	sbi->s_last_block = uopt.lastblock;
-	sbi->s_anchor[0] = sbi->s_anchor[1] = 0;
-	sbi->s_anchor[2] = uopt.anchor;
-
-	if (udf_check_valid(sb, uopt.novrs, silent)) {
-		/* read volume recognition sequences */
-		printk(KERN_WARNING "UDF-fs: No VRS found\n");
-		goto error_out;
+	if (uopt.flags & (1 << UDF_FLAG_BLOCKSIZE_SET)) {
+		no_anchor = udf_check_blocksize(sb, &uopt, silent);
+	} else {
+		uopt.blocksize = bdev_hardsect_size(sb->s_bdev);
+		is_default_blocksize = uopt.blocksize == UDF_DEFAULT_BLOCKSIZE;
+		no_anchor = udf_check_blocksize(sb, &uopt, silent ||
+						!is_default_blocksize);
+		if (no_anchor && !is_default_blocksize) {
+			uopt.blocksize = UDF_DEFAULT_BLOCKSIZE;
+			no_anchor = udf_check_blocksize(sb, &uopt, silent);
+		}
 	}
-
-	udf_find_anchor(sb);
+	if (no_anchor)
+		goto error_out;
 
 	/* Fill in the rest of the superblock */
 	sb->s_op = &udf_sb_ops;
