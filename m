Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbXKGKWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbXKGKWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 05:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbXKGKWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 05:22:37 -0500
Received: from lazybastard.de ([212.112.238.170]:40496 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbXKGKWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 05:22:36 -0500
Date: Wed, 7 Nov 2007 11:17:48 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundatin.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@skynet.ie>
Subject: Re: [patch 14/23] inodes: Support generic defragmentation
Message-ID: <20071107101748.GC7374@lazybastard.org>
References: <20071107011130.382244340@sgi.com> <20071107011229.893091119@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071107011229.893091119@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 November 2007 17:11:44 -0800, Christoph Lameter wrote:
>  
> +void *get_inodes(struct kmem_cache *s, int nr, void **v)
> +{
> +	int i;
> +
> +	spin_lock(&inode_lock);
> +	for (i = 0; i < nr; i++) {
> +		struct inode *inode = v[i];
> +
> +		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE))
> +			v[i] = NULL;
> +		else
> +			__iget(inode);
> +	}
> +	spin_unlock(&inode_lock);
> +	return NULL;
> +}
> +EXPORT_SYMBOL(get_inodes);

What purpose does the return type have?

> +/*
> + * Function for filesystems that embedd struct inode into their own
> + * structures. The offset is the offset of the struct inode in the fs inode.
> + */
> +void *fs_get_inodes(struct kmem_cache *s, int nr, void **v,
> +						unsigned long offset)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr; i++)
> +		v[i] += offset;
> +
> +	return get_inodes(s, nr, v);
> +}
> +EXPORT_SYMBOL(fs_get_inodes);

The fact that all pointers get changed makes me a bit uneasy:
	struct foo_inode v[20];
	...
	fs_get_inodes(..., v, ...);
	...
	v[0].foo_field = bar;
	
No warning, but spectacular fireworks.

> +void kick_inodes(struct kmem_cache *s, int nr, void **v, void *private)
> +{
> +	struct inode *inode;
> +	int i;
> +	int abort = 0;
> +	LIST_HEAD(freeable);
> +	struct super_block *sb;
> +
> +	for (i = 0; i < nr; i++) {
> +		inode = v[i];
> +		if (!inode)
> +			continue;

NULL is legal here?  Then fs_get_inodes should check for NULL as well
and not add the offset to NULL pointers, I guess.

> +		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
> +			if (remove_inode_buffers(inode))
> +				invalidate_mapping_pages(&inode->i_data,
> +								0, -1);

This linebreak can be removed.

> +		}
> +
> +		/* Invalidate children and dentry */
> +		if (S_ISDIR(inode->i_mode)) {
> +			struct dentry *d = d_find_alias(inode);
> +
> +			if (d) {
> +				d_invalidate(d);
> +				dput(d);
> +			}
> +		}
> +
> +		if (inode->i_state & I_DIRTY)
> +			write_inode_now(inode, 1);

Once more the three-bit I_DIRTY is used like a boolean value.  I don't
hold it against you, specifically.  A general review/cleanup is
necessary for that.

Jörn

-- 
"[One] doesn't need to know [...] how to cause a headache in order
to take an aspirin."
-- Scott Culp, Manager of the Microsoft Security Response Center, 2001
