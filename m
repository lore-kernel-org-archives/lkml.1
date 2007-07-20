Return-Path: <linux-kernel-owner+w=401wt.eu-S1765921AbXGTJca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765921AbXGTJca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 05:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756740AbXGTJcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 05:32:22 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:57763 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498AbXGTJcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 05:32:20 -0400
Date: Fri, 20 Jul 2007 11:32:21 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kay.sievers@vrfy.org
Subject: Re: kobject link failure
Message-ID: <20070720113221.390ed32a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070720080059.GA29639@suse.de>
References: <Pine.LNX.4.64.0707191956510.31013@fbirervta.pbzchgretzou.qr>
	<469FA94E.20002@googlemail.com>
	<20070720080059.GA29639@suse.de>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007 01:00:59 -0700,
Greg KH <gregkh@suse.de> wrote:


> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -250,6 +250,7 @@ static struct kset_uevent_ops device_uev
>  	.uevent =	dev_uevent,
>  };
> 
> +#ifdef CONFIG_HOTPLUG
>  static ssize_t show_uevent(struct device *dev, struct device_attribute *attr,
>  			   char *buf)
>  {
> @@ -330,6 +331,23 @@ out:
>  static struct device_attribute uevent_attr =
>  	__ATTR(uevent, S_IRUGO | S_IWUSR, show_uevent, store_uevent);
> 
> +static int device_add_uevent_attr(struct device *dev)
> +{
> +	return device_create_file(dev, &uevent_attr);
> +}
> +
> +static void device_remove_uevent_attr(struct device *dev)
> +{
> +	device_remove_file(dev, &uevent_attr);
> +}
> +
> +#else	/* CONFIG_HOTPLUG */
> +
> +static inline int device_add_uevent_attr(struct device *dev) { return 0; }
> +static inline void device_remove_uevent_attr(struct device *dev) { }
> +
> +#endif	/* CONFIG_HOTPLUG */
> +
>  static int device_add_attributes(struct device *dev,
>  				 struct device_attribute *attrs)
>  {
> @@ -787,7 +805,7 @@ int device_add(struct device *dev)
>  		blocking_notifier_call_chain(&dev->bus->bus_notifier,
>  					     BUS_NOTIFY_ADD_DEVICE, dev);
> 
> -	error = device_create_file(dev, &uevent_attr);
> +	error = device_add_uevent_attr(dev);
>  	if (error)
>  		goto attrError;
> 
> @@ -861,7 +879,7 @@ int device_add(struct device *dev)
>  		}
>  	}
>   ueventattrError:
> -	device_remove_file(dev, &uevent_attr);
> +	device_remove_uevent_attr(dev);
>   attrError:
>  	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
>  	kobject_del(&dev->kobj);
> @@ -994,7 +1012,7 @@ void device_del(struct device * dev)
>  			up(&dev->class->sem);
>  		}
>  	}
> -	device_remove_file(dev, &uevent_attr);
> +	device_remove_uevent_attr(dev);
>  	device_remove_attrs(dev);
>  	bus_remove_device(dev);
> 

Hm, this would be an interface change (the uevent attribute used to
exist even for !CONFIG_HOTPLUG, it just triggered nothing). How about
moving kobject_actions[] out of the #ifdef (maybe next to
kobject_action)?
