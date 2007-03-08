Return-Path: <linux-kernel-owner+w=401wt.eu-S1752410AbXCHSQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbXCHSQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 13:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbXCHSQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 13:16:28 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:29212 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbXCHSQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 13:16:27 -0500
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [RFC][Patch 2/6] integrity: fs hook placement
References: <1173369812.5981.2.camel@localhost.localdomain>
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Thu, 08 Mar 2007 21:16:29 +0300
In-Reply-To: <1173369812.5981.2.camel@localhost.localdomain> (Mimi Zohar's message of "Thu, 08 Mar 2007 11:03:32 -0500")
Message-ID: <87ps7jy51e.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> writes:

> This patch places calls to the new integrity hooks in the appropriate
> places in the fs directory. It is not meant in any way to be viewed
> as a complete set, but used as a basis for an initial discussion.
>
> Index: linux-2.6.21-rc3-mm2/fs/ext3/xattr_security.c
> ===================================================================
> --- linux-2.6.21-rc3-mm2.orig/fs/ext3/xattr_security.c
> +++ linux-2.6.21-rc3-mm2/fs/ext3/xattr_security.c
> @@ -10,6 +10,7 @@
>  #include <linux/ext3_jbd.h>
>  #include <linux/ext3_fs.h>
>  #include <linux/security.h>
> +#include <linux/integrity.h>
>  #include "xattr.h"
>  
>  static size_t
> @@ -58,12 +59,19 @@ ext3_init_security(handle_t *handle, str
>  
>  	err = security_inode_init_security(inode, dir, &name, &value, &len);
>  	if (err) {
> +		/* Even if creation of the security xattr fails, must
> +		 * indicate this is a new inode. */
> +		integrity_inode_init_integrity(inode, dir, NULL, NULL, NULL);
>  		if (err == -EOPNOTSUPP)
>  			return 0;
>  		return err;
>  	}
<<<< block begin
>  	err = ext3_xattr_set_handle(handle, inode, EXT3_XATTR_INDEX_SECURITY,
>  				    name, value, len, 0);
> +
> +	integrity_inode_init_integrity(inode, dir, &name, &value, &len);
> +	err = ext3_xattr_set_handle(handle, inode, EXT3_XATTR_INDEX_SECURITY,
> +				    name, value, len, 0);
<<<< block end
May be i've missed something, but i don't get last block.
Why you call ext3_xattr_set_handle() twise?, 
or you just mistyped and  it has to look like this:
<<<<block_begin

+	integrity_inode_init_integrity(inode, dir, &name, &value, &len);
	err = ext3_xattr_set_handle(handle, inode, EXT3_XATTR_INDEX_SECURITY,
				    name, value, len, 0);
<<<block_end
>  	kfree(name);
>  	kfree(value);
>  	return err;
> Index: linux-2.6.21-rc3-mm2/include/linux/fs.h
> ===================================================================
> --- linux-2.6.21-rc3-mm2.orig/include/linux/fs.h
> +++ linux-2.6.21-rc3-mm2/include/linux/fs.h
> @@ -591,6 +591,9 @@ struct inode {
>  #ifdef CONFIG_SECURITY
>  	void			*i_security;
>  #endif
> +#ifdef CONFIG_INTEGRITY
> +	void			*i_integrity;
> +#endif
>  	void			*i_private; /* fs or device private pointer */
>  };
>  
> Index: linux-2.6.21-rc3-mm2/fs/dcache.c
> ===================================================================
> --- linux-2.6.21-rc3-mm2.orig/fs/dcache.c
> +++ linux-2.6.21-rc3-mm2/fs/dcache.c
> @@ -29,6 +29,7 @@
>  #include <linux/file.h>
>  #include <asm/uaccess.h>
>  #include <linux/security.h>
> +#include <linux/integrity.h>
>  #include <linux/seqlock.h>
>  #include <linux/swap.h>
>  #include <linux/bootmem.h>
> @@ -986,6 +987,7 @@ void d_instantiate(struct dentry *entry,
>  	entry->d_inode = inode;
>  	fsnotify_d_instantiate(entry, inode);
>  	spin_unlock(&dcache_lock);
> +	integrity_d_instantiate(entry, inode);
>  	security_d_instantiate(entry, inode);
>  }
>  
> @@ -1050,6 +1052,7 @@ struct dentry *d_instantiate_unique(stru
>  	spin_unlock(&dcache_lock);
>  
>  	if (!result) {
> +		integrity_d_instantiate(entry, inode);
>  		security_d_instantiate(entry, inode);
>  		return NULL;
>  	}
> @@ -1187,6 +1190,7 @@ struct dentry *d_splice_alias(struct ino
>  			BUG_ON(!(new->d_flags & DCACHE_DISCONNECTED));
>  			fsnotify_d_instantiate(new, inode);
>  			spin_unlock(&dcache_lock);
> +			integrity_d_instantiate(new, inode);
>  			security_d_instantiate(new, inode);
>  			d_rehash(dentry);
>  			d_move(new, dentry);
> @@ -1197,6 +1201,7 @@ struct dentry *d_splice_alias(struct ino
>  			dentry->d_inode = inode;
>  			fsnotify_d_instantiate(dentry, inode);
>  			spin_unlock(&dcache_lock);
> +			integrity_d_instantiate(dentry, inode);
>  			security_d_instantiate(dentry, inode);
>  			d_rehash(dentry);
>  		}
> @@ -1748,6 +1753,7 @@ found:
>  	spin_unlock(&dcache_lock);
>  out_nolock:
>  	if (actual == dentry) {
> +		integrity_d_instantiate(dentry, inode);
>  		security_d_instantiate(dentry, inode);
>  		return NULL;
>  	}
> Index: linux-2.6.21-rc3-mm2/fs/file_table.c
> ===================================================================
> --- linux-2.6.21-rc3-mm2.orig/fs/file_table.c
> +++ linux-2.6.21-rc3-mm2/fs/file_table.c
> @@ -13,6 +13,7 @@
>  #include <linux/smp_lock.h>
>  #include <linux/fs.h>
>  #include <linux/security.h>
> +#include <linux/integrity.h>
>  #include <linux/eventpoll.h>
>  #include <linux/rcupdate.h>
>  #include <linux/mount.h>
> @@ -169,6 +170,7 @@ void fastcall __fput(struct file *file)
>  	if (file->f_op && file->f_op->release)
>  		file->f_op->release(inode, file);
>  	security_file_free(file);
> +	integrity_file_free(file);
>  	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL))
>  		cdev_put(inode->i_cdev);
>  	fops_put(file->f_op);
> @@ -240,6 +242,7 @@ void put_filp(struct file *file)
>  {
>  	if (atomic_dec_and_test(&file->f_count)) {
>  		security_file_free(file);
> +		integrity_file_free(file);
>  		file_kill(file);
>  		file_free(file);
>  	}
> Index: linux-2.6.21-rc3-mm2/fs/inode.c
> ===================================================================
> --- linux-2.6.21-rc3-mm2.orig/fs/inode.c
> +++ linux-2.6.21-rc3-mm2/fs/inode.c
> @@ -17,6 +17,7 @@
>  #include <linux/hash.h>
>  #include <linux/swap.h>
>  #include <linux/security.h>
> +#include <linux/integrity.h>
>  #include <linux/pagemap.h>
>  #include <linux/cdev.h>
>  #include <linux/bootmem.h>
> @@ -142,6 +143,14 @@ static struct inode *alloc_inode(struct 
>  			return NULL;
>  		}
>  
> +		if (integrity_inode_alloc(inode)) {
> +			if (inode->i_sb->s_op->destroy_inode)
> +				inode->i_sb->s_op->destroy_inode(inode);
> +			else
> +				kmem_cache_free(inode_cachep, (inode));
> +			return NULL;
> +		}
> +
>  		mapping->a_ops = &empty_aops;
>   		mapping->host = inode;
>  		mapping->flags = 0;
> @@ -172,6 +181,7 @@ void destroy_inode(struct inode *inode) 
>  {
>  	BUG_ON(inode_has_buffers(inode));
>  	security_inode_free(inode);
> +	integrity_inode_free(inode);
>  	if (inode->i_sb->s_op->destroy_inode)
>  		inode->i_sb->s_op->destroy_inode(inode);
>  	else
> Index: linux-2.6.21-rc3-mm2/fs/xattr.c
> ===================================================================
> --- linux-2.6.21-rc3-mm2.orig/fs/xattr.c
> +++ linux-2.6.21-rc3-mm2/fs/xattr.c
> @@ -14,6 +14,7 @@
>  #include <linux/xattr.h>
>  #include <linux/namei.h>
>  #include <linux/security.h>
> +#include <linux/integrity.h>
>  #include <linux/syscalls.h>
>  #include <linux/module.h>
>  #include <linux/fsnotify.h>
> @@ -84,11 +85,17 @@ vfs_setxattr(struct dentry *dentry, char
>  	error = security_inode_setxattr(dentry, name, value, size, flags);
>  	if (error)
>  		goto out;
> +
> +	error = integrity_inode_setxattr(dentry, name, value, size, flags);
> +	if (error)
> +		goto out;
> +
>  	error = -EOPNOTSUPP;
>  	if (inode->i_op->setxattr) {
>  		error = inode->i_op->setxattr(dentry, name, value, size, flags);
>  		if (!error) {
>  			fsnotify_xattr(dentry);
> +			integrity_inode_post_setxattr(dentry, name);
>  			security_inode_post_setxattr(dentry, name, value,
>  						     size, flags);
>  		}
> @@ -181,6 +188,8 @@ vfs_removexattr(struct dentry *dentry, c
>  
>  	mutex_lock(&inode->i_mutex);
>  	error = inode->i_op->removexattr(dentry, name);
> +	if (!error)
> +		integrity_inode_post_setxattr(dentry, name);
>  	mutex_unlock(&inode->i_mutex);
>  
>  	if (!error)
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

