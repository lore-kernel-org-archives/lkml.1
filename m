Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZHLP6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZHLP6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbZHLP6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:58:36 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59007 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753892AbZHLP6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:58:35 -0400
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0908121122010.2955-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0908121122010.2955-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 10:58:31 -0500
Message-Id: <1250092711.4000.33.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 11:44 -0400, Alan Stern wrote:
> On Wed, 12 Aug 2009, James Bottomley wrote:
> 
> > On Wed, 2009-08-12 at 10:54 -0400, Alan Stern wrote:
> > > > > + * Consider using cancel_work_sync() or cancel_delayed_work_sync() instead.
> > > > > + * They don't do the same thing (they cancel the work instead of waiting
> > > > > + * for it to complete), but in most cases they will suffice.
> > > > > + */
> > > > 
> > > > And this is wrong advice.  If you've violated the entangled deadlock
> > > > rules, the cancel functions will deadlock on you as well if the work is
> > > > still pending.
> > > 
> > > No they won't.  They will remove the work item from the workqueue right
> > > away, without blocking, assuming it hasn't started yet (i.e., is still 
> > > pending).  This is a large part of their raison d'etre.
> > 
> > Yes, they will ... you advised the _sync function which waits if the
> > work is in progress and hence induces the entanglement.  You can get
> > away with this if you don't use _sync (but then you won't know when the
> > queue is safely not touching any module code before removal).
> 
> This is partly a simple misunderstanding.  By "pending", I thought you
> meant that the work item was still on the workqueue but had not yet
> been invoked (i.e., "pending" as opposed to "running").  In that
> situation there will be no deadlock, as I said.
> 
> But let's consider the case you bring up, where the work item _has_
> started to run.  It's true that the work routine can cause deadlock by
> violating the locking rules, regardless of whether you use
> cancel_work_sync() or flush_scheduled_work().
> 
> Nevertheless, even in this case cancel_work_sync() is _still_ more
> reliable than flush_schedule_work().  Example: Let's suppose you're
> interested in work item A, which is at the head of the workqueue and
> has already started running.  Let's also suppose that A doesn't violate
> the locking rules (since otherwise things are hopeless).  Finally,
> let's assume the workqueue contains a second unrelated work item, B.
> 
> Here's what can happen with flush_scheduled_work():
> 
> 	CPU 0			CPU 1
> 	-----			-----
> 				A:	(invoked from workqueue)
> 				... does some stuff ...
> 	lock_mutex(&m);
> 	flush_scheduled_work();
> 	... waits ...
> 				A finishes
> 				B:	(invoked from workqueue)
> 				lock_mutex(&m);		/* Deadlock! */
> 
> Now consider the same situation with cancel_work_sync():
> 
> 	CPU 0			CPU 1
> 	-----			-----
> 				A:	(invoked from workqueue)
> 				... does some stuff ...
> 	lock_mutex(&m);
> 	cancel_work_sync(&A);
> 	... waits ...
> 				A finishes
> 	... continues running ...
> 				B:	(invoked from workqueue)
> 				lock_mutex(&m);
> 	unlock_mutex(&m);
> 				... continues running ...
> 
> You can see the difference.  There's no doubt about it,
> flush_scheduled_work() is more dangerous than cancel_work_sync().

This all boils down to "the race window for a deadlock may be narrower".

Instead of training programmers to narrow deadlock races, we should be
training them to avoid them.

The entangled deadlock problem occurs in all of our _sync() APIs as well
as interrupt and other workqueue stuff.

The rules are something like

Never use synchronous operations if you can avoid them.  If you must use
operations that wait for another thread to complete (say because you're
about to destroy data structures that queued elements may be using):
     1. Never hold any locks or mutexes while waiting for the completion
        of synchronous operations
     2. If you have to hold a lock while waiting:
             1. If it's a global lock, make sure you're using a local
                queue and that nothing you submitted to the queue can
                take the lock
             2. If it's a local lock, you may use a global queue but
                must still make sure that nothing you submitted to the
                queue can take the lock.

James


