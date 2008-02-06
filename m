Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbYBFLJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbYBFLJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 06:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYBFLJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 06:09:39 -0500
Received: from styx.suse.cz ([82.119.242.94]:54587 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751121AbYBFLJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 06:09:38 -0500
Date: Wed, 6 Feb 2008 12:09:36 +0100
From: Jan Kara <jack@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] udf: super.c reorganization
Message-ID: <20080206110936.GC12547@duck.suse.cz>
References: <1202063771-18172-1-git-send-email-marcin.slusarz@gmail.com> <20080203184230.GA18219@joi> <20080205162219.GK25464@duck.suse.cz> <20080205193417.GC6332@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205193417.GC6332@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 05-02-08 20:34:49, Marcin Slusarz wrote:
> On Tue, Feb 05, 2008 at 05:22:19PM +0100, Jan Kara wrote:
> >   Actually, the loop below would be even more readable it you did:
> > 
> >   if (map->s_partition_num == le16_to_cpu(p->partitionNumber))
> >     break;
> >   And do the work after we exit from the loop.
> > 
> > 
> > >  	for (i = 0; i < sbi->s_partitions; i++) {
> > > +		struct partitionHeaderDesc *phd;
> > > +
> > >  		map = &sbi->s_partmaps[i];
> > >  		udf_debug("Searching map: (%d == %d)\n",
> > >  			  map->s_partition_num,
> > >  			  le16_to_cpu(p->partitionNumber));
> > > -		if (map->s_partition_num ==
> > > -				le16_to_cpu(p->partitionNumber)) {
> > > -			map->s_partition_len =
> > > -				le32_to_cpu(p->partitionLength); /* blocks */
> > > -			map->s_partition_root =
> > > -				le32_to_cpu(p->partitionStartingLocation);
> > > -			if (p->accessType ==
> > > -					cpu_to_le32(PD_ACCESS_TYPE_READ_ONLY))
> > > -				map->s_partition_flags |=
> > > -						UDF_PART_FLAG_READ_ONLY;
> > > -			if (p->accessType ==
> > > -					cpu_to_le32(PD_ACCESS_TYPE_WRITE_ONCE))
> > > -				map->s_partition_flags |=
> > > -						UDF_PART_FLAG_WRITE_ONCE;
> > > -			if (p->accessType ==
> > > -					cpu_to_le32(PD_ACCESS_TYPE_REWRITABLE))
> > > +		if (map->s_partition_num !=
> > > +				le16_to_cpu(p->partitionNumber))
> > > +			continue;
> > > +
> > > +		map->s_partition_len =
> > > +			le32_to_cpu(p->partitionLength); /* blocks */
> > > +		map->s_partition_root =
> > > +			le32_to_cpu(p->partitionStartingLocation);
> > > +		if (p->accessType == cpu_to_le32(PD_ACCESS_TYPE_READ_ONLY))
> > > +			map->s_partition_flags |= UDF_PART_FLAG_READ_ONLY;
> > > +		if (p->accessType == cpu_to_le32(PD_ACCESS_TYPE_WRITE_ONCE))
> > > +			map->s_partition_flags |= UDF_PART_FLAG_WRITE_ONCE;
> > > +		if (p->accessType == cpu_to_le32(PD_ACCESS_TYPE_REWRITABLE))
> > > +			map->s_partition_flags |= UDF_PART_FLAG_REWRITABLE;
> > > +		if (p->accessType == cpu_to_le32(PD_ACCESS_TYPE_OVERWRITABLE))
> > > +			map->s_partition_flags |= UDF_PART_FLAG_OVERWRITABLE;
> > > +
> > > +		if (strcmp(p->partitionContents.ident,
> > > +				PD_PARTITION_CONTENTS_NSR02) &&
> > > +			strcmp(p->partitionContents.ident,
> > > +				PD_PARTITION_CONTENTS_NSR03))
> > > +			break;
> > > +
> > > +		phd = (struct partitionHeaderDesc *)
> > > +				(p->partitionContentsUse);
> > > +		if (phd->unallocSpaceTable.extLength) {
> > > +			kernel_lb_addr loc = {
> > > +				.logicalBlockNum = le32_to_cpu(
> > > +					phd->unallocSpaceTable.extPosition),
> > > +				.partitionReferenceNum = i,
> > > +			};
> > > +
> > > +			map->s_uspace.s_table =
> > > +				udf_iget(sb, loc);
> > > +			if (!map->s_uspace.s_table) {
> > > +				udf_debug("cannot load unallocSpaceTable "
> > > +					  "(part %d)\n", i);
> > > +				return 1;
> > > +			}
> > > +			map->s_partition_flags |=
> > > +				UDF_PART_FLAG_UNALLOC_TABLE;
> > > +			udf_debug("unallocSpaceTable (part %d) @ %ld\n",
> > > +					i, map->s_uspace.s_table->i_ino);
> > > +		}
> > > +		if (phd->unallocSpaceBitmap.extLength) {
> > > +			struct udf_bitmap *bitmap =
> > > +				udf_sb_alloc_bitmap(sb, i);
> > > +			map->s_uspace.s_bitmap = bitmap;
> > > +			if (bitmap != NULL) {
> > > +				bitmap->s_extLength = le32_to_cpu(
> > > +					phd->unallocSpaceBitmap.extLength);
> > > +				bitmap->s_extPosition = le32_to_cpu(
> > > +					phd->unallocSpaceBitmap.extPosition);
> > >  				map->s_partition_flags |=
> > > -						UDF_PART_FLAG_REWRITABLE;
> > > -			if (p->accessType ==
> > > -				    cpu_to_le32(PD_ACCESS_TYPE_OVERWRITABLE))
> > > +						UDF_PART_FLAG_UNALLOC_BITMAP;
> > > +				udf_debug("unallocSpaceBitmap (part %d) @ %d\n",
> > > +						i, bitmap->s_extPosition);
> > > +			}
> > > +		}
> > > +		if (phd->partitionIntegrityTable.extLength)
> > > +			udf_debug("partitionIntegrityTable (part %d)\n", i);
> > > +		if (phd->freedSpaceTable.extLength) {
> > > +			kernel_lb_addr loc = {
> > > +				.logicalBlockNum = le32_to_cpu(
> > > +					phd->freedSpaceTable.extPosition),
> > > +				.partitionReferenceNum = i,
> > > +			};
> > > +
> > > +			map->s_fspace.s_table =
> > > +				udf_iget(sb, loc);
> > > +			if (!map->s_fspace.s_table) {
> > > +				udf_debug("cannot load freedSpaceTable "
> > > +					  "(part %d)\n", i);
> > > +				return 1;
> > > +			}
> > > +			map->s_partition_flags |=
> > > +				UDF_PART_FLAG_FREED_TABLE;
> > > +			udf_debug("freedSpaceTable (part %d) @ %ld\n",
> > > +					i, map->s_fspace.s_table->i_ino);
> > > +		}
> > > +		if (phd->freedSpaceBitmap.extLength) {
> > > +			struct udf_bitmap *bitmap =
> > > +				udf_sb_alloc_bitmap(sb, i);
> > > +			map->s_fspace.s_bitmap = bitmap;
> > > +			if (bitmap != NULL) {
> > > +				bitmap->s_extLength = le32_to_cpu(
> > > +					phd->freedSpaceBitmap.extLength);
> > > +				bitmap->s_extPosition = le32_to_cpu(
> > > +					phd->freedSpaceBitmap.extPosition);
> > >  				map->s_partition_flags |=
> > > -						UDF_PART_FLAG_OVERWRITABLE;
> > > -
> > > -			if (!strcmp(p->partitionContents.ident,
> > > -				    PD_PARTITION_CONTENTS_NSR02) ||
> > > -			    !strcmp(p->partitionContents.ident,
> > > -				    PD_PARTITION_CONTENTS_NSR03)) {
> > > -				struct partitionHeaderDesc *phd;
> > > -
> > > -				phd = (struct partitionHeaderDesc *)
> > > -						(p->partitionContentsUse);
> > > -				if (phd->unallocSpaceTable.extLength) {
> > > -					kernel_lb_addr loc = {
> > > -						.logicalBlockNum = le32_to_cpu(phd->unallocSpaceTable.extPosition),
> > > -						.partitionReferenceNum = i,
> > > -					};
> > > -
> > > -					map->s_uspace.s_table =
> > > -						udf_iget(sb, loc);
> > > -					if (!map->s_uspace.s_table) {
> > > -						udf_debug("cannot load unallocSpaceTable (part %d)\n", i);
> > > -						return 1;
> > > -					}
> > > -					map->s_partition_flags |=
> > > -						UDF_PART_FLAG_UNALLOC_TABLE;
> > > -					udf_debug("unallocSpaceTable (part %d) @ %ld\n",
> > > -						  i, map->s_uspace.s_table->i_ino);
> > > -				}
> > > -				if (phd->unallocSpaceBitmap.extLength) {
> > > -					struct udf_bitmap *bitmap =
> > > -						udf_sb_alloc_bitmap(sb, i);
> > > -					map->s_uspace.s_bitmap = bitmap;
> > > -					if (bitmap != NULL) {
> > > -						bitmap->s_extLength =
> > > -							le32_to_cpu(phd->unallocSpaceBitmap.extLength);
> > > -						bitmap->s_extPosition =
> > > -							le32_to_cpu(phd->unallocSpaceBitmap.extPosition);
> > > -						map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_BITMAP;
> > > -						udf_debug("unallocSpaceBitmap (part %d) @ %d\n",
> > > -							  i, bitmap->s_extPosition);
> > > -					}
> > > -				}
> > > -				if (phd->partitionIntegrityTable.extLength)
> > > -					udf_debug("partitionIntegrityTable (part %d)\n", i);
> > > -				if (phd->freedSpaceTable.extLength) {
> > > -					kernel_lb_addr loc = {
> > > -						.logicalBlockNum = le32_to_cpu(phd->freedSpaceTable.extPosition),
> > > -						.partitionReferenceNum = i,
> > > -					};
> > > -
> > > -					map->s_fspace.s_table =
> > > -						udf_iget(sb, loc);
> > > -					if (!map->s_fspace.s_table) {
> > > -						udf_debug("cannot load freedSpaceTable (part %d)\n", i);
> > > -						return 1;
> > > -					}
> > > -					map->s_partition_flags |=
> > > -						UDF_PART_FLAG_FREED_TABLE;
> > > -					udf_debug("freedSpaceTable (part %d) @ %ld\n",
> > > -						  i, map->s_fspace.s_table->i_ino);
> > > -				}
> > > -				if (phd->freedSpaceBitmap.extLength) {
> > > -					struct udf_bitmap *bitmap =
> > > -						udf_sb_alloc_bitmap(sb, i);
> > > -					map->s_fspace.s_bitmap = bitmap;
> > > -					if (bitmap != NULL) {
> > > -						bitmap->s_extLength =
> > > -							le32_to_cpu(phd->freedSpaceBitmap.extLength);
> > > -						bitmap->s_extPosition =
> > > -							le32_to_cpu(phd->freedSpaceBitmap.extPosition);
> > > -						map->s_partition_flags |= UDF_PART_FLAG_FREED_BITMAP;
> > > -						udf_debug("freedSpaceBitmap (part %d) @ %d\n",
> > > -							  i, bitmap->s_extPosition);
> > > -					}
> > > -				}
> > > +						UDF_PART_FLAG_FREED_BITMAP;
> > > +				udf_debug("freedSpaceBitmap (part %d) @ %d\n",
> > > +						i, bitmap->s_extPosition);
> > >  			}
> > > -			break;
> > >  		}
> > > +		break;
> > >  	}
> > >  	if (i == sbi->s_partitions)
> > >  		udf_debug("Partition (%d) not found in partition map\n",
> 
> Ok. I didn't notice that. But it won't be as trivial as the rest. Separate patch?
  You're reindenting the code anyway, so moving it to another place isn't a
big deal (doesn't make review any harder). So you can just merge it into
the same patch. Thanks.

										Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
