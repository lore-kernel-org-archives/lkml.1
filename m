Return-Path: <linux-kernel-owner+w=401wt.eu-S965452AbXDLHXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965452AbXDLHXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 03:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965458AbXDLHXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 03:23:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965452AbXDLHX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 03:23:29 -0400
Message-ID: <461DDE44.2040409@redhat.com>
Date: Thu, 12 Apr 2007 03:22:44 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH] make MADV_FREE lazily free memory
References: <461C6452.1000706@redhat.com> <461D6413.6050605@cosmosbay.com> <461D67A9.5020509@redhat.com> <461DC75B.8040200@cosmosbay.com> <461DCCEB.70004@yahoo.com.au> <461DCDDA.2030502@yahoo.com.au>
In-Reply-To: <461DCDDA.2030502@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Nick Piggin wrote:
>> Eric Dumazet wrote:
>>
> 
>>>> Two things can happen here.
>>>>
>>>> If this program used the pages before the kernel needed
>>>> them, the program will be reusing its old pages.
>>>
>>>
>>>
>>> ah ok, this is because accessed/dirty bits are set by hardware and 
>>> not a page fault.
>>
>>
>> No it isn't.
> 
> That is to say, it isn't required for correctness. But if the
> question was about avoiding a fault, then yes ;)

Making the pte clean also needs to clear the hardware writable
bit on architectures where we do pte dirtying in software.

If we don't, we would have corruption problems all over the VM,
for example in the code around pte_clean_one :)

> But as Linus recently said, even hardware handled faults still
> take expensive microarchitectural traps.

Nowhere near as expensive as a full page fault, though...

The lazy freeing is aimed at avoiding page faults on memory
that is freed and later realloced, which is quite a common
thing in many workloads.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
