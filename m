Return-Path: <linux-kernel-owner+w=401wt.eu-S2993040AbXCIHhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993040AbXCIHhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993061AbXCIHhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:37:15 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2524 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993040AbXCIHhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:37:12 -0500
Date: Wed, 7 Mar 2007 21:07:17 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] swsusp: Disable nonboot CPUs before entering platform suspend
Message-ID: <20070307210716.GA4913@ucw.cz>
References: <200703072044.12021.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703072044.12021.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Prevent the WARN_ON() in arch/x86_64/kernel/acpi/sleep.c:init_low_mapping()
> from triggering by disabling nonboot CPUs before we finally enter the platform
> suspend.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  kernel/power/disk.c |    1 +
>  kernel/power/user.c |    2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.21-rc2-mm2/kernel/power/disk.c
> ===================================================================
> --- linux-2.6.21-rc2-mm2.orig/kernel/power/disk.c
> +++ linux-2.6.21-rc2-mm2/kernel/power/disk.c
> @@ -61,6 +61,7 @@ static void power_down(suspend_disk_meth
>  	switch(mode) {
>  	case PM_DISK_PLATFORM:
>  		if (pm_ops && pm_ops->enter) {
> +			disable_nonboot_cpus();
>  			kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
>  			pm_ops->enter(PM_SUSPEND_DISK);
>  			break;

...so, if pm_ops is non-null, power_down does nonboot cpu disabling,
otherwise we proceed with cpus enabled?

That looks ugly.

Is the warning bogus? Or maybe we should *always* disable nonboot cpus
in powerdown path?

> Index: linux-2.6.21-rc2-mm2/kernel/power/user.c
> ===================================================================
> --- linux-2.6.21-rc2-mm2.orig/kernel/power/user.c
> +++ linux-2.6.21-rc2-mm2/kernel/power/user.c
> @@ -398,9 +398,9 @@ static int snapshot_ioctl(struct inode *
>  
>  		case PMOPS_ENTER:
>  			if (data->platform_suspend) {
> +				disable_nonboot_cpus();
>  				kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
>  				error = pm_ops->enter(PM_SUSPEND_DISK);
> -				error = 0;
>  			}
>  			break;

Foe an userland application, disabling cpus during pmops_enter is at
least surprising.......

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
