Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbZHLU2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbZHLU2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 16:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbZHLU2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 16:28:19 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54872 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754768AbZHLU2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 16:28:18 -0400
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0908121432030.23954-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0908121432030.23954-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 20:28:13 +0000
Message-Id: <1250108893.8829.10.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 14:48 -0400, Alan Stern wrote:
> On Wed, 12 Aug 2009, James Bottomley wrote:
> 
> > On Wed, 2009-08-12 at 14:16 -0400, Alan Stern wrote:
> > > On Wed, 12 Aug 2009, James Bottomley wrote:
> > > 
> > > > If it's a local lock, how would something someone else submitted to the
> > > > queue, which would be out of scope, take this local lock?  A local lock,
> > > > by definition is local to the code scope you control.
> > > 
> > > This can happen easily.  Somebody else submits a work item to the
> > > queue, the work routine calls one of your publicly exported functions,
> > > and that function takes the local lock.
> > 
> > Fine, so local means not exported and not usable by exported functions.
> 
> I'll accept that.  However it means that the SCSI midlayer violates
> your own locking rules with regard to the scan mutex.  Whereas if
> flush_scheduled_work() were avoided, the locking rules would not be
> violated.

Why do you think I've been trying to get rid of it?  Global mutexes
covering large swathes of code are always a bad idea.  The async code
already picked up a deadlock entanglement with it.

> > > You can assure it by auditing the work routine's code.  A single work
> > > item involves a single function, plus whatever that function calls -- 
> > > it is easily checked.
> > > 
> > > You don't need to inspect every work item ever added to the queue, only 
> > > the one that you want to cancel.
> > 
> > This is true, but not relevant to the documentation you were trying to
> > add.  You're advocating using cancel sync as a replacement for flush ...
> > thus you have to cancel every pending piece of your work currently on
> > the queue.
> 
> In most cases there is only one or two work items to cancel.
>
> I'll stick my neck out even farther: In the majority of places where
> flush_scheduled_work() is used in the kernel, cancel_work_sync() would
> work just as well if not better, and it isn't used only because the
> code was written before cancel_work_sync() existed (or before the
> writer knew about it).
> 
> >  My contention is that this means your rules for submission
> > if you do this must be the same as they would be if you'd just called
> > flush; making the advice moot.
> 
> The rules for submission are _not_ the same.  With 
> flush_scheduled_work():
> 
> 	Make sure that any lock you hold while flushing is private
> 	and is not used (even indirectly) by any of your publicly 
> 	exported routines.
> 
> With cancel_work_sync():
> 
> 	Make sure that any lock you hold while cancelling is not
> 	used (even indirectly) by the work routine being cancelled.

The hair splitting has got to the point where I don't really care.  The
point is that flush_scheduled_work() and cancel_work_sync() have similar
problems.  Amazingly that was my original point.

James


