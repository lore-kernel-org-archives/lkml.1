Return-Path: <linux-kernel-owner+w=401wt.eu-S1423065AbXDXTez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423065AbXDXTez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423072AbXDXTey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:34:54 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:55237 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423065AbXDXTew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:34:52 -0400
From: Nikita Danilov <nikita@clusterfs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17966.23512.363955.141489@gargle.gargle.HOWL>
Date: Tue, 24 Apr 2007 23:34:48 +0400
To: David Lang <david.lang@digitalinsight.com>
Cc: Amit Gud <gud@cis.ksu.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, val_henson@linux.intel.com,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com,
       gud@ksu.edu
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
In-Reply-To: <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz>
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu>
	<17965.60841.900376.524639@gargle.gargle.HOWL>
	<Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz>
X-Mailer: VM 7.17 under 21.5 (patch 17) "chayote" (+CVS-20040321) XEmacs Lucid
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Lang writes:
 > On Tue, 24 Apr 2007, Nikita Danilov wrote:
 > 
 > > Amit Gud writes:
 > >
 > > Hello,
 > >
 > > >
 > > > This is an initial implementation of ChunkFS technique, briefly discussed
 > > > at: http://lwn.net/Articles/190222 and
 > > > http://cis.ksu.edu/~gud/docs/chunkfs-hotdep-val-arjan-gud-zach.pdf
 > >
 > > I have a couple of questions about chunkfs repair process.
 > >
 > > First, as I understand it, each continuation inode is a sparse file,
 > > mapping some subset of logical file blocks into block numbers. Then it
 > > seems, that during "final phase" fsck has to check that these partial
 > > mappings are consistent, for example, that no two different continuation
 > > inodes for a given file contain a block number for the same offset. This
 > > check requires scan of all chunks (rather than of only "active during
 > > crash"), which seems to return us back to the scalability problem
 > > chunkfs tries to address.
 > 
 > not quite.
 > 
 > this checking is a O(n^2) or worse problem, and it can eat a lot of memory in 
 > the process. with chunkfs you divide the problem by a large constant (100 or 
 > more) for the checks of individual chunks. after those are done then the final 
 > pass checking the cross-chunk links doesn't have to keep track of everything, it 
 > only needs to check those links and what they point to

Maybe I failed to describe the problem presicely.

Suppose that all chunks have been checked. After that, for every inode
I0 having continuations I1, I2, ... In, one has to check that every
logical block is presented in at most one of these inodes. For this one
has to read I0, with all its indirect (double-indirect, triple-indirect)
blocks, then read I1 with all its indirect blocks, etc. And to repeat
this for every inode with continuations.

In the worst case (every inode has a continuation in every chunk) this
obviously is as bad as un-chunked fsck. But even in the average case,
total amount of io necessary for this operation is proportional to the
_total_ file system size, rather than to the chunk size.

 > 
 > any ability to mark a filesystem as 'clean' and then not have to check it on 
 > reboot is a bonus on top of this.
 > 
 > David Lang

Nikita.
