Return-Path: <linux-kernel-owner+w=401wt.eu-S933691AbXDZIrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691AbXDZIrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 04:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933673AbXDZIrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 04:47:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:33907 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933669AbXDZIrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 04:47:40 -0400
Date: Thu, 26 Apr 2007 10:47:38 +0200
From: Jan Kara <jack@suse.cz>
To: Valerie Henson <val_henson@linux.intel.com>
Cc: David Chinner <dgc@sgi.com>, Amit Gud <gud@ksu.edu>,
       Nikita Danilov <nikita@clusterfs.com>,
       David Lang <david.lang@digitalinsight.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Message-ID: <20070426084738.GA21666@atrey.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu> <17965.60841.900376.524639@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL> <462E7C47.8080604@ksu.edu> <20070425105434.GX32602149@melbourne.sgi.com> <20070425230344.GC16129@nifty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425230344.GC16129@nifty>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Apr 25, 2007 at 08:54:34PM +1000, David Chinner wrote:
> > On Tue, Apr 24, 2007 at 04:53:11PM -0500, Amit Gud wrote:
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
> 
> What you do is keep tabs on whether you see damage that looks like
> this has occurred - e.g., inode use/free counts wrong, you had to zero
> a corrupted inode - and when this happens, you do a scan of all
> continuation inodes in chunks that have links to the corrupted chunk.
> What you need to make this go fast is (1) a pre-made list of which
> chunks have links with which other chunks, (2) a fast way to read all
> of the continuation inodes in a chunk (ignoring chunk-local inodes).
> This stage is O(fs size) approximately, but it should be quite swift.
  Do I get it right that you just have in each cnode a pointer to the
previous & next cnode? But then if two consecutive cnodes get corrupted,
you have no way to connect the chain, do you? If each cnode contained
some unique identifier of the file and a number identifying position of
cnode,  then there would be at least some way (through expensive) to
link them together correctly...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
