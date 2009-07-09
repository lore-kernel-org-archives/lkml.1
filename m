Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbZGIGGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbZGIGGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 02:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbZGIGG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 02:06:26 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:64505 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbZGIGG0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 02:06:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MWI0OmA1pfjsY+S9m6MMciS+rW0PlxHyiCUMYomx8ALd6AM4ekPgXQzEvGbT0YbZVi
         xSnTPnVGrwQp1qS2IBhUColiqbk//SqtT3BJJ+KeDMcKtcxgzCujHpUkZhSATCf3ysaW
         9+E4S/RqU5tAbcmoH3n6bbKppn8RgKVmfOajQ=
MIME-Version: 1.0
In-Reply-To: <4A492E22.3060307@shipmail.org>
References: <1245931298.13359.8.camel@localhost.localdomain>
	 <21d7e9970906251700n5f5fbd07ke24022b576b1770b@mail.gmail.com>
	 <1246024775.2371.0.camel@localhost> <4A492E22.3060307@shipmail.org>
Date: Thu, 9 Jul 2009 16:06:24 +1000
Message-ID: <21d7e9970907082306p68105109g3b754972fe9c53fa@mail.gmail.com>
Subject: Re: TTM page pool allocator
From: Dave Airlie <airlied@gmail.com>
To: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
Cc: Jerome Glisse <glisse@freedesktop.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/30 Thomas Hellström <thomas@shipmail.org>:
> Jerome Glisse skrev:
>>
>> On Fri, 2009-06-26 at 10:00 +1000, Dave Airlie wrote:
>>
>>>
>>> On Thu, Jun 25, 2009 at 10:01 PM, Jerome Glisse<glisse@freedesktop.org>
>>> wrote:
>>>
>>>>
>>>> Hi,
>>>>
>>>> Thomas i attach a reworked page pool allocator based on Dave works,
>>>> this one should be ok with ttm cache status tracking. It definitely
>>>> helps on AGP system, now the bottleneck is in mesa vertex's dma
>>>> allocation.
>>>>
>>>>
>>>
>>> My original version kept a list of wb pages as well, this proved to be
>>> quite a useful
>>> optimisation on my test systems when I implemented it, without it I
>>> was spending ~20%
>>> of my CPU in getting free pages, granted I always used WB pages on
>>> PCIE/IGP systems.
>>>
>>> Another optimisation I made at the time was around the populate call,
>>> (not sure if this
>>> is what still happens):
>>>
>>> Allocate a 64K local BO for DMA object.
>>> Write into the first 5 pages from userspace - get WB pages.
>>> Bind to GART, swap those 5 pages to WC + flush.
>>> Then populate the rest with WC pages from the list.
>>>
>>> Granted I think allocating WC in the first place from the pool might
>>> work just as well since most of the DMA buffers are write only.
>>>
>>> Dave.
>>> --
>>>
>>
>> Attached a new version of the patch, which integrate changes discussed.
>>
>> Cheers,
>> Jerome
>>
>
> Hi, Jerome!
> Still some outstanding things:
>
> 1) The AGP protection fixes compilation errors when AGP is not enabled, but
> what about architectures that need the map_page_into_agp() semantics for TTM
> even when AGP is not enabled? At the very least TTM should be disabled on
> those architectures. The best option would be to make those calls non-agp
> specific.
>
> 2) Why is the page refcount upped with get_page() after an alloc_page()?
>
> 3) It seems like pages are cache-transitioned one-by-one when freed. Again,
> this is a global TLB flush per page. Can't we free a large chunk of pages at
> once?
>

Jerome,

have we addressed these?

I'd really like to push this soon, as I'd like to fix up the 32 vs 36
bit dma masks if possible
which relies on us being able to tell the allocator to use GFP_DMA32 on some hw
(32-bit PAE mainly with a PCI card).

Dave.
