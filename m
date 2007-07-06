Return-Path: <linux-kernel-owner+w=401wt.eu-S1762748AbXGFW1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762748AbXGFW1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 18:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757996AbXGFW05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 18:26:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756437AbXGFW04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 18:26:56 -0400
Date: Sat, 7 Jul 2007 00:26:51 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: linux-kernel@vger.kernel.org
Subject: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070706222651.GG5777@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

for the hack week at opensuse (see http://idea.opensuse.org/) I've
been working on a new feature called CONFIG_PAGE_SHIFT.

In the last few days while reading the topics of the VM summit I
answered I disliked the dependency on defrag for reliable I/O and I
suggested I had an alternative design being able to run static
binaries so far. So some discussion come up and I got request for
disclosing my stuff sooner than later. Frankly I wanted to do a bit
more of progress before posting it, because I'm still unsure if this
is totally good idea, the large part of the userland page fault
frequency reduction isn't implemented yet but OTOH I sure like it more
than everything else I've seen so far in this space, and I don't want
to hide it further after explicit requests to disclose from other vm
developers ;).

Some background:

The x86 and amd64 architectures only support a fixed 4k page size. The
smaller the page size, the lower amount of memory is wasted in
partially unused ram, but the slower the global performance is. The
next available hardware page size is 2M which is generally too big for
general purpose applications and the x86 ABI requires mmap offset
parameter to work with 4k granularity (amd64 abi fixes that problem
but apps have been written for the x86 ABI so we'd rather keep
supporting the 4k file offset granularity in mmap if we want to be
sure not to break backwards compatibility with userland, especially
for the 32bit compatibility mode).

While there's nothing we can do in software to alleviate the
_hardware_ related overhead of the 4k page size (like tlb caching and
frequency of the hardware pagetable walking), the 4k page size end up
hurting many purely software things.

The xfs developers for example want to enlarge their filesystem
blocksize (the filesystem blocksize has a tradeoff similar to the
PAGE_SIZE, the larger the faster the filesystem but more disk space is
potentially wasted), they also want to use the “normal” writeback
pagecache efficient behavior when using a writable fs on top of a
dvd-ram with an hardblocksize of 64k. But they can't on x86/amd64
because the PAGE_SIZE is still 4k and the whole linux kernel can't
handle more than a blocksize of PAGE_SIZE.

What they miss is that the problem with the 4k PAGE_SIZE isn't just
the maximum blocksize we can support (i.e. dvd with 64k hardblocksize)
but the _whole_ kernel (not only the storage/fs subsystems) is slower
because of the 4k thing. This starts from the page faults in a
memcpy() that are double the number than if this was a 8k page-size,
all the memory allocations (including slub/slab/blob/whatever) are
double or 4 fold or 8 fold the ones that would happen with a
8k/16k/32k page size.

So my whole idea is to once and for all to decuple the size of the
pte-entry (4k on x86/amd64) with the page allocator granularity. The
HARD_PAGE_SHIFT will be 4k still, the common code PAGE_SIZE will be
variable and configurable at compile time with CONFIG_PAGE_SHIFT.

I feel this need to happen at some point in the linux VM, since once
done I can't imagine any server running with a 4k page-size anymore. 

Rule number 1: the moment you need to relay on order > 0 allocations
for critical things like basic buffered I/O, you must make everything
an order >0 allocation and just boost the PAGE_SIZE. Only vm_pgoff and
other pte manipulations will be still indexed at the HARD_PAGE_SIZE,
all common code won't notice. The backwards compatibility is provided
by tracking vm_pgoff+((addr & ~PAGE_MASK) >> HARD_PAGE_SHIFT), see
hardpfn_offset_to_index. Thanks to anon-vma this should work for
anon+mremap too, even though I need to figure out some bits there
still but I don't see anything fundamentally different (anon-vma whole
point is to reduce the differences in that area and to allow doing on
anonymous memory anything we can do on pagecache). The pagecache side
already apparently works, it still needs a restart of the pagetable
walking loop over the PAGE_SHIFT-HARD_PAGE_SHIFT bits bounded by
vm_start >> HARD_PAGE_SHIFT, vm_end >> HARD_PAGE_SHIFT, so to reduce
all the page fault rate though. The pte unmapping may be severely
broken too.

Once finished, this should allow for a total backwards compatible
design without any aliasing in the pagecache (only the pte won't be
naturally aligned but that's ok, aliasing at the virtual level is a
fundamental property of the VM and it always happens).

This whole issue is really a pure tradeoff between memory consumption
and I/O and CPU performance (and for the dvd-ram and xfs also a way to
use larger hardblocksize), so being able to benchmark is the first
priority, if there's no significant benchmark gain this whole thing
may be a failure. I'm not talking the I/O bound side, the I/O side
performance boost is guaranteed (exactly the same as with the variable
order page cache).

