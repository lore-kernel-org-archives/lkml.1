Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbYH2Np4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbYH2Np4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 09:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758033AbYH2Nox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 09:44:53 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:33850 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756758AbYH2Noo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 09:44:44 -0400
Message-Id: <20080829134419.000609936@vixen.sonytel.be>
References: <20080829134158.108976037@vixen.sonytel.be>
User-Agent: quilt/0.46-1
Date: Fri, 29 Aug 2008 15:42:01 +0200
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: linux-crypto@vger.kernel.org, squashfs-devel@lists.sourceforge.net
Cc: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 3/3] squashfs: Switch from zlib/inflate to "zlib" crypto module
Content-Disposition: inline; filename=crypto/squashfs-use-crypto-api-for-orig.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Modify SquashFS 3.4 to use the "zlib" crypto module instead of making direct
calls to the zlib/inflate library

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 fs/Kconfig                     |    3 +
 fs/squashfs/inode.c            |   65 +++++++++++++++++++++--------------------
 include/linux/squashfs_fs_sb.h |    3 +
 3 files changed, 38 insertions(+), 33 deletions(-)

--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1350,7 +1350,8 @@ config CRAMFS
 
 config SQUASHFS
 	tristate "SquashFS 3.4 - Squashed file system support"
-	select ZLIB_INFLATE
+	select CRYPTO
+	select CRYPTO_ZLIB
 	help
 	  Saying Y here includes support for SquashFS 3.4 (a Compressed
 	  Read-Only File System).  Squashfs is a highly compressed read-only
--- a/fs/squashfs/inode.c
+++ b/fs/squashfs/inode.c
@@ -23,7 +23,6 @@
 
 #include <linux/squashfs_fs.h>
 #include <linux/module.h>
-#include <linux/zlib.h>
 #include <linux/fs.h>
 #include <linux/squashfs_fs_sb.h>
 #include <linux/squashfs_fs_i.h>
@@ -36,6 +35,9 @@
 
 #include "squashfs.h"
 
