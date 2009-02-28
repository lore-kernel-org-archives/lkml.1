Return-Path: <linux-kernel-owner+w=401wt.eu-S1763750AbZB1CSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763750AbZB1CSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761973AbZB1CPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 21:15:09 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:57119 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761949AbZB1CPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 21:15:07 -0500
Date: Fri, 27 Feb 2009 18:14:12 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>, hch@infradead.org
Subject: Re: [RFC][PATCH 5/8] add f_op for checkpointability
Message-ID: <20090228021412.GD19872@us.ibm.com>
References: <20090227203425.F3B51176@kernel> <20090227203431.D1E697CB@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227203431.D1E697CB@kernel>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen [dave@linux.vnet.ibm.com] wrote:
| 
| We have set up sane defaults for how filesystems should
| be checkpointed.  However, as usual in the VFS, there
| are specialized places that will always need an ability
| to override these defaults.
| 
| This adds a new 'file_operations' function for
| checkpointing a file.  I did this under the assumption
| that we should have a dirt-simple way to make something
| (un)checkpointable that fits in with current code.
| 
| As you can see in the /dev/null patch in a second, all
| that we have to do to make something like /dev/null
| supported is add a single "generic" f_op entry.
| 
| Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
| ---
| 
|  linux-2.6.git-dave/checkpoint/ckpt_file.c     |   77 ++++++++++++++++----------
|  linux-2.6.git-dave/include/linux/checkpoint.h |    6 ++
|  linux-2.6.git-dave/include/linux/fs.h         |    4 +
|  3 files changed, 60 insertions(+), 27 deletions(-)
| 
| diff -puN checkpoint/ckpt_file.c~f_op-for-checkpointability checkpoint/ckpt_file.c
| --- linux-2.6.git/checkpoint/ckpt_file.c~f_op-for-checkpointability	2009-02-27 12:07:39.000000000 -0800
| +++ linux-2.6.git-dave/checkpoint/ckpt_file.c	2009-02-27 12:07:39.000000000 -0800
| @@ -104,56 +104,79 @@ int cr_explain_file(struct file *file, c
|  	return 0;
|  }
| 
| -int cr_file_supported(struct file *file)
| +typedef int (do_checkpoint_t)(struct file *, struct cr_ctx *,
| +			      struct cr_hdr_fd *);
| +
| +int generic_file_checkpoint(struct file *file, struct cr_ctx *ctx,
| +			 struct cr_hdr_fd *hh)
| +{
| +	/*
| +	 * A NULL hh means to make a trial run not
| +	 * actually writing data.  Just determine
| +	 * if the file is checkpointable.
| +	 */
| +	if (!hh)
| +		return 0;
| +
| +	hh->f_flags = file->f_flags;
| +	hh->f_mode = file->f_mode;
| +	hh->f_pos = file->f_pos;
| +	hh->f_version = file->f_version;
| +	/* FIX: need also file->uid, file->gid, file->f_owner, etc */
| +
| +	return 0;
| +}
| +
| +do_checkpoint_t *cr_file_get_func(struct file *file)
|  {

Do we really need this helper ? IOW do callers need this function pointer
itself ? Or can we have a more generic helper that callers can use both
check if checkpoint is possible (pass NULL in ctx and hh) and to actually
checkpoint. Something like:

	int cr_file_checkpoint(file, ctx, hh)
	{
		int rc = -1;

		if (!cr_fs_checkpointable(fstype))
			return rc;
		
		if (!cr_file_checkpointable(file))
			return rc;

		if (special_file(file))
			return rc;

		op = file->f_op->checkpoint;
		if (!op)
			op = generic_file_checkpoint;

		return (*op)(file, ctx, hh);
	}



|  	struct inode *inode = file->f_dentry->d_inode;
|  	struct file_system_type *fs_type = inode->i_sb->s_type;
| 
| -	if (fs_is_cr_able(fs_type))
| -		return 0;
| +	if (file->f_op->checkpoint)
| +		return file->f_op->checkpoint;
| +
| +	if (!fs_is_cr_able(fs_type))
| +		return NULL;
| 
|  	if (special_file(inode->i_mode))
| -		return 0;
| +		return NULL;
| 
| -	return 1;
| +	return generic_file_checkpoint;
| +}
| +
| +int cr_file_supported(struct file *file)
| +{
| +	do_checkpoint_t *func = cr_file_get_func(file);
| +
| +	if (func)
| +		return !func(file, NULL, NULL);
| +
| +	return 0;
|  }
| 
|  /* cr_write_fd_data - dump the state of a given file pointer */
|  static int cr_write_fd_data(struct cr_ctx *ctx, struct file *file, int parent)
|  {
| +	do_checkpoint_t *ckpt_func;
|  	struct cr_hdr h;
|  	struct cr_hdr_fd *hh = cr_hbuf_get(ctx, sizeof(*hh));
| -	struct dentry *dent = file->f_dentry;
| -	struct inode *inode = dent->d_inode;
| -	enum fd_type fd_type;
|  	int ret;
| 
|  	h.type = CR_HDR_FD_DATA;
|  	h.len = sizeof(*hh);
|  	h.parent = parent;
| 
| -	hh->f_flags = file->f_flags;
| -	hh->f_mode = file->f_mode;
| -	hh->f_pos = file->f_pos;
| -	hh->f_version = file->f_version;
| -	/* FIX: need also file->uid, file->gid, file->f_owner, etc */
| -
| -	switch (inode->i_mode & S_IFMT) {
| -	case S_IFREG:
| -		fd_type = CR_FD_FILE;
| -		break;
| -	case S_IFDIR:
| -		fd_type = CR_FD_DIR;
| -		break;
| -	default:
| -		cr_hbuf_put(ctx, sizeof(*hh));
| -		return -EBADF;
| -	}
| +	ckpt_func = cr_file_get_func(file);
| +	ret = -EBADF;
| +	if (!ckpt_func)
| +		goto out;
| 
| -	/* FIX: check if the file/dir/link is unlinked */
| -	hh->fd_type = fd_type;
| +	ret = ckpt_func(file, ctx, hh);
| +	if (ret)
| +		goto out;

So we can combine these two steps into just one ?

	ret = -EBADF;
	hh->fd_type = fd_type;
	if (cr_file_checkpoint(file, ctx, hh))
		goto out;

| 
|  	ret = cr_write_obj(ctx, &h, hh);
| +out:
|  	cr_hbuf_put(ctx, sizeof(*hh));
|  	if (ret < 0)
|  		return ret;

Sukadev
