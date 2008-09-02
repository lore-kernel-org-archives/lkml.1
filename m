Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbYIBOEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbYIBOEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 10:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbYIBOEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 10:04:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49574 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753758AbYIBOEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 10:04:05 -0400
Date: Tue, 2 Sep 2008 10:04:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Machek <pavel@suse.cz>
cc: Oliver Neukum <oneukum@suse.de>, <James.Bottomley@hansenpartnership.com>,
       <linux-kernel@vger.kernel.org>, <teheo@novell.com>,
       <stefanr@s5r6.in-berlin.de>, <Martin.Leisner@xerox.com>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] autosuspend for SCSI devices
In-Reply-To: <20080902090800.GA25178@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0809020957320.2489-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008, Pavel Machek wrote:

> > > > You'd make scsi driver writers' life easier if you made sure no autosuspends
> > > > happen while they recover from errors. After all, you have no idea which
> > > > commands will get through while the bus is in disarray.
> > > 
> > > Well, they have to handle other commands while bus has problems,
> > > anyway, right? So I'm not creating any _new_ problems for them. 
> > > 
> > > 									Pavel
> > 
> > 
> > I am afraid this is not true.
> 
> I guess you are right.

> ...but this should fix it, no? [incremental to previous]
> 									Pavel
> 
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index 3c184fe..7e5ea0d 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -10,6 +10,7 @@ #define DEBUG
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_device.h>
>  #include <scsi/scsi_host.h>
> +#include <scsi/scsi_eh.h>
>  
>  #include <linux/delay.h>
>  
> @@ -128,8 +129,11 @@ static int autosuspend_check(struct scsi
>  	if (!(sdev->sdev_state == SDEV_RUNNING ||
>  			sdev->sdev_state == SDEV_QUIESCE))
>  		return -ENODEV;
> +	if (!scsi_block_when_processing_errors(sdev))
> +		return -EBUSY;
>  
>  	suspend_time = sdev->last_busy + sdev->autosuspend_delay;
> +	/* FIXME: what if suspend_time - jiffies == -EPERM by some strange chance */
>  	if (time_before(jiffies, suspend_time))
>  		return suspend_time - jiffies;
>  	return 0;

If I'm not mistaken, while error hanlding is in progress we always have 
shost->shost_state equal to either SHOST_RECOVERY or 
SHOST_CANCEL_RECOVERY.  This is a better test to use.

Alan Stern

