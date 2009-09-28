Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbZI1Rvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbZI1Rvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 13:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbZI1Rvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 13:51:50 -0400
Received: from www.sr71.net ([198.145.64.142]:38863 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbZI1Rvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 13:51:48 -0400
Subject: [PATCH] LED driver for Intel NAS SS4200 series (v3)
From: Dave Hansen <dave@sr71.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, rgirod@confocus.com,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20090924171929.8ce89786.akpm@linux-foundation.org>
References: <1253118732-11944-1-git-send-email-dave@sr71.net>
	 <20090924171929.8ce89786.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 28 Sep 2009 10:51:50 -0700
Message-Id: <1254160310.17303.20180.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 17:19 -0700, Andrew Morton wrote:
> On Wed, 16 Sep 2009 09:32:12 -0700
> Dave Hansen <dave@sr71.net> wrote:
> 
> > Changes from last version
> > * Added dmi-basd hardware detection, and modparam
> >   override for it
> > * replaced DRIVER_NAME with KBUILD_MODNAME
> > 
> > --
> > 
> > This code is based on a driver that came in the "Open-source
> > and GPL components" download here:
> > 
> > http://downloadcenter.intel.com/SearchResult.aspx?lang=eng&ProductFamily=Server+Products&ProductLine=Intel%C2%AE+Storage+Systems&ProductProduct=Intel%C2%AE+Entry+Storage+System+SS4200-E&OSVersion=OS+Independent
> > 
> > It was in a file called nasgpio.c inside of a second zip file.
> > 
> > That code used an ioctl() call to operate the LEDs.  It also
> > created a new top-level /proc file just to let userspace locate
> > which dynamic major number had been allocated to the device.
> > Lovely.
> > 
> > I ripped out all of the hardware monitor support from nasgpio.c
> > as well as the smbus code that controls the LED brightness.  I
> > then converted the code to use the existing LED interfaces
> > rather than the ioctl().
> > 
> > Except for the probe routines, I rewrote most of it.
> > 
> > Thanks go to Arjan for his help in getting the original source
> > for this released and for chasing down some licensing issues.
> > 
> > Signed-off-by: Dave Hansen <dave@sr71.net>
> 
> We don't have Rodney's Signed-off-by:?

Unfortunately, no.  I'm not sure what Rodney's involvement with the
driver he wrote is at this point.  I've never had any contact with him,
although I cc'd him on this out of courtesy since I'd want to know if it
was my code.

I actually did a bit of work to ensure that there was source for this
available in any form.  I then actually contacted some folks at Intel to
resolve a licensing ambiguity with their source release.  I'm convinced
now that it is released under GPLv2.  I trust that, coming from Intel
directly, it is in good faith.

I do believe I have the rights to submit it, and I did re-read the DCO
just now to make sure that I feel this way.

I'd appreciate if Arjan or someone else at Intel could sign off on it.
That would probably remove any and all confusion.

> > +config LEDS_INTEL_SS4200
> > +	tristate "LED driver for Intel NAS SS4200 series"
> > +	depends on LEDS_CLASS && PCI
> 
> Does it need a dependency on DMI?

Yes.  I'll add it.

> > +	help
> > +	  This option enables support for the Intel SS4200 series of
> > +	  Network Attached Storage servers.  You may control the hard
> > +	  drive or power LEDs on the front panel.  Using this driver
> > +	  can stop the front LED from blinking after startup.
> > +
> >
> > ...
> >
> > +void nasgpio_led_set_attr(struct led_classdev *led_cdev, u32 port, u32 value)
> > +{
> > +	struct nasgpio_led *led = led_classdev_to_nasgpio_led(led_cdev);
> > +	u32 gpio_out;
> > +
> > +	gpio_out = inl(nas_gpio_io_base + port);
> > +	if (value)
> > +		gpio_out |= (1<<led->gpio_bit);
> > +	else
> > +		gpio_out &= ~(1<<led->gpio_bit);
> > +
> > +	outl(gpio_out, nas_gpio_io_base + port);
> > +}
> 
> This function needs locking, but doesn't have it.

The locking is done by the callers.  I noted it in the function
comments.  It needs to be done by callers since this function can
effectively do two things: make an LED be powered on or off, or make it
blink.  When a user requests that the state of both of those be changed,
I tried to do it atomically.

There was a comment on this:
        /*
         * Hold the lock across both operations.  This ensures
         * consistency so that both the "turn off blinking"
         * and "turn light off" operations complete as a set.
         */

Perhaps an __ prefix would help it be more clear that the function can't
just be called without locking?  I've done that, btw.

> > +	if (brightness == 0)
> > +		nasgpio_led_set_attr(led_cdev, GPO_BLINK, 0);
> > +	nasgpio_led_set_attr(led_cdev, GP_LVL, setting);
> > +	spin_unlock(&nasgpio_gpio_lock);
> > +}
> 
> Oh.  There's the locking.  How weird.

