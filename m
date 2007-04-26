Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbXDZFFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbXDZFFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 01:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbXDZFFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 01:05:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35951 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754702AbXDZFFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 01:05:14 -0400
Date: Wed, 25 Apr 2007 22:05:12 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
Message-ID: <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007, Eric W. Biederman wrote:

> The page cache has no problems supporting things with a block
> size larger then page size.  Now the block device layer may not
> have the code to do the scatter gather into small pages and it
> may not handle buffer heads whose data is split between multiple
> pages. 

It does have that problem. If a system is in use then memory is fragmented
and requests to the devices are in 4k sizes. The kernel has to manage the 
4k size. The number of requests that the driver can take is limited. 
Larger blocks allow shuffling more data to the device.

> And generally larger physical pages are a mistake to use.
> Especially as it looks from some of the later comment you don't
> date test on 32bit because the memory fragments faster.

Ummm.. Dont get me to comment on i386. I never said that memory fragments 
faster on i386. i386 has multiple issues with memory management that 
require a lot of work and that will cause difficulty. If you have these
fun systems with 512k ZONE_NORMAL and 63GB HIGHMEM then good luck...

> Is it common for hardware that supports large block sizes to not
> support splitting those blocks apart during DMA?  Unless it is common
> the whole premise of this patchset seems broken.

Huh? Splitting the blocks requires hardware effort -> Reduction in 
transfer rate.
 
> I suspect what needs to be fixed is the page cache block device
> interface so that we have helper functions that know how to stuff
> a single block into several pages.

Oh we have scores of these hacks around. Look at the dvd/cd layer. The 
point is to get rid of those.

> Right now I don't even want to think about trying to use a swap device
> with a large block size when we are low on memory.

But that is due to the VM (at least Linus tree) having no defrag methods.
mm has Mel's antifrag methods and can do it.

> > 2. 32/64k blocksize is also used in flash devices. Same issues.
> 
> flash devices are not block devices so I strongly doubt it is
> the same issue.

But they could be treated as such. Right now these poor guys have to 
improvise around the page size limit.

> > 4. Reduce fsck times. Larger block sizes mean faster file system checking.
> 
> Fewer seeks and less meta-data means faster fsck times.  Larger block
> sizes get us there only tangentially.  

Less meta data to manage does not reduce fsck times? Going from order 0 to 
order 2 blocks cuts the metadata to a fourth.

> > 5. Performance. If we look at IA64 vs. x86_64 then it seems that the
> >    faster interrupt handling on x86_64 compensate for the speed loss due to
> >    a smaller page size (4k vs 16k on IA64). Supporting larger block sizes
> >    sizes on all allows a significant reduction in I/O overhead and increases
> >    the size of I/O that can be performed by hardware in a single request
> >    since the number of scatter gather entries are typically limited for
> >    one request. This is going to become increasingly important to support
> >    the ever growing memory sizes since we may have to handle excessively
> >    large amounts of 4k requests for data sizes that may become common
> >    soon. For example to write a 1 terabyte file the kernel would have to
> >    handle 256 million 4k chunks.
> 
> This assumes you get the option of large files and batching things as
> the systems scale.  At SGI maybe that is true.  However in general
> you gets lots of small requests as systems scale up.

Yes you get lots of small request *because* we do not support defrag and 
cannot large contiguous allocations.

> > 6. Cross arch compatibility: It is currently not possible to mount
> >    an 16k blocksize ext2 filesystem created on IA64 on an x86_64 system.
> >    With this patch this becoems possible.
> 
> Again this is a problem with the page cache block device interface not
> a page cache problem.

Ummm the other arches read 16k blocks of contigous memory. That is not 
supported on 4k platforms right now. I guess you you move those to vmalloc 
areas? Want to hack the filesystems for this?
 
> I think supporting larger block sizes is a nice goal.  However unless
> we are bumping up against hardware limitations let's see how far
> we can go with batching and fixing the block layer/page cache interface
> instead of assuming that larger page sizes are the answer.

There are multiple scaling issues in the kernel. What you propose is to 
add hack over hack into the VM to avoid having to deal with 
defragmentation. That in turn will cause churn with hardware etc etc.


