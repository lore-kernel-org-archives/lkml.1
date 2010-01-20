Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246Ab0AXXlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab0AXXlU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 18:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090Ab0AXXlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 18:41:19 -0500
Received: from ip-85-161-27-212.eurotel.cz ([85.161.27.212]:34001 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751563Ab0AXXlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 18:41:18 -0500
X-Greylist: delayed 1409 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jan 2010 18:41:15 EST
Date: Wed, 20 Jan 2010 08:22:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, alan@linux.intel.com,
       charles.f.johnson@intel.com
Subject: Re: [PATCH] Add Linux Driver for Intel Langwell Watchdog
Message-ID: <20100120072206.GA1420@ucw.cz>
References: <1263849859-23265-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263849859-23265-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +#include <linux/uaccess.h>
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/sched.h>
> +#include <linux/signal.h>
> +#include <linux/sfi.h>
> +#include <linux/types.h>
> +#include <asm/irq.h>
> +#include <asm/atomic.h>
> +
> +/* See arch/x86/kernel/ipc_mrst.c */
> +#include <asm/ipc_defs.h>

WTF?

> +/* #include <asm/mrst.h> */

remove.

> +MODULE_PARM_DESC(timer_margin,
> +		"Watchdog timer margin"
> +		"Time between interrupt and resetting the system"
> +		"The range is from 1 to 160"
> +		"This is the time for all keep alives to arrive");

In miliseconds or what?

> +static int timer_set = DEFAULT_TIME;
> +module_param(timer_set, int, 0);
> +
> +MODULE_PARM_DESC(timer_set,
> +		"Default Watchdog timer setting"
> +		"Complete cycle time"
> +		"The range is from 1 to 170"
> +		"This is the time for all keep alives to arrive");
> +
> +/* driver will force boot on closure of device file */
> +static int force_boot = 1;
> +
> +module_param(force_boot, int, 0);
> +MODULE_PARM_DESC(force_boot,
> +		 "A value of 1 means that the driver will reboot"
> +		 "the system if the /dev/watchdog device is closed"
> +		 );

I'd hope watchdogs were somehow standardized?

> +/* This is used to force reboot if anyone tries to close this device */
> +static void watchdog_fire(void)
> +{
> +	module_put(THIS_MODULE);

Why?

> +	if (force_boot) {
> +		printk(KERN_CRIT PFX "Initiating system reboot.\n");
> +		emergency_restart();
> +		printk(KERN_CRIT PFX "Reboot didn't ?????\n");
> +	}
> +
> +	else {
> +		printk(KERN_CRIT PFX "Reboot would have happend\n");
> +		printk(KERN_CRIT PFX "You now have force_boot set to 0\n");
> +		printk(KERN_CRIT PFX "I am not rebooting\n");
> +	}

Little chatty?

> +/* timer interrupt handler */
> +irqreturn_t watchdog_timer_interrupt(int irq, void *dev_id)
> +{
> +	int int_status;
> +	int_status = ioread32(watchdog_device.timer_interrupt_status_addr);
> +
> +	pr_debug("Watchdog timer -  irq 7 interrupt received\n");

is it always irq 7?

> +static int langwell_set_heartbeat(u32 t)
> +{
> +	struct watchdog_reg_data reg_data;
> +
> +	watchdog_device.timer_set = t;
> +	watchdog_device.threshold =
> +	  timer_margin * watchdog_device.mtmr_ptr->freq;
> +	watchdog_device.soft_threshold =
> +	  (watchdog_device.timer_set - timer_margin)
> +	  * watchdog_device.mtmr_ptr->freq;
> +
> +	pr_debug("Watchdog timer - timer_margin is %x (hex) seconds\n",
> +	  timer_margin);
> +
> +	pr_debug("Watchdog timer - following are in clock cycles\n");
> +
> +	pr_debug("Watchdog timer - there are %x (hex) clock cycles\n",
> +	  watchdog_device.mtmr_ptr->freq);
> +
> +	pr_debug("Watchdog timer - per second\n");
> +
> +	pr_debug("Watchdog timer - thres is %x (hex) and warm is %x (hex)\n",
> +	  watchdog_device.threshold, watchdog_device.soft_threshold);
> +
> +	pr_debug("Watchdog timer - setting timer_set is %x (hex) seconds\n",
> +	  watchdog_device.timer_set);

Kill excessive debugging?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
