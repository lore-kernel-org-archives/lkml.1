Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYHLNBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYHLNBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYHLNAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:00:49 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:51721 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbYHLNAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:00:48 -0400
Date: Tue, 12 Aug 2008 15:59:02 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Subject: Re: [PATCH] PM: Remove WARN_ON from device_pm_add
Message-ID: <20080812125902.GB13910@cs181140183.pp.htv.fi>
References: <200808090105.14770.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200808090105.14770.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 01:05:13AM +0200, Rafael J. Wysocki wrote:
> PM: Remove WARN_ON from device_pm_add
> 
> Fix message in device_pm_add() saying that the device will not be
> added to dpm_list, although in fact the device is going to be added
> to the list regardless of the ordering violation.
> 
> Remove the WARN_ON(true) triggered in that situation, because it is
> hit by USB very often and spams the users' logs.
> 
> This patch fixes bug #11263

Michael Tsirkin said in #11284 (which is marked as a duplicate of #11263):

<--  snip  -->

> What exactly is this instability?

X often crashes on resume, sometimes ACPI seems to stop working
after resume. I am trying to figure exact way to reproduce first,
or get some relevant logs, then I'll report.

> Does 2.6.26 work fine?

yes

<--  snip  -->


Is this a separate regression or did the WARN_ON different from the 
first assumption indicate a functional regression?


> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/main.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/drivers/base/power/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/main.c
> +++ linux-2.6/drivers/base/power/main.c
> @@ -74,11 +74,9 @@ void device_pm_add(struct device *dev)
>  		 kobject_name(&dev->kobj));
>  	mutex_lock(&dpm_list_mtx);
>  	if (dev->parent) {
> -		if (dev->parent->power.status >= DPM_SUSPENDING) {
> -			dev_warn(dev, "parent %s is sleeping, will not add\n",
> +		if (dev->parent->power.status >= DPM_SUSPENDING)
> +			dev_warn(dev, "parent %s should not be sleeping\n",
>  				dev->parent->bus_id);
> -			WARN_ON(true);
> -		}
>  	} else if (transition_started) {
>  		/*
>  		 * We refuse to register parentless devices while a PM

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