Point taken. :)

> > +	config_data = inl(nas_gpio_io_base + GPI_INV);
> > +	dev_printk(KERN_DEBUG, dev, "Data read from GPI_INV = 0x%08x\n",
> > +					config_data);
> > +
> > +	spin_unlock(&nasgpio_gpio_lock);
> > +	return 0;
> > +}
> 
> I wonder if this (and ich7_lpc_probe()) could be __devinit.

Yes, I believe they can.

> > +static void ich7_lpc_cleanup(struct device *dev)
> > +{
> > +	/*
> > +	 * If we were given exclusive use of the GPIO
> > +	 * I/O Address range, we must return it.
> > +	 */
> > +	if (gp_gpio_resource) {
> > +		dev_printk(KERN_DEBUG, dev, "Releasing GPIO I/O addresses\n");
> > +		release_region(nas_gpio_io_base, ICH7_GPIO_SIZE);
> > +		gp_gpio_resource = NULL;
> > +	}
> > +}
> > +
> > +/*
> > + * The OS has determined that the LPC of the Intel ICH7 Southbridge is present
> > + * so we can retrive the required operational information and prepare the GPIO.
> > + */
> > +static struct pci_dev *nas_gpio_pci_dev;
> > +static int ich7_lpc_probe(struct pci_dev *dev, const struct pci_device_id *id)
> > +{
> > +	int status = 0;
> > +	u32 gc = 0;
> > +
> > +	pci_enable_device(dev);
> 
> Shouldn't we disable it again if this function fails?

Yes.  I've also added it to the device removal path.

> > +
> >
> > ...
> >
> > +
> > +void set_power_light_amber_noblink(void)
> 
> Please check that any/all global symbols really needed to be global.

Will do.  I found a few others.

> > +static ssize_t nas_led_blink_store(struct device *dev,
> > +				   struct device_attribute *attr,
> > +				   const char *buf, size_t size)
> > +{
> > +	int ret;
> > +	struct led_classdev *led = dev_get_drvdata(dev);
> > +	unsigned long blink_state;
> > +
> > +	ret = strict_strtoul(buf, 10, &blink_state);
> > +	if (ret)
> > +		return ret;
> > +
> > +	spin_lock(&nasgpio_gpio_lock);
> > +	nasgpio_led_set_attr(led, GPO_BLINK, blink_state);
> > +	spin_unlock(&nasgpio_gpio_lock);
> 
> It still looks like this locking could be moved into the callee.

That makes sense for two of the cases.  The other one is the probe-time
function.  It probably doesn't strictly need locking, but I think it is
nice to have.

the other is the one where we're setting blink and on/off state at the
same time.  nasgpio_led_set_attr() can only do one at once, so I need to
hold the lock over both calls.

Fixed up patch is appended.  It appears to be behaving itself on the
real hardware.

-- Dave

Changes from last version
* created non-lock-taking __nasgpio_led_set_attr() and
  a lock-taking version with no '__'.
* added Kconfig dependency on DMI
* Added some 'static's to functions
* Added __devinit to init-time functions
* Add missed pci_disable_device() on probe error and
  device removal

Previous changes:
* Added dmi-basd hardware detection, and modparam
  override for it
* replaced DRIVER_NAME with KBUILD_MODNAME

--

This code is based on a driver that came in the "Open-source
and GPL components" download here:
    
http://downloadcenter.intel.com/SearchResult.aspx?lang=eng&ProductFamily=Server+Products&ProductLine=Intel%C2%AE+Storage+Systems&ProductProduct=Intel%C2%AE+Entry+Storage+System+SS4200-E&OSVersion=OS+Independent
    
It was in a file called nasgpio.c inside of a second zip file
called SS4200-E_Linux_SIO_Driver-v1.4.zip.

That code used an ioctl() call to operate the LEDs.  It also
created a new top-level /proc file just to let userspace locate
which dynamic major number had been allocated to the device.
I decided that the interface probably wasn't mergeable in that
form. :)
    
I ripped out all of the hardware monitor support from nasgpio.c
as well as the smbus code that controls the LED brightness.  I
then converted the code to use the existing LED interfaces
rather than the ioctl().  I don't have any need for brightness
control, and its code is *completely* separate from the on/off
controls implemented here.  If anyone else wants it, I'd be
happy to look into adding it, but I don't care enough for now.

Except for the probe routines, I rewrote most of it.  I also
Note that I don't have any hardware documentation except for
the original driver.  

Thanks go to Arjan for his help in getting the original source
for this released and for chasing down some licensing issues.

Signed-off-by: Dave Hansen <dave@sr71.net>
---

 linux-2.6.git-dave/drivers/leds/Kconfig       |    9 
 linux-2.6.git-dave/drivers/leds/Makefile      |    1 
 linux-2.6.git-dave/drivers/leds/leds-ss4200.c |  560 ++++++++++++++++++++++++++
 3 files changed, 570 insertions(+)

diff -puN drivers/leds/Kconfig~driver_for_Intel_NAS_SS4200_series drivers/leds/Kconfig
--- linux-2.6.git/drivers/leds/Kconfig~driver_for_Intel_NAS_SS4200_series	2009-09-16 08:22:08.000000000 -0700
+++ linux-2.6.git-dave/drivers/leds/Kconfig	2009-09-28 10:14:06.000000000 -0700
@@ -229,6 +229,15 @@ config LEDS_BD2802
 	  This option enables support for BD2802GU RGB LED driver chips
 	  accessed via the I2C bus.
 
+config LEDS_INTEL_SS4200
+	tristate "LED driver for Intel NAS SS4200 series"
+	depends on LEDS_CLASS && PCI && DMI
+	help
+	  This option enables support for the Intel SS4200 series of
+	  Network Attached Storage servers.  You may control the hard
+	  drive or power LEDs on the front panel.  Using this driver
+	  can stop the front LED from blinking after startup.
+
 comment "LED Triggers"
 
 config LEDS_TRIGGERS
diff -puN /dev/null drivers/leds/leds-ss4200.c
--- /dev/null	2008-09-02 09:40:19.000000000 -0700
+++ linux-2.6.git-dave/drivers/leds/leds-ss4200.c	2009-09-28 10:43:40.000000000 -0700
@@ -0,0 +1,560 @@
+/*
+ * SS4200-E Hardware API
+ * Copyright (c) 2009, Intel Corporation.
+ * Copyright IBM Corporation, 2009
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Author: Dave Hansen <dave@sr71.net>
+ */
+
+#include <linux/dmi.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/kernel.h>
+#include <linux/leds.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+
+MODULE_AUTHOR("Rodney Girod <rgirod@confocus.com>, Dave Hansen <dave@sr71.net>");
+MODULE_DESCRIPTION("Intel NAS/Home Server ICH7 GPIO Driver");
+MODULE_LICENSE("GPL");
+
+/*
+ * ICH7 LPC/GPIO PCI Config register offsets
+ */
+#define PMBASE		0x040
+#define GPIO_BASE	0x048
+#define GPIO_CTRL	0x04c
+#define GPIO_EN		0x010
+
+/*
+ * The ICH7 GPIO register block is 64 bytes in size.
+ */
+#define ICH7_GPIO_SIZE	64
+
+/*
+ * Define register offsets within the ICH7 register block.
+ */
+#define GPIO_USE_SEL	0x000
+#define GP_IO_SEL	0x004
+#define GP_LVL		0x00c
+#define GPO_BLINK	0x018
+#define GPI_INV		0x030
+#define GPIO_USE_SEL2	0x034
+#define GP_IO_SEL2	0x038
+#define GP_LVL2		0x03c
+
+/*
+ * PCI ID of the Intel ICH7 LPC Device within which the GPIO block lives.
+ */
+static struct pci_device_id ich7_lpc_pci_id[] =
+{
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_1) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_30) },
+	{ } /* NULL entry */
+};
+
+MODULE_DEVICE_TABLE(pci, ich7_lpc_pci_id);
+
+static int __init ss4200_led_dmi_callback(const struct dmi_system_id *id)
+{
+	printk(KERN_INFO KBUILD_MODNAME ": '%s' found\n", id->ident);
+	return 1;
+}
+
+static unsigned int __initdata nodetect;
+module_param_named(nodetect, nodetect, bool, 0);
+MODULE_PARM_DESC(nodetect, "Skip DMI-based hardware detection");
+
+/*
+ * struct nas_led_whitelist - List of known good models
+ *
+ * Contains the known good models this driver is compatible with.
+ * When adding a new model try to be as strict as possible. This
+ * makes it possible to keep the false positives (the model is
+ * detected as working, but in reality it is not) as low as
+ * possible.
+ */
+static struct dmi_system_id __initdata nas_led_whitelist[] = {
+	{
+		.callback = ss4200_led_dmi_callback,
+		.ident = "Intel SS4200-E",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SS4200-E"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "1.00.00")
+		}
+	},
+};
+
+/*
+ * Base I/O address assigned to the Power Management register block
+ */
+static u32 g_pm_io_base;
+
+/*
+ * Base I/O address assigned to the ICH7 GPIO register block
+ */
+static u32 nas_gpio_io_base;
+
+/*
+ * When we successfully register a region, we are returned a resource.
+ * We use these to identify which regions we need to release on our way
+ * back out.
+ */
+static struct resource *gp_gpio_resource;
+
+struct nasgpio_led {
+	char *name;
+	u32 gpio_bit;
+	struct led_classdev led_cdev;
+};
+
+/*
+ * gpio_bit(s) are the ICH7 GPIO bit assignments
+ */
+static struct nasgpio_led nasgpio_leds[] = {
+	{ .name = "hdd1:blue:sata",	.gpio_bit = 0 },
+	{ .name = "hdd1:amber:sata",	.gpio_bit = 1 },
+	{ .name = "hdd2:blue:sata",	.gpio_bit = 2 },
+	{ .name = "hdd2:amber:sata",	.gpio_bit = 3 },
+	{ .name = "hdd3:blue:sata",	.gpio_bit = 4 },
+	{ .name = "hdd3:amber:sata",	.gpio_bit = 5 },
+	{ .name = "hdd4:blue:sata",	.gpio_bit = 6 },
+	{ .name = "hdd4:amber:sata",	.gpio_bit = 7 },
+	{ .name = "power:blue:power",	.gpio_bit = 27},
+	{ .name = "power:amber:power",  .gpio_bit = 28},
+};
+
+#define NAS_RECOVERY	0x00000400	/* GPIO10 */
+
+static struct nasgpio_led *
+led_classdev_to_nasgpio_led(struct led_classdev *led_cdev)
+{
+	return container_of(led_cdev, struct nasgpio_led, led_cdev);
+}
+
+static struct nasgpio_led *get_led_named(char *name)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(nasgpio_leds); i++) {
+		if (strcmp(nasgpio_leds[i].name, name))
+			continue;
+		return &nasgpio_leds[i];
+	}
+	return NULL;
+}
+
+/*
+ * This protects access to the gpio ports.
+ */
+static DEFINE_SPINLOCK(nasgpio_gpio_lock);
+
+/*
+ * There are two gpio ports, one for blinking and the other
+ * for power.  @port tells us if we're doing blinking or
+ * power control.
+ *
+ * Caller must hold nasgpio_gpio_lock
+ */
+static void __nasgpio_led_set_attr(struct led_classdev *led_cdev,
+				   u32 port, u32 value)
+{
+	struct nasgpio_led *led = led_classdev_to_nasgpio_led(led_cdev);
+	u32 gpio_out;
+
+	gpio_out = inl(nas_gpio_io_base + port);
+	if (value)
+		gpio_out |= (1<<led->gpio_bit);
+	else
+		gpio_out &= ~(1<<led->gpio_bit);
+
+	outl(gpio_out, nas_gpio_io_base + port);
+}
+
+static void nasgpio_led_set_attr(struct led_classdev *led_cdev,
+				 u32 port, u32 value)
+{
+	spin_lock(&nasgpio_gpio_lock);
+	__nasgpio_led_set_attr(led_cdev, port, value);
+	spin_unlock(&nasgpio_gpio_lock);
+}
+
+u32 nasgpio_led_get_attr(struct led_classdev *led_cdev, u32 port)
+{
+	struct nasgpio_led *led = led_classdev_to_nasgpio_led(led_cdev);
+	u32 gpio_in;
+
+	spin_lock(&nasgpio_gpio_lock);
+	gpio_in = inl(nas_gpio_io_base + port);
+	spin_unlock(&nasgpio_gpio_lock);
+	if (gpio_in & (1<<led->gpio_bit))
+		return 1;
+	return 0;
+}
+
+/*
+ * There is actual brightness control in the hardware,
+ * but it is via smbus commands and not implemented
+ * in this driver.
+ */
+static void nasgpio_led_set_brightness(struct led_classdev *led_cdev,
+				       enum led_brightness brightness)
+{
+	u32 setting = 0;
+	if (brightness >= LED_HALF)
+		setting = 1;
+	/*
+	 * Hold the lock across both operations.  This ensures
+	 * consistency so that both the "turn off blinking"
+	 * and "turn light off" operations complete as a set.
+	 */
+	spin_lock(&nasgpio_gpio_lock);
+	/*
+	 * LED class documentation asks that past blink state
+	 * be disabled when brightness is turned to zero.
+	 */
+	if (brightness == 0)
+		__nasgpio_led_set_attr(led_cdev, GPO_BLINK, 0);
+	__nasgpio_led_set_attr(led_cdev, GP_LVL, setting);
+	spin_unlock(&nasgpio_gpio_lock);
+}
+
+static int nasgpio_led_set_blink(struct led_classdev *led_cdev,
+				 unsigned long *delay_on,
+				 unsigned long *delay_off)
+{
+	u32 setting = 1;
+	if (!(*delay_on == 0 && *delay_off == 0) &&
+	    !(*delay_on == 500 && *delay_off == 500))
+		return -EINVAL;
+	/*
+	 * These are very approximate.
+	 */
+	*delay_on = 500;
+	*delay_off = 500;
+
+	nasgpio_led_set_attr(led_cdev, GPO_BLINK, setting);
+
+	return 0;
+}
+
+
+/*
+ * Initialize the ICH7 GPIO registers for NAS usage.  The BIOS should have
+ * already taken care of this, but we will do so in a non destructive manner
+ * so that we have what we need whether the BIOS did it or not.
+ */
+static int __devinit ich7_gpio_init(struct device *dev)
+{
+	int i;
+	u32 config_data = 0;
+	u32 all_nas_led = 0;
+
+	for (i = 0; i < ARRAY_SIZE(nasgpio_leds); i++)
+		all_nas_led |= (1<<nasgpio_leds[i].gpio_bit);
+
+	spin_lock(&nasgpio_gpio_lock);
+	/*
+	 * We need to enable all of the GPIO lines used by the NAS box,
+	 * so we will read the current Use Selection and add our usage
+	 * to it.  This should be benign with regard to the original
+	 * BIOS configuration.
+	 */
+	config_data = inl(nas_gpio_io_base + GPIO_USE_SEL);
+	dev_printk(KERN_DEBUG, dev, "Data read from GPIO_USE_SEL = 0x%08x\n",
+					config_data);
+	config_data |= all_nas_led + NAS_RECOVERY;
+	outl(config_data, nas_gpio_io_base + GPIO_USE_SEL);
+	config_data = inl(nas_gpio_io_base + GPIO_USE_SEL);
+	dev_printk(KERN_DEBUG, dev, "GPIO_USE_SEL = 0x%08x\n\n",
+					config_data);
+
+	/*
+	 * The LED GPIO outputs need to be configured for output, so we
+	 * will ensure that all LED lines are cleared for output and the
+	 * RECOVERY line ready for input.  This too should be benign with
+	 * regard to BIOS configuration.
+	 */
+	config_data = inl(nas_gpio_io_base + GP_IO_SEL);
+	dev_printk(KERN_DEBUG, dev, "Data read from GP_IO_SEL = 0x%08x\n",
+					config_data);
+	config_data &= ~all_nas_led;
+	config_data |= NAS_RECOVERY;
+	outl(config_data, nas_gpio_io_base + GP_IO_SEL);
+	config_data = inl(nas_gpio_io_base + GP_IO_SEL);
+	dev_printk(KERN_DEBUG, dev, "GP_IO_SEL = 0x%08x\n\n",
+					config_data);
+
+	/*
+	 * In our final system, the BIOS will initialize the state of all
+	 * of the LEDs.  For now, we turn them all off (or Low).
+	 */
+	config_data = inl(nas_gpio_io_base + GP_LVL);
+	dev_printk(KERN_DEBUG, dev, "Data read from GP_LVL = 0x%08x\n",
+				   config_data);
+	/*
+	 * In our final system, the BIOS will initialize the blink state of all
+	 * of the LEDs.  For now, we turn blink off for all of them.
+	 */
+	config_data = inl(nas_gpio_io_base + GPO_BLINK);
+	dev_printk(KERN_DEBUG, dev, "Data read from GPO_BLINK = 0x%08x\n",
+					config_data);
+
+	/*
+	 * At this moment, I am unsure if anything needs to happen with GPI_INV
+	 */
+	config_data = inl(nas_gpio_io_base + GPI_INV);
+	dev_printk(KERN_DEBUG, dev, "Data read from GPI_INV = 0x%08x\n",
+					config_data);
+
+	spin_unlock(&nasgpio_gpio_lock);
+	return 0;
+}
+
+static void ich7_lpc_cleanup(struct device *dev)
+{
+	/*
+	 * If we were given exclusive use of the GPIO
+	 * I/O Address range, we must return it.
+	 */
+	if (gp_gpio_resource) {
+		dev_printk(KERN_DEBUG, dev, "Releasing GPIO I/O addresses\n");
+		release_region(nas_gpio_io_base, ICH7_GPIO_SIZE);
+		gp_gpio_resource = NULL;
+	}
+}
+
+/*
+ * The OS has determined that the LPC of the Intel ICH7 Southbridge is present
+ * so we can retrive the required operational information and prepare the GPIO.
+ */
+static struct pci_dev *nas_gpio_pci_dev;
+static int __devinit ich7_lpc_probe(struct pci_dev *dev,
+				    const struct pci_device_id *id)
+{
+	int status = 0;
+	u32 gc = 0;
+
+	pci_enable_device(dev);
+
+	nas_gpio_pci_dev = dev;
+	status = pci_read_config_dword(dev, PMBASE, &g_pm_io_base);
+	if (status)
+		goto out;
+	g_pm_io_base &= 0x00000ff80;
+
+	status = pci_read_config_dword(dev, GPIO_CTRL, &gc);
+	if (!(GPIO_EN & gc)) {
+		status = -EEXIST;
+		dev_printk(KERN_INFO, &dev->dev,
+			   "ERROR: The LPC GPIO Block has not been enabled.\n");
+		goto out;
+	}
+
+	status = pci_read_config_dword(dev, GPIO_BASE, &nas_gpio_io_base);
+	if (0 > status) {
+		dev_printk(KERN_INFO, &dev->dev, "Unable to read GPIOBASE.\n");
+		goto out;
+	}
+	dev_printk(KERN_DEBUG, &dev->dev,
+		   "GPIOBASE = 0x%08x\n", nas_gpio_io_base);
+	nas_gpio_io_base &= 0x00000ffc0;
+
+	/*
+	 * Insure that we have exclusive access to the GPIO I/O address range.
+	 */
+	gp_gpio_resource = request_region(nas_gpio_io_base,
+					  ICH7_GPIO_SIZE, KBUILD_MODNAME);
+	if (NULL == gp_gpio_resource) {
+		dev_printk(KERN_INFO, &dev->dev,
+			   "ERROR Unable to register GPIO I/O addresses.\n");
+		status = -1;
+		goto out;
+	}
+
+	/*
+	 * Initialize the GPIO for NAS/Home Server Use
+	 */
+	ich7_gpio_init(&dev->dev);
+
+out:
+	if (status) {
+		ich7_lpc_cleanup(&dev->dev);
+		pci_disable_device(dev);
+	}
+	return status;
+}
+
+static void ich7_lpc_remove(struct pci_dev *dev)
+{
+	ich7_lpc_cleanup(&dev->dev);
+	pci_disable_device(dev);
+}
+
+/*
+ * pci_driver structure passed to the PCI modules
+ */
+static struct pci_driver nas_gpio_pci_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = ich7_lpc_pci_id,
+	.probe = ich7_lpc_probe,
+	.remove = ich7_lpc_remove,
+};
+
+static struct led_classdev *get_classdev_for_led_nr(int nr)
+{
+	struct nasgpio_led *nas_led = &nasgpio_leds[nr];
+	struct led_classdev *led = &nas_led->led_cdev;
+	return led;
+}
+
+
+static void set_power_light_amber_noblink(void)
+{
+	struct nasgpio_led *amber = get_led_named("power:amber:power");
+	struct nasgpio_led *blue = get_led_named("power:blue:power");
+
+	if (!amber || !blue)
+		return;
+	/*
+	 * LED_OFF implies disabling future blinking
+	 */
+	printk(KERN_DEBUG "setting blue off and amber on\n");
+
+	nasgpio_led_set_brightness(&blue->led_cdev, LED_OFF);
+	nasgpio_led_set_brightness(&amber->led_cdev, LED_FULL);
+}
+
+static ssize_t nas_led_blink_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led = dev_get_drvdata(dev);
+	int blinking = 0;
+	if (nasgpio_led_get_attr(led, GPO_BLINK))
+		blinking = 1;
+	return sprintf(buf, "%u\n", blinking);
+}
+
+static ssize_t nas_led_blink_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t size)
+{
+	int ret;
+	struct led_classdev *led = dev_get_drvdata(dev);
+	unsigned long blink_state;
+
+	ret = strict_strtoul(buf, 10, &blink_state);
+	if (ret)
+		return ret;
+
+	nasgpio_led_set_attr(led, GPO_BLINK, blink_state);
+
+	return size;
+}
+
+static DEVICE_ATTR(blink, 0644, nas_led_blink_show, nas_led_blink_store);
+
+static int register_nasgpio_led(int led_nr)
+{
+	int ret;
+	struct nasgpio_led *nas_led = &nasgpio_leds[led_nr];
+	struct led_classdev *led = get_classdev_for_led_nr(led_nr);
+
+	led->name = nas_led->name;
+	led->brightness = LED_OFF;
+	if (nasgpio_led_get_attr(led, GP_LVL))
+		led->brightness = LED_FULL;
+	led->brightness_set = nasgpio_led_set_brightness;
+	led->blink_set = nasgpio_led_set_blink;
+	ret = led_classdev_register(&nas_gpio_pci_dev->dev, led);
+	if (ret)
+		return ret;
+	ret = device_create_file(led->dev, &dev_attr_blink);
+	if (ret)
+		led_classdev_unregister(led);
+	return ret;
+}
+
+static void unregister_nasgpio_led(int led_nr)
+{
+	struct led_classdev *led = get_classdev_for_led_nr(led_nr);
+	led_classdev_unregister(led);
+	device_remove_file(led->dev, &dev_attr_blink);
+}
+/*
+ * module load/initialization
+ */
+static int __init nas_gpio_init(void)
+{
+	int i;
+	int ret = 0;
+	int nr_devices = 0;
+
+	nr_devices = dmi_check_system(nas_led_whitelist);
+	if (nodetect) {
+		printk(KERN_INFO "%s: skipping hardware autodetection\n",
+				KBUILD_MODNAME);
+		printk(KERN_INFO "\tif this works, please send the output ");
+		printk(KERN_INFO "of 'dmidecode' to dave@sr71.net\n");
+		nr_devices++;
+	}
+
+	if (nr_devices <= 0) {
+		printk(KERN_INFO "%s: no LED devices found\n",
+				KBUILD_MODNAME);
+		return -ENODEV;
+	}
+
+	printk(KERN_INFO "registering %s PCI driver\n", KBUILD_MODNAME);
+	ret = pci_register_driver(&nas_gpio_pci_driver);
+	if (ret)
+		return ret;
+	for (i = 0; i < ARRAY_SIZE(nasgpio_leds); i++) {
+		ret = register_nasgpio_led(i);
+		if (ret)
+			goto out_err;
+	}
+	/*
+	 * When the system powers on, the BIOS leaves the power
+	 * light blue and blinking.  This will turn it solid
+	 * amber once the driver is loaded.
+	 */
+	set_power_light_amber_noblink();
+	return 0;
+out_err:
+	for (; i >= 0; i--)
+		unregister_nasgpio_led(i);
+	pci_unregister_driver(&nas_gpio_pci_driver);
+	return ret;
+}
+
+/*
+ * module unload
+ */
+static void __exit nas_gpio_exit(void)
+{
+	int i;
+	printk(KERN_INFO "Unregistering %s driver\n", KBUILD_MODNAME);
+	for (i = 0; i < ARRAY_SIZE(nasgpio_leds); i++)
+		unregister_nasgpio_led(i);
+	pci_unregister_driver(&nas_gpio_pci_driver);
+}
+
+module_init(nas_gpio_init);
+module_exit(nas_gpio_exit);
diff -puN drivers/leds/Makefile~driver_for_Intel_NAS_SS4200_series drivers/leds/Makefile
--- linux-2.6.git/drivers/leds/Makefile~driver_for_Intel_NAS_SS4200_series	2009-09-16 08:22:08.000000000 -0700
+++ linux-2.6.git-dave/drivers/leds/Makefile	2009-09-16 08:22:08.000000000 -0700
@@ -28,6 +28,7 @@ obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca9
 obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
 obj-$(CONFIG_LEDS_WM8350)		+= leds-wm8350.o
 obj-$(CONFIG_LEDS_PWM)			+= leds-pwm.o
+obj-$(CONFIG_LEDS_INTEL_SS4200)		+= leds-ss4200.o
 
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
diff -puN drivers/leds/leds-clevo-mail.c~driver_for_Intel_NAS_SS4200_series drivers/leds/leds-clevo-mail.c
_


