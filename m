Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021Ab0CAIjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 03:39:07 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:50184 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab0CAIjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 03:39:01 -0500
Date: Mon, 1 Mar 2010 09:38:56 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       "Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
       john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <20100301083855.GK3671@enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
	john stultz <johnstul@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <cover.1267008049.git.lasaine@lvk.cs.msu.su>
 <5ba28a271f7a26a73d869735a81aa8756276c85c.1267008049.git.lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ba28a271f7a26a73d869735a81aa8756276c85c.1267008049.git.lasaine@lvk.cs.msu.su>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv2 5/6] pps: add parallel port PPS signal generator
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 03:28:16PM +0300, Alexander Gordeev wrote:
> Add PPS signal generator which utilizes STROBE pin of a parallel port to
> send PPS signals. It uses parport abstraction layer and hrtimers to
> precisely control the signal.
> 
> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> ---
>  drivers/pps/Kconfig                      |    2 +
>  drivers/pps/Makefile                     |    1 +
>  drivers/pps/generators/Kconfig           |   17 ++
>  drivers/pps/generators/Makefile          |    9 +
>  drivers/pps/generators/pps_gen_parport.c |  264 ++++++++++++++++++++++++++++++
>  5 files changed, 293 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/pps/generators/Kconfig
>  create mode 100644 drivers/pps/generators/Makefile
>  create mode 100644 drivers/pps/generators/pps_gen_parport.c
> 
> diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
> index 2bd4f65..f3b14cd 100644
> --- a/drivers/pps/Kconfig
> +++ b/drivers/pps/Kconfig
> @@ -31,4 +31,6 @@ config PPS_DEBUG
>  	  messages to the system log.  Select this if you are having a
>  	  problem with PPS support and want to see more of what is going on.
>  
> +source drivers/pps/generators/Kconfig
> +
>  endmenu
> diff --git a/drivers/pps/Makefile b/drivers/pps/Makefile
> index 19ea582..b299814 100644
> --- a/drivers/pps/Makefile
> +++ b/drivers/pps/Makefile
> @@ -4,5 +4,6 @@
>  
>  pps_core-y			:= pps.o kapi.o sysfs.o
>  obj-$(CONFIG_PPS)		:= pps_core.o
> +obj-y				+= generators/

I suppose this patch doesn't apply on top of my latest PPS patchset,
does it?

   http://permalink.gmane.org/gmane.linux.kernel/954152

Generators support should be added after PPS clients one.

>  
>  ccflags-$(CONFIG_PPS_DEBUG) := -DDEBUG
> diff --git a/drivers/pps/generators/Kconfig b/drivers/pps/generators/Kconfig
> new file mode 100644
> index 0000000..9cc1118
> --- /dev/null
> +++ b/drivers/pps/generators/Kconfig
> @@ -0,0 +1,17 @@
> +#
> +# PPS clients configuration
> +#

s/clients/generators

