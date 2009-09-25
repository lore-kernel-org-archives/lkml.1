Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZIYATm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZIYATm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 20:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbZIYATl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 20:19:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751568AbZIYATk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 20:19:40 -0400
Date: Thu, 24 Sep 2009 17:19:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave@sr71.net>
Cc: dave@sr71.net, rpurdie@rpsys.net, linux-kernel@vger.kernel.org,
       rgirod@confocus.com
Subject: Re: [PATCH] LED driver for Intel NAS SS4200 series
Message-Id: <20090924171929.8ce89786.akpm@linux-foundation.org>
In-Reply-To: <1253118732-11944-1-git-send-email-dave@sr71.net>
References: <1253118732-11944-1-git-send-email-dave@sr71.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009 09:32:12 -0700
Dave Hansen <dave@sr71.net> wrote:

> Changes from last version
> * Added dmi-basd hardware detection, and modparam
>   override for it
> * replaced DRIVER_NAME with KBUILD_MODNAME
> 
> --
> 
> This code is based on a driver that came in the "Open-source
> and GPL components" download here:
> 
> http://downloadcenter.intel.com/SearchResult.aspx?lang=eng&ProductFamily=Server+Products&ProductLine=Intel%C2%AE+Storage+Systems&ProductProduct=Intel%C2%AE+Entry+Storage+System+SS4200-E&OSVersion=OS+Independent
> 
> It was in a file called nasgpio.c inside of a second zip file.
> 
> That code used an ioctl() call to operate the LEDs.  It also
> created a new top-level /proc file just to let userspace locate
> which dynamic major number had been allocated to the device.
> Lovely.
> 
> I ripped out all of the hardware monitor support from nasgpio.c
> as well as the smbus code that controls the LED brightness.  I
> then converted the code to use the existing LED interfaces
> rather than the ioctl().
> 
> Except for the probe routines, I rewrote most of it.
> 
> Thanks go to Arjan for his help in getting the original source
> for this released and for chasing down some licensing issues.
> 
> Signed-off-by: Dave Hansen <dave@sr71.net>

We don't have Rodney's Signed-off-by:?

> ---
>  drivers/leds/Kconfig       |    9 +
>  drivers/leds/Makefile      |    1 +
>  drivers/leds/leds-ss4200.c |  551 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 561 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/leds/leds-ss4200.c
> 
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 7c8e712..ae6ed6e 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -229,6 +229,15 @@ config LEDS_BD2802
>  	  This option enables support for BD2802GU RGB LED driver chips
>  	  accessed via the I2C bus.
>  
> +config LEDS_INTEL_SS4200
> +	tristate "LED driver for Intel NAS SS4200 series"
> +	depends on LEDS_CLASS && PCI

Does it need a dependency on DMI?

> +	help
> +	  This option enables support for the Intel SS4200 series of
> +	  Network Attached Storage servers.  You may control the hard
> +	  drive or power LEDs on the front panel.  Using this driver
> +	  can stop the front LED from blinking after startup.
> +
>
> ...
>
> +void nasgpio_led_set_attr(struct led_classdev *led_cdev, u32 port, u32 value)
> +{
> +	struct nasgpio_led *led = led_classdev_to_nasgpio_led(led_cdev);
> +	u32 gpio_out;
> +
> +	gpio_out = inl(nas_gpio_io_base + port);
> +	if (value)
> +		gpio_out |= (1<<led->gpio_bit);
> +	else
> +		gpio_out &= ~(1<<led->gpio_bit);
> +
> +	outl(gpio_out, nas_gpio_io_base + port);
> +}

This function needs locking, but doesn't have it.

> +u32 nasgpio_led_get_attr(struct led_classdev *led_cdev, u32 port)
> +{
> +	struct nasgpio_led *led = led_classdev_to_nasgpio_led(led_cdev);
> +	u32 gpio_in;
> +
> +	spin_lock(&nasgpio_gpio_lock);
> +	gpio_in = inl(nas_gpio_io_base + port);
> +	spin_unlock(&nasgpio_gpio_lock);
> +	if (gpio_in & (1<<led->gpio_bit))
> +		return 1;
> +	return 0;
> +}

This function doesn't need locking, but has it.

