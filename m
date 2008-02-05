Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbYBEQXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbYBEQXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757884AbYBEQWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:22:23 -0500
Received: from styx.suse.cz ([82.119.242.94]:36837 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755594AbYBEQWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:22:21 -0500
Date: Tue, 5 Feb 2008 17:22:19 +0100
From: Jan Kara <jack@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] udf: super.c reorganization
Message-ID: <20080205162219.GK25464@duck.suse.cz>
References: <1202063771-18172-1-git-send-email-marcin.slusarz@gmail.com> <20080203184230.GA18219@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203184230.GA18219@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 03-02-08 19:42:38, Marcin Slusarz wrote:
> reorganize few code blocks in super.c which
> were needlessly indented (and hard to read):
> 
> so change from:
> rettype fun()
> {
> 	init;
> 	if (sth) {
> 		long block of code;
> 	}
> }
> 
> to:
> rettype fun()
> {
> 	init;
> 	if (!sth)
> 		return;
> 	long block of code;
> }
> 
> or
> 
> from:
> rettype fun2()
> {
> 	init;
> 	while (sth) {
> 		init2();
> 		if (sth2) {
> 			long block of code;
> 		}
> 	}
> }
> 
> to:
> rettype fun2()
> {
> 	init;
> 	while (sth) {
> 		init2();
> 		if (!sth2)
> 			continue;
> 		long block of code;
> 	}
> }

  I think change in udf_load_partdesc() should be done differently (see
comment below) but otherwise the patch is fine.

> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
> ---
>  fs/udf/super.c |  519 ++++++++++++++++++++++++++++----------------------------
>  1 files changed, 259 insertions(+), 260 deletions(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 3a7faad..b622d4c 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c

> @@ -798,18 +798,18 @@ static void udf_find_anchor(struct super_block *sb)
>  	}
>  
>  	for (i = 0; i < ARRAY_SIZE(sbi->s_anchor); i++) {
> -		if (sbi->s_anchor[i]) {
> -			bh = udf_read_tagged(sb, sbi->s_anchor[i],
> -					     sbi->s_anchor[i], &ident);
> -			if (!bh)
> +		if (!sbi->s_anchor[i])
> +			continue;
> +		bh = udf_read_tagged(sb, sbi->s_anchor[i],
> +					sbi->s_anchor[i], &ident);
> +		if (!bh)
> +			sbi->s_anchor[i] = 0;
> +		else {
> +			brelse(bh);
> +			if ((ident != TAG_IDENT_AVDP) &&
> +				(i || (ident != TAG_IDENT_FE &&
> +					ident != TAG_IDENT_EFE)))
>  				sbi->s_anchor[i] = 0;
> -			else {
> -				brelse(bh);
> -				if ((ident != TAG_IDENT_AVDP) &&
> -				    (i || (ident != TAG_IDENT_FE &&
> -					   ident != TAG_IDENT_EFE)))
> -					sbi->s_anchor[i] = 0;
> -			}
>  		}
>  	}
>  
> @@ -1001,108 +1001,108 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
>  	sbi = UDF_SB(sb);
>  
  Actually, the loop below would be even more readable it you did:

  if (map->s_partition_num == le16_to_cpu(p->partitionNumber))
    break;
  And do the work after we exit from the loop.


>  	for (i = 0; i < sbi->s_partitions; i++) {
> +		struct partitionHeaderDesc *phd;
> +
>  		map = &sbi->s_partmaps[i];
>  		udf_debug("Searching map: (%d == %d)\n",
>  			  map->s_partition_num,
>  			  le16_to_cpu(p->partitionNumber));
> -		if (map->s_partition_num ==
> -				le16_to_cpu(p->partitionNumber)) {
> -			map->s_partition_len =
> -				le32_to_cpu(p->partitionLength); /* blocks */
> -			map->s_partition_root =
> -				le32_to_cpu(p->partitionStartingLocation);
> -			if (p->accessType ==
> -					cpu_to_le32(PD_ACCESS_TYPE_READ_ONLY))
> -				map->s_partition_flags |=
> -						UDF_PART_FLAG_READ_ONLY;
> -			if (p->accessType ==
> -					cpu_to_le32(PD_ACCESS_TYPE_WRITE_ONCE))
> -				map->s_partition_flags |=
> -						UDF_PART_FLAG_WRITE_ONCE;
> -			if (p->accessType ==
> -					cpu_to_le32(PD_ACCESS_TYPE_REWRITABLE))
> +		if (map->s_partition_num !=
> +				le16_to_cpu(p->partitionNumber))
> +			continue;
> +
> +		map->s_partition_len =
> +			le32_to_cpu(p->partitionLength); /* blocks */
> +		map->s_partition_root =
> +			le32_to_cpu(p->partitionStartingLocation);
> +		if (p->accessType == cpu_to_le32(PD_ACCESS_TYPE_READ_ONLY))
> +			map->s_partition_flags |= UDF_PART_FLAG_READ_ONLY;
> +		if (p->accessType == cpu_to_le32(PD_ACCESS_TYPE_WRITE_ONCE))
> +			map->s_partition_flags |= UDF_PART_FLAG_WRITE_ONCE;
> +		if (p->accessType == cpu_to_le32(PD_ACCESS_TYPE_REWRITABLE))
> +			map->s_partition_flags |= UDF_PART_FLAG_REWRITABLE;
> +		if (p->accessType == cpu_to_le32(PD_ACCESS_TYPE_OVERWRITABLE))
> +			map->s_partition_flags |= UDF_PART_FLAG_OVERWRITABLE;
> +
> +		if (strcmp(p->partitionContents.ident,
> +				PD_PARTITION_CONTENTS_NSR02) &&
> +			strcmp(p->partitionContents.ident,
> +				PD_PARTITION_CONTENTS_NSR03))
> +			break;
> +
> +		phd = (struct partitionHeaderDesc *)
> +				(p->partitionContentsUse);
> +		if (phd->unallocSpaceTable.extLength) {
> +			kernel_lb_addr loc = {
> +				.logicalBlockNum = le32_to_cpu(
> +					phd->unallocSpaceTable.extPosition),
> +				.partitionReferenceNum = i,
> +			};
> +
> +			map->s_uspace.s_table =
> +				udf_iget(sb, loc);
> +			if (!map->s_uspace.s_table) {
> +				udf_debug("cannot load unallocSpaceTable "
> +					  "(part %d)\n", i);
> +				return 1;
> +			}
> +			map->s_partition_flags |=
> +				UDF_PART_FLAG_UNALLOC_TABLE;
> +			udf_debug("unallocSpaceTable (part %d) @ %ld\n",
> +					i, map->s_uspace.s_table->i_ino);
> +		}
> +		if (phd->unallocSpaceBitmap.extLength) {
> +			struct udf_bitmap *bitmap =
> +				udf_sb_alloc_bitmap(sb, i);
> +			map->s_uspace.s_bitmap = bitmap;
> +			if (bitmap != NULL) {
> +				bitmap->s_extLength = le32_to_cpu(
> +					phd->unallocSpaceBitmap.extLength);
> +				bitmap->s_extPosition = le32_to_cpu(
> +					phd->unallocSpaceBitmap.extPosition);
>  				map->s_partition_flags |=
> -						UDF_PART_FLAG_REWRITABLE;
> -			if (p->accessType ==
> -				    cpu_to_le32(PD_ACCESS_TYPE_OVERWRITABLE))
> +						UDF_PART_FLAG_UNALLOC_BITMAP;
> +				udf_debug("unallocSpaceBitmap (part %d) @ %d\n",
> +						i, bitmap->s_extPosition);
> +			}
> +		}
> +		if (phd->partitionIntegrityTable.extLength)
> +			udf_debug("partitionIntegrityTable (part %d)\n", i);
> +		if (phd->freedSpaceTable.extLength) {
> +			kernel_lb_addr loc = {
> +				.logicalBlockNum = le32_to_cpu(
> +					phd->freedSpaceTable.extPosition),
> +				.partitionReferenceNum = i,
> +			};
> +
> +			map->s_fspace.s_table =
> +				udf_iget(sb, loc);
> +			if (!map->s_fspace.s_table) {
> +				udf_debug("cannot load freedSpaceTable "
> +					  "(part %d)\n", i);
> +				return 1;
> +			}
> +			map->s_partition_flags |=
> +				UDF_PART_FLAG_FREED_TABLE;
> +			udf_debug("freedSpaceTable (part %d) @ %ld\n",
> +					i, map->s_fspace.s_table->i_ino);
> +		}
> +		if (phd->freedSpaceBitmap.extLength) {
> +			struct udf_bitmap *bitmap =
> +				udf_sb_alloc_bitmap(sb, i);
> +			map->s_fspace.s_bitmap = bitmap;
> +			if (bitmap != NULL) {
> +				bitmap->s_extLength = le32_to_cpu(
> +					phd->freedSpaceBitmap.extLength);
> +				bitmap->s_extPosition = le32_to_cpu(
> +					phd->freedSpaceBitmap.extPosition);
>  				map->s_partition_flags |=
> -						UDF_PART_FLAG_OVERWRITABLE;
> -
> -			if (!strcmp(p->partitionContents.ident,
> -				    PD_PARTITION_CONTENTS_NSR02) ||
> -			    !strcmp(p->partitionContents.ident,
> -				    PD_PARTITION_CONTENTS_NSR03)) {
> -				struct partitionHeaderDesc *phd;
> -
> -				phd = (struct partitionHeaderDesc *)
> -						(p->partitionContentsUse);
> -				if (phd->unallocSpaceTable.extLength) {
> -					kernel_lb_addr loc = {
> -						.logicalBlockNum = le32_to_cpu(phd->unallocSpaceTable.extPosition),
> -						.partitionReferenceNum = i,
> -					};
> -
> -					map->s_uspace.s_table =
> -						udf_iget(sb, loc);
> -					if (!map->s_uspace.s_table) {
> -						udf_debug("cannot load unallocSpaceTable (part %d)\n", i);
> -						return 1;
> -					}
> -					map->s_partition_flags |=
> -						UDF_PART_FLAG_UNALLOC_TABLE;
> -					udf_debug("unallocSpaceTable (part %d) @ %ld\n",
> -						  i, map->s_uspace.s_table->i_ino);
> -				}
> -				if (phd->unallocSpaceBitmap.extLength) {
> -					struct udf_bitmap *bitmap =
> -						udf_sb_alloc_bitmap(sb, i);
> -					map->s_uspace.s_bitmap = bitmap;
> -					if (bitmap != NULL) {
> -						bitmap->s_extLength =
> -							le32_to_cpu(phd->unallocSpaceBitmap.extLength);
> -						bitmap->s_extPosition =
> -							le32_to_cpu(phd->unallocSpaceBitmap.extPosition);
> -						map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_BITMAP;
> -						udf_debug("unallocSpaceBitmap (part %d) @ %d\n",
> -							  i, bitmap->s_extPosition);
> -					}
> -				}
> -				if (phd->partitionIntegrityTable.extLength)
> -					udf_debug("partitionIntegrityTable (part %d)\n", i);
> -				if (phd->freedSpaceTable.extLength) {
> -					kernel_lb_addr loc = {
> -						.logicalBlockNum = le32_to_cpu(phd->freedSpaceTable.extPosition),
> -						.partitionReferenceNum = i,
> -					};
> -
> -					map->s_fspace.s_table =
> -						udf_iget(sb, loc);
> -					if (!map->s_fspace.s_table) {
> -						udf_debug("cannot load freedSpaceTable (part %d)\n", i);
> -						return 1;
> -					}
> -					map->s_partition_flags |=
> -						UDF_PART_FLAG_FREED_TABLE;
> -					udf_debug("freedSpaceTable (part %d) @ %ld\n",
> -						  i, map->s_fspace.s_table->i_ino);
> -				}
> -				if (phd->freedSpaceBitmap.extLength) {
> -					struct udf_bitmap *bitmap =
> -						udf_sb_alloc_bitmap(sb, i);
> -					map->s_fspace.s_bitmap = bitmap;
> -					if (bitmap != NULL) {
> -						bitmap->s_extLength =
> -							le32_to_cpu(phd->freedSpaceBitmap.extLength);
> -						bitmap->s_extPosition =
> -							le32_to_cpu(phd->freedSpaceBitmap.extPosition);
> -						map->s_partition_flags |= UDF_PART_FLAG_FREED_BITMAP;
> -						udf_debug("freedSpaceBitmap (part %d) @ %d\n",
> -							  i, bitmap->s_extPosition);
> -					}
> -				}
> +						UDF_PART_FLAG_FREED_BITMAP;
> +				udf_debug("freedSpaceBitmap (part %d) @ %d\n",
> +						i, bitmap->s_extPosition);
>  			}
> -			break;
>  		}
> +		break;
>  	}
>  	if (i == sbi->s_partitions)
>  		udf_debug("Partition (%d) not found in partition map\n",
> @@ -1187,19 +1187,17 @@ static int udf_load_logicalvol(struct super_block *sb, struct buffer_head *bh,
>  					map->s_type_specific.s_sparing.
>  							s_spar_map[j] = bh2;
>  
> -					if (bh2 != NULL) {
> -						st = (struct sparingTable *)
> -								bh2->b_data;
> -						if (ident != 0 || strncmp(
> -							st->sparingIdent.ident,
> -							UDF_ID_SPARING,
> -							strlen(UDF_ID_SPARING))) {
> -							brelse(bh2);
> -							map->s_type_specific.
> -								s_sparing.
> -								s_spar_map[j] =
> -									NULL;
> -						}
> +					if (bh2 == NULL)
> +						continue;
> +
> +					st = (struct sparingTable *)bh2->b_data;
> +					if (ident != 0 || strncmp(
> +						st->sparingIdent.ident,
> +						UDF_ID_SPARING,
> +						strlen(UDF_ID_SPARING))) {
> +						brelse(bh2);
> +						map->s_type_specific.s_sparing.
> +							s_spar_map[j] = NULL;
>  					}
>  				}
>  				map->s_partition_func = udf_get_pblock_spar15;
> @@ -1364,40 +1362,40 @@ static int udf_process_sequence(struct super_block *sb, long block,
>  		brelse(bh);
>  	}
>  	for (i = 0; i < VDS_POS_LENGTH; i++) {
> -		if (vds[i].block) {
> -			bh = udf_read_tagged(sb, vds[i].block, vds[i].block,
> -					     &ident);
> -
> -			if (i == VDS_POS_PRIMARY_VOL_DESC) {
> -				udf_load_pvoldesc(sb, bh);
> -			} else if (i == VDS_POS_LOGICAL_VOL_DESC) {
> -				if (udf_load_logicalvol(sb, bh, fileset)) {
> -					brelse(bh);
> -					return 1;
> -				}
> -			} else if (i == VDS_POS_PARTITION_DESC) {
> -				struct buffer_head *bh2 = NULL;
> -				if (udf_load_partdesc(sb, bh)) {
> -					brelse(bh);
> -					return 1;
> -				}
> -				for (j = vds[i].block + 1;
> -				     j <  vds[VDS_POS_TERMINATING_DESC].block;
> -				     j++) {
> -					bh2 = udf_read_tagged(sb, j, j, &ident);
> -					gd = (struct generic_desc *)bh2->b_data;
> -					if (ident == TAG_IDENT_PD)
> -						if (udf_load_partdesc(sb,
> -								      bh2)) {
> -							brelse(bh);
> -							brelse(bh2);
> -							return 1;
> -						}
> -					brelse(bh2);
> -				}
> +		if (!vds[i].block)
> +			continue;
> +
> +		bh = udf_read_tagged(sb, vds[i].block, vds[i].block,
> +					&ident);
> +
> +		if (i == VDS_POS_PRIMARY_VOL_DESC)
> +			udf_load_pvoldesc(sb, bh);
> +		else if (i == VDS_POS_LOGICAL_VOL_DESC) {
> +			if (udf_load_logicalvol(sb, bh, fileset)) {
> +				brelse(bh);
> +				return 1;
> +			}
> +		} else if (i == VDS_POS_PARTITION_DESC) {
> +			struct buffer_head *bh2 = NULL;
> +			if (udf_load_partdesc(sb, bh)) {
> +				brelse(bh);
> +				return 1;
> +			}
> +			for (j = vds[i].block + 1;
> +				j <  vds[VDS_POS_TERMINATING_DESC].block;
> +				j++) {
> +				bh2 = udf_read_tagged(sb, j, j, &ident);
> +				gd = (struct generic_desc *)bh2->b_data;
> +				if (ident == TAG_IDENT_PD)
> +					if (udf_load_partdesc(sb, bh2)) {
> +						brelse(bh);
> +						brelse(bh2);
> +						return 1;
> +					}
> +				brelse(bh2);
>  			}
> -			brelse(bh);
>  		}
> +		brelse(bh);
>  	}
>  
>  	return 0;
> @@ -1409,6 +1407,7 @@ static int udf_process_sequence(struct super_block *sb, long block,
>  static int udf_check_valid(struct super_block *sb, int novrs, int silent)
>  {
>  	long block;
> +	struct udf_sb_info *sbi;
>  
>  	if (novrs) {
>  		udf_debug("Validity check skipped because of novrs option\n");
> @@ -1416,18 +1415,16 @@ static int udf_check_valid(struct super_block *sb, int novrs, int silent)
>  	}
>  	/* Check that it is NSR02 compliant */
>  	/* Process any "CD-ROM Volume Descriptor Set" (ECMA 167 2/8.3.1) */
> -	else {
> -		block = udf_vrs(sb, silent);
> -		if (block == -1) {
> -			struct udf_sb_info *sbi = UDF_SB(sb);
> -			udf_debug("Failed to read byte 32768. Assuming open "
> -				  "disc. Skipping validity check\n");
> -			if (!sbi->s_last_block)
> -				sbi->s_last_block = udf_get_last_block(sb);
> -			return 0;
> -		} else
> -			return !block;
> -	}
> +	block = udf_vrs(sb, silent);
> +	if (block != -1)
> +		return !block;
> +
> +	sbi = UDF_SB(sb);
> +	udf_debug("Failed to read byte 32768. Assuming open "
> +			"disc. Skipping validity check\n");
> +	if (!sbi->s_last_block)
> +		sbi->s_last_block = udf_get_last_block(sb);
> +	return 0;
>  }
>  
>  static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
> @@ -1446,6 +1443,7 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
>  	for (i = 0; i < ARRAY_SIZE(sbi->s_anchor); i++) {
>  		if (!sbi->s_anchor[i])
>  			continue;
> +
>  		bh = udf_read_tagged(sb, sbi->s_anchor[i], sbi->s_anchor[i],
>  				     &ident);
>  		if (!bh)
> @@ -1487,72 +1485,73 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
>  	for (i = 0; i < sbi->s_partitions; i++) {
>  		kernel_lb_addr uninitialized_var(ino);
>  		struct udf_part_map *map = &sbi->s_partmaps[i];
> -		switch (map->s_partition_type) {
> -		case UDF_VIRTUAL_MAP15:
> -		case UDF_VIRTUAL_MAP20:
> -			if (!sbi->s_last_block) {
> -				sbi->s_last_block = udf_get_last_block(sb);
> -				udf_find_anchor(sb);
> -			}
>  
> -			if (!sbi->s_last_block) {
> -				udf_debug("Unable to determine Lastblock (For "
> -					  "Virtual Partition)\n");
> -				return 1;
> -			}
> +		if (map->s_partition_type != UDF_VIRTUAL_MAP15 &&
> +			map->s_partition_type != UDF_VIRTUAL_MAP20)
> +			continue;
>  
> -			for (j = 0; j < sbi->s_partitions; j++) {
> -				struct udf_part_map *map2 = &sbi->s_partmaps[j];
> -				if (j != i &&
> -				    map->s_volumeseqnum ==
> -						map2->s_volumeseqnum &&
> -				    map->s_partition_num ==
> -						map2->s_partition_num) {
> -					ino.partitionReferenceNum = j;
> -					ino.logicalBlockNum =
> -						sbi->s_last_block -
> -							map2->s_partition_root;
> -					break;
> -				}
> +		if (!sbi->s_last_block) {
> +			sbi->s_last_block = udf_get_last_block(sb);
> +			udf_find_anchor(sb);
> +		}
> +
> +		if (!sbi->s_last_block) {
> +			udf_debug("Unable to determine Lastblock (For "
> +					"Virtual Partition)\n");
> +			return 1;
> +		}
> +
> +		for (j = 0; j < sbi->s_partitions; j++) {
> +			struct udf_part_map *map2 = &sbi->s_partmaps[j];
> +			if (j != i &&
> +				map->s_volumeseqnum ==
> +					map2->s_volumeseqnum &&
> +				map->s_partition_num ==
> +					map2->s_partition_num) {
> +				ino.partitionReferenceNum = j;
> +				ino.logicalBlockNum =
> +					sbi->s_last_block -
> +						map2->s_partition_root;
> +				break;
>  			}
> +		}
>  
> -			if (j == sbi->s_partitions)
> -				return 1;
> +		if (j == sbi->s_partitions)
> +			return 1;
>  
> -			sbi->s_vat_inode = udf_iget(sb, ino);
> -			if (!sbi->s_vat_inode)
> -				return 1;
> +		sbi->s_vat_inode = udf_iget(sb, ino);
> +		if (!sbi->s_vat_inode)
> +			return 1;
>  
> -			if (map->s_partition_type == UDF_VIRTUAL_MAP15) {
> -				map->s_type_specific.s_virtual.s_start_offset =
> -					udf_ext0_offset(sbi->s_vat_inode);
> -				map->s_type_specific.s_virtual.s_num_entries =
> -					(sbi->s_vat_inode->i_size - 36) >> 2;
> -			} else if (map->s_partition_type == UDF_VIRTUAL_MAP20) {
> -				uint32_t pos;
> -				struct virtualAllocationTable20 *vat20;
> -
> -				pos = udf_block_map(sbi->s_vat_inode, 0);
> -				bh = sb_bread(sb, pos);
> -				if (!bh)
> -					return 1;
> -				vat20 = (struct virtualAllocationTable20 *)
> -					bh->b_data +
> -					udf_ext0_offset(sbi->s_vat_inode);
> -				map->s_type_specific.s_virtual.s_start_offset =
> -					le16_to_cpu(vat20->lengthHeader) +
> -					udf_ext0_offset(sbi->s_vat_inode);
> -				map->s_type_specific.s_virtual.s_num_entries =
> -					(sbi->s_vat_inode->i_size -
> -					 map->s_type_specific.s_virtual.
> -							s_start_offset) >> 2;
> -				brelse(bh);
> -			}
> -			map->s_partition_root = udf_get_pblock(sb, 0, i, 0);
> -			map->s_partition_len =
> -				sbi->s_partmaps[ino.partitionReferenceNum].
> -								s_partition_len;
> +		if (map->s_partition_type == UDF_VIRTUAL_MAP15) {
> +			map->s_type_specific.s_virtual.s_start_offset =
> +				udf_ext0_offset(sbi->s_vat_inode);
> +			map->s_type_specific.s_virtual.s_num_entries =
> +				(sbi->s_vat_inode->i_size - 36) >> 2;
> +		} else if (map->s_partition_type == UDF_VIRTUAL_MAP20) {
> +			uint32_t pos;
> +			struct virtualAllocationTable20 *vat20;
> +
> +			pos = udf_block_map(sbi->s_vat_inode, 0);
> +			bh = sb_bread(sb, pos);
> +			if (!bh)
> +				return 1;
> +			vat20 = (struct virtualAllocationTable20 *)
> +				bh->b_data +
> +				udf_ext0_offset(sbi->s_vat_inode);
> +			map->s_type_specific.s_virtual.s_start_offset =
> +				le16_to_cpu(vat20->lengthHeader) +
> +				udf_ext0_offset(sbi->s_vat_inode);
> +			map->s_type_specific.s_virtual.s_num_entries =
> +				(sbi->s_vat_inode->i_size -
> +					map->s_type_specific.s_virtual.
> +						s_start_offset) >> 2;
> +			brelse(bh);
>  		}
> +		map->s_partition_root = udf_get_pblock(sb, 0, i, 0);
> +		map->s_partition_len =
> +			sbi->s_partmaps[ino.partitionReferenceNum].
> +							s_partition_len;
>  	}
>  	return 0;
>  }
> @@ -1561,25 +1560,25 @@ static void udf_open_lvid(struct super_block *sb)
>  {
>  	struct udf_sb_info *sbi = UDF_SB(sb);
>  	struct buffer_head *bh = sbi->s_lvid_bh;
> -	if (bh) {
> -		struct logicalVolIntegrityDesc *lvid =
> -				(struct logicalVolIntegrityDesc *)bh->b_data;
> -		struct logicalVolIntegrityDescImpUse *lvidiu =
> -							udf_sb_lvidiu(sbi);
> +	struct logicalVolIntegrityDesc *lvid;
> +	struct logicalVolIntegrityDescImpUse *lvidiu;
> +	if (!bh)
> +		return;
>  
> -		lvidiu->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
> -		lvidiu->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
> -		udf_time_to_stamp(&lvid->recordingDateAndTime, CURRENT_TIME);
> -		lvid->integrityType = LVID_INTEGRITY_TYPE_OPEN;
> +	lvid = (struct logicalVolIntegrityDesc *)bh->b_data;
> +	lvidiu = udf_sb_lvidiu(sbi);
>  
> -		lvid->descTag.descCRC = cpu_to_le16(
> -			udf_crc((char *)lvid + sizeof(tag),
> -				le16_to_cpu(lvid->descTag.descCRCLength),
> -				0));
> +	lvidiu->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
> +	lvidiu->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
> +	udf_time_to_stamp(&lvid->recordingDateAndTime, CURRENT_TIME);
> +	lvid->integrityType = LVID_INTEGRITY_TYPE_OPEN;
>  
> -		lvid->descTag.tagChecksum = udf_tag_checksum(&lvid->descTag);
> -		mark_buffer_dirty(bh);
> -	}
> +	lvid->descTag.descCRC = cpu_to_le16(
> +		udf_crc((char *)lvid + sizeof(tag),
> +			le16_to_cpu(lvid->descTag.descCRCLength), 0));
> +
> +	lvid->descTag.tagChecksum = udf_tag_checksum(&lvid->descTag);
> +	mark_buffer_dirty(bh);
>  }
>  
>  static void udf_close_lvid(struct super_block *sb)
> @@ -1587,35 +1586,35 @@ static void udf_close_lvid(struct super_block *sb)
>  	struct udf_sb_info *sbi = UDF_SB(sb);
>  	struct buffer_head *bh = sbi->s_lvid_bh;
>  	struct logicalVolIntegrityDesc *lvid;
> +	struct logicalVolIntegrityDescImpUse *lvidiu;
>  
>  	if (!bh)
>  		return;
>  
>  	lvid = (struct logicalVolIntegrityDesc *)bh->b_data;
>  
> -	if (lvid->integrityType == LVID_INTEGRITY_TYPE_OPEN) {
> -		struct logicalVolIntegrityDescImpUse *lvidiu =
> -							udf_sb_lvidiu(sbi);
> -		lvidiu->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
> -		lvidiu->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
> -		udf_time_to_stamp(&lvid->recordingDateAndTime, CURRENT_TIME);
> -		if (UDF_MAX_WRITE_VERSION > le16_to_cpu(lvidiu->maxUDFWriteRev))
> -			lvidiu->maxUDFWriteRev =
> -					cpu_to_le16(UDF_MAX_WRITE_VERSION);
> -		if (sbi->s_udfrev > le16_to_cpu(lvidiu->minUDFReadRev))
> -			lvidiu->minUDFReadRev = cpu_to_le16(sbi->s_udfrev);
> -		if (sbi->s_udfrev > le16_to_cpu(lvidiu->minUDFWriteRev))
> -			lvidiu->minUDFWriteRev = cpu_to_le16(sbi->s_udfrev);
> -		lvid->integrityType = cpu_to_le32(LVID_INTEGRITY_TYPE_CLOSE);
> -
> -		lvid->descTag.descCRC = cpu_to_le16(
> -			udf_crc((char *)lvid + sizeof(tag),
> -				le16_to_cpu(lvid->descTag.descCRCLength),
> -				0));
> -
> -		lvid->descTag.tagChecksum = udf_tag_checksum(&lvid->descTag);
> -		mark_buffer_dirty(bh);
> -	}
> +	if (lvid->integrityType != LVID_INTEGRITY_TYPE_OPEN)
> +		return;
> +
> +	lvidiu = udf_sb_lvidiu(sbi);
> +	lvidiu->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
> +	lvidiu->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
> +	udf_time_to_stamp(&lvid->recordingDateAndTime, CURRENT_TIME);
> +	if (UDF_MAX_WRITE_VERSION > le16_to_cpu(lvidiu->maxUDFWriteRev))
> +		lvidiu->maxUDFWriteRev = cpu_to_le16(UDF_MAX_WRITE_VERSION);
> +	if (sbi->s_udfrev > le16_to_cpu(lvidiu->minUDFReadRev))
> +		lvidiu->minUDFReadRev = cpu_to_le16(sbi->s_udfrev);
> +	if (sbi->s_udfrev > le16_to_cpu(lvidiu->minUDFWriteRev))
> +		lvidiu->minUDFWriteRev = cpu_to_le16(sbi->s_udfrev);
> +	lvid->integrityType = cpu_to_le32(LVID_INTEGRITY_TYPE_CLOSE);
> +
> +	lvid->descTag.descCRC = cpu_to_le16(
> +		udf_crc((char *)lvid + sizeof(tag),
> +			le16_to_cpu(lvid->descTag.descCRCLength),
> +			0));
> +
> +	lvid->descTag.tagChecksum = udf_tag_checksum(&lvid->descTag);
> +	mark_buffer_dirty(bh);
>  }
>  
>  static void udf_sb_free_bitmap(struct udf_bitmap *bitmap)
> -- 
> 1.5.3.7
> 
									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
