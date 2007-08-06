Return-Path: <linux-kernel-owner+w=401wt.eu-S1764035AbXHFUDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764035AbXHFUDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbXHFUDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:03:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60363 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074AbXHFUDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:03:38 -0400
Date: Mon, 6 Aug 2007 13:03:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Denis V. Lunev" <den@openvz.org>
Cc: dev@openvz.org, gregkh@suse.de, devel@openvz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci_get_device call from interrupt in reboot fixups
Message-Id: <20070806130326.87415ad0.akpm@linux-foundation.org>
In-Reply-To: <20070803103924.GA23786@iris.sw.ru>
References: <20070803103924.GA23786@iris.sw.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007 14:39:24 +0400 "Denis V. Lunev" <den@openvz.org> wrote:

> The following calltrace is possible now:
>  handle_sysrq
>    machine_emergency_restart
>      mach_reboot_fixups
>        pci_get_device
>          pci_get_subsys
> 	   down_read
> The patch obtains PCI device during initialization to avoid bothering PCI
> search engine in interrupt. Devices used in this code are not supposed to
> be pluggable, so it looks safe to keep them.
> 

hm.

> 
> diff --git a/arch/i386/kernel/reboot_fixups.c b/arch/i386/kernel/reboot_fixups.c
> index 03e1cce..873ad55 100644
> --- a/arch/i386/kernel/reboot_fixups.c
> +++ b/arch/i386/kernel/reboot_fixups.c
> @@ -37,6 +37,7 @@ struct device_fixup {
>  	unsigned int vendor;
>  	unsigned int device;
>  	void (*reboot_fixup)(struct pci_dev *);
> +	struct pci_dev *dev;
>  };
>  
>  static struct device_fixup fixups_table[] = {
> @@ -49,20 +50,35 @@ static struct device_fixup fixups_table[] = {
>   * is a fixup, we call it and we expect to never return from it. if we
>   * do return, we keep looking and then eventually fall back to the
>   * standard mach_reboot on return.
> + *
> + * Unfortunately, this code can be called from an interrupt and it is
> + * impossible to get PCI device directly. So, lets prepare the list
> + * beforehand.

This comment should tell the reader which interrupt path that is (ie: sysrq-B).

>   */
>  void mach_reboot_fixups(void)
>  {
>  	struct device_fixup *cur;
> -	struct pci_dev *dev;
>  	int i;
>  
>  	for (i=0; i < ARRAY_SIZE(fixups_table); i++) {
>  		cur = &(fixups_table[i]);
> -		dev = pci_get_device(cur->vendor, cur->device, NULL);
> -		if (!dev)
> +		if (cur->dev == NULL)
>  			continue;
>  
> -		cur->reboot_fixup(dev);
> +		cur->reboot_fixup(cur->dev);
> +	}
> +}
> +
> +int mach_fixup_init(void)
> +{
> +	struct device_fixup *cur;
> +	int i;
> +
> +	for (i=0; i < ARRAY_SIZE(fixups_table); i++) {
> +		cur = &(fixups_table[i]);
> +		cur->dev = pci_get_device(cur->vendor, cur->device, NULL);
>  	}
> +	return 0;
>  }
>  
> +module_init(mach_fixup_init);

I'm not sure that we want to make core PCI code capable of being called
from interrupt context just for the sake of sysrq-B.  It adds complexity
and maintenance hassles for something which is largely a debugging feature.

otoh, the patch is faily simple-looking and people _do_ use sysrq-B fairly
often so I guess we'll find out if we break it again.

otoh2, perhaps we can find some quicky hack on the sysrq patch to shut up
the might_sleep() warnings (which I presume is the only problem which is
presently being exhibited?).  Something like the unpleasant
oops_in_progress, perhaps.

Greg, any preferences?
