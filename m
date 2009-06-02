Return-Path: <linux-kernel-owner+w=401wt.eu-S1759248AbZFBFJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248AbZFBFJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 01:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZFBFJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 01:09:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752785AbZFBFJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 01:09:22 -0400
Date: Mon, 1 Jun 2009 22:08:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/9] add support for the TI VLYNQ bus
Message-Id: <20090601220854.a9ddd5ce.akpm@linux-foundation.org>
In-Reply-To: <200906011358.28359.florian@openwrt.org>
References: <200906011358.28359.florian@openwrt.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009 13:58:27 +0200 Florian Fainelli <florian@openwrt.org> wrote:

> This patch adds support for the TI VLYNQ high-speed,
> serial and packetized bus. This bus allows external
> devices to be connected to the System-on-Chip and
> appear in the main system memory just like any memory
> mapped peripheral. It is widely used in TI's networking
> and mutlimedia SoC, including the AR7 SoC.
> 
>
> ...
>
> +struct vlynq_regs {
> +	u32 revision;
> +	u32 control;
> +	u32 status;
> +	u32 int_prio;
> +	u32 int_status;
> +	u32 int_pending;
> +	u32 int_ptr;
> +	u32 tx_offset;
> +	struct vlynq_mapping rx_mapping[4];
> +	u32 chip;
> +	u32 autonego;
> +	u32 unused[6];
> +	u32 int_device[8];
> +};
> +
> +#define vlynq_reg_read(reg) readl(&(reg))
> +#define vlynq_reg_write(reg, val)  writel(val, &(reg))

grumble.  These just make the code harder to follow.  it'd be better to
open-code readl() and writel() at the callsites.

> +static int __vlynq_enable_device(struct vlynq_device *dev);
> +
> +#ifdef VLYNQ_DEBUG
> +static void vlynq_dump_regs(struct vlynq_device *dev)
> +{
> +	int i;
> +
> +	printk(KERN_DEBUG "VLYNQ local=%p remote=%p\n",
> +			dev->local, dev->remote);
> +	for (i = 0; i < 32; i++) {
> +		printk(KERN_DEBUG "VLYNQ: local %d: %08x\n",
> +			i + 1, ((u32 *)dev->local)[i]);
> +		printk(KERN_DEBUG "VLYNQ: remote %d: %08x\n",
> +			i + 1, ((u32 *)dev->remote)[i]);
> +	}
> +}
> +
> +static void vlynq_dump_mem(u32 *base, int count)
> +{
> +	int i;
> +
> +	for (i = 0; i < (count + 3) / 4; i++) {
> +		if (i % 4 == 0)
> +			printk(KERN_DEBUG "\nMEM[0x%04x]:", i * 4);
> +		printk(KERN_DEBUG " 0x%08x", *(base + i));
> +	}
> +	printk(KERN_DEBUG "\n");
> +}

lib/hexdump.c?

> +#endif
> +
> +int vlynq_linked(struct vlynq_device *dev)

afacit this didn't need to be a kernel-wide symbol?

Please review the patchset for any unnecessarily-global symbols.

> +{
> +	int i;
> +
> +	for (i = 0; i < 100; i++)
> +		if (vlynq_reg_read(dev->local->status) & VLYNQ_STATUS_LINK)
> +			return 1;
> +		else
> +			cpu_relax();
> +
> +	return 0;
> +}
> +
>
> ...
>
> +static void vlynq_remote_ack(unsigned int irq)
> +{
> +	struct vlynq_device *dev = get_irq_chip_data(irq);
> +
> +	u32 status = vlynq_reg_read(dev->remote->status);
> +
> +	if (printk_ratelimit())
> +		printk(KERN_DEBUG "%s: remote status: 0x%08x\n",
> +		       dev_name(&dev->dev), status);
> +	vlynq_reg_write(dev->remote->status, status);
> +}

This code seems to do rather a lot of printks for production code?

