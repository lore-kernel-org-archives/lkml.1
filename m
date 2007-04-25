Return-Path: <linux-kernel-owner+w=401wt.eu-S2992683AbXDYKz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992683AbXDYKz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992680AbXDYKzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:55:25 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33941 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161869AbXDYKzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:55:20 -0400
Date: Wed, 25 Apr 2007 20:54:34 +1000
From: David Chinner <dgc@sgi.com>
To: Amit Gud <gud@ksu.edu>
Cc: Nikita Danilov <nikita@clusterfs.com>,
       David Lang <david.lang@digitalinsight.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       val_henson@linux.intel.com, riel@surriel.com, zab@zabbo.net,
       arjan@infradead.org, suparna@in.ibm.com, brandon@ifup.org,
       karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Message-ID: <20070425105434.GX32602149@melbourne.sgi.com>
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu> <17965.60841.900376.524639@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL> <462E7C47.8080604@ksu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462E7C47.8080604@ksu.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 04:53:11PM -0500, Amit Gud wrote:
> Nikita Danilov wrote:
> >Maybe I failed to describe the problem presicely.
> >
> >Suppose that all chunks have been checked. After that, for every inode
> >I0 having continuations I1, I2, ... In, one has to check that every
> >logical block is presented in at most one of these inodes. For this one
> >has to read I0, with all its indirect (double-indirect, triple-indirect)
> >blocks, then read I1 with all its indirect blocks, etc. And to repeat
> >this for every inode with continuations.
> >
> >In the worst case (every inode has a continuation in every chunk) this
> >obviously is as bad as un-chunked fsck. But even in the average case,
> >total amount of io necessary for this operation is proportional to the
> >_total_ file system size, rather than to the chunk size.
> >
> 
> Perhaps, I should talk about how continuation inodes are managed / 
> located on disk. (This is how it is in my current implementation)
> 
> Right now, there is no distinction between an inode and continuation 
> inode (also referred to as 'cnode' below), except for the 
> EXT2_IS_CONT_FL flag. Every inode holds a list of static number of 
> inodes, currently limited to 4.
> 
> The structure looks like this:
> 
>  ----------		----------
> | cnode 0  |---------->| cnode 0  |----------> to another cnode or NULL
>  ----------		----------
> | cnode 1  |-----      | cnode 1  |-----
>  ----------	|	----------	|
> | cnode 2  |-- |      | cnode 2  |--   |
>  ----------  | |	----------  |   |
> | cnode 3  | | |      | cnode 3  | |   |
>  ----------  | |	----------  |   |
> 	  |  |  |		 |  |   |
> 
> 	   inodes		inodes or NULL

How do you recover if fsfuzzer takes out a cnode in the chain? The
chunk is marked clean, but clearly corrupted and needs fixing and
you don't know what it was pointing at.  Hence you have a pointer to
a trashed cnode *somewhere* that you need to find and fix, and a
bunch of orphaned cnodes that nobody points to *somewhere else* in
the filesystem that you have to find. That's a full scan fsck case,
isn't?

It seems that any sort of damage to the underlying storage (e.g.
media error, I/O error or user brain explosion) results in the need
to do a full fsck and hence chunkfs gives you no benefit in this
case.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
