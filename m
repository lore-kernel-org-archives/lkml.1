Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbZHLS2C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbZHLS2C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 14:28:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbZHLS2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 14:28:01 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59689 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753857AbZHLS2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 14:28:01 -0400
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0908121407140.23954-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0908121407140.23954-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 18:27:57 +0000
Message-Id: <1250101677.8829.4.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 14:16 -0400, Alan Stern wrote:
> On Wed, 12 Aug 2009, James Bottomley wrote:
> 
> > If it's a local lock, how would something someone else submitted to the
> > queue, which would be out of scope, take this local lock?  A local lock,
> > by definition is local to the code scope you control.
> 
> This can happen easily.  Somebody else submits a work item to the
> queue, the work routine calls one of your publicly exported functions,
> and that function takes the local lock.

Fine, so local means not exported and not usable by exported functions.

> > > Not at all.  With cancel_work_sync() you must verify only that the
> > > item you want to cancel obeys the rules.  There's no need to check the
> > > other items -- and a public workqueue like keventd_wq certainly will
> > > contain other items.
> > 
> > Um, so this is called on driver removal, which is an asynchronous event.
> > Thus, how can you assure that what's on the queue (which you are
> > advocating calling cancel sync for) doesn't violate the locking rules at
> > the time the driver is removed, unless you assure that every piece of
> > work submitted doesn't violate them.
> 
> You can assure it by auditing the work routine's code.  A single work
> item involves a single function, plus whatever that function calls -- 
> it is easily checked.
> 
> You don't need to inspect every work item ever added to the queue, only 
> the one that you want to cancel.

This is true, but not relevant to the documentation you were trying to
add.  You're advocating using cancel sync as a replacement for flush ...
thus you have to cancel every pending piece of your work currently on
the queue.  My contention is that this means your rules for submission
if you do this must be the same as they would be if you'd just called
flush; making the advice moot.

James


> > Thus the rules for calling flush and cancel sync are the same.
> 
> They are not.  With cancel you need to verify that the one item you are
> cancelling obeys the rules.  With flush you need to verify that
> _everything_ on the queue is safe with respect to locking.
> 
> The only valid reason for a driver to call flush_scheduled_work()  
> would be that it knows there's an outstanding work item, which has to
> be completed or cancelled, but it doesn't have a pointer to the item.  
> Then cancellation is impossible.
> 
> Alan Stern

