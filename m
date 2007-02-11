Return-Path: <linux-kernel-owner+w=401wt.eu-S932565AbXBKVyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565AbXBKVyj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 16:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932566AbXBKVyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 16:54:39 -0500
Received: from mout0.freenet.de ([194.97.50.131]:50088 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932565AbXBKVyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 16:54:37 -0500
X-Greylist: delayed 5513 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Feb 2007 16:54:37 EST
From: Sascha Sommer <saschasommer@freenet.de>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Experimental driver for Ricoh Bay1Controller SD Card readers
Date: Sun, 11 Feb 2007 21:22:37 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, rmk+mmc@arm.linux.org.uk,
       Elladan <elladan@eskimo.com>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Pierre Ossman <drzeus-list@drzeus.cx>
References: <200701070032.27234.saschasommer@freenet.de> <45A0C3A7.2040506@gmail.com>
In-Reply-To: <45A0C3A7.2040506@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Os3zFFWL9ORNU0b"
Message-Id: <200702112122.38440.saschasommer@freenet.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_Os3zFFWL9ORNU0b
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

On Sunday 07 January 2007 10:56, Jiri Slaby wrote:
> Sascha Sommer wrote:
> > Hi,
> >
> > Attached is a very experimental driver for a Ricoh SD Card reader that
> > can be found in some notebooks like the Samsung P35.
> >
> > Whenever a sd card is inserted into one of these notebooks, a virtual
> > pcmcia card will show up:
> >
> > Socket 0:
> >   product info: "RICOH", "Bay1Controller", "", ""
> >   manfid: 0x0000, 0x0000
> >
> > In order to write this driver I hacked qemu to have access to the cardbus
> > bridge containing this card. I then logged the register accesses of the
> > windows xp driver and tryed to analyse them.
> >
> > As the meanings of most of the register are still unknown to me, I
> > consider this driver very experimental. It is possible that this driver
> > might destroy your data or your hardware. Use at your own risk!
> >
> > Other problems:
> > - I only implemented reading support
> > - I only tested with a 128 MB SD card, no idea what would be needed to
> > support other card types
> > - irqs are not supported
> > - dma is not supported
> > - it is very slow
> > - the registers can be found on the cardbus bridge and not on the virtual
> >   pcmcia card. The cardbus bridge is already claimed by yenta_socket.
> >   Therefore the driver currently uses pci_find_device to find the cardbus
>
> - pci_find_device is no go today. Use pci_get_device (+ pci_dev_get, _put).
> - ioremap->pci_iomap
> - iobase should be __iomem.
> - codingstyle (char* buffer, for(loop, if(data){, ...)
>

Thanks for your feedback and testing.
I fixed the above problems and ran the code through Lindent.
Apart from that I did the following changes:
- implemented suspend/resume support (not tested very much)
- named the registers
- fixed a bug that caused a major slowdown when modprobed without debug=1
- added writting support (disabled by default, modprobe with write=1)
Before you enable writting please make sure that you did a proper backup of 
the data on the card. Do not use this driver to save important data.

I still consider this driver experimental, but without documentation this is 
probably not going to change anytime soon.
The question is now what I should do with the driver?
Is it worth to be included in the kernel? If yes where and against what 
kernelversion should I send the patch?


Thanks

Sascha


--Boundary-00=_Os3zFFWL9ORNU0b
Content-Type: text/x-makefile;
  charset="iso-8859-1";
  name="Makefile"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="Makefile"

KERNEL_VERSION = $(shell uname -r)
KERNEL_DIR = /lib/modules/$(KERNEL_VERSION)/build
MDIR = /lib/modules/$(KERNEL_VERSION)/kernel/drivers/mmc

obj-m += sdricoh_cs.o

default:
	$(MAKE) -C $(KERNEL_DIR) SUBDIRS=$(PWD) modules

install:
	if test ! -d $(MDIR) ; then mkdir -p $(MDIR) ; fi
	install -D -m 644 *.ko $(MDIR)
	depmod -a

clean:
	rm -f *.o *.ko *.mod.c .*o.cmd .*o.d .*o.flags
	rm -rf .tmp_versions

--Boundary-00=_Os3zFFWL9ORNU0b
Content-Type: text/x-csrc;
  charset="iso-8859-1";
  name="sdricoh_cs.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sdricoh_cs.c"

/*
 *  sdricoh_cs.c - driver for Ricoh Secure Digital Card Readers that can be found
 *     on some Ricoh RL5c476 II cardbus bridge
 *
 *  Copyright (C) 2006 - 2007 Sascha Sommer <saschasommer@freenet.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 * 
 * FIXME:
 *   - what about irqs and dma?
 */

#include <linux/delay.h>
#include <linux/highmem.h>
#include <linux/pci.h>
#include <linux/ioport.h>

#include <pcmcia/cs_types.h>
#include <pcmcia/cs.h>
#include <pcmcia/cistpl.h>
#include <pcmcia/ciscode.h>
#include <pcmcia/ds.h>
#include <pcmcia/cisreg.h>
#include <asm/io.h>

#include <linux/mmc/host.h>
#include <linux/mmc/protocol.h>

#define DRIVER_NAME "sdricoh_cs"
#define DRIVER_VERSION "0.1"

static unsigned int debug = 0;
static unsigned int write = 0;

//#define DEBUG

/* debug macros */

#ifdef DEBUG
#define REGDBG(fmt, arg...) do {\
        if (debug > 1) \
                printk(KERN_INFO "sdricoh_cs: "fmt, \
                         ##arg); } while (0)
#else
#define REGDBG(fmt, arg...)
#endif

#define DBG(fmt, arg...) do {\
        if (debug > 0) \
                printk(KERN_INFO "sdricoh_cs: "fmt, \
                         ##arg); } while (0)

#define ERR(fmt, arg...) do {\
                printk(KERN_INFO "sdricoh_cs: "fmt, \
                         ##arg); } while (0)

/* i/o region */
#define SDRICOH_PCI_REGION 0
#define SDRICOH_PCI_REGION_SIZE 0x1000

/* registers */
#define R104_VERSION     0x104
#define R200_CMD         0x200
#define R204_CMD_ARG     0x204
#define R208_DATAIO      0x208
#define R20C_RESP        0x20c
#define R21C_STATUS      0x21c
#define R2E0_INIT        0x2e0
#define R2E4_STATUS_RESP 0x2e4
#define R2F0_RESET       0x2f0
#define R224_CLOCK       0x224
#define R228_POWER       0x228
#define R230_DATA        0x230

/* flags for the R21C_STATUS register */
#define STATUS_CMD_FINISHED   0x00000001
#define STATUS_CARD_INSERTED  0x00000020
#define STATUS_CARD_LOCKED    0x00000080
#define STATUS_CMD_TIMEOUT    0x00400000
#define STATUS_READY_TO_READ  0x01000000
#define STATUS_READY_TO_WRITE 0x02000000
#define STATUS_BUSY           0x40000000

/* timeouts */
#define INIT_TIMEOUT      100
#define CMD_TIMEOUT       100
#define TRANSFER_TIMEOUT  20000

/* list of supported pcmcia devices */
static struct pcmcia_device_id pcmcia_ids[] = {
	/* vendor and device strings followed by their crc32 hashes */
	PCMCIA_DEVICE_PROD_ID12("RICOH", "Bay1Controller", 0xd9f522ed,
				0xc3901202),
	PCMCIA_DEVICE_NULL,
};

MODULE_DEVICE_TABLE(pcmcia, pcmcia_ids);

/* mmc privdata */
struct sdricoh_host {
	struct mmc_host *mmc;	/* MMC structure */
	unsigned char __iomem *iobase;
	struct pci_dev *pci_dev;
};

/***************** register i/o helper functions *****************************/

static inline unsigned int sdricoh_readl(struct sdricoh_host *host,
					 unsigned int reg)
{
	unsigned int value = readl(host->iobase + reg);
	REGDBG("rl %x 0x%x\n", reg, value);
	return value;
}

static inline void sdricoh_writel(struct sdricoh_host *host, unsigned int reg,
				  unsigned int value)
{
	writel(value, host->iobase + reg);
	REGDBG("wl %x 0x%x\n", reg, value);

}

static inline unsigned int sdricoh_readw(struct sdricoh_host *host,
					 unsigned int reg)
{
	unsigned int value = readw(host->iobase + reg);
	REGDBG("rb %x 0x%x\n", reg, value);
	return value;
}

static inline unsigned int sdricoh_readb(struct sdricoh_host *host,
					 unsigned int reg)
{
	unsigned int value = readb(host->iobase + reg);
	REGDBG("rb %x 0x%x\n", reg, value);
	return value;
}

static int sdricoh_mmc_cmd(struct sdricoh_host *host, unsigned char opcode,
			   unsigned int arg)
{
	unsigned int status;
	int result = MMC_ERR_NONE;
	unsigned int loop = 0;
	/* reset status reg? */
	sdricoh_writel(host, R21C_STATUS, 0x18);
	/* fill parameters */
	sdricoh_writel(host, R204_CMD_ARG, arg);
	sdricoh_writel(host, R200_CMD, (0x10000 << 8) | opcode);
	/* wait for command completion */
	if (opcode) {
		for (loop = 0; loop < CMD_TIMEOUT; loop++) {
			status = sdricoh_readl(host, R21C_STATUS);
			sdricoh_writel(host, R2E4_STATUS_RESP, status);
			if (status & STATUS_CMD_FINISHED)
				break;
			msleep(1);
		}
		if (loop == CMD_TIMEOUT || status & STATUS_CMD_TIMEOUT)
			result = MMC_ERR_TIMEOUT;
	}
	DBG("mmc_cmd opcode=%i arg=0x%x => %i (queries=%i)\n",
	    opcode, arg, result, loop);
	return result;

}

static int sdricoh_reset(struct sdricoh_host *host)
{
	unsigned int loop;
	DBG("reset\n");
	sdricoh_writel(host, R2F0_RESET, 0x10001);
	sdricoh_writel(host, R2E0_INIT, 0x10000);
	if (sdricoh_readl(host, R2E0_INIT) != 0x10000)
		return -EIO;
	sdricoh_writel(host, R2E0_INIT, 0x10007);

	/* status register ? */
	sdricoh_writel(host, R21C_STATUS, 0x18);

	/* clock or power register ? */
	sdricoh_writel(host, R224_CLOCK, 0x2000320);

	if (sdricoh_mmc_cmd(host, MMC_GO_IDLE_STATE, 0x0))
		return -EIO;

	/* what is this for ? */
	for (loop = 0; loop < INIT_TIMEOUT; loop++) {
		int result;
		if (sdricoh_mmc_cmd(host, MMC_APP_CMD, 0x0))
			return -EIO;
		result = sdricoh_mmc_cmd(host, 0x69, 0x100000);
		if (result) {
			if (result == MMC_ERR_TIMEOUT)
				continue;
			return -EIO;
		}
		if (sdricoh_readw(host, 0x20e) == 0x80ff)
			break;
	}

	if (loop == INIT_TIMEOUT) {
		DBG("timeout waiting for init to complete\n");
		return -EIO;
	}

	return 0;
}

static int sdricoh_read_block_pio(struct sdricoh_host *host, char *buffer)
{
	unsigned int *buf = (unsigned int *)buffer;
	unsigned int loop;
	int i;

	/* wait until the data is available */
	for (loop = 0; loop < CMD_TIMEOUT; loop++) {
		unsigned int status = sdricoh_readl(host, R21C_STATUS);
		sdricoh_writel(host, R2E4_STATUS_RESP, status);
		if (status & STATUS_READY_TO_READ)
			break;
	}
	sdricoh_writel(host, R21C_STATUS, 0x18);

	if (loop == CMD_TIMEOUT) {
		ERR("read_block: timeout waiting for data\n");
		return 0;
	}

	/* read data */
	for (i = 0; i < 512 / 4; i++) {
		buf[i] = sdricoh_readl(host, R230_DATA);
	}
	return 512;
}

static int sdricoh_write_block_pio(struct sdricoh_host *host, char *buffer)
{
	unsigned int *buf = (unsigned int *)buffer;
	unsigned int loop;
	int i;

	/* wait until the data is available */
	for (loop = 0; loop < CMD_TIMEOUT; loop++) {
		unsigned int status = sdricoh_readl(host, R21C_STATUS);
//              sdricoh_writel(host, R2E4_STATUS_RESP, status);
		if (status & STATUS_READY_TO_WRITE)
			break;
	}
	sdricoh_writel(host, R21C_STATUS, 0x18);

	if (loop == CMD_TIMEOUT) {
		ERR("write_block: timeout waiting for data\n");
		return 0;
	}

	/* write data */
	for (i = 0; i < 512 / 4; i++) {
		sdricoh_writel(host, R230_DATA, buf[i]);
	}
	return 512;
}

static void sdricoh_request(struct mmc_host *mmc, struct mmc_request *mrq)
{
	struct sdricoh_host *host = mmc_priv(mmc);
	struct mmc_command *cmd = mrq->cmd;
	struct mmc_data *data = cmd->data;

	DBG("=============================\n");
	DBG("sdricoh_request opcode=%i\n", cmd->opcode);

	/* read/write commands seem to require this */
	if (data) {
		sdricoh_writel(host, R208_DATAIO, 0);
	}

	cmd->error = sdricoh_mmc_cmd(host, cmd->opcode, cmd->arg);

	/* read response buffer */
	if (cmd->flags & MMC_RSP_PRESENT) {
		if (cmd->flags & MMC_RSP_136) {
			int i;
			/* CRC is stripped so we need to do some shifting. */
			for (i = 0; i < 4; i++) {
				cmd->resp[i] =
				    sdricoh_readl(host,
						  R20C_RESP + (3 - i) * 4) << 8;
				if (i != 3)
					cmd->resp[i] |=
					    sdricoh_readb(host,
							  R20C_RESP + (3 -
								       i) * 4 -
							  1);
			}
			DBG("resp[0]=0x%x\n", cmd->resp[0]);
			DBG("resp[1]=0x%x\n", cmd->resp[1]);
			DBG("resp[2]=0x%x\n", cmd->resp[2]);
			DBG("resp[2]=0x%x\n", cmd->resp[3]);
		} else {
			cmd->resp[0] = sdricoh_readl(host, R20C_RESP);
			DBG("resp[0]=0x%x\n", cmd->resp[0]);
		}
	}

	/* special command handling */
	if (cmd->opcode == MMC_SELECT_CARD) {
		sdricoh_mmc_cmd(host, MMC_APP_CMD, cmd->arg);	/* what is this for? set bus_width? */
		sdricoh_mmc_cmd(host, 0x46, 0x02);
	}

	/* transfer data */
	if (data && cmd->error == MMC_ERR_NONE
	    && cmd->opcode != SD_APP_SEND_SCR) {
		int i;
		char *mapped_sg = kmap_atomic(data->sg->page, KM_BIO_SRC_IRQ);
		DBG("read block: blksz %i blocks %i sg_len %i current length  %i\n", data->blksz, data->blocks, data->sg_len, data->sg->length);

		/* enter data reading mode */
		sdricoh_writel(host, R21C_STATUS, 0x837f031e);
		for (i = 0; i < data->blocks; i++) {
			if (data->flags & MMC_DATA_READ) {
				data->bytes_xfered +=
				    sdricoh_read_block_pio(host,
							   mapped_sg +
							   data->sg->offset +
							   (512 * i));
			} else {
				data->bytes_xfered +=
				    sdricoh_write_block_pio(host,
							    mapped_sg +
							    data->sg->offset +
							    (512 * i));
			}
		}
		kunmap_atomic(mapped_sg, KM_BIO_SRC_IRQ);

		sdricoh_writel(host, R208_DATAIO, 1);

		/* wait until the tranfer is finished */
		for (i = 0; i < TRANSFER_TIMEOUT; i++) {
			unsigned int status = sdricoh_readl(host, R21C_STATUS);
			sdricoh_writel(host, R2E4_STATUS_RESP, status);
			if (!(status & STATUS_BUSY))
				break;
		}
		if (i == TRANSFER_TIMEOUT) {
			ERR("timeout waiting for end of data cmd\n");
			cmd->error = MMC_ERR_TIMEOUT;
		}
		/* reset status register */
		sdricoh_writel(host, R21C_STATUS, 0x18);
	}

	mmc_request_done(mmc, mrq);
	DBG("=============================\n");
}

static void sdricoh_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
{
	struct sdricoh_host *host = mmc_priv(mmc);
	DBG("set_ios\n");

	if (ios->power_mode == MMC_POWER_ON) {
		sdricoh_writel(host, R224_CLOCK, 0x2000300);
		sdricoh_writel(host, R228_POWER, 0x40e0);
	}
}

static int sdricoh_get_ro(struct mmc_host *mmc)
{
	struct sdricoh_host *host = mmc_priv(mmc);
	unsigned int status;

	if (!write)
		return 1;

	status = sdricoh_readl(host, R21C_STATUS);
	sdricoh_writel(host, R2E4_STATUS_RESP, status);
	return (status & STATUS_CARD_LOCKED);
}

static struct mmc_host_ops sdricoh_ops = {
	.request = sdricoh_request,
	.set_ios = sdricoh_set_ios,
	.get_ro = sdricoh_get_ro,
};

/* initialize the control and register it to the mmc framework */
static int sdricoh_init_mmc(struct pci_dev *pci_dev,
			    struct pcmcia_device *pcmcia_dev)
{
	int result = 0;
	void *iobase = NULL;
	struct mmc_host *mmc = NULL;
	struct sdricoh_host *host = NULL;
	/* map iomem */
	if (pci_resource_len(pci_dev, SDRICOH_PCI_REGION) !=
	    SDRICOH_PCI_REGION_SIZE) {
		DBG("unexpected pci resource len\n");
		return -ENODEV;
	}
	iobase =
	    pci_iomap(pci_dev, SDRICOH_PCI_REGION, SDRICOH_PCI_REGION_SIZE);
	if (!iobase) {
		DBG("unable to map iobase\n");
		return -ENODEV;
	}
	/* check version? */
	if (readl(iobase + R104_VERSION) != 0x4000) {
		DBG("no supported mmc controller found\n");
		result = -ENODEV;
		goto err;
	}
	/* allocate privdata */
	mmc = pcmcia_dev->priv =
	    mmc_alloc_host(sizeof(struct sdricoh_host), &pcmcia_dev->dev);
	if (!mmc) {
		result = -ENOMEM;
		goto err;
	}
	host = mmc_priv(mmc);

	host->iobase = iobase;

	mmc->ops = &sdricoh_ops;

	/* FIXME: the following values are probably not correct 
	   we don't know how to change ocr and frequency at all 
	   hopefully it is configured correctly by the controller
	 */
	mmc->f_min = 450000;
	mmc->f_max = 24000000;
	mmc->caps = MMC_CAP_4_BIT_DATA;
	mmc->ocr_avail |= MMC_VDD_32_33 | MMC_VDD_33_34;

	mmc->max_sectors = 1024;
	mmc->max_seg_size = mmc->max_sectors * 512;

	/* reset the controler */
	if (sdricoh_reset(host)) {
		ERR("could not reset\n");
		result = -EIO;
		goto err;

	}

	result = mmc_add_host(mmc);

	if (!result) {
		DBG("mmc host registered\n");
		return 0;
	}

      err:
	if (iobase)
		iounmap(iobase);
	if (mmc)
		mmc_free_host(mmc);

	return result;
}

/* search for supported mmc controllers */
static int sdricoh_pcmcia_probe(struct pcmcia_device *pcmcia_dev)
{
	struct pci_dev *pci_dev = NULL;

	DBG("found pcmcia device %s %s\n", pcmcia_dev->prod_id[0],
	    pcmcia_dev->prod_id[1]);
	DBG("searching mmc controler...\n");

	/* search pci cardbus bridge that contains the mmc controler */
	/* the io region is already claimed by yenta_socket... */
	while ((pci_dev =
		pci_get_device(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_RL5C476,
			       pci_dev))) {
		/* try to init the device */
		if (!sdricoh_init_mmc(pci_dev, pcmcia_dev))
			return 0;

	}

	return -ENODEV;
}

static void sdricoh_pcmcia_detach(struct pcmcia_device *link)
{
	struct mmc_host *mmc = link->priv;

	DBG("detach\n");

	flush_scheduled_work();

	/* remove mmc host */
	if (mmc) {
		struct sdricoh_host *host = mmc_priv(mmc);
		mmc_remove_host(mmc);
		pci_iounmap(host->pci_dev, host->iobase);
		pci_dev_put(host->pci_dev);
		mmc_free_host(mmc);
	}

}

static int sdricoh_pcmcia_suspend(struct pcmcia_device *link)
{
        struct mmc_host *mmc = link->priv;
	DBG("suspend\n");
	mmc_suspend_host(mmc, PMSG_SUSPEND);
	return 0;
}

static int sdricoh_pcmcia_resume(struct pcmcia_device *link)
{
        struct mmc_host *mmc = link->priv;
	DBG("resume\n");
	mmc_resume_host(mmc);
	return 0;
}

static struct pcmcia_driver sdricoh_driver = {
	.drv = {
		.name = DRIVER_NAME,
		},
	.probe = sdricoh_pcmcia_probe,
	.remove = sdricoh_pcmcia_detach,
	.id_table = pcmcia_ids,
	.suspend = sdricoh_pcmcia_suspend,
	.resume = sdricoh_pcmcia_resume,
};

/*****************************************************************************\
 *                                                                           *
 * Driver init/exit                                                          *
 *                                                                           *
\*****************************************************************************/

static int __init sdricoh_drv_init(void)
{
	DBG("Ricoh RL5c476 II Secure Digital Interface driver\n");
	DBG("Copyright(c) Sascha Sommer\n");
	return pcmcia_register_driver(&sdricoh_driver);
}

static void __exit sdricoh_drv_exit(void)
{
	DBG("exiting\n");
	pcmcia_unregister_driver(&sdricoh_driver);

}

module_init(sdricoh_drv_init);
module_exit(sdricoh_drv_exit);

module_param(debug, uint, 0444);
module_param(write, uint, 0444);

MODULE_AUTHOR("Sascha Sommer <saschasommer@freenet.de>");
MODULE_DESCRIPTION("Ricoh RL5c476 II Secure Digital Interface driver");
MODULE_VERSION(DRIVER_VERSION);
MODULE_LICENSE("GPL");

MODULE_PARM_DESC(debug, "Enable debugging (default 0)");
MODULE_PARM_DESC(write,
		 "Dangerous: Enable writting. Might destroy the data on the sd card. (default 0)");

--Boundary-00=_Os3zFFWL9ORNU0b--