> +/*
> + * There is actual brightness control in the hardware,
> + * but it is via smbus commands and not implemented
> + * in this driver.
> + */
> +static void nasgpio_led_set_brightness(struct led_classdev *led_cdev,
> +				       enum led_brightness brightness)
> +{
> +	u32 setting = 0;
> +	if (brightness >= LED_HALF)
> +		setting = 1;
> +	/*
> +	 * Hold the lock across both operations.  This ensures
> +	 * consistency so that both the "turn off blinking"
> +	 * and "turn light off" operations complete as a set.
> +	 */
> +	spin_lock(&nasgpio_gpio_lock);
> +	/*
> +	 * LED class documentation asks that past blink state
> +	 * be disabled when brightness is turned to zero.
> +	 */
> +	if (brightness == 0)
> +		nasgpio_led_set_attr(led_cdev, GPO_BLINK, 0);
> +	nasgpio_led_set_attr(led_cdev, GP_LVL, setting);
> +	spin_unlock(&nasgpio_gpio_lock);
> +}

Oh.  There's the locking.  How weird.

> +static int nasgpio_led_set_blink(struct led_classdev *led_cdev,
> +				 unsigned long *delay_on,
> +				 unsigned long *delay_off)
> +{
> +	u32 setting = 1;
> +	if (!(*delay_on == 0 && *delay_off == 0) &&
> +	    !(*delay_on == 500 && *delay_off == 500))
> +		return -EINVAL;
> +	/*
> +	 * These are very approximate.
> +	 */
> +	*delay_on = 500;
> +	*delay_off = 500;
> +
> +	spin_lock(&nasgpio_gpio_lock);
> +	nasgpio_led_set_attr(led_cdev, GPO_BLINK, setting);
> +	spin_unlock(&nasgpio_gpio_lock);
> +
> +	return 0;
> +}

And again.

> +
> +/*
> + * Initialize the ICH7 GPIO registers for NAS usage.  The BIOS should have
> + * already taken care of this, but we will do so in a non destructive manner
> + * so that we have what we need whether the BIOS did it or not.
> + */
> +static int ich7_gpio_init(struct device *dev)
> +{
> +	int i;
> +	u32 config_data = 0;
> +	u32 all_nas_led = 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(nasgpio_leds); i++)
> +		all_nas_led |= (1<<nasgpio_leds[i].gpio_bit);
> +
> +	spin_lock(&nasgpio_gpio_lock);
> +	/*
> +	 * We need to enable all of the GPIO lines used by the NAS box,
> +	 * so we will read the current Use Selection and add our usage
> +	 * to it.  This should be benign with regard to the original
> +	 * BIOS configuration.
> +	 */
> +	config_data = inl(nas_gpio_io_base + GPIO_USE_SEL);
> +	dev_printk(KERN_DEBUG, dev, "Data read from GPIO_USE_SEL = 0x%08x\n",
> +					config_data);
> +	config_data |= all_nas_led + NAS_RECOVERY;
> +	outl(config_data, nas_gpio_io_base + GPIO_USE_SEL);
> +	config_data = inl(nas_gpio_io_base + GPIO_USE_SEL);
> +	dev_printk(KERN_DEBUG, dev, "GPIO_USE_SEL = 0x%08x\n\n",
> +					config_data);
> +
> +	/*
> +	 * The LED GPIO outputs need to be configured for output, so we
> +	 * will ensure that all LED lines are cleared for output and the
> +	 * RECOVERY line ready for input.  This too should be benign with
> +	 * regard to BIOS configuration.
> +	 */
> +	config_data = inl(nas_gpio_io_base + GP_IO_SEL);
> +	dev_printk(KERN_DEBUG, dev, "Data read from GP_IO_SEL = 0x%08x\n",
> +					config_data);
> +	config_data &= ~all_nas_led;
> +	config_data |= NAS_RECOVERY;
> +	outl(config_data, nas_gpio_io_base + GP_IO_SEL);
> +	config_data = inl(nas_gpio_io_base + GP_IO_SEL);
> +	dev_printk(KERN_DEBUG, dev, "GP_IO_SEL = 0x%08x\n\n",
> +					config_data);
> +
> +	/*
> +	 * In our final system, the BIOS will initialize the state of all
> +	 * of the LEDs.  For now, we turn them all off (or Low).
> +	 */
> +	config_data = inl(nas_gpio_io_base + GP_LVL);
> +	dev_printk(KERN_DEBUG, dev, "Data read from GP_LVL = 0x%08x\n",
> +				   config_data);
> +	/*
> +	 * In our final system, the BIOS will initialize the blink state of all
> +	 * of the LEDs.  For now, we turn blink off for all of them.
> +	 */
> +	config_data = inl(nas_gpio_io_base + GPO_BLINK);
> +	dev_printk(KERN_DEBUG, dev, "Data read from GPO_BLINK = 0x%08x\n",
> +					config_data);
> +
> +	/*
> +	 * At this moment, I am unsure if anything needs to happen with GPI_INV
> +	 */
> +	config_data = inl(nas_gpio_io_base + GPI_INV);
> +	dev_printk(KERN_DEBUG, dev, "Data read from GPI_INV = 0x%08x\n",
> +					config_data);
> +
> +	spin_unlock(&nasgpio_gpio_lock);
> +	return 0;
> +}

