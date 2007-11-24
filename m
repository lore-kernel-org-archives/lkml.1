Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbXKXRAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbXKXRAg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 12:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXKXRA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 12:00:28 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:57246 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbXKXRA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 12:00:27 -0500
Date: Sat, 24 Nov 2007 18:00:23 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org, Shannon Nelson <shannon.nelson@intel.com>,
       Dan Williams <dan.j.williams@intel.com>,
       David Brownell <david-b@pacbell.net>, kernel@avr32linux.org,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [RFC 4/4] Atmel MCI: Driver for Atmel on-chip MMC controllers
Message-ID: <20071124180023.20c831b8@poseidon.drzeus.cx>
In-Reply-To: <1195820413-2179-5-git-send-email-hskinnemoen@atmel.com>
References: <1195820413-2179-1-git-send-email-hskinnemoen@atmel.com>
	<1195820413-2179-2-git-send-email-hskinnemoen@atmel.com>
	<1195820413-2179-3-git-send-email-hskinnemoen@atmel.com>
	<1195820413-2179-4-git-send-email-hskinnemoen@atmel.com>
	<1195820413-2179-5-git-send-email-hskinnemoen@atmel.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2007 13:20:13 +0100
Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> This is a driver for the MMC controller on the AP7000 chips from
> Atmel. It should in theory work on AT91 systems too with some
> tweaking, but since the DMA interface is quite different, it's not
> entirely clear if it's worth it.
> 
> This driver has been around for a while in BSPs and kernel sources
> provided by Atmel, but this particular version uses the generic DMA
> Engine framework (with the slave extensions) instead of an
> avr32-only DMA controller framework.
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>

Why didn't I get a cc? Don't you love me any more? :'(


> ---
>  arch/avr32/boards/atngw100/setup.c      |    6 +
>  arch/avr32/boards/atstk1000/atstk1002.c |    3 +
>  arch/avr32/mach-at32ap/at32ap7000.c     |   31 +-
>  drivers/mmc/host/Kconfig                |   10 +
>  drivers/mmc/host/Makefile               |    1 +
>  drivers/mmc/host/atmel-mci.c            | 1170 +++++++++++++++++++++++++++++++
>  drivers/mmc/host/atmel-mci.h            |  192 +++++
>  include/asm-avr32/arch-at32ap/board.h   |   10 +-
>  8 files changed, 1417 insertions(+), 6 deletions(-)
>  create mode 100644 drivers/mmc/host/atmel-mci.c
>  create mode 100644 drivers/mmc/host/atmel-mci.h
> 

Could you add a note to MAINTAINERS as well?

> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index 5fef678..687cf8b 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -91,6 +91,16 @@ config MMC_AT91
>  
>  	  If unsure, say N.
>  
> +config MMC_ATMELMCI
> +	tristate "Atmel Multimedia Card Interface support"
> +	depends on AVR32 && DMA_ENGINE
> +	help
> +	  This selects the Atmel Multimedia Card Interface. If you have
> +	  a AT91 (ARM) or AT32 (AVR32) platform with a Multimedia Card
> +	  slot, say Y or M here.
> +
> +	  If unsure, say N.
> +
>  config MMC_IMX
>  	tristate "Motorola i.MX Multimedia Card Interface support"
>  	depends on ARCH_IMX

Now this gets a bit confusing as we'll have two drivers for AT91. Any status report on merging these?

I can accept having two drivers (for a while at least), but the Kconfig help texts should explain the sordid details.

> +
> +/* Those printks take an awful lot of time... */
> +#ifndef DEBUG
> +static unsigned int fmax = 15000000U;
> +#else
> +static unsigned int fmax = 1000000U;
> +#endif
> +module_param(fmax, uint, 0444);
> +MODULE_PARM_DESC(fmax, "Max frequency in Hz of the MMC bus clock");
> +

Why is this needed and is it perhaps something that can be moved to the MMC core?

> +
> +static int req_dbg_open(struct inode *inode, struct file *file)
> +{

This also looks like something that can be made general.

> +
> +	if (mmc->ios.bus_mode == MMC_BUSMODE_OPENDRAIN)
> +		cmdr |= MCI_BIT(OPDCMD);
> +
> +	dev_dbg(&mmc->class_dev,
> +		"cmd: op %02x arg %08x flags %08x, cmdflags %08lx\n",
> +		cmd->opcode, cmd->arg, cmd->flags, (unsigned long)cmdr);
> +

The debug output in the core should make this redundant.


> +
> +static void atmci_request(struct mmc_host *mmc, struct mmc_request *mrq)
> +{

I seem to recall that atmci couldn't currently handle transfers that weren't a multiple of four. Could you please add a check for this and fail the request with -EINVAL when that happens?

> +
> +static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
> +{
> +	struct atmel_mci	*host = mmc_priv(mmc);
> +	u32			mr;
> +
> +	if (ios->clock) {
> +		u32 clkdiv;
> +
> +		/* Set clock rate */
> +		clkdiv = host->bus_hz / (2 * ios->clock) - 1;
> +		if (clkdiv > 255) {
> +			dev_warn(&mmc->class_dev,
> +				"clock %u too slow; using %lu\n",
> +				ios->clock, host->bus_hz / (2 * 256));
> +			clkdiv = 255;
> +		}
> +
> +		mr = mci_readl(host, MR);
> +		mr = MCI_BFINS(CLKDIV, clkdiv, mr)
> +			| MCI_BIT(WRPROOF) | MCI_BIT(RDPROOF);
> +		mci_writel(host, MR, mr);
> +
> +		/* Enable the MCI controller */
> +		mci_writel(host, CR, MCI_BIT(MCIEN));
> +	} else {
> +		/* Disable the MCI controller */
> +		mci_writel(host, CR, MCI_BIT(MCIDIS));
> +	}
> +

I hope "disable" here doesn't power down the card, as that would be incorrect.

> +
> +		if (status & MCI_BIT(DCRCE)) {
> +			dev_dbg(&mmc->class_dev, "data CRC error\n");
> +			data->error = -EILSEQ;
> +		} else if (status & MCI_BIT(DTOE)) {
> +			dev_dbg(&mmc->class_dev, "data timeout error\n");
> +			data->error = -ETIMEDOUT;
> +		} else {
> +			dev_dbg(&mmc->class_dev, "data FIFO error\n");
> +			data->error = -EIO;
> +		}
> +		dev_dbg(&mmc->class_dev, "bytes xfered: %u\n",
> +				data->bytes_xfered);
> +

The debug output here is already provided by the MMC core.

> +
> +static int __exit atmci_remove(struct platform_device *pdev)
> +{
> +	struct atmel_mci *host = platform_get_drvdata(pdev);
> +
> +	platform_set_drvdata(pdev, NULL);
> +
> +	if (host) {
> +		atmci_cleanup_debugfs(host);
> +
> +		if (host->detect_pin >= 0) {
> +			free_irq(gpio_to_irq(host->detect_pin), host->mmc);
> +			cancel_delayed_work(&host->mmc->detect);

Not for driver poking. Hands off! :)

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
