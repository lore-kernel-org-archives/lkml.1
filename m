Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbXDPQj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbXDPQj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 12:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbXDPQj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 12:39:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57697 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbXDPQj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 12:39:57 -0400
Date: Mon, 16 Apr 2007 17:39:56 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>
Subject: Re: [nameidata 2/2] Pass no useless nameidata to the create, lookup, and permission IOPs
Message-ID: <20070416163956.GA11001@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
	Tony Jones <tonyj@suse.de>
References: <20070412090809.917795000@suse.de> <20070412090836.207973000@suse.de> <20070412100628.GA25078@infradead.org> <200704161829.20669.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704161829.20669.agruen@suse.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 06:29:20PM +0200, Andreas Gruenbacher wrote:
>  enum { MAX_NESTED_LINKS = 8 };
>  
> +/**
> + * Fields shared between nameidata and nameidata2 -- nameidata2 could
> + * be embedded in nameidata, but then the vfs code would become
> + * cluttered with dereferences.

you could use an anonymous struct embedeed in both.

> + */
> +#define __NAMEIDATA2				\
> +	struct dentry	*dentry;		\
> +	struct vfsmount *mnt;			\
> +	unsigned int	flags;			\
> +						\
> +	union {					\
> +		struct open_intent open;	\
> +	} intent;

Or better just pass argument directly.  We really
should only pass down the the dentry and the
intent to the filesystem.  The filesystem has
not business looking at mnt in the operations,
and the relevant bits of flags (mostly whether it's
O_EXCLUSIVE) should be stored in the intent, because
that's the only way it should be used.

Doing it that way also allows to fix some braindead calling conventions
like this one:

> -int permission(struct inode *inode, int mask, struct nameidata *nd)
> +int permission(struct inode *inode, int mask, struct nameidata2 *nd)
>  {
>  	umode_t mode = inode->i_mode;
>  	int retval, submask;
> @@ -278,7 +278,7 @@ int permission(struct inode *inode, int 
>   * for filesystem access without changing the "normal" uids which
>   * are used for other things.
>   */

>  static inline struct dentry *
>  do_revalidate(struct dentry *dentry, struct nameidata *nd)

Or this one.

> -			result = dir->i_op->lookup(dir, dentry, nd);
> +			result = dir->i_op->lookup(dir, dentry, ND2(nd));

or this one.

etc..
