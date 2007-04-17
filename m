Return-Path: <linux-kernel-owner+w=401wt.eu-S1751328AbXDQGXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbXDQGXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 02:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbXDQGXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 02:23:48 -0400
Received: from omta03sl.mx.bigpond.com ([144.140.92.155]:37972 "EHLO
	omta03sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbXDQGXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 02:23:46 -0400
Message-ID: <462467E9.4030509@bigpond.net.au>
Date: Tue, 17 Apr 2007 16:23:37 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de>
In-Reply-To: <20070417042954.GG25513@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta03sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Tue, 17 Apr 2007 06:23:43 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Tue, Apr 17, 2007 at 02:17:22PM +1000, Peter Williams wrote:
>> Nick Piggin wrote:
>>> On Tue, Apr 17, 2007 at 04:29:01AM +0200, Mike Galbraith wrote:
>>>> On Tue, 2007-04-17 at 10:06 +1000, Peter Williams wrote:
>>>>> Mike Galbraith wrote:
>>>>>> Demystify what?   The casual observer need only read either your attempt
>>>>>> at writing a scheduler, or my attempts at fixing the one we have, to see
>>>>>> that it was high time for someone with the necessary skills to step in.
>>>>> Make that "someone with the necessary clout".
>>>> No, I was brutally honest to both of us, but quite correct.
>>>>
>>>>>> Now progress can happen, which was _not_ happening before.
>>>>>>
>>>>> This is true.
>>>> Yup, and progress _is_ happening now, quite rapidly.
>>> Progress as in progress on Ingo's scheduler. I still don't know how we'd
>>> decide when to replace the mainline scheduler or with what.
>>>
>>> I don't think we can say Ingo's is better than the alternatives, can we?
>>> If there is some kind of bakeoff, then I'd like one of Con's designs to
>>> be involved, and mine, and Peter's...
>> I myself was thinking of this as the chance for a much needed 
>> simplification of the scheduling code and if this can be done with the 
>> result being "reasonable" it then gives us the basis on which to propose 
>> improvements based on the ideas of others such as you mention.
>>
>> As the size of the cpusched indicates, trying to evaluate alternative 
>> proposals based on the current O(1) scheduler is fraught.  Hopefully, 
> 
> I don't know why. The problem is that you can't really evaluate good
> proposals by looking at the code (you can say that one is bad, ie. the
> current one, which has a huge amount of temporal complexity and is
> explicitly unfair), but it is pretty hard to say one behaves well.

I meant that it's indicative of the amount of work that you have to do 
to implement a new scheduling discipline for evaluation.

> 
> And my scheduler for example cuts down the amount of policy code and
> code size significantly.

Yours is one of the smaller patches mainly because you perpetuate (or 
you did in the last one I looked at) the (horrible to my eyes) dual 
array (active/expired) mechanism.  That this idea was bad should have 
been apparent to all as soon as the decision was made to excuse some 
tasks from being moved from the active array to the expired array.  This 
essentially meant that there would be circumstances where extreme 
unfairness (to the extent of starvation in some cases) -- the very 
things that the mechanism was originally designed to ensure (as far as I 
can gather).  Right about then in the development of the O(1) scheduler 
alternative solutions should have been sought.

Other hints that it was a bad idea was the need to transfer time slices 
between children and parents during fork() and exit().

This disregard for the dual array mechanism has prevented me from 
looking at the rest of your scheduler in any great detail so I can't 
comment on any other ideas that may be in there.

> I haven't looked at Con's ones for a while,
> but I believe they are also much more straightforward than mainline...

I like Con's scheduler (partly because it uses a single array) but 
mainly because it's nice and simple.  However, his earlier schedulers 
were prone to starvation (admittedly, only if you went out of your way 
to make it happen) and I tried to convince him to use the anti 
starvation mechanism in my SPA schedulers but was unsuccessful.  I 
haven't looked at his latest scheduler that sparked all this furore so 
can't comment on it.

> 
> For example, let's say all else is equal between them, then why would
> we go with the O(logN) implementation rather than the O(1)?

In the highly unlikely event that you can't separate them on technical 
grounds, Occam's razor recommends choosing the simplest solution. :-)

To digress, my main concern is that load balancing is being lumped in 
with this new change.  It's becoming "accept this beg lump of new code 
or nothing".  I'd rather see a good fix to the intra runqueue/CPU 
scheduler problem implemented first and then if there really are any 
outstanding problems with the load balancer attack them later.  Them all 
being mixed up together gives me a nasty deja vu of impending disaster.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
