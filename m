Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836Ab0AETQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab0AETQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200Ab0AETQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:16:36 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:51039 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab0AETQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:16:35 -0500
Date: Tue, 5 Jan 2010 13:15:53 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Linus Torvalds <torvalds@linux-foundation.org>
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
In-Reply-To: <alpine.LFD.2.00.1001051052150.3630@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1001051301060.5119@router.home>
References: <20100104182429.833180340@chello.nl> <20100104182813.753545361@chello.nl> <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com> <28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com> <20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.LFD.2.00.1001042052210.3630@localhost.localdomain> <20100105143046.73938ea2.kamezawa.hiroyu@jp.fujitsu.com> <20100105163939.a3f146fb.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001050707520.3630@localhost.localdomain>
 <alpine.LFD.2.00.1001050810380.3630@localhost.localdomain> <87wrzwbh0z.fsf@basil.nowhere.org> <alpine.LFD.2.00.1001050950500.3630@localhost.localdomain> <alpine.DEB.2.00.1001051211000.2246@router.home> <alpine.LFD.2.00.1001051019280.3630@localhost.localdomain>
 <alpine.DEB.2.00.1001051235200.2246@router.home> <alpine.LFD.2.00.1001051052150.3630@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010, Linus Torvalds wrote:

> Don't you see the problem? The spinlock (with ticket locks) essentially
> does the "xadd" atomic increment anyway, but then it _waits_ for it. All
> totally pointless, and all just making for problems, and wasting CPU time
> and causing more cross-node traffic.

For the xadd to work it first would have to acquire the cacheline
exclusively. That can only occur for a single processor and with the
fitting minimum holdtime for exclusive cachelines everything should be
fine. If the critical section is done (unlock complete) then the next
processor (which had to stopped waiting to access the cacheline) can
acquire the lock.

The wait state is the processor being stopped due to not being able to
access the cacheline. Not the processor spinning in the xadd loop. That
only occurs if the critical section is longer than the timeout.

