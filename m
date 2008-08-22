Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbYHVBnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbYHVBnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 21:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYHVBnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 21:43:05 -0400
Received: from anchor-post-35.mail.demon.net ([194.217.242.85]:4900 "EHLO
	anchor-post-35.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087AbYHVBnE (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 21:43:04 -0400
Message-ID: <48AE19AD.1020209@lougher.demon.co.uk>
Date: Fri, 22 Aug 2008 02:43:09 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: jaredeh@gmail.com
CC: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@AM.SONY.COM,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 06/10] AXFS: axfs_super.c
References: <48AD0101.4020505@gmail.com>
In-Reply-To: <48AD0101.4020505@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:
> +static void axfs_free_region(struct axfs_super *sbi,
> +			     struct axfs_region_desc *region)
> +{
> +	if (!region)
> +		return;
> +
> +	if (AXFS_IS_REGION_XIP(sbi, region))
> +		return;
> +
> +	if (region->virt_addr)
> +		vfree(region->virt_addr);
> +}
> +

No need to do

	if(xxx)
		vfree(xxx)

vfree/kfree can cope with NULL pointers.

> +static void axfs_put_sbi(struct axfs_super *sbi)
> +{

> +	axfs_free_region(sbi, &sbi->uids);
> +	axfs_free_region(sbi, &sbi->gids);
> +
> +	if (sbi->second_dev)
> +		kfree(sbi->second_dev);
> +
> +	if (sbi->cblock_buffer[0])
> +		vfree(sbi->cblock_buffer[0]);
> +	if (sbi->cblock_buffer[1])
> +		vfree(sbi->cblock_buffer[1]);
> +

Again, just kfree(xxx)/vfree(xxx)

> +
> +static int axfs_copy_mem(struct super_block *sb, void *buf, u64 fsoffset,
> +			 u64 len)
> +{
> +	struct axfs_super *sbi = AXFS_SB(sb);
> +	unsigned long addr;
> +
> +	addr = sbi->virt_start_addr + (unsigned long)fsoffset;
> +	memcpy(buf, (void *)addr, (size_t) len);
> +	return 0;

Always returns 0, consider changing to static void

> +}
> +
> +static int axfs_copy_metadata(struct super_block *sb, void *buf, u64 fsoffset,
> +			      u64 len)
> +{
> +	struct axfs_super *sbi = AXFS_SB(sb);
> +	u64 end = fsoffset + len;
> +	u64 a = sbi->mmap_size - fsoffset;
> +	u64 b = end - sbi->mmap_size;
> +	void *bb = (void *)((unsigned long)buf + (unsigned long)a);
> +	int err;
> +
> +	/* Catches case where sbi is not yet fully initialized. */
> +	if ((sbi->magic == 0) && (sbi->virt_start_addr != 0))
> +		return axfs_copy_mem(sb, buf, fsoffset, len);
> +
> +	if (fsoffset < sbi->mmap_size) {
> +		if (end > sbi->mmap_size) {
> +			err = axfs_copy_metadata(sb, buf, fsoffset, a);
> +			if (err)
> +				return err;
> +			err = axfs_copy_metadata(sb, bb, sbi->mmap_size, b);
> +		} else {
> +			if (AXFS_IS_OFFSET_MMAPABLE(sbi, fsoffset)) {
> +				err = axfs_copy_mem(sb, buf, fsoffset, len);
> +			} else if (AXFS_HAS_MTD(sb)) {
> +				err = axfs_copy_mtd(sb, buf, fsoffset, len);
> +			} else if (AXFS_HAS_BDEV(sb)) {
> +				err = axfs_copy_block(sb, buf, fsoffset, len);
> +			} else {
> +				err = -EINVAL;

Consider initialising err to -EINVAL at declaration time, and get rid of 
this else,

> +			}
> +		}
> +	} else {
> +		if (AXFS_NODEV(sb)) {
> +			err = axfs_copy_mem(sb, buf, fsoffset, len);
> +		} else if (AXFS_HAS_BDEV(sb)) {
> +			err = axfs_copy_block(sb, buf, fsoffset, len);
> +		} else if (AXFS_HAS_MTD(sb)) {
> +			err = axfs_copy_mtd(sb, buf, fsoffset, len);
> +		} else {
> +			err = -EINVAL;

and this one.

> +		}
> +	}
> +	return err;
> +}
> +
> +static int axfs_fill_region_data(struct super_block *sb,
> +				 struct axfs_region_desc *region, int force)
> +{
> +
> +	if (AXFS_IS_REGION_INCORE(region))
> +		goto incore;
> +
> +	if (AXFS_IS_REGION_COMPRESSED(region))
> +		goto incore;
> +
> +	if (AXFS_IS_REGION_XIP(sbi, region)) {
> +		if ((end > sbi->mmap_size) && (force))
> +			goto incore;
> +		addr = sbi->virt_start_addr;
> +		addr += (unsigned long)fsoffset;
> +		region->virt_addr = (void *)addr;
> +		return 0;
> +	}
> +
> +incore:
> +	region->virt_addr = vmalloc(size);
> +	if (!region->virt_addr)
> +		goto out;
> +	vaddr = region->virt_addr;
> +
> +	if (AXFS_IS_REGION_COMPRESSED(region)) {
> +		buff = vmalloc(c_size);
> +		if (!buff)
> +			goto out;
> +		axfs_copy_metadata(sb, buff, fsoffset, c_size);
> +		err = axfs_uncompress_block(vaddr, size, buff, c_size);
> +		if (!err)
> +			goto out;
> +		vfree(buff);
> +	} else {
> +		axfs_copy_metadata(sb, vaddr, fsoffset, size);
> +	}
> +
> +	return 0;


 From this it would appear that if the region data can't be mapped XIP 
(i.e. it is compressed or on a block device), it is cached in its 
entirety in RAM?

This implies for block devices that the entire filesystem metadata has 
to be cached in RAM.  This severely limits the size of AXFS filesystems 
when using block devices, or the else memory usage will be excessive.


> +
> +out:
> +	if (buff)
> +		vfree(buff);
> +	if (region->virt_addr)
> +		vfree(region->virt_addr);
> +	return err;
> +}
> +

Just do kfree(xxx)


> +
> +static int axfs_get_onmedia_super(struct super_block *sb)
> +{
> +	int err;
> +	struct axfs_super *sbi = AXFS_SB(sb);
> +	struct axfs_super_onmedia *sbo;
> +
> +	sbo = kmalloc(sizeof(*sbo), GFP_KERNEL);
> +	if (!sbo)
> +		return -ENOMEM;
> +
> +	axfs_copy_metadata(sb, (void *)sbo, 0, sizeof(*sbo));
> +
> +	/* Do sanity checks on the superblock */
> +	if (be32_to_cpu(sbo->magic) != AXFS_MAGIC) {
> +		printk(KERN_ERR "axfs: wrong magic\n");
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	/* verify the signiture is correct */
> +	if (strncmp(sbo->signature, AXFS_SIGNATURE, sizeof(AXFS_SIGNATURE))) {
> +		printk(KERN_ERR "axfs: wrong axfs signature,"
> +		       " read %s, expected %s\n",
> +		       sbo->signature, AXFS_SIGNATURE);
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	sbi->magic = be32_to_cpu(sbo->magic);
> +	sbi->version_major = sbo->version_major;
> +	sbi->version_minor = sbo->version_minor;
> +	sbi->version_sub = sbo->version_sub;
> +	sbi->files = be64_to_cpu(sbo->files);
> +	sbi->size = be64_to_cpu(sbo->size);
> +	sbi->blocks = be64_to_cpu(sbo->blocks);
> +	sbi->mmap_size = be64_to_cpu(sbo->mmap_size);
> +	sbi->cblock_size = be32_to_cpu(sbo->cblock_size);
> +	sbi->timestamp.tv_sec = be64_to_cpu(sbo->timestamp);
> +	sbi->timestamp.tv_nsec = 0;
> +	sbi->compression_type = sbo->compression_type;
> +
> +	err = axfs_set_compression_type(sbi);
> +	if (err)
> +		goto out;
> +
> +	/* If no block or MTD device, adjust mmapable to cover all image */
> +	if (AXFS_NODEV(sb))
> +		sbi->mmap_size = sbi->size;
> +
> +	err = axfs_fill_region_descriptors(sb, sbo);
> +	if (err)
> +		goto out;
> +
> +	err = 0;

Redundant code

> +out:
> +	kfree(sbo);
> +	return err;
> +}
> +

Phillip


