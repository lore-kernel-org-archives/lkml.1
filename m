Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbYHATKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbYHATKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 15:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755218AbYHATKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 15:10:33 -0400
Received: from gw.goop.org ([64.81.55.164]:50245 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbYHATKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 15:10:32 -0400
Message-ID: <48935FA4.5010804@goop.org>
Date: Fri, 01 Aug 2008 12:10:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] lockdep: lock_set_subclass - reset a held lock's subclass
References: <20080731.155504.167792984.davem@davemloft.net>  <20080801.011122.32782916.davem@davemloft.net>  <20080801090100.GA25142@elte.hu>  <20080801.021348.233313767.davem@davemloft.net> <1217588920.9686.6.camel@twins> <489350AE.1030609@goop.org> <alpine.LFD.1.10.0808011113530.3277@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808011113530.3277@nehalem.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Fri, 1 Aug 2008, Jeremy Fitzhardinge wrote:
>   
>> Hey, can I use this to suppress the spurious lockdep warnings I get when I try
>> to hold more than one pte lock at once?
>>     
>
> So how sure are you that they are spurious?
>   

I have a function traversing a pagetable in vaddr order (low to high), 
taking pte locks as it builds up batches of pte page updates.  When the 
batch is issued, it releases all the locks, and won't end up holding 
more than ~16 at a time.

So, I think this is OK.  There are no internal lock ordering issues, and 
I don't think there'll be any bad interactions from someone trying to 
take pte locks for two separate pagetables.  I don't think there's 
anyone else trying to take more than one pte lock at once, but if there 
were "lock low vaddr then high" seems like a reasonable locking rule (or 
more precisely "lowest" to deal with the case of a pte page being 
aliased at multiple vaddrs).

Lockdep complains because the split pte locks are all in the same lock 
class, so it reports it as taking a spinlock recursively.  I'd reported 
this to PeterZ before, and he responded with "uh, I'll think about 
it...", which I took to mean "...when someone else has a problem".  So 
I'm wondering if this is that time...

(This is all with split pte locks, obviously.)

    J
