Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbYKHTBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbYKHTBZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 14:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbYKHTBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 14:01:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547AbYKHTBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 14:01:16 -0500
Date: Sat, 8 Nov 2008 11:00:40 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [git pull] scheduler updates
In-Reply-To: <20081108104116.48bd26e6@infradead.org>
Message-ID: <alpine.LFD.2.00.0811081051190.3468@nehalem.linux-foundation.org>
References: <20081108170224.GA553@elte.hu> <alpine.LFD.2.00.0811081026280.3468@nehalem.linux-foundation.org> <20081108104116.48bd26e6@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 8 Nov 2008, Arjan van de Ven wrote:
> 
> historically it was for early AMD cpus (K7, not sure if early K8 did
> this) where 2 consecutive rdtsc's in the same codestream would get
> reordered compared to eachother, so you could observe the tsc go
> backwards...

.. but this only happens with two _consecutive_ ones.

The thing is, nobody sane does that in generic code. The scheduler wants 
to have cycles, yes, but two consecutive scheduler invocations will have 
spinlocks etc in between. That's true of _all_ sane uses of a TSC.

I don't see that there is ever any reason to do the barriers for any 
normal case. And the cases where it does matter would actually be worth 
pointing out (ie making the barriers explicit in those cases, and those 
cases only).

Doing it in get_cycles() and "forgetting about it" may sound like a simple 
solution, but it's likely wrong. For example, one of the few cases where 
we realy care about time going backwards is gettimeofday() - which uses 
tsc, but which also has tons of serializing instructions on its own. 
EXCEPT WHEN IT IS a vsyscall!

But in that case, we don't even have the barrier, because we put it in the 
wrong function and 'forgot about it'. Of course, we may not need it 
(rdtscp maybe always serializes, I didn't check), but the point is, an 
explicit barrier is actually better than one that is hidden.

So who _really_ needs it? And why not just do it there?

			Linus
