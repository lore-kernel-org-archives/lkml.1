Return-Path: <linux-kernel-owner+w=401wt.eu-S932952AbYBMJ36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952AbYBMJ36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932761AbYBMJ3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:29:36 -0500
Received: from styx.suse.cz ([82.119.242.94]:36982 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932711AbYBMJ3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:29:32 -0500
Date: Wed, 13 Feb 2008 10:29:30 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH] udf: Fix readdir on UDF
Message-ID: <20080213092930.GA6451@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch cleaning up UDF directory offset handling missed modifications in dir.c
(because I've submitted an old version of the patch :() leading to broken
readdir. Fix it.

Signed-off-by: Jan Kara <jack@suse.cz>
CC: Marcin Slusarz <marcin.slusarz@gmail.com>

diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index 4b44e23..8d8643a 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -43,13 +43,13 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 	struct fileIdentDesc *fi = NULL;
 	struct fileIdentDesc cfi;
 	int block, iblock;
-	loff_t nf_pos = filp->f_pos - 1;
+	loff_t nf_pos = (filp->f_pos - 1) << 2;
 	int flen;
 	char fname[UDF_NAME_LEN];
 	char *nameptr;
 	uint16_t liu;
 	uint8_t lfi;
-	loff_t size = (udf_ext0_offset(dir) + dir->i_size) >> 2;
+	loff_t size = udf_ext0_offset(dir) + dir->i_size;
 	struct buffer_head *tmp, *bha[16];
 	kernel_lb_addr eloc;
 	uint32_t elen;
@@ -63,13 +63,13 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 		return 0;
 
 	if (nf_pos == 0)
-		nf_pos = (udf_ext0_offset(dir) >> 2);
+		nf_pos = udf_ext0_offset(dir);
 
-	fibh.soffset = fibh.eoffset = (nf_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	fibh.soffset = fibh.eoffset = nf_pos & (dir->i_sb->s_blocksize - 1);
 	iinfo = UDF_I(dir);
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 		fibh.sbh = fibh.ebh = NULL;
-	} else if (inode_bmap(dir, nf_pos >> (dir->i_sb->s_blocksize_bits - 2),
+	} else if (inode_bmap(dir, nf_pos >> dir->i_sb->s_blocksize_bits,
 			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
@@ -111,7 +111,7 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 	}
 
 	while (nf_pos < size) {
-		filp->f_pos = nf_pos + 1;
+		filp->f_pos = (nf_pos >> 2) + 1;
 
 		fi = udf_fileident_read(dir, &nf_pos, &fibh, &cfi, &epos, &eloc,
 					&elen, &offset);
@@ -178,7 +178,7 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 		}
 	} /* end while */
 
-	filp->f_pos = nf_pos + 1;
+	filp->f_pos = (nf_pos >> 2) + 1;
 
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
