Return-Path: <linux-kernel-owner+w=401wt.eu-S1757100AbZDSUwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbZDSUwZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 16:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbZDSUwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 16:52:09 -0400
Received: from mail.fieldses.org ([141.211.133.115]:41282 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814AbZDSUwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 16:52:07 -0400
Date: Sun, 19 Apr 2009 16:51:54 -0400
To: David Woodhouse <dwmw2@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, hooanon05@yahoo.co.jp,
       hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Fix i_mutex handling in nfsd readdir
Message-ID: <20090419205154.GA18110@fieldses.org>
References: <8036.1237474444@jrobl> <1237475837.16359.106.camel@macbook.infradead.org> <8913.1237476890@jrobl> <1239960739.3428.33.camel@macbook.infradead.org> <20090417193233.GM26366@ZenIV.linux.org.uk> <1240006620.19059.41.camel@macbook.infradead.org> <20090417224350.GN26366@ZenIV.linux.org.uk> <20090417225306.GO26366@ZenIV.linux.org.uk> <1240013753.21423.86.camel@macbook.infradead.org> <1240144069.3589.156.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240144069.3589.156.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 01:27:49PM +0100, David Woodhouse wrote:
> Commit 14f7dd63 ("Copy XFS readdir hack into nfsd code") introduced a
> bug to generic code which had been extant for a long time in the XFS
> version -- it started to call through into lookup_one_len() and hence
> into the file systems' ->lookup() methods without i_mutex held on the
> directory.
> 
> This patch fixes it by locking the directory's i_mutex again before
> calling the filldir functions. The original deadlocks which commit
> 14f7dd63 was designed to avoid are still avoided, because they were due
> to fs-internal locking, not i_mutex.
> 
> Commit 05f4f678 ("nfsd4: don't do lookup within readdir in recovery
> code") introduced a similar problem there, which this also addresses.
> 
> While we're at it, fix the return type of nfsd_buffered_readdir() which
> should be a __be32 not an int -- it's an NFS errno, not a Linux errno.
> And return nfserrno(-ENOMEM) when allocation fails, not just -ENOMEM.
> Sparse would have caught both of those if it wasn't so busy bitching
> about __cold__.
> 
> Commit 05f4f678 ("nfsd4: don't do lookup within readdir in recovery
> code") introduced a similar problem with calling lookup_one_len()
> without i_mutex, which this patch also addresses.
> 
> Reported-by: J. R. Okajima <hooanon05@yahoo.co.jp>
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> Umm-I-can-live-with-that-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> Still haven't tested the NFSv4 bit -- Bruce?

Thanks, there's an iterator in there that calls a passed-in function,
some examples of which were taking the i_mutex--so some fixing up is
needed.  I'll follow up with a patch once I've got one tested.

--b.

> 
> This time I remembered to remove the no-longer-used 'done:' label from
> nfsd_buffered_readdir() too.
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index b8433eb..78f253c 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1248,6 +1248,8 @@ struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
>  	int err;
>  	struct qstr this;
>  
> +	WARN_ON_ONCE(!mutex_is_locked(&base->d_inode->i_mutex));
> +
>  	err = __lookup_one_len(name, &this, base, len);
>  	if (err)
>  		return ERR_PTR(err);
> diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
> index 3444c00..210709c 100644
> --- a/fs/nfsd/nfs4recover.c
> +++ b/fs/nfsd/nfs4recover.c
> @@ -229,21 +229,23 @@ nfsd4_list_rec_dir(struct dentry *dir, recdir_func *f)
>  		goto out;
>  	status = vfs_readdir(filp, nfsd4_build_namelist, &names);
>  	fput(filp);
> +	mutex_lock(&dir->d_inode->i_mutex);
>  	while (!list_empty(&names)) {
>  		entry = list_entry(names.next, struct name_list, list);
>  
>  		dentry = lookup_one_len(entry->name, dir, HEXDIR_LEN-1);
>  		if (IS_ERR(dentry)) {
>  			status = PTR_ERR(dentry);
> -			goto out;
> +			break;
>  		}
>  		status = f(dir, dentry);
>  		dput(dentry);
>  		if (status)
> -			goto out;
> +			break;
>  		list_del(&entry->list);
>  		kfree(entry);
>  	}
> +	mutex_unlock(&dir->d_inode->i_mutex);
>  out:
>  	while (!list_empty(&names)) {
>  		entry = list_entry(names.next, struct name_list, list);
> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index ab93fcf..0874299 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -1885,8 +1885,8 @@ static int nfsd_buffered_filldir(void *__buf, const char *name, int namlen,
>  	return 0;
>  }
>  
> -static int nfsd_buffered_readdir(struct file *file, filldir_t func,
> -				 struct readdir_cd *cdp, loff_t *offsetp)
> +static __be32 nfsd_buffered_readdir(struct file *file, filldir_t func,
> +				    struct readdir_cd *cdp, loff_t *offsetp)
>  {
>  	struct readdir_data buf;
>  	struct buffered_dirent *de;
> @@ -1896,11 +1896,12 @@ static int nfsd_buffered_readdir(struct file *file, filldir_t func,
>  
>  	buf.dirent = (void *)__get_free_page(GFP_KERNEL);
>  	if (!buf.dirent)
> -		return -ENOMEM;
> +		return nfserrno(-ENOMEM);
>  
>  	offset = *offsetp;
>  
>  	while (1) {
> +		struct inode *dir_inode = file->f_path.dentry->d_inode;
>  		unsigned int reclen;
>  
>  		cdp->err = nfserr_eof; /* will be cleared on successful read */
> @@ -1919,26 +1920,38 @@ static int nfsd_buffered_readdir(struct file *file, filldir_t func,
>  		if (!size)
>  			break;
>  
> +		/*
> +		 * Various filldir functions may end up calling back into
> +		 * lookup_one_len() and the file system's ->lookup() method.
> +		 * These expect i_mutex to be held, as it would within readdir.
> +		 */
> +		host_err = mutex_lock_killable(&dir_inode->i_mutex);
> +		if (host_err)
> +			break;
> +
>  		de = (struct buffered_dirent *)buf.dirent;
>  		while (size > 0) {
>  			offset = de->offset;
>  
>  			if (func(cdp, de->name, de->namlen, de->offset,
>  				 de->ino, de->d_type))
> -				goto done;
> +				break;
>  
>  			if (cdp->err != nfs_ok)
> -				goto done;
> +				break;
>  
>  			reclen = ALIGN(sizeof(*de) + de->namlen,
>  				       sizeof(u64));
>  			size -= reclen;
>  			de = (struct buffered_dirent *)((char *)de + reclen);
>  		}
> +		mutex_unlock(&dir_inode->i_mutex);
> +		if (size > 0) /* We bailed out early */
> +			break;
> +
>  		offset = vfs_llseek(file, 0, SEEK_CUR);
>  	}
>  
> - done:
>  	free_page((unsigned long)(buf.dirent));
>  
>  	if (host_err)
> 
> -- 
> dwmw2
> 
