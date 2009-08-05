Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbZHEVtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbZHEVtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 17:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZHEVtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 17:49:06 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:38338 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbZHEVtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 17:49:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mJ6d/A/tPVZX43rjdxMV9g+FnCy+T40DWucQLoJbOdXP+uE4zZE9AK9Su0kzBuKXAZ
         WXKXF9ohAQyA/Rmszm1l4Ik7UQVSpDjlByCDEKFcluAm/eA7Doc+pOcCHO4emcfLQkez
         0II3E5nWI8vByCSsG9fN1fg4PevspiJdWRPrE=
MIME-Version: 1.0
In-Reply-To: <5DDAB7BA7BDB58439DD0EED0B8E9A3AE011CD92D@ausx3mpc102.aus.amer.dell.com>
References: <5DDAB7BA7BDB58439DD0EED0B8E9A3AE011CD92D@ausx3mpc102.aus.amer.dell.com>
Date: Wed, 5 Aug 2009 22:49:04 +0100
Message-ID: <9b2b86520908051449i566e06b4iec523e506346004c@mail.gmail.com>
Subject: Re: Network Device Naming mechanism and policy
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Jordan_Hargrave@dell.com
Cc: linux-kernel@vger.kernel.org, Matt_Domsch@dell.com, Narendra_K@dell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/09, Jordan_Hargrave@dell.com <Jordan_Hargrave@dell.com> wrote:
> This is from an old discussion several months ago:
> http://lkml.org/lkml/2009/3/24/357
> http://lkml.org/lkml/2009/3/24/380
>
> Basically the issue is that between a race in udev and PCI scan order the
> ethX IDs may not
> be consistent between reboots.  The idea is to use a mechanism similar to
> how disks now can
> be accessed by their LABEL/PATH/UUID instead of raw /dev/sdX ids.
>
> The following patch will create a device node for network devices based off
> their ifindex;
> udev can then use this device node for creating symlinks in /dev/net/xxxx
> similar to the
> way that disks now use by-label and by-path symlinks.
>
> Combining this with the biosdevname utility and patches to common network
> utilities,
> it could be possible to access ethernet devices by their PCI path or BIOS
> Label.
>
> eg. ifconfig Embedded_NIC_1
>
> --- include/linux/major.h~	2009-07-30 18:34:47.000000000 -0400
> +++ include/linux/major.h	2009-08-05 14:52:10.000000000 -0400
> @@ -169,6 +169,7 @@
>  #define IBM_FS3270_MAJOR	228
>
>  #define VIOTAPE_MAJOR		230
> +#define NETDEV_MAJOR		234
>
>  #define BLOCK_EXT_MAJOR		259
>  #define SCSI_OSD_MAJOR		260	/* open-osd's OSD scsi device */
> --- net/core/net-sysfs.cx	2009-08-05 15:00:13.000000000 -0400
> +++ net/core/net-sysfs.c	2009-08-05 15:01:20.000000000 -0400
> @@ -11,6 +11,7 @@
>
>  #include <linux/capability.h>
>  #include <linux/kernel.h>
> +#include <linux/major.h>
>  #include <linux/netdevice.h>
>  #include <linux/if_arp.h>
>  #include <net/sock.h>
> @@ -496,6 +497,7 @@ int netdev_register_kobject(struct net_d
>  	dev->class = &net_class;
>  	dev->platform_data = net;
>  	dev->groups = groups;
> +	dev->devt = MKDEV(NETDEV_MAJOR, net->ifindex);
>
>  	BUILD_BUG_ON(BUS_ID_SIZE < IFNAMSIZ);
>  	dev_set_name(dev, "%s", net->name);
>
>
> --jordan hargrave
> Dell Enterprise Linux Engineering

I guess opening such a device would yield ENODEV, which is
unfortunately misleading.  Pity to add code just to get ENOTSUPP,
but...

Idea: allow opening the device.  You needn't provide any operations.
The only effect would be to pin the ifindex.  That would allow tools
to avoid racing with hot-unplug.

Alan "Ideas are cheap" Jenkins

P.S. Is there any risk of ifindex overflowing when converted to a
device minor number?
