Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596Ab0A3XCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab0A3XCU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 18:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148Ab0A3XCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 18:02:19 -0500
Received: from thunk.org ([69.25.196.29]:38375 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab0A3XCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 18:02:18 -0500
Date: Sat, 30 Jan 2010 14:26:23 -0500
From: tytso@mit.edu
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Chinner <david@fromorbit.com>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: inodes: Support generic defragmentation
Message-ID: <20100130192623.GE788@thunk.org>
Mail-Followup-To: tytso@mit.edu,
	Christoph Lameter <cl@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Dave Chinner <david@fromorbit.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Alexander Viro <viro@ftp.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Christoph Lameter <clameter@sgi.com>,
	Rik van Riel <riel@redhat.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org
References: <20100129204931.789743493@quilx.com>
 <20100129205004.405949705@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129205004.405949705@quilx.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 02:49:42PM -0600, Christoph Lameter wrote:
> This implements the ability to remove inodes in a particular slab
> from inode caches. In order to remove an inode we may have to write out
> the pages of an inode, the inode itself and remove the dentries referring
> to the node.

How often is this going to happen?  Removing an inode is an incredibly
expensive operation.  We have to eject all of the pages from the page
cache, and if those pages are getting a huge amount of use --- say,
those corresponding to some shared library like libc --- or which have
a huge number of pages that are actively getting used, the thrashing
that is going to result is going to enormous.

There needs to be some kind of cost/benefit analysis done about
whether or not this is worth it.  Does it make sense to potentially
force hundreds and hundreds of megaytes of pages to get thrashed in
and out just to recover a single 4k page?  In some cases, maybe yes.
But in other cases, the results could be disastrous.

> +/*
> + * Generic callback function slab defrag ->kick methods. Takes the
> + * array with inodes where we obtained refcounts using fs_get_inodes()
> + * or get_inodes() and tries to free them.
> + */
> +void kick_inodes(struct kmem_cache *s, int nr, void **v, void *private)
> +{
> +	struct inode *inode;
> +	int i;
> +	int abort = 0;
> +	LIST_HEAD(freeable);
> +	int active;
> +
> +	for (i = 0; i < nr; i++) {
> +		inode = v[i];
> +		if (!inode)
> +			continue;

In some cases, it's going to be impossible to empty a particular slab
cache page.  For example, there may be one inode which has pages
locked into memory, or which we may decide (once we add some
intelligence into this function) is really not worth ejecting.  In
that case, there's no point dumping the rest of the inodes on that
particular slab page.   

> +		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
> +			if (remove_inode_buffers(inode))
> +				/*
> +				 * Should we really be doing this? Or
> +				 * limit the writeback here to only a few pages?
> +				 *
> +				 * Possibly an expensive operation but we
> +				 * cannot reclaim the inode if the pages
> +				 * are still present.
> +				 */
> +				invalidate_mapping_pages(&inode->i_data,
> +								0, -1);

> +		}

I do not thing this function does what you think it does....

"invalidate_mapping_pages() will not block on I/O activity, and it
will refuse to invalidate pages which are dirty, locked, under
writeback, or mapped into page tables."

So you need to force the data to be written *first*, then get the
pages removed from the page table, and only then, call
invalidate_mapping_pages().  Otherwise, this is just going to
pointlessly drop pages from the page cache and trashing the page
cache's effectiveness, without actually making it possible to drop a
particular inode if it is being used at all by any process.

Presumably then the defrag code, since it was unable to free a
particular page, will go on pillaging and raping other inodes in the
inode cache, until it can actually create a hugepage.  This is why you
really shouldn't start trying to trash an inode until you're
**really** sure it's possible completely evict a 4k slab page of all
of its inodes.

	   	       	  	     - Ted
