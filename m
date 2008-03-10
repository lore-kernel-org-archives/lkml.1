Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbYCJAdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbYCJAdb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 20:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbYCJAdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 20:33:22 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:42812
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbYCJAdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 20:33:22 -0400
Date: Mon, 10 Mar 2008 01:33:18 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] reserve RAM below PHYSICAL_START
Message-ID: <20080310003318.GG2648@v2.random>
References: <20080227003325.GS28483@v2.random> <p73ve446lxx.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73ve446lxx.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Mon, Mar 03, 2008 at 01:17:46PM +0100, Andi Kleen wrote:
> Andrea Arcangeli <andrea@qumranet.com> writes:
> 
> > Hello,
> >
> > this patch allows to prevent linux from using the ram below
> > PHYSICAL_START.
> >
> > The "reserved RAM" can be mapped by virtualization software with to
> > create a 1:1 mapping between guest physical (bus) address and host
> > physical (bus) address.
> 
> Wouldn't it be easier if your virtualization software just marked
> that area reserved or unmapped in its e820 map? 
> 
> Of if you don't want that you can get the same result with mem=... 
> arguments (e.g commonly used by crash dumping) 

Would all bootloader and OS be capable of booting with a virtualized
e820 map that marks everything below 256M as reserved (an host needs
at least 256M of ram to avoid swapping if somebody tries to log in to
kde)? How would real mode dma run at all when the host is booted with
mem=256M? I didn't verify it in practice but before starting this, I
assumed that if it really works it would be mostly by luck... not the
ideal for a virtualization solution that aims to be generic.

The only bit that won't be generic will be page at address zero and
the trampoline page, but besides those 3 pages, all other ram below 1M
will be completely marked as available ram in the virtualized e820
map. And hopefully nobody does DMA to those 3 pages marked reserved in
the virtualized e820 map (the two trampoline pages can be moved just
before phys address 640k with a fully orthogonal patch to greatly
decrease the risk of bootloader issues, I'm deferring that patch until
I tested some bootloader/OS combination with the ~0x6000 address).

> Even if that was all not possible for some reason having CONFIG for this would
> seem unfortunate for me -- i don't think users really want specially
> compiled kernels for specific hypervisors. With paravirt Linux
> is trying to get away from that. Some runtime setup method
> would be much better.

You're right but the relocatable kernel only works if you relocate it
at very low addresses (see MODULES_VADDR/KERNEL_IMAGE_SIZE). I fixed
that for the compile-time approach I taken, but fixing that for the
relocatable kernel so the kernel can relocate itself to address 900M
physical before jumping long mode, requires many more changes,
including moving all memparse/strlout/vsprintf to arch/x86/boot to
compile it it 32bit so the kernel command line can be parsed in 32bit
non-paging mode to extract the relocation address, before jumping
paging long mode.

My compile time approach doesn't slowdown the kernel module
allocation, it remains a small and relatively simple change to the
e820 map code. Hopefully KVM pci-passthrough without VT-d is done in
standard setups so the compile time approach will not be a big
limitation. So from a mainline kernel point of view, given this is
only needed in the short term because currently sold CPUs lack VT-d
the smaller is the change to allow pci-passthrough, the better. The
relocatable approach would be a much bigger change. Also note this
only works up to address near 1G, we can't reserve more than 1G with
this (extending over 1G requires even more changes). But a 800-900M
guest with pci-passthrough is sure enough right now (extending this to
2G is very easy with an incremental patch, extending over 2G is not
easy).

And if you're right and we'll later find everybody needs
pci-passthrough on every new system without recompiling the host
kernel, we can always switch to a relocatable kernel without changing
the userland API at all (/proc/iomem will show "reserved RAM" and
"reserved RAM failed" the same way as today, kvm userland won't notice
the difference). So I wouldn't worry so much about this being a
compile time thing to start with, given this avoids polluting the
kernel for a short-term matter.

In fact the only thing I'd worry about _right_now_ is the fact there's
no API in /proc/iomem to mark "reserved RAM" regions as
"busy". However given you also need to be root to map from /dev/mem I
don't think it's a big deal.

Thanks for the comments.
