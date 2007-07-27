Return-Path: <linux-kernel-owner+w=401wt.eu-S1764923AbXG0TEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764923AbXG0TEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 15:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbXG0TEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 15:04:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54442 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757091AbXG0TEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:04:10 -0400
Date: Fri, 27 Jul 2007 12:03:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       bcm43xx-dev@lists.berlios.de, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, Gary Zambrano <zambrano@broadcom.com>
Subject: Re: [PATCH] Merge the Sonics Silicon Backplane subsystem
Message-Id: <20070727120318.54d18cfc.akpm@linux-foundation.org>
In-Reply-To: <200707271857.24162.mb@bu3sch.de>
References: <200707271857.24162.mb@bu3sch.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 18:57:20 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> The Sonics Silicon Backplane is a mini-bus used on
> various Broadcom chips and embedded devices.
> Devices using the SSB include b44, bcm43xx and various
> Broadcom based wireless routers.
> A b44 and bcm43xx port and a SSB based OHCI driver is available.
> 

hm, slim pickings for me here.  Nice looking code.

checkpatch finds a few coding style glitches.  Lots of 80-col violations
which you might choose ignore (comments on #defines in headers are
especially hard) but these guys:

ERROR: "foo * bar" should be "foo *bar"
#4156: FILE: drivers/ssb/ssb_private.h:119:
+extern struct ssb_bus * ssb_pci_dev_to_bus(struct pci_dev *pdev);

are worth addressing.

> ...
>
> --- /dev/null
> +++ b/drivers/ssb/driver_pcicore.c
> @@ -0,0 +1,564 @@
>
> ...
>
> +u32 pci_iobase = 0x100;
> +u32 pci_membase = SSB_PCI_DMA;

These are quite poor names for global symbols.

> +static struct resource ssb_pcicore_mem_resource = {
> +	.name	= "SSB PCIcore external memory",
> +	.start	= SSB_PCI_DMA,
> +	.end	= (u32)SSB_PCI_DMA + (u32)SSB_PCI_DMA_SZ - 1,
> +	.flags	= IORESOURCE_MEM,
> +};

start and end here are resource_size_t.  Forcing them to u32 seems
inappropriate.

> +void ssb_pcicore_init(struct ssb_pcicore *pc)

Please check that all newly-added global symbols do indeed need global scope.

> +static void ssb_pcie_mdio_write(struct ssb_pcicore *pc, u8 device,
> +				u8 address, u16 data)
> +{
> +	const u16 mdio_control = 0x128;
> +	const u16 mdio_data = 0x12C;
> +	u32 v;
> +	int i;
> +
> +	v = 0x80; /* Enable Preamble Sequence */
> +	v |= 0x2; /* MDIO Clock Divisor */
> +	pcicore_write32(pc, mdio_control, v);
> +
> +	v = (1 << 30); /* Start of Transaction */
> +	v |= (1 << 28); /* Write Transaction */
> +	v |= (1 << 17); /* Turnaround */
> +	v |= (u32)device << 22;
> +	v |= (u32)address << 18;
> +	v |= data;
> +	pcicore_write32(pc, mdio_data, v);
> +	udelay(10);

mystery udelays are usually worth a comment.

> +	for (i = 0; i < 10; i++) {
> +		v = pcicore_read32(pc, mdio_control);
> +		if (v & 0x100 /* Trans complete */)
> +			break;
> +		msleep(1);
> +	}
> +	pcicore_write32(pc, mdio_control, 0);
> +}
>
> ...
>
> +
> +static void ssb_buses_lock(void)
> +{
> +	if (!ssb_is_early_boot)
> +		mutex_lock(&buses_mutex);
> +}
> +
> +static void ssb_buses_unlock(void)
> +{
> +	if (!ssb_is_early_boot)
> +		mutex_unlock(&buses_mutex);
> +}

Some comments are neeeded here to explain why we're jumping through this
hoop.  It's normally OK to take a mutex early in boot, so one wonders
what's happening.

> +EXPORT_SYMBOL(ssb_clockspeed);

Please check that all newly-added exports really need to be exported (I'm
sure they do, but..)

> +static int ssb_wait_bit(struct ssb_device *dev, u16 reg, u32 bitmask,
> +			int timeout, int set)
> +{
> +	int i;
> +	u32 val;
> +
> +	for (i = 0; i < timeout; i++) {
> +		val = ssb_read32(dev, reg);
> +		if (set) {
> +			if (val & bitmask)
> +				return 0;
> +		} else {
> +			if (!(val & bitmask))
> +				return 0;
> +		}
> +		udelay(10);
> +	}
> +	printk(KERN_ERR PFX "Timeout waiting for bitmask %08X on "
> +			    "register %04X to %s.\n",
> +	       bitmask, reg, (set ? "set" : "clear"));
> +
> +	return -ETIMEDOUT;
> +}

