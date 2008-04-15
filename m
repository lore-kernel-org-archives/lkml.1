Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbYDOGtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbYDOGtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 02:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYDOGtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 02:49:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752132AbYDOGtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 02:49:16 -0400
Date: Mon, 14 Apr 2008 23:48:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: s2ram: warn when interrupts should be disabled but are not
Message-Id: <20080414234840.917594ea.akpm@linux-foundation.org>
In-Reply-To: <20080412095311.GA1729@elf.ucw.cz>
References: <20080412095311.GA1729@elf.ucw.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008 11:53:11 +0200 Pavel Machek <pavel@ucw.cz> wrote:

> 
> sysdevs should be suspended/resumed with IRQs disabled; if something
> reenables them by mistake, we want to know early.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> ---
> commit fc3bccaf69e6c05464e7154369639bd5c96ccdc1
> tree bf960093ddb840242a00b4ec456ec79472b1c2ad
> parent 308e9d5309f378209e931f63f729806ec0a4d9f1
> author Pavel <pavel@amd.ucw.cz> Sat, 12 Apr 2008 11:52:05 +0200
> committer Pavel <pavel@amd.ucw.cz> Sat, 12 Apr 2008 11:52:05 +0200
> 
>  drivers/ata/ahci.c |    2 +-
>  drivers/base/sys.c |    3 +++
>  2 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/sys.c b/drivers/base/sys.c
> index 8e13fd9..e214467 100644
> --- a/drivers/base/sys.c
> +++ b/drivers/base/sys.c
> @@ -22,6 +22,7 @@ #include <linux/string.h>
>  #include <linux/pm.h>
>  #include <linux/device.h>
>  #include <linux/mutex.h>
> +#include <linux/hardirq.h>
>  
>  #include "base.h"
>  
> @@ -367,6 +368,7 @@ int sysdev_suspend(pm_message_t state)
>  			/* Call auxillary drivers first */
>  			list_for_each_entry(drv, &cls->drivers, entry) {
>  				if (drv->suspend) {
> +					WARN_ON(!irqs_disabled());
>  					ret = drv->suspend(sysdev, state);
>  					if (ret)
>  						goto aux_driver;

Is this warning ever triggers I expect we'll really really wish that
we'd done the check _after_ calling drv->suspend, and that we had also
done a print_symbol(drv->suspend).  No?


> @@ -442,6 +444,7 @@ int sysdev_resume(void)
>  		list_for_each_entry(sysdev, &cls->kset.list, kobj.entry) {
>  			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
>  
> +			WARN_ON(!irqs_disabled());
>  			__sysdev_resume(sysdev);
>  		}
>  	}

Perhaps here too.
