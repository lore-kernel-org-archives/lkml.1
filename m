Return-Path: <linux-kernel-owner+w=401wt.eu-S1759760AbYHVAcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760AbYHVAcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 20:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbYHVAck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 20:32:40 -0400
Received: from anchor-post-31.mail.demon.net ([194.217.242.89]:4769 "EHLO
	anchor-post-31.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754094AbYHVAcj (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 20:32:39 -0400
X-Greylist: delayed 661 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Aug 2008 20:32:39 EDT
Message-ID: <48AE0697.5040706@lougher.demon.co.uk>
Date: Fri, 22 Aug 2008 01:21:43 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: jaredeh@gmail.com
CC: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@AM.SONY.COM,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 04/10] AXFS: axfs_inode.c
References: <48AD00F0.5030403@gmail.com>
In-Reply-To: <48AD00F0.5030403@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:

> +
> +static int axfs_iget5_test(struct inode *inode, void *opaque)
> +{
> +	u64 *inode_number = (u64 *) opaque;
> +
> +	if (inode->i_sb == NULL) {
> +		printk(KERN_ERR "axfs_iget5_test:"
> +		       " the super block is set to null\n");
> +	}
> +	if (inode->i_ino == *inode_number)
> +		return 1;	/* matches */
> +	else
> +		return 0;	/* does not match */
> +}
> +

This implies inode_numbers are unique in AXFS?  If so you can get rid of 
  the axfs_iget5_set/test logic.  This is only necessary for filesystems 
with non-unique inode numbers like cramfs.

> +
> +struct inode *axfs_create_vfs_inode(struct super_block *sb, int ino)
> +{
> +	struct axfs_super *sbi = AXFS_SB(sb);
> +	struct inode *inode;
> +	u64 size;
> +
> +	inode = iget5_locked(sb, ino, axfs_iget5_test, axfs_iget5_set, &ino);

If inode_numbers are unique, use iget_locked here.

> +
> +	if (!(inode && (inode->i_state & I_NEW)))
> +		return inode;
> +
> +	inode->i_mode = AXFS_GET_MODE(sbi, ino);
> +	inode->i_uid = AXFS_GET_UID(sbi, ino);
> +	size = AXFS_GET_INODE_FILE_SIZE(sbi, ino);
> +	inode->i_size = size;

What's the reason for splitting this into two lines, rather than

inode->i_size = AXFS_GET_INODE_FILE_SIZE(sbi, ino);


> +	inode->i_blocks = AXFS_GET_INODE_NUM_ENTRIES(sbi, ino);
> +	inode->i_blkbits = PAGE_CACHE_SIZE * 8;
> +	inode->i_gid = AXFS_GET_GID(sbi, ino);
> +
> +	inode->i_mtime = inode->i_atime = inode->i_ctime = sbi->timestamp;

No unique per inode time?  Will cause problems using AXFS for archives 
etc. where preserving timestamps is important.


> +	inode->i_ino = ino;
> +

Unnecessary, set by iget_locked/iget_locked5

> +
> +static int axfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
> +{
> +	struct inode *inode = filp->f_dentry->d_inode;
> +	struct super_block *sb = inode->i_sb;
> +	struct axfs_super *sbi = AXFS_SB(sb);
> +	u64 ino_number = inode->i_ino;
> +	u64 entry;
> +	loff_t dir_index;
> +	char *name;
> +	int namelen, mode;
> +	int err = 0;
> +
> +	/* Get the current index into the directory and verify it is not beyond
> +	   the end of the list */
> +	dir_index = filp->f_pos;
> +	if (dir_index >= AXFS_GET_INODE_NUM_ENTRIES(sbi, ino_number))
> +		goto out;
> +
> +	/* Verify the inode is for a directory */
> +	if (!(S_ISDIR(inode->i_mode))) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	while (dir_index < AXFS_GET_INODE_NUM_ENTRIES(sbi, ino_number)) {
> +		entry = AXFS_GET_INODE_ARRAY_INDEX(sbi, ino_number) + dir_index;
> +
> +		name = (char *)AXFS_GET_INODE_NAME(sbi, entry);

One to one mapping between inode number and inode name?  No hard link 
support...?

> +		namelen = strlen(name);
> +
> +		mode = (int)AXFS_GET_MODE(sbi, entry);
> +		err = filldir(dirent, name, namelen, dir_index, entry, mode);
> +
> +		if (err)
> +			break;
> +
> +		dir_index++;
> +		filp->f_pos = dir_index;
> +	}
> +
> +out:
> +	return 0;
> +}

Are "." and ".." stored in the directory?  If not then axfs_readdir 
should fabricate them to avoid confusing applications that expect 
readdir(3) to return them.


> +static ssize_t axfs_file_read(struct file *filp, char __user *buf, size_t len,
> +			      loff_t *ppos)

> +	actual_size = len > remaining ? remaining : len;
> +	readlength = actual_size < PAGE_SIZE ? actual_size : PAGE_SIZE;

Use min() or min_t()

> +
> +static int axfs_readpage(struct file *file, struct page *page)
> +{
> +
> +	if (node_type == Compressed) {
> +		/* node is in compessed region */
> +		cnode_offset = AXFS_GET_CNODE_OFFSET(sbi, node_index);
> +		cnode_index = AXFS_GET_CNODE_INDEX(sbi, node_index);
> +		down_write(&sbi->lock);
> +		if (cnode_index != sbi->current_cnode_index) {
> +			/* uncompress only necessary if different cblock */
> +			ofs = AXFS_GET_CBLOCK_OFFSET(sbi, cnode_index);
> +			len = AXFS_GET_CBLOCK_OFFSET(sbi, cnode_index + 1);
> +			len -= ofs;
> +			axfs_copy_data(sb, cblk1, &(sbi->compressed), ofs, len);
> +			axfs_uncompress_block(cblk0, cblk_size, cblk1, len);
> +			sbi->current_cnode_index = cnode_index;

I assume compressed blocks can be larger than PAGE_CACHE_SIZE?  This 
suffers from the rather obvious inefficiency that you decompress a big 
block > PAGE_CACHE_SIZE, but only copy one PAGE_CACHE_SIZE page out of 
it.  If multiple files are being read simultaneously (a common 
occurrence), then each is going to replace your one cached uncompressed 
block (sbi->current_cnode_index), leading to decompressing the same 
blocks over and over again on sequential file access.

readpage file A, index 1 -> decompress block X
readpage file B, index 1 -> decompress block Y (replaces X)
readpage file A, index 2 -> repeated decompress of block X (replaces Y)
readpage file B, index 2 -> repeated decompress of block Y (replaces X)

and so on.

> +		}
> +		downgrade_write(&sbi->lock);
> +		max_len = cblk_size - cnode_offset;
> +		len = max_len > PAGE_CACHE_SIZE ? PAGE_CACHE_SIZE : max_len;

Again, min() or min_t().  Lots of these.

Phillip
