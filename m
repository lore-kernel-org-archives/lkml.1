Return-Path: <linux-kernel-owner+w=401wt.eu-S1761000AbXGDNAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761000AbXGDNAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 09:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758142AbXGDNAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 09:00:21 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:50053 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617AbXGDNAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 09:00:20 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Wed, 4 Jul 2007 18:51:36 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Keiichi Kii <k-keiichi@bx.jp.nec.com>, Netdev <netdev@vger.kernel.org>,
       Joel Becker <joel.becker@oracle.com>, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH -mm 9/9] netconsole: Support dynamic reconfiguration
 using configfs
In-Reply-To: <20070704110824.28520.11661.sendpatchset@cselinux1.cse.iitk.ac.in>
Message-ID: <Pine.LNX.4.64.0707041829220.30225@cselinux1.cse.iitk.ac.in>
References: <20070704110739.28520.5036.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070704110824.28520.11661.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Some more thoughts I had on this, for those interested. ]

> +#ifdef	CONFIG_NETCONSOLE_DYNAMIC
> +
> +/*
> + * Targets that were created by parsing the boot/module option string
> + * do not exist in the configfs hierarchy and will never go away (and
> + * have zeroed-out config_item members). So make these a no-op for them.
> + */
> +static void netconsole_target_get(struct netconsole_target *nt)
> +{
> +	static struct config_item empty_item;	/* Zeroed-out config_item */
> +
> +	if (memcmp(&nt->item, &empty_item, sizeof(struct config_item)))
> +		config_item_get(&nt->item);
> +}
> +
> +static void netconsole_target_put(struct netconsole_target *nt)
> +{
> +	static struct config_item empty_item;	/* Zeroed-out config_item */
> +
> +	if (memcmp(&nt->item, &empty_item, sizeof(struct config_item)))
> +		config_item_put(&nt->item);
> +}
> +
> +#else	/* !CONFIG_NETCONSOLE_DYNAMIC */
> +
>  /*
> - * Allocate new target and setup netpoll for it.
> + * No danger of targets going away from under us when dynamic
> + * reconfigurability is off.
> + */
> +static void netconsole_target_get(struct netconsole_target *nt)
> +{
> +}
> +
> +static void netconsole_target_put(struct netconsole_target *nt)
> +{
> +}
> +
> +#endif	/* CONFIG_NETCONSOLE_DYNAMIC */

This whole stuff (and calls to netconsole_target_get and _put from code
below) is not necessary. All the access to the netconsole_target objects
(that are present in the target_list) happens inside
spin_lock_irqsave(target_list_lock), so there's no need to do a
config_item_get() on these as there is no race window in which userspace
can delete (and thus release) these items from under us. Note that
drop_netconsole_target() removes target-to-delete from target_list
(under spin_lock_irqsave) _before_ free'ing the objects, and that both
_get() and _put() are balanced *inside* a spin_lock_irqsave /
spin_unlock_irqrestore pair -- so all this business is quite pointless.

I've kept this stuff in for now, but would like to get rid of it, really.
It's an unnecessary #ifdef-#else-#endif kludge. Comments?

> +	if (nt->enabled) {
> +		printk(KERN_ERR "netconsole: target (id %d) is enabled, "
> +				"disable to update parameters\n", nt->id);
> +		return -EINVAL;
> +	}

[ Such code exists in all the store() operations for all attributes other
than "enabled" itself. ]

Anyway, the problem is that the error does not show up violently in the
shell. The write fails, of course, values are unchanged, and dmesg shows
the diagnostic outputted above -- but "echo" does not complain about
-EINVAL returning from write(2) for some reason, neither did -EACCES.
I guess "echo" needs to be fixed. BTW would -EACCES be more appropriate?

Satyam
