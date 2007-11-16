Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbXKPHDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbXKPHDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 02:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbXKPHC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 02:02:56 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60843 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017AbXKPHCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 02:02:55 -0500
Date: Thu, 15 Nov 2007 23:02:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Abhishek Rai" <abhishekrai@google.com>
Cc: "Andreas Dilger" <adilger@sun.com>, linux-kernel@vger.kernel.org,
       "Ken Chen" <kenchen@google.com>, "Mike Waychison" <mikew@google.com>
Subject: Re: [PATCH] Clustering indirect blocks in Ext3
Message-Id: <20071115230219.1fe9338c.akpm@linux-foundation.org>
In-Reply-To: <d9885f0f0711152102h7a8270bfvd65605d8c00e6754@mail.gmail.com>
References: <d9885f0f0711152102h7a8270bfvd65605d8c00e6754@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 21:02:46 -0800 "Abhishek Rai" <abhishekrai@google.com> wrote:

> (This patch was previously posted on linux-ext4 where Andreas Dilger
> offered some valuable comments on it).
> 
> This patch modifies the block allocation strategy in ext3 in order to
> improve fsck performance. This was initially sent out as a patch for
> ext2, but given the lack of ongoing development on ext2, I have
> crossported it to ext3 instead. Slow fsck is not a serious problem on
> ext3 due to journaling, but once in a while users do need to run full
> fsck on their ext3 file systems. This can be due to several reasons:
> (1) bad disk, bad crash, etc, (2) bug in jbd/ext3, and (3) every few
> reboots, it's good to run fsck anyway. This patch will help reduce
> full fsck time for ext3. I've seen 50-65% reduction in fsck time when
> using this patch on a near-full file system. With some fsck
> optimizations, this figure becomes 80%.
> 
> Most of Ext3 metadata is clustered on disk. For example, Ext3
> partitions the block space into block groups and stores the metadata
> for each block group (inode table, block bitmap, inode bitmap) at the
> beginning of the block group. Clustering related metadata together not
> only helps ext3 I/O performance by keeping data and related metadata
> close together, but also helps fsck since it is able to find all the
> metadata in one place. However, indirect blocks are an exception.
> Indirect blocks are allocated on-demand and are spread out along with
> the data. This layout enables good I/O performance due to the close
> proximity between an indirect block and its data blocks but it makes
> things difficult for fsck which must now rotate almost the entire disk
> in order to read all indirect blocks. In fact, our measurements have
> indicated that for most ext3 disks on which fsck takes a long time,
> >80% of the time is spent reading indirect blocks. So speeding up
> indirect block read accesses in fsck can significantly improve fsck
> times.
> 
> One solution to this problem implemented in this patch is to cluster
> indirect blocks together on a per group basis, similar to how inodes
> and bitmaps are clustered.

So we have a section of blocks around the middle of the blockgroup which
are used for indirect blocks.

Presmably it starts around 50% of the way into the blockgroup?

How do you decide its size?

What happens when it fills up but we still have room for more data blocks
in that blockgroup?

Can this reserved area cause disk space wastage (all data blocks used,
metacluster area not yet full).

The file data block allocator now needs to avoid allocating blocks from
inside this reserved area.  How is this implemented?  It is awfully similar
to the existing reservations code - does it utilise that code?

> Indirect block clusters (metaclusters) help
> fsck performance by enabling fsck to fetch all indirect blocks by
> reading from a few locations on the disk instead of rotating through
> the entire disk. Unfortunately, a naive clustering scheme for indirect
> blocks can hurt I/O performance, as it separates out indirect blocks
> and corresponding direct blocks on the disk. So an I/O to a direct
> block whose indirect block is not in the page cache now needs to incur
> a longer seek+rotational delay in moving the disk head from the
> indirect block to the direct block.
> 
> So our goal then is to implement metaclustering without having any
> impact (<0.1%) on I/O performance. Fortunately, current ext3 I/O
> algorithm is not the most efficient, improving it can camouflage the
> performance hit we suffer due to metaclustering. In fact,
> metaclustering automatically enables one such optimization. When doing
> sequential read from a file and reading an indirect block for it, we
> readahead several indirect blocks of the file from the same
> metacluster. Moreover, when possible we do this asynchronously. This
> reduces the seek+rotational latency associated with seeking between
> data and indirect blocks during a (long) sequential read.
> 
> There is one more design choice that affect the performance of this
> patch: location and number of metaclusters per block group. Currently
> we have one metacluster per block group and it is located at the
> center of the block group. We adopted this scheme after evaluating
> three possible locations of metaclusters: beginning, middle, and end
> of block group. We did not evaluate configurations with >1 metacluster
> per block group. In our experiments, the middle configuration did not
> cause any performance degradation for sequential and random reads.
> Whereas putting the metacluster at the beginning of the block group
> yields best performance for sequential reads (write performance is
> unaffected by this change), putting it in the middle helps random
> reads. Since the "middle path" maintains status quo, we adopted that
> in our change.
> 
> Performance evaluation results:
> Setup:
> RAM: 8GB
> Disk: 400GB disk.
> CPU: Dual core hyperthreaded
> 
> All measurements were taken 10 times or more until standard deviation
> was <2%. Machine was rebooted between runs and file system freshly
> formatted, also we made sure that there was nothing running on the
> machine at the time of the test.
> 
> Notation:
> - 'vanilla': regular ext3 without any changes
> - 'mc': metaclustering ext3
> 
> Benchmark 1: Sequential write to a 10GB file followed by 'sync'
> 1. vanilla:
>   Total: 3m9.0s
>   User: 0.08
>   System: 23s-48s (very high variance)