+#define SQUASHFS_CRYPTO_ALG	"zlib"
+
+
 static struct dentry *squashfs_fh_to_dentry(struct super_block *s,
 		struct fid *fid, int fh_len, int fh_type);
 static struct dentry *squashfs_fh_to_parent(struct super_block *s,
@@ -236,7 +238,10 @@ SQSH_EXTERN unsigned int squashfs_read_d
 	}
 
 	if (compressed) {
-		int zlib_err = 0;
+		int error = 0;
+		void *next_out;
+		int avail_out;
+		unsigned int total_out = 0, dlen;
 
 		/*
 	 	* uncompress block
@@ -244,8 +249,8 @@ SQSH_EXTERN unsigned int squashfs_read_d
 
 		mutex_lock(&msblk->read_data_mutex);
 
-		msblk->stream.next_out = buffer;
-		msblk->stream.avail_out = srclength;
+		next_out = buffer;
+		avail_out = srclength;
 
 		for (bytes = 0; k < b; k++) {
 			avail_bytes = min(c_byte - bytes, msblk->devblksize - offset);
@@ -254,16 +259,8 @@ SQSH_EXTERN unsigned int squashfs_read_d
 			if (!buffer_uptodate(bh[k]))
 				goto release_mutex;
 
-			msblk->stream.next_in = bh[k]->b_data + offset;
-			msblk->stream.avail_in = avail_bytes;
-
 			if (k == 0) {
-				zlib_err = zlib_inflateInit(&msblk->stream);
-				if (zlib_err != Z_OK) {
-					ERROR("zlib_inflateInit returned unexpected result 0x%x,"
-						" srclength %d\n", zlib_err, srclength);
-					goto release_mutex;
-				}
+				total_out = 0;
 
 				if (avail_bytes == 0) {
 					offset = 0;
@@ -272,29 +269,32 @@ SQSH_EXTERN unsigned int squashfs_read_d
 				}
 			}
 
-			zlib_err = zlib_inflate(&msblk->stream, Z_NO_FLUSH);
-			if (zlib_err != Z_OK && zlib_err != Z_STREAM_END) {
-				ERROR("zlib_inflate returned unexpected result 0x%x,"
-					" srclength %d, avail_in %d, avail_out %d\n", zlib_err,
-					srclength, msblk->stream.avail_in, msblk->stream.avail_out);
+			dlen = avail_out;
+			error = crypto_comp_decompress(msblk->tfm,
+						       bh[k]->b_data + offset,
+						       avail_bytes, next_out,
+						       &dlen);
+			if (error && error != -EAGAIN) {
+				ERROR("crypto_comp_decompress returned "
+				      "unexpected result %d, srclength %d, "
+				      "avail_bytes %d, avail_out %d\n",
+				      error, srclength, avail_bytes,
+				      avail_out);
 				goto release_mutex;
 			}
+			next_out += dlen;
+			avail_out -= dlen;
+			total_out += dlen;
 
 			bytes += avail_bytes;
 			offset = 0;
 			brelse(bh[k]);
 		}
 
-		if (zlib_err != Z_STREAM_END)
+		if (error)
 			goto release_mutex;
 
-		zlib_err = zlib_inflateEnd(&msblk->stream);
-		if (zlib_err != Z_OK) {
-			ERROR("zlib_inflateEnd returned unexpected result 0x%x,"
-				" srclength %d\n", zlib_err, srclength);
-			goto release_mutex;
-		}
-		bytes = msblk->stream.total_out;
+		bytes = total_out;
 		mutex_unlock(&msblk->read_data_mutex);
 	} else {
 		int i;
@@ -1104,9 +1104,12 @@ static int squashfs_fill_super(struct su
 	}
 	msblk = s->s_fs_info;
 
-	msblk->stream.workspace = vmalloc(zlib_inflate_workspacesize());
-	if (msblk->stream.workspace == NULL) {
-		ERROR("Failed to allocate zlib workspace\n");
+	msblk->tfm = crypto_alloc_comp(SQUASHFS_CRYPTO_ALG, 0,
+				       CRYPTO_ALG_ASYNC);
+	if (IS_ERR(msblk->tfm)) {
+		ERROR("Failed to load %s crypto module\n",
+		      SQUASHFS_CRYPTO_ALG);
+		msblk->tfm = NULL;
 		goto failure;
 	}
 	sblk = &msblk->sblk;
@@ -1273,7 +1276,7 @@ failed_mount:
 	vfree(msblk->read_page);
 	squashfs_cache_delete(msblk->block_cache);
 	kfree(msblk->fragment_index_2);
-	vfree(msblk->stream.workspace);
+	crypto_free_comp(msblk->tfm);
 	kfree(s->s_fs_info);
 	s->s_fs_info = NULL;
 	return -EINVAL;
@@ -2084,7 +2087,7 @@ static void squashfs_put_super(struct su
 		kfree(sbi->fragment_index);
 		kfree(sbi->fragment_index_2);
 		kfree(sbi->meta_index);
-		vfree(sbi->stream.workspace);
+		crypto_free_comp(sbi->tfm);
 		kfree(s->s_fs_info);
 		s->s_fs_info = NULL;
 	}
--- a/include/linux/squashfs_fs_sb.h
+++ b/include/linux/squashfs_fs_sb.h
@@ -24,6 +24,7 @@
  */
 
 #include <linux/squashfs_fs.h>
+#include <linux/crypto.h>
 
 struct squashfs_cache_entry {
 	long long	block;
@@ -67,7 +68,7 @@ struct squashfs_sb_info {
 	struct mutex		read_page_mutex;
 	struct mutex		meta_index_mutex;
 	struct meta_index	*meta_index;
-	z_stream		stream;
+	struct crypto_comp	*tfm;
 	long long		*inode_lookup_table;
 	int			(*read_inode)(struct inode *i,  squashfs_inode_t \
 				inode);

-- 
With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010

