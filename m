Return-Path: <linux-kernel-owner+w=401wt.eu-S2992862AbXDYROa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992862AbXDYROa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 13:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992864AbXDYROa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 13:14:30 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:47431 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S2992862AbXDYRO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 13:14:26 -0400
Date: Wed, 25 Apr 2007 09:39:34 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Nikita Danilov <nikita@clusterfs.com>
cc: Amit Gud <gud@cis.ksu.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, val_henson@linux.intel.com,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com,
       gud@ksu.edu
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
In-Reply-To: <17967.15531.450627.972572@gargle.gargle.HOWL>
Message-ID: <Pine.LNX.4.63.0704250924230.8669@qynat.qvtvafvgr.pbz>
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu><17965.6084
  1.900376.524639@gargle.gargle.HOWL><Pine.LNX.4.63.0704241123200.7701@qynat
 .qvtvafvgr.pbz><17966.23512.363955.141489@gargle.gargle.HOWL><Pine.LNX.4.63
 .0704241222110.7701@qynat.qvtvafvgr.pbz> <17967.15531.450627.972572@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007, Nikita Danilov wrote:

> David Lang writes:
> > On Tue, 24 Apr 2007, Nikita Danilov wrote:
> >
> > > David Lang writes:
> > > > On Tue, 24 Apr 2007, Nikita Danilov wrote:
> > > >
> > > > > Amit Gud writes:
> > > > >
> > > > > Hello,
> > > > >
> > > > > >
> > > > > > This is an initial implementation of ChunkFS technique, briefly discussed
> > > > > > at: http://lwn.net/Articles/190222 and
> > > > > > http://cis.ksu.edu/~gud/docs/chunkfs-hotdep-val-arjan-gud-zach.pdf
> > > > >
> > > > > I have a couple of questions about chunkfs repair process.
> > > > >
> > > > > First, as I understand it, each continuation inode is a sparse file,
> > > > > mapping some subset of logical file blocks into block numbers. Then it
> > > > > seems, that during "final phase" fsck has to check that these partial
> > > > > mappings are consistent, for example, that no two different continuation
> > > > > inodes for a given file contain a block number for the same offset. This
> > > > > check requires scan of all chunks (rather than of only "active during
> > > > > crash"), which seems to return us back to the scalability problem
> > > > > chunkfs tries to address.
> > > >
> > > > not quite.
> > > >
> > > > this checking is a O(n^2) or worse problem, and it can eat a lot of memory in
> > > > the process. with chunkfs you divide the problem by a large constant (100 or
> > > > more) for the checks of individual chunks. after those are done then the final
> > > > pass checking the cross-chunk links doesn't have to keep track of everything, it
> > > > only needs to check those links and what they point to
> > >
> > > Maybe I failed to describe the problem presicely.
> > >
> > > Suppose that all chunks have been checked. After that, for every inode
> > > I0 having continuations I1, I2, ... In, one has to check that every
> > > logical block is presented in at most one of these inodes. For this one
> > > has to read I0, with all its indirect (double-indirect, triple-indirect)
> > > blocks, then read I1 with all its indirect blocks, etc. And to repeat
> > > this for every inode with continuations.
> > >
> > > In the worst case (every inode has a continuation in every chunk) this
> > > obviously is as bad as un-chunked fsck. But even in the average case,
> > > total amount of io necessary for this operation is proportional to the
> > > _total_ file system size, rather than to the chunk size.
> >
> > actually, it should be proportional to the number of continuation nodes. The
> > expectation (and design) is that they are rare.
>
> Indeed, but total size of meta-data pertaining to all continuation
> inodes is still proportional to the total file system size, and so is
> fsck time: O(total_file_system_size).

correct, but remember that in the real world O(total_file_system_size) does not 
mean that it can't work well. it just means that larger filesystems will take 
longer to check.

they aren't out to eliminate the need for fsck, just to be able to divide the 
time it currently takes by a large value so that as the filesystems continue to 
get larger it is still reasonable to check them

> What is more important, design puts (as far as I can see) no upper limit
> on the number of continuation inodes, and hence, even if _average_ fsck
> time is greatly reduced, occasionally it can take more time than ext2 of
> the same size. This is clearly unacceptable in many situations (HA,
> etc.).

in a pathalogical situation you are correct, it would take longer. however 
before declaring that this is completely unacceptable why don't you wait and see 
if the pathalogical situation is at all likely?

when you are doing ha with shared storage you tend to be doing things like 
databases, every database that I know about splits it's data files into many 
pieces of a fixed size. Postgres for example does 1M files. if you do a chunk 
size of 1G it's very unlikly that more then a couple files out of every thousand 
will end up with continuation nodes.

remember that the current thinking on chunk size is to make the chunks be ~1% of 
your filesystem, so on a 1TB filesystem your chunk size would be 10G (which, in 
the example above would mean just a couple files out of every ten thousand would 
have continuation nodes).

with the current filesystems it's _possible_ for a file to be spread out across 
the disk such that it's first block is at the beginning of the disk, the second 
at the end of the disk, the third back at the beginning, the fourth at the end, 
etc. but users don't worry about this when useing the filesystems becouse the 
odds of this happening under normal use are vanishingly small (and the 
filesystem designers work to make the odds this small). similarly the chunkfs 
designers are working to make the odds of every file having a continuation nodes 
vanishingly small as well.

David Lang
