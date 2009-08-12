Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbZHLRZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbZHLRZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 13:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbZHLRZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 13:25:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38622 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751717AbZHLRZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 13:25:23 -0400
Date: Wed, 12 Aug 2009 13:25:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
In-Reply-To: <1250096538.4000.106.camel@mulgrave.site>
Message-ID: <Pine.LNX.4.44L0.0908121310460.23954-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009, James Bottomley wrote:

> > >      2. If you have to hold a lock while waiting:
> > >              1. If it's a global lock, make sure you're using a local
> > >                 queue and that nothing you submitted to the queue can
> > >                 take the lock
> > >              2. If it's a local lock, you may use a global queue but
> > >                 must still make sure that nothing you submitted to the
> > >                 queue can take the lock.

> > Anyway, 2.1 and 2.2 are wrong.  They should read: "... make sure that

(I overstated things; 2.1 is okay.  But 2.2. is wrong.  And 
flush_scheduled_work() definitely concerns a global queue.)

> > nothing submitted to the queue calls any of your routines that can take
> > the lock."  The point being that even though _you_ don't submit
> > anything bad to the queue, somebody else might do so.
> 
> Semantically "make sure that nothing submitted to the queue can take a
> lock" means exactly that ... it includes all routines called by the
> queue function.

James, you wrote "make sure that nothing _you_ submitted to the queue" 
(my emphasis).  That is quite different from "make sure that nothing 
submitted to the queue".  One is doable, the other isn't.

> > If you use cancel_work_sync() instead of flush_scheduled_work() then 
> > the rules become less onerous.  In place of your 2.1 and 2.2, we have:
> > 
> > 	Make sure the work item you are cancelling cannot take
> > 	the lock.
> > 
> > This is much easier to verify.
> 
> It's the same, surely ... you must verify that everything going on to
> the queue obeys the rules otherwise you get things on it which can't be
> cancelled ...

Not at all.  With cancel_work_sync() you must verify only that the
item you want to cancel obeys the rules.  There's no need to check the
other items -- and a public workqueue like keventd_wq certainly will
contain other items.

> and thus either the advice to call cancel is wrong, or we
> could call flush because the locking rules are obeyed.

No; as shown above, your logic is flawed.

Alan Stern

P.S.: Ingo, I rather expected to see you comment on this thread.  What 
is your opinion?

