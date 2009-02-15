Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbZBORJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbZBORJK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 12:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbZBORIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 12:08:54 -0500
Received: from matrixpower.ru ([195.178.208.66]:55990 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbZBORIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 12:08:52 -0500
Date: Sun, 15 Feb 2009 20:08:40 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5/8] exofs: dir_inode and directory operations
Message-ID: <20090215170840.GA18115@ioremap.net>
References: <49902A9E.3070002@panasas.com> <1234185853-7873-1-git-send-email-bharrosh@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234185853-7873-1-git-send-email-bharrosh@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, Feb 09, 2009 at 03:24:13PM +0200, Boaz Harrosh (bharrosh@panasas.com) wrote:

> +void exofs_set_link(struct inode *dir, struct exofs_dir_entry *de,
> +			struct page *page, struct inode *inode)
> +{
> +	loff_t pos = page_offset(page) +
> +			(char *) de - (char *) page_address(page);
> +	unsigned len = le16_to_cpu(de->rec_len);
> +	int err;
> +
> +	lock_page(page);
> +	err = exofs_write_begin(NULL, page->mapping, pos, len,
> +				AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
> +	BUG_ON(err);

How unfriendly :)
simple_write_begin() may fail if there is no memory or appropriate
cgroup does not allow to charge more memory.

> +	de->inode_no = cpu_to_le64(inode->i_ino);
> +	exofs_set_de_type(de, inode);
> +	err = exofs_commit_chunk(page, pos, len);
> +	exofs_put_page(page);
> +	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
> +	mark_inode_dirty(dir);
> +}
> +
> +int exofs_add_link(struct dentry *dentry, struct inode *inode)
> +{
> +	struct inode *dir = dentry->d_parent->d_inode;
> +	const unsigned char *name = dentry->d_name.name;
> +	int namelen = dentry->d_name.len;
> +	unsigned chunk_size = exofs_chunk_size(dir);
> +	unsigned reclen = EXOFS_DIR_REC_LEN(namelen);
> +	unsigned short rec_len, name_len;
> +	struct page *page = NULL;
> +	struct exofs_sb_info *sbi = inode->i_sb->s_fs_info;
> +	struct exofs_dir_entry *de;
> +	unsigned long npages = dir_pages(dir);
> +	unsigned long n;
> +	char *kaddr;
> +	loff_t pos;
> +	int err;
> +
> +	for (n = 0; n <= npages; n++) {
> +		char *dir_end;
> +
> +		page = exofs_get_page(dir, n);
> +		err = PTR_ERR(page);
> +		if (IS_ERR(page))
> +			goto out;
> +		lock_page(page);
> +		kaddr = page_address(page);
> +		dir_end = kaddr + exofs_last_byte(dir, n);
> +		de = (struct exofs_dir_entry *)kaddr;
> +		kaddr += PAGE_CACHE_SIZE - reclen;
> +		while ((char *)de <= kaddr) {
> +			if ((char *)de == dir_end) {
> +				name_len = 0;
> +				rec_len = chunk_size;
> +				de->rec_len = cpu_to_le16(chunk_size);
> +				de->inode_no = 0;
> +				goto got_it;
> +			}
> +			if (de->rec_len == 0) {
> +				EXOFS_ERR("ERROR: exofs_add_link: "
> +					"zero-length directory entry");
> +				err = -EIO;
> +				goto out_unlock;
> +			}
> +			err = -EEXIST;
> +			if (exofs_match(namelen, name, de))
> +				goto out_unlock;
> +			name_len = EXOFS_DIR_REC_LEN(de->name_len);
> +			rec_len = le16_to_cpu(de->rec_len);
> +			if (!de->inode_no && rec_len >= reclen)
> +				goto got_it;
> +			if (rec_len >= name_len + reclen)
> +				goto got_it;
> +			de = (struct exofs_dir_entry *) ((char *) de + rec_len);
> +		}
> +		unlock_page(page);
> +		exofs_put_page(page);
> +	}
> +	BUG();
> +	return -EINVAL;
> +

So it will crash the system if directory entry does not contain any
data? What was wrong with -EINVAL?

Also, dir_pages(), readpage_done() and similar functions scream for less
generic names, and at least dir_pages() is already implemented in another
5 filesystems.

> +int exofs_delete_entry(struct exofs_dir_entry *dir, struct page *page)
> +{
> +	struct address_space *mapping = page->mapping;
> +	struct inode *inode = mapping->host;
> +	struct exofs_sb_info *sbi = inode->i_sb->s_fs_info;
> +	char *kaddr = page_address(page);
> +	unsigned from = ((char *)dir - kaddr) & ~(exofs_chunk_size(inode)-1);
> +	unsigned to = ((char *)dir - kaddr) + le16_to_cpu(dir->rec_len);
> +	loff_t pos;
> +	struct exofs_dir_entry *pde = NULL;
> +	struct exofs_dir_entry *de = (struct exofs_dir_entry *) (kaddr + from);
> +	int err;
> +
> +	while ((char *)de < (char *)dir) {

They have the same type, why is it needed to cast them to char pointer?

> +		if (de->rec_len == 0) {
> +			EXOFS_ERR("ERROR: exofs_delete_entry:"
> +				"zero-length directory entry");
> +			err = -EIO;
> +			goto out;
> +		}
> +		pde = de;
> +		de = exofs_next_entry(de);
> +	}
> +	if (pde)
> +		from = (char *)pde - (char *)page_address(page);
> +	pos = page_offset(page) + from;
> +	lock_page(page);
> +	err = exofs_write_begin(NULL, page->mapping, pos, to - from, 0,
> +							&page, NULL);
> +	BUG_ON(err);

Ugh, in the exofs_make_empty() it is handled without so visible
pain.

> +	if (pde)
> +		pde->rec_len = cpu_to_le16(to - from);
> +	dir->inode_no = 0;
> +	err = exofs_commit_chunk(page, pos, to - from);
> +	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
> +	mark_inode_dirty(inode);
> +	sbi->s_numfiles--;
> +out:
> +	exofs_put_page(page);
> +	return err;
> +}
> +
> +int exofs_make_empty(struct inode *inode, struct inode *parent)
> +{
> +	struct address_space *mapping = inode->i_mapping;
> +	struct page *page = grab_cache_page(mapping, 0);
> +	unsigned chunk_size = exofs_chunk_size(inode);
> +	struct exofs_dir_entry *de;
> +	int err;
> +	void *kaddr;
> +
> +	if (!page)
> +		return -ENOMEM;
> +
> +	err = exofs_write_begin(NULL, page->mapping, 0, chunk_size, 0,
> +							&page, NULL);
> +	if (err) {
> +		unlock_page(page);
> +		goto fail;
> +	}
> +
> +	kaddr = kmap_atomic(page, KM_USER0);
> +	de = (struct exofs_dir_entry *)kaddr;
> +	de->name_len = 1;
> +	de->rec_len = cpu_to_le16(EXOFS_DIR_REC_LEN(1));
> +	memcpy(de->name, ".\0\0", 4);

Plus one byte from the stack?

> +	de->inode_no = cpu_to_le64(inode->i_ino);
> +	exofs_set_de_type(de, inode);
> +
> +	de = (struct exofs_dir_entry *)(kaddr + EXOFS_DIR_REC_LEN(1));
> +	de->name_len = 2;
> +	de->rec_len = cpu_to_le16(chunk_size - EXOFS_DIR_REC_LEN(1));
> +	de->inode_no = cpu_to_le64(parent->i_ino);
> +	memcpy(de->name, "..\0", 4);

And another one.

> +	exofs_set_de_type(de, inode);
> +	kunmap_atomic(page, KM_USER0);
> +	err = exofs_commit_chunk(page, 0, chunk_size);
> +fail:
> +	page_cache_release(page);
> +	return err;
> +}
> +

> +struct inode *exofs_new_inode(struct inode *dir, int mode)
> +{
> +	struct super_block *sb;
> +	struct inode *inode;
> +	struct exofs_i_info *oi;
> +	struct exofs_sb_info *sbi;
> +	struct osd_request *or;
> +	struct osd_obj_id obj;
> +	int ret;
> +
> +	sb = dir->i_sb;
> +	inode = new_inode(sb);
> +	if (!inode)
> +		return ERR_PTR(-ENOMEM);
> +
> +	oi = exofs_i(inode);
> +
> +	init_waitqueue_head(&oi->i_wq);
> +	set_obj_2bcreated(oi);
> +
> +	sbi = sb->s_fs_info;
> +
> +	sb->s_dirt = 1;
> +	inode->i_uid = current->cred->fsuid;
> +	if (dir->i_mode & S_ISGID) {
> +		inode->i_gid = dir->i_gid;
> +		if (S_ISDIR(mode))
> +			mode |= S_ISGID;
> +	} else {
> +		inode->i_gid = current->cred->fsgid;
> +	}
> +	inode->i_mode = mode;
> +
> +	inode->i_ino = sbi->s_nextid++;
> +	inode->i_blkbits = EXOFS_BLKSHIFT;
> +	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
> +	oi->i_commit_size = inode->i_size = 0;
> +	spin_lock(&sbi->s_next_gen_lock);
> +	inode->i_generation = sbi->s_next_generation++;
> +	spin_unlock(&sbi->s_next_gen_lock);
> +	insert_inode_hash(inode);
> +
> +	mark_inode_dirty(inode);
> +
> +	obj.partition = sbi->s_pid;
> +	obj.id = inode->i_ino + EXOFS_OBJ_OFF;
> +	exofs_make_credential(oi->i_cred, &obj);
> +
> +	or = osd_start_request(sbi->s_dev, GFP_KERNEL);
> +	if (unlikely(!or)) {
> +		EXOFS_ERR("exofs_new_inode: osd_start_request failed\n");
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	osd_req_create_object(or, &obj);
> +
> +	/* increment the refcount so that the inode will still be around when we
> +	 * reach the callback
> +	 */
> +	atomic_inc(&inode->i_count);
> +
> +	ret = exofs_async_op(or, create_done, inode, oi->i_cred);
> +	if (ret) {
> +		atomic_dec(&inode->i_count);

igrab()/iput()?

> +		osd_end_request(or);
> +		return ERR_PTR(-EIO);
> +	}
> +	atomic_inc(&sbi->s_curr_pending);
> +
> +	return inode;
> +}

> +static int exofs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
> +{
> +	struct inode *inode;
> +	int err = -EMLINK;
> +
> +	if (dir->i_nlink >= EXOFS_LINK_MAX)
> +		goto out;
> +
> +	inode_inc_link_count(dir);
> +
> +	inode = exofs_new_inode(dir, S_IFDIR | mode);
> +	err = PTR_ERR(inode);
> +	if (IS_ERR(inode))
> +		goto out_dir;
> +
> +	inode->i_op = &exofs_dir_inode_operations;
> +	inode->i_fop = &exofs_dir_operations;
> +	inode->i_mapping->a_ops = &exofs_aops;
> +
> +	inode_inc_link_count(inode);
> +
> +	err = exofs_make_empty(inode, dir);
> +	if (err)
> +		goto out_fail;
> +
> +	err = exofs_add_link(dentry, inode);
> +	if (err)
> +		goto out_fail;
> +
> +	d_instantiate(dentry, inode);
> +out:
> +	return err;
> +
> +out_fail:
> +	inode_dec_link_count(inode);
> +	inode_dec_link_count(inode);

Why two decrements, will it be ok after exofs_make_empty() fail when it
was incremented only once?

> +	iput(inode);
> +out_dir:
> +	inode_dec_link_count(dir);
> +	goto out;
> +}

-- 
	Evgeniy Polyakov
