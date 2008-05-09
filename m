Return-Path: <linux-kernel-owner+w=401wt.eu-S1765927AbYEITkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765927AbYEITkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 15:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbYEITkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 15:40:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37686 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbYEITkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 15:40:35 -0400
Date: Fri, 9 May 2008 15:40:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 6/9] fuse: add export operations
Message-ID: <20080509194030.GA29118@infradead.org>
References: <20080509124107.645600519@szeredi.hu> <20080509124133.577558326@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509124133.577558326@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +struct fuse_inode_handle
> +{
> +	u64 nodeid;
> +	u32 generation;
> +};

This is the same filehandle type XFS uses for 64bit inode filesystems
where the parent is not encoded.  I'll post a patch soon to move that
64bit inode handling to common code.  I don't think it's a good idea
to delay your patch until that happens, but can you chose the fid
types to be the same as XFS does currently so that a conversion is
easily possible.  The fh_type should be 0x81 (fh type 1 order by 0x80
to imply it's 64bit inodes)

In case you want to look at that patch I'v uploaded the current
version at http://verein.lst.de/~hch/generic-64bit-inode-export

> +static struct dentry *fuse_get_dentry(struct super_block *sb,
> +				      struct fuse_inode_handle *handle)
> +{
> +	struct inode *inode;
> +	struct dentry *entry;
> +	int err = -ESTALE;
> +
> +	if (handle->nodeid == 0)
> +		goto out_err;
> +
> +	inode = ilookup5(sb, handle->nodeid, fuse_inode_eq, &handle->nodeid);
> +	if (!inode)
> +		goto out_err;

Only finding in-memory inodes for nfs export is quite dangerous.  I
think it would be a much better idea to support whatever upcalls are
needed to find the object if it's not in memory.  Without that the nfs
exporting support is hardly useable.

