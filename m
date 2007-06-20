Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbXFTMJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbXFTMJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 08:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbXFTMJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 08:09:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41939 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbXFTMJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 08:09:52 -0400
Date: Wed, 20 Jun 2007 13:09:47 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC PATCH 4/4] Directory listing support for union mounted directories.
Message-ID: <20070620120947.GA3973@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Bharata B Rao <bharata@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jan Blunck <j.blunck@tu-harburg.de>
References: <20070620055050.GB4267@in.ibm.com> <20070620055418.GF4267@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070620055418.GF4267@in.ibm.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 11:24:18AM +0530, Bharata B Rao wrote:
> From: Bharata B Rao <bharata@linux.vnet.ibm.com>
> Subject: Directory listing support for union mounted directories.
> 
> Modifies readdir()/getdents() to support union mounted directories.
> 
> This patch adds support to readdir()/getdents() to read directory entries
> from all the directories of the union stack, and present a merged view to
> the userspace. This is achieved by maintaining a cache of read entries.
> 
> TODO: Breaks lseek on union mounted directories, Fix this.

Btw, to avoid dealing with file structs representing multiple objects
->readdir should be changed to an inode_operation and not take a struct
file * but rather struct inode + loff_t *ppos.  This sounds like a nice
preparatory patch for any kind of union mount implementation and is
acceptable standing on it's own.

