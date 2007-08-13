Return-Path: <linux-kernel-owner+w=401wt.eu-S1030605AbXHMMxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030605AbXHMMxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S942116AbXHMHmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:42:49 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:34850 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S942490AbXHMHmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:42:45 -0400
Date: Mon, 13 Aug 2007 09:43:31 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] sysdev: remove global sysdev drivers list
Message-ID: <20070813094331.4bc53e2e@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070812044407.GA4573@APFDCB5C>
References: <20070812044407.GA4573@APFDCB5C>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 13:44:07 +0900,
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> No one uses sysdev_drivers. Because no one calls sysdev_driver_register
> with NULL class.
> 
> And it is difficult to imagine that someone want to implement a global
> sysdev driver which is called with all sys_device on any kind of
> sysdev_class.
> 
> So this patch removes global sysdev_drivers list.

This makes sense, I guess, especially since it simplyfies the code.

Some minor comments below.

> @@ -182,10 +179,12 @@ int sysdev_driver_register(struct sysdev
>  			list_for_each_entry(dev, &cls->kset.list, kobj.entry)
>  				drv->add(dev);
>  		}
> -	} else
> -		list_add_tail(&drv->entry, &sysdev_drivers);
> +	} else {
> +		err = -EINVAL;
> +		WARN_ON(1);

Maybe print what went wrong here?

> +	}
>  	mutex_unlock(&sysdev_drivers_lock);
> -	return 0;
> +	return err;
>  }
> 
> 
> @@ -206,6 +205,8 @@ void sysdev_driver_unregister(struct sys
>  				drv->remove(dev);
>  		}
>  		kset_put(&cls->kset);
> +	} else {
> +		WARN_ON(1);

This one is redundant, since you already warned on register.

>  	}
>  	mutex_unlock(&sysdev_drivers_lock);
>  }

> @@ -320,12 +310,6 @@ void sysdev_shutdown(void)
>  			struct sysdev_driver * drv;
>  			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
> 
> -			/* Call global drivers first. */
> -			list_for_each_entry(drv, &sysdev_drivers, entry) {
> -				if (drv->shutdown)
> -					drv->shutdown(sysdev);
> -			}
> -
>  			/* Call auxillary drivers next. */

This comment has become meaningless.

>  			list_for_each_entry(drv, &cls->drivers, entry) {
>  				if (drv->shutdown)

> @@ -393,15 +371,6 @@ int sysdev_suspend(pm_message_t state)
>  		list_for_each_entry(sysdev, &cls->kset.list, kobj.entry) {
>  			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
> 
> -			/* Call global drivers first. */
> -			list_for_each_entry(drv, &sysdev_drivers, entry) {
> -				if (drv->suspend) {
> -					ret = drv->suspend(sysdev, state);
> -					if (ret)
> -						goto gbl_driver;
> -				}
> -			}
> -
>  			/* Call auxillary drivers next. */

Dito here.

>  			list_for_each_entry(drv, &cls->drivers, entry) {
>  				if (drv->suspend) {
