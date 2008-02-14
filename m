Return-Path: <linux-kernel-owner+w=401wt.eu-S1762910AbYBNGCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762910AbYBNGCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 01:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbYBNGCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 01:02:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55424 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbYBNGCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 01:02:10 -0500
Date: Thu, 14 Feb 2008 01:02:01 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Paul Menage <menage@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add MS_BIND_FLAGS mount flag
Message-ID: <20080214060201.GA17680@infradead.org>
References: <47B283EB.8070209@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B283EB.8070209@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 09:45:15PM -0800, Paul Menage wrote:
> From: Paul Menage <menage@google.com>
>
> Add a new mount() flag, MS_BIND_FLAGS.
>
> MS_BIND_FLAGS indicates that a bind mount should take its per-mount flags
> from the arguments passed to mount() rather than from the source
> mountpoint.
>
> This flag allows you to create a bind mount with the desired per-mount
> flags in a single operation, rather than having to do a bind mount
> followed by a remount, which is fiddly and can block for non-trivial
> periods of time (on sb->s_umount?).
>
> For recursive bind mounts, only the root of the tree being bound
> inherits the per-mount flags from the mount() arguments; sub-mounts
> inherit their per-mount flags from the source tree as usual.

I think this concept is reasonable, but I don't think MS_BIND_FLAGS
is a descriptive name for this flag.  MS_EXPLICIT_FLAGS might be better
but still isn't optimal.

> +static struct vfsmount *
> +__copy_tree(struct vfsmount *mnt, struct dentry *dentry,
> +	    int flag, int mnt_flags)

> +struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
> +			   int flag)
> +{
> +	return __copy_tree(mnt, dentry, flag, mnt->mnt_flags);
> +}

Please just change copy_tree to have an additional parameter.  There's
just four callers of it in the tree, and three of them want the new
parameter.

> +	/* Use the source mount flags unless the user passed MS_BIND_FLAGS */

I think this comment could be made a little more explicit.

	/*
	 * If MS_EXPLICIT_FLAGS is passed in we will take the paramters
	 * the user has specified.  The default behaviour for bind
	 * mounts is however to take the flags from existing mount
	 * instances for the same superblock.
	 */
	 
> #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
> #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
> #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
> +#define MS_BIND_FLAGS	(1<<24) /* For MS_BIND, take mnt_flags from
> +				 * args, not from source mountpoint */
> #define MS_ACTIVE	(1<<30)
> #define MS_NOUSER	(1<<31)

this looks like whitespace damage to me.

