Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbZHLRCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbZHLRCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 13:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZHLRCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 13:02:24 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53470 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774AbZHLRCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 13:02:23 -0400
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0908121216500.9635-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0908121216500.9635-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 12:02:18 -0500
Message-Id: <1250096538.4000.106.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 12:23 -0400, Alan Stern wrote:
> On Wed, 12 Aug 2009, James Bottomley wrote:
> 
> > This all boils down to "the race window for a deadlock may be narrower".
> > 
> > Instead of training programmers to narrow deadlock races, we should be
> > training them to avoid them.
> > 
> > The entangled deadlock problem occurs in all of our _sync() APIs as well
> > as interrupt and other workqueue stuff.
> > 
> > The rules are something like
> > 
> > Never use synchronous operations if you can avoid them.  If you must use
> > operations that wait for another thread to complete (say because you're
> > about to destroy data structures that queued elements may be using):
> >      1. Never hold any locks or mutexes while waiting for the completion
> >         of synchronous operations
> >      2. If you have to hold a lock while waiting:
> >              1. If it's a global lock, make sure you're using a local
> >                 queue and that nothing you submitted to the queue can
> >                 take the lock
> >              2. If it's a local lock, you may use a global queue but
> >                 must still make sure that nothing you submitted to the
> >                 queue can take the lock.
> 
> I haven't seen these rules written down anywhere in the kernel 
> documentation.  Presumably people are supposed to be aware of them 
> already?

Um, well they seemed pretty obvious to me, so I just wrote them down.

> Anyway, 2.1 and 2.2 are wrong.  They should read: "... make sure that
> nothing submitted to the queue calls any of your routines that can take
> the lock."  The point being that even though _you_ don't submit
> anything bad to the queue, somebody else might do so.

Semantically "make sure that nothing submitted to the queue can take a
lock" means exactly that ... it includes all routines called by the
queue function.

> If you use cancel_work_sync() instead of flush_scheduled_work() then 
> the rules become less onerous.  In place of your 2.1 and 2.2, we have:
> 
> 	Make sure the work item you are cancelling cannot take
> 	the lock.
> 
> This is much easier to verify.

It's the same, surely ... you must verify that everything going on to
the queue obeys the rules otherwise you get things on it which can't be
cancelled ... and thus either the advice to call cancel is wrong, or we
could call flush because the locking rules are obeyed.

James


