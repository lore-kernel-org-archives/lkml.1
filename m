Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbXFKTZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbXFKTZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756267AbXFKTYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:24:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39969 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756193AbXFKTYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:24:47 -0400
Date: Mon, 11 Jun 2007 12:24:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: Jeff Garzik <jeff@garzik.org>, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PHY fixed driver: rework release path and update phy_id
 notation
Message-Id: <20070611122432.30219cfd.akpm@linux-foundation.org>
In-Reply-To: <20070609162118.2680.99019.stgit@ACA800FC.ipt.aol.com>
References: <20070609162118.2680.99019.stgit@ACA800FC.ipt.aol.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 09 Jun 2007 20:21:18 +0400
Vitaly Bordug <vitb@kernel.crashing.org> wrote:

> 
> device_bind_driver() error code returning has been fixed. 
> release() function has been written, so that to free resources
> in correct way; the release path is now clean.
> 
> Before the rework, it used to cause
>  Device 'fixed@100:1' does not have a release() function, it is broken
>  and must be fixed.
>  BUG: at drivers/base/core.c:104 device_release()
>  
>  Call Trace:  
>   [<ffffffff802ec380>] kobject_cleanup+0x53/0x7e
>   [<ffffffff802ec3ab>] kobject_release+0x0/0x9
>   [<ffffffff802ecf3f>] kref_put+0x74/0x81
>   [<ffffffff8035493b>] fixed_mdio_register_device+0x230/0x265
>   [<ffffffff80564d31>] fixed_init+0x1f/0x35
>   [<ffffffff802071a4>] init+0x147/0x2fb
>   [<ffffffff80223b6e>] schedule_tail+0x36/0x92
>   [<ffffffff8020a678>] child_rip+0xa/0x12
>   [<ffffffff80311714>] acpi_ds_init_one_object+0x0/0x83
>   [<ffffffff8020705d>] init+0x0/0x2fb
>   [<ffffffff8020a66e>] child_rip+0x0/0x12  
> 
> 
> Also changed the notation of the fixed phy definition on
> mdio bus to the form of <speed>+<duplex> to make it able to be used by
> gianfar and ucc_geth that define phy_id strictly as "%d:%d"
> 
>  
>  static int fixed_mdio_register_device(int number, int speed, int duplex)
>  {
> @@ -221,6 +238,12 @@ static int fixed_mdio_register_device(int number, int speed, int duplex)
>  	}
>  
>  	fixed->regs = kzalloc(MII_REGS_NUM*sizeof(int), GFP_KERNEL);
> +	if (NULL == fixed->regs) {
> +		kfree(dev);
> +		kfree(new_bus);
> +		kfree(fixed);
> +		return -ENOMEM;
> +	}
>  	fixed->regs_num = MII_REGS_NUM;
>  	fixed->phy_status.speed = speed;
>  	fixed->phy_status.duplex = duplex;
> @@ -249,57 +272,43 @@ static int fixed_mdio_register_device(int number, int speed, int duplex)
>  	fixed->phydev = phydev;
>  
>  	if(NULL == phydev) {
> -		err = -ENOMEM;
> -		goto device_create_fail;
> +		kfree(dev);
> +		kfree(new_bus);
> +		kfree(fixed->regs);
> +		kfree(fixed);
> +		return -ENOMEM;
>  	}
>  
>  	phydev->irq = PHY_IGNORE_INTERRUPT;
>  	phydev->dev.bus = &mdio_bus_type;
>  
> -	if(number)
> -		snprintf(phydev->dev.bus_id, BUS_ID_SIZE,
> -				"fixed_%d@%d:%d", number, speed, duplex);
> -	else
> -		snprintf(phydev->dev.bus_id, BUS_ID_SIZE,
> -				"fixed@%d:%d", speed, duplex);
> +	snprintf(phydev->dev.bus_id, BUS_ID_SIZE,
> +				"%d:%d", number, speed + duplex);
> +
>  	phydev->bus = new_bus;
>  
> +	phydev->dev.driver = &fixed_mdio_driver.driver;
> + 	phydev->dev.release = fixed_mdio_release;
> + 
> + 	err = phydev->dev.driver->probe(&phydev->dev);
> + 	if(err < 0) {
> + 		printk(KERN_ERR "Phy %s: problems with fixed driver\n",
> +				phydev->dev.bus_id);
> + 		kfree(phydev);
> + 		kfree(dev);
> + 		kfree(new_bus);
> + 		kfree(fixed->regs);
> + 		kfree(fixed);
> + 		return err;
> + 	}

This is pretty fragile code.  It would be better to consolidate all the
cleanup in a single spot at the end of fixed_mdio_register_device() and to
then employ the usual `goto err_foo;' technique.

Generally, embedding multiple return points into a large function like this
is a thing we prefer to avoid: it increases the risk that later changes will
introduce resource leaks, locking errors, etc.


Also, the

	if (NULL == some_ptr)

thing does look rather weird.  It is normally done to force a compile error
if someone uses "=" instead of "==", but gcc will warn about that anyway,
so it isn't really needed.