So `timeout' is in units of ten-microseconds.  Unusual.

> +void ssb_device_disable(struct ssb_device *dev, u32 core_specific_flags)
> +{
> +	u32 reject;
> +
> +	if (ssb_read32(dev, SSB_TMSLOW) & SSB_TMSLOW_RESET)
> +		return;
> +
> +	reject = ssb_tmslow_reject_bitmask(dev);
> +	ssb_write32(dev, SSB_TMSLOW, reject | SSB_TMSLOW_CLOCK);
> +	ssb_wait_bit(dev, SSB_TMSLOW, reject, 1000, 1);
> +	ssb_wait_bit(dev, SSB_TMSHIGH, SSB_TMSHIGH_BUSY, 1000, 0);
> +	ssb_write32(dev, SSB_TMSLOW,
> +		    SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
> +		    reject | SSB_TMSLOW_RESET |
> +		    core_specific_flags);
> +	/* flush */
> +	ssb_read32(dev, SSB_TMSLOW);
> +	udelay(1);
> +
> +	ssb_write32(dev, SSB_TMSLOW,
> +		    reject | SSB_TMSLOW_RESET |
> +		    core_specific_flags);
> +	/* flush */
> +	ssb_read32(dev, SSB_TMSLOW);
> +	udelay(1);

mystery udelay.

> +}
> +EXPORT_SYMBOL(ssb_device_disable);
>
> ...
>
> +const struct ssb_bus_ops ssb_pci_ops = {
> +	.read16		= ssb_pci_read16,
> +	.read32		= ssb_pci_read32,
> +	.write16	= ssb_pci_write16,
> +	.write32	= ssb_pci_write32,
> +};

static?

> +static ssize_t ssb_pci_attr_sprom_show(struct device *pcidev,
> +				       struct device_attribute *attr,
> +				       char *buf)
> +{
> +	struct pci_dev *pdev = container_of(pcidev, struct pci_dev, dev);
> +	struct ssb_bus *bus;
> +	u16 *sprom;
> +	int err = -ENODEV;
> +	ssize_t count = 0;
> +
> +	bus = ssb_pci_dev_to_bus(pdev);
> +	if (!bus)
> +		goto out;
> +	err = -ENOMEM;
> +	sprom = kcalloc(SSB_SPROMSIZE_WORDS, sizeof(u16), GFP_KERNEL);
> +	if (!sprom)
> +		goto out;
> +
> +	err = -ERESTARTSYS;
> +	if (mutex_lock_interruptible(&bus->pci_sprom_mutex))
> +		goto out_kfree;
> +	sprom_do_read(bus, sprom);
> +	mutex_unlock(&bus->pci_sprom_mutex);
> +
> +	count = sprom2hex(sprom, buf, PAGE_SIZE);
> +	err = 0;
> +
> +out_kfree:
> +	kfree(sprom);
> +out:
> +	return err ? err : count;
> +}

The mutex_lock_interruptible() looks fishy.  Some commented explanation of
what it's doing would be good here.  It's quite unobvious to this reader. 
Cheesy deadlock avoidance?  Hope not.

> +
> +/* These are the main device register access functions.
> + * do_select_core is inline to have the likely hotpath inline.
> + * All unlikely codepaths are out-of-line. */
> +static inline int do_select_core(struct ssb_bus *bus,
> +				 struct ssb_device *dev,
> +				 u16 *offset)
> +{
> +	int err;
> +	u8 need_seg = (*offset >= 0x800) ? 1 : 0;
> +
> +	if (unlikely(dev != bus->mapped_device)) {
> +		err = ssb_pcmcia_switch_core(bus, dev);
> +		if (unlikely(err))
> +			return err;
> +	}
> +	if (unlikely(need_seg != bus->mapped_pcmcia_seg)) {
> +		err = ssb_pcmcia_switch_segment(bus, need_seg);
> +		if (unlikely(err))
> +			return err;
> +	}
> +	if (need_seg == 1)
> +		*offset -= 0x800;
> +
> +	return 0;
> +}

Looks too large for inlining.

> +const struct ssb_bus_ops ssb_pcmcia_ops = {
> +	.read16		= ssb_pcmcia_read16,
> +	.read32		= ssb_pcmcia_read32,
> +	.write16	= ssb_pcmcia_write16,
> +	.write32	= ssb_pcmcia_write32,
> +};

static?


