Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121Ab0AER55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab0AER55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 12:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978Ab0AER54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 12:57:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752862Ab0AER54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 12:57:56 -0500
Date: Tue, 5 Jan 2010 09:55:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <87wrzwbh0z.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.2.00.1001050950500.3630@localhost.localdomain>
References: <20100104182429.833180340@chello.nl> <20100104182813.753545361@chello.nl> <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com> <28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com> <20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.LFD.2.00.1001042052210.3630@localhost.localdomain> <20100105143046.73938ea2.kamezawa.hiroyu@jp.fujitsu.com> <20100105163939.a3f146fb.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001050707520.3630@localhost.localdomain>
 <alpine.LFD.2.00.1001050810380.3630@localhost.localdomain> <87wrzwbh0z.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Jan 2010, Andi Kleen wrote:
> 
> > Oh well. Somebody who is bored might look at trying to make the wrapper 
> > code in arch/x86/lib/semaphore_32.S work on x86-64 too. It should make the 
> > successful rwsem cases much faster.
> 
> Maybe, maybe not.

If there is actual contention on the lock, but mainly just readers (which 
is what the profile indicates: since there is no scheduler footprint, the 
actual writer-vs-reader case is probably very rare), then the xadd is 
likely to be _much_ faster than the spinlock.

Sure, the cacheline is going to bounce regardless (since it's a shared 
per-mm data structure), but the spinlock is going to bounce wildly 
back-and-forth between everybody who _tries_ to get it, while the regular 
xadd is going to bounce just once per actual successful xadd.

So a spinlock is as cheap as an atomic when there is no contention (which 
is the common single-thread case - the real cost of both lock and atomic 
is simply the fact that CPU serialization is expensive), but when there is 
actual lock contention, I bet the atomic xadd is going to be shown to be 
superior.

Remember: we commonly claim that 'spin_unlock' is basically free on x86 - 
and that's true, but it is _only_ true for the uncontended state. 

		Linus
