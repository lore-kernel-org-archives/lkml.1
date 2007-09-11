Return-Path: <linux-kernel-owner+w=401wt.eu-S1764021AbXIKMFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764021AbXIKMFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 08:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762929AbXIKMFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 08:05:19 -0400
Received: from ns2.suse.de ([195.135.220.15]:37877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762878AbXIKMFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 08:05:17 -0400
Date: Tue, 11 Sep 2007 14:05:13 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070911120513.GA10328@v2.random>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709110452.20363.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 04:52:19AM +1000, Nick Piggin wrote:
> The idea that there even _is_ a bug to fail when higher order pages
> cannot be allocated was also brushed aside by some people at the
> vm/fs summit. I don't know if those people had gone through the
> math about this, but it goes somewhat like this: if you use a 64K
> page size, you can "run out of memory" with 93% of your pages free.
> If you use a 2MB page size, you can fail with 99.8% of your pages
> still free. That's 64GB of memory used on a 32TB Altix.
> 
> If you don't consider that is a problem because you don't care about
> theoretical issues or nobody has reported it from running -mm

MM kernels also forbids mmap, so there's no chance the largepages are
mlocked etc... that's not the final thing that is being measured.

> kernels, then I simply can't argue against that on a technical basis.
> But I'm totally against introducing known big fundamental problems to
> the VM at this stage of the kernel. God knows how long it takes to ever
> fix them in future after they have become pervasive throughout the 
> kernel.

Seconded.

> IMO the only thing that higher order pagecache is good for is a quick
> hack for filesystems to support larger block sizes. And after seeing it
> is fairly ugly to support mmap, I'm not even really happy for it to do
> that.

Additionally I feel the ones that will get the main advantage from the
quick hack are the crippled devices that are ~30% slower if the SG
tables are large.

> If VM scalability is a problem, then it needs to be addressed in other
> areas anyway for order-0 pages, and if contiguous pages helps IO
> scalability or crappy hardware, then there is nothing stopping us from

Yep.

> *attempting* to get contiguous memory in the current scheme.
> 
> Basically, if you're placing your hopes for VM and IO scalability on this,
> then I think that's a totally broken thing to do and will end up making
> the kernel worse in the years to come (except maybe on some poor
> configurations of bad hardware).

Agreed. From my part I am really convinced the only sane way to
approach the VM scalability and larger-physically contiguous pages
problem is the CONFIG_PAGE_SHIFT patch (aka large PAGE_SIZE from Hugh
for 2.4). I also have to say I always disliked the PAGE_CACHE_SIZE
definition too ;). I take it only as an attempt to documentation.

Furthermore all the issues with writeprotect faults over MAP_PRIVATE
regions will have to be addressed the same way with both approaches if
we want real 100% 4k-granular backwards compatibility.

On this topic I'm also going to suggest the cpu vendors to add a 64k
tlb using the reserved 62th bitflag in the pte (right after the NX
bit). So if alignment allows we can map pagecache with a 64k large tlb
on x86 (with a PAGE_SIZE of 64k), mixing it with the 4k tlb in the
same address space if userland alignment forbids using the 64k tlb. If
we want to break backwards compatibility and force all alignments on
64k and get rid of any 4k tlb to simplify the page fault code we can
do it later anyway... No idea if this feasible to achieve on the
hardware level though, it's not my problem anyway to judge this ;). As
constraints to the hardware interface it would be ok to require the
62th 64k-tlb bitflag to be only available on the pte that would have
normally mapped a physical address 64k naturally aligned, and to
require all later overlapping 4k ptes to be set to 0. If you've better
ideas to achieve this than my interface please let me know.

And if I'm terribly wrong and the variable order pagecache is the way
to go for the long run, the 64k tlb feature will fit in that model
very nicely too.

The reason of the 64k magic number is that this is the minimum unit of
contiguous I/O required to reach platter speed on most devices out
there. And it incidentally also matches ppc64 ;).
