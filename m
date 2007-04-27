Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbXD0VqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbXD0VqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757360AbXD0VqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:46:18 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44060 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757357AbXD0VqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:46:16 -0400
Date: Fri, 27 Apr 2007 22:49:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: torvalds@osdl.org
Subject: BAD PATCH: USB: remove use of the bus rwsem, as it doesn't really
 protect anything.
Message-ID: <20070427224932.34a03e2e@the-village.bc.nu>
In-Reply-To: <200704272059.l3RKxNPS023912@hera.kernel.org>
References: <200704272059.l3RKxNPS023912@hera.kernel.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Unless there is something I'm missing most of these patches seem totally
unsafe.

> --- a/drivers/usb/core/devices.c
> +++ b/drivers/usb/core/devices.c
> @@ -246,7 +246,6 @@ static char *usb_dump_interface_descriptor(char *start, char *end,
>  
>  	if (start > end)
>  		return start;
> -	down_read(&usb_bus_type.subsys.rwsem);
>  	if (iface) {
>  		driver_name = (iface->dev.driver
>  				? iface->dev.driver->name

iface->dev.driver can now become NULL during the evaluation above

> @@ -444,8 +441,6 @@ static int releaseintf(struct dev_state *ps, unsigned int ifnum)
>  	if (ifnum >= 8*sizeof(ps->ifclaimed))
>  		return err;
>  	dev = ps->dev;
> -	/* lock against other changes to driver bindings */
> -	down_write(&usb_bus_type.subsys.rwsem);
>  	intf = usb_ifnum_to_if(dev, ifnum);
>  	if (!intf)
>  		err = -ENOENT;
> @@ -453,7 +448,6 @@ static int releaseintf(struct dev_state *ps, unsigned int ifnum)
>  		usb_driver_release_interface(&usbfs_driver, intf);

Which takes iface->dev.driver to NULL

>  		err = 0;
>  	}
> -	up_write(&usb_bus_type.subsys.rwsem);
>  	return err;
>  }
>  
> @@ -813,7 +807,6 @@ static int proc_getdriver(struct dev_state *ps, void __user *arg)
>  
>  	if (copy_from_user(&gd, arg, sizeof(gd)))
>  		return -EFAULT;
> -	down_read(&usb_bus_type.subsys.rwsem);
>  	intf = usb_ifnum_to_if(ps->dev, gd.interface);
>  	if (!intf || !intf->dev.driver)
>  		ret = -ENODATA;

Ditto ...



