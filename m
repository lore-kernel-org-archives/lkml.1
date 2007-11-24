Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbXKXSST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbXKXSST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 13:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbXKXSSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 13:18:11 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:60506 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753090AbXKXSSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 13:18:09 -0500
Date: Sat, 24 Nov 2007 19:16:48 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, Shannon Nelson <shannon.nelson@intel.com>,
       Dan Williams <dan.j.williams@intel.com>,
       David Brownell <david-b@pacbell.net>, kernel@avr32linux.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC 4/4] Atmel MCI: Driver for Atmel on-chip MMC controllers
Message-ID: <20071124191648.2c2d56c7@siona>
In-Reply-To: <20071124180023.20c831b8@poseidon.drzeus.cx>
References: <1195820413-2179-1-git-send-email-hskinnemoen@atmel.com>
	<1195820413-2179-2-git-send-email-hskinnemoen@atmel.com>
	<1195820413-2179-3-git-send-email-hskinnemoen@atmel.com>
	<1195820413-2179-4-git-send-email-hskinnemoen@atmel.com>
	<1195820413-2179-5-git-send-email-hskinnemoen@atmel.com>
	<20071124180023.20c831b8@poseidon.drzeus.cx>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Nov 2007 18:00:23 +0100
Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> On Fri, 23 Nov 2007 13:20:13 +0100
> Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> 
> > This is a driver for the MMC controller on the AP7000 chips from
> > Atmel. It should in theory work on AT91 systems too with some
> > tweaking, but since the DMA interface is quite different, it's not
> > entirely clear if it's worth it.
> > 
> > This driver has been around for a while in BSPs and kernel sources
> > provided by Atmel, but this particular version uses the generic DMA
> > Engine framework (with the slave extensions) instead of an
> > avr32-only DMA controller framework.
> > 
> > Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> 
> Why didn't I get a cc? Don't you love me any more? :'(

Sorry, I didn't really mean to submit it for inclusion yet, as I
explained in the first mail in the series. I probably should have left
out the signoff to make this clearer.

Thanks for the feedback anyway.

> Could you add a note to MAINTAINERS as well?

Yes, I intend to do that in the final version.

> > diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> > index 5fef678..687cf8b 100644
> > --- a/drivers/mmc/host/Kconfig
> > +++ b/drivers/mmc/host/Kconfig
> > @@ -91,6 +91,16 @@ config MMC_AT91
> >  
> >  	  If unsure, say N.
> >  
> > +config MMC_ATMELMCI
> > +	tristate "Atmel Multimedia Card Interface support"
> > +	depends on AVR32 && DMA_ENGINE
> > +	help
> > +	  This selects the Atmel Multimedia Card Interface. If you
> > have
> > +	  a AT91 (ARM) or AT32 (AVR32) platform with a Multimedia
> > Card
> > +	  slot, say Y or M here.
> > +
> > +	  If unsure, say N.
> > +
> >  config MMC_IMX
> >  	tristate "Motorola i.MX Multimedia Card Interface support"
> >  	depends on ARCH_IMX
> 
> Now this gets a bit confusing as we'll have two drivers for AT91. Any
> status report on merging these?

I haven't really started working on that I'm afraid. I imagine the
parts dealing with data transfer will have to be completely separate
due to the differences in the DMA interface. Probably the interrupt
handler as well, unless we're willing to live with a few #ifdefs in it.

> I can accept having two drivers (for a while at least), but the
> Kconfig help texts should explain the sordid details.

Yeah, the help text is indeed confusing. I'll update it.

> > +
> > +/* Those printks take an awful lot of time... */
> > +#ifndef DEBUG
> > +static unsigned int fmax = 15000000U;
> > +#else
> > +static unsigned int fmax = 1000000U;
> > +#endif
> > +module_param(fmax, uint, 0444);
> > +MODULE_PARM_DESC(fmax, "Max frequency in Hz of the MMC bus clock");
> > +
> 
> Why is this needed and is it perhaps something that can be moved to
> the MMC core?

We used to have lots of problems with overruns and underruns and those
parameters were useful to limit the transfer rate. Now that the RDPROOF
and WRPROOF bits seem to have taken care of these problems for good, I
guess we can remove this parameter.

> > +
> > +static int req_dbg_open(struct inode *inode, struct file *file)
> > +{
> 
> This also looks like something that can be made general.

Yeah, could be. I'll look into it.

> > +
> > +	if (mmc->ios.bus_mode == MMC_BUSMODE_OPENDRAIN)
> > +		cmdr |= MCI_BIT(OPDCMD);
> > +
> > +	dev_dbg(&mmc->class_dev,
> > +		"cmd: op %02x arg %08x flags %08x, cmdflags
> > %08lx\n",
> > +		cmd->opcode, cmd->arg, cmd->flags, (unsigned
> > long)cmdr); +
> 
> The debug output in the core should make this redundant.

Yes, most of it is redundant, but the hardware register dump might
still make sense, but it should probably be turned into a dev_vdbg().

> > +
> > +static void atmci_request(struct mmc_host *mmc, struct mmc_request
> > *mrq) +{
> 
> I seem to recall that atmci couldn't currently handle transfers that
> weren't a multiple of four. Could you please add a check for this and
> fail the request with -EINVAL when that happens?

Yeah, although I want to fix that before submitting the final version.
The hardware has a special "byte mode" which will be slow, but it
should work.

> > +		/* Enable the MCI controller */
> > +		mci_writel(host, CR, MCI_BIT(MCIEN));
> > +	} else {
> > +		/* Disable the MCI controller */
> > +		mci_writel(host, CR, MCI_BIT(MCIDIS));
> > +	}
> > +
> 
> I hope "disable" here doesn't power down the card, as that would be
> incorrect.

No, it just stops the clock. I suppose we could use clk_disable()
instead of resetting the controller, but I don't think there's any
controller state we really care about at this point anyway.

> > +		dev_dbg(&mmc->class_dev, "bytes xfered: %u\n",
> > +				data->bytes_xfered);
> > +
> 
> The debug output here is already provided by the MMC core.

Indeed. I'll remove it.

> > +
> > +static int __exit atmci_remove(struct platform_device *pdev)
> > +{
> > +	struct atmel_mci *host = platform_get_drvdata(pdev);
> > +
> > +	platform_set_drvdata(pdev, NULL);
> > +
> > +	if (host) {
> > +		atmci_cleanup_debugfs(host);
> > +
> > +		if (host->detect_pin >= 0) {
> > +			free_irq(gpio_to_irq(host->detect_pin),
> > host->mmc);
> > +			cancel_delayed_work(&host->mmc->detect);
> 
> Not for driver poking. Hands off! :)

Ah. I think this solved some kind of oops-on-card-removal thing at some
point, but I'll try to remove it and see what happens.

Hmm...no, that can't be the case. I have to admit I don't quite
remember why we put that there.

Haavard
