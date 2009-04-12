Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbZDLAdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbZDLAdw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 20:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZDLAdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 20:33:42 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:48968 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbZDLAdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 20:33:40 -0400
Date: Sun, 12 Apr 2009 02:35:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       viro <viro@zeniv.linux.org.uk>, linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [RFC][patch] VMUFAT filesystem - v2
Message-ID: <20090412003544.GA3801@uranus.ravnborg.org>
References: <1239487891.6523.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239487891.6523.17.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian.

Some nitpicks. I do not know filesystems so nothing value on that front.

> 
> I will be writing appropriate userland tools and more documentation in
> due course.
> 
>  fs/Kconfig         |    1 +
>  fs/Makefile        |    1 +
>  fs/vmufat/Kconfig  |   14 +
>  fs/vmufat/Makefile |    7 +
>  fs/vmufat/inode.c  | 1400 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 1423 insertions(+), 0 deletions(-)

That was a lot of code in one file.

> 
> Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

It is:
Signed-off-by: ...


> +++ b/fs/vmufat/Makefile
> @@ -0,0 +1,7 @@
> +#
> +# Makefile for VMUFAT filesystem
> +#
> +
> +obj-$(CONFIG_VMUFAT_FS) += vmufat.o
> +
> +vmufat-objs := inode.o

Please use:
vmufat-y := inode.o

This is preferred syntax these days.

> diff --git a/fs/vmufat/inode.c b/fs/vmufat/inode.c
> new file mode 100644
> index 0000000..8ac0cba
> --- /dev/null
> +++ b/fs/vmufat/inode.c
> @@ -0,0 +1,1400 @@
> +/*
> + * inode operations for the VMU file system
> + *
> + * Copyright (C) 2002 - 2009	Adrian McMenamin
> + * Copyright (C) 2002		Paul Mundt
> + *
> + * Released under the terms of the GNU GPL.
> + */
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/fs.h>
> +#include <linux/slab.h>
> +#include <linux/blkdev.h>
> +#include <linux/buffer_head.h>
> +#include <linux/statfs.h>
> +#include <linux/mpage.h>
> +#include <linux/bcd.h>

The preference is to either sort includes by length (longest first)
or in alphabetic order.


> +
> +#define VMUFAT_NAMELEN 12
> +
> +/* GNU utils won't list files with inode num 0 */
> +#define VMUFAT_ZEROBLOCK 32768
> +#define VMU_BLK_SZ 512
> +#define VMUFAT_MAGIC 0x55555555
No so magic?
And it belongs in <linux/magic.h>

> +
> +static struct kmem_cache *vmufat_inode_cachep;
> +static struct kmem_cache *vmufat_blist_cachep;
> +static const struct inode_operations vmufat_inode_operations;
> +static const struct file_operations vmufat_file_operations;
> +static const struct address_space_operations vmufat_address_space_operations;
> +static const struct file_operations vmufat_file_dir_operations;
> +static const struct super_operations vmufat_super_operations;
> +
> +static struct inode *vmufat_get_inode(struct super_block *sb, long ino);
> +static int vmufat_list_blocks(struct inode *in);
Can you rearrange things so we do not need these forward decalarations?

> +struct memcard {
> +	long sb_bnum;
> +	long fat_bnum;
> +	long fat_len;
> +	long dir_bnum;
> +	long dir_len;
> +	long numblocks;
> +};
> +
> +struct vmufat_block_list {
> +	struct list_head b_list;
> +	int bno;
> +};
> +
> +struct vmufat_inode {
> +	struct vmufat_block_list blocks;
> +	int nblcks;
> +	struct inode vfs_inode;
> +};
> +
> +static struct vmufat_inode *VMUFAT_I(struct inode *in)
> +{
> +	return container_of(in, struct vmufat_inode, vfs_inode);
> +}
> +
> +struct vmufat_file_info {
> +	__u8 ftype;
> +	__u8 copy_pro;
> +	__u16 fblk;
> +	char fname[12];
> +};
VMUFAT_NAMELEN?

> +/* VMU hardware is flaky, so let's compensate for that
> + * without losing hardare independence -
> + * as it is likely to be where this filesystem is used
> + */
> +static inline struct buffer_head *vmufat_sb_bread(struct super_block *sb,
> +	sector_t block)
> +{
> +	struct buffer_head *bh;
> +	bh = sb_bread(sb, block);
> +	if (bh)
> +		return bh;
> +	return sb_bread(sb, block);
> +}
Looks wrong that we just try the same thing twice.

