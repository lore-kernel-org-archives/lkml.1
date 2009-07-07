Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbZGGFXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbZGGFXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 01:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbZGGFXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 01:23:07 -0400
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:57076 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756477AbZGGFXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:23:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=d7TT0ADI6uXiOdTgnj19T9DFlGnovPEnVSiOeJ3alaYLx6q3f28wXNoaT1C+M4o2;
  h=Received:Cc:Message-Id:From:To:In-Reply-To:Content-Type:Content-Transfer-Encoding:Mime-Version:Subject:Date:References:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-Id: <E1DB0A3A-EDAC-4566-BAD5-15955ACDA36C@earthlink.net>
From: Mitchell Erblich <erblichs@earthlink.net>
To: David Rientjes <rientjes@google.com>
In-Reply-To: <alpine.DEB.2.00.0907062032450.29086@chino.kir.corp.google.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: Re : .... get_page_from_freelist : MInority Suggestion to accept GFP_NOFAIL accept during boot
Date: Mon, 6 Jul 2009 22:23:01 -0700
References: <61448F53-1F7A-47EF-AAF3-CB2A46AB8009@earthlink.net> <alpine.DEB.2.00.0907030155250.13657@chino.kir.corp.google.com> <3DE21B02-7ABA-4E56-961C-1DFB608DBE43@earthlink.net> <alpine.DEB.2.00.0907062032450.29086@chino.kir.corp.google.com>
X-Mailer: Apple Mail (2.930.3)
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec79013f51e9702f3dd8fc73ac7b1c9cf85b350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 98.234.127.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

	After this email, if you want to keep
	up the emails on this thread, then lets
	push it private.

	My arg was independent of mem / page order,
	and only was that IMO the OS infrastructure during
	bootup needs this FLAG.

	My assumption is via the buddy list that if an order fails
	that means all supported orders greater will then also
	fail. ie: assuming GFP_NOFAIL  and global mem:
	 Yes, we need SLEEP but knowing that ATOMICs
	are also failing COULD be interesting.

	So, maybe a log entry should be forced with ATOMICs and
	NOFAIL. Yes, limit output with repeat counts.

	Mitchell Erblich
	===============
	
	
On Jul 6, 2009, at 8:37 PM, David Rientjes wrote:

> On Mon, 6 Jul 2009, Mitchell Erblich wrote:
>
>> David,
>>
>> 		The web page http://lkml.indiana.edu/hypermail/linux/kernel/
>>
>> 		Looking at the thread of emails on June 24 at 11:07:23
>> 		upcoming kerneloops.org item: get_page_from_freelist
>>
>> 		We have code from Arjan de Van
>>
>> it's this warning in mm/page_alloc.c:
>>
>> * __GFP_NOFAIL is not to be used in new code.
>> *
>> * All __GFP_NOFAIL callers should be fixed so that they
>> * properly detect and handle allocation failures.
>> *
>> * We most definitely don't want callers attempting to
>> * allocate greater than single-page units with
>> * __GFP_NOFAIL.
>> */
>> WARN_ON_ONCE(order > 0);
>>
>
> [ That's actually Andrew's code and comment, which has since been  
> changed
>   to
>
> 	WARN_ON_ONCE(order > 1);
>
>   by Linus. ]
>
> Your suggestion to revert this "deprecation" doesn't make sense,  
> though,
> given the workarounds I mentioned earlier:
>
>> On Jul 3, 2009, at 2:01 AM, David Rientjes wrote:
>>
>>> I'm confused by your request because all allocations with orders  
>>> under
>>> PAGE_ALLOC_COSTLY_ORDER are inherently __GFP_NOFAIL and those that  
>>> are not
>>> can easily implement the same behavior in the caller:
>>>
>>> 	struct page *page;
>>> 	do {
>>> 		page = alloc_pages(...);
>>> 	} while (!page);
>>>
>>> Hopefully something could be done to ensure the next call to  
>>> alloc_pages()
>>> would be more likely to succeed, but __GFP_NOFAIL doesn't provide  
>>> that
>>> anyway.
>
> That means anything that less than or equal to PAGE_ALLOC_COSTLY_ORDER
> (order-3 allocations) will already loop endlessly, regardless of  
> whether
> __GFP_NOFAIL is passed to the page allocator or not.  Secondly, you  
> can
> use my code above to replicate the exact behavior of __GFP_NOFAIL in  
> the
> caller.
>
> In other words, the page allocator doesn't need to implement any  
> special
> handling for __GFP_NOFAIL.

