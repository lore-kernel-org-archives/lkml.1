Return-Path: <linux-kernel-owner+w=401wt.eu-S2992474AbXCPBe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992474AbXCPBe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 21:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992475AbXCPBe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 21:34:57 -0400
Received: from smtp.osdl.org ([65.172.181.24]:48444 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992474AbXCPBe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 21:34:56 -0400
Date: Thu, 15 Mar 2007 17:34:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/5] revoke: core code
Message-Id: <20070315173438.efadd514.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703111330100.765@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703111330100.765@sbz-30.cs.Helsinki.FI>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Mar 2007 13:30:49 +0200 (EET) Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> The revokeat(2) and frevoke(2) system calls invalidate open file
> descriptors and shared mappings of an inode. After an successful
> revocation, operations on file descriptors fail with the EBADF or
> ENXIO error code for regular and device files,
> respectively. Attempting to read from or write to a revoked mapping
> causes SIGBUS.
> 
> The actual operation is done in two passes:
> 
>  1. Revoke all file descriptors that point to the given inode. We do
>     this under tasklist_lock so that after this pass, we don't need
>     to worry about racing with close(2) or dup(2).
>    
>  2. Take down shared memory mappings of the inode and close all file
>     pointers.
> 
> The file descriptors and memory mapping ranges are preserved until the
> owning task does close(2) and munmap(2), respectively.
> 
> ...
>
> +asmlinkage int sys_revokeat(int dfd, const char __user *filename);
> +asmlinkage int sys_frevoke(unsigned int fd);

noooo.... all system calls must return long.

> +static int revoke_vma(struct vm_area_struct *vma, struct zap_details *details)
> +{
> +	unsigned long restart_addr, start_addr, end_addr;
> +	int need_break;
> +
> +	start_addr = vma->vm_start;
> +	end_addr = vma->vm_end;
> +
> +	/*
> + 	 * Not holding ->mmap_sem here.
> +	 */
> +	vma->vm_flags |= VM_REVOKED;

so....  the modification of vm_flags is racy?

> +	smp_mb();

Please always document barriers.  There's presumably some vm_flags reader
we're concerned about here, but how is the code reader to know what the
code writer was thinking?


> +  again:
> +	restart_addr = zap_page_range(vma, start_addr, end_addr - start_addr,
> +				      details);
> +
> +	need_break = need_resched() || need_lockbreak(details->i_mmap_lock);
> +	if (need_break)
> +		goto out_need_break;
> +
> +	if (restart_addr < end_addr) {
> +		start_addr = restart_addr;
> +		goto again;
> +	}
> +	return 0;
> +
> +  out_need_break:
> +	spin_unlock(details->i_mmap_lock);
> +	cond_resched();
> +	spin_lock(details->i_mmap_lock);
> +	return -EINTR;
> +}
> +
> +static int revoke_mapping(struct address_space *mapping, struct file *to_exclude)
> +{
> +	struct vm_area_struct *vma;
> +	struct prio_tree_iter iter;
> +	struct zap_details details;
> +	int err = 0;
> +
> +	details.i_mmap_lock = &mapping->i_mmap_lock;
> +
> +	spin_lock(&mapping->i_mmap_lock);
> +	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, ULONG_MAX) {
> +		if ((vma->vm_flags & VM_SHARED) && vma->vm_file != to_exclude) {
> +			err = revoke_vma(vma, &details);
> +			if (err)
> +				goto out;
> +		}
> +	}
> +
> +	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list) {
> +		if ((vma->vm_flags & VM_SHARED) && vma->vm_file != to_exclude) {
> +			err = revoke_vma(vma, &details);
> +			if (err)
> +				goto out;
> +		}
> +	}
> +  out:
> +	spin_unlock(&mapping->i_mmap_lock);
> +	return err;
> +}

This all looks very strange.  If the calling process expires its timeslice,
the entire system call fails?

What's happening here?


> +
> +int generic_file_revoke(struct file *file)
> +{
> +	int err;
> +
> +	/*
> +	 * Flush pending writes.
> +	 */
> +	err = do_fsync(file, 1);
> +	if (err)
> +		goto out;
> +
> +	/*
> +	 * Make pending reads fail.
> +	 */
> +	err = invalidate_inode_pages2(file->f_mapping);
> +
> +  out:
> +	return err;
> +}
> +
> +EXPORT_SYMBOL(generic_file_revoke);

do_fsync() is seriously suboptimal - it will run an ext3 commit. 
do_sync_file_range(...,
SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE|SYNC_FILE_RANGE_WAIT_AFTER)
will run maybe five times quicker.

But otoh, do_sync_file_range() will fail to write back the pages for a
data=journal ext3 file, I expect (oops).


Why is this code using invalidate_inode_pages2()?  That function keeps on
breaking, has ill-defined semantics and will probably change in the future.

Exactly what semantics are you looking for here, and why?

The blank line before the EXPORT_SYMBOL() is a waste of space.

> +/*
> + *	Filesystem for revoked files.
> + */
> +
> +static struct inode *revokefs_alloc_inode(struct super_block *sb)
> +{
> +	struct revokefs_inode_info *info;
> +
> +	info = kmem_cache_alloc(revokefs_inode_cache, GFP_NOFS);
> +	if (!info)
> +		return NULL;
> +
> +	return &info->vfs_inode;
> +}

Why GFP_NOFS?

> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ uml-2.6/include/linux/revoked_fs_i.h	2007-03-11 13:09:20.000000000 +0200
> @@ -0,0 +1,20 @@
> +#ifndef _LINUX_REVOKED_FS_I_H
> +#define _LINUX_REVOKED_FS_I_H
> +
> +#define REVOKEFS_MAGIC 0x5245564B      /* REVK */

This is supposed to go into magic.h.


