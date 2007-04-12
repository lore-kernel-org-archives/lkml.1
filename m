Return-Path: <linux-kernel-owner+w=401wt.eu-S1422708AbXDLFpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422708AbXDLFpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 01:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422714AbXDLFpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 01:45:18 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:46076 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422708AbXDLFpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 01:45:16 -0400
Message-ID: <461DC75B.8040200@cosmosbay.com>
Date: Thu, 12 Apr 2007 07:44:59 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH] make MADV_FREE lazily free memory
References: <461C6452.1000706@redhat.com> <461D6413.6050605@cosmosbay.com> <461D67A9.5020509@redhat.com>
In-Reply-To: <461D67A9.5020509@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 12 Apr 2007 07:45:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel a écrit :
> Eric Dumazet wrote:
>> Rik van Riel a écrit :
>>> Make it possible for applications to have the kernel free memory
>>> lazily.  This reduces a repeated free/malloc cycle from freeing
>>> pages and allocating them, to just marking them freeable.  If the
>>> application wants to reuse them before the kernel needs the memory,
>>> not even a page fault will happen.
> 
>> I dont understand this last sentence. If not even a page fault 
>> happens, how the kernel knows that the page was eventually reused by 
>> the application, and should not be freed in case of memory pressure ?
> 
> Before maybe freeing the page, the kernel checks the referenced
> and dirty bits of the page table entries mapping that page.
> 
>> ptr = mmap(some space);
>> madvise(ptr, length, MADV_FREE);
>> /* kernel may free the pages */
> 
> All this call does is:
> - clear the accessed and dirty bits
> - move the page to the far end of the inactive list,
>   where it will be the first to be reclaimed
> 
>> sleep(10);
>>
>> /* what the application must do know before reusing space ? */
>> memset(ptr, data, 10000);
>> /* kernel should not free ptr[0..10000] now */
> 
> Two things can happen here.
> 
> If this program used the pages before the kernel needed
> them, the program will be reusing its old pages.

ah ok, this is because accessed/dirty bits are set by hardware and not a page 
fault. Is it true for all architectures ?

> 
> If the kernel got there first, you will get page faults
> and the kernel will fill in the memory with new pages.

perfect

> 
> Both of these alternatives are transparent to userspace.
> 

Thanks a lot for these clarifications. This will fly :)
