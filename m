Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042Ab0A2ITH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab0A2ITH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 03:19:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471Ab0A2ITF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 03:19:05 -0500
Received: from bamako.nerim.net ([62.4.17.28]:57188 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab0A2ITD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 03:19:03 -0500
Date: Fri, 29 Jan 2010 09:18:57 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Christian Kujau <lists@nerdbynature.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
       Stelian Pop <stelian@popies.net>,
       Michael Hanselmann <linux-kernel@hansmi.ch>
Subject: Re: i2c_powermac: Kernel access of bad area
Message-ID: <20100129091857.3b7228db@hyperion.delvare>
In-Reply-To: <20100107171738.2c83b13e@hyperion.delvare>
References: <alpine.DEB.2.01.0912281934170.3483@bogon.housecafe.de>
	<1262079255.2173.216.camel@pasglop>
	<20100106173745.57207520@hyperion.delvare>
	<alpine.DEB.2.01.1001061913310.3483@bogon.housecafe.de>
	<20100107171738.2c83b13e@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben, Christian,

On Thu, 7 Jan 2010 17:17:38 +0100, Jean Delvare wrote:
> On Wed, 6 Jan 2010 19:41:05 -0800 (PST), Christian Kujau wrote:
> > Hi Jean,
> > 
> > On Wed, 6 Jan 2010 at 17:37, Jean Delvare wrote:
> > > I think that sysfs files creation should be moved to the end of
> > > probe_thermostat() and sysfs files removal should be moved to the
> > > beginning of remove_thermostat(). Something like the totally untested
> > > patch below (no ppc machine at hand):
> > 
> > I applied your patch to 2.6.33-rc3, and was able to unload i2c-powermac and 
> > then reading the files left in /sys/devices/temperatures. I even tried to 
> > read the non-existant files (e.g. sensor1_fan_speed, etc...), but the 
> > kernel just wouldn't oops :)
> > 
> > So the initial oops is gone - yeah!

Ben, what about applying this patch of mine, as Christian reported it
fixed his oops?

> > However, the "Badness" remains when I try to modprobe i2c-powermac again:
> > 
> > [  442.148222] PowerMac i2c bus pmu 2 registered
> > [  442.148792] PowerMac i2c bus pmu 1 registered
> > [  442.149299] PowerMac i2c bus mac-io 0 registered
> > [  442.163573] adt746x: ADT7467 initializing
> > [  442.170072] adt746x: Lowering max temperatures from 73, 80, 109 to 67, 47, 67
> > [  442.176559] PowerMac i2c bus uni-n 1 registered
> > [  442.227115] sysfs: cannot create duplicate filename '/devices/ams'
> > [  442.227697] ------------[ cut here ]------------
> > [  442.228176] Badness at fs/sysfs/dir.c:487
> > [  442.228642] NIP: c00eb71c LR: c00eb71c CTR: 00000000
> > [  442.229117] REGS: eea0fa50 TRAP: 0700   Not tainted  (2.6.33-rc3)
> > [  442.229592] MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 42008444  XER: 00000000
> > [  442.230151] TASK = eea10000[2821] 'modprobe' THREAD: eea0e000
> > [  442.230191] GPR00: c00eb71c eea0fb00 eea10000 0000004c 000064c6 ffffffff ffffffff 00000000 
> > [  442.230758] GPR08: efa71740 c03e0000 00000000 000064c6 44008428 10020390 100e0000 100df49c 
> > [  442.231326] GPR16: 100b54c0 100df49c 100ddd20 1018fb08 100b5340 c03e674c c03e6720 c03ea044 
> > [  442.231902] GPR24: 00000000 24008422 ffffffea eea0fb58 ef0e9000 ef0e9000 ef0a9ea0 ffffffef 
> > [  442.233187] NIP [c00eb71c] sysfs_add_one+0x94/0xc0
> > [  442.233695] LR [c00eb71c] sysfs_add_one+0x94/0xc0
> > [  442.234363] Call Trace:
> > 
> > I've put the whole dmesg on:
> > 
> >    http://nerdbynature.de/bits/2.6.33-rc2/i2c_powermac/r1/
> 
> Hmm. Looks like a different but somewhat similar problem in the ams
> driver: some code that is in ams_exit() (the module exit code) should
> instead be called when the device (not module) is removed. It probably
> doesn't make much of a difference in the PMU case, but in the I2C case
> it does matter.
> 
> The following, totally untested patch may fix it. I make no guarantee
> that my code isn't racy though, I'm not familiar enough with the ams
> driver code to tell for sure.
> 
> ---
>  drivers/hwmon/ams/ams-core.c |   11 +++++++----
>  drivers/hwmon/ams/ams-i2c.c  |    2 ++
>  drivers/hwmon/ams/ams-pmu.c  |    2 ++
>  drivers/hwmon/ams/ams.h      |    1 +
>  4 files changed, 12 insertions(+), 4 deletions(-)
> 
> --- linux-2.6.33-rc3.orig/drivers/hwmon/ams/ams-core.c	2009-06-10 05:05:27.000000000 +0200
> +++ linux-2.6.33-rc3/drivers/hwmon/ams/ams-core.c	2010-01-07 17:14:25.000000000 +0100
> @@ -213,7 +213,7 @@ int __init ams_init(void)
>  	return -ENODEV;
>  }
>  
> -void ams_exit(void)
> +void ams_sensor_detach(void)
>  {
>  	/* Remove input device */
>  	ams_input_exit();
> @@ -221,9 +221,6 @@ void ams_exit(void)
>  	/* Remove attributes */
>  	device_remove_file(&ams_info.of_dev->dev, &dev_attr_current);
>  
> -	/* Shut down implementation */
> -	ams_info.exit();
> -
>  	/* Flush interrupt worker
>  	 *
>  	 * We do this after ams_info.exit(), because an interrupt might
> @@ -239,6 +236,12 @@ void ams_exit(void)
>  	pmf_unregister_irq_client(&ams_freefall_client);
>  }
>  
> +static void __exit ams_exit(void)
> +{
> +	/* Shut down implementation */
> +	ams_info.exit();
> +}
> +
>  MODULE_AUTHOR("Stelian Pop, Michael Hanselmann");
>  MODULE_DESCRIPTION("Apple Motion Sensor driver");
>  MODULE_LICENSE("GPL");
> --- linux-2.6.33-rc3.orig/drivers/hwmon/ams/ams-i2c.c	2009-06-10 05:05:27.000000000 +0200
> +++ linux-2.6.33-rc3/drivers/hwmon/ams/ams-i2c.c	2010-01-07 17:12:46.000000000 +0100
> @@ -238,6 +238,8 @@ static int ams_i2c_probe(struct i2c_clie
>  static int ams_i2c_remove(struct i2c_client *client)
>  {
>  	if (ams_info.has_device) {
> +		ams_sensor_detach();
> +
>  		/* Disable interrupts */
>  		ams_i2c_set_irq(AMS_IRQ_ALL, 0);
>  
> --- linux-2.6.33-rc3.orig/drivers/hwmon/ams/ams-pmu.c	2009-06-10 05:05:27.000000000 +0200
> +++ linux-2.6.33-rc3/drivers/hwmon/ams/ams-pmu.c	2010-01-07 17:13:47.000000000 +0100
> @@ -133,6 +133,8 @@ static void ams_pmu_get_xyz(s8 *x, s8 *y
>  
>  static void ams_pmu_exit(void)
>  {
> +	ams_sensor_detach();
> +
>  	/* Disable interrupts */
>  	ams_pmu_set_irq(AMS_IRQ_ALL, 0);
>  
> --- linux-2.6.33-rc3.orig/drivers/hwmon/ams/ams.h	2009-06-10 05:05:27.000000000 +0200
> +++ linux-2.6.33-rc3/drivers/hwmon/ams/ams.h	2010-01-07 17:11:43.000000000 +0100
> @@ -61,6 +61,7 @@ extern struct ams ams_info;
>  
>  extern void ams_sensors(s8 *x, s8 *y, s8 *z);
>  extern int ams_sensor_attach(void);
> +extern void ams_sensor_detach(void);
>  
>  extern int ams_pmu_init(struct device_node *np);
>  extern int ams_i2c_init(struct device_node *np);

Christian, did you ever test this second patch of mine? If you did,
what was the outcome?

-- 
Jean Delvare
