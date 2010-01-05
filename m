Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013Ab0AES2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab0AES2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 13:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702Ab0AES2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 13:28:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848Ab0AES2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 13:28:11 -0500
Date: Tue, 5 Jan 2010 10:25:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Christoph Lameter <cl@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <alpine.DEB.2.00.1001051211000.2246@router.home>
Message-ID: <alpine.LFD.2.00.1001051019280.3630@localhost.localdomain>
References: <20100104182429.833180340@chello.nl> <20100104182813.753545361@chello.nl> <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com> <28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com> <20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.LFD.2.00.1001042052210.3630@localhost.localdomain> <20100105143046.73938ea2.kamezawa.hiroyu@jp.fujitsu.com> <20100105163939.a3f146fb.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001050707520.3630@localhost.localdomain>
 <alpine.LFD.2.00.1001050810380.3630@localhost.localdomain> <87wrzwbh0z.fsf@basil.nowhere.org> <alpine.LFD.2.00.1001050950500.3630@localhost.localdomain> <alpine.DEB.2.00.1001051211000.2246@router.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Jan 2010, Christoph Lameter wrote:
> 
> If the critical section protected by the spinlock is small then the
> delay will keep the cacheline exclusive until we hit the unlock. This
> is the case here as far as I can tell.

I hope somebody can time it. Because I think the idle reads on all the 
(unsuccessful) spinlocks will kill it.

Think of it this way: under heavy contention, you'll see a lot of people 
waiting for the spinlocks and one of them succeeds at writing it, reading 
the line. So you get an O(n^2) bus traffic access pattern. In contrast, 
with an xadd, you get O(n) behavior - everybody does _one_ acquire-for- 
write bus access.

Remember: the critical section is small, but since you're contending on 
the spinlock, that doesn't much _help_. The readers are all hitting the 
lock (and you can try to solve the O(n*2) issue with back-off, but quite 
frankly, anybody who does that has basically already lost - I'm personally 
convinced you should never do lock backoff, and instead look at what you 
did wrong at a higher level instead).

				Linus