> +
> +if PPS
> +
> +comment "PPS generators support"
> +
> +config PPS_GENERATOR_PARPORT
> +	tristate "Parallel port PPS signal generator"
> +	depends on PARPORT != n && GENERIC_TIME
> +	help
> +	  If you say yes here you get support for a PPS signal generator which
> +	  utilizes STROBE pin of a parallel port to send PPS signals. It uses
> +	  parport abstraction layer and hrtimers to precisely control the signal.
> +
> +endif
> diff --git a/drivers/pps/generators/Makefile b/drivers/pps/generators/Makefile
> new file mode 100644
> index 0000000..303304a
> --- /dev/null
> +++ b/drivers/pps/generators/Makefile
> @@ -0,0 +1,9 @@
> +#
> +# Makefile for PPS generators.
> +#
> +
> +obj-$(CONFIG_PPS_GENERATOR_PARPORT) += pps_gen_parport.o
> +
> +ifeq ($(CONFIG_PPS_DEBUG),y)
> +EXTRA_CFLAGS += -DDEBUG
> +endif
> diff --git a/drivers/pps/generators/pps_gen_parport.c b/drivers/pps/generators/pps_gen_parport.c
> new file mode 100644
> index 0000000..e7cce30
> --- /dev/null
> +++ b/drivers/pps/generators/pps_gen_parport.c
> @@ -0,0 +1,264 @@
> +/*
> + * pps_gen_parport.c -- kernel parallel port PPS signal generator
> + *
> + *
> + * Copyright (C) 2009   Alexander Gordeev <lasaine@lvk.cs.msu.su>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +
> +/*
> + * TODO:
> + * 1. module parameters
> + * 2. check that local interrupts are blocked in hrtimer handler
> + * 3. fix issues when realtime clock is adjusted in a leap
> + * 4. test under heavy load
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/time.h>
> +#include <linux/hrtimer.h>
> +#include <linux/parport.h>
> +
> +#define DRVNAME "pps_gen_parport"
> +#define DRVDESC "parallel port PPS signal generator"
> +
> +#define SIGNAL		0
> +#define NO_SIGNAL	PARPORT_CONTROL_STROBE
> +
> +#define SEND_DELAY	30000	/* delay between setting and
> +				   dropping the signal (ns) */
> +#define SAFETY_INTERVAL	3000	/* set the hrtimer earlier for safety (ns) */
> +
> +/* internal per port structure */
> +struct pps_generator_pp {
> +	struct pardevice *pardev;	/* parport device */
> +	struct hrtimer timer;
> +	long port_write_time;		/* calibrated port write time (ns) */
> +};
> +
> +static struct pps_generator_pp device = {
> +	.pardev = NULL,
> +};
> +
> +static int attached;
> +
> +/* calibrated time between a hrtimer event and the reaction */
> +static long hrtimer_error = SAFETY_INTERVAL;
> +
> +/* the kernel hrtimer event */
> +static enum hrtimer_restart hrtimer_event(struct hrtimer *timer)
> +{
> +	struct timespec expire_time, ts1, ts2, ts3, dts;
> +	struct pps_generator_pp *dev;
> +	struct parport *port;
> +	long lim, delta;
> +	unsigned long flags;
> +
> +	/* NB: approx time with blocked interrupts =
> +	   SEND_DELAY + 3 * SAFETY_INTERVAL */
> +	local_irq_save(flags);
> +
> +	/* first of all we get the time stamp... */
> +	getnstimeofday(&ts1);
> +	expire_time = ktime_to_timespec(timer->_expires);
> +	dev = container_of(timer, struct pps_generator_pp, timer);
> +	lim = NSEC_PER_SEC - SEND_DELAY - dev->port_write_time;
> +
> +	/* check if we are late */
> +	if (expire_time.tv_sec != ts1.tv_sec || ts1.tv_nsec > lim) {
> +		local_irq_restore(flags);
> +		pr_err(DRVNAME ": we are late this time %ld.%09ld\n",
> +				ts1.tv_sec, ts1.tv_nsec);
> +		goto done;
> +	}
> +
> +	/* busy loop until the time is right for an assert edge */
> +	do {
> +		getnstimeofday(&ts2);
> +	} while (expire_time.tv_sec == ts2.tv_sec && ts2.tv_nsec < lim);
> +
> +	/* set the signal */
> +	port = dev->pardev->port;
> +	port->ops->write_control(port, SIGNAL);
> +
> +	/* busy loop until the time is right for a clear edge */
> +	lim = NSEC_PER_SEC - dev->port_write_time;
> +	do {
> +		getnstimeofday(&ts2);
> +	} while (expire_time.tv_sec == ts2.tv_sec && ts2.tv_nsec < lim);
> +
> +	/* unset the signal */
> +	port->ops->write_control(port, NO_SIGNAL);
> +
> +	getnstimeofday(&ts3);
> +
> +	local_irq_restore(flags);
> +
> +	/* update calibrated port write time */
> +	dts = timespec_sub(ts3, ts2);
> +	dev->port_write_time =
> +		(dev->port_write_time + timespec_to_ns(&dts)) >> 1;
> +
> +done:
> +	/* update calibrated hrtimer error */
> +	dts = timespec_sub(ts1, expire_time);
> +	delta = timespec_to_ns(&dts);
> +	/* If the new error value is bigger then the old, use the new
> +	 * value, if not then slowly move towards the new value. This
> +	 * way it should be safe in bad conditions and efficient in
> +	 * good conditions.
> +	 */
> +	if (delta >= hrtimer_error)
> +		hrtimer_error = delta;
> +	else
> +		hrtimer_error = (3 * hrtimer_error + delta) >> 2;
> +
> +	/* update the hrtimer expire time */
> +	hrtimer_set_expires(timer,
> +			ktime_set(expire_time.tv_sec + 1,
> +				NSEC_PER_SEC - (SEND_DELAY +
> +				dev->port_write_time + SAFETY_INTERVAL +
> +				2 * hrtimer_error)));
> +
> +	return HRTIMER_RESTART;
> +}
> +
> +/* calibrate port write time */
> +#define PORT_NTESTS_SHIFT	5
> +static void calibrate_port(struct pps_generator_pp *dev)
> +{
> +	struct parport *port = dev->pardev->port;
> +	int i;
> +	long acc = 0;
> +
> +	for (i = 0; i < (1 << PORT_NTESTS_SHIFT); i++) {
> +		struct timespec a, b;
> +		unsigned long irq_flags;
> +
> +		local_irq_save(irq_flags);
> +		getnstimeofday(&a);
> +		port->ops->write_control(port, NO_SIGNAL);
> +		getnstimeofday(&b);
> +		local_irq_restore(irq_flags);
> +
> +		b = timespec_sub(b, a);
> +		acc += timespec_to_ns(&b);
> +	}
> +
> +	dev->port_write_time = acc >> PORT_NTESTS_SHIFT;
> +	pr_info(DRVNAME ": port write takes %ldns\n", dev->port_write_time);
> +}
> +
> +static inline ktime_t next_intr_time(struct pps_generator_pp *dev)
> +{
> +	struct timespec ts;
> +
> +	getnstimeofday(&ts);
> +
> +	return ktime_set(ts.tv_sec +
> +			((ts.tv_nsec > 990 * NSEC_PER_MSEC) ? 1 : 0),
> +			NSEC_PER_SEC - (SEND_DELAY +
> +			dev->port_write_time + 3 * SAFETY_INTERVAL));
> +}
> +
> +static void parport_attach(struct parport *port)
> +{
> +	if (attached) {
> +		/* we already have a port */
> +		return;
> +	}
> +
> +	device.pardev = parport_register_device(port, DRVNAME,
> +			NULL, NULL, NULL, 0, &device);
> +	if (!device.pardev) {
> +		pr_err(DRVNAME ": couldn't register with %s\n", port->name);
> +		return;
> +	}
> +
> +	if (parport_claim_or_block(device.pardev) < 0) {
> +		pr_err(DRVNAME ": couldn't claim %s\n", port->name);
> +		goto err_unregister_dev;
> +	}
> +
> +	pr_info(DRVNAME ": attached to %s\n", port->name);
> +	attached = 1;
> +
> +	calibrate_port(&device);
> +
> +	hrtimer_init(&device.timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
> +	device.timer.function = hrtimer_event;
> +#ifdef CONFIG_PREEMPT_RT
> +	/* hrtimer interrupt will run in the interrupt context with this */
> +	device.timer.irqsafe = 1;
> +#endif
> +
> +	hrtimer_start(&device.timer, next_intr_time(&device), HRTIMER_MODE_ABS);
> +
> +	return;
> +
> +err_unregister_dev:
> +	parport_unregister_device(device.pardev);
> +}
> +
> +static void parport_detach(struct parport *port)
> +{
> +	if (port->cad != device.pardev)
> +		/* not our port */
> +		return;

Please use:

if (port->cad != device.pardev)
        return;    /* not our port */

> +
> +	hrtimer_cancel(&device.timer);
> +	parport_release(device.pardev);
> +	parport_unregister_device(device.pardev);
> +}
> +
> +static struct parport_driver pps_gen_parport_driver = {
> +	.name = DRVNAME,
> +	.attach = parport_attach,
> +	.detach = parport_detach,
> +};
> +
> +/* module staff */
> +
> +static int __init pps_gen_parport_init(void)
> +{
> +	int ret;
> +
> +	pr_info(DRVNAME ": " DRVDESC "\n");
> +
> +	ret = parport_register_driver(&pps_gen_parport_driver);
> +	if (ret) {
> +		pr_err(DRVNAME ": unable to register with parport\n");
> +		return ret;
> +	}
> +
> +	return  0;
> +}
> +
> +static void __exit pps_gen_parport_exit(void)
> +{
> +	parport_unregister_driver(&pps_gen_parport_driver);
> +	pr_info(DRVNAME ": hrtimer avg error is %ldns\n", hrtimer_error);
> +}
> +
> +module_init(pps_gen_parport_init);
> +module_exit(pps_gen_parport_exit);
> +
> +MODULE_AUTHOR("Alexander Gordeev <lasaine@lvk.cs.msu.su>");
> +MODULE_DESCRIPTION(DRVDESC);
> +MODULE_LICENSE("GPL");
> -- 
> 1.6.6.1
> 

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
