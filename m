Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbZLIPfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbZLIPfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 10:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbZLIPfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 10:35:43 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:35663 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbZLIPfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 10:35:43 -0500
Date: Wed, 9 Dec 2009 09:37:40 -0600
From: scameron@beardog.cce.hp.com
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, achiang@hp.com,
       jens.axboe@oracle.com, mikem@beardog.cce.hp.com
Subject: Re: + hpsa-use-msleep-instead-of-schedule_timeout.patch added to -mm tree
Message-ID: <20091209153740.GG6940@beardog.cce.hp.com>
References: <200912082204.nB8M48oL027313@imap1.linux-foundation.org> <4B1ED241.4090803@gmail.com> <20091208144419.af6298ba.akpm@linux-foundation.org> <4B1F7324.9000402@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1F7324.9000402@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 10:51:32AM +0100, Jiri Slaby wrote:
> On 12/08/2009 11:44 PM, Andrew Morton wrote:
> > On Tue, 08 Dec 2009 23:25:05 +0100
> > Jiri Slaby <jirislaby@gmail.com> wrote:
> > 
> >> On 12/08/2009 11:04 PM, akpm@linux-foundation.org wrote:
> >>> Subject: hpsa: use msleep() instead of schedule_timeout
> >>> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> >>>
> >>> Use msleep() instead of schedule_timeout
> >>
> >> The patch does more than that and moreover in a wrong manner, see below.
> >>
> >>> @@ -3262,8 +3262,8 @@ static int hpsa_pci_init(struct ctlr_inf
> >>>  		if (!(readl(h->vaddr + SA5_DOORBELL) & CFGTBL_ChangeReq))
> >>>  			break;
> >>>  		/* delay and try again */
> >>> -		set_current_state(TASK_INTERRUPTIBLE);
> >>> -		schedule_timeout(10);
> >>> +		set_current_state(TASK_UNINTERRUPTIBLE);
> >>> +		msleep(10);
> >>
> >> Why do you change interruptible sleep to uninterruptible?
> > 
> > Stealth bugfix ;)
> > 
> > If the calling process (called "modprobe") has signal_pending()
> > (someone ^C'ed it) then the TASK_INTERRUPTIBLE sleep will be a no-op
> > and the driver will probably go and screw things up.
> 
> Ok, then it should have been in the changelog. The changelog was just
> "Use msleep() instead of schedule_timeout". Apart it doesn't mention why
> it is changed (it might be obvious for some that it's a cleanup), it
> doesn't do merely that.

Sorry.  I'll try to do better.  FWIW, these all get rolled up into one
big patch on account of this being a new driver not yet in Linus's
tree, so those change log entries wouldn't go into git anyway, so
far as I know.

> 
> >>> diff -puN drivers/scsi/hpsa.h~hpsa-use-msleep-instead-of-schedule_timeout drivers/scsi/hpsa.h
> >>> --- a/drivers/scsi/hpsa.h~hpsa-use-msleep-instead-of-schedule_timeout
> >>> +++ a/drivers/scsi/hpsa.h
> >> ...
> >>> @@ -139,7 +139,7 @@ struct ctlr_info {
> >>>  #define HPSA_BOARD_READY_ITERATIONS \
> >>>  	((HPSA_BOARD_READY_WAIT_SECS * 1000) / \
> >>>  		HPSA_BOARD_READY_POLL_INTERVAL_MSECS)
> >>> -#define HPSA_POST_RESET_PAUSE (30 * HZ)
> >>> +#define HPSA_POST_RESET_PAUSE_MSECS (3000)
> >>
> >> Ehm?
> > 
> > 30 seconds would have sucked anyway ;)
> 

BTW, I talked to a firmware guy familiar with the original problem
and he looked through the firmware code for the the controllers this
driver supports and said he couldn't see any reason it should take more
than a couple seconds, so, three seconds in the driver seems reasonable.
If it turns out that people start complaining that the boards aren't
getting initialized in time, we can revisit it.  It's also my own
experience that this section takes next to no time at all.

> Might be. But again, then it should be explained in the changelog. And
> as this is totally separate thing, also in a separate patch.
> 
> At least I though this is the politics.
> 
> thanks,
> -- 
> js
