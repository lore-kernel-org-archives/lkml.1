Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbZF2VMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbZF2VMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 17:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbZF2VMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 17:12:07 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:45698 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771AbZF2VMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 17:12:07 -0400
Message-ID: <4A492E22.3060307@shipmail.org>
Date: Mon, 29 Jun 2009 23:12:02 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Jerome Glisse <glisse@freedesktop.org>
CC: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: TTM page pool allocator
References: <1245931298.13359.8.camel@localhost.localdomain>	 <21d7e9970906251700n5f5fbd07ke24022b576b1770b@mail.gmail.com> <1246024775.2371.0.camel@localhost>
In-Reply-To: <1246024775.2371.0.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jerome Glisse skrev:
> On Fri, 2009-06-26 at 10:00 +1000, Dave Airlie wrote:
>   
>> On Thu, Jun 25, 2009 at 10:01 PM, Jerome Glisse<glisse@freedesktop.org> wrote:
>>     
>>> Hi,
>>>
>>> Thomas i attach a reworked page pool allocator based on Dave works,
>>> this one should be ok with ttm cache status tracking. It definitely
>>> helps on AGP system, now the bottleneck is in mesa vertex's dma
>>> allocation.
>>>
>>>       
>> My original version kept a list of wb pages as well, this proved to be
>> quite a useful
>> optimisation on my test systems when I implemented it, without it I
>> was spending ~20%
>> of my CPU in getting free pages, granted I always used WB pages on
>> PCIE/IGP systems.
>>
>> Another optimisation I made at the time was around the populate call,
>> (not sure if this
>> is what still happens):
>>
>> Allocate a 64K local BO for DMA object.
>> Write into the first 5 pages from userspace - get WB pages.
>> Bind to GART, swap those 5 pages to WC + flush.
>> Then populate the rest with WC pages from the list.
>>
>> Granted I think allocating WC in the first place from the pool might
>> work just as well since most of the DMA buffers are write only.
>>
>> Dave.
>> --
>>     
>
> Attached a new version of the patch, which integrate changes discussed.
>
> Cheers,
> Jerome
>   
Hi, Jerome!
Still some outstanding things:

1) The AGP protection fixes compilation errors when AGP is not enabled, 
but what about architectures that need the map_page_into_agp() semantics 
for TTM even when AGP is not enabled? At the very least TTM should be 
disabled on those architectures. The best option would be to make those 
calls non-agp specific.

2) Why is the page refcount upped with get_page() after an alloc_page()?

3) It seems like pages are cache-transitioned one-by-one when freed. 
Again, this is a global TLB flush per page. Can't we free a large chunk 
of pages at once?

/Thanks,
Thomas






