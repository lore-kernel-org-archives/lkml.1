Return-Path: <linux-kernel-owner+w=401wt.eu-S2992527AbXDLNOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992527AbXDLNOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 09:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992529AbXDLNOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 09:14:48 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:30435 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2992527AbXDLNOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 09:14:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=LTxqlby+/oAUFB2x8Ox6/zHJqG/fYSE9XZPepagGG0iE0a+vecV/3oOvmjrmljC1hLYxM94e7HRP+F/49u2yNXO37XvWdB1TmyWeiq4KAt5vBnMwRhthDzois8QwfX1yEH3QBnltFVas+fIbLw/SH3W4vWYMlxS9qb0OA2tiWrw=  ;
X-YMail-OSG: h97fZToVM1lQ3kxHdYof4puAX04yRSGIxJbme3GMpL0XhiA8
Message-ID: <461E30A6.5030203@yahoo.com.au>
Date: Thu, 12 Apr 2007 23:14:14 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH] make MADV_FREE lazily free memory
References: <461C6452.1000706@redhat.com> <461D6413.6050605@cosmosbay.com> <461D67A9.5020509@redhat.com> <461DC75B.8040200@cosmosbay.com> <461DCCEB.70004@yahoo.com.au> <461DCDDA.2030502@yahoo.com.au> <461DDE44.2040409@redhat.com>
In-Reply-To: <461DDE44.2040409@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Nick Piggin wrote:
> 
>> Nick Piggin wrote:
>>
>>> Eric Dumazet wrote:

>>>> ah ok, this is because accessed/dirty bits are set by hardware and 
>>>> not a page fault.
>>>
>>>
>>>
>>> No it isn't.
>>
>>
>> That is to say, it isn't required for correctness. But if the
>> question was about avoiding a fault, then yes ;)
> 
> 
> Making the pte clean also needs to clear the hardware writable
> bit on architectures where we do pte dirtying in software.
> 
> If we don't, we would have corruption problems all over the VM,
> for example in the code around pte_clean_one :)

Sure. Hence why I say that having hardware set a/d bits are not
required for correctness ;)

>> But as Linus recently said, even hardware handled faults still
>> take expensive microarchitectural traps.
> 
> 
> Nowhere near as expensive as a full page fault, though...

I don't doubt that. Do you know rough numbers?


> The lazy freeing is aimed at avoiding page faults on memory
> that is freed and later realloced, which is quite a common
> thing in many workloads.

I would be interested to see how it performs and what these
workloads look like, although we do need to fix the basic glibc and
madvise locking problems first.

The obvious concerns I have with the patch are complexity (versus
payoff), behaviour under reclaim, and behaviour when freed memory
isn't reallocated very quickly (eg. degrading cache performance).

We'll see, I guess...

-- 
SUSE Labs, Novell Inc.
