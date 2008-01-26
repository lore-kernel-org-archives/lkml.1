Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbYAZA6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbYAZA6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 19:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbYAZA5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 19:57:52 -0500
Received: from gw.goop.org ([64.81.55.164]:50764 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbYAZA5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 19:57:51 -0500
Message-ID: <479A858B.6070102@goop.org>
Date: Fri, 25 Jan 2008 16:57:47 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, William Irwin <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 11 of 11] x86: defer cr3 reload when doing pud_clear()
References: <C3C0235A.12D8E%Keir.Fraser@cl.cam.ac.uk> <479A7A88.6010505@zytor.com>
In-Reply-To: <479A7A88.6010505@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Keir Fraser wrote:
>> On 25/1/08 22:54, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:
>>
>>> The only possibly relevant comment I can find in vol3a is:
>>>
>>>     Older IA-32 processors that implement the PAE mechanism use 
>>> uncached
>>>     accesses when loading page-directory-pointer table entries. This
>>>     behavior is
>>>     model specific and not architectural. More recent IA-32 
>>> processors may
>>>     cache page-directory-pointer table entries.
>>
>> Go read the Intel application note "TLBs, Paging-Structure Caches, 
>> and Their
>> Invalidation" at 
>> http://www.intel.com/design/processor/applnots/317080.pdf
>>
>> Section 8.1 explains about the PDPTR cache in 32-bit PAE mode, which can
>> only be refreshed by appropriate tickling of CR0, CR3 or CR4.
>>
>> It is also important to note that *any* valid page directory entry at 
>> *any*
>> level in the page-table hierarchy can become cached at *any* time. 
>> Basically
>> TLB lookup is performed as a longest-prefix match on the linear 
>> address to
>> skip as many levels in a page-table walk as possible (where a walk is
>> needed, because there is no full-length match on the linear address). 
>> So, if
>> you modify a directory entry from present to not-present, or change 
>> the page
>> directory that a valid pde points to, you probably need to flush the pde
>> caching structure. One piece of good news is that all pde caches are 
>> flushed
>> by any arbitrary INVLPG.
>>
>
> Actually, it's trickier than that.  The PDPTR, just like the segments, 
> aren't a real cache, and aren't invalidated by INVLPG.  This means you 
> can't go from less permissive to more permissive, which is normally 
> permitted in the x86.  The PDPTR should really be thought of as an 
> extended cr3 with four entries (this is also how it would be typically 
> implemented in hardware) rather than as a part of the paging structure 
> per se.

Yeah, that's basically what 8.1 says.  PAE doesn't follow the normal TLB 
rules for the top level, though they reserve the right to make it behave 
properly (as it would if you graft a PAE pagetable into a full 64-bit 
pagetable).


> Now, all of this reminds me of something somewhat messy: if we share 
> the kernel page tables for trampoline page tables, as discussed 
> elsewhere, we HAVE to do a complete, all-tlb-including-global-pages 
> flush after use, since the kernel pages are global and otherwise will 
> stick around.  Unlike the permissions pages, there aren't G enable 
> bits on the higher levels, but only for the PTEs themselves.

That wouldn't happen to often though, would it.  The identity mapping is 
only interested in a 1:1 view on RAM, and that's not going to change at 
all?  Does the TLB cache PAT attributes?  Do you need to do a global 
flush after changing a PTE's PAT bits to make sure that all that PTE's 
mappings have a consistent view on memory?

    J
