Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbYBXOCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbYBXOCT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 09:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbYBXOCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 09:02:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52914 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbYBXOCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 09:02:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [Bug 10030] Suspend doesn't work when SD card is inserted
Date: Sun, 24 Feb 2008 15:00:41 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>
References: <Pine.LNX.4.44L0.0802232240530.29968-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802232240530.29968-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802241500.41969.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 24 of February 2008, Alan Stern wrote:
> On Sat, 23 Feb 2008, Alan Stern wrote:
> 
> > It happened in a workqueue.  There could be lots of similar cases: Some 
> > interrupt-driven event causes a hotplug action.  Since the action can't 
> > be carried out in interrupt context, the driver has no choice but to 
> > defer it to a workqueue or kernel thread.  Blocking that workqueue or 
> > kernel thread won't cause a problem _unless_ the driver's 
> > suspend/resume methods try to synchronize with it.  That's the 
> > difficult case.
> 
> In fact this turns out to be exactly the problem with the MMC
> subsystem.  It uses a dedicated workqueue (kmmcd) to handle state
> changes, and mmc_suspend_host() does a flush_workqueue().  If the
> workqueue contains an entry to register or unregister a device, this is
> guaranteed to deadlock -- and that's exactly what happens when Zdenek 
> inserts or removes a card during the disk-drive spindown time of a 
> system sleep.
> 
> It looks like the best solution is for mmc_suspend_host() not to flush
> the workqueue; instead the workqueue should prevent itself from
> running during a suspend.  Right now the easiest way to accomplish this
> is for the workqueue routines (mmc_detect() and siblings) to acquire
> the mmc_host's device semaphore.  If in the future the MMC subsystem
> adds dynamic PM support then a more complicated arrangement will be 
> needed.
> 
> So the patch below, in combination with the previous patch, might just 
> fix the whole problem.

The patch looks sane and I think you're right.

Still, it depends on us holding the device semaphores (if I understand it
correctly).  For this reason, I'd prefer to include it into the patch that adds
device locking to the PM core.

I think we should first remove the device locking from
drivers/base/power/main.c (that's the patch I'd like to push upstream now) and
then create a patch that will add it back along with all of the necessary
additional changes we know of (BTW, I've just received a message from another
user affected by it).

but we need to be careful with
all the details.  IMO, it would be 

Thanks,
Rafael

 
> Index: usb-2.6/drivers/mmc/core/core.c
> ===================================================================
> --- usb-2.6.orig/drivers/mmc/core/core.c
> +++ usb-2.6/drivers/mmc/core/core.c
> @@ -731,8 +731,6 @@ void mmc_stop_host(struct mmc_host *host
>   */
>  int mmc_suspend_host(struct mmc_host *host, pm_message_t state)
>  {
> -	mmc_flush_scheduled_work();
> -
>  	mmc_bus_get(host);
>  	if (host->bus_ops && !host->bus_dead) {
>  		if (host->bus_ops->suspend)
> Index: usb-2.6/drivers/mmc/core/mmc.c
> ===================================================================
> --- usb-2.6.orig/drivers/mmc/core/mmc.c
> +++ usb-2.6/drivers/mmc/core/mmc.c
> @@ -441,6 +441,7 @@ static void mmc_detect(struct mmc_host *
>  	BUG_ON(!host);
>  	BUG_ON(!host->card);
>  
> +	down(&mmc_classdev(host)->sem);
>  	mmc_claim_host(host);
>  
>  	/*
> @@ -449,6 +450,7 @@ static void mmc_detect(struct mmc_host *
>  	err = mmc_send_status(host->card, NULL);
>  
>  	mmc_release_host(host);
> +	up(&mmc_classdev(host)->sem);
>  
>  	if (err) {
>  		mmc_remove(host);
> Index: usb-2.6/drivers/mmc/core/sd.c
> ===================================================================
> --- usb-2.6.orig/drivers/mmc/core/sd.c
> +++ usb-2.6/drivers/mmc/core/sd.c
> @@ -500,6 +500,7 @@ static void mmc_sd_detect(struct mmc_hos
>  	BUG_ON(!host);
>  	BUG_ON(!host->card);
>  
> +	down(&mmc_classdev(host)->sem);
>  	mmc_claim_host(host);
>  
>  	/*
> @@ -508,6 +509,7 @@ static void mmc_sd_detect(struct mmc_hos
>  	err = mmc_send_status(host->card, NULL);
>  
>  	mmc_release_host(host);
> +	up(&mmc_classdev(host)->sem);
>  
>  	if (err) {
>  		mmc_sd_remove(host);
> Index: usb-2.6/drivers/mmc/core/sdio.c
> ===================================================================
> --- usb-2.6.orig/drivers/mmc/core/sdio.c
> +++ usb-2.6/drivers/mmc/core/sdio.c
> @@ -195,6 +195,7 @@ static void mmc_sdio_detect(struct mmc_h
>  	BUG_ON(!host);
>  	BUG_ON(!host->card);
>  
> +	down(&mmc_classdev(host)->sem);
>  	mmc_claim_host(host);
>  
>  	/*
> @@ -203,6 +204,7 @@ static void mmc_sdio_detect(struct mmc_h
>  	err = mmc_select_card(host->card);
>  
>  	mmc_release_host(host);
> +	up(&mmc_classdev(host)->sem);
>  
>  	if (err) {
>  		mmc_sdio_remove(host);
> 
> 
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
