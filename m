Return-Path: <linux-kernel-owner+w=401wt.eu-S1765415AbYEAXkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765415AbYEAXkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbYEAXkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:40:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504AbYEAXkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:40:04 -0400
Date: Thu, 1 May 2008 16:39:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sascha Sommer <saschasommer@freenet.de>
Cc: linux-kernel@vger.kernel.org, sdricohcs-devel@lists.sourceforge.net,
       Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: [PATCH] MMC/SD host driver for Ricoh Bay1Controllers
Message-Id: <20080501163940.b49f9c4f.akpm@linux-foundation.org>
In-Reply-To: <200804271617.53438.saschasommer@freenet.de>
References: <200804271617.53438.saschasommer@freenet.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008 16:17:53 +0200
Sascha Sommer <saschasommer@freenet.de> wrote:

> Hi,
> 
> attached you can find a driver for MMC/SD card controllers that have been 
> integrated into some Notebooks with Ricoh Co Ltd RL5c476 II Cardbus bridges. 

Thanks.

Please do copy Pierre on mmc patches.

> This includes the Samsung P35 notebook, the Dell X300 and some notebooks from 
> the Asus M6N series.
> Whenever a MMC or SD card is insterted in the cardslot of one of these 
> notebooks the cardbus bridge will announce a 
> virtual Ricoh Bay1Controller PCMCIA card.
> 
> Since I submitted the first version of this driver to lkml last year many 
> changes have been made. The driver can now read and write to MMC and SD cards 
> and the reading speed for SD cards should be close to the windows driver now.
> Many thanks to all the people that tested the driver and helped me to fix some 
> of the remaining bugs. I think it is now time to find out what needs to be 
> fixed before the driver can go into kernel.
> 
> While the driver is working fine for me there are still some not so nice parts 
> in it. 
> - the registers are on the cardbus bridge that is already claimed by yenta 
> socket therefore the driver has to use pci_get_device
> - there is a lot of register polling because the reader does not support irqs
> - some mmc commands require extra hacks. One of those commands is the
>   SD_APP_SEND_SCR command (a user reported that it is required for his SDHC
>   card). Like the read and write commands this command
>   requires a block read to read the scr but this does not seem to work.
>   I do not have any documentation for this device and the windows driver does
>   not support such commands so I cannot find the
>   needed info in its logfiles.
> ...
> 
> I'm thankfull for any kind of feedback.
> 
> Signed-off-by: Sascha Sommer <saschasommer@freenet.de>

The patch has a large number of trivial layout problems, most of which we
wold ordinarily prefer be fixed.  Please pass the diff through
scripts/checkpatch.pl and consider the output?

>
> ...
>
> +#define DRIVER_NAME "sdricoh_cs"
> +#define DRIVER_VERSION "0.1.4"

Please consider removing the driver version.  It becomes useless once the
code is merge into the kernel - it cannot be used to determine exactly
which version of the driver your users are running.  Distros may patch the
driver, other kernel develoeprs may patch it and forget to increment the
version number, etc.

To regenerate a user's driver source the only reliable approach is to find
out their kernel version and then go find the source to that kernel.

