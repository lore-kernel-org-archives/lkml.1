Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841Ab0AGVuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab0AGVuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 16:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756Ab0AGVuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 16:50:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:60816 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab0AGVuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:50:07 -0500
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.1001071007010.7821@localhost.localdomain>
References: <20100104182429.833180340@chello.nl>
	 <20100104182813.753545361@chello.nl>
	 <20100105054536.44bf8002@infradead.org>
	 <alpine.DEB.2.00.1001050916300.1074@router.home>
	 <20100105192243.1d6b2213@infradead.org>
	 <alpine.DEB.2.00.1001071007210.901@router.home>
	 <alpine.LFD.2.00.1001070814080.7821@localhost.localdomain>
	 <1262884960.4049.106.camel@laptop>
	 <alpine.LFD.2.00.1001070934060.7821@localhost.localdomain>
	 <alpine.LFD.2.00.1001070937180.7821@localhost.localdomain>
	 <1262887207.4049.127.camel@laptop>
	 <alpine.LFD.2.00.1001071007010.7821@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jan 2010 22:49:42 +0100
Message-ID: <1262900982.4049.145.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 10:15 -0800, Linus Torvalds wrote:
> 
> On Thu, 7 Jan 2010, Peter Zijlstra wrote:
> > 
> > Well, with that sync_vma() thing I posted the other day all the
> > speculative page fault needs is a write to current->fault_vma, the ptl
> > and an O(nr_threads) loop on unmap() for file vmas -- aside from writing
> > the pte itself of course.
> 
> How do you handle the race of
> 
> 	fault handler:			munmap
> 
> 	look up vma without locks
> 
> 	.. interrupt happens or
> 	  something delays things ..
> 					remove the vma from the list
> 					sync_vma()
> 
> 	current->fault_vma = vma
> 
> etc?
> 
> Maybe I'm missing something, but quite frankly, the above looks pretty 
> damn fundamental. Something needs to take a lock. If you get rid of the 
> mmap_sem, you need to replace it with another lock.
> 
> There's no sane way to "look up vma and atomically mark it as busy" 
> without locks. You can do it with extra work, ie something like
> 
> 	look up vma without locks
> 	current->fault_vma = vma
> 	smp_mb();
> 	check that the vma is still on the list
> 
> (with he appropriate barriers on the munmap side too, of course) where you 
> avoid the lock by basically turning it into an ordering problem, but it 
> ends up being pretty much as expensive anyway for single threads.

As expensive for single threads is just fine with me, as long as we get
cheaper with lots of threads.

I basically did the above revalidation with seqlocks, we lookup the vma,
mark it busy and revalidate the vma sequence count.

> And for lots and lots of threads, you now made that munmap be pretty 
> expensive.

Yeah, I really hate that part too, trying hard to come up with something
smarter but my brain isn't yet co-operating :-)

