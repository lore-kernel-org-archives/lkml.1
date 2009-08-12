Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbZHLPoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbZHLPoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZHLPoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:44:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47372 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751724AbZHLPoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:44:20 -0400
Date: Wed, 12 Aug 2009 11:44:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
In-Reply-To: <1250089234.4000.22.camel@mulgrave.site>
Message-ID: <Pine.LNX.4.44L0.0908121122010.2955-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009, James Bottomley wrote:

> On Wed, 2009-08-12 at 10:54 -0400, Alan Stern wrote:
> > > > + * Consider using cancel_work_sync() or cancel_delayed_work_sync() instead.
> > > > + * They don't do the same thing (they cancel the work instead of waiting
> > > > + * for it to complete), but in most cases they will suffice.
> > > > + */
> > > 
> > > And this is wrong advice.  If you've violated the entangled deadlock
> > > rules, the cancel functions will deadlock on you as well if the work is
> > > still pending.
> > 
> > No they won't.  They will remove the work item from the workqueue right
> > away, without blocking, assuming it hasn't started yet (i.e., is still 
> > pending).  This is a large part of their raison d'etre.
> 
> Yes, they will ... you advised the _sync function which waits if the
> work is in progress and hence induces the entanglement.  You can get
> away with this if you don't use _sync (but then you won't know when the
> queue is safely not touching any module code before removal).

This is partly a simple misunderstanding.  By "pending", I thought you
meant that the work item was still on the workqueue but had not yet
been invoked (i.e., "pending" as opposed to "running").  In that
situation there will be no deadlock, as I said.

But let's consider the case you bring up, where the work item _has_
started to run.  It's true that the work routine can cause deadlock by
violating the locking rules, regardless of whether you use
cancel_work_sync() or flush_scheduled_work().

Nevertheless, even in this case cancel_work_sync() is _still_ more
reliable than flush_schedule_work().  Example: Let's suppose you're
interested in work item A, which is at the head of the workqueue and
has already started running.  Let's also suppose that A doesn't violate
the locking rules (since otherwise things are hopeless).  Finally,
let's assume the workqueue contains a second unrelated work item, B.

Here's what can happen with flush_scheduled_work():

	CPU 0			CPU 1
	-----			-----
				A:	(invoked from workqueue)
				... does some stuff ...
	lock_mutex(&m);
	flush_scheduled_work();
	... waits ...
				A finishes
				B:	(invoked from workqueue)
				lock_mutex(&m);		/* Deadlock! */

Now consider the same situation with cancel_work_sync():

	CPU 0			CPU 1
	-----			-----
				A:	(invoked from workqueue)
				... does some stuff ...
	lock_mutex(&m);
	cancel_work_sync(&A);
	... waits ...
				A finishes
	... continues running ...
				B:	(invoked from workqueue)
				lock_mutex(&m);
	unlock_mutex(&m);
				... continues running ...

You can see the difference.  There's no doubt about it,
flush_scheduled_work() is more dangerous than cancel_work_sync().

Alan Stern

