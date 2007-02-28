Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbXB1Ja5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbXB1Ja5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 04:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932100AbXB1Ja5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 04:30:57 -0500
Received: from poczta.o2.pl ([193.17.41.142]:54792 "EHLO poczta.o2.pl"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932089AbXB1Ja4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 04:30:56 -0500
Date: Wed, 28 Feb 2007 10:34:37 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: jt@hpl.hp.com
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "David S\. Miller" <davem@davemloft.net>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.20] kobject net ifindex + rename
Message-ID: <20070228093437.GA1847@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228012741.GA3988@bougret.hpl.hp.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28-02-2007 02:27, Jean Tourrilhes wrote:
> 	Hi all,
...
> 	Patch for 2.6.20 is attached. The patch was tested on a system
> running the hotplug scripts, and on another system running udev.
> 
> 	Have fun...
> 
> 	Jean
> 
> Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>
> 
> ---------------------------------------------------------
...
> diff -u -p linux/net/core/net-sysfs.j1.c linux/net/core/net-sysfs.c
> --- linux/net/core/net-sysfs.j1.c	2007-02-27 15:01:08.000000000 -0800
> +++ linux/net/core/net-sysfs.c	2007-02-27 15:06:49.000000000 -0800
> @@ -412,6 +412,17 @@ static int netdev_uevent(struct class_de
>  	if ((size <= 0) || (i >= num_envp))
>  		return -ENOMEM;
>  
> +	/* pass ifindex to uevent.
> +	 * ifindex is useful as it won't change (interface name may change)
> +	 * and is what RtNetlink uses natively. */
> +	envp[i++] = buf;
> +	n = snprintf(buf, size, "IFINDEX=%d", dev->ifindex) + 1;
> +	buf += n;
> +	size -= n;
> +
> +	if ((size <= 0) || (i >= num_envp))

Btw.:
1. if size == 10 and snprintf returns 9 (without NULL)
   then n == 10 (with NULL), so isn't it enough (here and above):
 
	if ((size < 0) || (i >= num_envp))

2. shouldn't there be (here and above):
 
		envp[--i] = NULL;

> +		return -ENOMEM;
> +
>  	envp[i] = NULL;
>  	return 0;
>  }
...
> diff -u -p linux/drivers/base/class.j1.c linux/drivers/base/class.c
> --- linux/drivers/base/class.j1.c	2007-02-26 18:38:10.000000000 -0800
> +++ linux/drivers/base/class.c	2007-02-27 15:52:37.000000000 -0800
> @@ -841,6 +841,8 @@ int class_device_rename(struct class_dev
>  {
>  	int error = 0;
>  	char *old_class_name = NULL, *new_class_name = NULL;
> +	char *devname_string = NULL;
> +	char *envp[2];
>  
>  	class_dev = class_device_get(class_dev);
>  	if (!class_dev)
> @@ -849,6 +851,15 @@ int class_device_rename(struct class_dev
>  	pr_debug("CLASS: renaming '%s' to '%s'\n", class_dev->class_id,
>  		 new_name);
>  
> +	devname_string = kmalloc(strlen(class_dev->class_id) + 15, GFP_KERNEL);
> +	if (!devname_string) {
> +		class_device_put(class_dev);
> +		return -ENOMEM;
> +	}
> +	sprintf(devname_string, "INTERFACE_OLD=%s", class_dev->class_id);
> +	envp[0] = devname_string;
> +	envp[1] = NULL;
> +
>  #ifdef CONFIG_SYSFS_DEPRECATED
>  	if (class_dev->dev)
>  		old_class_name = make_class_name(class_dev->class->name,
> @@ -868,8 +879,16 @@ int class_device_rename(struct class_dev
>  		sysfs_remove_link(&class_dev->dev->kobj, old_class_name);
>  	}
>  #endif
> +
> +	/* This function is only used for network interface.
> +	 * Some hotplug package track interfaces by their name and
> +	 * therefore want to know when the name is changed by the user. */
> +	if(!error)
> +		kobject_uevent_env(&class_dev->kobj, KOBJ_RENAME, envp);
> +
>  	class_device_put(class_dev);
>  
> +	kfree(devname_string);

Maybe I miss something, but it seems kobject_uevent_env copies
pointers from envp instead of buffers' contents.

Regards,
Jarek P.
