Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbXDZFp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbXDZFp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 01:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbXDZFp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 01:45:27 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56316 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbXDZFpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 01:45:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com>
	<m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com>
Date: Wed, 25 Apr 2007 23:44:17 -0600
In-Reply-To: <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com>
	(Christoph Lameter's message of "Wed, 25 Apr 2007 22:05:12 -0700
	(PDT)")
Message-ID: <m1abwvofke.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <clameter@sgi.com> writes:

> On Wed, 25 Apr 2007, Eric W. Biederman wrote:
>
>> The page cache has no problems supporting things with a block
>> size larger then page size.  Now the block device layer may not
>> have the code to do the scatter gather into small pages and it
>> may not handle buffer heads whose data is split between multiple
>> pages. 
>
> It does have that problem. If a system is in use then memory is fragmented
> and requests to the devices are in 4k sizes. The kernel has to manage the 
> 4k size. The number of requests that the driver can take is limited. 
> Larger blocks allow shuffling more data to the device.

I have a hard time believe that device hardware limits don't allow them
to have enough space to handle larger requests.  If so it was a poor
design by the hardware manufacturers.

>> And generally larger physical pages are a mistake to use.
>> Especially as it looks from some of the later comment you don't
>> date test on 32bit because the memory fragments faster.
>
> Ummm.. Dont get me to comment on i386. I never said that memory fragments 
> faster on i386. i386 has multiple issues with memory management that 
> require a lot of work and that will cause difficulty. If you have these
> fun systems with 512k ZONE_NORMAL and 63GB HIGHMEM then good luck...
>
>> Is it common for hardware that supports large block sizes to not
>> support splitting those blocks apart during DMA?  Unless it is common
>> the whole premise of this patchset seems broken.
>
> Huh? Splitting the blocks requires hardware effort -> Reduction in 
> transfer rate.

Splitting the blocks doesn't change the transfer effort one iota.
The bus pci/pcie/hypertransport already have block sizes below 4KB.
Reading a longer list of descriptors might slow things down, but I would
be surprised.

The physical medium is the primary disk bottleneck.

Thinking about it the fastest thing I can do with a filesystem or disk
is to not use it.  That is to cache it efficiently. Having page sized
chunks in my cache increases my caching efficiency.   Large order
pages work directly against my caching efficiency.

>> I suspect what needs to be fixed is the page cache block device
>> interface so that we have helper functions that know how to stuff
>> a single block into several pages.
>
> Oh we have scores of these hacks around. Look at the dvd/cd layer. The 
> point is to get rid of those.

Perhaps this is just a matter of cleaning them up so they are no
longer hacks?

You are trying to couple something that has no business being coupled
as it reduces the system usability when you couple them.

>> Right now I don't even want to think about trying to use a swap device
>> with a large block size when we are low on memory.
>
> But that is due to the VM (at least Linus tree) having no defrag methods.
> mm has Mel's antifrag methods and can do it.

This is fundamental.  Fragmentation when you multiple chunk sizes
cannot be solved without a the ability to move things in memory,
whereas it doesn't exist when you only have a single chunk size.

>> > 2. 32/64k blocksize is also used in flash devices. Same issues.
>> 
>> flash devices are not block devices so I strongly doubt it is
>> the same issue.
>
> But they could be treated as such. Right now these poor guys have to 
> improvise around the page size limit.

The reason they are different is that they have very different
fundamental properties.  Flash devices have essentially no seek time
so random access if fast.  However the have a maximum number of erases
per sector so you have to be careful to do wear leveling.  Flash
devices are distinctly different, and using the block layer for them
while they do not behave like block devices is the wrong thing to do.

>> > 4. Reduce fsck times. Larger block sizes mean faster file system checking.
>> 
>> Fewer seeks and less meta-data means faster fsck times.  Larger block
>> sizes get us there only tangentially.  
>
> Less meta data to manage does not reduce fsck times? Going from order 0 to 
> order 2 blocks cuts the metadata to a fourth.

I agree that less meta data helps.  But switching to extents can reduce the
meta data much more, and still doesn't penalize you for small files if
you have them.

>> > 5. Performance. If we look at IA64 vs. x86_64 then it seems that the
>> >    faster interrupt handling on x86_64 compensate for the speed loss due to
>> >    a smaller page size (4k vs 16k on IA64). Supporting larger block sizes
>> > sizes on all allows a significant reduction in I/O overhead and increases
>> >    the size of I/O that can be performed by hardware in a single request
>> >    since the number of scatter gather entries are typically limited for
>> >    one request. This is going to become increasingly important to support
>> >    the ever growing memory sizes since we may have to handle excessively
>> >    large amounts of 4k requests for data sizes that may become common
>> >    soon. For example to write a 1 terabyte file the kernel would have to
>> >    handle 256 million 4k chunks.
>> 
>> This assumes you get the option of large files and batching things as
>> the systems scale.  At SGI maybe that is true.  However in general
>> you gets lots of small requests as systems scale up.
>
> Yes you get lots of small request *because* we do not support defrag and 
> cannot large contiguous allocations.

Lots of small requests are fundamental.  If lots of small requests were
not fundamental we would gets large requests scatter gather requests.

>> > 6. Cross arch compatibility: It is currently not possible to mount
>> >    an 16k blocksize ext2 filesystem created on IA64 on an x86_64 system.
>> >    With this patch this becoems possible.
>> 
>> Again this is a problem with the page cache block device interface not
>> a page cache problem.
>
> Ummm the other arches read 16k blocks of contigous memory. That is not 
> supported on 4k platforms right now. I guess you you move those to vmalloc 
> areas? Want to hack the filesystems for this?

Freak no.  You teach the code how to have a block in multiple physical
pages. 


>> I think supporting larger block sizes is a nice goal.  However unless
>> we are bumping up against hardware limitations let's see how far
>> we can go with batching and fixing the block layer/page cache interface
>> instead of assuming that larger page sizes are the answer.
>
> There are multiple scaling issues in the kernel. What you propose is to 
> add hack over hack into the VM to avoid having to deal with 
> defragmentation. That in turn will cause churn with hardware etc
> etc.

No. I propose to avoid all designs that have the concept of
fragmentation.

There is an argument for having struct page control more than 4K
of memory even when the hardware page size is 4K.  But that is a
separate problem.  And by only having one size we still don't
get fragmentation.


Eric
