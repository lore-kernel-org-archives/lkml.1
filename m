Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbYBJKeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbYBJKeB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 05:34:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYBJKdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 05:33:53 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:12121 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbYBJKdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 05:33:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=KadczZg9FQtzqJGw6aV7moFcNsuGaA8XPoNaF2nbx8/RsUlVYtD1Sl9tLgY4N3NSgs0eQLZOi2NESeOMMWdQ5yt8Ye6/u1eAQHwp3isb0OVMEaLHwercNswXTfOUZB3vLnPi0y0/nwhYKYT1M9H7uIrjOOSJFBJK+5MzGU5uoPc=
Date: Sun, 10 Feb 2008 11:33:08 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] udf: super.c reorganization
Message-ID: <20080210103257.GG6737@joi>
References: <1202063771-18172-1-git-send-email-marcin.slusarz@gmail.com> <20080203184230.GA18219@joi> <20080205162219.GK25464@duck.suse.cz> <20080205193417.GC6332@joi> <20080206110936.GC12547@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206110936.GC12547@duck.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 12:09:36PM +0100, Jan Kara wrote:
> On Tue 05-02-08 20:34:49, Marcin Slusarz wrote:
> > On Tue, Feb 05, 2008 at 05:22:19PM +0100, Jan Kara wrote:
> > >   Actually, the loop below would be even more readable it you did:
> > > 
> > >   if (map->s_partition_num == le16_to_cpu(p->partitionNumber))
> > >     break;
> > >   And do the work after we exit from the loop.
> > > 
> > > 
(...)
> > 
> > Ok. I didn't notice that. But it won't be as trivial as the rest. Separate patch?
>   You're reindenting the code anyway, so moving it to another place isn't a
> big deal (doesn't make review any harder). So you can just merge it into
> the same patch. Thanks.
As you wish.

---
udf: super.c reorganization

reorganize few code blocks in super.c which
were needlessly indented (and hard to read):

so change from:
rettype fun()
{
	init;
	if (sth) {
		long block of code;
	}
}

to:
rettype fun()
{
	init;
	if (!sth)
		return;
	long block of code;
}

or

from:
rettype fun2()
{
	init;
	while (sth) {
		init2();
		if (sth2) {
			long block of code;
		}
	}
}

to:
rettype fun2()
{
	init;
	while (sth) {
		init2();
		if (!sth2)
			continue;
		long block of code;
	}
}

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/super.c |  552 +++++++++++++++++++++++++++-----------------------------
 1 files changed, 270 insertions(+), 282 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 56d9efb..45d7b62 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -864,18 +864,18 @@ static void udf_find_anchor(struct super_block *sb)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(sbi->s_anchor); i++) {
-		if (sbi->s_anchor[i]) {
-			bh = udf_read_tagged(sb, sbi->s_anchor[i],
-					     sbi->s_anchor[i], &ident);
-			if (!bh)
+		if (!sbi->s_anchor[i])
+			continue;
+		bh = udf_read_tagged(sb, sbi->s_anchor[i],
+					sbi->s_anchor[i], &ident);
+		if (!bh)
+			sbi->s_anchor[i] = 0;
+		else {
+			brelse(bh);
+			if ((ident != TAG_IDENT_AVDP) &&
+				(i || (ident != TAG_IDENT_FE &&
+					ident != TAG_IDENT_EFE)))
 				sbi->s_anchor[i] = 0;
-			else {
-				brelse(bh);
-				if ((ident != TAG_IDENT_AVDP) &&
-				    (i || (ident != TAG_IDENT_FE &&
-					   ident != TAG_IDENT_EFE)))
-					sbi->s_anchor[i] = 0;
-			}
 		}
 	}
 
@@ -1058,128 +1058,118 @@ static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, u32 index)
 
 static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 {
-	struct partitionDesc *p;
-	int i;
+	struct partitionHeaderDesc *phd;
+	struct partitionDesc *p = (struct partitionDesc *)bh->b_data;
 	struct udf_part_map *map;
-	struct udf_sb_info *sbi;
-
-	p = (struct partitionDesc *)bh->b_data;
-	sbi = UDF_SB(sb);
+	struct udf_sb_info *sbi = UDF_SB(sb);
+	bool found = false;
+	int i;
+	u16 partitionNumber = le16_to_cpu(p->partitionNumber);
 
 	for (i = 0; i < sbi->s_partitions; i++) {
 		map = &sbi->s_partmaps[i];
 		udf_debug("Searching map: (%d == %d)\n",
-			  map->s_partition_num,
-			  le16_to_cpu(p->partitionNumber));
-		if (map->s_partition_num ==
-				le16_to_cpu(p->partitionNumber)) {
-			map->s_partition_len =
-				le32_to_cpu(p->partitionLength); /* blocks */
-			map->s_partition_root =
-				le32_to_cpu(p->partitionStartingLocation);
-			if (p->accessType ==
-					cpu_to_le32(PD_ACCESS_TYPE_READ_ONLY))
-				map->s_partition_flags |=
-						UDF_PART_FLAG_READ_ONLY;
-			if (p->accessType ==
-					cpu_to_le32(PD_ACCESS_TYPE_WRITE_ONCE))
-				map->s_partition_flags |=
-						UDF_PART_FLAG_WRITE_ONCE;
-			if (p->accessType ==
-					cpu_to_le32(PD_ACCESS_TYPE_REWRITABLE))
-				map->s_partition_flags |=
-						UDF_PART_FLAG_REWRITABLE;
-			if (p->accessType ==
-				    cpu_to_le32(PD_ACCESS_TYPE_OVERWRITABLE))
-				map->s_partition_flags |=
-						UDF_PART_FLAG_OVERWRITABLE;
-
-			if (!strcmp(p->partitionContents.ident,
-				    PD_PARTITION_CONTENTS_NSR02) ||
-			    !strcmp(p->partitionContents.ident,
-				    PD_PARTITION_CONTENTS_NSR03)) {
-				struct partitionHeaderDesc *phd;
-
-				phd = (struct partitionHeaderDesc *)
-						(p->partitionContentsUse);
-				if (phd->unallocSpaceTable.extLength) {
-					kernel_lb_addr loc = {
-						.logicalBlockNum = le32_to_cpu(phd->unallocSpaceTable.extPosition),
-						.partitionReferenceNum = i,
-					};
-
-					map->s_uspace.s_table =
-						udf_iget(sb, loc);
-					if (!map->s_uspace.s_table) {
-						udf_debug("cannot load unallocSpaceTable (part %d)\n", i);
-						return 1;
-					}
-					map->s_partition_flags |=
-						UDF_PART_FLAG_UNALLOC_TABLE;
-					udf_debug("unallocSpaceTable (part %d) @ %ld\n",
-						  i, map->s_uspace.s_table->i_ino);
-				}
-				if (phd->unallocSpaceBitmap.extLength) {
-					struct udf_bitmap *bitmap =
-						udf_sb_alloc_bitmap(sb, i);
-					map->s_uspace.s_bitmap = bitmap;
-					if (bitmap != NULL) {
-						bitmap->s_extLength =
-							le32_to_cpu(phd->unallocSpaceBitmap.extLength);
-						bitmap->s_extPosition =
-							le32_to_cpu(phd->unallocSpaceBitmap.extPosition);
-						map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_BITMAP;
-						udf_debug("unallocSpaceBitmap (part %d) @ %d\n",
-							  i, bitmap->s_extPosition);
-					}
-				}
-				if (phd->partitionIntegrityTable.extLength)
-					udf_debug("partitionIntegrityTable (part %d)\n", i);
-				if (phd->freedSpaceTable.extLength) {
-					kernel_lb_addr loc = {
-						.logicalBlockNum = le32_to_cpu(phd->freedSpaceTable.extPosition),
-						.partitionReferenceNum = i,
-					};
-
-					map->s_fspace.s_table =
-						udf_iget(sb, loc);
-					if (!map->s_fspace.s_table) {
-						udf_debug("cannot load freedSpaceTable (part %d)\n", i);
-						return 1;
-					}
-					map->s_partition_flags |=
-						UDF_PART_FLAG_FREED_TABLE;
-					udf_debug("freedSpaceTable (part %d) @ %ld\n",
-						  i, map->s_fspace.s_table->i_ino);
-				}
-				if (phd->freedSpaceBitmap.extLength) {
-					struct udf_bitmap *bitmap =
-						udf_sb_alloc_bitmap(sb, i);
-					map->s_fspace.s_bitmap = bitmap;
-					if (bitmap != NULL) {
-						bitmap->s_extLength =
-							le32_to_cpu(phd->freedSpaceBitmap.extLength);
-						bitmap->s_extPosition =
-							le32_to_cpu(phd->freedSpaceBitmap.extPosition);
-						map->s_partition_flags |= UDF_PART_FLAG_FREED_BITMAP;
-						udf_debug("freedSpaceBitmap (part %d) @ %d\n",
-							  i, bitmap->s_extPosition);
-					}
-				}
-			}
+			  map->s_partition_num, partitionNumber);
+		found = map->s_partition_num == partitionNumber;
+		if (found)
 			break;
-		}
 	}
