Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbZHLRgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbZHLRgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 13:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZHLRgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 13:36:37 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39951 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754687AbZHLRgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 13:36:35 -0400
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0908121310460.23954-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0908121310460.23954-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 17:36:33 +0000
Message-Id: <1250098593.4000.114.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 13:25 -0400, Alan Stern wrote:
> On Wed, 12 Aug 2009, James Bottomley wrote:
> 
> > > >      2. If you have to hold a lock while waiting:
> > > >              1. If it's a global lock, make sure you're using a local
> > > >                 queue and that nothing you submitted to the queue can
> > > >                 take the lock
> > > >              2. If it's a local lock, you may use a global queue but
> > > >                 must still make sure that nothing you submitted to the
> > > >                 queue can take the lock.
> 
> > > Anyway, 2.1 and 2.2 are wrong.  They should read: "... make sure that
> 
> (I overstated things; 2.1 is okay.  But 2.2. is wrong.  And 
> flush_scheduled_work() definitely concerns a global queue.)
> 
> > > nothing submitted to the queue calls any of your routines that can take
> > > the lock."  The point being that even though _you_ don't submit
> > > anything bad to the queue, somebody else might do so.
> > 
> > Semantically "make sure that nothing submitted to the queue can take a
> > lock" means exactly that ... it includes all routines called by the
> > queue function.
> 
> James, you wrote "make sure that nothing _you_ submitted to the queue" 
> (my emphasis).  That is quite different from "make sure that nothing 
> submitted to the queue".  One is doable, the other isn't.

If it's a local lock, how would something someone else submitted to the
queue, which would be out of scope, take this local lock?  A local lock,
by definition is local to the code scope you control.

> > > If you use cancel_work_sync() instead of flush_scheduled_work() then 
> > > the rules become less onerous.  In place of your 2.1 and 2.2, we have:
> > > 
> > > 	Make sure the work item you are cancelling cannot take
> > > 	the lock.
> > > 
> > > This is much easier to verify.
> > 
> > It's the same, surely ... you must verify that everything going on to
> > the queue obeys the rules otherwise you get things on it which can't be
> > cancelled ...
> 
> Not at all.  With cancel_work_sync() you must verify only that the
> item you want to cancel obeys the rules.  There's no need to check the
> other items -- and a public workqueue like keventd_wq certainly will
> contain other items.

Um, so this is called on driver removal, which is an asynchronous event.
Thus, how can you assure that what's on the queue (which you are
advocating calling cancel sync for) doesn't violate the locking rules at
the time the driver is removed, unless you assure that every piece of
work submitted doesn't violate them.

Thus the rules for calling flush and cancel sync are the same.

James


> > and thus either the advice to call cancel is wrong, or we
> > could call flush because the locking rules are obeyed.
> 
> No; as shown above, your logic is flawed.
> 
> Alan Stern
> 
> P.S.: Ingo, I rather expected to see you comment on this thread.  What 
> is your opinion?

