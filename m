Return-Path: <linux-kernel-owner+w=401wt.eu-S1761939AbYA3PNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761939AbYA3PNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 10:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbYA3PNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 10:13:09 -0500
Received: from styx.suse.cz ([82.119.242.94]:35671 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755612AbYA3PNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:13:07 -0500
Date: Wed, 30 Jan 2008 16:13:05 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] udf: Fix adding entry to a directory
Message-ID: <20080130151305.GG16140@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  the patch below fixes a reported bug - we could create an illegal
directory when its size was less than blocksize but larger than fits in an
inode block. Please apply. Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

When adding directory entry to a directory, we have to properly increase
length of the last extent. Handle this similarly as extending regular files -
make extents always have size multiple of block size (it will be truncated
down to proper size in udf_clear_inode()).

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.24-rc8-mm1-1-udf_fpos_fix/fs/udf/inode.c linux-2.6.24-rc8-mm1-2-udf_add_entry_fix/fs/udf/inode.c
--- linux-2.6.24-rc8-mm1-1-udf_fpos_fix/fs/udf/inode.c	2008-01-29 22:24:30.000000000 +0100
+++ linux-2.6.24-rc8-mm1-2-udf_add_entry_fix/fs/udf/inode.c	2008-01-29 23:09:25.000000000 +0100
@@ -289,7 +289,7 @@ struct buffer_head *udf_expand_dir_adini
 	eloc.logicalBlockNum = *block;
 	eloc.partitionReferenceNum =
 				iinfo->i_location.partitionReferenceNum;
-	elen = inode->i_size;
+	elen = inode->i_sb->s_blocksize;
 	iinfo->i_lenExtents = elen;
 	epos.bh = NULL;
 	epos.block = iinfo->i_location;
diff -rupX /home/jack/.kerndiffexclude linux-2.6.24-rc8-mm1-1-udf_fpos_fix/fs/udf/namei.c linux-2.6.24-rc8-mm1-2-udf_add_entry_fix/fs/udf/namei.c
--- linux-2.6.24-rc8-mm1-1-udf_fpos_fix/fs/udf/namei.c	2008-01-29 20:38:47.000000000 +0100
+++ linux-2.6.24-rc8-mm1-2-udf_add_entry_fix/fs/udf/namei.c	2008-01-29 23:06:56.000000000 +0100
@@ -395,7 +395,6 @@ static struct fileIdentDesc *udf_add_ent
 		}
 
 		block = dinfo->i_location.logicalBlockNum;
-
 	} else {
 		block = udf_get_lb_pblock(dir->i_sb, dinfo->i_location, 0);
 		fibh->sbh = fibh->ebh = NULL;
@@ -474,6 +473,14 @@ static struct fileIdentDesc *udf_add_ent
 	}
 
 add:
+	if (dinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
+		elen = (elen + sb->s_blocksize - 1) & ~(sb->s_blocksize - 1);
+		if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
+			epos.offset -= sizeof(short_ad);
+		else if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
+			epos.offset -= sizeof(long_ad);
+		udf_write_aext(dir, &epos, eloc, elen, 1);
+	}
 	f_pos += nfidlen;
 
 	if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB &&
@@ -491,15 +498,9 @@ add:
 		if (!fibh->sbh)
 			return NULL;
 		epos.block = dinfo->i_location;
-		eloc.logicalBlockNum = block;
-		eloc.partitionReferenceNum =
-				dinfo->i_location.partitionReferenceNum;
-		elen = dir->i_sb->s_blocksize;
 		epos.offset = udf_file_entry_alloc_offset(dir);
-		if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-			epos.offset += sizeof(short_ad);
-		else if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-			epos.offset += sizeof(long_ad);
+		/* Load extent udf_expand_dir_adinicb() has created */
+		udf_current_aext(dir, &epos, &eloc, &elen, 1);
 	}
 
 	if (sb->s_blocksize - fibh->eoffset >= nfidlen) {
