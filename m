Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbYA3PKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbYA3PKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 10:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYA3PK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 10:10:29 -0500
Received: from styx.suse.cz ([82.119.242.94]:59094 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751464AbYA3PK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:10:29 -0500
Date: Wed, 30 Jan 2008 16:10:27 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] udf: Cleanup directory offset handling
Message-ID: <20080130151027.GF16140@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  the patch below is a cleanup preparing space for the real fix in the
next patch. Please apply. Thanks.
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

Position in directory returned by readdir is offset of directory entry
divided by four (don't ask me why). Make this conversion only when
reading f_pos from userspace / writing it there and internally work in
bytes. It makes things more easily readable and also fixes a bug (we
forgot to divide length of the entry by 4 when advancing f_pos in
udf_add_entry()).

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.24-rc8-mm1/fs/udf/directory.c linux-2.6.24-rc8-mm1-1-udf_fpos_fix/fs/udf/directory.c
--- linux-2.6.24-rc8-mm1/fs/udf/directory.c	2008-01-29 19:20:40.000000000 +0100
+++ linux-2.6.24-rc8-mm1-1-udf_fpos_fix/fs/udf/directory.c	2008-01-29 20:40:07.000000000 +0100
@@ -95,7 +95,7 @@ struct fileIdentDesc *udf_fileident_read
 		if (!fi)
 			return NULL;
 
-		*nf_pos += ((fibh->eoffset - fibh->soffset) >> 2);
+		*nf_pos += fibh->eoffset - fibh->soffset;
 
 		memcpy((uint8_t *)cfi, (uint8_t *)fi,
 		       sizeof(struct fileIdentDesc));
@@ -157,7 +157,7 @@ struct fileIdentDesc *udf_fileident_read
 	if (!fi)
 		return NULL;
 
-	*nf_pos += ((fibh->eoffset - fibh->soffset) >> 2);
+	*nf_pos += fibh->eoffset - fibh->soffset;
 
 	if (fibh->eoffset <= dir->i_sb->s_blocksize) {
 		memcpy((uint8_t *)cfi, (uint8_t *)fi,
@@ -197,8 +197,7 @@ struct fileIdentDesc *udf_fileident_read
 				  cfi->lengthFileIdent +
 				  le16_to_cpu(cfi->lengthOfImpUse) + 3) & ~3;
 
-			*nf_pos += (fi_len - (fibh->eoffset - fibh->soffset))
-					>> 2;
+			*nf_pos += fi_len - (fibh->eoffset - fibh->soffset);
 			fibh->eoffset = fibh->soffset + fi_len;
 		} else {
 			memcpy((uint8_t *)cfi, (uint8_t *)fi,
diff -rupX /home/jack/.kerndiffexclude linux-2.6.24-rc8-mm1/fs/udf/inode.c linux-2.6.24-rc8-mm1-1-udf_fpos_fix/fs/udf/inode.c
--- linux-2.6.24-rc8-mm1/fs/udf/inode.c	2008-01-29 19:20:40.000000000 +0100
+++ linux-2.6.24-rc8-mm1-1-udf_fpos_fix/fs/udf/inode.c	2008-01-29 22:24:30.000000000 +0100
@@ -219,8 +219,8 @@ struct buffer_head *udf_expand_dir_adini
 	struct extent_position epos;
 
 	struct udf_fileident_bh sfibh, dfibh;
-	loff_t f_pos = udf_ext0_offset(inode) >> 2;
-	int size = (udf_ext0_offset(inode) + inode->i_size) >> 2;
+	loff_t f_pos = udf_ext0_offset(inode);
+	int size = udf_ext0_offset(inode) + inode->i_size;
 	struct fileIdentDesc cfi, *sfi, *dfi;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
@@ -256,11 +256,11 @@ struct buffer_head *udf_expand_dir_adini
 	mark_buffer_dirty_inode(dbh, inode);
 
 	sfibh.soffset = sfibh.eoffset =
-			(f_pos & ((inode->i_sb->s_blocksize - 1) >> 2)) << 2;
+			f_pos & (inode->i_sb->s_blocksize - 1);
 	sfibh.sbh = sfibh.ebh = NULL;
 	dfibh.soffset = dfibh.eoffset = 0;
 	dfibh.sbh = dfibh.ebh = dbh;
-	while ((f_pos < size)) {
+	while (f_pos < size) {
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
 		sfi = udf_fileident_read(inode, &f_pos, &sfibh, &cfi, NULL,
 					 NULL, NULL, NULL);
diff -rupX /home/jack/.kerndiffexclude linux-2.6.24-rc8-mm1/fs/udf/namei.c linux-2.6.24-rc8-mm1-1-udf_fpos_fix/fs/udf/namei.c
--- linux-2.6.24-rc8-mm1/fs/udf/namei.c	2008-01-29 19:20:40.000000000 +0100
+++ linux-2.6.24-rc8-mm1-1-udf_fpos_fix/fs/udf/namei.c	2008-01-29 20:38:47.000000000 +0100
@@ -160,14 +160,13 @@ static struct fileIdentDesc *udf_find_en
 	struct extent_position epos = {};
 	struct udf_inode_info *dinfo = UDF_I(dir);
 
-	size = (udf_ext0_offset(dir) + dir->i_size) >> 2;
-	f_pos = (udf_ext0_offset(dir) >> 2);
+	size = udf_ext0_offset(dir) + dir->i_size;
+	f_pos = udf_ext0_offset(dir);
 
-	fibh->soffset = fibh->eoffset =
-		(f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	fibh->soffset = fibh->eoffset = f_pos & (dir->i_sb->s_blocksize - 1);
 	if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
 		fibh->sbh = fibh->ebh = NULL;
-	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
+	else if (inode_bmap(dir, f_pos >> dir->i_sb->s_blocksize_bits,
 			      &epos, &eloc, &elen, &offset) ==
 					(EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
@@ -189,7 +188,7 @@ static struct fileIdentDesc *udf_find_en
 		return NULL;
 	}
 
-	while ((f_pos < size)) {
+	while (f_pos < size) {
 		fi = udf_fileident_read(dir, &f_pos, fibh, cfi, &epos, &eloc,
 					&elen, &offset);
 		if (!fi) {
@@ -342,7 +341,7 @@ static struct fileIdentDesc *udf_add_ent
 	loff_t f_pos;
 	int flen;
 	char *nameptr;
-	loff_t size = (udf_ext0_offset(dir) + dir->i_size) >> 2;
+	loff_t size = udf_ext0_offset(dir) + dir->i_size;
 	int nfidlen;
 	uint8_t lfi;
 	uint16_t liu;
@@ -370,14 +369,13 @@ static struct fileIdentDesc *udf_add_ent
 
 	nfidlen = (sizeof(struct fileIdentDesc) + namelen + 3) & ~3;
 
-	f_pos = (udf_ext0_offset(dir) >> 2);
+	f_pos = udf_ext0_offset(dir);
 
-	fibh->soffset = fibh->eoffset =
-			(f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	fibh->soffset = fibh->eoffset = f_pos & (dir->i_sb->s_blocksize - 1);
 	dinfo = UDF_I(dir);
 	if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
 		fibh->sbh = fibh->ebh = NULL;
-	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
+	else if (inode_bmap(dir, f_pos >> dir->i_sb->s_blocksize_bits,
 			      &epos, &eloc, &elen, &offset) ==
 					(EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
@@ -405,7 +403,7 @@ static struct fileIdentDesc *udf_add_ent
 		goto add;
 	}
 
-	while ((f_pos < size)) {
+	while (f_pos < size) {
 		fi = udf_fileident_read(dir, &f_pos, fibh, cfi, &epos, &eloc,
 					&elen, &offset);
 
@@ -484,7 +482,7 @@ add:
 		epos.bh = NULL;
 		fibh->soffset -= udf_ext0_offset(dir);
 		fibh->eoffset -= udf_ext0_offset(dir);
-		f_pos -= (udf_ext0_offset(dir) >> 2);
+		f_pos -= udf_ext0_offset(dir);
 		if (fibh->sbh != fibh->ebh)
 			brelse(fibh->ebh);
 		brelse(fibh->sbh);
@@ -537,8 +535,7 @@ add:
 		block = eloc.logicalBlockNum + ((elen - 1) >>
 						dir->i_sb->s_blocksize_bits);
 		fibh->ebh = udf_bread(dir,
-				f_pos >> (dir->i_sb->s_blocksize_bits - 2),
-				1, err);
+				f_pos >> dir->i_sb->s_blocksize_bits, 1, err);
 		if (!fibh->ebh) {
 			brelse(epos.bh);
 			brelse(fibh->sbh);
@@ -775,7 +772,7 @@ static int empty_dir(struct inode *dir)
 	struct fileIdentDesc *fi, cfi;
 	struct udf_fileident_bh fibh;
 	loff_t f_pos;
-	loff_t size = (udf_ext0_offset(dir) + dir->i_size) >> 2;
+	loff_t size = udf_ext0_offset(dir) + dir->i_size;
 	int block;
 	kernel_lb_addr eloc;
 	uint32_t elen;
@@ -783,14 +780,12 @@ static int empty_dir(struct inode *dir)
 	struct extent_position epos = {};
 	struct udf_inode_info *dinfo = UDF_I(dir);
 
-	f_pos = (udf_ext0_offset(dir) >> 2);
-
-	fibh.soffset = fibh.eoffset =
-			(f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	f_pos = udf_ext0_offset(dir);
+	fibh.soffset = fibh.eoffset = f_pos & (dir->i_sb->s_blocksize - 1);
 
 	if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
 		fibh.sbh = fibh.ebh = NULL;
-	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
+	else if (inode_bmap(dir, f_pos >> dir->i_sb->s_blocksize_bits,
 			      &epos, &eloc, &elen, &offset) ==
 					(EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
@@ -812,7 +807,7 @@ static int empty_dir(struct inode *dir)
 		return 0;
 	}
 
-	while ((f_pos < size)) {
+	while (f_pos < size) {
 		fi = udf_fileident_read(dir, &f_pos, &fibh, &cfi, &epos, &eloc,
 					&elen, &offset);
 		if (!fi) {