hm, system time variance is weird.  You might have found an ext3 bug (or a
cpu time accounting bug).

Excecution profiling would tell, I guess.

> 2. mc:
>   Total: 3m6.1s
>   User: 0.08s
>   System: 48.1s
>
> Benchmark 2: Sequential read from a 10GB file.
> Description: the file is created using same type of ext2 (mc or vanilla)
> 1. vanilla:
>   Total: 3m14.5s
>   User: 0.04s
>   System: 13.4s
> 2. mc:
>   Total: 3m14.5s
>   User: 0.04s
>   System: 13.3s
> 
> Benchmark 3: Random read from a 300GB file
> Description: read using 512 byte chunk total 5MB
> 1. vanilla:
>   Total: 3m56.4s
>   User: ~0
>   System: 0.6s
> 2. mc:
>   Total: 3m51.4s
>   User: ~0
>   System: 0.8s
> 
> Benchmark 4: Random read from a 300GB file
> Description: read using 512KB chunk total 1% size of the file
> 1. vanilla:
>   Total: 4m46.3s
>   User: ~0
>   System: 3.9s
> 2. mc:
>   Total: 4m44.4s
>   User: ~0
>   System: 3.9s
> 
> Benchmark 5: fsck
> Description: Prepare a newly formated 400GB disk as follows: create
> 200 files of 0.5GB each, 100 files of 1GB each, 40 files of 2.5GB ech,
> and 10 files of 10GB each. fsck command line: fsck -f -n
> 1. vanilla:
>   Total: 12m18.1s
>   User: 15.9s
>   System: 18.3s
> 2. mc:
>   Total: 4m47.0s
>   User: 16.0s
>   System: 17.1s
> 

They're large files.  It would be interesting to see what the numbers are
for more and smaller files.

> 
> Benchmark 6: kernbench (this was done on an 8cpu machine with 32GB RAM)
> 1. vanilla:
>   Elapsed: 35.60
>   User: 228.79
>   System: 21.10
> 2. mc:
>   Elapsed: 35.12
>   User: 228.47
>   System: 21.08
> 
> Note:
> 1. This patch does not affect ext3 on-disk layout compatibility in any
> way. Existing disks continue to work with new code, and disks modified
> by new code continue to work with existing machines. In contrast, the
> extents patch will also probably solve this problem but it breaks on-disk
> compatibility.
> 2. Metaclustering is a mount time option (-o metacluster). This option
> only affects the write path, when this option is specified indirect
> blocks are allocated in clusters, when it is not specified they are
> allocated alongside data blocks. The read path is unaffected by the
> option, read behavior depends on the data layout on disk - if read
> discovers metaclusters on disk it will do prefetching otherwise it
> will not.
> 3. e2fsck speedup with metaclustering varies from disk
> to disk with most benefit coming from disks which have a large number
> of indirect blocks. For disks which have few indirect blocks, fsck
> usually doesn't take too long anyway and hence it's OK not to deliver
> a huge speedup there. But in all cases, metaclustering doesn't cause
> any degradation in IO performance as seen in the benchmarks above.

Less speedup, for more-and-smaller files, it appears.

An important question is: how does it stand up over time?  Simply laying
files out a single time on a fresh fs is the easy case.  But what happens
if that disk has been in continuous create/delete/truncate/append usage for
six months?

> 
> [implementation]
>

We can get onto that later ;)

