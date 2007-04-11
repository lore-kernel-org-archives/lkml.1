Return-Path: <linux-kernel-owner+w=401wt.eu-S1161428AbXDKXXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161428AbXDKXXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161431AbXDKXXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 19:23:40 -0400
Received: from thunk.org ([69.25.196.29]:50282 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161428AbXDKXXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 19:23:39 -0400
Date: Wed, 11 Apr 2007 19:22:24 -0400
From: Theodore Tso <tytso@mit.edu>
To: Neil Brown <neilb@suse.de>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
Message-ID: <20070411232224.GF17778@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Christoph Hellwig <hch@infradead.org>,
	Ulrich Drepper <drepper@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com> <20070407203633.GA21555@thunk.org> <20070407233037.GA16508@infradead.org> <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org> <17947.65165.569482.976343@notabene.brown> <20070411144252.GB17778@thunk.org> <17949.25061.739035.688232@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17949.25061.739035.688232@notabene.brown>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 08:32:05AM +1000, Neil Brown wrote:
> For the first:
>   You are storing an internal tree representation of part of the
>   directory attached to the 'struct file'.
>   Would it be possible to store this attached to the page via the
>   ->private pointer?  What would avoid the allocate/create/free
>   overhead on every request.

The reason why we are storing it associated with the file pointer
instead of the page/block is because the a filename insertion might
cause a node split, in which case half of the 4k block gets copied to
another block.  We need a stable pointer to where we are in the tree
that can cope with hash collisions, and that's the reason for creating
red/black tree in the first place, since it *doesn't* get split and
reorganized when the directory's hash tree gets reorg'ed.  So
attaching the tree to the page breaks the reason why we have the
separate data structure in the first place.

>   You suggest caching the open files in nfsd.  While that is probably
>   possible (I've thought of it a number of times) is would also be
>   quite complex, e.g. requiring some sort of call-back to close all
>   those files when the filesystem is unexported.  And it is very easy
>   to get caching heuristics wrong.  Leveraging the page-cache which is
>   a very mature cache seems to make a lot of sense.

Is it really that complex?  The simplest way of handling it is simply
keeping a open directory fd cache in a per-filesystem rbtree index
which is indexed by file handle and contains the file pointer.  When
you unexport the filesystem, you simply walk the rbtree and close all
of the file descriptors; no callback is required.

The caching hueristics are an issue; but fixed-size cache with a
simple LFU replacement strategy isn't all that complex to implement.
If 95% of the time, the readdir's come in quick succession, even a
small cache will probably provide huge performance gains, and
increaing the cache size past some critical point will probably only
provide marginal improvements.  

> For the second.
>   You say that you " would need at least 96 bits in order to make that
>   guarantee; 64 bits of hash, plus a 32-bit count value in the hash
>   collision chain".  I think 96 is a bit greedy.  Surely 48 bits of 
>   hash and 16 bits of collision-chain-position would plenty.  You would
>   need 65537 entries before a collision was even possible, and
>   billions before it was at all likely. (How big does a set of 48bit
>   numbers have to get before the probability that "No subset of 65536
>   numbers are all the same" drops below 0.95?)
> 
>   This would really require that the collision-chain-index was stable
>   across create/delete.  Doing that while you have the tree in the
>   page cache is probably easy enough.  Doing it across reboots is
>   probably not possible without on-disk changes.

Actually, no, we can't keep the collision chain count stable across a
create/delete even while the tree is cached.  At least, not without
storing a huge amount of state associated with each page.  (It would
be a lot more work than simply having nfsd keep a fd cache for
directory streams ;-).

If we need create/delete stability, probably our only sane
implementation choice is to just stick with a 63-bit hash, and cross
our fingers and hope for the best.  

If nfsd caches the last N used directory caches, where N is roughly
proportional to the number of active clients, and the clients all only
use the last cookie returned in the readdir entry (since it would be
stupid to use one of the earlier ones and request the server to
re-send something which the client already has), at least in the
absense of telldir/seekdir calls, then that might be quite sufficient,
even if we return multiple direntory entries which contain hash
collisions to the client.  As long as the directory fd is cached, and
the client just uses the last cookie to fetch the next batch of
dirents, we'll be fine.

						- Ted
