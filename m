Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbXGGXBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbXGGXBP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 19:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbXGGXBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 19:01:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34527 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbXGGXBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 19:01:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH -mm] Freezer: Handle uninterruptible tasks
Date: Sun, 8 Jul 2007 01:08:08 +0200
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <nigel@nigel.suspend2.net>
References: <20070706202629.GA158@tv-sign.ru> <200707070038.25830.oliver@neukum.org> <200707070100.17413.rjw@sisk.pl>
In-Reply-To: <200707070100.17413.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707080108.09783.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 7 July 2007 01:00, Rafael J. Wysocki wrote:
> On Saturday, 7 July 2007 00:38, Oliver Neukum wrote:
> > Am Freitag, 6. Juli 2007 schrieb Oleg Nesterov:
> > > Rafael J. Wysocki wrote:
> > > >
> > > > This patch makes the freezer skip uninterruptible user space tasks (ie. such
> > > > that have an mm of their own) when counting the tasks to be frozen.  As a
> > > > result, these tasks have the TIF_FREEZE and TIF_SIGPENDING flags set, but the
> > > > freezer doesn't wait for them to enter the refrigerator.  Nevertheless, they
> > > > will enter the refrigerator as soon as they change their state.
> > > 
> > > A small correction: they will enter the refrigerator on return to user-space.
> > 
> > That is too late. We would need them to go to sleep as soon as they are
> > woken up. This does not matter if they are in uninterruptible sleep due to
> > fuse deadlocking, as they won't be woken up, but it kills the other cases.
> 
> I'm sorry I can't write anything more about that right now, I'll write more
> tomorrow.
> 
> For now, I can only say that I have reasons to believe that the other cases
> are not likely to "leak" through the freezer.

OK, sorry for the delay.

The first reason is that a similar approach had been used by suspend2 for
quite some time without any visible adverse effects.  Of course this is not
a proof, but it means that the undesirable conditions are not easy to trigger
(if at all possible).

Next, if an uninterruptible task A waits on a mutex (or semaphore), then there
is a task B that holds it.  This task may be a kernel thread or a user space
process.  In the latter case it may also be uninterruptible, but then we can 
consider that task instead of A, so assume that B is interruptible.  In that
case, however, B is also freezable, but before it's frozen, it must release the
mutex.  In that case A will become freezable before B is frozen and the freezer
will have a chance to start to count A.  Thus, in that case A won't "leak"
through the freezer in the uninterruptible state.

Now, if B is a kernel thread, it might hold the mutex longer than the freezer
is running, but it has to have a reason for that.  Namely, I think that in
practice this can only happen if the resource protected by the lock is
unavailable.  In that case, task A may potentially cause problems to happen
if the resource becomes available during the suspend or resume at exactly
the right moment (eg. when .suspend() that task A may interfere with is being
executed).  IMO, this is unlikely.

I think that this also applies to the situation in which an uninterruptible task
waits for an event to occur (like a completion).  Namely, if the event waited
for by the task doesn't occur relatively quickly (like within a few scheduling
cycles), then it's likely not to occur throughout the entire suspend/resume
cycle.

This doesn't mean that no problems will happen no matter what, but at least
they are much less likely to happend than in the case when we remove the
freezer entirely without doing anything about the drivers before.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
