Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbYIGEzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbYIGEzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 00:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYIGEzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 00:55:36 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:56576 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbYIGEzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 00:55:35 -0400
Message-ID: <48C35DFC.9080903@cs.columbia.edu>
Date: Sun, 07 Sep 2008 00:52:12 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: arnd@arndb.de, jeremy@goop.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [RFC v3][PATCH 8/9] File descriprtors (dump)
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu>	 <Pine.LNX.4.64.0809040405250.5982@takamine.ncl.cs.columbia.edu> <1220553660.23386.60.camel@nimitz>
In-Reply-To: <1220553660.23386.60.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dave Hansen wrote:
> On Thu, 2008-09-04 at 04:05 -0400, Oren Laadan wrote:
>> +/**
>> + * cr_scan_fds - scan file table and construct array of open fds
>> + * @files: files_struct pointer
>> + * @fdtable: (output) array of open fds
>> + * @return: the number of open fds found
>> + *
>> + * Allocates the file descriptors array (*fdtable), caller should free
>> + */
>> +int cr_scan_fds(struct files_struct *files, int **fdtable)
>> +{
>> +	struct fdtable *fdt;
>> +	int *fdlist;
>> +	int i, n, max;
>> +
>> +	max = CR_DEFAULT_FDTABLE;
>> +
>> + repeat:
>> +	n = 0;
>> +	fdlist = kmalloc(max * sizeof(*fdlist), GFP_KERNEL);
>> +	if (!fdlist)
>> +		return -ENOMEM;
>> +
>> +	spin_lock(&files->file_lock);
>> +	fdt = files_fdtable(files);
>> +	for (i = 0; i < fdt->max_fds; i++) {
>> +		if (fcheck_files(files, i)) {
>> +			if (n == max) {
>> +				spin_unlock(&files->file_lock);
>> +				kfree(fdlist);
>> +				max *= 2;
>> +				if (max < 0) {	/* overflow ? */
>> +					n = -EMFILE;
>> +					break;
>> +				}
>> +				goto repeat;
>> +			}
>> +			fdlist[n++] = i;
>> +		}
>> +	}
>> +	spin_unlock(&files->file_lock);
>> +
>> +	*fdtable = fdlist;
>> +	return n;
>> +}
> 
> That loop needs some love.  At least save us from one level of
> indenting:
> 
>> +	for (i = 0; i < fdt->max_fds; i++) {
>> +		if (!fcheck_files(files, i)
>> 			continue;
>> 		if (n == max) {
>> +			spin_unlock(&files->file_lock);
>> +			kfree(fdlist);
>> +			max *= 2;
>> +			if (max < 0) {	/* overflow ? */
>> +				n = -EMFILE;
>> +				break;
>> +			}
>> +			goto repeat;
>> +		}
>> +		fdlist[n++] = i;
>> +	}
> 
> My gut also says that there has to be a better way to find a good size
> for fdlist() than growing it this way.  

Can you suggest a better way to find the open files of a task ?

Either I loop twice (loop to count, then allocate, then loop to fill),
or optimistically try an initial guess and expand on demand.

> 
> Why do we even have a fixed size for this?
> 
> +#define CR_DEFAULT_FDTABLE  256
> 
>> +/* cr_write_fd_data - dump the state of a given file pointer */
>> +static int cr_write_fd_data(struct cr_ctx *ctx, struct file *file, int parent)
>> +{
>> +	struct cr_hdr h;
>> +	struct cr_hdr_fd_data *hh = cr_hbuf_get(ctx, sizeof(*hh));
>> +	struct dentry *dent = file->f_dentry;
>> +	struct inode *inode = dent->d_inode;
>> +	enum fd_type fd_type;
>> +	int ret;
>> +
>> +	h.type = CR_HDR_FD_DATA;
>> +	h.len = sizeof(*hh);
>> +	h.parent = parent;
>> +
>> +	BUG_ON(!inode);
> 
> Why a BUG_ON()?  We'll deref it in just a sec anyway.  We prefer to just
> get the NULL dereference rather than an explicit BUG_ON().
> 
>> +	hh->f_flags = file->f_flags;
>> +	hh->f_mode = file->f_mode;
>> +	hh->f_pos = file->f_pos;
>> +	hh->f_uid = file->f_uid;
>> +	hh->f_gid = file->f_gid;
> 
> Is there a plan to save off the 'struct user' here instead?  Nested user
> namespaces in one checkpoint image might get confused otherwise.

Of course. Eventually, 'struct user' will be another shared object that
is encountered and saved with the checkpoint image.

> 
>> +	hh->f_version = file->f_version;
>> +	/* FIX: need also file->f_owner */
>> +
>> +	switch (inode->i_mode & S_IFMT) {
>> +	case S_IFREG:
>> +		fd_type = CR_FD_FILE;
>> +		break;
>> +	case S_IFDIR:
>> +		fd_type = CR_FD_DIR;
>> +		break;
>> +	case S_IFLNK:
>> +		fd_type = CR_FD_LINK;
>> +		break;
>> +	default:
>> +		return -EBADF;
>> +	}
> 
> Why don't we just store (and use) (inode->i_mode & S_IFMT) in fd_type
> instead of making our own types?

There will be others that cannot be inferred from inode->i_mode,
e.g. CR_FD_FILE_UNLINKED, CR_FD_DIR_UNLINKED, CR_FD_SOCK_UNIX,
CR_FD_SOCK_INET_V4, CR_FD_EVENTPOLL etc.

> 
>> +	/* FIX: check if the file/dir/link is unlinked */
>> +	hh->fd_type = fd_type;

[...]

Oren.

