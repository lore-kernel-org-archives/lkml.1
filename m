Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205Ab0A3Cnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab0A3Cnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 21:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191Ab0A3Cno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 21:43:44 -0500
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:58324 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755062Ab0A3Cno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 21:43:44 -0500
Date: Sat, 30 Jan 2010 13:43:29 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: inodes: Support generic defragmentation
Message-ID: <20100130024329.GJ15853@discord.disaster>
References: <20100129204931.789743493@quilx.com> <20100129205004.405949705@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129205004.405949705@quilx.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 02:49:42PM -0600, Christoph Lameter wrote:
> This implements the ability to remove inodes in a particular slab
> from inode caches. In order to remove an inode we may have to write out
> the pages of an inode, the inode itself and remove the dentries referring
> to the node.
> 
> Provide generic functionality that can be used by filesystems that have
> their own inode caches to also tie into the defragmentation functions
> that are made available here.
> 
> FIXES NEEDED!
> 
> Note Miklos comments on the patch at http://lkml.indiana.edu/hypermail/linux/kernel/0810.1/2003.html
> 
> The way we obtain a reference to a inode entry may be unreliable since inode
> refcounting works in different ways. Also a reference to the superblock is necessary
> in order to be able to operate on the inodes.
> 
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: Alexander Viro <viro@ftp.linux.org.uk>
> Cc: Christoph Hellwig <hch@infradead.org>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
> ---
>  fs/inode.c         |  123 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h |    6 ++
>  2 files changed, 129 insertions(+)
> 
> Index: linux-2.6/fs/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/inode.c	2010-01-29 12:03:04.000000000 -0600
> +++ linux-2.6/fs/inode.c	2010-01-29 12:03:25.000000000 -0600
> @@ -1538,6 +1538,128 @@ static int __init set_ihash_entries(char
>  __setup("ihash_entries=", set_ihash_entries);
>  
>  /*
> + * Obtain a refcount on a list of struct inodes pointed to by v. If the
> + * inode is in the process of being freed then zap the v[] entry so that
> + * we skip the freeing attempts later.
> + *
> + * This is a generic function for the ->get slab defrag callback.
> + */
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

How do you expect defrag to behave when the filesystem doesn't free
the inode immediately during dispose_list()? That is, the above code
only finds inodes that are still active at the VFS level but they
may still live for a significant period of time after the
dispose_list() call. This is a real issue now that XFS has combined
the VFS and XFS inodes into the same slab...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
