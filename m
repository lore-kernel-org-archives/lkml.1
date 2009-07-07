Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbZGGO6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbZGGO6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758450AbZGGO6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:58:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58029 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984AbZGGO6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:58:21 -0400
Date: Tue, 7 Jul 2009 10:58:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 3/4] fs: new truncate sequence
Message-ID: <20090707145820.GA9976@infradead.org>
References: <20090707144423.GC2714@wotan.suse.de> <20090707144823.GE2714@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090707144823.GE2714@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 04:48:23PM +0200, Nick Piggin wrote:
> Don't know whether it is a good idea to move i_alloc_sem into implementation.
> Maybe it is better to leave it in the caller in this patchset?

Generally moving locks without changing prototypes can be a very subtle
way to break things.  A good option is to move the locking in a separate
patch set in a patch series or at least release if it's otherwise to
complicated.

> +int simple_setsize(struct dentry *dentry, loff_t newsize,
> +			unsigned flags, struct file *file)

This one could probably also use kerneldoc comment.

> +{
> +	struct inode *inode = dentry->d_inode;
> +	loff_t oldsize;
> +	int error;
> +
> +	error = inode_newsize_ok(inode, newsize);
> +	if (error)
> +		return error;
> +
> +	oldsize = inode->i_size;
> +	i_size_write(inode, newsize);
> +	truncate_pagecache(inode, oldsize, newsize);
> +
> +	return error;
> +}

> +	if (ia_valid & ATTR_SIZE) {
> +		if (inode->i_op && inode->i_op->setsize) {

inode->i_op is mandatory these days.

> +			unsigned int flags = 0;
> +			struct file *file = NULL;
> +
> +			if (ia_valid & ATTR_FILE) {
> +				flags |= SETSIZE_FILE;
> +				file = attr->ia_file;
> +			}
> +			if (ia_valid & ATTR_OPEN)
> +				flags |= SETSIZE_OPEN;
> +			error = inode->i_op->setsize(dentry, attr->ia_size,
> +							flags, file);
> +			if (error)
> +				return error;

So you still pass down to ->setattr if ->setsize succeeded?  That's a
very confusing calling convention.  It also means we first do the
truncation and any following time/mode updates are in a separate
transaction which is a no-go.