> +
> +/* Linear day numbers of the respective 1sts in non-leap years. */
> +static int day_n[] =
> +    {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334};
> +
> +static struct dentry *vmufat_inode_lookup(struct inode *in, struct dentry *dent,
> +	struct nameidata *nd)
> +{
> +	struct super_block *sb;
> +	struct memcard *vmudetails;
> +	struct buffer_head *bh;
> +	struct inode *ino;
> +	char name[VMUFAT_NAMELEN];
> +	long blck_read;
> +	int error = 0, fno = 0;
> +
> +	if (dent->d_name.len > VMUFAT_NAMELEN) {
> +		error = -ENAMETOOLONG;
> +		goto out;
> +	}
> +
> +	sb = in->i_sb;
> +	vmudetails = sb->s_fs_info;
> +	blck_read = vmudetails->dir_bnum;
> +
> +	bh = vmufat_sb_bread(sb, blck_read);
> +	if (!bh) {
> +		error = -EIO;
> +		goto out;
> +	}
> +
> +	do {
> +		/* Have we got a file? */
> +		if (bh->b_data[vmufat_index(fno)] == 0)
> +			goto next;
> +
> +		/* get file name */
> +		memcpy(name,
> +		       bh->b_data + 4 + vmufat_index(fno), VMUFAT_NAMELEN);
> +		/* do names match ?*/
> +		if (memcmp(dent->d_name.name, name, dent->d_name.len) == 0) {
> +			/* read the inode number from the directory */
> +			ino = vmufat_get_inode(sb,
> +				le16_to_cpu(((u16 *) bh->b_data)
> +					[1 + vmufat_index_16(fno)]));
> +			if (!ino) {
> +				error = -EACCES;
> +				goto release_bh;
> +			}
> +			if (IS_ERR(ino)) {
> +				error = PTR_ERR(ino);
> +				goto release_bh;
> +			}
> +			/* return the entry */
> +			d_add(dent, ino);
> +			goto release_bh;
> +		}
> +next:
> +		/* did not match, so try the next file */
> +		fno++;
> +		/* do we need to move to the next block in the directory? */
> +		if (fno >= 0x10) {

Can we have a descriptive constant here..


> +			fno = 0;
> +			blck_read--;
> +			if (blck_read <=
> +				vmudetails->dir_bnum - vmudetails->dir_len) {
> +				d_add(dent, NULL);
> +				break;
> +			}
> +			brelse(bh);
> +			bh = vmufat_sb_bread(sb, blck_read);
> +			if (!bh) {
> +				error = -EIO;
> +				goto out;
> +			}
> +		}
> +	} while (1);
> +
> +release_bh:
> +	brelse(bh);
> +out:
> +	return ERR_PTR(error);
> +}
> +

> +/*
> + * Find a free block in the FAT and mark it
> + * as the end of a file
> + */
> +static int vmufat_find_free(struct super_block *sb)
> +{
> +	struct memcard *vmudetails = sb->s_fs_info;
> +	int nextblock, x;
> +	u16 fatdata;
> +	struct buffer_head *bh_fat;
> +	int error = 0;
> +
> +	nextblock = vmudetails->fat_bnum + vmudetails->fat_len - 1;
> +	x = VMU_BLK_SZ;
> +	bh_fat =
> +	    vmufat_sb_bread(sb, nextblock);
> +	if (!bh_fat) {
> +		error = -EIO;
> +		goto fail;
> +	}
> +
> +	do {
> +		fatdata = ((u16 *) bh_fat->b_data)[x];
> +		if (fatdata == 0xfffc)
> +			break;	/*empty block */
Is this endian safe - you use le16_to_cpu before.
Hmmm, you are reading a char * and casting it to a u16 *.
So -4 equals 0xfffc. That should be ok.
But it would be nicer with an accessor function to read this.

Use a constant for 0xfffc (you use it multiple times)

> +		if (--x < 0) {
> +			put_bh(bh_fat);
> +			if (--nextblock >= vmudetails->fat_bnum) {
> +				x = VMU_BLK_SZ;
> +				bh_fat = vmufat_sb_bread(sb, nextblock);
> +				if (!bh_fat) {
> +					error = -EIO;
> +					goto fail;
> +				}
> +			} else
> +				break;
> +		}
> +	} while (1);
> +
> +	if (nextblock < vmudetails->fat_bnum) {
> +		printk(KERN_ERR "VMUFAT: device is full\n");
> +		error = -ENOSPC;
> +		put_bh(bh_fat);
> +		goto fail;
> +	}
> +	put_bh(bh_fat);
> +	return  x + (nextblock - vmudetails->fat_bnum) * VMU_BLK_SZ;
> +
> +fail:
> +	return error;
> +}

