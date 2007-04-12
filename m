Return-Path: <linux-kernel-owner+w=401wt.eu-S1161591AbXDLMWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161591AbXDLMWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 08:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161598AbXDLMWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 08:22:11 -0400
Received: from thunk.org ([69.25.196.29]:52095 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161591AbXDLMWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 08:22:10 -0400
Date: Thu, 12 Apr 2007 08:21:16 -0400
From: Theodore Tso <tytso@mit.edu>
To: Neil Brown <neilb@suse.de>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
Message-ID: <20070412122116.GD28148@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Christoph Hellwig <hch@infradead.org>,
	Ulrich Drepper <drepper@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070407233037.GA16508@infradead.org> <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org> <17947.65165.569482.976343@notabene.brown> <20070411144252.GB17778@thunk.org> <17949.25061.739035.688232@notabene.brown> <20070411232224.GF17778@thunk.org> <17949.36737.701327.104172@notabene.brown> <20070412023712.GA8175@lazybastard.org> <17949.51797.386833.917451@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17949.51797.386833.917451@notabene.brown>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 03:57:41PM +1000, Neil Brown wrote:
> But my perspective is that a solution in nfsd at-best a work-around.
> Caching the whole 'struct file' when there is just a small bit that we
> might want seems like a heavy hammer.  The filesystem is in the best
> place to know what needs to be cached, and it should be the one doing
> the caching.

Sure, but ext3 needs to cache the information in the file handle,
because it's dynamic, per-directory stream information that needs to
be cached.  The fundamental problem is the broken nature of the 64-bit
cookie; it simply isn't big enough.  So what's being disputed is who
gets to pay the cost of that particular design mistake, in POSIX and
in NFS?

In the POSIX case, right now only applications that use
telldir/seekdir pay the cost, which is they might see some repeated
directory entries in the case of hash collisions.

Unfortunately, in the NFS case if there are hash collisions, under the
wrong circumstances the NFS client could loop forever trying to
readdir() a directory stream.

> This is a simple consequence of the design decision to use hashes as
> the search key.  They aren't dense and they will collide.  So the
> solution will be a bit fuzzy around the edges.  And maybe that is an
> acceptable tradeoff.  But the filesystem should take full
> responsibility for it, whether in performance or correctness :-)

Well, we could also say that it is NFS's fault that they used a
limited size cookie as a fundamental part of their protocol.... 

> But there are alternatives.  e.g. internal chaining.
> Insist on a unique 64bit hash for every file.  If the hash is in use,
> increment and try again.  On lookup, if the hash leads you to a file
> with the wrong name, increment and try again until you find a hole
> (hash value that is not stored).  When you delete an entry, leave a
> place holder if the next hash is in use.  Conversely if the next hash
> is not in use, delete the entry and delete the previous one if it is a
> place holder.

This solution requires an incompatible file format change.  In
addition, it means trying to garbage collect directory entries when at
the beginning or end of a directory block without dragging in the
previous or next directory block.  This is a huge amount of hair, will
screw over performance, and is not compatible with how we do things
today.  

(It also means that you have to store the hash in the directory entry,
which we don't do today, since we can always calculate the hash from
the file name.  But if in some cases the hash is going to be some
small integer plus the calculated hash, you have to bloat the
directory entry by an extra 8 bytes per dirent.)

Again, compared to a directory fd cache, what you're proposing a huge
hit to the filesystem, and at the moment, given that telldir/seekdir
is rarely used by everyone else, it's mainly NFS which is the main bad
actor here by insisting on the use of a small 31/63-bit cookie as a
condition of protocol correctness.

						- Ted
