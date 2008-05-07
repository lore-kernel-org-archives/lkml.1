Return-Path: <linux-kernel-owner+w=401wt.eu-S1759886AbYEGQXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759886AbYEGQXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760158AbYEGQXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:23:13 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:40465 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758199AbYEGQXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:23:08 -0400
Date: Wed, 7 May 2008 10:22:51 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080507162251.GX19219@parisc-linux.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang> <1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <4821C370.1030801@firstfloor.org> <20080507083105.b9874d78.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507083105.b9874d78.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 08:31:05AM -0700, Andrew Morton wrote:
> On Wed, 07 May 2008 16:57:52 +0200 Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Or figure out what made the semaphore consolidation slower? As Ingo
> > pointed out earlier 40% is unlikely to be a fast path problem, but some
> > algorithmic problem. Surely that is fixable (even for .26)?
> 
> Absolutely.  Yanmin is apparently showing that each call to __down()
> results in 1,451 calls to schedule().  wtf?

I can't figure it out either.  Unless schedule() is broken somehow ...
but that should have shown up with semaphore-sleepers.c, shouldn't it?

One other difference between semaphore-sleepers and the new generic code
is that in effect, semaphore-sleepers does a little bit of spinning
before it sleeps.  That is, if up() and down() are called more-or-less
simultaneously, the increment of sem->count will happen before __down
calls schedule().  How about something like this:

diff --git a/kernel/semaphore.c b/kernel/semaphore.c
index 5c2942e..ef83f5a 100644
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -211,6 +211,7 @@ static inline int __sched __down_common(struct semaphore *sem, long state,
 	waiter.up = 0;
 
 	for (;;) {
+		int i;
 		if (state == TASK_INTERRUPTIBLE && signal_pending(task))
 			goto interrupted;
 		if (state == TASK_KILLABLE && fatal_signal_pending(task))
@@ -219,7 +220,15 @@ static inline int __sched __down_common(struct semaphore *sem, long state,
 			goto timed_out;
 		__set_task_state(task, state);
 		spin_unlock_irq(&sem->lock);
+
+		for (i = 0; i < 10; i++) {
+			if (waiter.up)
+				goto skip_schedule;
+			cpu_relax();
+		}
+
 		timeout = schedule_timeout(timeout);
+ skip_schedule:
 		spin_lock_irq(&sem->lock);
 		if (waiter.up)
 			return 0;

Maybe it'd be enough to test it once ... or maybe we should use
spin_is_locked() ... Ingo?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
