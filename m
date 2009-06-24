Return-Path: <linux-kernel-owner+w=401wt.eu-S1760040AbZFXQCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040AbZFXQCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbZFXQCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:02:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45065 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbZFXQCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:02:35 -0400
Date: Wed, 24 Jun 2009 18:02:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, ben-linux@fluff.org,
       hskinnemoen@atmel.com, anemo@mba.ocn.ne.jp, linux-usb@vger.kernel.org,
       rjw@sisk.pl, stern@rowland.harvard.edu,
       linux-pm@lists.linux-foundation.org, akpm@linux-foundation.org,
       linux-omap@vger.kernel.org, felipe.balbi@nokia.com
Subject: Re: [PATCH 07/07] pm: remove platform device
	suspend_late()/resume_early() V2
Message-ID: <20090624160227.GB6977@elf.ucw.cz>
References: <20090624092306.14276.127.sendpatchset@rx1.opensource.se> <20090624092409.14276.96577.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624092409.14276.96577.sendpatchset@rx1.opensource.se>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-06-24 18:24:09, Magnus Damm wrote:
> From: Magnus Damm <damm@igel.co.jp>
> 
> This is V2 of the platform driver power management late/early
> callback removal patch. The callbacks ->suspend_late() and
> ->resume_early() are removed since all in-tree users now have
> been migrated to dev_pm_ops.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>

Looks ok to me. ACK.

> ---
> 
>  Untested but compiles fine.
> 
>  Changes since V1:
>  - none, just rediff to fit upstream changes
> 
>  drivers/base/platform.c         |   36 ------------------------------------
>  include/linux/platform_device.h |    2 --
>  2 files changed, 38 deletions(-)
> 
> --- 0001/drivers/base/platform.c
> +++ work/drivers/base/platform.c	2009-06-24 17:27:33.000000000 +0900
> @@ -628,30 +628,6 @@ static int platform_legacy_suspend(struc
>  	return ret;
>  }
>  
> -static int platform_legacy_suspend_late(struct device *dev, pm_message_t mesg)
> -{
> -	struct platform_driver *pdrv = to_platform_driver(dev->driver);
> -	struct platform_device *pdev = to_platform_device(dev);
> -	int ret = 0;
> -
> -	if (dev->driver && pdrv->suspend_late)
> -		ret = pdrv->suspend_late(pdev, mesg);
> -
> -	return ret;
> -}
> -
> -static int platform_legacy_resume_early(struct device *dev)
> -{
> -	struct platform_driver *pdrv = to_platform_driver(dev->driver);
> -	struct platform_device *pdev = to_platform_device(dev);
> -	int ret = 0;
> -
> -	if (dev->driver && pdrv->resume_early)
> -		ret = pdrv->resume_early(pdev);
> -
> -	return ret;
> -}
> -
>  static int platform_legacy_resume(struct device *dev)
>  {
>  	struct platform_driver *pdrv = to_platform_driver(dev->driver);
> @@ -714,8 +690,6 @@ static int platform_pm_suspend_noirq(str
>  	if (drv->pm) {
>  		if (drv->pm->suspend_noirq)
>  			ret = drv->pm->suspend_noirq(dev);
> -	} else {
> -		ret = platform_legacy_suspend_late(dev, PMSG_SUSPEND);
>  	}
>  
>  	return ret;
> @@ -750,8 +724,6 @@ static int platform_pm_resume_noirq(stru
>  	if (drv->pm) {
>  		if (drv->pm->resume_noirq)
>  			ret = drv->pm->resume_noirq(dev);
> -	} else {
> -		ret = platform_legacy_resume_early(dev);
>  	}
>  
>  	return ret;
> @@ -797,8 +769,6 @@ static int platform_pm_freeze_noirq(stru
>  	if (drv->pm) {
>  		if (drv->pm->freeze_noirq)
>  			ret = drv->pm->freeze_noirq(dev);
> -	} else {
> -		ret = platform_legacy_suspend_late(dev, PMSG_FREEZE);
>  	}
>  
>  	return ret;
> @@ -833,8 +803,6 @@ static int platform_pm_thaw_noirq(struct
>  	if (drv->pm) {
>  		if (drv->pm->thaw_noirq)
>  			ret = drv->pm->thaw_noirq(dev);
> -	} else {
> -		ret = platform_legacy_resume_early(dev);
>  	}
>  
>  	return ret;
> @@ -869,8 +837,6 @@ static int platform_pm_poweroff_noirq(st
>  	if (drv->pm) {
>  		if (drv->pm->poweroff_noirq)
>  			ret = drv->pm->poweroff_noirq(dev);
> -	} else {
> -		ret = platform_legacy_suspend_late(dev, PMSG_HIBERNATE);
>  	}
>  
>  	return ret;
> @@ -905,8 +871,6 @@ static int platform_pm_restore_noirq(str
>  	if (drv->pm) {
>  		if (drv->pm->restore_noirq)
>  			ret = drv->pm->restore_noirq(dev);
> -	} else {
> -		ret = platform_legacy_resume_early(dev);
>  	}
>  
>  	return ret;
> --- 0001/include/linux/platform_device.h
> +++ work/include/linux/platform_device.h	2009-06-24 17:27:33.000000000 +0900
> @@ -57,8 +57,6 @@ struct platform_driver {
>  	int (*remove)(struct platform_device *);
>  	void (*shutdown)(struct platform_device *);
>  	int (*suspend)(struct platform_device *, pm_message_t state);
> -	int (*suspend_late)(struct platform_device *, pm_message_t state);
> -	int (*resume_early)(struct platform_device *);
>  	int (*resume)(struct platform_device *);
>  	struct device_driver driver;
>  	struct platform_device_id *id_table;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
