Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbZCKQFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbZCKQFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbZCKQEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:04:53 -0400
Received: from ns2.suse.de ([195.135.220.15]:34400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbZCKQEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:04:52 -0400
Date: Wed, 11 Mar 2009 17:04:48 +0100
From: Jan Kara <jack@suse.cz>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udf: use hardware sector size
Message-ID: <20090311160448.GH24590@duck.suse.cz>
References: <49B4D758.8000304@ladisch.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <49B4D758.8000304@ladisch.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi,

On Mon 09-03-09 09:46:16, Clemens Ladisch wrote:
> This patch makes the UDF FS driver use the hardware sector size as the
> default logical block size, which is required by the UDF specifications.
  Hmm, I've checked the standard and you're right.

> While the previous default of 2048 bytes was correct for optical disks,
> it was not for hard disks or USB storage devices, and made it impossible
> to use such a device with the default mount options.  (The Linux mkudffs
> tool uses a default block size of 2048 bytes even on devices with
> smaller hardware sectors, so this bug is unlikely to be noticed unless
> UDF-formatted USB storage devices are exchanged with other OSs.)
> 
> To avoid regressions for people who use loopback optical disk images or
> who used the (sometimes wrong) defaults of mkudffs, we also try with
> a block size of 2048 bytes if no anchor was found with the hardware
> sector size.
  OK, probably makes sence. Thanks for the fix. I've merged the patch with
a few cosmetic changes:
  1) We don't call udf_check_valid() with 'silent' set when checking
with the hardware sector size. It's not like we're going to flood logs
with error messages so it should be fine and user knows what's happening.
  2) I've added a message that we're rescanning the volume with new
blocksize.
  3) I've changed udf_check_blocksize() to udf_check_volume() which IMO
better describes what the function does.
  4) udf_check_blocksize() returned 0 when it succeeded and 1 when it
failed. I know some UDF functions do this but the other way around is more
logical (and usual in the rest of the kernel) and I try to convert the
functions to this style when I find them. So I've changed the function
to return 1 when it succeeds finding the anchor and 0 when it fails.
  The resulting patch is attached.

								Honza

> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> 
> --- linux-2.6.orig/fs/udf/udf_sb.h
> +++ linux-2.6/fs/udf/udf_sb.h
> @@ -30,6 +30,7 @@
>  #define UDF_FLAG_GID_SET	16
>  #define UDF_FLAG_SESSION_SET	17
>  #define UDF_FLAG_LASTBLOCK_SET	18
> +#define UDF_FLAG_BLOCKSIZE_SET	19
>  
>  #define UDF_PART_FLAG_UNALLOC_BITMAP	0x0001
>  #define UDF_PART_FLAG_UNALLOC_TABLE	0x0002
> --- linux-2.6.orig/fs/udf/super.c
> +++ linux-2.6/fs/udf/super.c
> @@ -86,7 +86,7 @@ static int udf_remount_fs(struct super_b
>  static int udf_check_valid(struct super_block *, int, int);
>  static int udf_vrs(struct super_block *sb, int silent);
>  static void udf_load_logicalvolint(struct super_block *, kernel_extent_ad);
> -static void udf_find_anchor(struct super_block *);
> +static int udf_find_anchor(struct super_block *);
>  static int udf_find_fileset(struct super_block *, kernel_lb_addr *,
>  			    kernel_lb_addr *);
>  static void udf_load_fileset(struct super_block *, struct buffer_head *,
> @@ -258,7 +258,7 @@ static int udf_show_options(struct seq_f
>  
>  	if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT))
>  		seq_puts(seq, ",nostrict");
> -	if (sb->s_blocksize != UDF_DEFAULT_BLOCKSIZE)
> +	if (UDF_QUERY_FLAG(sb, UDF_FLAG_BLOCKSIZE_SET))
>  		seq_printf(seq, ",bs=%lu", sb->s_blocksize);
>  	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UNHIDE))
>  		seq_puts(seq, ",unhide");
> @@ -405,7 +405,6 @@ static int udf_parse_options(char *optio
>  	int option;
>  
>  	uopt->novrs = 0;
> -	uopt->blocksize = UDF_DEFAULT_BLOCKSIZE;
>  	uopt->partition = 0xFFFF;
>  	uopt->session = 0xFFFFFFFF;
>  	uopt->lastblock = 0;
> @@ -433,6 +432,7 @@ static int udf_parse_options(char *optio
>  			if (match_int(&args[0], &option))
>  				return 0;
>  			uopt->blocksize = option;
> +			uopt->flags |= (1 << UDF_FLAG_BLOCKSIZE_SET);
>  			break;
>  		case Opt_unhide:
>  			uopt->flags |= (1 << UDF_FLAG_UNHIDE);
> @@ -761,12 +761,13 @@ static sector_t udf_scan_anchors(struct 
>   * Return 1 if not found, 0 if ok
>   *
>   */
> -static void udf_find_anchor(struct super_block *sb)
> +static int udf_find_anchor(struct super_block *sb)
>  {
>  	sector_t lastblock;
>  	struct buffer_head *bh = NULL;
>  	uint16_t ident;
>  	int i;
> +	int anchor_found = 0;
>  	struct udf_sb_info *sbi = UDF_SB(sb);
>  
>  	lastblock = udf_scan_anchors(sb, sbi->s_last_block);
> @@ -804,10 +805,13 @@ check_anchor:
>  			brelse(bh);
>  			if (ident != TAG_IDENT_AVDP)
>  				sbi->s_anchor[i] = 0;
> +			else
> +				anchor_found = 1;
>  		}
>  	}
>  
>  	sbi->s_last_block = lastblock;
> +	return !anchor_found;
>  }
>  
>  static int udf_find_fileset(struct super_block *sb,
> @@ -1679,6 +1683,32 @@ static int udf_check_valid(struct super_
>  	return !block;
>  }
>  
> +static int udf_check_blocksize(struct super_block *sb,
> +			       struct udf_options *uopt, int silent)
> +{
> +	struct udf_sb_info *sbi = UDF_SB(sb);
> +
> +	if (!sb_set_blocksize(sb, uopt->blocksize)) {
> +		if (!silent)
> +			printk(KERN_WARNING "UDF-fs: Bad block size\n");
> +		return 1;
> +	}
> +	sbi->s_last_block = uopt->lastblock;
> +	if (udf_check_valid(sb, uopt->novrs, silent)) {
> +		if (!silent)
> +			printk(KERN_WARNING "UDF-fs: No VRS found\n");
> +		return 1;
> +	}
> +	sbi->s_anchor[0] = sbi->s_anchor[1] = 0;
> +	sbi->s_anchor[2] = uopt->anchor;
> +	if (udf_find_anchor(sb)) {
> +		if (!silent)
> +			printk(KERN_WARNING "UDF-fs: No anchor found\n");
> +		return 1;
> +	}
> +	return 0;
> +}
> +
>  static int udf_load_sequence(struct super_block *sb, kernel_lb_addr *fileset)
>  {
>  	struct anchorVolDescPtr *anchor;
> @@ -1847,6 +1877,8 @@ static void udf_free_partition(struct ud
>  static int udf_fill_super(struct super_block *sb, void *options, int silent)
>  {
>  	int i;
> +	int no_anchor;
> +	int is_default_blocksize;
>  	struct inode *inode = NULL;
>  	struct udf_options uopt;
>  	kernel_lb_addr rootdir, fileset;
> @@ -1895,13 +1927,6 @@ static int udf_fill_super(struct super_b
>  	sbi->s_umask = uopt.umask;
>  	sbi->s_nls_map = uopt.nls_map;
>  
> -	/* Set the block size for all transfers */
> -	if (!sb_min_blocksize(sb, uopt.blocksize)) {
> -		udf_debug("Bad block size (%d)\n", uopt.blocksize);
> -		printk(KERN_ERR "udf: bad block size (%d)\n", uopt.blocksize);
> -		goto error_out;
> -	}
> -
>  	if (uopt.session == 0xFFFFFFFF)
>  		sbi->s_session = udf_get_last_session(sb);
>  	else
> @@ -1909,17 +1934,20 @@ static int udf_fill_super(struct super_b
>  
>  	udf_debug("Multi-session=%d\n", sbi->s_session);
>  
> -	sbi->s_last_block = uopt.lastblock;
> -	sbi->s_anchor[0] = sbi->s_anchor[1] = 0;
> -	sbi->s_anchor[2] = uopt.anchor;
> -
> -	if (udf_check_valid(sb, uopt.novrs, silent)) {
> -		/* read volume recognition sequences */
> -		printk(KERN_WARNING "UDF-fs: No VRS found\n");
> -		goto error_out;
> +	if (uopt.flags & (1 << UDF_FLAG_BLOCKSIZE_SET)) {
> +		no_anchor = udf_check_blocksize(sb, &uopt, silent);
> +	} else {
> +		uopt.blocksize = bdev_hardsect_size(sb->s_bdev);
> +		is_default_blocksize = uopt.blocksize == UDF_DEFAULT_BLOCKSIZE;
> +		no_anchor = udf_check_blocksize(sb, &uopt, silent ||
> +						!is_default_blocksize);
> +		if (no_anchor && !is_default_blocksize) {
> +			uopt.blocksize = UDF_DEFAULT_BLOCKSIZE;
> +			no_anchor = udf_check_blocksize(sb, &uopt, silent);
> +		}
>  	}
> -
> -	udf_find_anchor(sb);
> +	if (no_anchor)
> +		goto error_out;
>  
>  	/* Fill in the rest of the superblock */
>  	sb->s_op = &udf_sb_ops;
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--9jxsPFA5p3P2qPhR
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-udf-use-hardware-sector-size.patch"

>From 41debf4e7959b8e537880a8ed04fd770ee4bd67f Mon Sep 17 00:00:00 2001
From: Clemens Ladisch <clemens@ladisch.de>
Date: Wed, 11 Mar 2009 15:57:47 +0100
Subject: [PATCH] udf: use hardware sector size

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
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/super.c  |   70 ++++++++++++++++++++++++++++++++++++++----------------
 fs/udf/udf_sb.h |    1 +
 2 files changed, 50 insertions(+), 21 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 36a467c..f8fece4 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -86,7 +86,6 @@ static int udf_remount_fs(struct super_block *, int *, char *);
 static int udf_check_valid(struct super_block *, int, int);
 static int udf_vrs(struct super_block *sb, int silent);
 static void udf_load_logicalvolint(struct super_block *, struct kernel_extent_ad);
-static void udf_find_anchor(struct super_block *);
 static int udf_find_fileset(struct super_block *, struct kernel_lb_addr *,
 			    struct kernel_lb_addr *);
 static void udf_load_fileset(struct super_block *, struct buffer_head *,
@@ -260,7 +259,7 @@ static int udf_show_options(struct seq_file *seq, struct vfsmount *mnt)
 
 	if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT))
 		seq_puts(seq, ",nostrict");
-	if (sb->s_blocksize != UDF_DEFAULT_BLOCKSIZE)
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_BLOCKSIZE_SET))
 		seq_printf(seq, ",bs=%lu", sb->s_blocksize);
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UNHIDE))
 		seq_puts(seq, ",unhide");
@@ -416,7 +415,6 @@ static int udf_parse_options(char *options, struct udf_options *uopt,
 	int option;
 
 	uopt->novrs = 0;
-	uopt->blocksize = UDF_DEFAULT_BLOCKSIZE;
 	uopt->partition = 0xFFFF;
 	uopt->session = 0xFFFFFFFF;
 	uopt->lastblock = 0;
@@ -444,6 +442,7 @@ static int udf_parse_options(char *options, struct udf_options *uopt,
 			if (match_int(&args[0], &option))
 				return 0;
 			uopt->blocksize = option;
+			uopt->flags |= (1 << UDF_FLAG_BLOCKSIZE_SET);
 			break;
 		case Opt_unhide:
 			uopt->flags |= (1 << UDF_FLAG_UNHIDE);
@@ -789,12 +788,13 @@ static sector_t udf_scan_anchors(struct super_block *sb, sector_t lastblock)
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
@@ -832,10 +832,13 @@ check_anchor:
 			brelse(bh);
 			if (ident != TAG_IDENT_AVDP)
 				sbi->s_anchor[i] = 0;
+			else
+				anchor_found = 1;
 		}
 	}
 
 	sbi->s_last_block = lastblock;
+	return anchor_found;
 }
 
 static int udf_find_fileset(struct super_block *sb,
@@ -1721,6 +1724,32 @@ static int udf_check_valid(struct super_block *sb, int novrs, int silent)
 	return !block;
 }
 
+static int udf_check_volume(struct super_block *sb,
+			    struct udf_options *uopt, int silent)
+{
+	struct udf_sb_info *sbi = UDF_SB(sb);
+
+	if (!sb_set_blocksize(sb, uopt->blocksize)) {
+		if (!silent)
+			printk(KERN_WARNING "UDF-fs: Bad block size\n");
+		return 0;
+	}
+	sbi->s_last_block = uopt->lastblock;
+	if (udf_check_valid(sb, uopt->novrs, silent)) {
+		if (!silent)
+			printk(KERN_WARNING "UDF-fs: No VRS found\n");
+		return 0;
+	}
+	sbi->s_anchor[0] = sbi->s_anchor[1] = 0;
+	sbi->s_anchor[2] = uopt->anchor;
+	if (!udf_find_anchor(sb)) {
+		if (!silent)
+			printk(KERN_WARNING "UDF-fs: No anchor found\n");
+		return 0;
+	}
+	return 1;
+}
+
 static int udf_load_sequence(struct super_block *sb, struct kernel_lb_addr *fileset)
 {
 	struct anchorVolDescPtr *anchor;
@@ -1889,6 +1918,7 @@ static void udf_free_partition(struct udf_part_map *map)
 static int udf_fill_super(struct super_block *sb, void *options, int silent)
 {
 	int i;
+	int found_anchor;
 	struct inode *inode = NULL;
 	struct udf_options uopt;
 	struct kernel_lb_addr rootdir, fileset;
@@ -1941,13 +1971,6 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	sbi->s_dmode = uopt.dmode;
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
@@ -1955,17 +1978,22 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 
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
+		found_anchor = udf_check_volume(sb, &uopt, silent);
+	} else {
+		uopt.blocksize = bdev_hardsect_size(sb->s_bdev);
+		found_anchor = udf_check_volume(sb, &uopt, silent);
+		if (!found_anchor && uopt.blocksize != UDF_DEFAULT_BLOCKSIZE) {
+			if (!silent)
+				printk(KERN_NOTICE
+				       "UDF-fs: Rescanning with blocksize "
+				       "%d\n", UDF_DEFAULT_BLOCKSIZE);
+			uopt.blocksize = UDF_DEFAULT_BLOCKSIZE;
+			found_anchor = udf_check_volume(sb, &uopt, silent);
+		}
 	}
-
-	udf_find_anchor(sb);
+	if (!found_anchor)
+		goto error_out;
 
 	/* Fill in the rest of the superblock */
 	sb->s_op = &udf_sb_ops;
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 158221e..2dd9219 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -30,6 +30,7 @@
 #define UDF_FLAG_GID_SET	16
 #define UDF_FLAG_SESSION_SET	17
 #define UDF_FLAG_LASTBLOCK_SET	18
+#define UDF_FLAG_BLOCKSIZE_SET	19
 
 #define UDF_PART_FLAG_UNALLOC_BITMAP	0x0001
 #define UDF_PART_FLAG_UNALLOC_TABLE	0x0002
-- 
1.6.0.2


--9jxsPFA5p3P2qPhR--
