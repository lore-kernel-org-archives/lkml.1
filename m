Return-Path: <linux-kernel-owner+w=401wt.eu-S966797AbZLHWo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966797AbZLHWo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966658AbZLHWo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:44:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966589AbZLHWo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:44:26 -0500
Date: Tue, 8 Dec 2009 14:44:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, scameron@beardog.cce.hp.com,
       James.Bottomley@HansenPartnership.com, achiang@hp.com,
       jens.axboe@oracle.com, mikem@beardog.cce.hp.com
Subject: Re: + hpsa-use-msleep-instead-of-schedule_timeout.patch added to
 -mm tree
Message-Id: <20091208144419.af6298ba.akpm@linux-foundation.org>
In-Reply-To: <4B1ED241.4090803@gmail.com>
References: <200912082204.nB8M48oL027313@imap1.linux-foundation.org>
	<4B1ED241.4090803@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Dec 2009 23:25:05 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

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
> Why do you change interruptible sleep to uninterruptible?

Stealth bugfix ;)

If the calling process (called "modprobe") has signal_pending()
(someone ^C'ed it) then the TASK_INTERRUPTIBLE sleep will be a no-op
and the driver will probably go and screw things up.

> And you
> intermix jiffies with msecs. Use schedule_timeout_interruptible(10).
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

yup, I fixed those.

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

30 seconds would have sucked anyway ;)
