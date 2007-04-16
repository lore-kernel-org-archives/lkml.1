Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988AbXDPGTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbXDPGTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 02:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbXDPGTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 02:19:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:35996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbXDPGTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 02:19:10 -0400
From: Neil Brown <neilb@suse.de>
To: Theodore Tso <tytso@mit.edu>
Date: Mon, 16 Apr 2007 16:18:53 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17955.5453.164637.970405@notabene.brown>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
In-Reply-To: message from Theodore Tso on Thursday April 12
References: <20070407233037.GA16508@infradead.org>
	<46193048.6000606@zytor.com>
	<20070408184129.GA20871@lazybastard.org>
	<17947.65165.569482.976343@notabene.brown>
	<20070411144252.GB17778@thunk.org>
	<17949.25061.739035.688232@notabene.brown>
	<20070411232224.GF17778@thunk.org>
	<17949.36737.701327.104172@notabene.brown>
	<20070412023712.GA8175@lazybastard.org>
	<17949.51797.386833.917451@notabene.brown>
	<20070412122116.GD28148@thunk.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday April 12, tytso@mit.edu wrote:
> 
> Unfortunately, in the NFS case if there are hash collisions, under the
> wrong circumstances the NFS client could loop forever trying to
> readdir() a directory stream.

I think that can be easily avoided by the filesystem by simply
ensuring that the cookies returned in a request are all *after* the
'llseek' cookie.  There still maybe some risk of missing or extra
entries in the directory if the filesystem cannot perform a precise
cookie->position mapping, but an infinite loop should not be a problem.

> 
> > This is a simple consequence of the design decision to use hashes as
> > the search key.  They aren't dense and they will collide.  So the
> > solution will be a bit fuzzy around the edges.  And maybe that is an
> > acceptable tradeoff.  But the filesystem should take full
> > responsibility for it, whether in performance or correctness :-)
> 
> Well, we could also say that it is NFS's fault that they used a
> limited size cookie as a fundamental part of their protocol.... 
> 

You still haven't convinced me that the limited size is a fundamental
problem.
In the case of ext3,  I have suggested (various things including)
using 56bits of the hash and an 8 bit sequence number through any
hash chain that may eventuate.
The seq number could not be stable across reboots with the current
on-disk data, but could be made stable for almost all real usage with
a little bit of caching (I imagine using upper 4 bits to give a
sequence number while reading from disk, and lower 4 bits to give a
sequence number when adding new entries).

Even if you adjusted this to 32bits hash and 32bits seq number to
guarantee that the seq number never overflowed, collisions would still
be sufficiently rare that you wouldn't notice them in performance
measurements, but it might just give the collision handling code some
testing in the real world.

> > But there are alternatives.  e.g. internal chaining.
..
> 
> This solution requires an incompatible file format change. 

I wasn't suggesting that ext3 use internal chaining.  That is
obviously not an option.  I was putting the idea forward for any
filesystem developers who may not have finalised their directory
design yet so they could see a mechanism for indexing directories that
gives 100% correct semantics.

> Again, compared to a directory fd cache, what you're proposing a huge
> hit to the filesystem, and at the moment, given that telldir/seekdir
> is rarely used by everyone else, it's mainly NFS which is the main bad
> actor here by insisting on the use of a small 31/63-bit cookie as a
> condition of protocol correctness.

What I would really like to propose (which may or may not match what
it might have seemed like I was proposing in the past) is that ext3
(and every filesystem) should produce and consume cookies that are as
close to perfect as practically possible.  That means guaranteeing no
infinite loops and minimising the chance of lost or duplicated entries
in the case of completely uncached NFS/READDIR access.

On top of that I propose that it might be appropriate to provide some
caching somewhere on the understanding that is isn't required for
correctness and is there primarily for performance (though it might
smooth over some correctness rough edges).

I think it is best for that caching to reside in the page cache, but I
am not completely against putting fd-caching in nfsd.

Supposing I were to try my hand at making the modifications I
suggested to ext3 so that per page/hashvalue rbtrees were cached in
the pagecache and were used to provide a stable-as-possible telldir
cookie.
Would you be willing to review and comment on such patches, and would
you be open to including them in ext3 (or ext4) if they proved to be
suitably stable, maintainable, efficient, etc??

NeilBrown
