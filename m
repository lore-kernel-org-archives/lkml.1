Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZCaJAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZCaJAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 05:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbZCaJAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 05:00:30 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:12484 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750769AbZCaJA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 05:00:28 -0400
Message-ID: <49D1DB04.3040505@panasas.com>
Date: Tue, 31 Mar 2009 11:57:40 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/8] exofs: Kbuild, Headers and osd utils
References: <49C1331D.1080805@panasas.com>	<1237399056-29171-1-git-send-email-bharrosh@panasas.com> <20090331010414.707695a2.akpm@linux-foundation.org>
In-Reply-To: <20090331010414.707695a2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Mar 2009 08:59:37.0915 (UTC) FILETIME=[0528C0B0:01C9B1DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2009 11:04 AM, Andrew Morton wrote:
> On Wed, 18 Mar 2009 19:57:36 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> This patch includes osd infrastructure that will be used later by
>> the file system.
>>
>> Also the declarations of constants, on disk structures,
>> and prototypes.
>>
>> And the Kbuild+Kconfig files needed to build the exofs module.
>>
>> ...
>>
>> --- /dev/null
>> +++ b/fs/exofs/Kbuild
>> @@ -0,0 +1,30 @@
>> +#
>> +# Kbuild for the EXOFS module
>> +#
>> +# Copyright (C) 2008 Panasas Inc.  All rights reserved.
>> +#
>> +# Authors:
>> +#   Boaz Harrosh <bharrosh@panasas.com>
>> +#
>> +# This program is free software; you can redistribute it and/or modify
>> +# it under the terms of the GNU General Public License version 2
>> +#
>> +# Kbuild - Gets included from the Kernels Makefile and build system
>> +#
>> +
>> +ifneq ($(OSD_INC),)
>> +# we are built out-of-tree Kconfigure everything as on
>> +
>> +CONFIG_EXOFS_FS=m
>> +ccflags-y += -DCONFIG_EXOFS_FS -DCONFIG_EXOFS_FS_MODULE
>> +# ccflags-y += -DCONFIG_EXOFS_DEBUG
>> +
>> +# if we are built out-of-tree and the hosting kernel has OSD headers
>> +# then "ccflags-y +=" will not pick the out-off-tree headers. Only by doing
>> +# this it will work. This might break in future kernels
>> +KBUILD_CPPFLAGS := -I$(OSD_INC) $(KBUILD_CPPFLAGS)
>> +
>> +endif
> 
> But this patch is putting the fs into the tree, so all the above is unneeded.
> 
>> ...
>>
>> + * Object IDs 0, 1, and 2 are always in use (see above defines).
>> + */
>> +enum {
>> +	EXOFS_UINT64_MAX = (~0LL),
> 
> Use ULLONG_MAX?
> 
> ~0ULL would be more consistent.
> 
>> +	EXOFS_MAX_INO_ID = (sizeof(ino_t) * 8 == 64) ? EXOFS_UINT64_MAX :
>> +					(1LL << (sizeof(ino_t) * 8 - 1)),
> 
> Tricky, needs a comment.
> 
> Would be clearer to use 1ULL.
> 
>> +	EXOFS_MAX_ID	 = (EXOFS_MAX_INO_ID - 1 - EXOFS_OBJ_OFF),
>> +};
>> +

OK, OK, OK

>> +/****************************************************************************
>> + * Misc.
>> + ****************************************************************************/
>> +#define EXOFS_BLKSHIFT	12
>> +#define EXOFS_BLKSIZE	(1UL << EXOFS_BLKSHIFT)
>> +
>> +/****************************************************************************
>> + * superblock-related things
>> + ****************************************************************************/
>> +#define EXOFS_SUPER_MAGIC	0x5DF5
> 
> Should be in include/linux/magic.h
> 

Is this relevant for OSD, I guess if there are going to
be more OSD filesystems then yes.

I will do it, thanks.

>> ...
>>
>> +/*
>> + * The file control block - stored in an object's attributes.  This is where
>> + * the in-memory inode is stored on disk.
>> + */
>> +struct exofs_fcb {
>> +	__le64  i_size;			/* Size of the file */
>> +	__le16  i_mode;         	/* File mode */
>> +	__le16  i_links_count;  	/* Links count */
>> +	__le32  i_uid;          	/* Owner Uid */
>> +	__le32  i_gid;          	/* Group Id */
>> +	__le32  i_atime;        	/* Access time */
>> +	__le32  i_ctime;        	/* Creation time */
>> +	__le32  i_mtime;        	/* Modification time */
>> +	__le32  i_flags;        	/* File flags (unused for now)*/
>> +	__le32  i_generation;   	/* File version (for NFS) */
>> +	__le32  i_data[EXOFS_IDATA];	/* Short symlink names and device #s */
>> +};
> 
> There is no room for future expansion.  Would that be appropriate/wise?
> I guess it would need versioning information somewhere too.
> 

In osd we have the size-of-the-attribute it sits in. So if in future we
add members we can switch according to size, also we can just stick it in
a different attribute number, so like EXOFS_ATTR_INODE_DATA_VER1
EXOFS_ATTR_INODE_DATA_VER2 attribute. Presence of, means support. Hell we can
even be backward compatible with having 2 or three versions at once.

>> ...
>>
>> +/* u64 has problems with printk this will cast it to unsigned long long */
>> +#define _LLU(x) (unsigned long long)(x)
> 
> ug.
> 
> Normally the response is "please open-code this".  But given that one
> day real soon this printk(u64) problem will be fixed, I guess the use
> of _LLU will make it easy to find and delete all the now-unneeded
> casts.
> 

Exactly my thoughts

>> ...
>>
>> +/*
>> + * our inode flags
>> + */
>> +#define OBJ_2BCREATED	0	/* object will be created soon*/
>> +#define OBJ_CREATED	1	/* object has been created on the osd*/
>> +
>> +static inline int obj_2bcreated(struct exofs_i_info *oi)
>> +{
>> +	return test_bit(OBJ_2BCREATED, &(oi->i_flags));
>> +}
> 
> unneeded parentheses around oi->i_flags.
> 
>> +static inline void set_obj_2bcreated(struct exofs_i_info *oi)
>> +{
>> +	set_bit(OBJ_2BCREATED, &(oi->i_flags));
>> +}
>> +
>> +static inline int obj_created(struct exofs_i_info *oi)
>> +{
>> +	return test_bit(OBJ_CREATED, &(oi->i_flags));
>> +}
>> +
>> +static inline void set_obj_created(struct exofs_i_info *oi)
>> +{
>> +	set_bit(OBJ_CREATED, &(oi->i_flags));
>> +}
> 
> dittoes.
> 
>> ...
>>
> 

Thanks
will fix

Boaz
