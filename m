Return-Path: <linux-kernel-owner+w=401wt.eu-S1752355AbZDSXbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbZDSXbu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 19:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbZDSXbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 19:31:38 -0400
Received: from mail.crca.org.au ([67.207.131.56]:43360 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbZDSXbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 19:31:37 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH] PM/Suspend: Introduce two new platform callbacks to
 avoid breakage (Re: 900af0d breaks some embedded suspend/resume)
From: Nigel Cunningham <ncunningham-lkml@crca.org.au>
Reply-To: ncunningham-lkml@crca.org.au
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Len Brown <lenb@kernel.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
In-Reply-To: <200904182047.48009.rjw@sisk.pl>
References: <20090417231009.GB6900@flint.arm.linux.org.uk>
	 <200904181626.10388.rjw@sisk.pl>
	 <20090418144132.GC7148@flint.arm.linux.org.uk>
	 <200904182047.48009.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 09:31:47 +1000
Message-Id: <1240183907.8867.22.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, 2009-04-18 at 20:47 +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM/Suspend: Introduce two new platform callbacks to avoid breakage
> 
> Commit 900af0d973856d6feb6fc088c2d0d3fde57707d3 (PM: Change suspend
> code ordering) changed the ordering of suspend code in such a way
> that the platform .prepare() callback is now executed after the
> device drivers' late suspend callbacks have run.  Unfortunately, this
> turns out to break ARM platforms that need to talk via I2C to power
> control devices during the .prepare() callback.
> 
> For this reason introduce two new platform suspend callbacks,
> .prepare_late() and .wake(), that will be called just prior to
> disabling non-boot CPUs and right after bringing them back on line,
> respectively, and use them instead of .prepare() and .finish() for
> ACPI suspend.  Make the PM core execute the .prepare() and .finish()
> platform suspend callbacks where they were executed previously (that
> is, right after calling the regular suspend methods provided by
> device drivers and right before executing their regular resume
> methods, respectively).
> 
> It is not necessary to make analogous changes to the hibernation
> code and data structures at the moment, because they are only used
> by ACPI platforms.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  drivers/acpi/sleep.c    |    8 ++++----
>  include/linux/suspend.h |   36 ++++++++++++++++++++++++++----------
>  kernel/power/main.c     |   24 +++++++++++++++++-------
>  3 files changed, 47 insertions(+), 21 deletions(-)
> 
> Index: linux-2.6/kernel/power/main.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/main.c
> +++ linux-2.6/kernel/power/main.c
> @@ -291,20 +291,26 @@ static int suspend_enter(suspend_state_t
>  
>  	device_pm_lock();
>  
> +	if (suspend_ops->prepare) {
> +		error = suspend_ops->prepare();
> +		if (error)
> +			goto Done;
> +	}
> +
>  	error = device_power_down(PMSG_SUSPEND);
>  	if (error) {
>  		printk(KERN_ERR "PM: Some devices failed to power down\n");
> -		goto Done;
> +		goto Platfrom_finish;

s/Platfrom/Platform

Why retain the typo in multiple places?

>  	}
>  
> -	if (suspend_ops->prepare) {
> -		error = suspend_ops->prepare();
> +	if (suspend_ops->prepare_late) {
> +		error = suspend_ops->prepare_late();
>  		if (error)
>  			goto Power_up_devices;
>  	}

Doesn't this invalidate testing that's already been done? Drivers
implementing prepare() (arm omap1, pxa, omap2, s3c and powerpc mpc52xx
and lite5200) are now going to have it called pre device_power_down. Why
not call the new prepare() "prepare_early" and leave the current prepare
as it is in the place where it's already called?

The name is also very confusing. Prepare matches with Finish and
Prepare_late with wake. How about prepare and unprepare?

Reviewed-by: Nigel Cunningham <nigel@tuxonice.net>

Regards,

Nigel