-	if (i == sbi->s_partitions)
+
+	if (!found) {
 		udf_debug("Partition (%d) not found in partition map\n",
-			  le16_to_cpu(p->partitionNumber));
-	else
-		udf_debug("Partition (%d:%d type %x) starts at physical %d, "
-			  "block length %d\n",
-			  le16_to_cpu(p->partitionNumber), i,
-			  map->s_partition_type,
-			  map->s_partition_root,
-			  map->s_partition_len);
+			  partitionNumber);
+		return 0;
+	}
+
+	map->s_partition_len = le32_to_cpu(p->partitionLength); /* blocks */
+	map->s_partition_root = le32_to_cpu(p->partitionStartingLocation);
+
+	if (p->accessType == cpu_to_le32(PD_ACCESS_TYPE_READ_ONLY))
+		map->s_partition_flags |= UDF_PART_FLAG_READ_ONLY;
+	if (p->accessType == cpu_to_le32(PD_ACCESS_TYPE_WRITE_ONCE))
+		map->s_partition_flags |= UDF_PART_FLAG_WRITE_ONCE;
+	if (p->accessType == cpu_to_le32(PD_ACCESS_TYPE_REWRITABLE))
+		map->s_partition_flags |= UDF_PART_FLAG_REWRITABLE;
+	if (p->accessType == cpu_to_le32(PD_ACCESS_TYPE_OVERWRITABLE))
+		map->s_partition_flags |= UDF_PART_FLAG_OVERWRITABLE;
+
+	udf_debug("Partition (%d:%d type %x) starts at physical %d, "
+		  "block length %d\n", partitionNumber, i,
+		  map->s_partition_type, map->s_partition_root,
+		  map->s_partition_len);
+
+	if (strcmp(p->partitionContents.ident, PD_PARTITION_CONTENTS_NSR02) &&
+	    strcmp(p->partitionContents.ident, PD_PARTITION_CONTENTS_NSR03))
+		return 0;
+
+	phd = (struct partitionHeaderDesc *)p->partitionContentsUse;
+	if (phd->unallocSpaceTable.extLength) {
+		kernel_lb_addr loc = {
+			.logicalBlockNum = le32_to_cpu(
+				phd->unallocSpaceTable.extPosition),
+			.partitionReferenceNum = i,
+		};
+
+		map->s_uspace.s_table = udf_iget(sb, loc);
+		if (!map->s_uspace.s_table) {
+			udf_debug("cannot load unallocSpaceTable (part %d)\n",
+					i);
+			return 1;
+		}
+		map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_TABLE;
+		udf_debug("unallocSpaceTable (part %d) @ %ld\n",
+				i, map->s_uspace.s_table->i_ino);
+	}
+
+	if (phd->unallocSpaceBitmap.extLength) {
+		struct udf_bitmap *bitmap = udf_sb_alloc_bitmap(sb, i);
+		map->s_uspace.s_bitmap = bitmap;
+		if (bitmap != NULL) {
+			bitmap->s_extLength = le32_to_cpu(
+				phd->unallocSpaceBitmap.extLength);
+			bitmap->s_extPosition = le32_to_cpu(
+				phd->unallocSpaceBitmap.extPosition);
+			map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_BITMAP;
+			udf_debug("unallocSpaceBitmap (part %d) @ %d\n",
+					i, bitmap->s_extPosition);
+		}
+	}
+
+	if (phd->partitionIntegrityTable.extLength)
+		udf_debug("partitionIntegrityTable (part %d)\n", i);
+
+	if (phd->freedSpaceTable.extLength) {
+		kernel_lb_addr loc = {
+			.logicalBlockNum = le32_to_cpu(
+				phd->freedSpaceTable.extPosition),
+			.partitionReferenceNum = i,
+		};
+
+		map->s_fspace.s_table = udf_iget(sb, loc);
+		if (!map->s_fspace.s_table) {
+			udf_debug("cannot load freedSpaceTable (part %d)\n", i);
+			return 1;
+		}
+
+		map->s_partition_flags |= UDF_PART_FLAG_FREED_TABLE;
+		udf_debug("freedSpaceTable (part %d) @ %ld\n",
+				i, map->s_fspace.s_table->i_ino);
+	}
+
+	if (phd->freedSpaceBitmap.extLength) {
+		struct udf_bitmap *bitmap = udf_sb_alloc_bitmap(sb, i);
+		map->s_fspace.s_bitmap = bitmap;
+		if (bitmap != NULL) {
+			bitmap->s_extLength = le32_to_cpu(
+				phd->freedSpaceBitmap.extLength);
+			bitmap->s_extPosition = le32_to_cpu(
+				phd->freedSpaceBitmap.extPosition);
+			map->s_partition_flags |= UDF_PART_FLAG_FREED_BITMAP;
+			udf_debug("freedSpaceBitmap (part %d) @ %d\n",
+					i, bitmap->s_extPosition);
+		}
+	}
+
 	return 0;
 }
 
