Return-Path: <linux-kernel-owner+w=401wt.eu-S1764628AbYCDM6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764628AbYCDM6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764462AbYCDM6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:58:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45783 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764351AbYCDM6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:58:23 -0500
Date: Tue, 4 Mar 2008 13:57:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Roskin <proski@gnu.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Zan Lynx <zlynx@acm.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
Message-ID: <20080304125744.GF29777@elte.hu>
References: <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org> <1204304352.6767.21.camel@localhost> <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org> <1204305609.21719.16.camel@dv> <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org> <1204313978.2316.8.camel@dv> <20080229211513.GI27212@elte.hu> <1204324265.2316.70.camel@dv> <20080303105752.GA23594@elte.hu> <20080304003723.z79pcavdk4wgoc44@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304003723.z79pcavdk4wgoc44@webmail.spamcop.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Roskin <proski@gnu.org> wrote:

>>> ndiswrapper contains essentially two drivers in one - PCI and USB. 
>>> The PCI driver uses DMA, which should be a strong argument for 
>>> keeping it in the kernel.
>>
>> how exactly does it use DMA - how does it allocate the memory it 
>> later on DMAs into, and how does it typically program that DMA target 
>> - is there any control over that in the NDIS protocol - or will NDIS 
>> drivers just write random addresses to the mmio space and then the 
>> hardware does DMA to/from those addresses? [without the NDIS 
>> framework having any knowledge about the encoding of those bits?]
>
> Sorry for delay.  I'm really not sure.  The maintainer of ndiswrapper 
> is currently offline, and I'm just trying to take care of the basic 
> stuff.
>
> All I can say is NdisMAllocateSharedMemory maps to 
> dma_alloc_coherent(), and there are some references to scatter-gather 
> lists.  There is a call to dma_map_single(), which is ultimately 
> called by the Tx function net_dev->hard_start_xmit.
>
> I understand there is some control from NDIS.  At least it can request 
> memory available for DMA.

so ... i suspect the requirement would be for 
NdisMAllocateSharedMemory() to return a linear address that is DMA-able, 
and to properly map it to a physical address via dma_map_single(). I can 
see only one complication in pushing this to user-space: physical 
fragmentation of allocations. What are the typical buffer sizes that 
NDIS drivers request from the kernel? Is it frequently above 4K?

you could try to create a syscall-ish API towards the kernel that allows 
DMA, it would have the following functionality:

- allocate a piece of continuous memory and return its physical address
  plus its linear address as well and map the linear address into the
  user-space pagetables. This memory would be unfragmented on the 
  physical side.

you probably could even use/hack hugetlbfs right now to achieve 
something very similar. (hugetlbfs pages are unfragmented 2MB 
largepages)

if the NDIS API is done halfways right, then there's no need for any of 
these buffers to be in kernel-space and for the driver to run in kernel 
space.

i think someone should really try to push a known-well-behaving NDIS 
driver (for which a Linux driver exists too) down to user-space. NDIS 
has been around since Netware so it's a pretty well-understood driver 
model. And with an iommu it could all be made a safe sandbox as well (an 
NDIS device could never exit its sandbox).

	Ingo
