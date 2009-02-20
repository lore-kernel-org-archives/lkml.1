Return-Path: <linux-kernel-owner+w=401wt.eu-S1758515AbZBTIrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515AbZBTIrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbZBTIrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 03:47:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:55114 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbZBTIrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 03:47:36 -0500
Subject: Re: [PATCH] drm: Fix lock order reversal between mmap_sem and
 struct_mutex.
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Hellstrom <thomas@shipmail.org>
Cc: Eric Anholt <eric@anholt.net>, Wang Chen <wangchen@cn.fujitsu.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <499E6A71.8060609@shipmail.org>
References: <1234918786-854-1-git-send-email-eric@anholt.net>
	 <1234969734.4637.111.camel@laptop>  <499DC8EC.3000806@shipmail.org>
	 <1235082372.4612.665.camel@laptop>  <499E6A71.8060609@shipmail.org>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 09:47:22 +0100
Message-Id: <1235119642.4736.19.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-20 at 09:31 +0100, Thomas Hellstrom wrote:
> Peter Zijlstra wrote:
> > On Thu, 2009-02-19 at 22:02 +0100, Thomas Hellstrom wrote:
> >   
> >>  
> >> It looks to me like the driver preferred locking order is
> >>
> >> object_mutex (which happens to be the device global struct_mutex)
> >>   mmap_sem
> >>      offset_mutex.
> >>
> >> So if one could avoid using the struct_mutex for object bookkeeping (A 
> >> separate lock) then
> >> vm_open() and vm_close() would adhere to that locking order as well, 
> >> simply by not taking the struct_mutex at all.
> >>
> >> So only fault() remains, in which that locking order is reversed. 
> >> Personally I think the trylock ->reschedule->retry method with proper 
> >> commenting is a good solution. It will be the _only_ place where locking 
> >> order is reversed and it is done in a deadlock-safe manner. Note that 
> >> fault() doesn't really fail, but requests a retry from user-space with 
> >> rescheduling to give the process holding the struct_mutex time to 
> >> release it.
> >>     
> >
> > It doesn't do the reschedule -- need_resched() will check if the current
> > task was marked to be scheduled away, 

> Yes. my mistake. set_tsk_need_resched() would be the proper call. If I'm 
> correctly informed, that would kick in the scheduler _after_ the 
> mmap_sem() is released, just before returning to user-space.

Yes, but it would still life-lock in the RT example given in the other
email.

> > furthermore yield based locking
> > sucks chunks.
> >   
> Yes, but AFAICT in this situation it is the only way to reverse locking 
> order in a deadlock safe manner. If there is a lot of contention it will 
> eat cpu. Unfortunately since the struct_mutex is such a wide lock there 
> will probably be contention in some situations.

I'd be surprised if this were the only solution. Maybe its the easiest,
but not one I'll support.

> BTW isn't this quite common in distributed resource management, when you 
> can't ensure that all requestors will request resources in the same order?
> Try to grab all resources you need for an operation. If you fail to get 
> one, release the resources you already have, sleep waiting for the 
> failing one to be available and then retry.

Not if you're building deterministic systems. Such constructs are highly
non-deterministic.

Furthermore, this isn't really a distributed system is it?

