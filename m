Return-Path: <linux-kernel-owner+w=401wt.eu-S2992718AbXDYLeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992718AbXDYLeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992717AbXDYLeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:34:14 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:47377 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992701AbXDYLeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:34:12 -0400
From: Nikita Danilov <nikita@clusterfs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17967.15531.450627.972572@gargle.gargle.HOWL>
Date: Wed, 25 Apr 2007 15:34:03 +0400
To: David Lang <david.lang@digitalinsight.com>
Cc: Amit Gud <gud@cis.ksu.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, val_henson@linux.intel.com,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com,
       gud@ksu.edu
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Newsgroups: gmane.linux.kernel,gmane.linux.file-systems
In-Reply-To: <Pine.LNX.4.63.0704241222110.7701@qynat.qvtvafvgr.pbz>
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu>
	<17965.6084 1.900376.524639@gargle.gargle.HOWL>
	<Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz>
	<17966.23512.363955.141489@gargle.gargle.HOWL>
	<Pine.LNX.4.63.0704241222110.7701@qynat.qvtvafvgr.pbz>
X-Mailer: VM 7.17 under 21.5 (patch 17) "chayote" (+CVS-20040321) XEmacs Lucid
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Lang writes:
 > On Tue, 24 Apr 2007, Nikita Danilov wrote:
 > 
 > > David Lang writes:
 > > > On Tue, 24 Apr 2007, Nikita Danilov wrote:
 > > >
 > > > > Amit Gud writes:
 > > > >
 > > > > Hello,
 > > > >
 > > > > >
 > > > > > This is an initial implementation of ChunkFS technique, briefly discussed
 > > > > > at: http://lwn.net/Articles/190222 and
 > > > > > http://cis.ksu.edu/~gud/docs/chunkfs-hotdep-val-arjan-gud-zach.pdf
 > > > >
 > > > > I have a couple of questions about chunkfs repair process.
 > > > >
 > > > > First, as I understand it, each continuation inode is a sparse file,
 > > > > mapping some subset of logical file blocks into block numbers. Then it
 > > > > seems, that during "final phase" fsck has to check that these partial
 > > > > mappings are consistent, for example, that no two different continuation
 > > > > inodes for a given file contain a block number for the same offset. This
 > > > > check requires scan of all chunks (rather than of only "active during
 > > > > crash"), which seems to return us back to the scalability problem
 > > > > chunkfs tries to address.
 > > >
 > > > not quite.
 > > >
 > > > this checking is a O(n^2) or worse problem, and it can eat a lot of memory in
 > > > the process. with chunkfs you divide the problem by a large constant (100 or
 > > > more) for the checks of individual chunks. after those are done then the final
 > > > pass checking the cross-chunk links doesn't have to keep track of everything, it
 > > > only needs to check those links and what they point to
 > >
 > > Maybe I failed to describe the problem presicely.
 > >
 > > Suppose that all chunks have been checked. After that, for every inode
 > > I0 having continuations I1, I2, ... In, one has to check that every
 > > logical block is presented in at most one of these inodes. For this one
 > > has to read I0, with all its indirect (double-indirect, triple-indirect)
 > > blocks, then read I1 with all its indirect blocks, etc. And to repeat
 > > this for every inode with continuations.
 > >
 > > In the worst case (every inode has a continuation in every chunk) this
 > > obviously is as bad as un-chunked fsck. But even in the average case,
 > > total amount of io necessary for this operation is proportional to the
 > > _total_ file system size, rather than to the chunk size.
 > 
 > actually, it should be proportional to the number of continuation nodes. The 
 > expectation (and design) is that they are rare.

Indeed, but total size of meta-data pertaining to all continuation
inodes is still proportional to the total file system size, and so is
fsck time: O(total_file_system_size).

What is more important, design puts (as far as I can see) no upper limit
on the number of continuation inodes, and hence, even if _average_ fsck
time is greatly reduced, occasionally it can take more time than ext2 of
the same size. This is clearly unacceptable in many situations (HA,
etc.).

Nikita.
