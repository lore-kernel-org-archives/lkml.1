Return-Path: <linux-kernel-owner+w=401wt.eu-S965918AbXCFQmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965918AbXCFQmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965336AbXCFQmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:42:23 -0500
Received: from styx.suse.cz ([82.119.242.94]:53855 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965332AbXCFQmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:42:21 -0500
Date: Tue, 6 Mar 2007 17:47:27 +0100
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jack@suse.cz, akpm@osdl.org
Subject: [PATCH 3/6] UDF cleanup and fixes
Message-ID: <20070306164727.GF3661@duck.suse.cz>
References: <20070306164447.GC3661@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306164447.GC3661@duck.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make UDF use get_bh() instead of directly accessing b_count and use brelse()
instead of udf_release_data() which does just brelse()...

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.20-2-udf_extent_position_t/fs/udf/balloc.c linux-2.6.20-3-udf_buffer_handling/fs/udf/balloc.c
--- linux-2.6.20-2-udf_extent_position_t/fs/udf/balloc.c	2007-02-22 14:52:17.000000000 +0100
+++ linux-2.6.20-3-udf_buffer_handling/fs/udf/balloc.c	2007-03-06 16:38:05.000000000 +0100
@@ -508,8 +508,8 @@ static void udf_table_free_blocks(struct
 		{
 			i = -1;
 			oepos.block = epos.block;
-			udf_release_data(oepos.bh);
-			atomic_inc(&epos.bh->b_count);
+			brelse(oepos.bh);
+			get_bh(epos.bh);
 			oepos.bh = epos.bh;
 			oepos.offset = 0;
 		}
@@ -546,8 +546,8 @@ static void udf_table_free_blocks(struct
 			adsize = sizeof(long_ad);
 		else
 		{
-			udf_release_data(oepos.bh);
-			udf_release_data(epos.bh);
+			brelse(oepos.bh);
+			brelse(epos.bh);
 			goto error_return;
 		}
 
@@ -556,7 +556,7 @@ static void udf_table_free_blocks(struct
 			char *sptr, *dptr;
 			int loffset;
 	
-			udf_release_data(oepos.bh);
+			brelse(oepos.bh);
 			oepos = epos;
 
 			/* Steal a block from the extent being free'd */
@@ -567,7 +567,7 @@ static void udf_table_free_blocks(struct
 			if (!(epos.bh = udf_tread(sb,
 				udf_get_lb_pblock(sb, epos.block, 0))))
 			{
-				udf_release_data(oepos.bh);
+				brelse(oepos.bh);
 				goto error_return;
 			}
 			aed = (struct allocExtDesc *)(epos.bh->b_data);
@@ -658,8 +658,8 @@ static void udf_table_free_blocks(struct
 		}
 	}
 
-	udf_release_data(epos.bh);
-	udf_release_data(oepos.bh);
+	brelse(epos.bh);
+	brelse(oepos.bh);
 
 error_return:
 	sb->s_dirt = 1;
@@ -723,7 +723,7 @@ static int udf_table_prealloc_blocks(str
 	else
 		alloc_count = 0;
 
-	udf_release_data(epos.bh);
+	brelse(epos.bh);
 
 	if (alloc_count && UDF_SB_LVIDBH(sb))
 	{
@@ -789,9 +789,9 @@ static int udf_table_new_block(struct su
 			spread = nspread;
 			if (goal_epos.bh != epos.bh)
 			{
-				udf_release_data(goal_epos.bh);
+				brelse(goal_epos.bh);
 				goal_epos.bh = epos.bh;
-				atomic_inc(&goal_epos.bh->b_count);
+				get_bh(goal_epos.bh);
 			}
 			goal_epos.block = epos.block;
 			goal_epos.offset = epos.offset - adsize;
@@ -800,11 +800,11 @@ static int udf_table_new_block(struct su
 		}
 	}
 
-	udf_release_data(epos.bh);
+	brelse(epos.bh);
 
 	if (spread == 0xFFFFFFFF)
 	{
-		udf_release_data(goal_epos.bh);
+		brelse(goal_epos.bh);
 		mutex_unlock(&sbi->s_alloc_mutex);
 		return 0;
 	}
@@ -820,7 +820,7 @@ static int udf_table_new_block(struct su
 
 	if (inode && DQUOT_ALLOC_BLOCK(inode, 1))
 	{
-		udf_release_data(goal_epos.bh);
+		brelse(goal_epos.bh);
 		mutex_unlock(&sbi->s_alloc_mutex);
 		*err = -EDQUOT;
 		return 0;
@@ -830,7 +830,7 @@ static int udf_table_new_block(struct su
 		udf_write_aext(table, &goal_epos, goal_eloc, goal_elen, 1);
 	else
 		udf_delete_aext(table, goal_epos, goal_eloc, goal_elen);
-	udf_release_data(goal_epos.bh);
+	brelse(goal_epos.bh);
 
 	if (UDF_SB_LVIDBH(sb))
 	{
@@ -915,11 +915,14 @@ inline int udf_new_block(struct super_bl
 	struct inode * inode,
 	uint16_t partition, uint32_t goal, int *err)
 {
+	int ret;
+
 	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP)
 	{
-		return udf_bitmap_new_block(sb, inode,
+		ret = udf_bitmap_new_block(sb, inode,
 			UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_bitmap,
 			partition, goal, err);
+		return ret;
 	}
 	else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE)
 	{
diff -rupX /home/jack/.kerndiffexclude linux-2.6.20-2-udf_extent_position_t/fs/udf/dir.c linux-2.6.20-3-udf_buffer_handling/fs/udf/dir.c
--- linux-2.6.20-2-udf_extent_position_t/fs/udf/dir.c	2007-02-22 14:52:17.000000000 +0100
+++ linux-2.6.20-3-udf_buffer_handling/fs/udf/dir.c	2007-02-22 14:57:59.000000000 +0100
@@ -144,7 +144,7 @@ do_udf_readdir(struct inode * dir, struc
 
 		if (!(fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block)))
 		{
-			udf_release_data(epos.bh);
+			brelse(epos.bh);
 			return -EIO;
 		}
 	
@@ -172,7 +172,7 @@ do_udf_readdir(struct inode * dir, struc
 	}
 	else
 	{
-		udf_release_data(epos.bh);
+		brelse(epos.bh);
 		return -ENOENT;
 	}
 
@@ -185,9 +185,9 @@ do_udf_readdir(struct inode * dir, struc
 		if (!fi)
 		{
 			if (fibh.sbh != fibh.ebh)
-				udf_release_data(fibh.ebh);
-			udf_release_data(fibh.sbh);
-			udf_release_data(epos.bh);
+				brelse(fibh.ebh);
+			brelse(fibh.sbh);
+			brelse(epos.bh);
 			return 0;
 		}
 
@@ -245,9 +245,9 @@ do_udf_readdir(struct inode * dir, struc
 			if (filldir(dirent, fname, flen, filp->f_pos, iblock, dt_type) < 0)
 			{
 				if (fibh.sbh != fibh.ebh)
-					udf_release_data(fibh.ebh);
-				udf_release_data(fibh.sbh);
-				udf_release_data(epos.bh);
+					brelse(fibh.ebh);
+				brelse(fibh.sbh);
+				brelse(epos.bh);
 	 			return 0;
 			}
 		}
@@ -256,9 +256,9 @@ do_udf_readdir(struct inode * dir, struc
 	filp->f_pos = nf_pos + 1;
 
 	if (fibh.sbh != fibh.ebh)
-		udf_release_data(fibh.ebh);
-	udf_release_data(fibh.sbh);
-	udf_release_data(epos.bh);
+		brelse(fibh.ebh);
+	brelse(fibh.sbh);
+	brelse(epos.bh);
 
 	return 0;
 }
diff -rupX /home/jack/.kerndiffexclude linux-2.6.20-2-udf_extent_position_t/fs/udf/directory.c linux-2.6.20-3-udf_buffer_handling/fs/udf/directory.c
--- linux-2.6.20-2-udf_extent_position_t/fs/udf/directory.c	2007-02-22 14:52:17.000000000 +0100
+++ linux-2.6.20-3-udf_buffer_handling/fs/udf/directory.c	2007-02-22 14:57:59.000000000 +0100
@@ -36,14 +36,14 @@ udf_filead_read(struct inode *dir, uint8
 
 	if (!ad)
 	{
-		udf_release_data(*bh);
+		brelse(*bh);
 		*error = 1;
 		return NULL;
 	}
 
 	if (*offset == dir->i_sb->s_blocksize)
 	{
-		udf_release_data(*bh);
+		brelse(*bh);
 		block = udf_get_lb_pblock(dir->i_sb, fe_loc, ++*pos);
 		if (!block)
 			return NULL;
@@ -57,7 +57,7 @@ udf_filead_read(struct inode *dir, uint8
 		remainder = dir->i_sb->s_blocksize - loffset;
 		memcpy((uint8_t *)ad, (*bh)->b_data + loffset, remainder);
 
-		udf_release_data(*bh);
+		brelse(*bh);
 		block = udf_get_lb_pblock(dir->i_sb, fe_loc, ++*pos);
 		if (!block)
 			return NULL;
@@ -120,7 +120,7 @@ udf_fileident_read(struct inode *dir, lo
 		else
 			epos->offset = lextoffset;
 
-		udf_release_data(fibh->sbh);
+		brelse(fibh->sbh);
 		if (!(fibh->sbh = fibh->ebh = udf_tread(dir->i_sb, block)))
 			return NULL;
 		fibh->soffset = fibh->eoffset = 0;
@@ -149,7 +149,7 @@ udf_fileident_read(struct inode *dir, lo
 	}
 	else if (fibh->sbh != fibh->ebh)
 	{
-		udf_release_data(fibh->sbh);
+		brelse(fibh->sbh);
 		fibh->sbh = fibh->ebh;
 	}
 
diff -rupX /home/jack/.kerndiffexclude linux-2.6.20-2-udf_extent_position_t/fs/udf/inode.c linux-2.6.20-3-udf_buffer_handling/fs/udf/inode.c
--- linux-2.6.20-2-udf_extent_position_t/fs/udf/inode.c	2007-02-22 14:52:17.000000000 +0100
+++ linux-2.6.20-3-udf_buffer_handling/fs/udf/inode.c	2007-02-22 14:57:59.000000000 +0100
@@ -247,7 +247,7 @@ struct buffer_head * udf_expand_dir_adin
 		sfi = udf_fileident_read(inode, &f_pos, &sfibh, &cfi, NULL, NULL, NULL, NULL);
 		if (!sfi)
 		{
-			udf_release_data(dbh);
+			brelse(dbh);
 			return NULL;
 		}
 		UDF_I_ALLOCTYPE(inode) = alloctype;
@@ -259,7 +259,7 @@ struct buffer_head * udf_expand_dir_adin
 			sfi->fileIdent + le16_to_cpu(sfi->lengthOfImpUse)))
 		{
 			UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_IN_ICB;
-			udf_release_data(dbh);
+			brelse(dbh);
 			return NULL;
 		}
 	}
@@ -277,7 +277,7 @@ struct buffer_head * udf_expand_dir_adin
 	udf_add_aext(inode, &epos, eloc, elen, 0);
 	/* UniqueID stuff */
 
-	udf_release_data(epos.bh);
+	brelse(epos.bh);
 	mark_inode_dirty(inode);
 	return dbh;
 }
@@ -386,14 +386,14 @@ static struct buffer_head * inode_getblk
 	{
 		if (prev_epos.bh != cur_epos.bh)
 		{
-			udf_release_data(prev_epos.bh);
-			atomic_inc(&cur_epos.bh->b_count);
+			brelse(prev_epos.bh);
+			get_bh(cur_epos.bh);
 			prev_epos.bh = cur_epos.bh;
 		}
 		if (cur_epos.bh != next_epos.bh)
 		{
-			udf_release_data(cur_epos.bh);
-			atomic_inc(&next_epos.bh->b_count);
+			brelse(cur_epos.bh);
+			get_bh(next_epos.bh);
 			cur_epos.bh = next_epos.bh;
 		}
 
@@ -436,9 +436,9 @@ static struct buffer_head * inode_getblk
 				~(inode->i_sb->s_blocksize - 1));
 			etype = udf_write_aext(inode, &cur_epos, eloc, elen, 1);
 		}
-		udf_release_data(prev_epos.bh);
-		udf_release_data(cur_epos.bh);
-		udf_release_data(next_epos.bh);
+		brelse(prev_epos.bh);
+		brelse(cur_epos.bh);
+		brelse(next_epos.bh);
 		newblock = udf_get_lb_pblock(inode->i_sb, eloc, offset);
 		*phys = newblock;
 		return NULL;
@@ -492,8 +492,8 @@ static struct buffer_head * inode_getblk
 		else
 			lastblock = 1;
 	}
-	udf_release_data(cur_epos.bh);
-	udf_release_data(next_epos.bh);
+	brelse(cur_epos.bh);
+	brelse(next_epos.bh);
 
 	/* if the current extent is not recorded but allocated, get the
 		block in the extent corresponding to the requested block */
@@ -513,7 +513,7 @@ static struct buffer_head * inode_getblk
 		if (!(newblocknum = udf_new_block(inode->i_sb, inode,
 			UDF_I_LOCATION(inode).partitionReferenceNum, goal, err)))
 		{
-			udf_release_data(prev_epos.bh);
+			brelse(prev_epos.bh);
 			*err = -ENOSPC;
 			return NULL;
 		}
@@ -538,7 +538,7 @@ static struct buffer_head * inode_getblk
        the new number of extents is less than the old number */
 	udf_update_extents(inode, laarr, startnum, endnum, &prev_epos);
 
-	udf_release_data(prev_epos.bh);
+	brelse(prev_epos.bh);
 
 	if (!(newblock = udf_get_pblock(inode->i_sb, newblocknum,
 		UDF_I_LOCATION(inode).partitionReferenceNum, 0)))
@@ -934,7 +934,7 @@ __udf_read_inode(struct inode *inode)
 	{
 		printk(KERN_ERR "udf: udf_read_inode(ino %ld) failed ident=%d\n",
 			inode->i_ino, ident);
-		udf_release_data(bh);
+		brelse(bh);
 		make_bad_inode(inode);
 		return;
 	}
@@ -963,35 +963,35 @@ __udf_read_inode(struct inode *inode)
 						ident == TAG_IDENT_EFE)
 					{
 						memcpy(&UDF_I_LOCATION(inode), &loc, sizeof(kernel_lb_addr));
-						udf_release_data(bh);
-						udf_release_data(ibh);
-						udf_release_data(nbh);
+						brelse(bh);
+						brelse(ibh);
+						brelse(nbh);
 						__udf_read_inode(inode);
 						return;
 					}
 					else
 					{
-						udf_release_data(nbh);
-						udf_release_data(ibh);
+						brelse(nbh);
+						brelse(ibh);
 					}
 				}
 				else
-					udf_release_data(ibh);
+					brelse(ibh);
 			}
 		}
 		else
-			udf_release_data(ibh);
+			brelse(ibh);
 	}
 	else if (le16_to_cpu(fe->icbTag.strategyType) != 4)
 	{
 		printk(KERN_ERR "udf: unsupported strategy type: %d\n",
 			le16_to_cpu(fe->icbTag.strategyType));
-		udf_release_data(bh);
+		brelse(bh);
 		make_bad_inode(inode);
 		return;
 	}
 	udf_fill_inode(inode, bh);
-	udf_release_data(bh);
+	brelse(bh);
 }
 
 static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
@@ -1334,7 +1334,7 @@ udf_update_inode(struct inode *inode, in
 				use->descTag.tagChecksum += ((uint8_t *)&(use->descTag))[i];
 
 		mark_buffer_dirty(bh);
-		udf_release_data(bh);
+		brelse(bh);
 		return err;
 	}
 
@@ -1523,7 +1523,7 @@ udf_update_inode(struct inode *inode, in
 			err = -EIO;
 		}
 	}
-	udf_release_data(bh);
+	brelse(bh);
 	return err;
 }
 
@@ -1670,7 +1670,7 @@ int8_t udf_add_aext(struct inode *inode,
 			else
 				udf_update_tag(epos->bh->b_data, sizeof(struct allocExtDesc));
 			mark_buffer_dirty_inode(epos->bh, inode);
-			udf_release_data(epos->bh);
+			brelse(epos->bh);
 		}
 		else
 			mark_inode_dirty(inode);
@@ -1761,7 +1761,7 @@ int8_t udf_next_aext(struct inode *inode
 	{
 		epos->block = *eloc;
 		epos->offset = sizeof(struct allocExtDesc);
-		udf_release_data(epos->bh);
+		brelse(epos->bh);
 		if (!(epos->bh = udf_tread(inode->i_sb, udf_get_lb_pblock(inode->i_sb, epos->block, 0))))
 		{
 			udf_debug("reading block %d failed!\n",
@@ -1841,7 +1841,7 @@ udf_insert_aext(struct inode *inode, str
 	int8_t etype;
 
 	if (epos.bh)
-		atomic_inc(&epos.bh->b_count);
+		get_bh(epos.bh);
 
 	while ((etype = udf_next_aext(inode, &epos, &oeloc, &oelen, 0)) != -1)
 	{
@@ -1851,7 +1851,7 @@ udf_insert_aext(struct inode *inode, str
 		nelen = (etype << 30) | oelen;
 	}
 	udf_add_aext(inode, &epos, neloc, nelen, 1);
-	udf_release_data(epos.bh);
+	brelse(epos.bh);
 	return (nelen >> 30);
 }
 
@@ -1865,8 +1865,8 @@ int8_t udf_delete_aext(struct inode *ino
 
 	if (epos.bh)
 	{
-		atomic_inc(&epos.bh->b_count);
-		atomic_inc(&epos.bh->b_count);
+		get_bh(epos.bh);
+		get_bh(epos.bh);
 	}
 
 	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_SHORT)
@@ -1886,8 +1886,8 @@ int8_t udf_delete_aext(struct inode *ino
 		if (oepos.bh != epos.bh)
 		{
 			oepos.block = epos.block;
-			udf_release_data(oepos.bh);
-			atomic_inc(&epos.bh->b_count);
+			brelse(oepos.bh);
+			get_bh(epos.bh);
 			oepos.bh = epos.bh;
 			oepos.offset = epos.offset - adsize;
 		}
@@ -1938,8 +1938,8 @@ int8_t udf_delete_aext(struct inode *ino
 		}
 	}
 	
-	udf_release_data(epos.bh);
-	udf_release_data(oepos.bh);
+	brelse(epos.bh);
+	brelse(oepos.bh);
 	return (elen >> 30);
 }
 
@@ -1992,7 +1992,7 @@ long udf_block_map(struct inode *inode, 
 		ret = 0;
 
 	unlock_kernel();
-	udf_release_data(epos.bh);
+	brelse(epos.bh);
 
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_VARCONV))
 		return udf_fixed_to_variable(ret);
diff -rupX /home/jack/.kerndiffexclude linux-2.6.20-2-udf_extent_position_t/fs/udf/misc.c linux-2.6.20-3-udf_buffer_handling/fs/udf/misc.c
--- linux-2.6.20-2-udf_extent_position_t/fs/udf/misc.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6.20-3-udf_buffer_handling/fs/udf/misc.c	2007-02-22 14:57:59.000000000 +0100
@@ -274,12 +274,6 @@ udf_read_ptagged(struct super_block *sb,
 		loc.logicalBlockNum + offset, ident);
 }
 
-void udf_release_data(struct buffer_head *bh)
-{
-	if (bh)
-		brelse(bh);
-}
-
 void udf_update_tag(char *data, int length)
 {
 	tag *tptr = (tag *)data;
diff -rupX /home/jack/.kerndiffexclude linux-2.6.20-2-udf_extent_position_t/fs/udf/namei.c linux-2.6.20-3-udf_buffer_handling/fs/udf/namei.c
--- linux-2.6.20-2-udf_extent_position_t/fs/udf/namei.c	2007-02-22 14:52:17.000000000 +0100
+++ linux-2.6.20-3-udf_buffer_handling/fs/udf/namei.c	2007-02-22 14:57:59.000000000 +0100
@@ -182,13 +182,13 @@ udf_find_entry(struct inode *dir, struct
 
 		if (!(fibh->sbh = fibh->ebh = udf_tread(dir->i_sb, block)))
 		{
-			udf_release_data(epos.bh);
+			brelse(epos.bh);
 			return NULL;
 		}
 	}
 	else
 	{
-		udf_release_data(epos.bh);
+		brelse(epos.bh);
 		return NULL;
 	}
 
@@ -199,9 +199,9 @@ udf_find_entry(struct inode *dir, struct
 		if (!fi)
 		{
 			if (fibh->sbh != fibh->ebh)
-				udf_release_data(fibh->ebh);
-			udf_release_data(fibh->sbh);
-			udf_release_data(epos.bh);
+				brelse(fibh->ebh);
+			brelse(fibh->sbh);
+			brelse(epos.bh);
 			return NULL;
 		}
 
@@ -247,15 +247,15 @@ udf_find_entry(struct inode *dir, struct
 		{
 			if (udf_match(flen, fname, dentry->d_name.len, dentry->d_name.name))
 			{
-				udf_release_data(epos.bh);
+				brelse(epos.bh);
 				return fi;
 			}
 		}
 	}
 	if (fibh->sbh != fibh->ebh)
-		udf_release_data(fibh->ebh);
-	udf_release_data(fibh->sbh);
-	udf_release_data(epos.bh);
+		brelse(fibh->ebh);
+	brelse(fibh->sbh);
+	brelse(epos.bh);
 	return NULL;
 }
 
@@ -321,8 +321,8 @@ udf_lookup(struct inode *dir, struct den
 	if (udf_find_entry(dir, dentry, &fibh, &cfi))
 	{
 		if (fibh.sbh != fibh.ebh)
-			udf_release_data(fibh.ebh);
-		udf_release_data(fibh.sbh);
+			brelse(fibh.ebh);
+		brelse(fibh.sbh);
 
 		inode = udf_iget(dir->i_sb, lelb_to_cpu(cfi.icb.extLocation));
 		if ( !inode )
@@ -400,7 +400,7 @@ udf_add_entry(struct inode *dir, struct 
 
 		if (!(fibh->sbh = fibh->ebh = udf_tread(dir->i_sb, block)))
 		{
-			udf_release_data(epos.bh);
+			brelse(epos.bh);
 			*err = -EIO;
 			return NULL;
 		}
@@ -423,9 +423,9 @@ udf_add_entry(struct inode *dir, struct 
 		if (!fi)
 		{
 			if (fibh->sbh != fibh->ebh)
-				udf_release_data(fibh->ebh);
-			udf_release_data(fibh->sbh);
-			udf_release_data(epos.bh);
+				brelse(fibh->ebh);
+			brelse(fibh->sbh);
+			brelse(epos.bh);
 			*err = -EIO;
 			return NULL;
 		}
@@ -455,7 +455,7 @@ udf_add_entry(struct inode *dir, struct 
 		{
 			if (((sizeof(struct fileIdentDesc) + liu + lfi + 3) & ~3) == nfidlen)
 			{
-				udf_release_data(epos.bh);
+				brelse(epos.bh);
 				cfi->descTag.tagSerialNum = cpu_to_le16(1);
 				cfi->fileVersionNum = cpu_to_le16(1);
 				cfi->fileCharacteristics = 0;
@@ -478,9 +478,9 @@ udf_add_entry(struct inode *dir, struct 
 			udf_match(flen, fname, dentry->d_name.len, dentry->d_name.name))
 		{
 			if (fibh->sbh != fibh->ebh)
-				udf_release_data(fibh->ebh);
-			udf_release_data(fibh->sbh);
-			udf_release_data(epos.bh);
+				brelse(fibh->ebh);
+			brelse(fibh->sbh);
+			brelse(epos.bh);
 			*err = -EEXIST;
 			return NULL;
 		}
@@ -492,14 +492,14 @@ add:
 	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB &&
 		sb->s_blocksize - fibh->eoffset < nfidlen)
 	{
-		udf_release_data(epos.bh);
+		brelse(epos.bh);
 		epos.bh = NULL;
 		fibh->soffset -= udf_ext0_offset(dir);
 		fibh->eoffset -= udf_ext0_offset(dir);
 		f_pos -= (udf_ext0_offset(dir) >> 2);
 		if (fibh->sbh != fibh->ebh)
-			udf_release_data(fibh->ebh);
-		udf_release_data(fibh->sbh);
+			brelse(fibh->ebh);
+		brelse(fibh->sbh);
 		if (!(fibh->sbh = fibh->ebh = udf_expand_dir_adinicb(dir, &block, err)))
 			return NULL;
 		epos.block = UDF_I_LOCATION(dir);
@@ -519,7 +519,7 @@ add:
 		fibh->eoffset += nfidlen;
 		if (fibh->sbh != fibh->ebh)
 		{
-			udf_release_data(fibh->sbh);
+			brelse(fibh->sbh);
 			fibh->sbh = fibh->ebh;
 		}
 
@@ -541,7 +541,7 @@ add:
 		fibh->eoffset += nfidlen - sb->s_blocksize;
 		if (fibh->sbh != fibh->ebh)
 		{
-			udf_release_data(fibh->sbh);
+			brelse(fibh->sbh);
 			fibh->sbh = fibh->ebh;
 		}
 
@@ -550,8 +550,8 @@ add:
 
 		if (!(fibh->ebh = udf_bread(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2), 1, err)))
 		{
-			udf_release_data(epos.bh);
-			udf_release_data(fibh->sbh);
+			brelse(epos.bh);
+			brelse(fibh->sbh);
 			return NULL;
 		}
 
@@ -566,7 +566,7 @@ add:
 			else
 				block ++;
 
-			udf_release_data(fibh->sbh);
+			brelse(fibh->sbh);
 			fibh->sbh = fibh->ebh;
 			fi = (struct fileIdentDesc *)(fibh->sbh->b_data);
 		}
@@ -587,7 +587,7 @@ add:
 	cfi->lengthOfImpUse = cpu_to_le16(0);
 	if (!udf_write_fi(dir, cfi, fi, fibh, NULL, name))
 	{
-		udf_release_data(epos.bh);
+		brelse(epos.bh);
 		dir->i_size += nfidlen;
 		if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
 			UDF_I_LENALLOC(dir) += nfidlen;
@@ -596,10 +596,10 @@ add:
 	}
 	else
 	{
-		udf_release_data(epos.bh);
+		brelse(epos.bh);
 		if (fibh->sbh != fibh->ebh)
-			udf_release_data(fibh->ebh);
-		udf_release_data(fibh->sbh);
+			brelse(fibh->ebh);
+		brelse(fibh->sbh);
 		*err = -EIO;
 		return NULL;
 	}
@@ -656,8 +656,8 @@ static int udf_create(struct inode *dir,
 		mark_inode_dirty(dir);
 	}
 	if (fibh.sbh != fibh.ebh)
-		udf_release_data(fibh.ebh);
-	udf_release_data(fibh.sbh);
+		brelse(fibh.ebh);
+	brelse(fibh.sbh);
 	unlock_kernel();
 	d_instantiate(dentry, inode);
 	return 0;
@@ -701,8 +701,8 @@ static int udf_mknod(struct inode * dir,
 	mark_inode_dirty(inode);
 
 	if (fibh.sbh != fibh.ebh)
-		udf_release_data(fibh.ebh);
-	udf_release_data(fibh.sbh);
+		brelse(fibh.ebh);
+	brelse(fibh.sbh);
 	d_instantiate(dentry, inode);
 	err = 0;
 out:
@@ -743,7 +743,7 @@ static int udf_mkdir(struct inode * dir,
 		cpu_to_le32(UDF_I_UNIQUE(dir) & 0x00000000FFFFFFFFUL);
 	cfi.fileCharacteristics = FID_FILE_CHAR_DIRECTORY | FID_FILE_CHAR_PARENT;
 	udf_write_fi(inode, &cfi, fi, &fibh, NULL, NULL);
-	udf_release_data(fibh.sbh);
+	brelse(fibh.sbh);
 	inode->i_mode = S_IFDIR | mode;
 	if (dir->i_mode & S_ISGID)
 		inode->i_mode |= S_ISGID;
@@ -766,8 +766,8 @@ static int udf_mkdir(struct inode * dir,
 	mark_inode_dirty(dir);
 	d_instantiate(dentry, inode);
 	if (fibh.sbh != fibh.ebh)
-		udf_release_data(fibh.ebh);
-	udf_release_data(fibh.sbh);
+		brelse(fibh.ebh);
+	brelse(fibh.sbh);
 	err = 0;
 out:
 	unlock_kernel();
@@ -808,13 +808,13 @@ static int empty_dir(struct inode *dir)
 
 		if (!(fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block)))
 		{
-			udf_release_data(epos.bh);
+			brelse(epos.bh);
 			return 0;
 		}
 	}
 	else
 	{
-		udf_release_data(epos.bh);
+		brelse(epos.bh);
 		return 0;
 	}
 
@@ -826,25 +826,25 @@ static int empty_dir(struct inode *dir)
 		if (!fi)
 		{
 			if (fibh.sbh != fibh.ebh)
-				udf_release_data(fibh.ebh);
-			udf_release_data(fibh.sbh);
-			udf_release_data(epos.bh);
+				brelse(fibh.ebh);
+			brelse(fibh.sbh);
+			brelse(epos.bh);
 			return 0;
 		}
 
 		if (cfi.lengthFileIdent && (cfi.fileCharacteristics & FID_FILE_CHAR_DELETED) == 0)
 		{
 			if (fibh.sbh != fibh.ebh)
-				udf_release_data(fibh.ebh);
-			udf_release_data(fibh.sbh);
-			udf_release_data(epos.bh);
+				brelse(fibh.ebh);
+			brelse(fibh.sbh);
+			brelse(epos.bh);
 			return 0;
 		}
 	}
 	if (fibh.sbh != fibh.ebh)
-		udf_release_data(fibh.ebh);
-	udf_release_data(fibh.sbh);
-	udf_release_data(epos.bh);
+		brelse(fibh.ebh);
+	brelse(fibh.sbh);
+	brelse(epos.bh);
 	return 1;
 }
 
@@ -884,8 +884,8 @@ static int udf_rmdir(struct inode * dir,
 
 end_rmdir:
 	if (fibh.sbh != fibh.ebh)
-		udf_release_data(fibh.ebh);
-	udf_release_data(fibh.sbh);
+		brelse(fibh.ebh);
+	brelse(fibh.sbh);
 out:
 	unlock_kernel();
 	return retval;
@@ -928,8 +928,8 @@ static int udf_unlink(struct inode * dir
 
 end_unlink:
 	if (fibh.sbh != fibh.ebh)
-		udf_release_data(fibh.ebh);
-	udf_release_data(fibh.sbh);
+		brelse(fibh.ebh);
+	brelse(fibh.sbh);
 out:
 	unlock_kernel();
 	return retval;
@@ -977,7 +977,7 @@ static int udf_symlink(struct inode * di
 		elen = inode->i_sb->s_blocksize;
 		UDF_I_LENEXTENTS(inode) = elen;
 		udf_add_aext(inode, &epos, eloc, elen, 0);
-		udf_release_data(epos.bh);
+		brelse(epos.bh);
 
 		block = udf_get_pblock(inode->i_sb, block,
 			UDF_I_LOCATION(inode).partitionReferenceNum, 0);
@@ -1060,7 +1060,7 @@ static int udf_symlink(struct inode * di
 		}
 	}
 
-	udf_release_data(epos.bh);
+	brelse(epos.bh);
 	inode->i_size = elen;
 	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB)
 		UDF_I_LENALLOC(inode) = inode->i_size;
@@ -1089,8 +1089,8 @@ static int udf_symlink(struct inode * di
 		mark_inode_dirty(dir);
 	}
 	if (fibh.sbh != fibh.ebh)
-		udf_release_data(fibh.ebh);
-	udf_release_data(fibh.sbh);
+		brelse(fibh.ebh);
+	brelse(fibh.sbh);
 	d_instantiate(dentry, inode);
 	err = 0;
 
@@ -1145,8 +1145,8 @@ static int udf_link(struct dentry * old_
 		mark_inode_dirty(dir);
 	}
 	if (fibh.sbh != fibh.ebh)
-		udf_release_data(fibh.ebh);
-	udf_release_data(fibh.sbh);
+		brelse(fibh.ebh);
+	brelse(fibh.sbh);
 	inc_nlink(inode);
 	inode->i_ctime = current_fs_time(inode->i_sb);
 	mark_inode_dirty(inode);
@@ -1174,8 +1174,8 @@ static int udf_rename (struct inode * ol
 	if ((ofi = udf_find_entry(old_dir, old_dentry, &ofibh, &ocfi)))
 	{
 		if (ofibh.sbh != ofibh.ebh)
-			udf_release_data(ofibh.ebh);
-		udf_release_data(ofibh.sbh);
+			brelse(ofibh.ebh);
+		brelse(ofibh.sbh);
 	}
 	tloc = lelb_to_cpu(ocfi.icb.extLocation);
 	if (!ofi || udf_get_lb_pblock(old_dir->i_sb, tloc, 0)
@@ -1188,8 +1188,8 @@ static int udf_rename (struct inode * ol
 		if (!new_inode)
 		{
 			if (nfibh.sbh != nfibh.ebh)
-				udf_release_data(nfibh.ebh);
-			udf_release_data(nfibh.sbh);
+				brelse(nfibh.ebh);
+			brelse(nfibh.sbh);
 			nfi = NULL;
 		}
 	}
@@ -1290,19 +1290,19 @@ static int udf_rename (struct inode * ol
 	if (ofi)
 	{
 		if (ofibh.sbh != ofibh.ebh)
-			udf_release_data(ofibh.ebh);
-		udf_release_data(ofibh.sbh);
+			brelse(ofibh.ebh);
+		brelse(ofibh.sbh);
 	}
 
 	retval = 0;
 
 end_rename:
-	udf_release_data(dir_bh);
+	brelse(dir_bh);
 	if (nfi)
 	{
 		if (nfibh.sbh != nfibh.ebh)
-			udf_release_data(nfibh.ebh);
-		udf_release_data(nfibh.sbh);
+			brelse(nfibh.ebh);
+		brelse(nfibh.sbh);
 	}
 	unlock_kernel();
 	return retval;
diff -rupX /home/jack/.kerndiffexclude linux-2.6.20-2-udf_extent_position_t/fs/udf/partition.c linux-2.6.20-3-udf_buffer_handling/fs/udf/partition.c
--- linux-2.6.20-2-udf_extent_position_t/fs/udf/partition.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6.20-3-udf_buffer_handling/fs/udf/partition.c	2007-02-22 14:57:59.000000000 +0100
@@ -81,7 +81,7 @@ uint32_t udf_get_pblock_virt15(struct su
 
 	loc = le32_to_cpu(((__le32 *)bh->b_data)[index]);
 
-	udf_release_data(bh);
+	brelse(bh);
 
 	if (UDF_I_LOCATION(UDF_SB_VAT(sb)).partitionReferenceNum == partition)
 	{
diff -rupX /home/jack/.kerndiffexclude linux-2.6.20-2-udf_extent_position_t/fs/udf/super.c linux-2.6.20-3-udf_buffer_handling/fs/udf/super.c
--- linux-2.6.20-2-udf_extent_position_t/fs/udf/super.c	2007-02-22 14:52:17.000000000 +0100
+++ linux-2.6.20-3-udf_buffer_handling/fs/udf/super.c	2007-02-22 14:57:59.000000000 +0100
@@ -565,7 +565,7 @@ udf_vrs(struct super_block *sb, int sile
 
 		if (vsd->stdIdent[0] == 0)
 		{
-			udf_release_data(bh);
+			brelse(bh);
 			break;
 		}
 		else if (!strncmp(vsd->stdIdent, VSD_STD_ID_CD001, VSD_STD_ID_LEN))
@@ -598,7 +598,7 @@ udf_vrs(struct super_block *sb, int sile
 		}
 		else if (!strncmp(vsd->stdIdent, VSD_STD_ID_TEA01, VSD_STD_ID_LEN))
 		{
-			udf_release_data(bh);
+			brelse(bh);
 			break;
 		}
 		else if (!strncmp(vsd->stdIdent, VSD_STD_ID_NSR02, VSD_STD_ID_LEN))
@@ -609,7 +609,7 @@ udf_vrs(struct super_block *sb, int sile
 		{
 			nsr03 = sector;
 		}
-		udf_release_data(bh);
+		brelse(bh);
 	}
 
 	if (nsr03)
@@ -675,7 +675,7 @@ udf_find_anchor(struct super_block *sb)
 			{
 				ident = le16_to_cpu(((tag *)bh->b_data)->tagIdent);
 				location = le32_to_cpu(((tag *)bh->b_data)->tagLocation);
-				udf_release_data(bh);
+				brelse(bh);
 			}
 
 			if (ident == TAG_IDENT_AVDP)
@@ -710,7 +710,7 @@ udf_find_anchor(struct super_block *sb)
 				{
 					ident = le16_to_cpu(((tag *)bh->b_data)->tagIdent);
 					location = le32_to_cpu(((tag *)bh->b_data)->tagLocation);
-					udf_release_data(bh);
+					brelse(bh);
 				}
 	
 				if (ident == TAG_IDENT_AVDP &&
@@ -729,7 +729,7 @@ udf_find_anchor(struct super_block *sb)
 					{
 						ident = le16_to_cpu(((tag *)bh->b_data)->tagIdent);
 						location = le32_to_cpu(((tag *)bh->b_data)->tagLocation);
-						udf_release_data(bh);
+						brelse(bh);
 					}
 	
 					if (ident == TAG_IDENT_AVDP &&
@@ -751,7 +751,7 @@ udf_find_anchor(struct super_block *sb)
 		{
 			ident = le16_to_cpu(((tag *)bh->b_data)->tagIdent);
 			location = le32_to_cpu(((tag *)bh->b_data)->tagLocation);
-			udf_release_data(bh);
+			brelse(bh);
 
 			if (ident == TAG_IDENT_AVDP && location == 256)
 				UDF_SET_FLAG(sb, UDF_FLAG_VARCONV);
@@ -768,7 +768,7 @@ udf_find_anchor(struct super_block *sb)
 			}
 			else
 			{
-				udf_release_data(bh);
+				brelse(bh);
 				if ((ident != TAG_IDENT_AVDP) && (i ||
 					(ident != TAG_IDENT_FE && ident != TAG_IDENT_EFE)))
 				{
@@ -797,7 +797,7 @@ udf_find_fileset(struct super_block *sb,
 			return 1;
 		else if (ident != TAG_IDENT_FSD)
 		{
-			udf_release_data(bh);
+			brelse(bh);
 			return 1;
 		}
 			
@@ -836,7 +836,7 @@ udf_find_fileset(struct super_block *sb,
 						newfileset.logicalBlockNum += 1 +
 							((le32_to_cpu(sp->numOfBytes) + sizeof(struct spaceBitmapDesc) - 1)
 								>> sb->s_blocksize_bits);
-						udf_release_data(bh);
+						brelse(bh);
 						break;
 					}
 					case TAG_IDENT_FSD:
@@ -847,7 +847,7 @@ udf_find_fileset(struct super_block *sb,
 					default:
 					{
 						newfileset.logicalBlockNum ++;
-						udf_release_data(bh);
+						brelse(bh);
 						bh = NULL;
 						break;
 					}
@@ -867,7 +867,7 @@ udf_find_fileset(struct super_block *sb,
 
 		UDF_SB_PARTITION(sb) = fileset->partitionReferenceNum;
 		udf_load_fileset(sb, bh, root);
-		udf_release_data(bh);
+		brelse(bh);
 		return 0;
 	}
 	return 1;
@@ -1085,7 +1085,7 @@ udf_load_logicalvol(struct super_block *
 						if (ident != 0 ||
 							strncmp(st->sparingIdent.ident, UDF_ID_SPARING, strlen(UDF_ID_SPARING)))
 						{
-							udf_release_data(UDF_SB_TYPESPAR(sb,i).s_spar_map[j]);
+							brelse(UDF_SB_TYPESPAR(sb,i).s_spar_map[j]);
 							UDF_SB_TYPESPAR(sb,i).s_spar_map[j] = NULL;
 						}
 					}
@@ -1139,12 +1139,12 @@ udf_load_logicalvolint(struct super_bloc
 			udf_load_logicalvolint(sb, leea_to_cpu(UDF_SB_LVID(sb)->nextIntegrityExt));
 		
 		if (UDF_SB_LVIDBH(sb) != bh)
-			udf_release_data(bh);
+			brelse(bh);
 		loc.extLength -= sb->s_blocksize;
 		loc.extLocation ++;
 	}
 	if (UDF_SB_LVIDBH(sb) != bh)
-		udf_release_data(bh);
+		brelse(bh);
 }
 
 /*
@@ -1247,7 +1247,7 @@ udf_process_sequence(struct super_block 
 					done = 1;
 				break;
 		}
-		udf_release_data(bh);
+		brelse(bh);
 	}
 	for (i=0; i<VDS_POS_LENGTH; i++)
 	{
@@ -1269,10 +1269,10 @@ udf_process_sequence(struct super_block 
 					gd = (struct generic_desc *)bh2->b_data;
 					if (ident == TAG_IDENT_PD)
 						udf_load_partdesc(sb, bh2);
-					udf_release_data(bh2);
+					brelse(bh2);
 				}
 			}
-			udf_release_data(bh);
+			brelse(bh);
 		}
 	}
 
@@ -1335,7 +1335,7 @@ udf_load_partition(struct super_block *s
 			reserve_e = reserve_e >> sb->s_blocksize_bits;
 			reserve_e += reserve_s;
 
-			udf_release_data(bh);
+			brelse(bh);
 
 			/* Process the main & reserve sequences */
 			/* responsible for finding the PartitionDesc(s) */
@@ -1410,7 +1410,7 @@ udf_load_partition(struct super_block *s
 							udf_ext0_offset(UDF_SB_VAT(sb));
 					UDF_SB_TYPEVIRT(sb,i).s_num_entries = (UDF_SB_VAT(sb)->i_size -
 						UDF_SB_TYPEVIRT(sb,i).s_start_offset) >> 2;
-					udf_release_data(bh);
+					brelse(bh);
 				}
 				UDF_SB_PARTROOT(sb,i) = udf_get_pblock(sb, 0, i, 0);
 				UDF_SB_PARTLEN(sb,i) = UDF_SB_PARTLEN(sb,ino.partitionReferenceNum);
@@ -1682,7 +1682,7 @@ error_out:
 		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15)
 		{
 			for (i=0; i<4; i++)
-				udf_release_data(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
+				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
 		}
 	}
 #ifdef CONFIG_UDF_NLS
@@ -1691,7 +1691,7 @@ error_out:
 #endif
 	if (!(sb->s_flags & MS_RDONLY))
 		udf_close_lvid(sb);
-	udf_release_data(UDF_SB_LVIDBH(sb));
+	brelse(UDF_SB_LVIDBH(sb));
 	UDF_SB_FREE(sb);
 	kfree(sbi);
 	sb->s_fs_info = NULL;
@@ -1760,7 +1760,7 @@ udf_put_super(struct super_block *sb)
 		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15)
 		{
 			for (i=0; i<4; i++)
-				udf_release_data(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
+				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
 		}
 	}
 #ifdef CONFIG_UDF_NLS
@@ -1769,7 +1769,7 @@ udf_put_super(struct super_block *sb)
 #endif
 	if (!(sb->s_flags & MS_RDONLY))
 		udf_close_lvid(sb);
-	udf_release_data(UDF_SB_LVIDBH(sb));
+	brelse(UDF_SB_LVIDBH(sb));
 	UDF_SB_FREE(sb);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
@@ -1839,7 +1839,7 @@ udf_count_free_bitmap(struct super_block
 	}
 	else if (ident != TAG_IDENT_SBD)
 	{
-		udf_release_data(bh);
+		brelse(bh);
 		printk(KERN_ERR "udf: udf_count_free failed\n");
 		goto out;
 	}
@@ -1861,7 +1861,7 @@ udf_count_free_bitmap(struct super_block
 		}
 		if ( bytes )
 		{
-			udf_release_data(bh);
+			brelse(bh);
 			newblock = udf_get_lb_pblock(sb, loc, ++block);
 			bh = udf_tread(sb, newblock);
 			if (!bh)
@@ -1873,7 +1873,7 @@ udf_count_free_bitmap(struct super_block
 			ptr = (uint8_t *)bh->b_data;
 		}
 	}
-	udf_release_data(bh);
+	brelse(bh);
 
 out:
 	unlock_kernel();
@@ -1898,7 +1898,7 @@ udf_count_free_table(struct super_block 
 
 	while ((etype = udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1)
 		accum += (elen >> table->i_sb->s_blocksize_bits);
-	udf_release_data(epos.bh);
+	brelse(epos.bh);
 
 	unlock_kernel();
 
diff -rupX /home/jack/.kerndiffexclude linux-2.6.20-2-udf_extent_position_t/fs/udf/symlink.c linux-2.6.20-3-udf_buffer_handling/fs/udf/symlink.c
--- linux-2.6.20-2-udf_extent_position_t/fs/udf/symlink.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6.20-3-udf_buffer_handling/fs/udf/symlink.c	2007-02-22 14:57:59.000000000 +0100
@@ -95,7 +95,7 @@ static int udf_symlink_filler(struct fil
 	}
 
 	udf_pc_to_char(inode->i_sb, symlink, inode->i_size, p);
-	udf_release_data(bh);
+	brelse(bh);
 
 	unlock_kernel();
 	SetPageUptodate(page);
diff -rupX /home/jack/.kerndiffexclude linux-2.6.20-2-udf_extent_position_t/fs/udf/truncate.c linux-2.6.20-3-udf_buffer_handling/fs/udf/truncate.c
--- linux-2.6.20-2-udf_extent_position_t/fs/udf/truncate.c	2007-03-06 15:02:06.000000000 +0100
+++ linux-2.6.20-3-udf_buffer_handling/fs/udf/truncate.c	2007-03-06 15:02:33.000000000 +0100
@@ -119,7 +119,7 @@ void udf_discard_prealloc(struct inode *
 	}
 	UDF_I_LENEXTENTS(inode) = lbcount;
 
-	udf_release_data(epos.bh);
+	brelse(epos.bh);
 }
 
 void udf_truncate_extents(struct inode * inode)
@@ -287,5 +287,5 @@ void udf_truncate_extents(struct inode *
 	}
 	UDF_I_LENEXTENTS(inode) = inode->i_size;
 
-	udf_release_data(epos.bh);
+	brelse(epos.bh);
 }
diff -rupX /home/jack/.kerndiffexclude linux-2.6.20-2-udf_extent_position_t/fs/udf/udfdecl.h linux-2.6.20-3-udf_buffer_handling/fs/udf/udfdecl.h
--- linux-2.6.20-2-udf_extent_position_t/fs/udf/udfdecl.h	2007-02-22 14:52:17.000000000 +0100
+++ linux-2.6.20-3-udf_buffer_handling/fs/udf/udfdecl.h	2007-02-26 17:13:47.000000000 +0100
@@ -106,6 +106,7 @@ extern void udf_delete_inode(struct inod
 extern void udf_clear_inode(struct inode *);
 extern int udf_write_inode(struct inode *, int);
 extern long udf_block_map(struct inode *, sector_t);
+extern int udf_extend_file(struct inode *, struct extent_position *, kernel_long_ad *, sector_t);
 extern int8_t inode_bmap(struct inode *, sector_t, struct extent_position *, kernel_lb_addr *, uint32_t *, sector_t *);
 extern int8_t udf_add_aext(struct inode *, struct extent_position *, kernel_lb_addr, uint32_t, int);
 extern int8_t udf_write_aext(struct inode *, struct extent_position *, kernel_lb_addr, uint32_t, int);
@@ -120,7 +121,6 @@ extern struct genericFormat *udf_add_ext
 extern struct genericFormat *udf_get_extendedattr(struct inode *, uint32_t, uint8_t);
 extern struct buffer_head *udf_read_tagged(struct super_block *, uint32_t, uint32_t, uint16_t *);
 extern struct buffer_head *udf_read_ptagged(struct super_block *, kernel_lb_addr, uint32_t, uint16_t *);
-extern void udf_release_data(struct buffer_head *);
 extern void udf_update_tag(char *, int);
 extern void udf_new_tag(char *, uint16_t, uint16_t, uint16_t, uint32_t, int);
 
diff -rupX /home/jack/.kerndiffexclude linux-2.6.20-2-udf_extent_position_t/fs/udf/udf_sb.h linux-2.6.20-3-udf_buffer_handling/fs/udf/udf_sb.h
--- linux-2.6.20-2-udf_extent_position_t/fs/udf/udf_sb.h	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6.20-3-udf_buffer_handling/fs/udf/udf_sb.h	2007-02-22 14:57:59.000000000 +0100
@@ -93,7 +93,7 @@ static inline struct udf_sb_info *UDF_SB
 	for (i=0; i<nr_groups; i++)\
 	{\
 		if (UDF_SB_BITMAP(X,Y,Z,i))\
-			udf_release_data(UDF_SB_BITMAP(X,Y,Z,i));\
+			brelse(UDF_SB_BITMAP(X,Y,Z,i));\
 	}\
 	if (size <= PAGE_SIZE)\
 		kfree(UDF_SB_PARTMAPS(X)[Y].Z.s_bitmap);\
