Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbZBWHaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbZBWHaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 02:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbZBWHaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 02:30:18 -0500
Received: from gw.goop.org ([64.81.55.164]:41244 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbZBWHaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 02:30:17 -0500
Message-ID: <49A25086.30606@goop.org>
Date: Sun, 22 Feb 2009 23:30:14 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH RFC] vm_unmap_aliases: allow callers to inhibit TLB flush
References: <49416494.6040009@goop.org> <200902200441.08541.nickpiggin@yahoo.com.au> <499DAEE4.8010507@goop.org> <200902231514.01965.nickpiggin@yahoo.com.au>
In-Reply-To: <200902231514.01965.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Friday 20 February 2009 06:11:32 Jeremy Fitzhardinge wrote:
>   
>> Nick Piggin wrote:
>>     
>>> Then what is the point of the vm_unmap_aliases? If you are doing it
>>> for security it won't work because other CPUs might still be able
>>> to write through dangling TLBs. If you are not doing it for
>>> security then it does not need to be done at all.
>>>       
>> Xen will make sure any danging tlb entries are flushed before handing
>> the page out to anyone else.
>>
>>     
>>> Unless it is something strange that Xen does with the page table
>>> structure and you just need to get rid of those?
>>>       
>> Yeah.  A pte pointing at a page holds a reference on it, saying that it
>> belongs to the domain.  You can't return it to Xen until the refcount is 0.
>>     
>
> OK. Then I will remember to find some time to get the interrupt
> safe patches working. I wonder why you can't just return it to
> Xen when (or have Xen hold it somewhere until) the refcount
> reaches 0?
>   

It would still need to allocate a page in the meantime, which could fail 
because the domain has hit its hard memory limit (which will be the 
common case, because a domain generally starts with its full compliment 
of memory).   The nice thing about the exchange is that there's no 
accounting to take into account.

>>> Or... what if we just allow a compile and/or boot time flag to direct
>>> that it does not want lazy vmap unmapping and it will just revert to
>>> synchronous unmapping? If Xen needs lots of flushing anyway it might
>>> not be a win anyway.
>>>       
>> That may be worth considering.
>>     
>
> ... in the meantime, shall we just do this for Xen? It is probably
> safer and may end up with no worse performance on Xen anyway. If
> we get more vmap users and it becomes important, you could look at
> more sophisticated ways of doing this. Eg. a page could be flagged
> if it potentially has lazy vmaps.
>   

OK.  Do you want to do the patch, or shall I?

    J

