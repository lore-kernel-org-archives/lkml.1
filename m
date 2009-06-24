Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbZFXAQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbZFXAQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 20:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZFXAQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 20:16:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981AbZFXAQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 20:16:24 -0400
Date: Tue, 23 Jun 2009 17:14:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, npiggin@suse.de, tj@kernel.org
Subject: Re: [PATCH 4/4] FUSE: implement direct mmap
Message-Id: <20090623171441.535c6c98.akpm@linux-foundation.org>
In-Reply-To: <1245317073-24000-5-git-send-email-tj@kernel.org>
References: <1245317073-24000-1-git-send-email-tj@kernel.org>
	<1245317073-24000-5-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009 18:24:33 +0900
Tejun Heo <tj@kernel.org> wrote:

> This patch implements direct mmap.  It allows FUSE server to honor
> each mmap request with anonymous mapping.  FUSE server can make
> multiple mmap requests share a single anonymous mapping or separate
> mappings as it sees fit.
> 
> mmap request is handled in two steps.  MMAP first queries the server
> whether it wants to share the mapping with an existing one or create a
> new one, and if so, with which flags.  MMAP_COMMIT notifies the server
> the result of mmap and if successful the fd the server can use to
> access the mmap region.
> 
> Internally, shmem_file is used to back the mmap areas and vma->vm_file
> is overridden from the FUSE file to the shmem_file.
> 
> For details, please read the comment on top of
> fuse_file_direct_mmap().
> 
>
> ...
>
> +static int fuse_mmap_commit_prep(struct fuse_conn *fc, struct fuse_req *req)
> +{
> +	struct fuse_mmap_commit_in *commit_in = (void *)req->in.args[0].value;
> +	struct file *mfile = req->misc.mmap.file;
> +	int fd;
> +
> +	if (!mfile)
> +		return 0;
> +
> +	/* new mmap.file has been created, assign a fd to it */
> +	fd = commit_in->fd = get_unused_fd_flags(O_CLOEXEC);
> +	if (fd < 0)
> +		return 0;

Shouldn't this be `return fd;'?

> +	get_file(mfile);
> +	fd_install(fd, mfile);
> +	return 0;
> +}
> +
>
> ...
>
> +int fuse_file_direct_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct fuse_file *ff = file->private_data;
> +	struct fuse_conn *fc = ff->fc;
> +	struct vm_operations_struct *orig_vm_ops = vma->vm_ops;
> +	struct file *orig_vm_file = vma->vm_file;
> +	unsigned long orig_vm_flags = vma->vm_flags;
> +	struct fuse_mmap *fmmap = NULL;
> +	struct file *mfile = NULL;
> +	struct fuse_req *req;
> +	struct fuse_mmap_in mmap_in;
> +	struct fuse_mmap_out mmap_out;
> +	struct fuse_mmap_commit_in commit_in;
> +	u64 mmap_unique;
> +	int err;
> +
> +	/*
> +	 * First, execute FUSE_MMAP which will query the server
> +	 * whether this mmap request is valid and which fd it wants to
> +	 * use to mmap this request.
> +	 */
> +	req = fuse_get_req(fc);
> +	if (IS_ERR(req)) {
> +		err = PTR_ERR(req);
> +		goto err;
> +	}
> +
> +	memset(&mmap_in, 0, sizeof(mmap_in));
> +	mmap_in.fh = ff->fh;
> +	mmap_in.addr = vma->vm_start;
> +	mmap_in.len = vma->vm_end - vma->vm_start;
> +	mmap_in.prot = ((vma->vm_flags & VM_READ) ? PROT_READ : 0) |
> +		       ((vma->vm_flags & VM_WRITE) ? PROT_WRITE : 0) |
> +		       ((vma->vm_flags & VM_EXEC) ? PROT_EXEC : 0);
> +	mmap_in.flags = ((vma->vm_flags & VM_GROWSDOWN) ? MAP_GROWSDOWN : 0) |
> +			((vma->vm_flags & VM_DENYWRITE) ? MAP_DENYWRITE : 0) |
> +			((vma->vm_flags & VM_EXECUTABLE) ? MAP_EXECUTABLE : 0) |
> +			((vma->vm_flags & VM_LOCKED) ? MAP_LOCKED : 0);
> +	mmap_in.offset = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
> +
> +	req->in.h.opcode = FUSE_MMAP;
> +	req->in.h.nodeid = ff->nodeid;
> +	req->in.numargs = 1;
> +	req->in.args[0].size = sizeof(mmap_in);
> +	req->in.args[0].value = &mmap_in;
> +	req->out.numargs = 1;
> +	req->out.args[0].size = sizeof(mmap_out);
> +	req->out.args[0].value = &mmap_out;
> +
> +	req->end = fuse_mmap_end;
> +
> +	fuse_request_send(fc, req);
> +
> +	/* mmap.file is set if server requested to reuse existing mapping */
> +	mfile = req->misc.mmap.file;
> +	mmap_unique = req->in.h.unique;
> +	err = req->out.h.error;
> +
> +	fuse_put_request(fc, req);
> +
> +	/* ERR_PTR value in mfile means fget failure, send failure COMMIT */
> +	if (IS_ERR(mfile)) {
> +		err = PTR_ERR(mfile);
> +		goto commit;
> +	}
> +	/* userland indicated failure, we can just fail */
> +	if (err)
> +		goto err;
> +
> +	/*
> +	 * Second, create mmap as the server requested.
> +	 */
> +	fmmap = create_fuse_mmap(fc, file, mfile, mmap_unique, mmap_out.fd,
> +				 vma);
> +	if (IS_ERR(fmmap)) {
> +		err = PTR_ERR(fmmap);
> +		goto commit;
> +	}
> +
> +	/* fmmap points to shm_file to mmap, give it to vma */
> +	mfile = fmmap->mmap_file;
> +	vma->vm_file = mfile;
> +
> +	/* add flags server requested and mmap the shm_file */
> +	if (mmap_out.flags & FUSE_MMAP_DONT_COPY)
> +		vma->vm_flags |= VM_DONTCOPY;
> +	if (mmap_out.flags & FUSE_MMAP_DONT_EXPAND)
> +		vma->vm_flags |= VM_DONTEXPAND;
> +
> +	err = mfile->f_op->mmap(mfile, vma);
> +	if (err)
> +		goto commit;
> +
> +	/*
> +	 * Override vm_ops->open and ->close.  This is a bit hacky but
> +	 * vma's can't easily be nested and FUSE needs to notify the
> +	 * server when to release resources for mmaps.  Both shmem and
> +	 * tiny_shmem implementations are okay with this trick but if
> +	 * there's a cleaner way to do this, please update it.
> +	 */
> +	err = -EINVAL;
> +	if (vma->vm_ops->open || vma->vm_ops->close || vma->vm_private_data) {
> +		printk(KERN_ERR "FUSE: can't do direct mmap. shmem mmap has "
> +		       "open, close or vm_private_data\n");
> +		goto commit;
> +	}
> +
> +	fmmap->vm_ops = *vma->vm_ops;
> +	vma->vm_ops = &fmmap->vm_ops;
> +	vma->vm_ops->open = fuse_vm_open;
> +	vma->vm_ops->close = fuse_vm_close;
> +	vma->vm_private_data = fmmap;
> +	err = 0;

