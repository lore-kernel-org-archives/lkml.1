Return-Path: <linux-kernel-owner+w=401wt.eu-S1759335AbZB0HMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335AbZB0HMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759792AbZB0HMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:12:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:48639 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758275AbZB0HMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:12:37 -0500
Message-ID: <49A79237.9070408@kernel.org>
Date: Fri, 27 Feb 2009 16:11:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jeremy@goop.org, cpw@sgi.com
Subject: Re: [patch] x86: optimize __pa() to be linear again on 64-bit x86
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <20090223101741.GP9582@elte.hu> <20090223133804.GA20468@elte.hu> <200902240108.54892.nickpiggin@yahoo.com.au> <20090223145358.GB3377@elte.hu> <49A780E0.7020508@kernel.org> <20090227065717.GA5207@elte.hu>
In-Reply-To: <20090227065717.GA5207@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 27 Feb 2009 07:11:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Ingo Molnar wrote:
> * Tejun Heo <tj@kernel.org> wrote:
> 
>> Hello,
>>
>> Ingo Molnar wrote:
>>> Yeah, we can do this complete conversion.
>>>
>>> I'll clean it up some more. I think the best representation of 
>>> this will be via a virt_to_sym() and sym_to_virt() space. That 
>>> makes it really clear when we are moving from the symbol space 
>>> to the linear space and back.
>> For arch code, maybe it's maintainable but with my driver developer
>> hat on I gotta say virt_to_page() not working on .data/.bss is quite
>> scary. [...]
> 
> Well, we have a debug mechanism in place.
> 
> As i suggested it in my first mail we can run with debug enabled 
> for a cycle and then turn on the optimization by default (with 
> the debug option still available too).

I don't know.  The failure mode just seems to subtle to me and we'll
be able to gain most of the benefits by using the fast version at
appropriate places without adding any risk.

> Drivers doing DMA on .data/.bss items is rather questionable 
> anyway (and dangerous as well, on any platform where there's 
> coherency problems if DMA is misaligned, etc.), and a quick look 
> shows there's at most 2-3 dozen examples of that in all of 
> drivers/*.

Gained benefit vs. added danger equation just doesn't seem right to
me.  Yes, we'll be able to filter most of them in a cycle or two but
we will never know whether it's fully safe or not.  Please note that
when it goes wrong, it can go wrong silently corrupting some unrelated
stuff.  When there is a way to achieve almost the same level of
performance gain in safe way, I don't think doing it this way is a
good choice.  Also, if we do this, we're basically introducing new API
by changing semantics of an existing one in a way that can break the
current users, which we really should avoid.

Thanks.

-- 
tejun
