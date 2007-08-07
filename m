Return-Path: <linux-kernel-owner+w=401wt.eu-S1763038AbXHGUFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763038AbXHGUFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbXHGUFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:05:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48406 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754858AbXHGUFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:05:37 -0400
Date: Tue, 7 Aug 2007 13:05:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Javier Pello <javier.pello@urjc.es>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not 
 notified
Message-Id: <20070807130502.615d0112.akpm@linux-foundation.org>
In-Reply-To: <46B37CF7.2020803@urjc.es>
References: <46B37CF7.2020803@urjc.es>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Aug 2007 21:07:35 +0200
Javier Pello <javier.pello@urjc.es> wrote:

> Hi,
> 
> I have prepared a patch that makes request_firmware skip the usual
> grace period that it gives firmware images to show up, if it determines
> that userspace was not notified at all.
> 
> When request_firmware is called, it sends an event to userspace to
> ask for the firmware image that is needed, and then it installs a
> timeout so that it will not wait forever for the image. However,
> if userspace did not receive the event at all (no /sbin/hotplug,
> for instance), then having the kernel wait is pointless. This is
> particularly true during boot, when the wait is done synchronously
> and the whole kernel freezes for a minute.
> 
> The attached patch fixes this by making _request_firmware check whether
> the firmware loading event was succesfully sent to userspace, and skip
> the timeout if it has not. The patch comes in two parts:
> 
> 1. The first part changes kobject_uevent_env in lib/kobject_uevent.c
> to report a failure if both netlink_broadcast (if applicable) and
> call_usermodehelper fail to send the event to userspace. Nothing in
> the kernel seems to care about the return value of kobject_uevent_env,
> so this should not break anything.
> 
> 2. The second part changes _request_firmware in
> drivers/base/firmware_class.c to actually check the return value of
> kobject_uevent and skip the loading_timeout delay if the loading event
> was not delivered to userspace at all.
> 
> The patches apply cleanly against 2.6.23-rc1. Any suggestions or feedback
> will be welcome.
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

If uevent_helper[0] is \0 then this function can return success, even
though it didn't deliver anything to userspace.

I suppose that's correct behaviour: the operator configured the system to
disable the hotplug callout.  However in this scenario, the firmware laoder
will still needlessly implement the grace period.

It's probably not worth worrying about.
