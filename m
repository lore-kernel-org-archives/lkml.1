Return-Path: <linux-kernel-owner+w=401wt.eu-S1762506AbXEZT2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762506AbXEZT2j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 15:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbXEZT2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 15:28:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:7918 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbXEZT2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 15:28:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=tz3ppp6peSZIRcAbCPEL0oANsEa/6Vt50gxEwUE/qn6/s54Ee+lvucnQ3HRqaZmYfIVlEZym3Y01KDyVKOPmMt54WILkg9do+MqnWT50zTU1eSPPX+g/JEBX7HGkSZ1nNUF1KzJRcprzZ3oWUCaf5o4HjSz6WMmOBhc7Wqpayzs=
Message-ID: <46588A3D.2060208@gmail.com>
Date: Sat, 26 May 2007 23:27:57 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: Roland Dreier <rdreier@cisco.com>, Greg KH <greg@kroah.com>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIE
References: <20070523155958.GA5282@kroah.com> <4654AB40.6060208@gmail.com> <adaejl79rh0.fsf@cisco.com> <4654BC10.2000808@gmail.com> <adazm3v89hv.fsf@cisco.com> <4654C85B.6060505@gmail.com> <adatzu385g1.fsf@cisco.com> <46561287.8020103@gmail.com> <ada1wh560u1.fsf@cisco.com> <46584C30.4030206@gmail.com> <20070526182828.GA7080@colo.lackof.org>
In-Reply-To: <20070526182828.GA7080@colo.lackof.org>
Content-Type: multipart/mixed;
 boundary="------------020703090708080804000401"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020703090708080804000401
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

Grant Grundler wrote:
> On Sat, May 26, 2007 at 07:03:12PM +0400, Manu Abraham wrote:
>> Roland Dreier wrote:
>>>  > I am now wondering whether the usage of MSI would help in this case and
>>>  > that i should be using enable_msi before request_irq ?
>>>
>>> MSI interrupts are never shared.  So if pci_enable_msi() succeeds, you
>>> can be sure that the interrupts you get with that IRQ number are
>>> coming from your device.
>>>
>> i presume then i shouldn't be using IRQF_SHARED, if using MSI.
> 
> I'm not sure...but my guess is not. Who ever "just knows", could you
> please submit a patch to Documentation/MSI-HOWTO.txt ?

did a bit of search in the sources, e1000 does avoid using IRQF_SHARED.
tg3 uses IRQF_SAMPLE_RANDOM, don't understand why SAMPLE_RANDOM though.

>> Another question would be if the device supports multiple messages, MSIX
>> should be used ?
> 
> Yes. Assuming the device supports multiple MSI-X messages.
> 

What i read from the specs:

