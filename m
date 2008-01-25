Return-Path: <linux-kernel-owner+w=401wt.eu-S1751922AbYAYA0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbYAYA0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 19:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYAYA0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 19:26:31 -0500
Received: from gw.goop.org ([64.81.55.164]:47098 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbYAYA0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 19:26:30 -0500
Message-ID: <47992CB2.8050606@goop.org>
Date: Thu, 24 Jan 2008 16:26:26 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Matt Mackall <mpm@selenic.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Keir Fraser <Keir.Fraser@cl.cam.ac.uk>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH UPDATE] x86: ignore spurious faults
References: <4797D64D.1060105@goop.org> <1201202046.3897.41.camel@cinder.waste.org> <4798E51C.4000209@goop.org> <200801251041.17392.nickpiggin@yahoo.com.au>
In-Reply-To: <200801251041.17392.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Friday 25 January 2008 06:21, Jeremy Fitzhardinge wrote:
>   
>> Matt Mackall wrote:
>>     
>>> There's perhaps an opportunity to do this lazy TLB trick in the mmap
>>> path as well, where RW mappings are initially mapped as RO so we can
>>> catch processes dirtying them and then switched to RW. If the mapping is
>>> shared across threads on multiple cores, we can defer synchronizing the
>>> TLBs on the others.
>>>       
>> I think spurious usermode faults are already dealt with.
>> handle_pte_fault() does essentially the same thing as this patch:
>>
>> 	if (ptep_set_access_flags(vma, address, pte, entry, write_access)) {
>> 		update_mmu_cache(vma, address, entry);
>> 	} else {
>> 		/*
>> 		 * This is needed only for protection faults but the arch code
>> 		 * is not yet telling us if this is a protection fault or not.
>> 		 * This still avoids useless tlb flushes for .text page faults
>> 		 * with threads.
>> 		 */
>> 		if (write_access)
>> 			flush_tlb_page(vma, address);
>> 	}
>>     
>
> I (obviously) don't know exactly how the TLB works in x86, but I
> thought that on a miss, the CPU walks the pagetables first before
> faulting? Maybe that's not the case if there is an RO entry
> actually in the TLB?
>   

My understanding is that it will fault immediately if there's a TLB 
entry, and rewalk the tables on return from the fault before restarting 
the instruction, so there's no need for an explicit TLB flush.  The TLB 
doesn't have a notion of negative cache entries, so any entry represents 
a present page of some variety.

    J
