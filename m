Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab0BHHiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 02:38:10 -0500
Received: from cantor.suse.de ([195.135.220.2]:56121 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab0BHHiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 02:38:04 -0500
Date: Mon, 8 Feb 2010 18:37:53 +1100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, tytso@mit.edu,
       Andi Kleen <andi@firstfloor.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: inodes: Support generic defragmentation
Message-ID: <20100208073753.GC9781@laptop>
References: <20100129205004.405949705@quilx.com>
 <20100130192623.GE788@thunk.org>
 <20100131083409.GF29555@one.firstfloor.org>
 <20100131135933.GM15853@discord.disaster>
 <alpine.DEB.2.00.1002030920500.5671@router.home>
 <20100204003410.GD5332@discord.disaster>
 <20100204030736.GB25885@thunk.org>
 <20100204033911.GE5332@discord.disaster>
 <20100204093350.GE13318@laptop>
 <alpine.DEB.2.00.1002041109500.28165@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002041109500.28165@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 11:13:15AM -0600, Christoph Lameter wrote:
> On Thu, 4 Feb 2010, Nick Piggin wrote:
> 
> > Well what I described is to do the slab pinning from the reclaim path
> > (rather than from slab calling into the subsystem). All slab locking
> > basically "innermost", so you can pretty much poke the slab layer as
> > much as you like from the subsystem.
> 
> Reclaim/defrag is called from the reclaim path (of the VM). We could
> enable a call from the fs reclaim code into the slab. But how would this
> work?

Well the exact details will depend, but I feel that things should
get easier because you pin the object (and therefore the slab) via
the normal and well tested reclaim paths.

So for example, for dcache, you will come in and take the normal
locks: dcache_lock, sb_lock, pin the sb, umount_lock. At which
point you have pinned dentries without changing any locking. So
then you can find the first entry on the LRU, and should be able
to then build a list of dentries on the same slab.

You still have the potential issue of now finding objects that would
not be visible by searching the LRU alone. However at least the
locking should be simplified.

 
> > After that, LRU on slabs should be fairly easy. Slab could provide a
> > private per-slab pointer for example that is managed by the caller.
> > Subsystem can then call into slab to find the objects.
> 
> Sure with some minor changes we could have a call that is giving you the
> list of neighboring objects in a slab, while locking it? Then you can look
> at the objects and decide which ones can be tossed and then do another
> call to release the objects and unlock the slab.

Yep. Well... you may not even need to ask slab layer to lock the
slab. Provided that the subsystem is locking out changes. It could
possibly be helpful to have a call to lock and unlock the slab,
although usage of such an API would have to be very careful.

Thanks,
Nick
