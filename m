Return-Path: <linux-kernel-owner+w=401wt.eu-S932593AbZDCOf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593AbZDCOf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbZDCOfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:35:48 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34108 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756612AbZDCOfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:35:48 -0400
Subject: Re: [PATCH] block: fix intermittent dm timeout based oops
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
In-Reply-To: <20090403143208.GA10005@schmichrtp.de.ibm.com>
References: <20090324071730.53D7118C7A2@pentland.suse.de>
	 <20090403143208.GA10005@schmichrtp.de.ibm.com>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 09:35:45 -0500
Message-Id: <1238769345.3359.15.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 16:32 +0200, Christof Schmitt wrote:
> On Tue, Mar 24, 2009 at 08:17:30AM +0100, Hannes Reinecke wrote:
> > Very rarely under stress testing of dm, oopses are occuring as
> > something tampers with an old stack frame.  This has been traced back
> > to blk_abort_queue() leaving a timeout_list pointing to the stack.
> > The reason is that sometimes blk_abort_request() won't delete the
> > timer (if the request is marked as complete but before the timer has
> > been removed, a small race window).  Fix this by splicing back from
> > the ususally empty list to the q->timeout_list.
> > 
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > ---
> >  block/blk-timeout.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/block/blk-timeout.c b/block/blk-timeout.c
> > index bbbdc4b..6213123 100644
> > --- a/block/blk-timeout.c
> > +++ b/block/blk-timeout.c
> > @@ -224,6 +224,12 @@ void blk_abort_queue(struct request_queue *q)
> >  	list_for_each_entry_safe(rq, tmp, &list, timeout_list)
> >  		blk_abort_request(rq);
> > 
> > +	/*
> > +	 * Occasionally, blk_abort_request() will return without
> > +	 * deleting the element from the list
> > +	 */
> > +	list_splice(&list, &q->timeout_list);
> > +
> >  	spin_unlock_irqrestore(q->queue_lock, flags);
> > 
> >  }
> > -- 
> > 1.5.3.2
> 
> I just noticed that this fix is not upstream yet and i have seen test
> cases hitting this problem.
> 
> Jens, are you going to included this patch, or should this go through
> the SCSI tree?

It's a block patch, so it goes through the block tree ... it also needs
backporting to stable.

James


