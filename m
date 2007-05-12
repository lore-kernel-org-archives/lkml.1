Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbXELPeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbXELPeq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 11:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbXELPek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 11:34:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:3884 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbXELPej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 11:34:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=WwEpAMdSr3v70Wj7HBstiNsh3tc7yHASbDfSj/4BU5gEK3ChAon6XhbIm45RJiBC+Pe75SQ6Ej+xkpReu9rlIWaX1/+b1NJfkU1LAudrUGsJqXFXTB/IYXzaB2OXsBsnwUdymJ2XhFEf//MZaQ0h8CwfBOX8uRpoBpw/M1/vIqY=
Date: Sat, 12 May 2007 17:34:32 +0200 (CEST)
From: Esben Nielsen <nielsen.esben@googlemail.com>
X-X-Sender: simlo@frodo.shire
To: Ingo Molnar <mingo@elte.hu>
cc: Esben Nielsen <nielsen.esben@googlemail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 0/2] convert mmap_sem to a scalable rw_mutex
In-Reply-To: <20070512143328.GA24803@elte.hu>
Message-ID: <Pine.LNX.4.64.0705121721570.2101@frodo.shire>
References: <20070511131541.992688403@chello.nl> <Pine.LNX.4.64.0705121120210.26287@frodo.shire>
 <1178964103.6810.55.camel@twins> <Pine.LNX.4.64.0705121520210.2101@frodo.shire>
 <20070512143328.GA24803@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 May 2007, Ingo Molnar wrote:

>
> * Esben Nielsen <nielsen.esben@googlemail.com> wrote:
>
>> I notice that the rwsems used now isn't priority inversion safe (thus
>> destroying the perpose of having PI futexes). We thus already have a
>> bug in the mainline.
>
> you see everything in black and white, ignoring all the grey scales!
> Upstream PI futexes are perfectly fine as long as the mm semaphore is
> not write-locked (by anyone) while the critical path is running. Given
> that real-time tasks often use mlockall and other practices to simplify
> their workload so this is not all that hard to achieve.
>

Yeah, after sending that mail I realized I accepted this fact way back...
But I disagree in that it is easy to avoid not write-lcling the mm 
semaphore: A simple malloc() might lead to a mmap() call creating trouble. 
Am I right?


>> I suggest making a rw_mutex which does read side PI: A reader boosts
>> the writer, but a writer can't boost the readers, since there can be a
>> large amount of those.
>
> this happens automatically when you use Peter's stuff on -rt.

Because the rw_mutex is translated into a rt_mutex - as you say below.

> But
> mainline should not be bothered with this.
>

I disagree. You lay a large burdon on the users of PI futexes to avoid 
write locking the mm semaphore. PI boosting those writers would be a good 
idea even in the mainline.

>> I don't have time to make such a rw_mutex but I have a simple idea for
>> one, where the rt_mutex can be reused.
>
> Peter's stuff does this already if you remap all the mutex ops to
> rt_mutex ops. Which is also what happens on -rt automatically. Ok?
>

That is how -rt works and should work. No disagrement there.

> [ for mainline it is totally pointless and unnecessary to slow down all
>  MM ops via an rt_mutex, because there are so many other, much larger
>  effects that make execution time unbound. (interrupts for example) ]
>

1) How much slower would the pi_rw_mutex I suggested really be? As far as 
I see there is only an overhead when there is congestion. I can not see 
that that overhead is much larger than a non-PI boosting implementation.

2) I know that execution time isn't bounded in the main-line - that is why 
-rt is needed. But it is _that_ bad? How low can you get your latencies 
with preemption on on a really busy machine?

Basically, I think PI futexes should provide the same kind of latencies 
as the basic thread latency. That is what the user would expect.
Priority invertions should be removed, but ofcourse you can't do better 
than the OS does otherwise.

> 	Ingo
>

Esben
