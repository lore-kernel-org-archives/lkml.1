Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbXL0Mun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbXL0Mun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 07:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbXL0MuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 07:50:13 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:27570 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753AbXL0MuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 07:50:11 -0500
X-Trace: 646513311/mk-filter-4.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.80
X-SBRS: None
X-RemoteIP: 81.1.89.80
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAEcuc0dRAVlQ/2dsb2JhbACBV6o4
Subject: Re: [PATCH] SH/Dreamcast - add support for GD-Rom device
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Adrian McMenamin <lkmladrian@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org
In-Reply-To: <20071227081822.GA22693@linux-sh.org>
References: <8b67d60712261726l28960f69u2eb2756a6f5176e1@mail.gmail.com>
	 <20071227081822.GA22693@linux-sh.org>
Content-Type: text/plain
Date: Thu, 27 Dec 2007 12:49:39 +0000
Message-Id: <1198759779.6170.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-27 at 17:18 +0900, Paul Mundt wrote:
> On Thu, Dec 27, 2007 at 01:26:47AM +0000, Adrian McMenamin wrote:

> 
> > +		/* now seek to take the request spinlock
> > + 		 * before handling ending the request */
> > +		spin_lock(&gdrom_lock);
> > +		list_del_init(&req->queuelist);
> > +		blk_requeue_request(gd.gdrom_rq, req);
> > +		if (err)
> > +			end_request(req, 0);
> > +		else
> > +			end_request(req, 1);
> > +	}
> > +	spin_unlock(&gdrom_lock);
> > +	kfree(read_command);
> > +}	
> > +
> This locking is all over the place. What is this lock supposed to be
> accomplishing?
> -

I have to hold the lock to access the request queue. As the linked list
of deferred requests is under the control of code also protected by the
lock, it is also held to ensure manipulation of that list is serialised.

The first step of the loop manipulates that linked list - so it is held
as we re-iterate over the loop.

This is pretty much the way Jens recommended I do it.

