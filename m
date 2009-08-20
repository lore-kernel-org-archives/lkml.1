Return-Path: <linux-kernel-owner+w=401wt.eu-S1753683AbZHTHD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbZHTHD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 03:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbZHTHD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 03:03:27 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:59703 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbZHTHD0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 03:03:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p9x3nj5Ol9+lI8To9paz2+Bp9Ze9FUPo59oeV9L4d/MaPSFmEiURi1lWo+oPtuTtp5
         DIqFBYX5Sfwy5vzQMNipgkvJLEpWntW4nQFgNOu0g0Vd1ESX8Ov5Jnc/AgkQWdZRP0tx
         TjToR6r1MwKj42Pac4l6FDHbT9Edx34ATt2KQ=
MIME-Version: 1.0
In-Reply-To: <20090819100553.GE24809@csn.ul.ie>
References: <alpine.LFD.2.00.0908172317470.32114@casper.infradead.org>
	 <56e00de0908180329p2a37da3fp43ddcb8c2d63336a@mail.gmail.com>
	 <202cde0e0908182248we01324em2d24b9e741727a7b@mail.gmail.com>
	 <20090819100553.GE24809@csn.ul.ie>
Date: Thu, 20 Aug 2009 19:03:28 +1200
Message-ID: <202cde0e0908200003w43b91ac3v8a149ec1ace45d6d@mail.gmail.com>
Subject: Re: [PATCH 0/3]HTLB mapping for drivers (take 2)
From: Alexey Korolev <akorolex@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Eric Munson <linux-mm@mgebm.net>, Alexey Korolev <akorolev@infradead.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel,

>> User level applications process the data.
>> Device is using a master DMA to send data to the user buffer, buffer
>> size can be >1GB and performance is very important. (So huge pages
>> mapping really makes sense.)
>>
>
> Ok, so the DMA may be faster because you have to do less scatter/gather
> and can DMA in larger chunks and and reading from userspace may be faster
> because there is less translation overhead. Right?
>
Less translation overhead is important. Unfortunately not all devices
have scatter/gather
(our case) as having it increase h/w complexity a lot.

>> In addition we have to mention that:
>> 1. It is hard for user to tell how much huge pages needs to be
>>    reserved by the driver.
>
> I think you have this problem either way. If the buffer is allocated and
> populated before mmap(), then the driver is going to have to guess how many
> pages it needs. If the DMA occurs as a result of mmap(), it's easier because
> you know the number of huge pages to be reserved at that point and you have
> the option of falling back to small pages if necessary.
>
>> 2. Devices add constrains on memory regions. For example it needs to
>>    be contiguous with in the physical address space. It is necessary to
>>   have ability to specify special gfp flags.
>
> The contiguity constraints are the same for huge pages. Do you mean there
> are zone restrictions? If so, the hugetlbfs_file_setup() function could be
> extended to specify a GFP mask that is used for the allocation of hugepages
> and associated with the hugetlbfs inode. Right now, there is a htlb_alloc_mask
> mask that is applied to some additional flags so htlb_alloc_mask would be
> the default mask unless otherwise specified.
>
Under contiguous I mean that we need several huge pages being
physically contiguous.
To obtain it we allocate pages till not find a contig. region
(success) or reach a boundary (fail).
So in our particular case approach based on getting pages from
hugetlbfs won't work
because memory region will not be contiguous.
However this approach will give an easy way to support hugetlb
mapping, it won't cause any complexity
in accounting. But it will be suitable for hardware with large amount
of sg regions only.

>
> How about;
>
>        o Extend Eric's helper slightly to take a GFP mask that is
>          associated with the inode and used for allocations from
>          outside the hugepage pool
>        o A helper that returns the page at a given offset within
>          a hugetlbfs file for population before the page has been
>          faulted.
Do you mean get_user_pages call?

Alexey
