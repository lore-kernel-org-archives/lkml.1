Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbZCEReC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbZCEReC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 12:34:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbZCERdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 12:33:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:19542 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbZCERdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 12:33:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dm1zp4ETVHQZlG6S1h8fDHK53P+4kZiDY/+PQBtA7gTracg0Xi5MWJSIPlDoUFNDNy
         i6Yh9M1seUge5M8ehXlW4OP9S6j98KmYRD7IJzhikW2+s9OVrC2/ky6dUuVvcl8FqFC/
         Uwap5Qo58Y4bNiZvkgOXCcqa/7kQ9Ts2kyDIc=
Date: Thu, 5 Mar 2009 20:40:37 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
Message-ID: <20090305174037.GA2274@x200.localdomain>
References: <20090305163857.0C18F3FD@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305163857.0C18F3FD@kernel>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 08:38:57AM -0800, Dave Hansen wrote:
> This takes a suggestion of Ingo's along with comments from lots of
> other people.  It can track whether a given file is able to be
> checkpointed.  It introduces a f_op to allow easy customization
> like the reset of the VFS.

Here is how alternative looks like
* without touching VFS at all
* without adding default handlers
* without duplicate code every ->checkpoint hook will have
* without largely useless "special file" messages
  (what's so special about it?)
* without adding userspace-visible /proc/*/checkpointable 
* without recalculating "checkpointable" property on fs_struct
  on every C/R=y kernel.

* with "ban by default" policy as well
* with error message immediatly understandable by developer:

	cr_check_file: can't checkpoint file f61a0f40, ->f_op = socket_file_ops+0x0/0x1c0

It may lack some printk, but printks are trivial to insert including
using d_path for precise info.



static int cr_check_file(struct file *file)
{
	struct inode *inode = file->f_path.dentry->d_inode;
	unsigned int major, minor;

	if (d_unhashed(file->f_path.dentry))
		return -EINVAL;
#ifdef CONFIG_SECURITY
	if (file->f_security)
		return -EINVAL;
#endif
#ifdef CONFIG_EPOLL
	spin_lock(&file->f_ep_lock);
	if (!list_empty(&file->f_ep_links)) {
		spin_unlock(&file->f_ep_lock);
		return -EINVAL;
	}
	spin_unlock(&file->f_ep_lock);
#endif

	switch (inode->i_mode & S_IFMT) {
	case S_IFREG:
	case S_IFDIR:
		/* Likely on-disk filesystem. */
		/* FIXME: FUSE, NFS, other networking filesystems */
		if (inode->i_sb->s_type->fs_flags & FS_REQUIRES_DEV)
			return 0;
		break;
	case S_IFBLK:
		major = imajor(inode);
		minor = iminor(inode);
		printk("%s: can't checkpoint block device %u:%u, ->f_op = %pS\n", __func__, major, minor, file->f_op);
		return -EINVAL;
	case S_IFCHR:
		major = imajor(inode);
		minor = iminor(inode);
		if (major == UNIX98_PTY_SLAVE_MAJOR)
			return 0;
		printk("%s: can't checkpoint char device %u:%u, ->f_op = %pS\n", __func__, major, minor, file->f_op);
		return -EINVAL;
	case S_IFIFO:
		break;
	case S_IFSOCK:
		return 0;
	case S_IFLNK:
		/* One can't open symlink. */
		BUG();
	}
	printk("%s: can't checkpoint file %p, ->f_op = %pS\n", __func__, file, file->f_op);
	return -EINVAL;
}

static int __cr_collect_file(struct cr_context *ctx, struct file *file)
{
	struct cr_object *obj;

	obj = cr_find_obj_by_ptr(ctx, file, CR_CTX_FILE);
	if (obj) {
		obj->o_count++;
		return 0;
	}

	obj = cr_object_create(file);
	if (!obj)
		return -ENOMEM;
	list_add_tail(&obj->o_list, &ctx->cr_obj[CR_CTX_FILE]);
	printk("collect file %p\n", file);
	return 0;
}

int cr_collect_file(struct cr_context *ctx, struct file *file)
{
	int rv;

	rv = cr_check_file(file);
	if (rv < 0)
		return rv;
	return __cr_collect_file(ctx, file);
}
