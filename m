Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbYEEHZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbYEEHZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 03:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbYEEHYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 03:24:50 -0400
Received: from mail.suse.de ([195.135.220.2]:57353 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbYEEHYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 03:24:48 -0400
From: Neil Brown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Mon, 5 May 2008 17:24:31 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18462.46639.578272.994939@notabene.brown>
Cc: Jacek Luczak <difrost.kernel@gmail.com>,
       Prakash Punnoor <prakash@punnoor.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org
Subject: Re: WARNING in 2.6.25-07422-gb66e1f1
In-Reply-To: message from Jens Axboe on Sunday May 4
References: <200805031151.44287.prakash@punnoor.de>
	<481DB3F3.5080102@gmail.com>
	<20080504183839.GN12774@kernel.dk>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday May 4, jens.axboe@oracle.com wrote:
> On Sun, May 04 2008, Jacek Luczak wrote:
> > Hi,
> > 
> > I've CC:-ed few guys which may help.
> > 
> > Prakash Punnoor pisze:
> > > Hi, I got this on boot:
> > >
> > > usb 2-1.3: new full speed USB device using ehci_hcd and address 3
> > > usb 2-1.3: configuration #1 chosen from 1 choice
> > > Clocksource tsc unstable (delta = -117343945 ns)
> > > ------------[ cut here ]------------
> > > WARNING: at include/linux/blkdev.h:443 blk_remove_plug+0x7d/0x90()
...
> 
> Looks like it caught a real bug there - unfortunately we have to check
> for ->queue_lock here as well, if this is another stacked devices and
> not the bottom device. Does this make the warning go away for you?
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 087eee0..958f26b 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3264,6 +3264,8 @@ static void raid5_unplug_device(struct request_queue *q)
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&conf->device_lock, flags);
> +	if (q->queue_lock)
> +		spin_lock(q->queue_lock);
>  
>  	if (blk_remove_plug(q)) {
>  		conf->seq_flush++;
> @@ -3271,6 +3273,8 @@ static void raid5_unplug_device(struct request_queue *q)
>  	}
>  	md_wakeup_thread(mddev->thread);
>  
> +	if (q->queue_lock)
> +		spin_unlock(q->queue_lock);
>  	spin_unlock_irqrestore(&conf->device_lock, flags);
>  
>  	unplug_slaves(mddev);
> 

I suspect that will just cause more problems, as the 'q' for an md
device never gets ->queue_lock initialised.
I suspect the correct thing to do is set
	q->queue_lock = &conf->device_lock;

at some stage, probably immediately after device_lock is initialised
in 'run'.

I was discussing this with Dan Williams starting
  http://marc.info/?l=linux-raid&m=120951839903995&w=4
though we don't have an agreed patch yet.

I'm wondering why you mention the issues of stacked devices though.  I
don't see how it applies.  Could you explain?

Thanks,
NeilBrown
