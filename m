Return-Path: <linux-kernel-owner+w=401wt.eu-S1759189AbZDGXOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189AbZDGXOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbZDGXMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:12:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756592AbZDGXMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:12:45 -0400
Date: Tue, 7 Apr 2009 16:06:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, john@johnmccutchan.com,
       rlove@rlove.org
Subject: Re: [PATCH -V2 06/13] dnotify: reimplement dnotify using fsnotify
Message-Id: <20090407160622.78b89f7f.akpm@linux-foundation.org>
In-Reply-To: <20090327200537.32007.25483.stgit@paris.rdu.redhat.com>
References: <20090327200508.32007.63278.stgit@paris.rdu.redhat.com>
	<20090327200537.32007.25483.stgit@paris.rdu.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 16:05:37 -0400
Eric Paris <eparis@redhat.com> wrote:

> Reimplement dnotify using fsnotify.
> 
>
> ...
>
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1431,6 +1431,8 @@ S:	Orphan
>  DIRECTORY NOTIFICATION (DNOTIFY)
>  P:	Stephen Rothwell
>  M:	sfr@canb.auug.org.au
> +P:	Eric Paris
> +M:	eparis@parisplace.org

hah!

>  L:	linux-kernel@vger.kernel.org
>  S:	Supported
>  
>
> ...
>
> +static int dnotify_should_send_event(struct fsnotify_group *group, struct inode *inode, __u32 mask)

could return bool, if you like that sort of thing.

> +{
> +	struct fsnotify_mark_entry *entry;
> +	int send;
> +
> +	/* !dir_notify_enable should never get here, don't waste time checking
> +	if (!dir_notify_enable)
> +		return 0; */
> +
> +	/* not a dir, dnotify doesn't care */
> +	if (!S_ISDIR(inode->i_mode))
> +		return 0;
> +
> +	spin_lock(&inode->i_lock);
> +	entry = fsnotify_find_mark_entry(group, inode);
> +	spin_unlock(&inode->i_lock);
> +
> +	/* no mark means no dnotify watch */
> +	if (!entry)
> +		return 0;
> +
> +	spin_lock(&entry->lock);
> +	send = !!(mask & entry->mask);
> +	spin_unlock(&entry->lock);
> +	fsnotify_put_mark(entry);
> +
> +	return send;
> +}
> +
>
> ...
>
> -int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
> +/* this conversion is done only at watch creation */
> +static inline __u32  convert_arg(unsigned long arg)

The compiler will inline this anyway.

s/  / /

> +{
> +	__u32 new_mask = FS_EVENT_ON_CHILD;
> +
> +	if (arg & DN_MULTISHOT)
> +		new_mask |= FS_DN_MULTISHOT;
> +	if (arg & DN_DELETE)
> +		new_mask |= (FS_DELETE | FS_MOVED_FROM);
> +	if (arg & DN_MODIFY)
> +		new_mask |= FS_MODIFY;
> +	if (arg & DN_ACCESS)
> +		new_mask |= FS_ACCESS;
> +	if (arg & DN_ATTRIB)
> +		new_mask |= FS_ATTRIB;
> +	if (arg & DN_RENAME)
> +		new_mask |= FS_DN_RENAME;
> +	if (arg & DN_CREATE)
> +		new_mask |= (FS_CREATE | FS_MOVED_TO);
> +
> +	return new_mask;
> +}
> +
> +static int attach_dn(struct dnotify_struct *dn, struct dnotify_mark_entry *dnentry, fl_owner_t id,
> +		     int fd, struct file *filp, __u32 mask)

Given that the definition is already broken over two lines, there's
nothing to be gained by making it look messy in 80-cols?

>  {
> -	struct dnotify_struct *dn;
>  	struct dnotify_struct *odn;
>  	struct dnotify_struct **prev;
> -	struct inode *inode;
> -	fl_owner_t id = current->files;
> -	struct file *f;
> -	int error = 0;
>  
> -	if ((arg & ~DN_MULTISHOT) == 0) {
> -		dnotify_flush(filp, id);
> -		return 0;
> -	}
> -	if (!dir_notify_enable)
> -		return -EINVAL;
> -	inode = filp->f_path.dentry->d_inode;
> -	if (!S_ISDIR(inode->i_mode))
> -		return -ENOTDIR;
> -	dn = kmem_cache_alloc(dn_cache, GFP_KERNEL);
> -	if (dn == NULL)
> -		return -ENOMEM;
> -	spin_lock(&inode->i_lock);
> -	prev = &inode->i_dnotify;
> +	prev = &dnentry->dn;
>  	while ((odn = *prev) != NULL) {
> +		/* do we already have a dnotify struct and we are just adding more events? */
>  		if ((odn->dn_owner == id) && (odn->dn_filp == filp)) {
>  			odn->dn_fd = fd;
> -			odn->dn_mask |= arg;
> -			inode->i_dnotify_mask |= arg & ~DN_MULTISHOT;
> -			goto out_free;
> +			odn->dn_mask |= mask;
> +			return -EEXIST;
>  		}
>  		prev = &odn->dn_next;
>  	}
>  
> -	rcu_read_lock();
> -	f = fcheck(fd);
> -	rcu_read_unlock();
> -	/* we'd lost the race with close(), sod off silently */
> -	/* note that inode->i_lock prevents reordering problems
> -	 * between accesses to descriptor table and ->i_dnotify */
> -	if (f != filp)
> -		goto out_free;
> -
> -	error = __f_setown(filp, task_pid(current), PIDTYPE_PID, 0);
> -	if (error)
> -		goto out_free;
> -
> -	dn->dn_mask = arg;
> +	dn->dn_mask = mask;
>  	dn->dn_fd = fd;
>  	dn->dn_filp = filp;
>  	dn->dn_owner = id;
> -	inode->i_dnotify_mask |= arg & ~DN_MULTISHOT;
> -	dn->dn_next = inode->i_dnotify;
> -	inode->i_dnotify = dn;
> -	spin_unlock(&inode->i_lock);
> -	return 0;
> +	dn->dn_next = dnentry->dn;
> +	dnentry->dn = dn;
>  
> -out_free:
> -	spin_unlock(&inode->i_lock);
> -	kmem_cache_free(dn_cache, dn);
> -	return error;
> +	return 0;
>  }
>  
>
> ...
>
> -extern void __inode_dir_notify(struct inode *, unsigned long);
> +#define ALL_DNOTIFY_EVENTS (FS_DELETE | FS_DELETE_CHILD |\
> +			    FS_MODIFY | FS_MODIFY_CHILD |\
> +			    FS_ACCESS | FS_ACCESS_CHILD |\
> +			    FS_ATTRIB | FS_ATTRIB_CHILD |\
> +			    FS_CREATE | FS_DN_RENAME |\
> +			    FS_MOVED_FROM | FS_MOVED_TO)

"DNOTIFY_ALL_EVENTS"?

>  extern void dnotify_flush(struct file *, fl_owner_t);
>  extern int fcntl_dirnotify(int, struct file *, unsigned long);
> -extern void dnotify_parent(struct dentry *, unsigned long);
> -
> -static inline void inode_dir_notify(struct inode *inode, unsigned long event)
> -{
> -	if (inode->i_dnotify_mask & (event))
> -		__inode_dir_notify(inode, event);
> -}
>  
>
> ...
>

