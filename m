Return-Path: <linux-kernel-owner+w=401wt.eu-S932287AbXBYTyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287AbXBYTyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 14:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932293AbXBYTyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 14:54:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:40243 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287AbXBYTyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 14:54:46 -0500
Date: Sun, 25 Feb 2007 20:54:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: stable@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Stefan Seyfried <seife@suse.de>
Subject: Re: [PATCH] swsusp: Fix possible oops in userland interface
Message-ID: <20070225195431.GD1746@elf.ucw.cz>
References: <200702242306.44445.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702242306.44445.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Stefan Seyfried <seife@suse.de>
> 
> Fix the Oops occuring when SNAPSHOT_PMOPS or SNAPSHOT_S2RAM ioctl is called on
> a system without pm_ops defined (eg. a non-ACPI kernel on x86 PC).
> 
> Signed-off-by: Stefan Seyfried <seife@suse.de>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.
									Pavel
> ---
> 
>  user.c |   19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> --- a/kernel/power/user.c	2007-02-01 01:07:38.000000000 +0100
> +++ b/kernel/power/user.c	2007-02-01 22:25:48.000000000 +0100
> @@ -292,7 +292,7 @@ static int snapshot_ioctl(struct inode *
>  			break;
>  		}
>  
> -		if (pm_ops->prepare) {
> +		if (pm_ops && pm_ops->prepare) {
>  			error = pm_ops->prepare(PM_SUSPEND_MEM);
>  			if (error)
>  				goto OutS3;
> @@ -311,7 +311,7 @@ static int snapshot_ioctl(struct inode *
>  			device_resume();
>  		}
>  		resume_console();
> -		if (pm_ops->finish)
> +		if (pm_ops && pm_ops->finish)
>  			pm_ops->finish(PM_SUSPEND_MEM);
>  
>   OutS3:
> @@ -322,20 +322,25 @@ static int snapshot_ioctl(struct inode *
>  		switch (arg) {
>  
>  		case PMOPS_PREPARE:
> -			if (pm_ops->prepare) {
> +			if (pm_ops && pm_ops->prepare)
>  				error = pm_ops->prepare(PM_SUSPEND_DISK);
> -			}
> +			else
> +				error = -ENOSYS;
>  			break;
>  
>  		case PMOPS_ENTER:
>  			kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
> -			error = pm_ops->enter(PM_SUSPEND_DISK);
> +			if (pm_ops && pm_ops->enter)
> +				error = pm_ops->enter(PM_SUSPEND_DISK);
> +			else
> +				error = -ENOSYS;
>  			break;
>  
>  		case PMOPS_FINISH:
> -			if (pm_ops && pm_ops->finish) {
> +			if (pm_ops && pm_ops->finish)
>  				pm_ops->finish(PM_SUSPEND_DISK);
> -			}
> +			else
> +				error = -ENOSYS;
>  			break;
>  
>  		default:

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
