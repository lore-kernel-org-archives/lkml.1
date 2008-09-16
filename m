Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbYIPQze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbYIPQze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 12:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbYIPQz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 12:55:26 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39190 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbYIPQzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 12:55:25 -0400
Subject: Re: [RFC v5][PATCH 8/8] Dump open file descriptors
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <1221347167-9956-9-git-send-email-orenl@cs.columbia.edu>
References: <1221347167-9956-1-git-send-email-orenl@cs.columbia.edu>
	 <1221347167-9956-9-git-send-email-orenl@cs.columbia.edu>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 09:55:13 -0700
Message-Id: <1221584113.20360.16.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-13 at 19:06 -0400, Oren Laadan wrote:
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
> +	hh->f_flags = file->f_flags;
> +	hh->f_mode = file->f_mode;
> +	hh->f_pos = file->f_pos;
> +	hh->f_version = file->f_version;
> +	/* FIX: need also file->uid, file->gid, file->f_owner, etc */
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
> +
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

One of the big things I'm looking for in these file patches is to make
sure that we can expand some day to lots of mounts and lots of
filesystem namespaces.

This tells me that we probably need a per-process vfsroot (which is also
a shared object).  We probably need to make a note in the task structure
as well as here.  

-- Dave

