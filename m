Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbZHLSQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbZHLSQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 14:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbZHLSQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 14:16:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56377 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752545AbZHLSQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 14:16:30 -0400
Date: Wed, 12 Aug 2009 14:16:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
In-Reply-To: <1250098593.4000.114.camel@mulgrave.site>
Message-ID: <Pine.LNX.4.44L0.0908121407140.23954-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009, James Bottomley wrote:

> If it's a local lock, how would something someone else submitted to the
> queue, which would be out of scope, take this local lock?  A local lock,
> by definition is local to the code scope you control.

This can happen easily.  Somebody else submits a work item to the
queue, the work routine calls one of your publicly exported functions,
and that function takes the local lock.

> > Not at all.  With cancel_work_sync() you must verify only that the
> > item you want to cancel obeys the rules.  There's no need to check the
> > other items -- and a public workqueue like keventd_wq certainly will
> > contain other items.
> 
> Um, so this is called on driver removal, which is an asynchronous event.
> Thus, how can you assure that what's on the queue (which you are
> advocating calling cancel sync for) doesn't violate the locking rules at
> the time the driver is removed, unless you assure that every piece of
> work submitted doesn't violate them.

You can assure it by auditing the work routine's code.  A single work
item involves a single function, plus whatever that function calls -- 
it is easily checked.

You don't need to inspect every work item ever added to the queue, only 
the one that you want to cancel.

> Thus the rules for calling flush and cancel sync are the same.

They are not.  With cancel you need to verify that the one item you are
cancelling obeys the rules.  With flush you need to verify that
_everything_ on the queue is safe with respect to locking.

The only valid reason for a driver to call flush_scheduled_work()  
would be that it knows there's an outstanding work item, which has to
be completed or cancelled, but it doesn't have a pointer to the item.  
Then cancellation is impossible.

Alan Stern

