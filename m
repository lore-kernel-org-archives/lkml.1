Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbYIDSpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbYIDSpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758162AbYIDSlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:41:06 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35070 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758161AbYIDSlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:41:04 -0400
Subject: Re: [RFC v3][PATCH 8/9] File descriprtors (dump)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: arnd@arndb.de, jeremy@goop.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0809040405250.5982@takamine.ncl.cs.columbia.edu>
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu>
	 <Pine.LNX.4.64.0809040405250.5982@takamine.ncl.cs.columbia.edu>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 11:41:00 -0700
Message-Id: <1220553660.23386.60.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-04 at 04:05 -0400, Oren Laadan wrote:
> +/**
> + * cr_scan_fds - scan file table and construct array of open fds
> + * @files: files_struct pointer
> + * @fdtable: (output) array of open fds
> + * @return: the number of open fds found
> + *
> + * Allocates the file descriptors array (*fdtable), caller should free
> + */
> +int cr_scan_fds(struct files_struct *files, int **fdtable)
> +{
> +	struct fdtable *fdt;
> +	int *fdlist;
> +	int i, n, max;
> +
> +	max = CR_DEFAULT_FDTABLE;
> +
> + repeat:
> +	n = 0;
> +	fdlist = kmalloc(max * sizeof(*fdlist), GFP_KERNEL);
> +	if (!fdlist)
> +		return -ENOMEM;
> +
> +	spin_lock(&files->file_lock);
> +	fdt = files_fdtable(files);
> +	for (i = 0; i < fdt->max_fds; i++) {
> +		if (fcheck_files(files, i)) {
> +			if (n == max) {
> +				spin_unlock(&files->file_lock);
> +				kfree(fdlist);
> +				max *= 2;
> +				if (max < 0) {	/* overflow ? */
> +					n = -EMFILE;
> +					break;
> +				}
> +				goto repeat;
> +			}
> +			fdlist[n++] = i;
> +		}
> +	}
> +	spin_unlock(&files->file_lock);
> +
> +	*fdtable = fdlist;
> +	return n;
> +}

That loop needs some love.  At least save us from one level of
indenting:

> +	for (i = 0; i < fdt->max_fds; i++) {
> +		if (!fcheck_files(files, i)
> 			continue;
> 		if (n == max) {
> +			spin_unlock(&files->file_lock);
> +			kfree(fdlist);
> +			max *= 2;
> +			if (max < 0) {	/* overflow ? */
> +				n = -EMFILE;
> +				break;
> +			}
> +			goto repeat;
> +		}
> +		fdlist[n++] = i;
> +	}

My gut also says that there has to be a better way to find a good size
for fdlist() than growing it this way.  

Why do we even have a fixed size for this?

+#define CR_DEFAULT_FDTABLE  256

> +/* cr_write_fd_data - dump the state of a given file pointer */
> +static int cr_write_fd_data(struct cr_ctx *ctx, struct file *file, int parent)
> +{
> +	struct cr_hdr h;
> +	struct cr_hdr_fd_data *hh = cr_hbuf_get(ctx, sizeof(*hh));
> +	struct dentry *dent = file->f_dentry;
> +	struct inode *inode = dent->d_inode;
> +	enum fd_type fd_type;
> +	int ret;
> +
> +	h.type = CR_HDR_FD_DATA;
> +	h.len = sizeof(*hh);
> +	h.parent = parent;
> +
> +	BUG_ON(!inode);

Why a BUG_ON()?  We'll deref it in just a sec anyway.  We prefer to just
get the NULL dereference rather than an explicit BUG_ON().

> +	hh->f_flags = file->f_flags;
> +	hh->f_mode = file->f_mode;
> +	hh->f_pos = file->f_pos;
> +	hh->f_uid = file->f_uid;
> +	hh->f_gid = file->f_gid;

Is there a plan to save off the 'struct user' here instead?  Nested user
namespaces in one checkpoint image might get confused otherwise.

> +	hh->f_version = file->f_version;
> +	/* FIX: need also file->f_owner */
> +
> +	switch (inode->i_mode & S_IFMT) {
> +	case S_IFREG:
> +		fd_type = CR_FD_FILE;
> +		break;
> +	case S_IFDIR:
> +		fd_type = CR_FD_DIR;
> +		break;
> +	case S_IFLNK:
> +		fd_type = CR_FD_LINK;
> +		break;
> +	default:
> +		return -EBADF;
> +	}

Why don't we just store (and use) (inode->i_mode & S_IFMT) in fd_type
instead of making our own types?

> +	/* FIX: check if the file/dir/link is unlinked */
> +	hh->fd_type = fd_type;
> +
> +	ret = cr_write_obj(ctx, &h, hh);
> +	cr_hbuf_put(ctx, sizeof(*hh));
> +	if (ret < 0)
> +		return ret;
> +
> +	return cr_write_fname(ctx, &file->f_path, ctx->vfsroot);
> +}
> +
> +/**
> + * cr_write_fd_ent - dump the state of a given file descriptor
> + * @ctx: checkpoint context
> + * @files: files_struct pointer
> + * @fd: file descriptor
> + *
> + * Save the state of the file descriptor; look up the actual file pointer
> + * in the hash table, and if found save the matching objref, otherwise call
> + * cr_write_fd_data to dump the file pointer too.
> + */
> +static int
> +cr_write_fd_ent(struct cr_ctx *ctx, struct files_struct *files, int fd)
> +{
> +	struct cr_hdr h;
> +	struct cr_hdr_fd_ent *hh = cr_hbuf_get(ctx, sizeof(*hh));
> +	struct file *file = NULL;
> +	struct fdtable *fdt;
> +	int coe, objref, ret;
> +
> +	/* make sure hh->fd (that is of type __u16) doesn't overflow */
> +	if (fd > USHORT_MAX) {
> +		pr_warning("CR: open files table too big (%d)\n", USHORT_MAX);
> +		return -EMFILE;
> +	}

Since the kernel always seems to make fds integers, it would make sense
to me to store them as integers in the checkpoint image.  Why bother to
shrink them down to a 16-bit type?

> +	rcu_read_lock();
> +	fdt = files_fdtable(files);
> +	file = fcheck_files(files, fd);
> +	if (file) {
> +		coe = FD_ISSET(fd, fdt->close_on_exec);
> +		get_file(file);
> +	}
> +	rcu_read_unlock();
> +
> +	/* sanity check (although this shouldn't happen) */
> +	if (!file)
> +		return -EBADF;
> +
> +	ret = cr_obj_add_ptr(ctx, (void *) file, &objref, CR_OBJ_FILE, 0);
> +	cr_debug("fd %d objref %d file %p c-o-e %d)\n", fd, objref, file, coe);
> +
> +	if (ret >= 0) {
> +		int new = ret;
> +
> +		h.type = CR_HDR_FD_ENT;
> +		h.len = sizeof(*hh);
> +		h.parent = 0;
> +
> +		hh->objref = objref;
> +		hh->fd = fd;
> +		hh->close_on_exec = coe;
> +
> +		ret = cr_write_obj(ctx, &h, hh);
> +		cr_hbuf_put(ctx, sizeof(*hh));
> +		if (ret < 0)
> +			return ret;
> +
> +		/* new==1 if-and-only-if file was new and added to hash */
> +		if (new)
> +			ret = cr_write_fd_data(ctx, file, objref);
> +	}

This if() block is in the normal flow path of the function and should go
at the top indentation level.  You can just do this:

	  if (ret < 0)
		goto out;
  	  // if block contents here...

   out:
> +	fput(file);
> +	return ret;
> +}
-- Dave