> +static unsigned int debug = 0;
> +static unsigned int switchlocked = 0;
> +
> +/* #define DEBUG */
> +
> +/* debug macros */
> +
> +#ifdef DEBUG
> +#define REGDBG(fmt, arg...) do {\
> +        if (debug > 1) \
> +                printk(KERN_INFO "sdricoh_cs: "fmt, \

Use DRIVER_NAME here

> +                         ##arg); } while (0)
> +#else
> +#define REGDBG(fmt, arg...)
> +#endif
> +
> +#define DBG(fmt, arg...) do {\
> +        if (debug > 0) \
> +                printk(KERN_INFO DRIVER_NAME ": "fmt, \
> +                         ##arg); } while (0)
> +
> +#define ERR(fmt, arg...) do {\
> +                printk(KERN_INFO DRIVER_NAME ": "fmt, \
> +                         ##arg); } while (0)
> +
> +#define INFO(fmt, arg...) do {\
> +                printk(KERN_INFO DRIVER_NAME ": "fmt, \
> +                         ##arg); } while (0)

It'd be nice to use common debug macros rather than home-made ones. 
include/linux/kernel.h has one.  But don't bust a gut over it - thousands
of drivers do this :(

>
> ...
>
> +static int sdricoh_query_status(struct sdricoh_host *host,unsigned int wanted,
> +				unsigned int timeout){
> +	unsigned int loop;
> +	unsigned int status = 0;
> +	for (loop = 0; loop < timeout; loop++) {
> +		status = sdricoh_readl(host, R21C_STATUS);
> +		sdricoh_writel(host, R2E4_STATUS_RESP, status);
> +		if (status & wanted)
> +			break;
> +	}
> +
> +        if (loop == timeout) {
> +                ERR("query_status: timeout waiting for data\n");
> +                return -ETIMEDOUT;
> +        }

Something went wrong with the indenting there, although I expect checkpatch
will notice it.

> +	/* do not do this check in the loop as some commands fail otherwise */
> +	if(status & 0x7F0000){
> +		ERR("waiting for status bit %x failed\n",wanted);
> +		return -EINVAL;
> +	}
> +	return 0;
> +
> +}
> +
> +
> +
> +
> +

?

> +static int sdricoh_mmc_cmd(struct sdricoh_host *host, unsigned char opcode,
> +			   unsigned int arg)
> +{
> +	unsigned int status;
> +	int result = 0;
> +	unsigned int loop = 0;
> +	/* reset status reg? */
> +	sdricoh_writel(host, R21C_STATUS, 0x18);
> +	/* fill parameters */
> +	sdricoh_writel(host, R204_CMD_ARG, arg);
> +	sdricoh_writel(host, R200_CMD, (0x10000 << 8) | opcode);
> +	/* wait for command completion */
> +	if (opcode) {
> +		for (loop = 0; loop < CMD_TIMEOUT; loop++) {
> +			status = sdricoh_readl(host, R21C_STATUS);
> +			sdricoh_writel(host, R2E4_STATUS_RESP, status);
> +			if (status  & STATUS_CMD_FINISHED)
> +				break;
> +		}
> +		if (loop == CMD_TIMEOUT || status & STATUS_CMD_TIMEOUT)

The test of STATUS_CMD_TIMEOUT here is redundant.

Perhaps you meant to break out of the loop if STATUS_CMD_TIMEOUT becomes
set.

> +			result = -ETIMEDOUT;
> +
> +	}
> +	DBG("mmc_cmd opcode=%i arg=0x%x => %i (queries=%i)\n",
> +	    opcode, arg, result, loop);
> +
> +	if(result == 0){
> +		/* EXT_CSD are filtered so this should be save */
> +                if(opcode == SD_SEND_IF_COND){
> +                        if(host->mode != MODE_SDHC){
> +                                INFO("switching to SDHC mode\n");
> +                                host->mode = MODE_SDHC;
> +                        }
> +                }
> +
> +		/* switch to SD mode if APP_CMDs are supported */
> +		if(opcode == MMC_APP_CMD){
> +			if(host->mode == MODE_MMC){
> +				INFO("switching to SD mode\n");
> +				host->mode = MODE_SD;
> +			}
> +		}
> +	}
> +
> +	return result;
> +
> +}
>
> ...
>
> +static int sdricoh_blockio(struct sdricoh_host *host, int read,
> +				unsigned int* buf)
> +{
> +	int i;
> +	/* wait until the data is available */
> +	if(read){
> +		if(sdricoh_query_status(host,STATUS_READY_TO_READ,
> +						TRANSFER_TIMEOUT))
> +			return 0;
> +		sdricoh_writel(host, R21C_STATUS, 0x18);
> +		/* read data */
> +		for (i = 0; i < 512 / 4; i++) {
> +			buf[i] = sdricoh_readl(host, R230_DATA);
> +		}

Will this code work correctly on big-endian machines?

> +	}else{
> +		if(sdricoh_query_status(host,STATUS_READY_TO_WRITE,
> +						TRANSFER_TIMEOUT))
> +			return 0;
> +		sdricoh_writel(host, R21C_STATUS, 0x18);
> +		/* write data */
> +		for (i = 0; i < 512 / 4; i++) {
> +			sdricoh_writel(host, R230_DATA, buf[i]);
> +		}
> +	}
> +
> +	return 512;
> +}
> +
> +static int sdricoh_busy(struct sdricoh_host* host){

the brace goes on the next line, please.

> +	unsigned int status;
> +	int i;
> +	/* wait until the tranfer is finished */
> +	for (i = 0; i < BUSY_TIMEOUT; i++) {
> +		status = sdricoh_readl(host, R21C_STATUS);
> +		sdricoh_writel(host, R2E4_STATUS_RESP, status);
> +		if (!(status & STATUS_BUSY))
> +		break;

missing tab

> +	}
> +	if(status & 0x7F0000)
> +		return -EINVAL;
> +	if(i == BUSY_TIMEOUT)
> +		return -ETIMEDOUT;
> +	return 0;
> +}
> +
> +
> +static void sdricoh_request(struct mmc_host *mmc, struct mmc_request *mrq)
> +{
> +	struct sdricoh_host *host = mmc_priv(mmc);
> +	struct mmc_command *cmd = mrq->cmd;
> +	struct mmc_data *data = cmd->data;
> +	int i;
> +
> +	DBG("=============================\n");
> +	DBG("sdricoh_request opcode=%i\n", cmd->opcode);
> +
> +	sdricoh_writel(host, R21C_STATUS, 0x18);
> +
> +	/* we cannot handle all commands that require a block transfer
> +	   therefore do some ugly special handling here
> +	*/
> +	if(cmd->data){
> +		switch(cmd->opcode){
> +			/* working commands */
> +			case MMC_READ_SINGLE_BLOCK:
> +			case MMC_READ_MULTIPLE_BLOCK:
> +			case MMC_WRITE_BLOCK:
> +				break;
> +	               	case SD_APP_SEND_SCR: /* required for SDHC */
> +				cmd->error = sdricoh_mmc_cmd(host,
> +						       cmd->opcode,cmd->arg);
> +                       		mmc_request_done(mmc, mrq);
> +                       		return;
> +			default:
> +				DBG("unsupported command %i\n",cmd->opcode);
> +				cmd->error = -EINVAL;
> +				mmc_request_done(mmc, mrq);
> +				return;
> +		}

we normally will indent the body of the switch statement one tabstop less
than this.

> +	}
> +
> +
> +	/* read/write commands seem to require this */
> +	if (data) {
> +		if((cmd->error = sdricoh_busy(host)))
> +			ERR("sdricoh_request: unable to prepare transfer %x\n",
> +				cmd->error);
> +		sdricoh_writel(host, R208_DATAIO, 0);
> +	}
> +
> +
> +	cmd->error = sdricoh_mmc_cmd(host, cmd->opcode, cmd->arg);
> +
> +	/* read response buffer */
> +	if (cmd->flags & MMC_RSP_PRESENT) {
> +		if (cmd->flags & MMC_RSP_136) {
> +			/* CRC is stripped so we need to do some shifting. */
> +			for (i = 0; i < 4; i++) {
> +				cmd->resp[i] =
> +				    sdricoh_readl(host,
> +						  R20C_RESP + (3 - i) * 4) << 8;
> +				if (i != 3)
> +					cmd->resp[i] |=
> +					    sdricoh_readb(host, R20C_RESP +
> +							  (3 - i) *4 - 1);
> +			}
> +			DBG("resp[0]=0x%x\n", cmd->resp[0]);
> +			DBG("resp[1]=0x%x\n", cmd->resp[1]);
> +			DBG("resp[2]=0x%x\n", cmd->resp[2]);
> +			DBG("resp[2]=0x%x\n", cmd->resp[3]);
> +		} else {
> +			cmd->resp[0] = sdricoh_readl(host, R20C_RESP);
> +			DBG("resp[0]=0x%x\n", cmd->resp[0]);
> +		}
> +	}
> +
> +	/* yet another workaround */
> +	/* without the extra command SD cards do not work at all */
> +	if (cmd->opcode == MMC_SELECT_CARD) {
> +		if(host->mode != MODE_MMC){
> +			sdricoh_mmc_cmd(host, MMC_APP_CMD, cmd->arg);
> +			sdricoh_mmc_cmd(host, 0x46, 0x02);
> +		}else{
> +			sdricoh_writel(host, R228_POWER, 0xc0e0);
> +			sdricoh_writel(host, R224_MODE, 0x2000301);
> +		}
> +	}
> +
> +	/* transfer data */
> +	if (data && cmd->error == 0) {
> +		DBG("transfer: blksz %i blocks %i sg_len %i sg length %i\n",
> +                    data->blksz, data->blocks, data->sg_len, data->sg->length);
> +
> +		/* enter data reading mode */
> +		sdricoh_writel(host, R21C_STATUS, 0x837f031e);
> +		for (i = 0; i < data->blocks; i++) {
> +			unsigned int *buf;
> +			struct page* page;
> +			size_t xfered;
> +			page = sg_page(data->sg);
> +
> +        		buf = kmap(page) + data->sg->offset + (512 * i);
> +			xfered =
> +			  sdricoh_blockio(host,data->flags & MMC_DATA_READ,buf);
> +			kunmap(page);

hm.  I don't really know how the kernel gets down into here, but I wonder
if this driver (and, I bet, lots of similar ones) should be doing
flush_dcache_page() after modifying the page.  If this page can be file
pagecache or user memory then "yes".  Unless it's done elsewhere for us.

> +			if(!xfered){
> +				ERR("sdricoh_request: block transfer failed\n");
> +				cmd->error = -EINVAL;
> +				break;
> +			}else
> +				data->bytes_xfered += xfered;
> +		}
> +
> +		sdricoh_writel(host, R208_DATAIO, 1);
> +
> +		if(sdricoh_query_status(host,STATUS_TRANSFER_FINISHED,
> +					TRANSFER_TIMEOUT)){
> +			ERR("sdricoh_request: transfer end error\n");
> +			cmd->error = -EINVAL;
> +		}
> +
> +		if(!cmd->error && (cmd->error = sdricoh_busy(host)))
> +			ERR("sdricoh_request: transfer not finished %x\n",
> +				cmd->error);
> +
> +	}
> +
> +	mmc_request_done(mmc, mrq);
> +	DBG("=============================\n");
> +}
>
> ...
>
> +/* initialize the control and register it to the mmc framework */
> +static int sdricoh_init_mmc(struct pci_dev *pci_dev,
> +			    struct pcmcia_device *pcmcia_dev)
> +{
> +	int result = 0;
> +	void __iomem *iobase = NULL;
> +	struct mmc_host *mmc = NULL;
> +	struct sdricoh_host *host = NULL;
> +	/* map iomem */
> +	if (pci_resource_len(pci_dev, SDRICOH_PCI_REGION) !=
> +	    SDRICOH_PCI_REGION_SIZE) {
> +		DBG("unexpected pci resource len\n");
> +		return -ENODEV;
> +	}
> +	iobase =
> +	    pci_iomap(pci_dev, SDRICOH_PCI_REGION, SDRICOH_PCI_REGION_SIZE);
> +	if (!iobase) {
> +		ERR("unable to map iobase\n");
> +		return -ENODEV;
> +	}
> +	/* check version? */
> +	if (readl(iobase + R104_VERSION) != 0x4000) {
> +		DBG("no supported mmc controller found\n");
> +		result = -ENODEV;
> +		goto err;
> +	}
> +	/* allocate privdata */
> +	mmc = pcmcia_dev->priv =
> +	    mmc_alloc_host(sizeof(struct sdricoh_host), &pcmcia_dev->dev);
> +	if (!mmc) {
> +		ERR("mmc_alloc_host failed\n");
> +		result = -ENOMEM;
> +		goto err;
> +	}
> +	host = mmc_priv(mmc);
> +
> +	host->iobase = iobase;
> +
> +	mmc->ops = &sdricoh_ops;
> +
> +	/* FIXME: frequency and voltage handling is done by the controller
> +	 */
> +	mmc->f_min = 450000;
> +	mmc->f_max = 24000000;
> +	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
> +
> +	mmc->max_seg_size = 1024 * 512;
> +
> +	/* reset the controler */
> +	if (sdricoh_reset(host)) {
> +		DBG("could not reset\n");
> +		result = -EIO;
> +		goto err;

forgot to free pcmcia_dev->priv here?

> +	}
> +
> +	result = mmc_add_host(mmc);
> +
> +	if (!result) {
> +		DBG("mmc host registered\n");
> +		return 0;
> +	}
> +
> +      err:
> +	if (iobase)
> +		iounmap(iobase);
> +	if (mmc)
> +		mmc_free_host(mmc);
> +
> +	return result;
> +}
>
> ...
>
> +static void sdricoh_pcmcia_detach(struct pcmcia_device *link)
> +{
> +	struct mmc_host *mmc = link->priv;
> +
> +	DBG("detach\n");
> +
> +	flush_scheduled_work();

what work are we flushing here?

> +	/* remove mmc host */
> +	if (mmc) {
> +		struct sdricoh_host *host = mmc_priv(mmc);
> +		mmc_remove_host(mmc);
> +		pci_iounmap(host->pci_dev, host->iobase);
> +		pci_dev_put(host->pci_dev);
> +		mmc_free_host(mmc);
> +	}
> +	pcmcia_disable_device(link);
> +
> +}
>
> ...
>
> --- drivers/mmc/host.org/Kconfig	2008-04-27 14:35:31.000000000 +0200
> +++ drivers/mmc/host/Kconfig	2008-04-27 15:15:29.000000000 +0200
> @@ -130,3 +130,13 @@
>  
>  	  If unsure, or if your system has no SPI master driver, say N.
>  
> +config MMC_SDRICOH_CS
> +	tristate "MMC/SD driver for Ricoh Bay1Controllers (EXPERIMENTAL)"
> +	depends on EXPERIMENTAL && MMC && PCI && PCMCIA && YENTA

Is the dependency on YENTA correct?

> +	help
> +	  Say Y here if your Notebook reports a Ricoh Bay1Controller PCMCIA
> +	  card whenever you insert a MMC or SD card into the card slot.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called sdricoh_cs.
> +
>
> ...
>
