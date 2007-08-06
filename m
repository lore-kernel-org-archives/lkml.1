Return-Path: <linux-kernel-owner+w=401wt.eu-S1764303AbXHFMYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764303AbXHFMYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 08:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXHFMYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 08:24:22 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:19310 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbXHFMYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 08:24:21 -0400
Date: Mon, 6 Aug 2007 14:24:51 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Javier Pello <javier.pello@urjc.es>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not 
 notified
Message-ID: <20070806142451.5d28d41c@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <46B37CF7.2020803@urjc.es>
References: <46B37CF7.2020803@urjc.es>
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

On Fri, 03 Aug 2007 21:07:35 +0200,
Javier Pello <javier.pello@urjc.es> wrote:

> 1. The first part changes kobject_uevent_env in lib/kobject_uevent.c
> to report a failure if both netlink_broadcast (if applicable) and
> call_usermodehelper fail to send the event to userspace. Nothing in
> the kernel seems to care about the return value of kobject_uevent_env,
> so this should not break anything.

Famous last words ;) I recall that things broke when the driver core
tried to care about the return code of kobject_uevent(), so this may
work if you check just in your special case.

> 
> 2. The second part changes _request_firmware in
> drivers/base/firmware_class.c to actually check the return value of
> kobject_uevent and skip the loading_timeout delay if the loading event
> was not delivered to userspace at all.

Note that kobject_uevent() returns 0 if the event has been filtered.

> 
> The patches apply cleanly against 2.6.23-rc1. Any suggestions or feedback
> will be welcome.

It would be better if you sent the patches seperately.

> 
> Javier
> 
> PS  Please CC: me on replies, as I am not subscribed to the list.
> 
> 
> ==========
> From: Javier Pello <javier.pello@urjc.es>
> 
> kobject_uevent: return an error if event was not delivered to userspace
> 
> Make kobject_uevent_env return an error to the caller if the event was
> not delivered to userspace either via netlink or via uevent_helper.
> 
> Signed-off-by: Javier Pello <javier.pello@urjc.es>
> 
> ---
> diff -u linux-2.6.22/lib/kobject_uevent.c linux-2.6.22-p/lib/kobject_uevent.c
> --- linux-2.6.22/lib/kobject_uevent.c	2007-07-09 01:32:17.000000000 +0200
> +++ linux-2.6.22-p/lib/kobject_uevent.c	2007-07-18 20:17:10.000000000 +0200
> @@ -186,7 +186,8 @@
>  			}
> 
>  			NETLINK_CB(skb).dst_group = 1;
> -			netlink_broadcast(uevent_sock, skb, 0, 1, GFP_KERNEL);
> +			retval = netlink_broadcast(uevent_sock, skb, 0, 1,
> +						GFP_KERNEL);

Maybe add a pr_debug() here for debugging?
>  		}
>  	}
>  #endif
> @@ -198,7 +199,18 @@
>  		argv [0] = uevent_helper;
>  		argv [1] = (char *)subsystem;
>  		argv [2] = NULL;
> -		call_usermodehelper (argv[0], argv, envp, UMH_WAIT_EXEC);
> +#if defined(CONFIG_NET)
> +		if (retval) {
> +			retval = call_usermodehelper (argv[0], argv, envp,
> +						UMH_WAIT_EXEC);
> +		} else {
> +			call_usermodehelper (argv[0], argv, envp,
> +						UMH_WAIT_EXEC);
> +		}
> +#else
> +		retval = call_usermodehelper (argv[0], argv, envp,
> +						UMH_WAIT_EXEC);
> +#endif
>  	}
> 
>  exit:

Here a pr_debug() may also be nice.

> 
> ==========
> From: Javier Pello <javier.pello@urjc.es>
> 
> request_firmware: skip timeout if userspace was not notified
> 
> Stop _request_firmware from setting up a timer and waiting for
> the firmware image to appear if kobject_uevent returns an error
> (meaning userspace was not notified at all).
> 
> This prevents useless delays if there is no userspace tool to
> provide the firmware image (eg during boot).
> 
> Signed-off-by: Javier Pello <javier.pello@urjc.es>
> 
> ---
> diff -u linux-2.6.22/drivers/base/firmware_class.c linux-2.6.22-p/drivers/base/firmware_class.c
> --- linux-2.6.22/drivers/base/firmware_class.c	2007-07-09 01:32:17.000000000 +0200
> +++ linux-2.6.22-p/drivers/base/firmware_class.c	2007-07-18 20:06:53.000000000 +0200
> @@ -420,8 +420,12 @@
>  			add_timer(&fw_priv->timeout);
>  		}
> 
> -		kobject_uevent(&f_dev->kobj, KOBJ_ADD);
> -		wait_for_completion(&fw_priv->completion);
> +		retval = kobject_uevent(&f_dev->kobj, KOBJ_ADD);
> +		if (retval) {
> +			fw_load_abort(fw_priv);
> +		} else {
> +			wait_for_completion(&fw_priv->completion);
> +		}
>  		set_bit(FW_STATUS_DONE, &fw_priv->status);
>  		del_timer_sync(&fw_priv->timeout);
>  	} else

Maybe add a small comment here?