6.2 Message Signals Interrupts
The MSI logic is responsible for generating the MSI messages.MSI is an
optional feature in PCI Express that enables a device to request a
service by writing a system-specified message to a system-specified
address (PCI Express DWORD memory write transaction). The write
transaction address specifies the MSI message destination and the write
transaction data specifies the message including a message “ID”. During
device configuration, system software reads the capability list of the
logic core to find out whether it supports MSI, and if yes how many
different MSI messages it is requesting. Using the multiple message
feature allows an PCI Express device to give different MSI messages a
unique message ID (e.g. an MSI message initiated by interrupt source #1
gets a different message ID
than an MSI message initiated by interrupt source#2). The max. number of
requested MSI messages is 32 and must be aligned to a power of two
(1,2,4,8,16, or 32). The core will be configured for 32 requested
messages, but optionally the default setting of 32 requested messages
can be modified by the BOOT logic immediately after power-on-reset (i.e.
before device configuration). After reading the capability list, system
 software initializes the following parameters:

- Multiple Message Enable field Defines the number of allowed messages,
which is either all or a subsetof the number of requested messages. For
example, a PCI Express device can request 4messages and be allocated
either four, two, or one message. The number of messages requested and
allocated are aligned to a power of two (a PCI Express device that
requires three messages must request four)

- MSI message destination address
Defines the (physical) message destination address of MSI messages.

- MSI message data
Defines the message data of MSI messages.

The main features of the MSI logic are:

• MSI capability
- 32 different messages
- programmable ID in MSI message data field
- programmable TC in MSI message address field
• Support for MSI delay timer
• Support for the following interrupt sources:
- DMA channel tag_ack (“buffer_done”) interrupts (12x)
- DMA channel overflow interrupts (12x)
- A/V interrupts (8x)
- I2C interrupts (2x)
- unmapped_tc interrupt (1x)
- external interrupts from GPIO (16x)
- all interrupts edge sensitive with programmable edge polarity
- round-robin arbitration between multiple, simultaneous interrupt requests
• Support for interrupt masking (i.e. enable/disable)
• Support for INT-A emulation
• DTL-MMIO target interface for SW access
- 4Kbyte address aperture (12bit address / 32bit aligned)
- 32bit read and write data

>> In such a context, if i request for say more than the messages that i
>> need, say i request 16 messages, but use only 1 or 2, that does bear any
>> consequences ?
> 
> Yes. One is allocating IRQ vectors from a finite number of vectors.
> But this normally isn't a problem until one gets to larger machines that
> have more than 4-8 PCI-e or PCI-X slots.

Ok. Alongwith this, i am a bit confused with the mailbox approach of
sending messages, every register type has it's own set of interrupt
registers (for example I2C, say I2C has it's own set of 32 STATUS
bitfields for it's interrupt, the same goes for the others)

Another aspect is the DTL-MMIO interface, which isn't defined any place.
Using the base addresses as an offset to the normal MMIO obtained using
pci_resource_*/ioremap() doesn't seem to work at all.

Seems like it needs some kind of a translation (guessing here, still no
clue yet) The device supports 50 MSI interrupt sources

Somewhere else it mentions thus:

6.4Global Register (GREG)
The logic provides a set of global registers there are accessible via a
device transaction level protocol memory mapped input output interface.
Primarily, the global registers are used to control and/or observe logic
inside the SAA7160 that is not directly accessible via the device status
network.

The main features of the GREG logic are:
• 16 general purpose global registers

• dedicated interfaces to/from the following SAA7160 blocks:
- core unit
- device transaction level 2 memory transaction level protocol adapter unit
- audio/video input unit
- Reset unit
- I²C to device transaction level unit
- pulse synchronization unit

• device transaction level protocol memory mapped input output target
interface for SW
access
- 4Kbyte address aperture (12bit address / 32bit aligned)
- 32bit read and write data
Furthermore, the GREG logic also implements 16 general-purpose global
registers that can be used whenever temporary storage of one or more
registers is needed. An example here could be a mailbox type of
application where an external I²C master writes to GREGvia I2CtoDTL, and
system software reads from GREG. It should be noted that the GREG logic
does not offer any hardware support for semaphoring, so in case of a
mailbox type of application data coherency needs to be ensured in some
other way, for example using GPIO.

In the SAA7160, the GREG logic has dedicated interfaces to/from the
following blocks:

• Audio/Video input unit
The glue logic inside the Audio/Video input block requires some control
to configure them into the desired operating mode. This glue logic
inside the A/V input block is controlled via registers in the GREG block.

• I²CtoDTL unit
The 7bit I²C slave address of the I²CtoDTL block can be defined via
register in the GREG logic. The default I²C slave address after reset is
0b1110000.

• Reset unit
All reset control circuitry is grouped together in the Reset block. Each
reset domain can be individually activated and/or released via registers
in the GREG logic.

• DTL2MTL adapter unit
The overflow mode in the DTL2MTL adapter can be enabled/disabled for
each DMA channel individually via a register in the GREG logic.

• PULSE_SYNC unit
The tag_ack filter for MSI in the PULSE_SYNC module can be enabled /
disabled via a register in the GREG logic.

• Core unit
At PCI Express reset, the PCI Express configuration registers inside the
core unit will be loaded with “default” values. Most of them are
hard-coded. Some others are application dependent and are provided as
configuration inputs at the core interface such that their reset values
can be defined via registers in the GREG logic.

> 
> Typically, one will limit the number of vectors to the number of CPUs
> in the system or to how many different events the device can signal.
> 
>>> But using MSI does not work on all systems, so your driver needs to
>>> work with standard (possibly shared) INTx interrupts too.  And you
>>> should probably provide at least a module flag to disable the use of
>>> MSI, to avoid problems on buggy systems.
>> I should probably look for CONFIG_PCI_MSI and check whether the system
>> supports MSI pci_enable_msi() ?
> 
> pci_enable_msi() will fail if the system doesn't support MSI or something
> else goes wrong with the call (e.g. already setup).

Ok, so that will be a good choice for testing whether the machine would
support MSI or not.
Did retouch the code, it looks like as attached, on module load/unload
the logs do look like this:

[  239.262464] saa716x_hybrid_probe: Searching for SAA7160/1/2 PCIe
Hybrid devices
[  239.262471] saa716x_pcie_init: found a Twinhan VP-6090 device
[  239.262506] PCI: Found IRQ 11 for device 0000:06:00.0
[  239.262945] PCI: Sharing IRQ 11 with 0000:00:03.0
[  239.263070] PCI: Sharing IRQ 11 with 0000:00:1a.0
[  239.263249] PCI: Sharing IRQ 11 with 0000:01:00.0
[  239.263402] PCI: Setting latency timer of device 0000:06:00.0 to 64
[  239.263636]      SAA7162 Rev 1 [1822:0027], irq: 215, latency: 0
[  239.263641]      IOMEM: 0x32200000-0x32300000 length:0x100000
[  239.263644]      MMIO: 0xe0b80000
[  239.317087] saa716x_pcie_init (0): Subsys:0xffffffff
[  307.602818] saa716x_pcie_exit (0): Unloading ..
[  307.602824] saa716x_pcie_exit (0): Disabling PCIe Bus Mastering ..
[  307.602853] saa716x_pcie_exit (0): SAA716x mem: 0xe0b80000

A bit confused on how Memory mapped I/O works here

Thanks,
Manu







--------------020703090708080804000401
Content-Type: text/plain;
 name="saa716x_pci.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="saa716x_pci.c"

#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/kernel.h>
#include <linux/pci.h>

#include <asm/io.h>
#include <linux/ioport.h>
#include <asm/pgtable.h>
#include <asm/page.h>
#include <linux/types.h>
#include <linux/interrupt.h>
#include <linux/kmod.h>
#include <linux/vmalloc.h>
#include <linux/init.h>
#include "saa716x_priv.h"
#include "saa716x_regs.h"
#include "saa716x_budget.h"

#define DRIVER_NAME				"SAA716x_CORE"

unsigned int verbose = 5;
module_param(verbose, int, 0644);
MODULE_PARM_DESC(verbose, "verbosity level");

static irqreturn_t saa716x_pcie_irq(int irq, void *dev_id)
{
	struct saa716x *saa716x;
	u32 i2c_stat1, i2c_stat2, mask;

	if (unlikely((saa716x = (struct saa716x *) dev_id) == NULL)) {
		printk(KERN_ERR "%s: Aeie NULL ptr\n", __func__);
		return IRQ_NONE;
	}
//	i2c_stat1 = saa716x_read(0xbfe0);
//	i2c_stat2 = saa716x_read(0xcfe0);
	dprintk(verbose, SAA716x_DEBUG, 0, "=== Interrupts[Core A: %04x - Core B: %04x] [", i2c_stat1, i2c_stat2);

	dprintk(verbose, SAA716x_DEBUG, 0, "] ==\n");

	return IRQ_HANDLED;
}

static irqreturn_t saa716x_pcie_irq_msi(int irq, void *dev_id)
{
	struct saa716x *saa716x;

	if (unlikely((saa716x = (struct saa716x *) dev_id) == NULL)) {
		printk(KERN_ERR "%s: Aeie NULL ptr\n", __func__);
		return IRQ_NONE;
	}

	return IRQ_HANDLED;
}

static int saa716x_request_irq(struct saa716x *saa716x)
{
	u32 flags;
	int err;

	flags = IRQF_SHARED;
#ifdef CONFIG_PCI_MSI
	saa716x->have_msi = TRUE;
	if ((err = pci_enable_msi(saa716x->pdev))) {
		printk("%s ERROR(%d): unable to allocate MSI Interrupt\n", __func__, err);
		saa716x->have_msi = FALSE;
	}
	if (saa716x->have_msi) {
		flags &= ~IRQF_SHARED;
		err = request_irq(saa716x->pdev->irq, &saa716x_pcie_irq_msi, flags, DRIVER_NAME, saa716x);
		if (err)
			printk("%s ERROR(%d): Unable to allocate Interrupt\n", __func__, err);
	} else
#endif
	if ((err = request_irq(saa716x->pdev->irq, &saa716x_pcie_irq, flags, DRIVER_NAME, saa716x)) != 0)
		printk("%s ERROR(%d): Unable to allocate Interrupt\n", __func__, err);

	return err;
}

static void saa716x_free_irq(struct saa716x *saa716x)
{
	free_irq(saa716x->pdev->irq, saa716x);

#ifdef CONFIG_PCI_MSI
	if (saa716x->have_msi)
		pci_disable_msi(saa716x->pdev);
#endif
}

int saa716x_pcie_init(struct saa716x *saa716x)
{
	struct pci_dev *pdev = saa716x->pdev;
	int err = 0;
	u8 latency, revision;
	u32 i2c_stat, int_stat, flags, subsys;
	unsigned long mmio_start, mmio_len;

	printk(KERN_INFO "%s: found a %s device\n", __func__, saa716x->hwconfig->model_name);
	pci_set_drvdata(pdev, saa716x);
	if ((err = pci_enable_device(pdev)) != 0) {
		printk(KERN_ERR "%s ERROR: pci enable failed (%i)\n", __func__, err);
		goto fail0;
	}
	if (!(pci_resource_flags(pdev, BAR_0) & IORESOURCE_MEM)) {
		printk(KERN_ERR "Cannot find proper PCIe device "
		       "base addrress, aborting.\n");

		err = -ENODEV;
		goto fail1;
	}
	if ((err = pci_request_region(pdev, BAR_0, DRIVER_NAME)) < 0) {
		printk(KERN_ERR "%s ERROR: mem region request failed\n", __func__);
		err = -ENOMEM;
		goto fail1;
	}
	pci_set_master(pdev);
	mmio_start = pci_resource_start(pdev, BAR_0);
	mmio_len = pci_resource_len(pdev, BAR_0);
	err = -EIO;

	if (!(saa716x->mmio = ioremap(mmio_start, mmio_len)))
		goto fail2;

	saa716x->mmio_start = mmio_start;
	saa716x->mmio_end = mmio_start + mmio_len;
	err = saa716x_request_irq(saa716x);
	if (err)
		goto fail2;

	pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &latency);
	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);

	dprintk(verbose, SAA716x_ERROR, 0, "     SAA7162 Rev %d [%04x:%04x], ",
		revision,
		saa716x->pdev->subsystem_vendor,
		saa716x->pdev->subsystem_device);

	dprintk(verbose, SAA716x_ERROR, 0,
		"irq: %d, latency: %d\n     IOMEM: 0x%lx-0x%lx length:0x%lx\n",
		saa716x->pdev->irq,
		latency,
		saa716x->mmio_start,
		saa716x->mmio_end,
		mmio_len);

	dprintk(verbose, SAA716x_ERROR, 0, "     MMIO: 0x%p\n", saa716x->mmio);
	saa716x->verbose = verbose;

//	init_waitqueue_head(&saa716x->i2c_queue);
	/* Disable all interrupts here */
//	saa716x_write(0, 0x500);
//	i2c_stat = saa716x_read(0xb008);
//	int_stat = saa716x_read(0x500);
//	dprintk(verbose, SAA716x_ERROR, 1, "I2C Status=[0x%04x]", i2c_stat);
//	dprintk(verbose, SAA716x_ERROR, 1, "INT Status=[0x%04x]", int_stat);

	subsys = saa716x_read(0x00012000);
	dprintk(verbose, SAA716x_ERROR, 1, "Subsys:0x%04x", subsys);

	return 0;

fail2:
	iounmap(saa716x->mmio);
	release_mem_region(pci_resource_start(saa716x->pdev, 0),
			   pci_resource_len(saa716x->pdev, 0));
fail1:
	pci_disable_device(pdev);
fail0:
	pci_set_drvdata(pdev, NULL);
	return err;
}
EXPORT_SYMBOL_GPL(saa716x_pcie_init);

void saa716x_pcie_exit(struct saa716x *saa716x)
{
	struct pci_dev *pdev = saa716x->pdev;
	u8 command;

	dprintk(verbose, SAA716x_ERROR, 1, "Unloading .. ");
	dprintk(verbose, SAA716x_ERROR, 1, "Disabling PCIe Bus Mastering ..");
	pci_read_config_byte(pdev, PCI_COMMAND, &command);
	command &= ~PCI_COMMAND_MASTER;
	pci_write_config_byte(pdev, PCI_COMMAND, command);
	saa716x_free_irq(saa716x);
	dprintk(verbose, SAA716x_NOTICE, 1, "SAA716x mem: 0x%p", saa716x->mmio);
	iounmap(saa716x->mmio);

	release_mem_region(pci_resource_start(pdev, 0),
			   pci_resource_len(pdev, 0));

	pci_disable_device(pdev);
	pci_set_drvdata(pdev, NULL);
}
EXPORT_SYMBOL_GPL(saa716x_pcie_exit);

MODULE_DESCRIPTION("SAA716x PCIe bridge driver");
MODULE_AUTHOR("Manu Abraham");
MODULE_LICENSE("GPL");






--------------020703090708080804000401--
