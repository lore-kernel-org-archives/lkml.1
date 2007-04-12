Return-Path: <linux-kernel-owner+w=401wt.eu-S1161569AbXDLGlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161569AbXDLGlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 02:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161574AbXDLGlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 02:41:01 -0400
Received: from mx1.suse.de ([195.135.220.2]:47080 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161569AbXDLGlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 02:41:00 -0400
From: Neil Brown <neilb@suse.de>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Date: Thu, 12 Apr 2007 15:57:41 +1000
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <17949.51797.386833.917451@notabene.brown>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com>
	<20070407203633.GA21555@thunk.org>
	<20070407233037.GA16508@infradead.org>
	<46193048.6000606@zytor.com>
	<20070408184129.GA20871@lazybastard.org>
	<17947.65165.569482.976343@notabene.brown>
	<20070411144252.GB17778@thunk.org>
	<17949.25061.739035.688232@notabene.brown>
	<20070411232224.GF17778@thunk.org>
	<17949.36737.701327.104172@notabene.brown>
	<20070412023712.GA8175@lazybastard.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday April 12, joern@lazybastard.org wrote:
> On Thu, 12 April 2007 11:46:41 +1000, Neil Brown wrote:
> > 
> > I could argue that nfs came before ext3+dirindex, so ext3 should have
> > been designed to work properly with NFS.  You could argue that fixing
> > it in nfsd fixes it for all filesystems.  But I'm not sure either of
> > those arguments are likely to be at all convincing...
> 
> Caring about a non-ext3 filesystem, I sure would like an nfs solution as
> well. :)

I have a non-ext3 filesystem I care about too.....

But my perspective is that a solution in nfsd at-best a work-around.
Caching the whole 'struct file' when there is just a small bit that we
might want seems like a heavy hammer.  The filesystem is in the best
place to know what needs to be cached, and it should be the one doing
the caching.

> 
> > Hmmm. I wonder.  Which is more likely?
> >   - That two 64bit hashes from some set are the same
> >   - or that 65536 48bit hashes from a set of equal size are the same.
> 
> The former.  Each bit going from hash strength to collision chain length
> reduces the likelihood of an overflow.  In the extreme case of a 0bit
> hash and 64bit collision chain, you need 2^64 entries compared to 2^32
> for the other extreme.
> 
> However, the collision chain gives me quite a bit of headache.  One
> would have to store each entry's position on the chain, deal with older
> entries getting deleted, newer entries getting removed, etc.  All this
> requires a lot of complicated code that basically never gets tested in
> the wild.

This is a simple consequence of the design decision to use hashes as
the search key.  They aren't dense and they will collide.  So the
solution will be a bit fuzzy around the edges.  And maybe that is an
acceptable tradeoff.  But the filesystem should take full
responsibility for it, whether in performance or correctness :-)

> 
> Just settling for a 64bit hash and returning -EEXIST when someone causes
> a collision an creat() sounds more appealing.  Directories with 4
> billion entries will cause problems, but that is hardly news to anyone.
> 

I think you want -EFBIG or -ENOSPC.  -EEXIST sounds just wrong.

But there are alternatives.  e.g. internal chaining.
Insist on a unique 64bit hash for every file.  If the hash is in use,
increment and try again.  On lookup, if the hash leads you to a file
with the wrong name, increment and try again until you find a hole
(hash value that is not stored).  When you delete an entry, leave a
place holder if the next hash is in use.  Conversely if the next hash
is not in use, delete the entry and delete the previous one if it is a
place holder.

Then you get 100% correct semantics and a performance hit in the face
of hash collisions that is probably no worse than that which ext3
currently gets.  It probably does cost you a bit of storage to store
those 64bit hashes, though I suspect some clever compression can help
out there (You only need one bit more than the filename when there is
no chaining).

You have to require 64bit cookies/fpos, but I think that today, that
is a reasonable thing to require (5 years ago it might not have been).

NeilBrown
