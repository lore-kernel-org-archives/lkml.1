Return-Path: <linux-kernel-owner+w=401wt.eu-S1750821AbXBMQqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750821AbXBMQqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 11:46:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbXBMQqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 11:46:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39653 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbXBMQqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 11:46:12 -0500
Date: Tue, 13 Feb 2007 17:42:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Message-ID: <20070213164220.GA13499@elte.hu>
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu> <20070213150019.4b4d4827@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213150019.4b4d4827@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan <alan@lxorguk.ukuu.org.uk> wrote:

> > A syslet is executed opportunistically: i.e. the syslet subsystem 
> > assumes that the syslet will not block, and it will switch to a 
> > cachemiss kernel thread from the scheduler. This means that even a
> 
> How is scheduler fairness maintained ? and what is done for resource 
> accounting here ?

the async threads are as if the user created user-space threads - and 
it's accounted (and scheduled) accordingly.

> > that the kernel fills and user-space clears. Waiting is done via the 
> > sys_async_wait() system call. Completion can be supressed on a 
> > per-atom
> 
> They should be selectable as well iff possible.

basically arbitrary notification interfaces are supported. For example 
if you add a sys_kill() call as the last syslet atom then this will 
notify any waiter in sigwait().

or if you want to select(), just do it in the fds that you are 
interested in, and the write that the syslet does triggers select() 
completion.

but the fastest one will be by using syslets: to just check the 
notification ring pointer in user-space, and then call into 
sys_async_wait() if the ring is empty.

I just noticed a small bug here: sys_async_wait() should also take the 
ring index userspace checked as a second parameter, and fix up the 
number of events it waits for with the delta between the ring index the 
kernel maintains and the ring index user-space has. The patch below 
fixes this bug.

> > Open issues:
> 
> Let me add some more
> 
> 	sys_setuid/gid/etc need to be synchronous only and not occur 
> while other async syscalls are running in parallel to meet current 
> kernel assumptions.

these should probably be taken out of the 'async syscall table', along 
with fork and the async syscalls themselves.

> 	sys_exec and other security boundaries must be synchronous 
> only and not allow async "spill over" (consider setuid async binary 
> patching)

i've tested sys_exec() and it seems to work, but i might have missed 
some corner-cases. (And what you raise is not academic, it might even 
make sense to do it, in the vfork() way.)

> >  - sys_fork() and sys_async_exec() should be filtered out from the 
> >    syscalls that are allowed - first one only makes sense with ptregs, 
> 
> clone and vfork. async_vfork is a real mindbender actually.

yeah. Also, create_module() perhaps. I'm starting to lean towards an 
async_syscall_table[]. At which point we could reduce the max syslet 
parameter count to 4, and do those few 5 and 6 parameter syscalls (of 
which only splice() and futex() truly matter i suspect) via wrappers. 
This would fit a syslet atom into 32 bytes on x86. Hm?

> >    second one is a nice kernel recursion thing :) I didnt want to 
> >    duplicate the sys_call_table though - maybe others have a better 
> >    idea.
> 
> What are the semantics of async sys_async_wait and async sys_async ?

agreed, that should be forbidden too.

	Ingo

---------------------->
---
 kernel/async.c |   12 +++++++++---
 kernel/async.h |    2 +-
 2 files changed, 10 insertions(+), 4 deletions(-)

Index: linux/kernel/async.c
===================================================================
--- linux.orig/kernel/async.c
+++ linux/kernel/async.c
@@ -721,7 +721,8 @@ static void refill_cachemiss_pool(struct
  * to finish or for all async processing to finish (whichever
  * comes first).
  */
-asmlinkage long sys_async_wait(unsigned long min_wait_events)
+asmlinkage long
+sys_async_wait(unsigned long min_wait_events, unsigned long user_curr_ring_idx)
 {
 	struct async_head *ah = current->ah;
 
@@ -730,12 +731,17 @@ asmlinkage long sys_async_wait(unsigned 
 
 	if (min_wait_events) {
 		spin_lock(&ah->lock);
-		ah->events_left = min_wait_events;
+		/*
+		 * Account any completions that happened since user-space
+		 * checked the ring:
+	 	 */
+		ah->events_left = min_wait_events -
+				(ah->curr_ring_idx - user_curr_ring_idx);
 		spin_unlock(&ah->lock);
 	}
 
 	return wait_event_interruptible(ah->wait,
-		list_empty(&ah->busy_async_threads) || !ah->events_left);
+		list_empty(&ah->busy_async_threads) || ah->events_left > 0);
 }
 
 /**
Index: linux/kernel/async.h
===================================================================
--- linux.orig/kernel/async.h
+++ linux/kernel/async.h
@@ -26,7 +26,7 @@ struct async_head {
 	struct list_head			ready_async_threads;
 	struct list_head			busy_async_threads;
 
-	unsigned long				events_left;
+	long					events_left;
 	wait_queue_head_t			wait;
 
 	struct async_head_user	__user		*uah;
