Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbXFUUiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbXFUUiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbXFUUh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:37:58 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:52805 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130AbXFUUh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:37:57 -0400
Message-ID: <467AE155.3080703@cosmosbay.com>
Date: Thu, 21 Jun 2007 22:36:37 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chuck Ebbert <cebbert@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
References: <20070620093612.GA1626@ff.dom.local> <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org> <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org> <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com> <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org> <20070621202917.a2bfbfc7.dada1@cosmosbay.com> <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org> <alpine.LFD.0.98.0706211230130.3593@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706211230130.3593@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 21 Jun 2007 22:36:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds a écrit :
> 
> On Thu, 21 Jun 2007, Linus Torvalds wrote:
>> We don't do nesting locking either, for exactly the same reason. Are 
>> nesting locks "easier"? Absolutely. They are also almost always a sign of 
>> a *bug*. So making spinlocks and/or mutexes nest by default is just a way 
>> to encourage bad programming!
> 
> Side note, and as a "truth in advertising" section: I'll have to admit 
> that I argued against fair semaphores on the same grounds. I was wrong 
> then (and eventually admitted it, and we obviously try to make our mutexes 
> and semaphores fair these days!), and maybe I'm wrong now.
> 
> If somebody can actually come up with a sequence where we have spinlock 
> starvation, and it's not about an example of bad locking, and nobody 
> really can come up with any other way to fix it, we may eventually have to 
> add the notion of "fair spinlocks".
> 

I tried to find such a sequence, but I think its more a matter of hardware 
evolution, and some degenerated cases.

In some years (months ?), it might possible to starve say the file struct 
spinlock of a process in a open()/close() infinite loop. This because the 
number of instruction per 'memory cache line transfert between cpus/core' is 
raising.

But then one can say its a bug in user code :)

Another way to starve kernel might be a loop doing settime() , since seqlock 
are quite special in serialization :

Only seqlock's writers perform atomic ops, readers could be starved because of 
some hardware 'optimization'.


> So my arguments are purely pragmatic. It's not that I hate fairness per 
> se. I dislike it only when it's used to "solve" (aka hide) other problems.
> 
> In the end, some situations do need fairness, and the fact that aiming for 
> fairness is often harder, slower, and more complicated than not doing so 
> at that point turns into a non-argument. If you need it, you need it.

Maybe some *big* NUMA machines really want this fairness (even if it cost some 
cycles as pointed by Davide in http://lkml.org/lkml/2007/3/29/246 ) , I am 
just guessing since I cannot test such monsters. I tested Davide program on a 
Dual Opteron and got some perf difference.


$ ./qspins  -n 2
now testing: TICKLOCK
timeres=4000
uscycles=1991
AVG[0]: 2195.250000 cycles/loop
SIG[0]: 11.813657
AVG[1]: 2212.312500 cycles/loop
SIG[1]: 38.038991

$ ./qspins  -n 2 -s
now testing: SPINLOCK
timeres=4000
uscycles=1991
AVG[0]: 2066.000000 cycles/loop
SIG[0]: 0.000000
AVG[1]: 2115.687500 cycles/loop
SIG[1]: 63.083000


> 
> I just don't think we need it, and we're better off solving problems other 
> ways.
> 
> (For example, we might also solve such problems by creating a separate
> "fair_spin_lock" abstraction, and only making the particular users that 
> need it actually use it. It would depend a bit on whether the cost of 
> implementing the fairness is noticeable enough for it to be worth having 
> a separate construct for it).
> 
> 		Linus
> 
> 

