Return-Path: <linux-kernel-owner+w=401wt.eu-S1759080AbXEOUtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080AbXEOUtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 16:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbXEOUte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 16:49:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51347 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbXEOUtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 16:49:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: Freezeable workqueues [Was: 2.6.22-rc1: Broken suspend on SMP with tifm]
Date: Tue, 15 May 2007 22:54:33 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alex Dubov <oakad@yahoo.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>
References: <200705132132.08546.rjw@sisk.pl> <200705142327.37021.rjw@sisk.pl> <20070514214833.GA249@tv-sign.ru>
In-Reply-To: <20070514214833.GA249@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705152254.34402.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 May 2007 23:48, Oleg Nesterov wrote:
> On 05/14, Rafael J. Wysocki wrote:
> >
> > On Monday, 14 May 2007 18:55, Oleg Nesterov wrote:
> > > 
> > > Rafael, I am afraid we are making too much noise, and this may confuse Alex
> > > and Andrew.
> > > 
> > > First, we should decide how to fix the bug we have in 2.6.22. I prefer a simple
> > > "make freezeable workqueues singlethread" I sent. It was acked by Alex, it is
> > > simple, and it is also good because tifm doesn't need multithreaded wq anyway.
> > 
> > Yes, I've already agreed with that.
> 
> Ah, OK, I misunderstood your message as if you propose this fix for 2.6.22.

Never mind. :-)

> > > 	- Do we need freezeable workqueues ?
> > 
> > Well, we have at least one case in which they appear to be useful.
> 
> So, in the long term, should we change this only user, or we think we better fix
> freezeable wqs again?

Long term, I'd like to have freezable workqueues, so that people don't have to
use "raw" kernel threads only because they need some synchronization with
hibertnation/suspend.  Plus some cases in which workqueues are used by
fs-related code make me worry.

OTOH, I have some concerns with that (please see [*] below).
 
> > > WORK2->func() completes.
> > > 
> > > freezer comes. cwq->thread notices TIF_FREEZE and goes to refrigerator before
> > > executing that barrier.
> 
> This is not possible. cwq->thread _must_ notice the barrier before it goes to
> refrigerator.
> 
> So, given that we have cpu_populated_map we can re-introduce take_over_work()
> along with migrate_sequence and thus we can fix freezeable multithreaded wqs.

[*] The problem is, though, that freezable workqueus have some potential to fail
the freezer.  Namely, suppose task A calls flush_workqueue() on a freezable
workqueue, finds some work items in there, inserts the barrier and waits for
completion (TASK_UNINTERRUPTIBLE).  In the meantime, TIF_FREEZE is set on
the worker thread, which is then woken up and goes to the refrigerator.  Thus
if A is not NOFREEZE, the freezing of tasks will fail (A must be a kernel
thread for this to happen, but still).  Worse yet, if A is NOFREEZE, it will be
blocked until the worker thread is woken up.

To avoid this, I think, we may need to redesign the freezer, so that freezable
worker threads are frozen after all of the other kernel threads.  Additionally,
we'd need to make a rule that NOFREEZE kernel threads must not call
flush_workqueue() or cancel_work_sync() on freezable workqueues.

> > > If we have take_over_work() we should use it for any workqueue,
> > > freezeable or not. Otherwise this is just a mess, imho.
> 
> Still, this is imho true. So we'd better do some other changes to be consistent.

Agreed.

Greetings,
Rafael