I wonder if this (and ich7_lpc_probe()) could be __devinit.

> +static void ich7_lpc_cleanup(struct device *dev)
> +{
> +	/*
> +	 * If we were given exclusive use of the GPIO
> +	 * I/O Address range, we must return it.
> +	 */
> +	if (gp_gpio_resource) {
> +		dev_printk(KERN_DEBUG, dev, "Releasing GPIO I/O addresses\n");
> +		release_region(nas_gpio_io_base, ICH7_GPIO_SIZE);
> +		gp_gpio_resource = NULL;
> +	}
> +}
> +
> +/*
> + * The OS has determined that the LPC of the Intel ICH7 Southbridge is present
> + * so we can retrive the required operational information and prepare the GPIO.
> + */
> +static struct pci_dev *nas_gpio_pci_dev;
> +static int ich7_lpc_probe(struct pci_dev *dev, const struct pci_device_id *id)
> +{
> +	int status = 0;
> +	u32 gc = 0;
> +
> +	pci_enable_device(dev);

Shouldn't we disable it again if this function fails?

> +	nas_gpio_pci_dev = dev;
> +	status = pci_read_config_dword(dev, PMBASE, &g_pm_io_base);
> +	if (status)
> +		goto out;
> +	g_pm_io_base &= 0x00000ff80;
> +
> +	status = pci_read_config_dword(dev, GPIO_CTRL, &gc);
> +	if (!(GPIO_EN & gc)) {
> +		status = -EEXIST;
> +		dev_printk(KERN_INFO, &dev->dev,
> +			   "ERROR: The LPC GPIO Block has not been enabled.\n");
> +		goto out;
> +	}
> +
> +	status = pci_read_config_dword(dev, GPIO_BASE, &nas_gpio_io_base);
> +	if (0 > status) {
> +		dev_printk(KERN_INFO, &dev->dev, "Unable to read GPIOBASE.\n");
> +		goto out;
> +	}
> +	dev_printk(KERN_DEBUG, &dev->dev,
> +		   "GPIOBASE = 0x%08x\n", nas_gpio_io_base);
> +	nas_gpio_io_base &= 0x00000ffc0;
> +
> +	/*
> +	 * Insure that we have exclusive access to the GPIO I/O address range.
> +	 */
> +	gp_gpio_resource = request_region(nas_gpio_io_base,
> +					  ICH7_GPIO_SIZE, KBUILD_MODNAME);
> +	if (NULL == gp_gpio_resource) {
> +		dev_printk(KERN_INFO, &dev->dev,
> +			   "ERROR Unable to register GPIO I/O addresses.\n");
> +		status = -1;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Initialize the GPIO for NAS/Home Server Use
> +	 */
> +	ich7_gpio_init(&dev->dev);
> +
> +out:
> +	if (status)
> +		ich7_lpc_cleanup(&dev->dev);
> +	return status;
> +}
> +
>
> ...
>
> +
> +void set_power_light_amber_noblink(void)

Please check that any/all global symbols really needed to be global.

> +{
> +	struct nasgpio_led *amber = get_led_named("power:amber:power");
> +	struct nasgpio_led *blue = get_led_named("power:blue:power");
> +
> +	if (!amber || !blue)
> +		return;
> +	/*
> +	 * LED_OFF implies disabling future blinking
> +	 */
> +	printk(KERN_DEBUG "setting blue off and amber on\n");
> +
> +	nasgpio_led_set_brightness(&blue->led_cdev, LED_OFF);
> +	nasgpio_led_set_brightness(&amber->led_cdev, LED_FULL);
> +}
> +
>
> ...
>
> +static ssize_t nas_led_blink_store(struct device *dev,
> +				   struct device_attribute *attr,
> +				   const char *buf, size_t size)
> +{
> +	int ret;
> +	struct led_classdev *led = dev_get_drvdata(dev);
> +	unsigned long blink_state;
> +
> +	ret = strict_strtoul(buf, 10, &blink_state);
> +	if (ret)
> +		return ret;
> +
> +	spin_lock(&nasgpio_gpio_lock);
> +	nasgpio_led_set_attr(led, GPO_BLINK, blink_state);
> +	spin_unlock(&nasgpio_gpio_lock);

It still looks like this locking could be moved into the callee.

> +	return size;
> +}
> +
>
> ...
>

