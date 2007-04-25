Return-Path: <linux-kernel-owner+w=401wt.eu-S2992729AbXDYLij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992729AbXDYLij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992726AbXDYLij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:38:39 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:48763 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992723AbXDYLih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:38:37 -0400
Date: Wed, 25 Apr 2007 05:38:34 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: David Chinner <dgc@sgi.com>
Cc: Amit Gud <gud@ksu.edu>, Nikita Danilov <nikita@clusterfs.com>,
       David Lang <david.lang@digitalinsight.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       val_henson@linux.intel.com, riel@surriel.com, zab@zabbo.net,
       arjan@infradead.org, suparna@in.ibm.com, brandon@ifup.org,
       karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Message-ID: <20070425113834.GT5967@schatzie.adilger.int>
Mail-Followup-To: David Chinner <dgc@sgi.com>,
	Amit Gud <gud@ksu.edu>, Nikita Danilov <nikita@clusterfs.com>,
	David Lang <david.lang@digitalinsight.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	val_henson@linux.intel.com, riel@surriel.com, zab@zabbo.net,
	arjan@infradead.org, suparna@in.ibm.com, brandon@ifup.org,
	karunasagark@gmail.com
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu> <17965.60841.900376.524639@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL> <462E7C47.8080604@ksu.edu> <20070425105434.GX32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425105434.GX32602149@melbourne.sgi.com>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 25, 2007  20:54 +1000, David Chinner wrote:
> On Tue, Apr 24, 2007 at 04:53:11PM -0500, Amit Gud wrote:
> > Right now, there is no distinction between an inode and continuation 
> > inode (also referred to as 'cnode' below), except for the 
> > EXT2_IS_CONT_FL flag. Every inode holds a list of static number of 
> > inodes, currently limited to 4.
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

Presumably, the cnodes in the other chunks contain forward and back
references.  Those need to contain at minimum inode + generation + chunk
to avoid problem of pointing to a _different_ inode after such corruption
caused the old inode to be deleted and a new one allocated in its place.

If the cnode in each chunk is more than just a singly-linked list, the
file as a whole could survive multiple chunk corruptions, though there
would now be holes in the file.

> It seems that any sort of damage to the underlying storage (e.g.
> media error, I/O error or user brain explosion) results in the need
> to do a full fsck and hence chunkfs gives you no benefit in this
> case.

There are several cases where such corruption could be found:
- file access from the "parent" cnode will be missing corrupted cnode,
  probably causing a fsck of both the source and target chunks
- a fsck of the source chunk would find the dangling cnode reference
  and cause a fsck of the corrupt chunk
- a fsck of the later cnode chunks would find the dangling cnode reference
  and cause a fsck of the corrupt chunk
- a fsck of the corrupt chunk would find the original corruption

The case where only a fsck of the corrupt chunk is done would not find the
cnode references.  Maybe there needs to be per-chunk info which contains
a list/bitmap of other chunks that have cnodes shared with each chunk?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

