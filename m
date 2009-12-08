Return-Path: <linux-kernel-owner+w=401wt.eu-S966782AbZLHWn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966782AbZLHWn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966427AbZLHWnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:43:22 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:15346 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319AbZLHWnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:43:21 -0500
Date: Tue, 8 Dec 2009 16:43:50 -0600
From: scameron@beardog.cce.hp.com
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       achiang@hp.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com
Subject: Re: + hpsa-use-msleep-instead-of-schedule_timeout.patch added to -mm tree
Message-ID: <20091208224350.GE6940@beardog.cce.hp.com>
References: <200912082204.nB8M48oL027313@imap1.linux-foundation.org> <4B1ED241.4090803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1ED241.4090803@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 11:25:05PM +0100, Jiri Slaby wrote:
> On 12/08/2009 11:04 PM, akpm@linux-foundation.org wrote:
> > Subject: hpsa: use msleep() instead of schedule_timeout
> > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > 
> > Use msleep() instead of schedule_timeout
> 
> The patch does more than that and moreover in a wrong manner, see below.
> 
> > @@ -3262,8 +3262,8 @@ static int hpsa_pci_init(struct ctlr_inf
> >  		if (!(readl(h->vaddr + SA5_DOORBELL) & CFGTBL_ChangeReq))
> >  			break;
> >  		/* delay and try again */
> > -		set_current_state(TASK_INTERRUPTIBLE);
> > -		schedule_timeout(10);
> > +		set_current_state(TASK_UNINTERRUPTIBLE);
> > +		msleep(10);
> 
> Why do you change interruptible sleep to uninterruptible? And you

Because the I think the interruptible was wrong, we aren't interested
in signals at this point.

> intermix jiffies with msecs. Use schedule_timeout_interruptible(10).

Probably it should have been msecs all along, not jiffies.  Looking at that particular
part of the code, it's very old, and might even be superflous given the controllers
this driver supports (and those it does not support.)  I'm thinking that
schedule_timeout(10) was written back when HZ was commonly 100, so that would
have been 100 msecs, not 10.  Considering the comment above this code describing
the circumstances that this is for, I doubt that code has ever run, actually.
You have to replace a failed drive just as driver is loading.

I will talk to the firmware guys and see if I can figure out what the original
case that lead to this code being put in is still relevant.  We might be
able to get rid of this section altogether.

> 
> > @@ -3302,7 +3302,8 @@ static int __devinit hpsa_init_one(struc
> >  
> >  		/* Some devices (notably the HP Smart Array 5i Controller)
> >  		   need a little pause here */
> > -		schedule_timeout_uninterruptible(HPSA_POST_RESET_PAUSE);
> > +		set_current_state(TASK_UNINTERRUPTIBLE);
> > +		msleep(HPSA_POST_RESET_PAUSE_MSECS);
> 
> Hmm, setting the state is superfluous, as msleep does the job itself.

Yeah, Andrew pointed that out and sent me a patch.  Thanks.

> 
> > diff -puN drivers/scsi/hpsa.h~hpsa-use-msleep-instead-of-schedule_timeout drivers/scsi/hpsa.h
> > --- a/drivers/scsi/hpsa.h~hpsa-use-msleep-instead-of-schedule_timeout
> > +++ a/drivers/scsi/hpsa.h
> ...
> > @@ -139,7 +139,7 @@ struct ctlr_info {
> >  #define HPSA_BOARD_READY_ITERATIONS \
> >  	((HPSA_BOARD_READY_WAIT_SECS * 1000) / \
> >  		HPSA_BOARD_READY_POLL_INTERVAL_MSECS)
> > -#define HPSA_POST_RESET_PAUSE (30 * HZ)
> > +#define HPSA_POST_RESET_PAUSE_MSECS (3000)
> 
> Ehm?

Jeez, you'd think I could multiply by 1000 without screwing up.  Guess not.

> 
> -- 
> js
