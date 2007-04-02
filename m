Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbXDBK4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbXDBK4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 06:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbXDBK4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 06:56:08 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2091 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbXDBK4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 06:56:06 -0400
Date: Mon, 2 Apr 2007 11:55:53 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Greg KH <gregkh@suse.de>, Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andres Salomon <dilinger@debian.org>
Subject: Re: [patch 2.6.21-rc5-git 1/2] fix hotplug for legacy platform drivers
Message-ID: <20070402105553.GA12153@flint.arm.linux.org.uk>
Mail-Followup-To: David Brownell <david-b@pacbell.net>,
	Greg KH <gregkh@suse.de>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	Andres Salomon <dilinger@debian.org>
References: <200703311455.38490.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703311455.38490.david-b@pacbell.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 02:55:38PM -0700, David Brownell wrote:
> --- g26.orig/drivers/pcmcia/pxa2xx_mainstone.c	2007-03-30 16:44:04.000000000 -0700
> +++ g26/drivers/pcmcia/pxa2xx_mainstone.c	2007-03-31 14:23:56.000000000 -0700
> @@ -175,6 +175,8 @@ static int __init mst_pcmcia_init(void)
>  	if (!mst_pcmcia_device)
>  		return -ENOMEM;
>  
> +	/* REVISIT just statically allocate the device */
> +	mst_pcmcia_device->dev.uevent_suppress = 0;

Such a comment indicates that you clearly do not understand why these
platform devices are dynamically allocated.

These are modules.  If they were statically allocated, then you have a
potential oops waiting to happen if you have the right ordering of user
accesses to sysfs coupled with an inopportune unload of such a driver -
the memory backing the platform device will be unexpectedly released
resulting in an access to freed memory.

The dynamic allocation interfaces for platform devices is there to
allow drivers to properly conform to the sysfs lifetime rules.

Any module statically allocating a device structure is just simply buggy.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
