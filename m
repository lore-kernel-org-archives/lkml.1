Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbYC1D0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbYC1D0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 23:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYC1D02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 23:26:28 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53370 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752003AbYC1D01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 23:26:27 -0400
Date: Thu, 27 Mar 2008 20:24:22 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com>
References: <200803272353.51901.rjw@sisk.pl>
 <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008, Linus Torvalds wrote:

> 
> 
> On Thu, 27 Mar 2008, Rafael J. Wysocki wrote:
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9412
> > Subject		: commit a878539ef994787c447a98c2e3ba0fe3dad984ec breaks boot on SB600 AHCI
> > Submitter	: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
> > Date		: 2008-03-12 17:15 (16 days old)
> > Handled-By	: Jeff Garzik <jgarzik@pobox.com>
> > 		  Richard Zhao <richard.zhao@amd.com>
> 
> Fixed by 4cde32fc4b32e96a99063af3183acdfd54c563f0, methinks.
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9962
> > Subject		: mount: could not find filesystem
> > Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> > Date		: 2008-02-12 14:34 (45 days old)
> > References	: http://lkml.org/lkml/2008/2/12/91
> > Handled-By	: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > 		  Yinghai Lu <yhlu.kernel@gmail.com>
> 
> Needs more info. The original oops that opened it is fixed, but..
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9976
> > Subject		: BUG: 2.6.25-rc1: iptables postrouting setup causes oops
> > Submitter	: Ben Nizette <bn@niasdigital.com>
> > Date		: 2008-02-12 12:46 (45 days old)
> > References	: http://lkml.org/lkml/2008/2/12/148
> > Handled-By	: Haavard Skinnemoen <hskinnemoen@atmel.com>
> 
> This one seems gone (and was apparently AVR-only):
> 
> http://lkml.org/lkml/2008/2/13/607:
>   "What ever the problem is it isn't immediately apparent in latest git so
>    I guess we'll just have to keep our eyes peeled."
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9978
> > Subject		: 2.6.25-rc1: volanoMark regression
> > Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > Date		: 2008-02-13 10:30 (44 days old)
> > References	: http://lkml.org/lkml/2008/2/13/128
> > 		  http://lkml.org/lkml/2008/3/12/52
> > 		  http://lkml.org/lkml/2008/3/18/81
> > Handled-By	: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > 		  Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> Hmm. It is a regression on one machine (2x quad-core stoakley), but not 
> another (4x quad-core tigerton).
> 
> Interestingly, the stoakley box numbers have apparently been all over the 
> map.
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10318
> > Subject		: WARNING: at arch/x86/mm/highmem_32.c:43 kmap_atomic_prot+0x87/0x184()
> > Submitter	: Pawel Staszewski <pstaszewski@artcom.pl>
> > Date		: 2008-03-25 02:50 (3 days old)
> 
> Andrew and seems to have debugged this down to a kzalloc(GFP_ATOMIC) or 
> similar.

Slab allocations can never use GFP_HIGHMEM. Slab allocators BUG 
if either of these bits are set (checks on the slowpaths):

#define GFP_SLAB_BUG_MASK (__GFP_DMA32|__GFP_HIGHMEM|~__GFP_BITS_MASK)

GFP flags are not masked/checked if either inline fallback to the page 
allocator occurs (SLUB for >4k allocs) or if an allocation is forwarded
to the page allocator (SLOB, SLUB). They are also not checked on the 
fastpaths.


AFAICT the check in kmap_atomic_prot is simply too strict.

void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t 
prot)
{
        enum fixed_addresses idx;
        unsigned long vaddr;
        /* even !CONFIG_PREEMPT needs this, for in_atomic in do_page_fault */

        debug_kmap_atomic_prot(type);

        pagefault_disable();

        if (!PageHighMem(page))
                return page_address(page);


The check for PageHighMem(page) needs to either come before the 
debug_kmap_atomic_prot() or kmap_atomic_prot should only be called for 
HIGHMEM allocations. Otherwise any get_zeroed_page() alloc from an 
interrupt context may cause a false positive here.

Seems to be a reoccurrence of something that I discussed with Andrew a 
while back.

http://marc.info/?t=118790336700011&r=1&w=2