64k is probably the ideal value for CONFIG_PAGE_SHIFT in db servers,
only 8 times faster in allocating ram but without huge ram waste and
especially optimal I/O size for ide (and better for scsi too of
course).

Comparison with “variable order page cache”: that tries to keep the
page allocator at 4k and changes the pagecache layer at order > 0
allocations. The major showstopper with their design is that there's
no way they can defrag reliably the kernel memory as long as any
driver is still allowed to run alloc_page(). Worst of all the
defragmenter will waste lots of cpu if it has an hard time to defrag,
so it's not a strightforward tradeoff and it has corner cases where
its underperformance will be hard to evaluate because it normally
won't trigger (even if in the best-case the I/O performance will be
good). Even worse if it eventually fails to defrag (no guarantees can
be made unless certain areas of memory are marked non generic) I/O
reliability will be decreased. So it would need at least a fallback to
order 0 to be really reliable.  And despite all the above downsides it
provides no advantage except being able to access devices with an
hard/soft blocksize larger than 4k (it only tackle on the I/O
performance with 4k fs, it hurts CPU performance if something). My
design solves their troubles (I/O performance) and at the same time it
boost the performance of everyone else too. It however requires
compiling a kernel with a special CONFIG_PAGE_SHIFT, but then you also
have to specially create xfs with a >4k blocksize so it seems a minor
issue (especially for the 1024 cpu systems ;), and in theory the
CONFIG_PAGE_SHIFT can also become a boot time parameter if we're ok to
waste quite some cycles at runtime.

The original idea of having a software page size larger than a
hardware page size, originated at SUSE by myself and Andi Kleen while
helping AMD to design their amd64 cpu, IIRC the conclusion was not to
worry too much about the 4k page size being too small because we could
make a soft-page-size if the time would come (or even a 2M PAGE_SIZE
kernel), it's just that at the time we thought we had to break
backwards compatibility (hence the ABI change in amd64 not requiring a
4k mmap offset alignment anymore), but I hope my current
improved/refined idea for the hack week of handling not naturally
aligned pages using the vm_pgoff indexed at HARD_PAGE_SIZE plus the
few bits between PAGE_SHIFT and HARD_PAGE_SHIFT of virtual address,
will not need to break anything anymore.

The following simple bench seems to run fine on one real hardware and
on kvm (a friend of mine failed so far to run it on his hardware
though, so perhaps some driver triggers some remaining bugs) when
booted as init=/tmp/bench-static after “cp -a /dev/hda /tmp/”.

#include <stdio.h>
#include <sys/time.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <assert.h> 

#define BUFSIZE (100*1024*1024) 

main() { 
      struct timeval before, after;
      int fd = open("/tmp/hda", O_RDONLY);
      unsigned long usec;
      char * c = malloc(BUFSIZE);
      assert(c);
      assert(fd > 2);
      for (;;) {
              gettimeofday(&before, NULL);
              if (read(fd, c, BUFSIZE) != BUFSIZE)
                      printf("errorn");
              gettimeofday(&after, NULL);
              lseek(fd, 0, 0);
              usec = (after.tv_sec - before.tv_sec)*1000000;
              usec += after.tv_usec - before.tv_usec;
              printf("%d usecn", usec);
      }
}

CONFIG_PAGE_SHIFT = 12 (default):

109770 usec
109673 usec

CONFIG_PAGE_SHIFT = 13 (8k page size)

108738 usec
108667 usec

Numbers are totally repeatable. Because I was too lazy at adapting the
anonymous memory page faults so far, the page coloring is guaranteed
the worst possible in the lowest significant bit of the page color,
but once I'll stop wasting gigantic amounts of ram over anon memory
and I'll reduce the page fault rate of 2 4 8 16 etc... times, the
anonymous memory will be automatically page-colored (for the first
time, actually not a perfect coloring but a better coloring for sure,
the larger the PAGE_SHIFT the better the coloring), so after that
there shouldn't be slowdowns anymore at the very large PAGE_SHIFT like
64 and over.

Max PAGE_SIZE supported is 8M, but implementation details in pgattr
will likely prevent to boot (now even to compile) with a page size
over 2M (easy to fix but going over 2M wasn't a short term
worry). Clearly once we reach those large PAGE_SIZE, it'll also be
possible to use the pmd to map the 'struct page' with a large tlb if
it has been mapped naturally aligned in the virtual address space.

If you want to help/look here the patch:

	http://www.kernel.org/pub/linux/kernel/people/andrea/patches/v2.6/2.6.22-rc7/hard-page-size

I'm tracking it with hg mq extension so far, but I can change if it
helps.

Thanks.
