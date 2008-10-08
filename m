Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYJHQEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYJHQEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 12:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbYJHQEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 12:04:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47699 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbYJHQD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 12:03:59 -0400
Message-ID: <48ECD9C8.4000700@redhat.com>
Date: Wed, 08 Oct 2008 12:03:20 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, hugh@veritas.com, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
References: <20080804130317.994042639@chello.nl> <20080804131012.246115111@chello.nl> <48974512.7000206@goop.org> <1217876046.3589.61.camel@twins> <489757EC.3000309@goop.org> <alpine.LFD.1.10.0808041230070.3340@nehalem.linux-foundation.org> <20081008152708.GA11207@goodmis.org> <alpine.LFD.2.00.0810080836410.3208@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810080836410.3208@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Wed, 8 Oct 2008, Steven Rostedt wrote:
>   
>>> And yes, if there is an outer lock, even the order of getting locks is 
>>> irrelevant, as long as anybody who gets more than one inner lock always 
>>> holds the outer one.
>>>       
>> But I need to disagree on a programming practice style.  Unlocking locks
>> in a non nested order is just bad programming practice.
>>     
>
> No it is not.
>
> Unlocking locks in non-nested order can sometimes be very much the rigth 
> thing to do, and thinking otherwise is (a) naive and (b) can generate 
> totally unnecessary and pointless bugs.
>
> The thing is, sometimes you have to do it, and imposing totally made-up 
> rules ("unlocks have to nest") just confuses everybody.
>
> The FACT is, that unlocks do not have to nest cleanly. That's a rock solid 
> *FACT*. The locking order matters, and the unlocking order does not.
>
> And if you cannot accept that as a fact, and you then say "unlock order 
> should matter just to keep things nice and clean", then you end up being 
> screwed and/or confused when you can't hold to the unlock order.
>
> There are many perfectly valid reasons not to unlock in reverse order. 
> Don't create make-believe rules that break those reasons for no gain.
>   

Unfortunately, you cut out my comment that I stated "unless there is a 
good reason not to",
which the below example is a good reason ;-)
> For example:
>  - let's say that you have a singly-linked list of objects.
>  - you need to lock all objects, do something, and then unlock all 
>    objects.
>  - the *only* sane way to do that is to just traverse the list twice.
>  - that means that you will unlock the objects in the same order you 
>    locked them, _not_ in reverse ("nested") order.
>  - if you force a rule of "unlocks must be nested", then
>
> 	YOU ARE A F*CKING MORON.
>
> It's that simple. Don't do made-up rules that have no technical reason for 
> them. 
>
> Lock ordering matters. Unlock ordering does not. It really is that simple. 
> Don't confuse the issue by claiming anything else.
>   

Yes, I totally agree that there are good reasons not to unlock in 
reverse order, and the example
you gave happens to be one of them.

I just find that seeing something like:

    lock(A);
    lock(B);

    [do something]

    unlock(A);
    unlock(B);

just seems to be sloppy.

I wont harp on this, it only came up in conversation in which someone 
pointed out your
post.

-- Steve