@@ -1253,19 +1243,17 @@ static int udf_load_logicalvol(struct super_block *sb, struct buffer_head *bh,
 					map->s_type_specific.s_sparing.
 							s_spar_map[j] = bh2;
 
-					if (bh2 != NULL) {
-						st = (struct sparingTable *)
-								bh2->b_data;
-						if (ident != 0 || strncmp(
-							st->sparingIdent.ident,
-							UDF_ID_SPARING,
-							strlen(UDF_ID_SPARING))) {
-							brelse(bh2);
-							map->s_type_specific.
-								s_sparing.
-								s_spar_map[j] =
-									NULL;
-						}
+					if (bh2 == NULL)
+						continue;
+
+					st = (struct sparingTable *)bh2->b_data;
+					if (ident != 0 || strncmp(
+						st->sparingIdent.ident,
+						UDF_ID_SPARING,
+						strlen(UDF_ID_SPARING))) {
+						brelse(bh2);
+						map->s_type_specific.s_sparing.
+							s_spar_map[j] = NULL;
 					}
 				}
 				map->s_partition_func = udf_get_pblock_spar15;
@@ -1430,40 +1418,40 @@ static int udf_process_sequence(struct super_block *sb, long block,
 		brelse(bh);
 	}
 	for (i = 0; i < VDS_POS_LENGTH; i++) {
-		if (vds[i].block) {
-			bh = udf_read_tagged(sb, vds[i].block, vds[i].block,
-					     &ident);
-
-			if (i == VDS_POS_PRIMARY_VOL_DESC) {
-				udf_load_pvoldesc(sb, bh);
-			} else if (i == VDS_POS_LOGICAL_VOL_DESC) {
-				if (udf_load_logicalvol(sb, bh, fileset)) {
-					brelse(bh);
-					return 1;
-				}
-			} else if (i == VDS_POS_PARTITION_DESC) {
-				struct buffer_head *bh2 = NULL;
-				if (udf_load_partdesc(sb, bh)) {
-					brelse(bh);
-					return 1;
-				}
-				for (j = vds[i].block + 1;
-				     j <  vds[VDS_POS_TERMINATING_DESC].block;
-				     j++) {
-					bh2 = udf_read_tagged(sb, j, j, &ident);
-					gd = (struct generic_desc *)bh2->b_data;
-					if (ident == TAG_IDENT_PD)
-						if (udf_load_partdesc(sb,
-								      bh2)) {
-							brelse(bh);
-							brelse(bh2);
-							return 1;
-						}
-					brelse(bh2);
-				}
+		if (!vds[i].block)
+			continue;
+
+		bh = udf_read_tagged(sb, vds[i].block, vds[i].block,
+					&ident);
+
+		if (i == VDS_POS_PRIMARY_VOL_DESC)
+			udf_load_pvoldesc(sb, bh);
+		else if (i == VDS_POS_LOGICAL_VOL_DESC) {
+			if (udf_load_logicalvol(sb, bh, fileset)) {
+				brelse(bh);
+				return 1;
+			}
+		} else if (i == VDS_POS_PARTITION_DESC) {
+			struct buffer_head *bh2 = NULL;
+			if (udf_load_partdesc(sb, bh)) {
+				brelse(bh);
+				return 1;
+			}
+			for (j = vds[i].block + 1;
+				j <  vds[VDS_POS_TERMINATING_DESC].block;
+				j++) {
+				bh2 = udf_read_tagged(sb, j, j, &ident);
+				gd = (struct generic_desc *)bh2->b_data;
+				if (ident == TAG_IDENT_PD)
+					if (udf_load_partdesc(sb, bh2)) {
+						brelse(bh);
+						brelse(bh2);
+						return 1;
+					}
+				brelse(bh2);
 			}
-			brelse(bh);
 		}
+		brelse(bh);
 	}
 
 	return 0;
@@ -1475,6 +1463,7 @@ static int udf_process_sequence(struct super_block *sb, long block,
 static int udf_check_valid(struct super_block *sb, int novrs, int silent)
 {
 	long block;
+	struct udf_sb_info *sbi;
 
 	if (novrs) {
 		udf_debug("Validity check skipped because of novrs option\n");
@@ -1482,18 +1471,16 @@ static int udf_check_valid(struct super_block *sb, int novrs, int silent)
 	}
 	/* Check that it is NSR02 compliant */
 	/* Process any "CD-ROM Volume Descriptor Set" (ECMA 167 2/8.3.1) */
-	else {
-		block = udf_vrs(sb, silent);
-		if (block == -1) {
-			struct udf_sb_info *sbi = UDF_SB(sb);
-			udf_debug("Failed to read byte 32768. Assuming open "
-				  "disc. Skipping validity check\n");
-			if (!sbi->s_last_block)
-				sbi->s_last_block = udf_get_last_block(sb);
-			return 0;
-		} else
-			return !block;
-	}
+	block = udf_vrs(sb, silent);
+	if (block != -1)
+		return !block;
+
+	sbi = UDF_SB(sb);
+	udf_debug("Failed to read byte 32768. Assuming open "
+			"disc. Skipping validity check\n");
+	if (!sbi->s_last_block)
+		sbi->s_last_block = udf_get_last_block(sb);
+	return 0;
 }
 
 static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
@@ -1512,6 +1499,7 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 	for (i = 0; i < ARRAY_SIZE(sbi->s_anchor); i++) {
 		if (!sbi->s_anchor[i])
 			continue;
+
 		bh = udf_read_tagged(sb, sbi->s_anchor[i], sbi->s_anchor[i],
 				     &ident);
 		if (!bh)
@@ -1553,72 +1541,73 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 	for (i = 0; i < sbi->s_partitions; i++) {
 		kernel_lb_addr uninitialized_var(ino);
 		struct udf_part_map *map = &sbi->s_partmaps[i];
-		switch (map->s_partition_type) {
-		case UDF_VIRTUAL_MAP15:
-		case UDF_VIRTUAL_MAP20:
-			if (!sbi->s_last_block) {
-				sbi->s_last_block = udf_get_last_block(sb);
-				udf_find_anchor(sb);
-			}
 
-			if (!sbi->s_last_block) {
-				udf_debug("Unable to determine Lastblock (For "
-					  "Virtual Partition)\n");
-				return 1;
-			}
+		if (map->s_partition_type != UDF_VIRTUAL_MAP15 &&
+			map->s_partition_type != UDF_VIRTUAL_MAP20)
+			continue;
 
-			for (j = 0; j < sbi->s_partitions; j++) {
-				struct udf_part_map *map2 = &sbi->s_partmaps[j];
-				if (j != i &&
-				    map->s_volumeseqnum ==
-						map2->s_volumeseqnum &&
-				    map->s_partition_num ==
-						map2->s_partition_num) {
-					ino.partitionReferenceNum = j;
-					ino.logicalBlockNum =
-						sbi->s_last_block -
-							map2->s_partition_root;
-					break;
-				}
+		if (!sbi->s_last_block) {
+			sbi->s_last_block = udf_get_last_block(sb);
+			udf_find_anchor(sb);
+		}
+
+		if (!sbi->s_last_block) {
+			udf_debug("Unable to determine Lastblock (For "
+					"Virtual Partition)\n");
+			return 1;
+		}
+
+		for (j = 0; j < sbi->s_partitions; j++) {
+			struct udf_part_map *map2 = &sbi->s_partmaps[j];
+			if (j != i &&
+				map->s_volumeseqnum ==
+					map2->s_volumeseqnum &&
+				map->s_partition_num ==
+					map2->s_partition_num) {
+				ino.partitionReferenceNum = j;
+				ino.logicalBlockNum =
+					sbi->s_last_block -
+						map2->s_partition_root;
+				break;
 			}
+		}
 
-			if (j == sbi->s_partitions)
-				return 1;
+		if (j == sbi->s_partitions)
+			return 1;
 
-			sbi->s_vat_inode = udf_iget(sb, ino);
-			if (!sbi->s_vat_inode)
-				return 1;
+		sbi->s_vat_inode = udf_iget(sb, ino);
+		if (!sbi->s_vat_inode)
+			return 1;
 
-			if (map->s_partition_type == UDF_VIRTUAL_MAP15) {
-				map->s_type_specific.s_virtual.s_start_offset =
-					udf_ext0_offset(sbi->s_vat_inode);
-				map->s_type_specific.s_virtual.s_num_entries =
-					(sbi->s_vat_inode->i_size - 36) >> 2;
-			} else if (map->s_partition_type == UDF_VIRTUAL_MAP20) {
-				uint32_t pos;
-				struct virtualAllocationTable20 *vat20;
-
-				pos = udf_block_map(sbi->s_vat_inode, 0);
-				bh = sb_bread(sb, pos);
-				if (!bh)
-					return 1;
-				vat20 = (struct virtualAllocationTable20 *)
-					bh->b_data +
-					udf_ext0_offset(sbi->s_vat_inode);
-				map->s_type_specific.s_virtual.s_start_offset =
-					le16_to_cpu(vat20->lengthHeader) +
-					udf_ext0_offset(sbi->s_vat_inode);
-				map->s_type_specific.s_virtual.s_num_entries =
-					(sbi->s_vat_inode->i_size -
-					 map->s_type_specific.s_virtual.
-							s_start_offset) >> 2;
-				brelse(bh);
-			}
-			map->s_partition_root = udf_get_pblock(sb, 0, i, 0);
-			map->s_partition_len =
-				sbi->s_partmaps[ino.partitionReferenceNum].
-								s_partition_len;
+		if (map->s_partition_type == UDF_VIRTUAL_MAP15) {
+			map->s_type_specific.s_virtual.s_start_offset =
+				udf_ext0_offset(sbi->s_vat_inode);
+			map->s_type_specific.s_virtual.s_num_entries =
+				(sbi->s_vat_inode->i_size - 36) >> 2;
+		} else if (map->s_partition_type == UDF_VIRTUAL_MAP20) {
+			uint32_t pos;
+			struct virtualAllocationTable20 *vat20;
+
+			pos = udf_block_map(sbi->s_vat_inode, 0);
+			bh = sb_bread(sb, pos);
+			if (!bh)
+				return 1;
+			vat20 = (struct virtualAllocationTable20 *)
+				bh->b_data +
+				udf_ext0_offset(sbi->s_vat_inode);
+			map->s_type_specific.s_virtual.s_start_offset =
+				le16_to_cpu(vat20->lengthHeader) +
+				udf_ext0_offset(sbi->s_vat_inode);
+			map->s_type_specific.s_virtual.s_num_entries =
+				(sbi->s_vat_inode->i_size -
+					map->s_type_specific.s_virtual.
+						s_start_offset) >> 2;
+			brelse(bh);
 		}
+		map->s_partition_root = udf_get_pblock(sb, 0, i, 0);
+		map->s_partition_len =
+			sbi->s_partmaps[ino.partitionReferenceNum].
+							s_partition_len;
 	}
 	return 0;
 }
@@ -1627,26 +1616,26 @@ static void udf_open_lvid(struct super_block *sb)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct buffer_head *bh = sbi->s_lvid_bh;
-	if (bh) {
-		struct logicalVolIntegrityDesc *lvid =
-				(struct logicalVolIntegrityDesc *)bh->b_data;
-		struct logicalVolIntegrityDescImpUse *lvidiu =
-							udf_sb_lvidiu(sbi);
+	struct logicalVolIntegrityDesc *lvid;
+	struct logicalVolIntegrityDescImpUse *lvidiu;
+	if (!bh)
+		return;
 
-		lvidiu->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
-		lvidiu->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
-		udf_time_to_disk_stamp(&lvid->recordingDateAndTime,
-					CURRENT_TIME);
-		lvid->integrityType = LVID_INTEGRITY_TYPE_OPEN;
+	lvid = (struct logicalVolIntegrityDesc *)bh->b_data;
+	lvidiu = udf_sb_lvidiu(sbi);
 
-		lvid->descTag.descCRC = cpu_to_le16(
-			udf_crc((char *)lvid + sizeof(tag),
-				le16_to_cpu(lvid->descTag.descCRCLength),
-				0));
+	lvidiu->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
+	lvidiu->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
+	udf_time_to_disk_stamp(&lvid->recordingDateAndTime,
+				CURRENT_TIME);
+	lvid->integrityType = LVID_INTEGRITY_TYPE_OPEN;
 
-		lvid->descTag.tagChecksum = udf_tag_checksum(&lvid->descTag);
-		mark_buffer_dirty(bh);
-	}
+	lvid->descTag.descCRC = cpu_to_le16(
+		udf_crc((char *)lvid + sizeof(tag),
+			le16_to_cpu(lvid->descTag.descCRCLength), 0));
+
+	lvid->descTag.tagChecksum = udf_tag_checksum(&lvid->descTag);
+	mark_buffer_dirty(bh);
 }
 
 static void udf_close_lvid(struct super_block *sb)
@@ -1654,36 +1643,35 @@ static void udf_close_lvid(struct super_block *sb)
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct buffer_head *bh = sbi->s_lvid_bh;
 	struct logicalVolIntegrityDesc *lvid;
+	struct logicalVolIntegrityDescImpUse *lvidiu;
 
 	if (!bh)
 		return;
 
 	lvid = (struct logicalVolIntegrityDesc *)bh->b_data;
 
-	if (lvid->integrityType == LVID_INTEGRITY_TYPE_OPEN) {
-		struct logicalVolIntegrityDescImpUse *lvidiu =
-							udf_sb_lvidiu(sbi);
-		lvidiu->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
-		lvidiu->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
-		udf_time_to_disk_stamp(&lvid->recordingDateAndTime,
-					CURRENT_TIME);
-		if (UDF_MAX_WRITE_VERSION > le16_to_cpu(lvidiu->maxUDFWriteRev))
-			lvidiu->maxUDFWriteRev =
-					cpu_to_le16(UDF_MAX_WRITE_VERSION);
-		if (sbi->s_udfrev > le16_to_cpu(lvidiu->minUDFReadRev))
-			lvidiu->minUDFReadRev = cpu_to_le16(sbi->s_udfrev);
-		if (sbi->s_udfrev > le16_to_cpu(lvidiu->minUDFWriteRev))
-			lvidiu->minUDFWriteRev = cpu_to_le16(sbi->s_udfrev);
-		lvid->integrityType = cpu_to_le32(LVID_INTEGRITY_TYPE_CLOSE);
-
-		lvid->descTag.descCRC = cpu_to_le16(
-			udf_crc((char *)lvid + sizeof(tag),
-				le16_to_cpu(lvid->descTag.descCRCLength),
-				0));
-
-		lvid->descTag.tagChecksum = udf_tag_checksum(&lvid->descTag);
-		mark_buffer_dirty(bh);
-	}
+	if (lvid->integrityType != LVID_INTEGRITY_TYPE_OPEN)
+		return;
+
+	lvidiu = udf_sb_lvidiu(sbi);
+	lvidiu->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
+	lvidiu->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
+	udf_time_to_disk_stamp(&lvid->recordingDateAndTime, CURRENT_TIME);
+	if (UDF_MAX_WRITE_VERSION > le16_to_cpu(lvidiu->maxUDFWriteRev))
+		lvidiu->maxUDFWriteRev = cpu_to_le16(UDF_MAX_WRITE_VERSION);
+	if (sbi->s_udfrev > le16_to_cpu(lvidiu->minUDFReadRev))
+		lvidiu->minUDFReadRev = cpu_to_le16(sbi->s_udfrev);
+	if (sbi->s_udfrev > le16_to_cpu(lvidiu->minUDFWriteRev))
+		lvidiu->minUDFWriteRev = cpu_to_le16(sbi->s_udfrev);
+	lvid->integrityType = cpu_to_le32(LVID_INTEGRITY_TYPE_CLOSE);
+
+	lvid->descTag.descCRC = cpu_to_le16(
+		udf_crc((char *)lvid + sizeof(tag),
+			le16_to_cpu(lvid->descTag.descCRCLength),
+			0));
+
+	lvid->descTag.tagChecksum = udf_tag_checksum(&lvid->descTag);
+	mark_buffer_dirty(bh);
 }
 
 static void udf_sb_free_bitmap(struct udf_bitmap *bitmap)
-- 
1.5.3.7