> 
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> ---
>  fs/file_table.c    |    1 
>  fs/readdir.c       |  242 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/fs.h |   12 ++
>  3 files changed, 254 insertions(+), 1 deletion(-)
> 
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -174,6 +174,7 @@ void fastcall __fput(struct file *file)
>  	if (file->f_mode & FMODE_WRITE)
>  		put_write_access(inode);
>  	put_pid(file->f_owner.pid);
> +	put_rdstate(file->f_rdstate);
>  	file_kill(file);
>  	file->f_path.dentry = NULL;
>  	file->f_path.mnt = NULL;
> --- a/fs/readdir.c
> +++ b/fs/readdir.c
> @@ -19,6 +19,8 @@
>  
>  #include <asm/uaccess.h>
>  
> +int readdir_union(struct file *file, void *buf, filldir_t filler);
> +
>  int vfs_readdir(struct file *file, filldir_t filler, void *buf)
>  {
>  	struct inode *inode = file->f_path.dentry->d_inode;
> @@ -33,7 +35,10 @@ int vfs_readdir(struct file *file, filld
>  	mutex_lock(&inode->i_mutex);
>  	res = -ENOENT;
>  	if (!IS_DEADDIR(inode)) {
> -		res = file->f_op->readdir(file, buf, filler);
> +		if (IS_MNT_UNION(file->f_path.mnt))
> +			res = readdir_union(file, buf, filler);
> +		else
> +			res = file->f_op->readdir(file, buf, filler);
>  		file_accessed(file);
>  	}
>  	mutex_unlock(&inode->i_mutex);
> @@ -303,3 +308,238 @@ out_putf:
>  out:
>  	return error;
>  }
> +
> +/*
> + * NOTE: Some of the code below which maintains a list of dirents as a cache
> + * is from Jan Blunck's original union mount readdir patch.
> + */
> +
> +/* The readdir cache object */
> +struct rdcache_entry {
> +	struct list_head list;
> +	struct qstr name;
> +};
> +
> +struct rdcache_callback {
> +	void *buf;			/* original callback buffer */
> +	filldir_t filldir;		/* the filldir() we should call */
> +	int error;			/* stores filldir error */
> +	struct rdstate *rdstate;	/* readdir state */
> +};
> +
> +static int rdcache_add_entry(struct list_head *list,
> +				 const char *name, int namelen)
> +{
> +	struct rdcache_entry *this;
> +	char *tmp_name;
> +
> +	this = kmalloc(sizeof(*this), GFP_KERNEL);
> +	if (!this) {
> +		printk(KERN_CRIT "rdcache_add_entry(): out of kernel memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	tmp_name = kmalloc(namelen + 1, GFP_KERNEL);
> +	if (!tmp_name) {
> +		printk(KERN_CRIT "rdcache_add_entry(): out of kernel memory\n");
> +		kfree(this);
> +		return -ENOMEM;
> +	}
> +
> +	this->name.name = tmp_name;
> +	this->name.len = namelen;
> +	this->name.hash = 0;
> +	memcpy(tmp_name, name, namelen);
> +	tmp_name[namelen] = 0;
> +	INIT_LIST_HEAD(&this->list);
> +	list_add(&this->list, list);
> +	return 0;
> +}
> +
> +static void rdcache_free(struct list_head *list)
> +{
> +	struct list_head *p;
> +	struct list_head *ptmp;
> +	int count = 0;
> +
> +	list_for_each_safe(p, ptmp, list) {
> +		struct rdcache_entry *this;
> +
> +		this = list_entry(p, struct rdcache_entry, list);
> +		list_del_init(&this->list);
> +		kfree(this->name.name);
> +		kfree(this);
> +		count++;
> +	}
> +	return;
> +}
> +
> +static int rdcache_find_entry(struct list_head *uc_list,
> +				  const char *name, int namelen)
> +{
> +	struct rdcache_entry *p;
> +	int ret = 0;
> +
> +	list_for_each_entry(p, uc_list, list) {
> +		if (p->name.len != namelen)
> +			continue;
> +		if (strncmp(p->name.name, name, namelen) == 0) {
> +			ret = 1;
> +			break;
> +		}
> +	}
> +	return ret;
> +}
> +
> +/*
> + * filldir routine for union mounted directories.
> + * Handles duplicate elimination by building a readdir cache.
> + * TODO: readdir cache is a linked list. Check if this can be designed
> + * more efficiently.
> + */
> +static int filldir_union(void *buf, const char *name, int namlen,
> +			   loff_t offset, u64 ino, unsigned int d_type)
> +{
> +	struct rdcache_callback *cb = buf;
> +	int err;
> +
> +	if (rdcache_find_entry(&cb->rdstate->dirent_cache, name, namlen))
> +		return 0;
> +
> +	err =  cb->filldir(cb->buf, name, namlen, offset, ino, d_type);
> +	if (err >= 0)
> +		rdcache_add_entry(&cb->rdstate->dirent_cache, name, namlen);
> +	cb->error = err;
> +	return err;
> +}
> +
> +/* Called from last fput() */
> +void put_rdstate(struct rdstate *rdstate)
> +{
> +	if (!rdstate)
> +		return;
> +
> +	mntput(rdstate->mnt);
> +	dput(rdstate->dentry);
> +	rdcache_free(&rdstate->dirent_cache);
> +	kfree(rdstate);
> +}
> +
> +static struct rdstate *get_rdstate(struct file *file)
> +{
> +	if (file->f_rdstate)
> +		return file->f_rdstate;
> +
> +	/*
> +	 * We have read the dirents from this earlier but now don't have a
> +	 * corresponding rdstate. This shouldn't happen.
> +	 */
> +	if (file->f_pos)
> +		return ERR_PTR(-EINVAL);
> +
> +	file->f_rdstate = kmalloc(sizeof(struct rdstate), GFP_KERNEL);
> +	if (!file->f_rdstate)
> +		return ERR_PTR(-ENOMEM);
> +
> +	file->f_rdstate->off = 0;
> +	file->f_rdstate->mnt = mntget(file->f_path.mnt);
> +	file->f_rdstate->dentry = dget(file->f_path.dentry);
> +	INIT_LIST_HEAD(&file->f_rdstate->dirent_cache);
> +	return file->f_rdstate;
> +}
> +
> +int readdir_union(struct file *file, void *buf, filldir_t filler)
> +{
> +	struct dentry *topmost = file->f_path.dentry;
> +	struct rdstate *rdstate;
> +	struct nameidata nd;
> +	loff_t offset = 0;
> +	struct rdcache_callback cb;
> +	int err = 0;
> +
> +	/*
> +	 * If this is not a union mount point or not a unioned directory
> +	 * within the union mount point, do readdir in the normal way.
> +	 */
> +	nd.mnt = file->f_path.mnt;
> +	nd.dentry = file->f_path.dentry;
> +	if (!next_union_mount_exists(nd.mnt, nd.dentry))
> +		return file->f_op->readdir(file, buf, filler);
> +
> +	rdstate = get_rdstate(file);
> +	if (IS_ERR(rdstate)) {
> +		err = PTR_ERR(rdstate);
> +		return err;
> +	}
> +
> +	cb.buf = buf;
> +	cb.filldir = filler;
> +	cb.rdstate = rdstate;
> +
> +	offset = rdstate->off;
> +
> +	/* Read from the topmost directory */
> +	if (rdstate->dentry == topmost) {
> +		file->f_pos = offset;
> +		err = file->f_op->readdir(file, &cb, filldir_union);
> +		rdstate->off = file->f_pos;
> +		if (err < 0 || cb.error < 0)
> +			goto out;
> +
> +		/*
> +		 * Reading from topmost dir complete, start reading the lower
> +		 * dir from the beginning.
> +		 */
> +		offset = 0;
> +	} else {
> +		nd.mnt = rdstate->mnt;
> +		nd.dentry = rdstate->dentry;
> +		goto read_lower;
> +	}
> +
> +	if (!next_union_mount(&nd))
> +		return err;
> +
> +read_lower:
> +	do {
> +		struct vfsmount *mnt_tmp = mntget(nd.mnt);
> +		struct dentry *dentry_tmp = dget(nd.dentry);
> +		struct file *ftmp = dentry_open(nd.dentry, nd.mnt,
> +						file->f_flags);
> +		if (IS_ERR(ftmp)) {
> +			mntput(mnt_tmp);
> +			dput(dentry_tmp);
> +			err = PTR_ERR(ftmp);
> +			goto out;
> +		}
> +
> +		mutex_lock(&nd.dentry->d_inode->i_mutex);
> +		ftmp->f_pos = offset;
> +
> +		err = ftmp->f_op->readdir(ftmp, &cb, filldir_union);
> +		file_accessed(ftmp);
> +		rdstate->off = ftmp->f_pos;
> +		mutex_unlock(&nd.dentry->d_inode->i_mutex);
> +		if (nd.mnt != rdstate->mnt) {
> +			mntput(rdstate->mnt);
> +			rdstate->mnt = mntget(nd.mnt);
> +		}
> +		if (nd.dentry != rdstate->dentry) {
> +			dput(rdstate->dentry);
> +			rdstate->dentry = dget(nd.dentry);
> +		}
> +		fput(ftmp);
> +		if (err < 0 || cb.error < 0)
> +			goto out;
> +
> +		/*
> +		 * Reading from a lower dir complete, start reading the
> +		 * next lower dir from the beginning.
> +		 */
> +		offset = 0;
> +	} while (next_union_mount(&nd));
> +
> +	return 0;
> +out:
> +	return err;
> +}
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -841,6 +841,14 @@ static inline void ra_set_size(struct fi
>  unsigned long ra_submit(struct file_ra_state *ra,
>  		       struct address_space *mapping, struct file *filp);
>  
> +/* Direct cache for readdir, used for union mounted directories. */
> +struct rdstate {
> +	struct vfsmount *mnt;
> +	struct dentry *dentry;
> +	loff_t off;
> +	struct list_head dirent_cache;
> +};
> +
>  struct file {
>  	/*
>  	 * fu_list becomes invalid after file_free is called and queued via
> @@ -875,6 +883,7 @@ struct file {
>  	spinlock_t		f_ep_lock;
>  #endif /* #ifdef CONFIG_EPOLL */
>  	struct address_space	*f_mapping;
> +	struct rdstate		*f_rdstate;
>  };
>  extern spinlock_t files_lock;
>  #define file_list_lock() spin_lock(&files_lock);
> @@ -2119,5 +2128,8 @@ static inline void free_secdata(void *se
>  { }
>  #endif	/* CONFIG_SECURITY */
>  
> +/* fs/readdir.c */
> +void put_rdstate(struct rdstate *rdstate);
> +
>  #endif /* __KERNEL__ */
>  #endif /* _LINUX_FS_H */
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
