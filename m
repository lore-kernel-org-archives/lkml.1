Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752095AbYLRPqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbYLRPqm (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 10:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbYLRPqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 10:46:31 -0500
Received: from sh.osrg.net ([192.16.179.4]:39667 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbYLRPqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 10:46:30 -0500
Date: Fri, 19 Dec 2008 00:45:50 +0900
To: mingo@elte.hu
Cc: jeremy@goop.org, fujita.tomonori@lab.ntt.co.jp,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        x86@kernel.org, ian.campbell@citrix.com, jbeulich@novell.com,
        joerg.roedel@amd.com
Subject: Re: [PATCH 00 of 14] swiotlb/x86: lay groundwork for xen dom0 use
	of swiotlb
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081218132313.GE32135@elte.hu>
References: <20081218015705Z.fujita.tomonori@lab.ntt.co.jp>
	<49494BE4.1070408@goop.org>
	<20081218132313.GE32135@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081219004454D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008 14:23:13 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > FUJITA Tomonori wrote:
> >> On Wed, 17 Dec 2008 08:31:43 -0800
> >> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >>
> >>   
> >>>> I think that the whole patchset is against the swiotlb design. swiotlb
> >>>> is designed to be used as a library. Each architecture implements the
> >>>> own swiotlb by using swiotlb library
> >>>> (e.g. arch/x86/kernel/pci-swiotlb_64.c).
> >>>>         
> >>> The whole patchset?  The bulk of the changes to lib/swiotlb.c are  
> >>> relatively minor to remove the unwarranted assumptions it is making 
> >>> in the face of a new user.  They will have no effect on other 
> >>> existing users, including non-Xen x86 builds.
> >>>
> >>> If you have specific objections we can discuss those, but I don't 
> >>> think there's anything fundamentally wrong with making lib/swiotlb.c 
> >>> a bit more generically useful.
> >>>     
> >>
> >> Sorry, but the highmem support is not generically useful.
> >>   
> >
> > That's a circular argument.  lib/swiotlb currently used by 1 1/2 of the 
> > 23 architectures, neither of which happens to use highmem.  If you 
> > consider swiotlb to be a general purpose mechanism, then presumably the 
> > other 21 1/2 architectures are at least potential users (and 6 1/2 of 
> > those have highmem configurations).  If you base your judgement of 
> > what's a "generically useful" change based on what the current users 
> > need, then you'll naturally exclude the requirements of all the other 
> > (potential) users.
> >
> > And the matter arises now because we're trying to unify the use of 
> > swiotlb in x86, bringing the number of users up to 2.
> >
> >> I'm especially against the highmem support. As you said, the rest looks 
> >> fine but if you go with pci-swiotlb_32.c, I think that you don't need 
> >> the most of them.
> >>   
> >
> > I really don't want to have to duplicate a lot of code just to 
> > incorporate a few small changes.  In fact the original Xen patch set 
> > included its own swiotlb implementation, and that was rejected on the 
> > grounds that we should use the common swiotlb.c.
> 
> duplicating that would not be a very good design - and 32-bit highmem is a 
> reality we have to live with for some time to come. The impact:
> 
>    10 files changed, 251 insertions(+), 81 deletions(-)

It's not about the number of the lines. For example, X86_64 and IA64
have to use the following ugly code:

+static struct swiotlb_phys_addr swiotlb_bus_to_phys_addr(char *dma_addr)
+{
+	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
+	struct swiotlb_phys_addr buffer = io_tlb_orig_addr[index];
+	buffer.offset += (long)dma_addr & ((1 << IO_TLB_SHIFT) - 1);
+	buffer.page += buffer.offset >> PAGE_SHIFT;
+	buffer.offset &= PAGE_SIZE - 1;
+	return buffer;
+}

Why do they suffers such code even if they don't need it at all?


> looks rather to the point and seems relatively compressed. In fact 32-bit 
> Xen could end up being the largest user (and tester) of swiotlb facilities 
> in general, as modern 64-bit platforms tend to have hw IOMMUs.

I don't think so. Yes, modern 64-bit platforms tend to have hw IOMMUs
but I think that the majority don't use it. The modern I/O devices
(such as HBA) are capable of 64bit address DMA. So if you don't use
virtualization, you don't want IOMMU overheads (software and
hardware). So I think that 32-bit Xen is a fringe user of swiotlb.


> Having more code sharing and more testers is a plus.

If you read the patch (such as the above code), it unnecessarily adds
huge complicity to X86_64 and IA64. It just hurts stability,
readability and maintainability. There is no plus.

If multiple architectures need highmem in swiotlb, adding it to
lib/swiotlb.c makes sense. But what Xen people insist is, we should be
prepare for unlikely events, such as 'x86_64 would want to support
highmem' and they have no idea about who but we should be prepare for
someone who could use it.

I believe that adding ugly complicity to the generic code for unlikely
events is a bad idea.

I don't insist that Xen people need to duplicate all the swiotlb
code. It's fine to make it usable for x86. But I'm against adding the
code that only x86 uses to lib/swiotlb.c. That's should be in
arch/x86/pci-swiotlb_32.c. We already have
arch/x86/pci-swiotlb_64.c. If you add the code that only x86_32 use to
the generic library code (lib/swiotlb.c), why do we have
arch/x86/pci-swiotlb_64.c?


I know that you will merge the patchset anyway but I'm strongly
against the highmem patch.
