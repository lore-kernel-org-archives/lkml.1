Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbXEGLJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbXEGLJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 07:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932526AbXEGLJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 07:09:58 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:21272 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbXEGLJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 07:09:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=CQWUixGs4VdyW64+4+hN5W4/rcX5X2gAUUClLGtRQlqdRgDk6nmNC9R6B1L8wE2p83nseBt3O/A1pPVO3Gxx1j6f2HP5Tv+kE/6+5A1oJ6cAOqPqh/nDj72kfqANzk+0QQO0qUw9IofIwZi4pG+9RR0NaKEqvk36A1WBtuzUjDU=
Date: Mon, 7 May 2007 13:09:42 +0200 (CEST)
From: Esben Nielsen <nielsen.esben@googlemail.com>
X-X-Sender: simlo@frodo.shire
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Esben Nielsen <nielsen.esben@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v8
In-Reply-To: <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705071159530.14011@frodo.shire>
References: <20070501212223.GA29867@elte.hu> <463854F3.3020403@linux.vnet.ibm.com>
 <20070502100545.GA6857@elte.hu> <46386F2B.9050307@linux.vnet.ibm.com>
 <20070502111742.GA18132@elte.hu> <Pine.LNX.4.64.0705051016420.12880@frodo.shire>
 <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 5 May 2007, Linus Torvalds wrote:

>
>
> On Sat, 5 May 2007, Esben Nielsen wrote:
>>
>> I have been wondering why you use usigned for timers anyway. It is also like
>> that in hrtimers. Why not use signed and avoid (almost) all worries about wrap
>> around issues. The trick is that when all
>>   a < b
>> is be replaced by
>>   a - b < 0
>> the code will work on all 2-complement machines even if the (signed!) integers
>> a and b wrap around.
>
> No. BOTH of the above are buggy.
>
> The C language definition doesn't allow signed integers to wrap (ie it's
> undefined behaviour), so "a-b < 0" can be rewritten by the compiler as a
> simple signed "a < b".
>
> And the unsigned (or signed) "a < b" is just broken wrt any kind of
> wrap-around (whether wrapping around zero or the sign bit).
>
> So the _only_ valid way to handle timers is to
> - either not allow wrapping at all (in which case "unsigned" is better,
>   since it is bigger)
> - or use wrapping explicitly, and use unsigned arithmetic (which is
>   well-defined in C) and do something like "(long)(a-b) > 0".
>
> Notice? The signed variant is basically _never_ correct.
>

What is (long)(a-b) ? I have tried to look it up in the C99 standeard but 
I can't find it. Maybe it is in the referred LIA-1 standeard, which I 
can't find with google.

I think the best would be to use "a-b > ULONG_MAX/2" when you mean "a<b" 
as that should be completely portable.

According to C99 Appendix H2.2 
(http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf) an 
implementation can choose to do modulo signed integers as it is 
mandatory for unsigned integers. If an implementation have choosen 
to do that it must be a bug to to do the "a-b < 0" -> "a<b" optimization.

I have never experienced a compiler/architecture combination _not_ doing 
wrapped signed integers.

Esben


> 		Linus
>
