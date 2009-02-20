Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbZBTHhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbZBTHhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 02:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZBTHhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 02:37:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:33468 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbZBTHhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 02:37:06 -0500
Subject: Re: [PATCH] drm: Fix lock order reversal between mmap_sem and
 struct_mutex.
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Anholt <eric@anholt.net>
Cc: Thomas Hellstrom <thomas@shipmail.org>,
       Wang Chen <wangchen@cn.fujitsu.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1235095484.2636.39.camel@gaiman>
References: <1234918786-854-1-git-send-email-eric@anholt.net>
	 <1234969734.4637.111.camel@laptop>  <499DC8EC.3000806@shipmail.org>
	 <1235082372.4612.665.camel@laptop>  <1235095484.2636.39.camel@gaiman>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 08:36:46 +0100
Message-Id: <1235115406.4736.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 18:04 -0800, Eric Anholt wrote:
> On Thu, 2009-02-19 at 23:26 +0100, Peter Zijlstra wrote:
> > On Thu, 2009-02-19 at 22:02 +0100, Thomas Hellstrom wrote:
> > >  
> > > It looks to me like the driver preferred locking order is
> > > 
> > > object_mutex (which happens to be the device global struct_mutex)
> > >   mmap_sem
> > >      offset_mutex.
> > > 
> > > So if one could avoid using the struct_mutex for object bookkeeping (A 
> > > separate lock) then
> > > vm_open() and vm_close() would adhere to that locking order as well, 
> > > simply by not taking the struct_mutex at all.
> > > 
> > > So only fault() remains, in which that locking order is reversed. 
> > > Personally I think the trylock ->reschedule->retry method with proper 
> > > commenting is a good solution. It will be the _only_ place where locking 
> > > order is reversed and it is done in a deadlock-safe manner. Note that 
> > > fault() doesn't really fail, but requests a retry from user-space with 
> > > rescheduling to give the process holding the struct_mutex time to 
> > > release it.
> > 
> > It doesn't do the reschedule -- need_resched() will check if the current
> > task was marked to be scheduled away, furthermore yield based locking
> > sucks chunks.

Imagine what would happen if your faulting task was the highest RT prio
task in the system, you'd end up with a life-lock.

> > What's so very difficult about pulling the copy_*_user() out from under
> > the locks?
> 
> That we're expecting the data movement to occur while holding device
> state in place.  For example, we write data through the GTT most of the
> time so we:
> 
> lock struct_mutex
> pin the object to the GTT
> flushing caches as needed
> copy_from_user
> unpin object
> unlock struct_mutex

So you cannot drop the lock once you've pinned the dst object?

> If I'm to pull the copy_from_user out, that means I have to:
> 
> alloc temporary storage
> for each block of temp storage size:
> 	copy_from_user
> 	lock struct_mutex
> 	pin the object to the GTT
> 	flush caches as needed
> 	memcpy
> 	unpin object
> 	unlock struct_mutex
> 
> At this point of introducing our third copy of the user's data in our
> hottest path, we should probably ditch the pwrite path entirely and go
> to user mapping of the objects for performance.  Requiring user mapping
> (which has significant overhead) cuts the likelihood of moving from
> user-space object caching to kernel object caching in the future, which
> has the potential of saving steaming piles of memory.

Or you could get_user_pages() to fault the user pages and pin them, and
then do pagefault_disable() and use copy_from_user_inatomic or such, and
release the pages again.