> +
> +/* read the FAT for a given block */
> +static u16 vmufat_get_fat(struct super_block *sb, long block)
> +{
> +	struct memcard *vmudetails = sb->s_fs_info;
> +	struct buffer_head *bh;
> +	int offset;
> +	u16 block_content;
> +
> +	offset = block/(VMU_BLK_SZ/2);
Spaces around operators..

> +	if (offset >= vmudetails->fat_len)
> +		return 0xFFFE;

Constant for 0xFFFE

> +
> +	bh = vmufat_sb_bread(sb, offset + 1 +
> +		vmudetails->fat_bnum - vmudetails->fat_len);
> +	if (!bh)
> +		return 0xFFFF;

Constant for 0xFFFF

> +
> +
> +	block_content = ((u16 *)bh->b_data)[block % (VMU_BLK_SZ / 2)];

What is the difference between block % (VMU_BLK_SZ / 2) and block / (VMU_BLK_SZ / 2)?


> +	put_bh(bh);
> +	return block_content;
> +}

> +
> +/* set the FAT for a given block */
> +static int vmufat_set_fat(struct super_block *sb, long block, u16 set)
> +{
> +	struct memcard *vmudetails = sb->s_fs_info;
> +	struct buffer_head *bh;
> +	int offset;
> +
> +	offset = block/(VMU_BLK_SZ/2);
Spaces. And same calculation as before.

> +	if (offset >= vmudetails->fat_len)
> +		return -EINVAL;
> +
> +	bh = vmufat_sb_bread(sb, offset + 1 +
> +		vmudetails->fat_bnum - vmudetails->fat_len);
> +	if (!bh)
> +		return -EIO;
> +
> +	((u16 *) bh->b_data)[block % (VMU_BLK_SZ / 2)] = set;
> +	mark_buffer_dirty(bh);
> +	put_bh(bh);
> +	return 0;
> +}
> +
> +static int vmufat_inode_create(struct inode *dir, struct dentry *de,
> +		int imode, struct nameidata *nd)
> +{
> +	/* Create an inode */
> +	int x = 0, y, z, error = 0, q;
> +	long blck_read;
> +	struct inode *inode;
> +	struct super_block *sb;
> +	struct memcard *vmudetails;
> +	struct buffer_head *bh_fat = NULL, *bh;
> +	unsigned long unix_date;
> +	int year, day, nl_day, month;	/*inspired by FAT driver */
> +	u8 century, u8year;
> +
> +	if (de->d_name.len > VMUFAT_NAMELEN)
> +		return -ENAMETOOLONG;
> +
> +	sb = dir->i_sb;
> +	vmudetails = sb->s_fs_info;
> +
> +	inode = new_inode(sb);
> +	if (!inode) {
> +		error = -ENOSPC;
> +		goto out;
> +	}
> +
> +	/* Walk through blocks looking for place to write
> +	* Is this an executible file? */
> +	if (imode & 73) {	/*Octal 111 */

Then write an octal value?

> +		inode->i_ino = VMUFAT_ZEROBLOCK;
> +		/* But this already allocated? */
> +		if (vmufat_get_fat(sb, 0) != 0xFFFC) {
> +			printk(KERN_ERR
> +				"VMUFAT: cannot write executible file to"
> +				" filesystem - block 0 already allocated.\n");
> +			error = -ENOSPC;
> +			goto clean_inode;
> +		}
> +		q = 0;
> +	} else {
> +		q = vmufat_find_free(sb);
> +		if (q < 0) {
> +			error = q;
> +			goto clean_inode;
> +		}
> +		inode->i_ino = q;
> +	}
> +
> +	error = vmufat_set_fat(sb, q, 0xFFFA);
> +	if (error)
> +		goto clean_inode;
> +
> +	inode->i_uid = 0;
> +	inode->i_gid = 0;
> +	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
> +	inode->i_mode = imode;
> +	inode->i_blocks = 1;
> +	inode->i_sb = sb;
> +	insert_inode_hash(inode);
> +	inode->i_op = &vmufat_inode_operations;
> +	inode->i_fop = &vmufat_file_operations;
> +	inode->i_mapping->a_ops = &vmufat_address_space_operations;
> +
> +	/* Write to the directory
> +	* Now search for space for the directory entry */
> +	blck_read = vmudetails->dir_bnum;
> +	bh = vmufat_sb_bread(sb, blck_read);
> +	if (!bh) {
> +		error = -EIO;
> +		goto clean_inode;
> +	}
> +
> +	for (y = 0; y < (vmudetails->dir_len * 0x10); y++) {
> +		if ((y / 0x10) > (vmudetails->dir_bnum - blck_read)) {
> +			brelse(bh);
> +			blck_read--;
> +			bh = vmufat_sb_bread(sb, blck_read);
> +			if (!bh) {
> +				error = -EIO;
> +				goto clean_fat;
> +			}
> +		}
> +		if (((bh->b_data)[vmufat_index(y)]) == 0)
> +			break;
> +	}
> +	/* Have the directory entry
> +	 * so now update it */
> +	z = vmufat_index(y);
> +	if (inode->i_ino != VMUFAT_ZEROBLOCK)
> +		bh->b_data[z] = 0x33;	/* data file */
> +	else
> +		bh->b_data[z] = 0xcc;
> +
> +	if ((bh->b_data[z + 1] != (char) 0x00) &&
> +		(bh->b_data[z + 1] != (char) 0xff))
> +		bh->b_data[z + 1] = (char) 0x00;
> +
> +	if (inode->i_ino != VMUFAT_ZEROBLOCK) {
> +		((u16 *) bh->b_data)[z / 2 + 1] =
> +		    cpu_to_le16(inode->i_ino);
> +		((u16 *) bh->b_data)[z / 2 + 0x0D] = 0;
> +	} else {
> +		((u16 *) bh->b_data)[z / 2 + 1] = 0;
> +		((u16 *) bh->b_data)[z / 2 + 0x0D] = 1;
> +	}
> +
> +	/* Name */
> +	memset((char *) (bh->b_data + z + 0x04), '\0', 0x0C);
> +	memcpy((char *) (bh->b_data + z + 0x04), ((de->d_name).name),
> +		de->d_name.len);
> +
Lots of hardcoded constants above that I think describe the filesystem layout..

> +	/* BCD timestamp it */
> +	unix_date = CURRENT_TIME.tv_sec;
> +	day = unix_date / 86400 - 3652;
> +	year = day / 365;
> +
> +	if ((year + 3) / 4 + 365 * year > day)
> +		year--;
> +
> +	day -= (year + 3) / 4 + 365 * year;
> +	if (day == 59 && !(year & 3)) {
> +		nl_day = day;
> +		month = 2;
> +	} else {
> +		nl_day = (year & 3) || day <= 59 ? day : day - 1;
> +		for (month = 0; month < 12; month++)
> +			if (day_n[month] > nl_day)
> +				break;
> +	}
> +
> +	century = 19;
> +	if (year > 19)
> +		century = 20;
> +
> +	bh->b_data[z + 0x10] = bin2bcd(century);
> +	u8year = year + 80;
> +	if (u8year > 99)
> +		u8year = u8year - 100;
> +
> +	bh->b_data[z + 0x11] = bin2bcd(u8year);
> +	bh->b_data[z + 0x12] = bin2bcd(month);
> +	bh->b_data[z + 0x13] =
> +	    bin2bcd(day - day_n[month - 1] + 1);
> +	bh->b_data[z + 0x14] =
> +	    bin2bcd((unix_date / 3600) % 24);
> +	bh->b_data[z + 0x15] = bin2bcd((unix_date / 60) % 60);
> +	bh->b_data[z + 0x16] = bin2bcd(unix_date % 60);
The above should be in a separate function.

> +
> +	((u16 *) bh->b_data)[z / 2 + 0x0C] =
> +	    cpu_to_le16(inode->i_blocks);
> +
> +	inode->i_mtime.tv_sec = unix_date;
> +	mark_buffer_dirty(bh);
> +	brelse(bh);
> +
> +	error = vmufat_list_blocks(inode);
> +	if (error)
> +		goto clean_fat;
> +
> +	d_instantiate(de, inode); printk("created inode 0x%lX\n", inode->i_ino);
> +	brelse(bh_fat);
> +	return error;
> +
> +clean_fat:
> +	((u16 *)bh_fat->b_data)[x] = 0xfffc;
> +	mark_buffer_dirty(bh_fat);
> +	brelse(bh_fat);
> +clean_inode:
> +	iput(inode);
> +out:
> +	return error;
> +}
> +
> +static int vmufat_inode_rename(struct inode *in_source,
> +			      struct dentry *de_source,
> +			      struct inode *in_target,
> +			      struct dentry *de_target)
> +{
> +	return -EPERM;
> +}
> +
> +static int vmufat_readdir(struct file *filp, void *dirent, filldir_t filldir)
> +{
> +	int filenamelen, i, error = 0;
> +	struct vmufat_file_info *saved_file = NULL;
> +	struct dentry *dentry = filp->f_dentry;
> +	struct inode *inode = dentry->d_inode;
> +	struct super_block *sb = inode->i_sb;
> +	struct memcard *vmudetails = sb->s_fs_info;
> +	struct buffer_head *bh;
> +
> +	int blck_read = vmudetails->dir_bnum;
> +	bh = vmufat_sb_bread(sb, blck_read);
> +	if (!bh) {
> +		error = -EIO;
> +		goto out;
> +	}
> +
> +	i = filp->f_pos;
> +
> +	/* handle . for this directory and .. for parent */
> +	switch ((unsigned int) filp->f_pos) {
> +	case 0:
> +		if (filldir(dirent, ".", 1, i++, inode->i_ino, DT_DIR) < 0)
> +			goto finish;
> +
> +		filp->f_pos++;
> +	case 1:
> +		if (filldir(dirent, "..", 2, i++,
> +			    dentry->d_parent->d_inode->i_ino, DT_DIR) < 0)
> +			goto finish;
> +
> +		filp->f_pos++;
> +	default:
> +		break;
> +	}
> +
> +	/* trap reading beyond the end of the directory */
> +	if ((i - 2) > (vmudetails->dir_len * 0x10)) {
> +		error = -EINVAL;
> +		goto release_bh;
> +	}
> +
> +	saved_file =
> +	    kmalloc(sizeof(struct vmufat_file_info), GFP_KERNEL);
> +	if (!saved_file) {
> +		error = -ENOMEM;
> +		goto release_bh;
> +	}
> +
> +	do {
> +		if ((i - 2) / 0x10 > (vmudetails->dir_bnum - blck_read)) {
> +			/* move to next block in directory */
> +			blck_read--;
> +			if (vmudetails->dir_bnum - vmudetails->dir_len <=
> +				blck_read)
> +				break;
> +			brelse(bh);
> +			bh = vmufat_sb_bread(sb, blck_read);
> +			if (!bh) {
> +				kfree(saved_file);
> +				error = -EIO;
> +				goto out;
> +			}
It is simpler to just do:
			if (!bh) {
				error = -EIO;
				goto finish;
			}
kfree() is a noop for NULL pointers, and likewise for brelse().
So simplify your error paths with this in mind.
This is true at several places in the file.


> +		}
> +
> +		saved_file->ftype = bh->b_data[vmufat_index(i - 2)];
> +
> +		if (saved_file->ftype == 0)
> +			break;
> +
> +		saved_file->fblk =
> +		    le16_to_cpu(((u16 *) bh->b_data)[1 +
> +			vmufat_index_16(i - 2)]);
This seems to be a common operation - use a helper function.

> +		if (saved_file->fblk == 0)
> +			saved_file->fblk = VMUFAT_ZEROBLOCK;
> +
> +		memcpy(saved_file->fname,
> +		       bh->b_data + 4 + vmufat_index(i - 2), VMUFAT_NAMELEN);
> +		filenamelen = strlen(saved_file->fname);
> +		if (filenamelen > VMUFAT_NAMELEN)
> +			filenamelen = VMUFAT_NAMELEN;
> +		if (filldir
> +		    (dirent, saved_file->fname, filenamelen, i++,
> +		     saved_file->fblk, DT_REG) < 0) {
This is an ugly way to avoid the 80 char limit - please redo.

> +			goto finish;
> +		}
> +
> +		filp->f_pos++;
> +	} while (1);
> +
> +finish:
> +	kfree(saved_file);
> +release_bh:
> +	brelse(bh);
> +out:
> +	return error;
> +}

I did not read furter from here.
But please try to see which comments apply to the rest of the file.

	Sam
