Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbZBOPD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbZBOPD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 10:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZBOPDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 10:03:49 -0500
Received: from cs-studio.ru ([195.178.208.66]:51926 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbZBOPDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 10:03:47 -0500
Date: Sun, 15 Feb 2009 18:03:36 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] filesystem: VMUFAT filesystem
Message-ID: <20090215150335.GA15736@ioremap.net>
References: <1234646219.6609.37.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234646219.6609.37.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian.

On Sat, Feb 14, 2009 at 09:16:59PM +0000, Adrian McMenamin (adrian@newgolddream.dyndns.info) wrote:
> The SEGA Dreamcast visual memory unit implements a file allocation table
> based filesystem which is somewhat similar to FAT16. This filesystem
> code implements that filesystem and I have used it to successfully
> manage Dreamcast VMUs and VMU images mounted via loop.
> 
> You can read more about the filesystem here:
> http://mc.pp.se/dc/vms/flashmem.html
> 
> I intend to fully document the filesystem and write an appropriate user
> tool to create a drive image, but in the meantime here is an early cut
> of the filesystem itself for comment.

> +struct dentry *vmufat_inode_lookup(struct inode *in, struct dentry *dent,
> +	struct nameidata *nd)
> +{
> +	struct super_block *sb;
> +	struct memcard *vmudetails;
> +	struct buffer_head *bh;
> +	struct inode *ino;
> +	char name[VMUFAT_NAMELEN];
> +	long blck_read;
> +	int error = 0, fno = 0, filenamelen;
> +
> +	if (dent->d_name.len > VMUFAT_NAMELEN) {
> +		error = -ENAMETOOLONG;
> +		goto out;
> +	}
> +

Cool, only 12 bytes names.

> +	sb = in->i_sb;
> +	vmudetails = (struct memcard *)sb->s_fs_info;

No need for the additional cast.

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
> +		if (((__u8 *)bh->b_data)[(fno % 0x10) * 0x20] == 0) {

This % and * pattern is used all over the place, can it be into some
common helper?

> +			error = -ENOENT;
> +			goto release_bh;
> +		}
> +
> +		/* get file name */
> +		memcpy(name,
> +		       bh->b_data + 4 + (fno % 0x10) * 0x20, VMUFAT_NAMELEN);
> +		/* do names match ?*/
> +		filenamelen = strlen(dent->d_name.name);

You can use dent->d_name.len

> +static int vmufat_inode_create(struct inode *dir, struct dentry *de,
> +		int imode, struct nameidata *nd)
> +{
> +	/* Create an inode */
> +	int y, z;
> +	long nextblock, blck_read;
> +	struct inode *inode;
> +	struct super_block *sb;
> +	struct memcard *vmudetails;
> +	struct buffer_head *bh_fat, *bh;
> +	unsigned long unix_date;
> +	int year, day, nl_day, month;	/*inspired by FAT driver */
> +	__u16 fatdata;
> +	__u8 century, u8year;
> +
> +
> +	if (de->d_name.len > VMUFAT_NAMELEN)
> +		return -ENAMETOOLONG;
> +
> +	sb = dir->i_sb;
> +	vmudetails = (struct memcard *) sb->s_fs_info;
> +
> +	inode = new_inode(sb);
> +	if (!inode)
> +		return -ENOSPC;
> +
> +	/* Walk through blocks looking for place to write
> +	* Is this an executible file? */
> +	if (imode & 73) {	/*Octal 111 */

Some nice-looking define for the mask?

> +		inode->i_ino = VMUFAT_ZEROBLOCK;
> +		/* But this already allocated? */
> +		bh_fat =
> +		    vmufat_sb_bread(sb, vmudetails->fat_bnum);
> +		if (!bh_fat)
> +			return -EIO;

Inode leak.

> +
> +		fatdata = ((__u16 *) bh_fat->b_data)[0];
> +		if (fatdata != 0xfffc) {
> +			printk(KERN_ERR
> +				"vmufat: cannot write executible file to"
> +				" filesystem - block 0 already allocated.\n");
> +			brelse(bh_fat);
> +			return -ENOSPC;

Inode leak. There are several others in the error pathes below.
Please use goto and single exit point.

> +		}
> +

Lost newline.

> +	} else {
> +		/*Look for a free block in the FAT */
> +		nextblock = vmudetails->numblocks - 1;
> +		bh_fat =
> +		    vmufat_sb_bread(sb, vmudetails->fat_bnum);
> +		if (!bh_fat)
> +			return -EIO;
> +
> +		do {
> +			fatdata = ((__u16 *) bh_fat->b_data)[nextblock];
> +			if (fatdata == 0xfffc)
> +				break;	/*empty block */
> +			if (--nextblock < 0)
> +				break;
> +		} while (1);
> +
> +		if (nextblock < 0) {
> +			iput(inode);
> +			brelse(bh_fat);
> +			return -ENOSPC;
> +		}
> +		inode->i_ino = nextblock;
> +	}
> +	brelse(bh_fat);
> +
> +	inode->i_uid = 0;
> +	inode->i_gid = 0;
> +	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
> +	inode->i_mode = imode;
> +	inode->i_blocks = 0;
> +	inode->i_sb = sb;
> +	insert_inode_hash(inode);
> +	mark_inode_dirty(inode);
> +	inode->i_op = &vmufat_inode_operations;
> +	inode->i_fop = &vmufat_file_operations;
> +
> +	/* Write to the directory
> +	* Now search for space for the directory entry */
> +	blck_read = vmudetails->dir_bnum;
> +	bh = vmufat_sb_bread(sb, blck_read);
> +	if (!bh)
> +		return -EIO;
> +
> +	for (y = 0; y < (vmudetails->dir_len * 0x10); y++) {
> +		if ((y / 0x10) > (vmudetails->dir_bnum - blck_read)) {
> +			brelse(bh);
> +			blck_read--;
> +			bh = vmufat_sb_bread(sb, blck_read);
> +			if (!bh)
> +				return -EIO;
> +		}
> +		if (((bh->b_data)[(y % 0x10) * 0x20]) == 0)
> +			break;
> +	}
> +	/* Have the directory entry
> +	 * so now update it */
> +	z = (y % 0x10) * 0x20;
> +	if (inode->i_ino != VMUFAT_ZEROBLOCK)
> +		bh->b_data[z] = 0x33;	/* data file */
> +	else
> +		bh->b_data[z] = 0xcc;
> +

Plsase create a symbolic names for the common constants.

> +	if ((bh->b_data[z + 1] != (char) 0x00) &&
> +		(bh->b_data[z + 1] != (char) 0xff))
> +		bh->b_data[z + 1] = (char) 0x00;
> +
> +	if (inode->i_ino != VMUFAT_ZEROBLOCK) {
> +		((__u16 *) bh->b_data)[z / 2 + 1] =
> +		    cpu_to_le16(inode->i_ino);
> +		((__u16 *) bh->b_data)[z / 2 + 0x0D] = 0;
> +	} else {
> +		((__u16 *) bh->b_data)[z / 2 + 1] = 0;
> +		((__u16 *) bh->b_data)[z / 2 + 0x0D] = 1;
> +	}
> +
> +	/* Name */
> +	memset((char *) (bh->b_data + z + 0x04), '\0', 0x0C);
> +	memcpy((char *) (bh->b_data + z + 0x04), ((de->d_name).name),
> +	       de->d_name.len);
> +
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
> +	bh->b_data[z + 0x10] = bcd_from_u8(century);
> +	u8year = year + 80;
> +	if (u8year > 99)
> +		u8year = u8year - 100;
> +
> +	bh->b_data[z + 0x11] = bcd_from_u8(u8year);
> +	bh->b_data[z + 0x12] = bcd_from_u8((__u8) month);
> +	bh->b_data[z + 0x13] =
> +	    bcd_from_u8((__u8) day - day_n[month - 1] + 1);
> +	bh->b_data[z + 0x14] =
> +	    bcd_from_u8((__u8) ((unix_date / 3600) % 24));
> +	bh->b_data[z + 0x15] = bcd_from_u8((__u8) ((unix_date / 60) % 60));
> +	bh->b_data[z + 0x16] = bcd_from_u8((__u8) (unix_date % 60));
> +
> +	((__u16 *) bh->b_data)[z / 2 + 0x0C] =
> +	    cpu_to_le16(inode->i_blocks);
> +
> +	inode->i_mtime.tv_sec = unix_date;
> +	mark_buffer_dirty(bh);
> +	brelse(bh);
> +
> +	d_instantiate(de, inode);
> +
> +	return 0;
> +}
> +
> +
> +static int vmufat_inode_rename(struct inode *in_source,
> +			      struct dentry *de_source,
> +			      struct inode *in_target,
> +			      struct dentry *de_target)
> +{
> +	return -EPERM;
> +}
> +

Just do not implement the function if it is not supported.

> +const struct inode_operations vmufat_inode_operations = {
> +	.lookup =	vmufat_inode_lookup,
> +	.unlink =	vmufat_inode_unlink,
> +	.create =	vmufat_inode_create,
> +	.rename =	vmufat_inode_rename,
> +};
> +
> +
> +static int vmufat_readdir(struct file *filp, void *dirent, filldir_t filldir)
> +{
> +	int filenamelen, i;
> +	struct vmufat_file_info *saved_file = NULL;
> +	struct dentry *dentry = filp->f_dentry;
> +	struct inode *inode = dentry->d_inode;
> +	struct super_block *sb = inode->i_sb;
> +	struct memcard *vmudetails =
> +	    ((struct memcard *) sb->s_fs_info);
> +	struct buffer_head *bh;
> +
> +	int blck_read = vmudetails->dir_bnum;
> +	bh = vmufat_sb_bread(sb, blck_read);
> +	if (!bh)
> +		return -EIO;
> +
> +	i = filp->f_pos;
> +
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
> +	/* wander through the Directory and find files */
> +	if ((i - 2) > (vmudetails->dir_len * 0x10)) {
> +		brelse(bh);
> +		return -1;

-ENOENT?

> +	}
> +
> +	saved_file =
> +	    kmalloc(sizeof(struct vmufat_file_info), GFP_KERNEL);
> +

Need to check the return value.

> +	do {
> +		if ((i - 2) / 0x10 > (vmudetails->dir_bnum - blck_read)) {
> +			/* move to next block in directory */
> +			brelse(bh);
> +			blck_read--;
> +			bh = vmufat_sb_bread(sb, blck_read);
> +			if (!bh) {
> +				kfree(saved_file);
> +				return -EIO;
> +			}
> +		}
> +
> +		saved_file->ftype = bh->b_data[((i - 2) % 0x10) * 0x20];
> +
> +		if (saved_file->ftype == 0)
> +			break;
> +
> +		saved_file->fblk =
> +		    le16_to_cpu(((__u16 *) bh->b_data)[1 +
> +				((i - 2) % 0x10) * 0x10]);
> +		if (saved_file->fblk == 0)
> +			saved_file->fblk = VMUFAT_ZEROBLOCK;
> +
> +		memcpy(saved_file->fname,
> +		       bh->b_data + 4 + ((i - 2) % 0x10) * 0x20, 12);

VMUFAT_NAMELEN instead of 12?

> +		filenamelen = strlen(saved_file->fname);
> +		if (filenamelen > VMUFAT_NAMELEN)
> +			filenamelen = VMUFAT_NAMELEN;
> +		if (filldir
> +		    (dirent, saved_file->fname, filenamelen, i++,
> +		     saved_file->fblk, DT_REG) < 0) {
> +			goto finish;
> +		}
> +
> +		filp->f_pos++;
> +	} while (1);
> +
> +finish:
> +
> +	kfree(saved_file);
> +	brelse(bh);
> +
> +	return 0;
> +}
> +
> +const struct file_operations vmufat_file_dir_operations = {
> +	.owner =	THIS_MODULE,
> +	.read =		generic_read_dir,
> +	.readdir =	vmufat_readdir,
> +	.fsync =	file_fsync,
> +};
> +
> +static int vmufat_game_write(struct file *file, const char *buf, char *writebuf,
> +		     size_t count, loff_t *ppos)
> +{
> +	__u16 fatdata;
> +	struct buffer_head *bh_fat, *bh;
> +	struct inode *in = (file->f_dentry)->d_inode;
> +	struct super_block *sb = in->i_sb;
> +	struct memcard *vmudetails =
> +	    ((struct memcard *) sb->s_fs_info);
> +

You may want to create a helper function for this common access pattern
or just dereference void s_fs_info pointer without the cast.

> +	unsigned long blkoffset = *ppos >> in->i_sb->s_blocksize_bits;
> +	if (blkoffset < 1) {
> +		/* Additional sanity check */
> +		kfree(writebuf);
> +		return -EIO;
> +	}
> +
> +	/* Is the next block free in the VMU? */
> +	bh_fat = vmufat_sb_bread(in->i_sb, vmudetails->fat_bnum);
> +	if (!bh_fat) {
> +		kfree(writebuf);
> +		return -EIO;
> +	}

Please use single exit path and number of gotos, this allows to
eliminate errors and makes code more readable.

> +	fatdata = ((__u16 *) bh_fat->b_data)[(__u16) blkoffset];
> +
> +	if (fatdata != 0xfffc) {
> +		printk(KERN_ERR
> +			"vmufat: Cannot save game file - insufficient"
> +			" linear space\n");
> +		kfree(writebuf);
> +		return -EFBIG;
> +	}
> +
> +	/*Now we have the space - write the block out */
> +	bh = vmufat_sb_bread(sb, blkoffset);
> +	if (!bh) {
> +		brelse(bh_fat);
> +		kfree(writebuf);
> +		return -EIO;
> +	}
> +	if (count < sb->s_blocksize)
> +		memset((char *) (bh->b_data), '\0', sb->s_blocksize);
> +	memcpy((char *) (bh->b_data), writebuf, count);
> +	mark_buffer_dirty(bh);
> +	brelse(bh);
> +	in->i_size += count;
> +	in->i_blocks++;
> +
> +	/*Now update the FAT */
> +	((__u16 *) (bh_fat->b_data))[(__u16) blkoffset] = 0xfffa;
> +	((__u16 *) (bh_fat->b_data))[((__u16) (blkoffset - 1))] =
> +	    cpu_to_le16(blkoffset);

Please dereference it to the u16 pointer earlier.

> +	mark_buffer_dirty(bh_fat);
> +
> +	brelse(bh_fat);
> +
> +	kfree(writebuf);
> +	*ppos += count;
> +	return count;
> +}
> +
> +static ssize_t vmufat_file_write(struct file *file, const char *buf, size_t count,
> +			 loff_t *ppos)
> +{
> +	struct buffer_head *bh, *bh_fat;
> +	unsigned long inode_num, currentblock, nextblock;
> +	char *writebuf;
> +	int previousblock;
> +	__u16 fatdata;
> +	struct inode *in = (file->f_dentry)->d_inode;
> +	struct super_block *sb = in->i_sb;
> +	struct memcard *vmudetails =
> +	    ((struct memcard *) sb->s_fs_info);
> +	unsigned long blkoffset = *ppos >> in->i_sb->s_blocksize_bits;
> +
> +	if ((ssize_t) count < 0)
> +		return -ENOENT;
> +

Why is this needed?

> +	/* We will assume that all files -
> +	 * unless having inode value of 0
> +	 * are data files
> +	 */
> +
> +	/* copy buffer */
> +	if (count > sb->s_blocksize)
> +		count = sb->s_blocksize;
> +	writebuf = kzalloc(count, GFP_KERNEL);
> +	copy_from_user(writebuf, buf, count);
> +

Need to check return value for both calls
in case of fault or low memory.

> +	/* Handle game files */
> +	inode_num = in->i_ino;
> +	if (inode_num == VMUFAT_ZEROBLOCK)
> +		inode_num = 0;
> +
> +	/*Start by writing out to first block */
> +	if (blkoffset == 0) {
> +		currentblock = inode_num;
> +		bh = vmufat_sb_bread(sb, inode_num);
> +		if (!bh) {
> +			kfree(writebuf);
> +			return -EIO;
> +		}
> +		if (count < sb->s_blocksize)
> +			memset((char *) (bh->b_data), '\0', sb->s_blocksize);
> +		memcpy((char *) (bh->b_data), writebuf, count);

No need for the cast.

That's all for now. Overall there is a fair numebr of leaks 
because of the missed freeing in the error path and lots of duplicated
code because of the multiple error exit points. Also you frequently do
not check the return value of the functions which may fail.

-- 
	Evgeniy Polyakov
