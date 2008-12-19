Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbYLSFEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbYLSFEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 00:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbYLSFEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 00:04:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:59023 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbYLSFEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 00:04:44 -0500
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xen-devel@lists.xensource.com, x86@kernel.org, ian.campbell@citrix.com,
       jbeulich@novell.com, joerg.roedel@amd.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Message-Id: <3853A0F2-F817-4263-9EF9-9A0655BF95CD@kernel.crashing.org>
From: Becky Bruce <beckyb@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20081218210231.GB24271@elte.hu>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH 00 of 14] swiotlb/x86: lay groundwork for xen dom0 use of swiotlb
Date: Thu, 18 Dec 2008 23:03:05 -0600
References: <20081216203513.GA14787@elte.hu> <20081217142637V.fujita.tomonori@lab.ntt.co.jp> <4949296F.7000701@goop.org> <20081218015705Z.fujita.tomonori@lab.ntt.co.jp> <E5300CC0-1D08-46F7-91F6-DEC36202F1DE@kernel.crashing.org> <20081218210231.GB24271@elte.hu>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 18, 2008, at 3:02 PM, Ingo Molnar wrote:

>
> * Becky Bruce <beckyb@kernel.crashing.org> wrote:
>
>>> Can you be more specific? What architecture is plan to use highmem
>>> support in swiotlb?
>>
>> 32-bit powerpc needs this support - I was actually about to push a
>> similar set of patches.  We have several processors that support 36  
>> bits
>> of physical address space and do not have any iommu capability.  The
>> rest of the kernel support for those processors is now in place, so
>> swiotlb is the last piece of the puzzle for that to be fully  
>> functional.
>> I need to take a closer look at this series to see exactly what it's
>> doing and how it differs from what I've been testing.
>>
>> So there is another immediate use case, and I'd really hate to see  
>> this
>> code duplicated.  It should be entirely possible to remove the
>> assumption that we can save off the VA of the original buffer,  
>> which is
>> the thing that precludes HIGHMEM support, and still have nice  
>> readable,
>> maintainable code.
>
> you can have a look at Jeremy's current lineup of patches in
> tip/core/iotlb:
>
>   http://people.redhat.com/mingo/tip.git/README
>
> (also integrated into tip/master)
>
> What would be needed to make it suit your usecase too?

Ingo,

I've taken a quick look at the series posted to the list, and they're  
actually very similar to what I've done.  I think there are really  
only 3 fairly minor issues that need to be resolved to make this work  
on ppc:

1) We need to add swiotlb_map/unmap_page calls, as those are part the  
ppc dma_mapping_ops (in fact, we don't have map/unmap_single in the  
dma_mapping_ops struct on ppc anymore - those just call map/ 
unmap_page).  This is really just a matter of moving some code around  
and making some minor changes, as swiotlb_map/unmap_single can call  
swiotlb_map/unmap_page once the args have been converted.  There's a  
patch in my series that should make this pretty obvious.

2) To convert any address to/from a bus address, we also need the  
hwdev pointer passed as an argument since ppc supports a per-device  
offset accessed via the device ptr that is used to calculate the bus  
address.  I'd also given my conversion functions more generic names,  
as it seemed highly likely that these would eventually be useful  
outside of the swiotlb code.

3) powerpc uses enum dma_data_direction for the direction argument to  
its dma_ops, which is, from reading the kernel docs, the correct  
argument type for the DMA API functions.  However, the iotlb/x86/ia64  
code is currently using an int.  This causes a build warning when we  
initialize the dma_ops struct using the swiotlb funcs.  Is there a  
reason for the use of "int" in x86/ia64?  The Right Thing(TM) here  
seems to be to convert those over to using the enum, and I have a big  
patch that starts doing that, but I've probably missed some places.  I  
could instead do some hackery on the ppc side, and leave the other  
platforms alone, but I'd prefer to do it cleanly. Thoughts?

Unfortunately, this is horrible timing for me, as starting tomorrow,  
I'm going to be offline for a week and a half or so in podunk  
Louisiana with essentially no net access.  I can integrate my code  
into your tree and test on PPC as soon as I return to the real world.   
I'll go ahead and post my current patch series for reference, since  
I'm about to disappear - it's not been tested on anything other than  
powerpc (which is all I have for testing - it's highly likely I've  
done something that's bogus on x86), it needs some cleanup, and I've  
only built the entire series on x86_64 (not the individual pieces),  
but it should definitely give you an idea of what we need to make  
things work on ppc - the code is stable running LTP on a 2-core 32-bit  
MPC8641 board with 6GB of RAM.

Cheers,
Becky
