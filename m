Return-Path: <linux-kernel-owner+w=401wt.eu-S1763594AbXKPW1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763594AbXKPW1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 17:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934982AbXKPW1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 17:27:11 -0500
Received: from smtp-out.google.com ([216.239.45.13]:42615 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934800AbXKPW1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 17:27:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=K96hcyqO2754vbeoKpqhF1d9T/H1YNGfYp7wMpLpDfVAdUFjSeDCA/t+wh3n2/yxS
	3FO7J0n7lZcLdkfXCSXmQ==
Message-ID: <d9885f0f0711161427u3ab41741kf5a0dc58def30c0@mail.gmail.com>
Date: Fri, 16 Nov 2007 14:27:02 -0800
From: "Abhishek Rai" <abhishekrai@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Clustering indirect blocks in Ext3
Cc: "Andreas Dilger" <adilger@sun.com>, linux-kernel@vger.kernel.org,
       "Ken Chen" <kenchen@google.com>, "Mike Waychison" <mikew@google.com>
In-Reply-To: <20071115230219.1fe9338c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9885f0f0711152102h7a8270bfvd65605d8c00e6754@mail.gmail.com>
	 <20071115230219.1fe9338c.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 15, 2007 11:02 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu, 15 Nov 2007 21:02:46 -0800 "Abhishek Rai" <abhishekrai@google.com> wrote:
> > One solution to this problem implemented in this patch is to cluster
> > indirect blocks together on a per group basis, similar to how inodes
> > and bitmaps are clustered.
>
> So we have a section of blocks around the middle of the blockgroup which
> are used for indirect blocks.
>
> Presmably it starts around 50% of the way into the blockgroup?
>
> How do you decide its size?

There are couple of factors to consider when choosing a size:
1. The size cannot be too small, or the metacluster will fill up too
quickly and then we'll have to fall back to regular indirect block
allocation. E.g., if average file size of files in a block group is
512KB, a default block group having 32K blocks of size 4KB will need
~256 indirect blocks, one for each file.
2. If number of indirect blocks is too high, there will be less space
for data block allocation and so it'll make it more likely that we run
out of data blocks and start using blocks from the metacluster which
makes metaclustering useless.

Considering these factors, I think we should have <1% of blocks
reserved for the metacluster. The current patch uses (blocks_per_group
/ 128).

> What happens when it fills up but we still have room for more data blocks
> in that blockgroup?

Metaclustering is honored only as long as we have free data blocks and
free metacluster blocks. If we run out of either, we start using the
other. Of course, once that happens indirect blocks may not be
clustered anymore.

> Can this reserved area cause disk space wastage (all data blocks used,
> metacluster area not yet full).

No because of above reason.

> The file data block allocator now needs to avoid allocating blocks from
> inside this reserved area.  How is this implemented?  It is awfully similar
> to the existing reservations code - does it utilise that code?

It is actually much simpler than the reservation code, so I haven't
used it. The logic is implemented in <20 lines in
ext3_try_to_allocate().

>
> > Notation:
> > - 'vanilla': regular ext3 without any changes
> > - 'mc': metaclustering ext3
> >
> > Benchmark 1: Sequential write to a 10GB file followed by 'sync'
> > 1. vanilla:
> >   Total: 3m9.0s
> >   User: 0.08
> >   System: 23s-48s (very high variance)
>
> hm, system time variance is weird.  You might have found an ext3 bug (or a
> cpu time accounting bug).
>
> Excecution profiling would tell, I guess.

OK, I'll investigate this further.

> > Benchmark 5: fsck
> > Description: Prepare a newly formated 400GB disk as follows: create
> > 200 files of 0.5GB each, 100 files of 1GB each, 40 files of 2.5GB ech,
> > and 10 files of 10GB each. fsck command line: fsck -f -n
> > 1. vanilla:
> >   Total: 12m18.1s
> >   User: 15.9s
> >   System: 18.3s
> > 2. mc:
> >   Total: 4m47.0s
> >   User: 16.0s
> >   System: 17.1s
> >
>
> They're large files.  It would be interesting to see what the numbers are
> for more and smaller files.
>

kernbench below shows the behavior with small files. I'll also post
results from running
compilebench.

> >
> > Benchmark 6: kernbench (this was done on an 8cpu machine with 32GB RAM)
> > 1. vanilla:
> >   Elapsed: 35.60
> >   User: 228.79
> >   System: 21.10
> > 2. mc:
> >   Elapsed: 35.12
> >   User: 228.47
> >   System: 21.08
> >
> > Note:
> > 1. This patch does not affect ext3 on-disk layout compatibility in any
> > way. Existing disks continue to work with new code, and disks modified
> > by new code continue to work with existing machines. In contrast, the
> > extents patch will also probably solve this problem but it breaks on-disk
> > compatibility.
> > 2. Metaclustering is a mount time option (-o metacluster). This option
> > only affects the write path, when this option is specified indirect
> > blocks are allocated in clusters, when it is not specified they are
> > allocated alongside data blocks. The read path is unaffected by the
> > option, read behavior depends on the data layout on disk - if read
> > discovers metaclusters on disk it will do prefetching otherwise it
> > will not.
> > 3. e2fsck speedup with metaclustering varies from disk
> > to disk with most benefit coming from disks which have a large number
> > of indirect blocks. For disks which have few indirect blocks, fsck
> > usually doesn't take too long anyway and hence it's OK not to deliver
> > a huge speedup there. But in all cases, metaclustering doesn't cause
> > any degradation in IO performance as seen in the benchmarks above.
>
> Less speedup, for more-and-smaller files, it appears.

Not necessarily. If a lot of files use indirect blocks which happens when file
length >48KB on a 4KB blocksize file system, then we have a lot of
indirect blocks to read during fsck and hence this patch will be useful. But
if most files are <= 48KB, then the speedup is less/none of course.

>
> An important question is: how does it stand up over time?  Simply laying
> files out a single time on a fresh fs is the easy case.  But what happens
> if that disk has been in continuous create/delete/truncate/append usage for
> six months?

I'll post results of running compilebench shortly.

> >
> > [implementation]
> >
>
> We can get onto that later ;)
>
>
