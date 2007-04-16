Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbXDPLIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbXDPLIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 07:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbXDPLIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 07:08:00 -0400
Received: from thunk.org ([69.25.196.29]:45586 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030358AbXDPLHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 07:07:46 -0400
Date: Mon, 16 Apr 2007 07:07:02 -0400
From: Theodore Tso <tytso@mit.edu>
To: Neil Brown <neilb@suse.de>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
Message-ID: <20070416110702.GF27533@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Christoph Hellwig <hch@infradead.org>,
	Ulrich Drepper <drepper@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070408184129.GA20871@lazybastard.org> <17947.65165.569482.976343@notabene.brown> <20070411144252.GB17778@thunk.org> <17949.25061.739035.688232@notabene.brown> <20070411232224.GF17778@thunk.org> <17949.36737.701327.104172@notabene.brown> <20070412023712.GA8175@lazybastard.org> <17949.51797.386833.917451@notabene.brown> <20070412122116.GD28148@thunk.org> <17955.5453.164637.970405@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17955.5453.164637.970405@notabene.brown>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 04:18:53PM +1000, Neil Brown wrote:
> On Thursday April 12, tytso@mit.edu wrote:
> > 
> > Unfortunately, in the NFS case if there are hash collisions, under the
> > wrong circumstances the NFS client could loop forever trying to
> > readdir() a directory stream.
> 
> I think that can be easily avoided by the filesystem by simply
> ensuring that the cookies returned in a request are all *after* the
> 'llseek' cookie.  There still maybe some risk of missing or extra
> entries in the directory if the filesystem cannot perform a precise
> cookie->position mapping, but an infinite loop should not be a problem.

It is true that you can replace the infinite loop problem by
guaranteeing that certain filenames are simply always missing.
Neither seemed desirable to me, but it is true that if we have to err
in one direction or another, simply skipping files in the case of a
hash collision is probably a better result.

> You still haven't convinced me that the limited size is a fundamental
> problem.
> In the case of ext3,  I have suggested (various things including)
> using 56bits of the hash and an 8 bit sequence number through any
> hash chain that may eventuate.
> The seq number could not be stable across reboots with the current
> on-disk data, but could be made stable for almost all real usage with
> a little bit of caching (I imagine using upper 4 bits to give a
> sequence number while reading from disk, and lower 4 bits to give a
> sequence number when adding new entries).

The challenge is making it be stable across inserts/deletes, never
mind reboots.  And it's not a "little bit of cacheing"; in order to be
correct we would have to cache *forever*, since at least in theory an
NFS client could hold on to a cookie for an arbitrarily long period of
time (weeks, months, years, decades), yes?

> Supposing I were to try my hand at making the modifications I
> suggested to ext3 so that per page/hashvalue rbtrees were cached in
> the pagecache and were used to provide a stable-as-possible telldir
> cookie.

Well, the first problem you'll run into is that ext3 doesn't store
directories in the page cache.  That's because the journaling layer
fs/jbd operates on a buffer cache basis (i.e., on a per filesystem
block level).  

Secondly, storing the rbtree in the page cache doesn't help, because
the whole point of the rbtree is to have a stable pointer that doesn't
change across a b-tree node split.  Whether you use a page cache or
the buffer cache, it doesn't change the fact that when you do a b-tree
node split, half the directory entries *go* *someplace* *else*.  Put
another way, Linus's standard reasons for wanting to store the
directory in the page cache so we can have better readahead don't
apply when you're using htree, because with htree we're never reading
entries in page cache order.

So you wouldn't be able to store the rbtree in the page cache, since
the doing so would defeat the whole purpose of the having the rbtree
in the first place.  The rbtree needs to be per directory stream,
*not* per directory block.   

You could store a mapping between each directory entry and a sequence
number.  That could work, modulo the need to store these entries
*forever*.  But now you take a performance hit since every time you
create or delete a directory entry, you'll need to keep the cache up
to date.  And since we don't store the hash in the on-disk format
(since you can always calculate it from the filename), you'll need to
store the hash as well in the cache information.  So that means
storing a 64-bit hash plus the sequence counter information --- and if
we assume 32-bit alignment requirements for data structures, it means
the simplest way to do this would be to hang a data structure off of
each directory block which consumes 12 bytes of data for every
directory entry, plus either (a) extra space for pointers so you can
easily insert and delete entries as directory entries are created or
deleted, or (b) resigning yourself to use memmove() to insert and
delete entries in the linear array.  

You're welcome to try, but I suspect it won't take long before you'll
see why I'm asserting that a directory fd cache in nfsd is *way* less
work.  :-)

						- Ted