Yes, the vm_operations save/overwrite/restore is the stinky part here.

I'm not completely clear what's going on here, and why, and what the
overall implications and risks are.  Some discussion in the changelog
would help.  With all that information we then would be better situated
to discuss and perhaps solve <whatever problem this solves> by more
pleasing means.

I mean, if the need for this hack indicates that there is some
shortcoming in core VM then perhaps we can improve core VM.  Dunno.

> + commit:
> +	/*
> +	 * Third, either mmap succeeded or failed after MMAP request
> +	 * succeeded.  Notify userland what happened.
> +	 */
> +
> +	/* missing commit can cause resource leak on server side, don't fail */
> +	req = fuse_get_req_nofail(fc, file);

That's an optimistically-named function.

<looks>

hm, it seems to duplicate mempool.c.

> +	memset(&commit_in, 0, sizeof(commit_in));
> +	commit_in.fh = ff->fh;
> +	commit_in.mmap_unique = mmap_unique;
> +	commit_in.addr = mmap_in.addr;
> +	commit_in.len = mmap_in.len;
> +	commit_in.prot = mmap_in.prot;
> +	commit_in.flags = mmap_in.flags;
> +	commit_in.offset = mmap_in.offset;
> +
> +	if (!err) {
> +		commit_in.fd = fmmap->mmap_fd;
> +		/*
> +		 * If fmmap->mmap_fd < 0, new fd needs to be created
> +		 * when the server reads MMAP_COMMIT.  Pass the file
> +		 * pointer.  A fd will be assigned to it by the
> +		 * fuse_mmap_commit_prep callback.
> +		 */
> +		if (fmmap->mmap_fd < 0)
> +			req->misc.mmap.file = mfile;
> +	} else
> +		commit_in.fd = err;
> +
> +	req->in.h.opcode = FUSE_MMAP_COMMIT;
> +	req->in.h.nodeid = ff->nodeid;
> +	req->in.numargs = 1;
> +	req->in.args[0].size = sizeof(commit_in);
> +	req->in.args[0].value = &commit_in;
> +
> +	req->prep = fuse_mmap_commit_prep;
> +	req->end = fuse_mmap_commit_end;
> +
> +	fuse_request_send(fc, req);
> +	if (!err)			/* notified failure to userland */
> +		err = req->out.h.error;
> +	if (!err && commit_in.fd < 0)	/* failed to allocate fd */
> +		err = commit_in.fd;
> +	fuse_put_request(fc, req);
> +
> +	if (!err) {
> +		fput(orig_vm_file);
> +		fmmap->mmap_fd = commit_in.fd;
> +		return 0;
> +	}
> +
> +	/* fall through */
> + err:
> +	if (fmmap && !IS_ERR(fmmap))
> +		destroy_fuse_mmap(fmmap);
> +	if (mfile && !IS_ERR(mfile))
> +		fput(mfile);
> +
> +	/* restore original vm_ops, file and flags */
> +	vma->vm_ops = orig_vm_ops;
> +	vma->vm_file = orig_vm_file;
> +	vma->vm_flags = orig_vm_flags;
> +
> +	if (err == -ENOSYS) {
> +		/* Can't provide the coherency needed for MAP_SHARED */
> +		if (vma->vm_flags & VM_MAYSHARE)
> +			return -ENODEV;
> +
> +		invalidate_inode_pages2(file->f_mapping);
> +
> +		return generic_file_mmap(file, vma);

Now what's happening on this path?

We seem to have decided to fallback to a standard mmap of some form? 
Why?  If the user's request failed, shouldn't we just fail the syscall?
Hasn't the kernel just lied to userspace about what happened?

Also, this code looks like it's duplicating the behaviour of core MM? 
If so then it needs to be kept in sync as core MM changes - that's a
maintenance problem.  Can it be improved by changing core MM?

> +	}
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(fuse_file_direct_mmap);
>
> ...
>
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -272,6 +272,13 @@ struct fuse_req {
>  			struct fuse_write_out out;
>  		} write;
>  		struct fuse_lk_in lk_in;
> +		struct {
> +			/** to move filp for mmap between client and server */

Comment pretends to be kerneldoc?

> +			struct file *file;
> +		} mmap;
> +		struct {
> +			struct fuse_munmap_in in;
> +		} munmap;
>  	} misc;
>  
>
> ...
>
> --- a/include/linux/fuse.h
> +++ b/include/linux/fuse.h
> @@ -178,6 +178,15 @@ struct fuse_file_lock {
>   */
>  #define FUSE_POLL_SCHEDULE_NOTIFY (1 << 0)
>  
> +/**

kerneldoc?  Does this work?

> + * Mmap flags
> + *
> + * FUSE_MMAP_DONT_COPY: don't copy the region on fork
> + * FUSE_MMAP_DONT_EXPAND: can't be expanded with mremap()
> + */
> +#define FUSE_MMAP_DONT_COPY	(1 << 0)
> +#define FUSE_MMAP_DONT_EXPAND	(1 << 1)
> +
>
> ...
>

