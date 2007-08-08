Return-Path: <linux-kernel-owner+w=401wt.eu-S1760764AbXHHJHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764AbXHHJHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 05:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbXHHJG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 05:06:56 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:1838 "EHLO myri.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750993AbXHHJGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 05:06:55 -0400
X-Greylist: delayed 2390 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Aug 2007 05:06:54 EDT
Message-ID: <46B97E39.3020905@myri.com>
Date: Wed, 08 Aug 2007 04:26:33 -0400
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: =?ISO-8859-1?Q?C=E9dric_Augonnet?= <cedric.augonnet@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, brice@myri.com,
       cedric.augonnet@ens-lyon.org
Subject: Re: PAT support for i386 and x86_64
References: <f56c1ba00708061903r29baea3dj6b57032be5820983@mail.gmail.com> <20070807083004.GB30085@one.firstfloor.org>
In-Reply-To: <20070807083004.GB30085@one.firstfloor.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/2007 4:30 AM, Andi Kleen wrote:
> On Mon, Aug 06, 2007 at 10:03:15PM -0400, Cédric Augonnet wrote:
>   
>> Hi all,
>>
>> For quite a while now, there as been numerous attempt to introduce support for
>> Page Attribute Table (PAT) in the Linux kernel, whereas most other OS already
>> have some support for this feature. Such a proposition popping up periodically,
>> perhaps it would be an opportunity to fix that lack for once.
>>     
>
> The trouble is you need to avoid conflicting attributes, otherwise
> you risk cache corruption. This means the direct mapping needs to be fixed
> up and the kernel needs to keep track of the ranges to prevent conflicts.
>   




I don't see why we have to worry about cache corruption in the case at
hand. Write-combining is needed to map io (typically pci-mem regions)
which are never mapped cachable anywhere, including in the linear map.


If somebody for some reason needs to play with special attributes on
regular RAM for which inconsistent aliasing could be a problem:
- please explain why that consistency issue is mentioned in the context
of  write-combining/PAT: the problem already potentially exists through
the use of the _PAGE_PCD attribute, and having an extra WC choice should
not make the problem worse or better (note that with the initial patch
that WC/PAT combination is only exploited in pci_mmap_page_range() which
rightfully doesn't seem to care about cachable attribute consistency
anyway).



> Also when there is already a MTRR it might not work due to the complicated
> rules of MTRR<->PAT interaction.
>   



Some PAT<->MTRR cases are messy, but getting a WC type through PAT seems
to straightforwardly take precedence over any MTRR type, doesn't it?



> Then there are old CPU errata that need to be handled etc.
>   



We mentioned that point in the introduction of the patch. We have looked
at the documented PAT erratas that exists for the Pentium-II,
Pentium-III, Pentium-M, some early pentium-IV processors. While there
are minor variations for the description of the bug depending on the
processor, they all fit into the following description: "under some
circumstances the PAT bit might be ignored". The patch purposefully puts
write-combining at PAT6 so if the conditions are there for the errata 
to trigger, PAT2 (UC-) will be selected by the processor and the
corresponding accesses will simply be uncacheable instead of being
write-combining, which doesn't affect correctness.


We would certainly appreciate having any other erratas we missed
mentioned here for reference.


> There are also some other issues.
>   



Introducing something like ioremap_wc() or a "sfence" wmb_wc() was
excluded from the initial patch on purpose. It would be the logical next
step (but involves possible API driver extensions), so the proposed
patch was limited to making use of the new WC attribute by really
handling the write_combine argument of pci_mmap_page_range(). That
seemed to generate enough objections to start with.


There is at least one mostly cosmetic problem in the patch in
pci_mmap_page_range() where huge pages should not be a concern here.



> You didn't solve all that at all. If it was as simple as your patch
> we would have long done it already.


I am sorry, but after this and other messages on the list, I still don't
understand why a simple approach hasn't been made available already:
- the attribute consistency issue seems independant of using PAT to
create WC mappings (in particular the possibility of mixing by accident
WC and UC aliases has always existed, having broken driver make such
aliases through a new PAT-based attribute combination hardly changes
anything, same for mixing uncachable and cachable aliases,  new WC/PAT
combination doesn't change anything).


Sure there would some logical follow-up after a simple patch (like
providing a proper ioremap() interface, and maybe a new kind of barrier,
and handling the PAT bit properly in arch/x86/mm/pageattr.c, but those
follow-ups were purposefully excluded, and none seems very complex either).


So if there is any remaining issue on doing something "as simple as this
patch", please clarify it.


Best regards,


Loic


