Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZDPLX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZDPLX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 07:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbZDPLXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 07:23:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47388 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbZDPLXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 07:23:10 -0400
Date: Thu, 16 Apr 2009 12:23:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [RFC][patch] filesystem: Vmufat filesystem, version 4
Message-ID: <20090416112308.GB26366@ZenIV.linux.org.uk>
References: <1239654768.6542.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239654768.6542.10.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 09:32:48PM +0100, Adrian McMenamin wrote:
> +struct memcard {
> +	long sb_bnum;
> +	long fat_bnum;
> +	long fat_len;
> +	long dir_bnum;
> +	long dir_len;
> +	long numblocks;
> +};

Eh...
	a) are any of those really signed?
	b) can any of those be more than 32 bits?

> +struct vmufat_block_list {
> +	struct list_head b_list;
> +	int bno;
> +};

You've got to be kidding.  So you want to keep a list of ints and do it
that way?  With separate allocation for every sodding one and a cyclic
list going through the entire bunch?

Besides, 'int' is almost certainly a wrong type.  I can buy 'u32', but...

> +	do {
...
> +	} while (1);

er... that's highly unidiomatic (and fairly common in your code below).
Any reasons for that?

> +	bh_fat =
> +	    vmufat_sb_bread(sb, nextblock);
> +	if (!bh_fat) {
> +		error = -EIO;
> +		goto fail;
> +	}
> +
> +	do {
> +		fatdata = ((u16 *) bh_fat->b_data)[x];
> +		if (fatdata == FAT_UNALLOCATED)
> +			break;	/*empty block */
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

Off-by-twice and that should've been a couple of nested loops.

> +static u16 vmufat_get_fat(struct super_block *sb, long block)
> +{
> +	struct memcard *vmudetails = sb->s_fs_info;
> +	struct buffer_head *bh;
> +	int offset;
> +	u16 block_content;
> +	/* which block in the FAT */
> +	offset = block / (VMU_BLK_SZ / 2);
> +	if (offset >= vmudetails->fat_len)
> +		return FAT_ERROR;
> +
> +	bh = vmufat_sb_bread(sb, offset + 1 +
> +		vmudetails->fat_bnum - vmudetails->fat_len);
> +	if (!bh)
> +		return FAT_ERROR;
> +	/* look inside the block */
> +	block_content = ((u16 *)bh->b_data)[block % (VMU_BLK_SZ / 2)];
> +	put_bh(bh);
> +	return block_content;
> +}

What's the endianness of that puppy?

> +
> +	/* Walk through blocks looking for place to write
> +	* Is this an executible file? */
> +	if (imode & 73) {

No comments.  Really.  There must be some limits on the language one is
willing to use on public maillist, after all.

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
> +	if ((i - 2) > (vmudetails->dir_len * DIR_ENT_PER_BLK)) {
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
> +		if ((i - 2) / DIR_ENT_PER_BLK >
> +			(vmudetails->dir_bnum - blck_read)) {
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
> +		if (saved_file->fblk == 0)
> +			saved_file->fblk = VMUFAT_ZEROBLOCK;
> +
> +		memcpy(saved_file->fname,
> +		       bh->b_data + 4 + vmufat_index(i - 2), VMUFAT_NAMELEN);
> +		filenamelen = strlen(saved_file->fname);

Who said there will be NUL anywhere at all?

> +		if (filenamelen > VMUFAT_NAMELEN)
> +			filenamelen = VMUFAT_NAMELEN;

See above.

> +		if (filldir
> +		    (dirent, saved_file->fname, filenamelen, i++,
> +		     saved_file->fblk, DT_REG) < 0) {
> +			goto finish;
> +		}

WTF do we bother with that copying, anyway?

> +static int vmufat_list_blocks(struct inode *in)
> +{
> +	struct vmufat_inode *vi = VMUFAT_I(in);
> +	struct super_block *sb = in->i_sb;
> +	long nextblock;
> +	long ino = in->i_ino;
> +	struct memcard *vmudetails;
> +	int error;
> +	struct list_head *iter, *iter2;
> +	struct vmufat_block_list *vbl, *nvbl;
> +	u16 fatdata;
> +
> +	vmudetails = sb->s_fs_info;
> +	nextblock = ino;
> +	if (nextblock == VMUFAT_ZEROBLOCK)
> +		nextblock = 0;
> +
> +	/* Delete any previous list of blocks */
> +	list_for_each_safe(iter, iter2, &vi->blocks.b_list) {
> +		vbl = list_entry(iter, struct vmufat_block_list, b_list);
> +		list_del(iter);
> +		kmem_cache_free(vmufat_blist_cachep, vbl);
> +	}
> +	vi->nblcks = 0;
> +	do {
> +		vbl = kmem_cache_alloc(vmufat_blist_cachep,
> +			GFP_KERNEL);
> +		if (!vbl) {
> +			error = -ENOMEM;
> +			goto unwind_out;
> +		}
> +		INIT_LIST_HEAD(&vbl->b_list);
> +		vbl->bno = nextblock;
> +		list_add_tail(&vbl->b_list, &vi->blocks.b_list);
> +		vi->nblcks++;
> +
> +		/* Find next block in the FAT - if there is one */
> +		fatdata = vmufat_get_fat(sb, nextblock);
> +		if (fatdata == FAT_UNALLOCATED) {
> +			printk(KERN_WARNING "VMUFAT: FAT table appears to have"
> +				" been corrupted.\n");
> +			error = -EIO;
> +			goto unwind_out;
> +		}
> +		if (fatdata == FAT_FILE_END)
> +			break;	/*end of file */
> +		nextblock = fatdata;
> +	} while (1);
> +
> +	return 0;
> +
> +unwind_out:
> +	list_for_each_entry_safe(vbl, nvbl, &vi->blocks.b_list, b_list) {
> +		list_del_init(&vbl->b_list);
> +		kmem_cache_free(vmufat_blist_cachep, vbl);
> +	}
> +	return error;
> +}

And you call *that* on every block allocation?

> +				if (le16_to_cpu(((u16 *) bh->b_data)
__le16 *, please, and the same for other places like that.
> +					[(y % DIR_ENT_PER_BLK) * 
> +					DIR_REC_LEN / 2 + 0x01]) == ino)
> +					break;

> +			if ((((u8 *) bh->b_data)[0x01 + z] ==
> +			     0x00) & ~(sb->s_flags & MS_RDONLY))
> +				inode->i_mode |= S_IWUGO;
> +			/* Is file executible - ie a game */
> +			if ((((u8 *) bh->b_data)[z] ==
> +			     0xcc) & ~(sb->s_flags & MS_NOEXEC))
> +				inode->i_mode |= S_IXUGO;

a) there's such thing as local variables.  Use them.
b) when you do that, do remember that names may be longer than one character.
c) linux-kernel is not an IOCCC.  This & ~ above is a pure obfuscation.

> +static void vmufat_put_super(struct super_block *sb)
> +{
> +	sb->s_dev = 0;
WTF for?  Leave handling that to fs/super.c, please.
> +	kfree(sb->s_fs_info);
> +}

> +	/* Look through the FAT */
> +	nextblock = vmudetails->fat_bnum + vmudetails->fat_len - 1;
> +	x = sb->s_blocksize;
> +	bh_fat = vmufat_sb_bread(sb, nextblock);
> +	if (!bh_fat) {
> +		error = -EIO;
> +		goto out;
> +	}
> +
> +	do {
> +		fatdata = ((u16 *) bh_fat->b_data)[x];
> +		if (fatdata == FAT_UNALLOCATED)
> +			free++;
> +		if (--x < 0) {
> +			brelse(bh_fat);
> +			if (--nextblock >= vmudetails->fat_bnum) {
> +				x = sb->s_blocksize;
> +				bh_fat = vmufat_sb_bread(sb, nextblock);
> +				if (!bh_fat) {
> +					error = -EIO;
> +					goto out;
> +				}
> +			} else
> +				break;
> +		}
> +	} while (1);

Pardon me, but... what the hell is going on in that code?  In particular,
is there any reason for not making it a straightforward for() going through
blocks and equally straightforward inner for() going through each block?
BTW, there seems to be an off-by-factor-of-2 above nicely obfuscated by
all that mess.  Namely,
	x = sb->s_blocksize;
	((u16 *) bh_fat->b_data)[x];
will end up accessing data at offset 2 * blocksize, which is twice the size
of actual block.

> +static int vmufat_unlink(struct inode *dir, struct dentry *dentry)
> +{
> +	struct inode *in;
> +
> +	in = dentry->d_inode;
> +	if (!in)
> +		return -EIO;
> +	vmufat_delete_inode(in);
> +	return 0;
> +}

And what happens when I open a file, unlink it and try to read?

Overall: code badly needs deobfuscation before anything else can be done
with it.
