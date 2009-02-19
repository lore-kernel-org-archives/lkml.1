Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbZBSAM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbZBSAM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 19:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbZBSAMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 19:12:48 -0500
Received: from kroah.org ([198.145.64.141]:38026 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754399AbZBSAMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 19:12:47 -0500
Date: Wed, 18 Feb 2009 16:00:44 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH] staging/pohmelfs: fix quota build error and printk
	formats
Message-ID: <20090219000044.GB5181@kroah.com>
References: <20090218103932.6a7880f9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218103932.6a7880f9.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy, this patch is already in my tree, can you pull the next
linux-next to verify it?

thanks,

greg k-h

On Wed, Feb 18, 2009 at 10:39:32AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix pohmelfs for disk quota changes and printk format warnings:
> 
> drivers/staging/pohmelfs/inode.c:917: warning: format '%u' expects type 'unsigned int', but argument 4 has type 'size_t'
> drivers/staging/pohmelfs/inode.c:982: error: implicit declaration of function 'DQUOT_TRANSFER'
> drivers/staging/pohmelfs/inode.c:1036: warning: format '%u' expects type 'unsigned int', but argument 7 has type 'size_t'
> 
> drivers/staging/pohmelfs/trans.c:164: warning: format '%u' expects type 'unsigned int', but argument 5 has type '__kernel_size_t'
> drivers/staging/pohmelfs/trans.c:170: warning: format '%u' expects type 'unsigned int', but argument 7 has type '__kernel_size_t'
> drivers/staging/pohmelfs/trans.c:517: warning: format '%u' expects type 'unsigned int', but argument 6 has type '__kernel_size_t'
> drivers/staging/pohmelfs/trans.c:600: warning: format '%u' expects type 'unsigned int', but argument 6 has type '__kernel_size_t'
> drivers/staging/pohmelfs/trans.c:610: warning: format '%u' expects type 'unsigned int', but argument 7 has type '__kernel_size_t'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Evgeniy Polyakov <zbr@ioremap.net>
> ---
>  drivers/staging/pohmelfs/inode.c |    6 +++---
>  drivers/staging/pohmelfs/trans.c |   10 +++++-----
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> --- linux-next-20090218.orig/drivers/staging/pohmelfs/inode.c
> +++ linux-next-20090218/drivers/staging/pohmelfs/inode.c
> @@ -914,7 +914,7 @@ ssize_t pohmelfs_write(struct file *file
>  	kiocb.ki_pos = pos;
>  	kiocb.ki_left = len;
>  
> -	dprintk("%s: len: %u, pos: %llu.\n", __func__, len, pos);
> +	dprintk("%s: len: %zu, pos: %llu.\n", __func__, len, pos);
>  
>  	mutex_lock(&inode->i_mutex);
>  	ret = pohmelfs_data_lock(pi, pos, len, POHMELFS_WRITE_LOCK);
> @@ -979,7 +979,7 @@ int pohmelfs_setattr_raw(struct inode *i
>  
>  	if ((attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
>  	    (attr->ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid)) {
> -		err = DQUOT_TRANSFER(inode, attr) ? -EDQUOT : 0;
> +		err = vfs_dq_transfer(inode, attr) ? -EDQUOT : 0;
>  		if (err)
>  			goto err_out_exit;
>  	}
> @@ -1033,7 +1033,7 @@ static int pohmelfs_send_xattr_req(struc
>  	struct netfs_cmd *cmd;
>  	void *data;
>  
> -	dprintk("%s: id: %llu, start: %llu, name: '%s', attrsize: %u, cmd: %d.\n",
> +	dprintk("%s: id: %llu, start: %llu, name: '%s', attrsize: %zu, cmd: %d.\n",
>  			__func__, id, start, name, attrsize, command);
>  
>  	path_len = pohmelfs_path_length(pi);
> --- linux-next-20090218.orig/drivers/staging/pohmelfs/trans.c
> +++ linux-next-20090218/drivers/staging/pohmelfs/trans.c
> @@ -160,14 +160,14 @@ int netfs_trans_send(struct netfs_trans 
>  
>  	err = kernel_sendmsg(st->socket, &msg, (struct kvec *)msg.msg_iov, 1, t->iovec.iov_len);
>  	if (err <= 0) {
> -		printk("%s: failed to send contig transaction: t: %p, gen: %u, size: %u, err: %d.\n",
> +		printk("%s: failed to send contig transaction: t: %p, gen: %u, size: %zu, err: %d.\n",
>  				__func__, t, t->gen, t->iovec.iov_len, err);
>  		if (err == 0)
>  			err = -ECONNRESET;
>  		goto err_out_unlock_return;
>  	}
>  
> -	dprintk("%s: sent %s transaction: t: %p, gen: %u, size: %u, page_num: %u.\n",
> +	dprintk("%s: sent %s transaction: t: %p, gen: %u, size: %zu, page_num: %u.\n",
>  			__func__, (t->page_num)?"partial":"full",
>  			t, t->gen, t->iovec.iov_len, t->page_num);
>  
> @@ -514,7 +514,7 @@ int netfs_trans_finish(struct netfs_tran
>  		cmd->csize = psb->crypto_attached_size;
>  	}
>  
> -	dprintk("%s: t: %u, size: %u, iov_len: %u, attached_size: %u, attached_pages: %u.\n",
> +	dprintk("%s: t: %u, size: %u, iov_len: %zu, attached_size: %u, attached_pages: %u.\n",
>  			__func__, t->gen, cmd->size, t->iovec.iov_len, t->attached_size, t->attached_pages);
>  	err = pohmelfs_trans_crypt(t, psb);
>  	if (err) {
> @@ -597,7 +597,7 @@ void *netfs_trans_add(struct netfs_trans
>  	}
>  
>  	if (io->iov_len + size > t->total_size) {
> -		dprintk("%s: too big size t: %p, gen: %u, iov_len: %u, size: %u, total: %u.\n",
> +		dprintk("%s: too big size t: %p, gen: %u, iov_len: %zu, size: %u, total: %u.\n",
>  				__func__, t, t->gen, io->iov_len, size, t->total_size);
>  		ptr = ERR_PTR(-E2BIG);
>  		goto out;
> @@ -607,7 +607,7 @@ void *netfs_trans_add(struct netfs_trans
>  	io->iov_len += size;
>  
>  out:
> -	dprintk("%s: t: %p, gen: %u, size: %u, total: %u.\n",
> +	dprintk("%s: t: %p, gen: %u, size: %u, total: %zu.\n",
>  		__func__, t, t->gen, size, io->iov_len);
>  	return ptr;
>  }
