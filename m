Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbXDZAsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbXDZAsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXDZAsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:48:22 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56063 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752403AbXDZAsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:48:20 -0400
Date: Thu, 26 Apr 2007 10:47:40 +1000
From: David Chinner <dgc@sgi.com>
To: Valerie Henson <val_henson@linux.intel.com>
Cc: David Chinner <dgc@sgi.com>, Amit Gud <gud@ksu.edu>,
       Nikita Danilov <nikita@clusterfs.com>,
       David Lang <david.lang@digitalinsight.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Message-ID: <20070426004740.GE65285596@melbourne.sgi.com>
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu> <17965.60841.900376.524639@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL> <462E7C47.8080604@ksu.edu> <20070425105434.GX32602149@melbourne.sgi.com> <20070425230344.GC16129@nifty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425230344.GC16129@nifty>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 04:03:44PM -0700, Valerie Henson wrote:
> On Wed, Apr 25, 2007 at 08:54:34PM +1000, David Chinner wrote:
> > On Tue, Apr 24, 2007 at 04:53:11PM -0500, Amit Gud wrote:
> > > 
> > > The structure looks like this:
> > > 
> > >  ----------		----------
> > > | cnode 0  |---------->| cnode 0  |----------> to another cnode or NULL
> > >  ----------		----------
> > > | cnode 1  |-----      | cnode 1  |-----
> > >  ----------	|	----------	|
> > > | cnode 2  |-- |      | cnode 2  |--   |
> > >  ----------  | |	----------  |   |
> > > | cnode 3  | | |      | cnode 3  | |   |
> > >  ----------  | |	----------  |   |
> > > 	  |  |  |		 |  |   |
> > > 
> > > 	   inodes		inodes or NULL
> > 
> > How do you recover if fsfuzzer takes out a cnode in the chain? The
> > chunk is marked clean, but clearly corrupted and needs fixing and
> > you don't know what it was pointing at.  Hence you have a pointer to
> > a trashed cnode *somewhere* that you need to find and fix, and a
> > bunch of orphaned cnodes that nobody points to *somewhere else* in
> > the filesystem that you have to find. That's a full scan fsck case,
> > isn't?
> 
> Excellent question.  This is one of the trickier aspects of chunkfs -
> the orphan inode problem (tricky, but solvable).  The problem is what
> if you smash/lose/corrupt an inode in one chunk that has a
> continuation inode in another chunk?  A back pointer does you no good
> if the back pointer is corrupted.

*nod*

> What you do is keep tabs on whether you see damage that looks like
> this has occurred - e.g., inode use/free counts wrong, you had to zero
> a corrupted inode - and when this happens, you do a scan of all
> continuation inodes in chunks that have links to the corrupted chunk.

This assumes that you know a chunk has been corrupted, though.
How do you find that out?

> What you need to make this go fast is (1) a pre-made list of which
> chunks have links with which other chunks,

So you add a new on-disk structure that needs to be kept up to
date? How do you trust that structure to be correct if you are
not journalling it? What happens if fsfuzzer trashes part
of this table as well and you can't trust it?

> (2) a fast way to read all
> of the continuation inodes in a chunk (ignoring chunk-local inodes).
> This stage is O(fs size) approximately, but it should be quite swift.

Assuming you can trust this list. if not, finding cnodes is going
to be rather slow.....

> > It seems that any sort of damage to the underlying storage (e.g.
> > media error, I/O error or user brain explosion) results in the need
> > to do a full fsck and hence chunkfs gives you no benefit in this
> > case.
> 
> I worry about this but so far haven't found something which couldn't
> be cut down significantly with just a little extra work.  It might be
> helpful to look at an extreme case.
> 
> Let's say we're incredibly paranoid.  We could be justified in running
> a full fsck on the entire file system in between every single I/O.
> After all, something *might* have been silently corrupted.  But this
> would be ridiculously slow.  We could instead never check the file
> system.  But then we would end up panicking and corrupting the file
> system a lot.  So what's a good compromise?
> 
> In the chunkfs case, here's my rules of thumb so far:
> 
> 1. Detection: All metadata has magic numbers and checksums.
> 2. Scrubbing: Random check of chunks when possible.
> 3. Repair: When we detect corruption, either by checksum error, file
>    system code assertion failure, or hardware tells us we have a bug,
>    check the chunk containing the error and any outside-chunk
>    information that could be affected by it.

So if you end up with a corruption in a "clean" part of the
filesystem, you may not find out about the corruption on reboot and
fsck?  You need to trip over the corruption first before fsck can be
told it needs to check/repair a given chunk? Or do you need to force
a "check everything" fsck in this case?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
