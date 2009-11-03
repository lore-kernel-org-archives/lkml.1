Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbZKCB66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbZKCB66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 20:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756690AbZKCB66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 20:58:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756601AbZKCB65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 20:58:57 -0500
Date: Mon, 2 Nov 2009 17:59:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: uninline PDE get
Message-Id: <20091102175900.bbe61f31.akpm@linux-foundation.org>
In-Reply-To: <20091029081926.GA9916@x200>
References: <20091029081926.GA9916@x200>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009 11:19:26 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
> Subject: [PATCH] proc: uninline PDE get
>

I really don't like this "PDE" terminology.  Few people know what it
means.  It's better to use the same terms as the kernel uses, eg
proc_dir_entry.


> * PDE get is trivial -- make inline, save a few bits of code,
>   drop "refcount is 0" check -- it should be done in some generic refcount code,
>   don't recall it's was helpful
> * rename GET and PUT functions to pde_get(), pde_put() for cool prefix!
> * remove obvious and incorrent comments
> * in remove_proc_entry() use pde_put(),
>   when I fixed PDE refcounting to be normal one, remove_proc_entry() was
>   supposed to do "-1" and code now reflects that.
> 

I deduce that the title should have been "inline", not "uninline".

I'll rewrite it to

	proc: rename de_get() to pde_get() and inline it

> ---
> 
>  fs/proc/generic.c  |   21 +++++++++++++--------
>  fs/proc/inode.c    |   31 ++++---------------------------
>  fs/proc/internal.h |   10 ++++++----
>  3 files changed, 23 insertions(+), 39 deletions(-)
> 
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -429,7 +429,7 @@ struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *dir,
>  			unsigned int ino;
>  
>  			ino = de->low_ino;
> -			de_get(de);
> +			pde_get(de);
>  			spin_unlock(&proc_subdir_lock);
>  			error = -EINVAL;
>  			inode = proc_get_inode(dir->i_sb, ino, de);
> @@ -445,7 +445,7 @@ out_unlock:
>  		return NULL;
>  	}
>  	if (de)
> -		de_put(de);
> +		pde_put(de);
>  	return ERR_PTR(error);
>  }
>  
> @@ -509,17 +509,17 @@ int proc_readdir_de(struct proc_dir_entry *de, struct file *filp, void *dirent,
>  				struct proc_dir_entry *next;
>  
>  				/* filldir passes info to user space */
> -				de_get(de);
> +				pde_get(de);
>  				spin_unlock(&proc_subdir_lock);
>  				if (filldir(dirent, de->name, de->namelen, filp->f_pos,
>  					    de->low_ino, de->mode >> 12) < 0) {
> -					de_put(de);
> +					pde_put(de);
>  					goto out;
>  				}
>  				spin_lock(&proc_subdir_lock);
>  				filp->f_pos++;
>  				next = de->next;
> -				de_put(de);
> +				pde_put(de);
>  				de = next;
>  			} while (de);
>  			spin_unlock(&proc_subdir_lock);
> @@ -763,7 +763,7 @@ out:
>  	return NULL;
>  }
>  
> -void free_proc_entry(struct proc_dir_entry *de)
> +static void free_proc_entry(struct proc_dir_entry *de)
>  {
>  	unsigned int ino = de->low_ino;
>  
> @@ -777,6 +777,12 @@ void free_proc_entry(struct proc_dir_entry *de)
>  	kfree(de);
>  }
>  
> +void pde_put(struct proc_dir_entry *pde)
> +{
> +	if (atomic_dec_and_test(&pde->count))
> +		free_proc_entry(pde);
> +}
> +
>  /*
>   * Remove a /proc entry and free it if it's not currently in use.
>   */
> @@ -845,6 +851,5 @@ continue_removing:
>  	WARN(de->subdir, KERN_WARNING "%s: removing non-empty directory "
>  			"'%s/%s', leaking at least '%s'\n", __func__,
>  			de->parent->name, de->name, de->subdir->name);
> -	if (atomic_dec_and_test(&de->count))
> -		free_proc_entry(de);
> +	pde_put(de);
>  }
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -24,29 +24,6 @@
>  
>  #include "internal.h"
>  
> -struct proc_dir_entry *de_get(struct proc_dir_entry *de)
> -{
> -	atomic_inc(&de->count);
> -	return de;
> -}
> -
> -/*
> - * Decrements the use count and checks for deferred deletion.
> - */
> -void de_put(struct proc_dir_entry *de)
> -{
> -	if (!atomic_read(&de->count)) {
> -		printk("de_put: entry %s already free!\n", de->name);
> -		return;
> -	}
> -
> -	if (atomic_dec_and_test(&de->count))
> -		free_proc_entry(de);
> -}
> -
> -/*
> - * Decrement the use count of the proc_dir_entry.
> - */
>  static void proc_delete_inode(struct inode *inode)
>  {
>  	struct proc_dir_entry *de;
> @@ -59,7 +36,7 @@ static void proc_delete_inode(struct inode *inode)
>  	/* Let go of any associated proc directory entry */
>  	de = PROC_I(inode)->pde;
>  	if (de)
> -		de_put(de);
> +		pde_put(de);
>  	if (PROC_I(inode)->sysctl)
>  		sysctl_head_put(PROC_I(inode)->sysctl);
>  	clear_inode(inode);
> @@ -480,7 +457,7 @@ struct inode *proc_get_inode(struct super_block *sb, unsigned int ino,
>  		}
>  		unlock_new_inode(inode);
>  	} else
> -	       de_put(de);
> +	       pde_put(de);
>  	return inode;
>  }			
>  
> @@ -495,7 +472,7 @@ int proc_fill_super(struct super_block *s)
>  	s->s_op = &proc_sops;
>  	s->s_time_gran = 1;
>  	
> -	de_get(&proc_root);
> +	pde_get(&proc_root);
>  	root_inode = proc_get_inode(s, PROC_ROOT_INO, &proc_root);
>  	if (!root_inode)
>  		goto out_no_root;
> @@ -509,6 +486,6 @@ int proc_fill_super(struct super_block *s)
>  out_no_root:
>  	printk("proc_read_super: get root inode failed\n");
>  	iput(root_inode);
> -	de_put(&proc_root);
> +	pde_put(&proc_root);
>  	return -ENOMEM;
>  }
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -61,8 +61,6 @@ extern const struct file_operations proc_pagemap_operations;
>  extern const struct file_operations proc_net_operations;
>  extern const struct inode_operations proc_net_inode_operations;
>  
> -void free_proc_entry(struct proc_dir_entry *de);
> -
>  void proc_init_inodecache(void);
>  
>  static inline struct pid *proc_pid(struct inode *inode)
> @@ -101,8 +99,12 @@ unsigned long task_vsize(struct mm_struct *);
>  int task_statm(struct mm_struct *, int *, int *, int *, int *);
>  void task_mem(struct seq_file *, struct mm_struct *);
>  
> -struct proc_dir_entry *de_get(struct proc_dir_entry *de);
> -void de_put(struct proc_dir_entry *de);
> +static inline struct proc_dir_entry *pde_get(struct proc_dir_entry *pde)
> +{
> +	atomic_inc(&pde->count);
> +	return pde;
> +}
> +void pde_put(struct proc_dir_entry *pde);
>  
>  extern struct vfsmount *proc_mnt;
>  int proc_fill_super(struct super_block *);
