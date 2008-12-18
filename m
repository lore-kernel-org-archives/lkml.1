Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753339AbYLRSYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbYLRSYr (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 13:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbYLRSYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 13:24:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:57801 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbYLRSYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 13:24:35 -0500
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xen-devel@lists.xensource.com, x86@kernel.org, ian.campbell@citrix.com,
        jbeulich@novell.com, joerg.roedel@amd.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Message-Id: <E5300CC0-1D08-46F7-91F6-DEC36202F1DE@kernel.crashing.org>
From: Becky Bruce <beckyb@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081218015705Z.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH 00 of 14] swiotlb/x86: lay groundwork for xen dom0 use of swiotlb
Date: Thu, 18 Dec 2008 12:17:54 -0600
References: <20081216203513.GA14787@elte.hu> <20081217142637V.fujita.tomonori@lab.ntt.co.jp> <4949296F.7000701@goop.org> <20081218015705Z.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 17, 2008, at 10:56 AM, FUJITA Tomonori wrote:

> On Wed, 17 Dec 2008 08:31:43 -0800
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>>> I think that the whole patchset is against the swiotlb design.  
>>> swiotlb
>>> is designed to be used as a library. Each architecture implements  
>>> the
>>> own swiotlb by using swiotlb library
>>> (e.g. arch/x86/kernel/pci-swiotlb_64.c).
>>>
>>
>> The whole patchset?  The bulk of the changes to lib/swiotlb.c are
>> relatively minor to remove the unwarranted assumptions it is making  
>> in
>> the face of a new user.  They will have no effect on other existing
>> users, including non-Xen x86 builds.
>>
>> If you have specific objections we can discuss those, but I don't  
>> think
>> there's anything fundamentally wrong with making lib/swiotlb.c a bit
>> more generically useful.
>
> Sorry, but the highmem support is not generically useful.
>
> I'm especially against the highmem support. As you said, the rest
> looks fine but if you go with pci-swiotlb_32.c, I think that you don't
> need the most of them.

>
>
>
>>> For example, adding the following code (9/14) for just Xen that the
>>> majority of swiotbl users (x86_64 and IA64) don't need to the  
>>> library
>>> is against the design.
>>>
>>
>> If the architecture doesn't support highmem then this code will  
>> compile
>> to nothing - PageHighMem() will always evaluate to 0.  It will  
>> therefore
>
> I'm not talking about it will be complied or not. As I wrote in
> another mail, I'm talking about the maintainability and readability of
> the common library.
>
>
>> have zero effect on the code generated for IA64 or x86-64.  This is  
>> not
>> really a Xen-specific change, but a result of adding swiotlb  
>> support for
>> i386.  Other architectures which support a notion of highmem would  
>> also
>> need this code if they wanted to use swiotlb.
>
> Can you be more specific? What architecture is plan to use highmem
> support in swiotlb?

32-bit powerpc needs this support - I was actually about to push a  
similar set of patches.  We have several processors that support 36  
bits of physical address space and do not have any iommu capability.   
The rest of the kernel support for those processors is now in place,  
so swiotlb is the last piece of the puzzle for that to be fully  
functional.  I need to take a closer look at this series to see  
exactly what it's doing and how it differs from what I've been testing.

So there is another immediate use case, and I'd really hate to see  
this code duplicated.  It should be entirely possible to remove the  
assumption that we can save off the VA of the original buffer, which  
is the thing that precludes HIGHMEM support, and still have nice  
readable, maintainable code.

Cheers,
-Becky

