Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbXL0Twi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbXL0Twi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 14:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbXL0Twa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 14:52:30 -0500
Received: from brick.kernel.dk ([87.55.233.238]:9188 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbXL0Tw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 14:52:29 -0500
Date: Thu, 27 Dec 2007 20:52:24 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Paul Mundt <lethal@linux-sh.org>, Adrian McMenamin <lkmladrian@gmail.com>,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] SH/Dreamcast - add support for GD-Rom device
Message-ID: <20071227195224.GG26896@kernel.dk>
References: <8b67d60712261726l28960f69u2eb2756a6f5176e1@mail.gmail.com> <20071227081822.GA22693@linux-sh.org> <1198759779.6170.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198759779.6170.4.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27 2007, Adrian McMenamin wrote:
> 
> On Thu, 2007-12-27 at 17:18 +0900, Paul Mundt wrote:
> > On Thu, Dec 27, 2007 at 01:26:47AM +0000, Adrian McMenamin wrote:
> 
> > 
> > > +		/* now seek to take the request spinlock
> > > + 		 * before handling ending the request */
> > > +		spin_lock(&gdrom_lock);
> > > +		list_del_init(&req->queuelist);
> > > +		blk_requeue_request(gd.gdrom_rq, req);
> > > +		if (err)
> > > +			end_request(req, 0);
> > > +		else
> > > +			end_request(req, 1);
> > > +	}
> > > +	spin_unlock(&gdrom_lock);
> > > +	kfree(read_command);
> > > +}	
> > > +
> > This locking is all over the place. What is this lock supposed to be
> > accomplishing?
> > -
> 
> I have to hold the lock to access the request queue. As the linked list
> of deferred requests is under the control of code also protected by the
> lock, it is also held to ensure manipulation of that list is serialised.
> 
> The first step of the loop manipulates that linked list - so it is held
> as we re-iterate over the loop.
> 
> This is pretty much the way Jens recommended I do it.

I didn't recommend the last requeue bit, it looks like a work-around due
to the way that end_request() works. The kerneldoc comment for that
function also tells you NOT to use this in new code. Use
end_dequeued_request() and get rid of the requeue, and streamline 'err'
so you can just pass it directly in.

The locking otherwise looks fine to me.

-- 
Jens Axboe

