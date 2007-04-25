Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbXDYXDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbXDYXDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbXDYXDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:03:48 -0400
Received: from mga06.intel.com ([134.134.136.21]:27594 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754507AbXDYXDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:03:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,452,1170662400"; 
   d="scan'208";a="234060900"
Date: Wed, 25 Apr 2007 16:03:44 -0700
From: Valerie Henson <val_henson@linux.intel.com>
To: David Chinner <dgc@sgi.com>
Cc: Amit Gud <gud@ksu.edu>, Nikita Danilov <nikita@clusterfs.com>,
       David Lang <david.lang@digitalinsight.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Message-ID: <20070425230344.GC16129@nifty>
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu> <17965.60841.900376.524639@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL> <462E7C47.8080604@ksu.edu> <20070425105434.GX32602149@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425105434.GX32602149@melbourne.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 08:54:34PM +1000, David Chinner wrote:
> On Tue, Apr 24, 2007 at 04:53:11PM -0500, Amit Gud wrote:
> > 
> > The structure looks like this:
> > 
> >  ----------		----------
> > | cnode 0  |---------->| cnode 0  |----------> to another cnode or NULL
> >  ----------		----------
> > | cnode 1  |-----      | cnode 1  |-----
> >  ----------	|	----------	|
> > | cnode 2  |-- |      | cnode 2  |--   |
> >  ----------  | |	----------  |   |
> > | cnode 3  | | |      | cnode 3  | |   |
> >  ----------  | |	----------  |   |
> > 	  |  |  |		 |  |   |
> > 
> > 	   inodes		inodes or NULL
> 
> How do you recover if fsfuzzer takes out a cnode in the chain? The
> chunk is marked clean, but clearly corrupted and needs fixing and
> you don't know what it was pointing at.  Hence you have a pointer to
> a trashed cnode *somewhere* that you need to find and fix, and a
> bunch of orphaned cnodes that nobody points to *somewhere else* in
> the filesystem that you have to find. That's a full scan fsck case,
> isn't?

Excellent question.  This is one of the trickier aspects of chunkfs -
the orphan inode problem (tricky, but solvable).  The problem is what
if you smash/lose/corrupt an inode in one chunk that has a
continuation inode in another chunk?  A back pointer does you no good
if the back pointer is corrupted.

What you do is keep tabs on whether you see damage that looks like
this has occurred - e.g., inode use/free counts wrong, you had to zero
a corrupted inode - and when this happens, you do a scan of all
continuation inodes in chunks that have links to the corrupted chunk.
What you need to make this go fast is (1) a pre-made list of which
chunks have links with which other chunks, (2) a fast way to read all
of the continuation inodes in a chunk (ignoring chunk-local inodes).
This stage is O(fs size) approximately, but it should be quite swift.

> It seems that any sort of damage to the underlying storage (e.g.
> media error, I/O error or user brain explosion) results in the need
> to do a full fsck and hence chunkfs gives you no benefit in this
> case.

I worry about this but so far haven't found something which couldn't
be cut down significantly with just a little extra work.  It might be
helpful to look at an extreme case.

Let's say we're incredibly paranoid.  We could be justified in running
a full fsck on the entire file system in between every single I/O.
After all, something *might* have been silently corrupted.  But this
would be ridiculously slow.  We could instead never check the file
system.  But then we would end up panicking and corrupting the file
system a lot.  So what's a good compromise?

In the chunkfs case, here's my rules of thumb so far:

1. Detection: All metadata has magic numbers and checksums.
2. Scrubbing: Random check of chunks when possible.
3. Repair: When we detect corruption, either by checksum error, file
   system code assertion failure, or hardware tells us we have a bug,
   check the chunk containing the error and any outside-chunk
   information that could be affected by it.

-VAL
