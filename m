Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab0BCCLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 21:11:17 -0500
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:57534 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932244Ab0BCCLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 21:11:15 -0500
Date: Mon, 1 Feb 2010 00:59:33 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: tytso@mit.edu, Christoph Lameter <cl@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: inodes: Support generic defragmentation
Message-ID: <20100131135933.GM15853@discord.disaster>
References: <20100129204931.789743493@quilx.com> <20100129205004.405949705@quilx.com> <20100130192623.GE788@thunk.org> <20100131083409.GF29555@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100131083409.GF29555@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 09:34:09AM +0100, Andi Kleen wrote:
> On Sat, Jan 30, 2010 at 02:26:23PM -0500, tytso@mit.edu wrote:
> > On Fri, Jan 29, 2010 at 02:49:42PM -0600, Christoph Lameter wrote:
> > > This implements the ability to remove inodes in a particular slab
> > > from inode caches. In order to remove an inode we may have to write out
> > > the pages of an inode, the inode itself and remove the dentries referring
> > > to the node.
> > 
> > How often is this going to happen?  Removing an inode is an incredibly
> 
> The standard case is the classic updatedb. Lots of dentries/inodes cached
> with no or little corresponding data cache.

I don't believe that updatedb has anything to do with causing
internal inode/dentry slab fragmentation. In all my testing I rarely
see use-once filesystem traversals cause internal slab
fragmentation. This appears to be a result of use-once filesystem
traversal resulting in slab pages full of objects that have the same
locality of access.  Hence each new slab page that traversal
allocates will contain objects that will be adjacent in the LRU.
Hence LRU-based reclaim is very likely to free all the objects on
each page in the same pass and as such no fragmentation will occur.

All the cases of inode/dentry slab fragmentation I have seen are a
result of access patterns that result in slab pages containing
objects with different temporal localities. It's when the access
pattern is sufficiently distributed throughout the working set we
get the "need to free 95% of the objects in the entire cache to free
a single page" type of reclaim behaviour.

AFAICT, the defrag patches as they stand don't really address the
fundamental problem of differing temporal locality inside a slab
page.  It makes the assumption that "partial page == defrag
candidate" but there isn't any further consideration of when any of
the remaing objects were last accessed. I think that this really
does need to be taken into account, especially considering that the
allocator tries to fill partial pages with new objects before
allocating new pages and so the page under reclaim might contain
very recently allocated objects.

Someone in a previous discussion on this patch set (Nick? Hugh,
maybe? I can't find the reference right now) mentioned something
like this about the design of the force-reclaim operations. IIRC the
suggestion was that it may be better to track LRU-ness by per-slab
page rather than per-object so that reclaim can target the slab
pages that - on aggregate - had the oldest objects in it. I think
this has merit - prevention of internal fragmentation seems like a
better approach to me than to try to cure it after it is already
present....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