>
> ...
>
> +static int vlynq_device_match(struct device *dev,
> +			      struct device_driver *drv)
> +{
> +	struct vlynq_device *vdev = to_vlynq_device(dev);
> +	struct vlynq_driver *vdrv = to_vlynq_driver(drv);
> +	struct vlynq_device_id *ids = vdrv->id_table;
> +
> +	while (ids->id) {
> +		if (ids->id == vdev->dev_id) {
> +			vdev->divisor = ids->divisor;
> +			vlynq_set_drvdata(vdev, ids);
> +			printk(KERN_INFO "Driver found for VLYNQ " \
> +				"device: %08x\n", vdev->dev_id);
> +			return 1;
> +		}
> +		printk(KERN_DEBUG "Not using the %08x VLYNQ device's driver" \
> +			" for VLYNQ device: %08x\n", ids->id, vdev->dev_id);

The backslashes here are unneeded and unconventional.

> +		ids++;
> +	}
> +	return 0;
> +}
> +
> +static int vlynq_device_probe(struct device *dev)
> +{
> +	struct vlynq_device *vdev = to_vlynq_device(dev);
> +	struct vlynq_driver *drv = to_vlynq_driver(dev->driver);
> +	struct vlynq_device_id *id = vlynq_get_drvdata(vdev);
> +	int result = -ENODEV;
> +
> +	get_device(dev);
> +	if (drv && drv->probe)
> +		result = drv->probe(vdev, id);

Can `drv' really be NULL here?

> +	if (result)
> +		put_device(dev);
> +	return result;
> +}
> +
> +static int vlynq_device_remove(struct device *dev)
> +{
> +	struct vlynq_driver *drv = to_vlynq_driver(dev->driver);
> +	if (drv && drv->remove)
> +		drv->remove(to_vlynq_device(dev));

ditto.

> +	put_device(dev);
> +	return 0;
> +}
> +
> +int __vlynq_register_driver(struct vlynq_driver *driver, struct module *owner)
> +{
> +	driver->driver.name = driver->name;
> +	driver->driver.bus = &vlynq_bus_type;
> +	return driver_register(&driver->driver);
> +}
> +EXPORT_SYMBOL(__vlynq_register_driver);
> +
> +void vlynq_unregister_driver(struct vlynq_driver *driver)
> +{
> +	driver_unregister(&driver->driver);
> +}
> +EXPORT_SYMBOL(vlynq_unregister_driver);
> +
> +static int __vlynq_try_remote(struct vlynq_device *dev)
> +{
> +	int i;
> +
> +	vlynq_reset(dev);
> +	for (i = dev->dev_id ? vlynq_rdiv2 : vlynq_rdiv8; dev->dev_id ?
> +			i <= vlynq_rdiv8 : i >= vlynq_rdiv2;
> +		dev->dev_id ? i++ : i--) {

Wow.

> +		if (!vlynq_linked(dev))
> +			break;
> +
> +		vlynq_reg_write(dev->remote->control,
> +				(vlynq_reg_read(dev->remote->control) &
> +				~VLYNQ_CTRL_CLOCK_MASK) |
> +				VLYNQ_CTRL_CLOCK_INT |
> +				VLYNQ_CTRL_CLOCK_DIV(i - vlynq_rdiv1));
> +		vlynq_reg_write(dev->local->control,
> +				((vlynq_reg_read(dev->local->control)
> +				& ~(VLYNQ_CTRL_CLOCK_INT |
> +				VLYNQ_CTRL_CLOCK_MASK)) |
> +				VLYNQ_CTRL_CLOCK_DIV(i - vlynq_rdiv1)));
> +
> +		if (vlynq_linked(dev)) {
> +			printk(KERN_DEBUG
> +				"%s: using remote clock divisor %d\n",
> +				dev_name(&dev->dev), i - vlynq_rdiv1 + 1);
> +			dev->divisor = i;
> +			return 0;
> +		} else {
> +			vlynq_reset(dev);
> +		}
> +	}
> +
> +	return -ENODEV;
> +}

This code could do with a few comments.

See, this reader of your code doesn't know what vlynq_linked() does, so
I don't have a hope of working out whey this function returns -ENODEV
if it couldn't find any "linked" devices.  What does this _mean_ in
terms of the underlying hardware and its configuration?

Dunno.  But it would be nice to be able to work that out from reading
the code, no?

> +static int __vlynq_try_local(struct vlynq_device *dev)
> +{
> +	int i;
> +
> +	vlynq_reset(dev);
> +
> +	for (i = dev->dev_id ? vlynq_ldiv2 : vlynq_ldiv8; dev->dev_id ?
> +			i <= vlynq_ldiv8 : i >= vlynq_ldiv2;
> +		dev->dev_id ? i++ : i--) {
> +
> +		vlynq_reg_write(dev->local->control,
> +				(vlynq_reg_read(dev->local->control) &
> +				~VLYNQ_CTRL_CLOCK_MASK) |
> +				VLYNQ_CTRL_CLOCK_INT |
> +				VLYNQ_CTRL_CLOCK_DIV(i - vlynq_ldiv1));
> +
> +		if (vlynq_linked(dev)) {
> +			printk(KERN_DEBUG
> +				"%s: using local clock divisor %d\n",
> +				dev_name(&dev->dev), i - vlynq_ldiv1 + 1);
> +			dev->divisor = i;
> +			return 0;
> +		} else {
> +			vlynq_reset(dev);
> +		}
> +	}
> +
> +	return -ENODEV;
> +}
> +
> +static int __vlynq_try_external(struct vlynq_device *dev)
> +{
> +	vlynq_reset(dev);
> +	if (!vlynq_linked(dev))
> +		return -ENODEV;
> +
> +	vlynq_reg_write(dev->remote->control,
> +			(vlynq_reg_read(dev->remote->control) &
> +			~VLYNQ_CTRL_CLOCK_INT));
> +
> +	vlynq_reg_write(dev->local->control,
> +			(vlynq_reg_read(dev->local->control) &
> +			~VLYNQ_CTRL_CLOCK_INT));
> +
> +	if (vlynq_linked(dev)) {
> +		printk(KERN_DEBUG "%s: using external clock\n",
> +			dev_name(&dev->dev));
> +			dev->divisor = vlynq_div_external;
> +		return 0;
> +	}
> +
> +	return -ENODEV;
> +}

"remote", "local", "external".  What do these terms mean?  Perhaps
there's a TI datasheet somewhere?

> +static int __vlynq_enable_device(struct vlynq_device *dev)
> +{
> +	int result;
> +	struct plat_vlynq_ops *ops = dev->dev.platform_data;
> +
> +	result = ops->on(dev);
> +	if (result)
> +		return result;
> +
> +	switch (dev->divisor) {
> +	case vlynq_div_external:
> +	case vlynq_div_auto:
> +		/* When the device is brought from reset it should have clock
> +		generation negotiated by hardware.
> +		Check which device is generating clocks and perform setup
> +		accordingly */

Preferred comment layout format is

		/*
		 * When the device is brought from reset it should have clock
		 * generation negotiated by hardware.  Check which device is
		 * generating clocks and perform setup accordingly
		 */


> +		if (vlynq_linked(dev) && vlynq_reg_read(dev->remote->control) &
> +		   VLYNQ_CTRL_CLOCK_INT) {
> +			if (!__vlynq_try_remote(dev) ||
> +				!__vlynq_try_local(dev)  ||
> +				!__vlynq_try_external(dev))
> +				return 0;
> +		} else {
> +			if (!__vlynq_try_external(dev) ||
> +				!__vlynq_try_local(dev)    ||
> +				!__vlynq_try_remote(dev))
> +				return 0;
> +		}
> +		break;
> +	case vlynq_ldiv1: case vlynq_ldiv2: case vlynq_ldiv3: case vlynq_ldiv4:
> +	case vlynq_ldiv5: case vlynq_ldiv6: case vlynq_ldiv7: case vlynq_ldiv8:

One `case' per line, please.

> +		vlynq_reg_write(dev->local->control,
> +				VLYNQ_CTRL_CLOCK_INT |
> +				VLYNQ_CTRL_CLOCK_DIV(dev->divisor -
> +						     vlynq_ldiv1));
> +		vlynq_reg_write(dev->remote->control, 0);
> +		if (vlynq_linked(dev)) {
> +			printk(KERN_DEBUG
> +				"%s: using local clock divisor %d\n",
> +				dev_name(&dev->dev),
> +				dev->divisor - vlynq_ldiv1 + 1);
> +			return 0;
> +		}
> +		break;
> +	case vlynq_rdiv1: case vlynq_rdiv2: case vlynq_rdiv3: case vlynq_rdiv4:
> +	case vlynq_rdiv5: case vlynq_rdiv6: case vlynq_rdiv7: case vlynq_rdiv8:
> +		vlynq_reg_write(dev->local->control, 0);
> +		vlynq_reg_write(dev->remote->control,
> +				VLYNQ_CTRL_CLOCK_INT |
> +				VLYNQ_CTRL_CLOCK_DIV(dev->divisor -
> +						     vlynq_rdiv1));
> +		if (vlynq_linked(dev)) {
> +			printk(KERN_DEBUG
> +				"%s: using remote clock divisor %d\n",
> +				dev_name(&dev->dev),
> +				dev->divisor - vlynq_rdiv1 + 1);
> +			return 0;
> +		}
> +		break;
> +	}
> +
> +	ops->off(dev);
> +	return -ENODEV;
> +}
> +
> +int vlynq_enable_device(struct vlynq_device *dev)
> +{
> +	struct plat_vlynq_ops *ops = dev->dev.platform_data;
> +	int result = -ENODEV;
> +
> +	result = __vlynq_enable_device(dev);
> +	if (result)
> +		return result;
> +
> +	result = vlynq_setup_irq(dev);
> +	if (result)
> +		ops->off(dev);

It's strange that this function directly calls __vlynq_enable_device(),
and undoes that via ops->off() if vlynq_setup_irq() failed.

I'd have expected to see a call to ops->off() used as a cancallation
for ops->on()?

> +	dev->enabled = !result;
> +	return result;
> +}
> +EXPORT_SYMBOL(vlynq_enable_device);
> +
> +
>
> ...
>
> +struct vlynq_device {
> +	u32 id, dev_id;
> +	int local_irq;
> +	int remote_irq;
> +	enum vlynq_divisor divisor;
> +	u32 regs_start, regs_end;
> +	u32 mem_start, mem_end;

This doesn't look 64-bit-bus friendly.

> +	u32 irq_start, irq_end;
> +	int irq;
> +	int enabled;
> +	struct vlynq_regs *local;
> +	struct vlynq_regs *remote;
> +	struct device dev;
> +};
>
> ...
>

