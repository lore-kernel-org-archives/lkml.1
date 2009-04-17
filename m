Return-Path: <linux-kernel-owner+w=401wt.eu-S1759035AbZDQLEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035AbZDQLEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 07:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbZDQLEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 07:04:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42264 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbZDQLEj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 07:04:39 -0400
From: "Kumar, Purushotam" <purushotam@ti.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 17 Apr 2009 16:34:22 +0530
Subject: RE: [PATCH 1/1] DaVinci: MMC: V4: MMC/SD controller driver for
 DaVinci family.
Thread-Topic: [PATCH 1/1] DaVinci: MMC: V4: MMC/SD controller driver for
 DaVinci family.
Thread-Index: Acm6FGp27DwjPYZQTRSk9sAB1OmS4AFMzlGw
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301CCA0190F@dbde02.ent.ti.com>
References: <1238666196-29979-1-git-send-email-purushotam@ti.com>
 <20090410214143.4aa4045e@mjolnir.ossman.eu>
In-Reply-To: <20090410214143.4aa4045e@mjolnir.ossman.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  drivers/mmc/host/davinci_mmc.c           | 1264 ++++++++++++++++++++++++++++++
> >  4 files changed, 1298 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/arm/mach-davinci/include/mach/mmc.h
> >  create mode 100644 drivers/mmc/host/davinci_mmc.c
> 
> I want a MAINTAINERS entry for this driver as well.

I will add this and re-submit the patch.  I will provide e-mail id in the MODULE_AUTHOR.

> 
> > +	/*
> > +	 * Before non-DMA WRITE commands the controller needs priming:
> > +	 * FIFO should be populated with 32 bytes i.e. whatever is the FIFO size
> > +	 */
> > +	if (!host->do_dma && (host->data_dir == DAVINCI_MMC_DATADIR_WRITE) &&
> > +		((cmd->opcode == MMC_WRITE_BLOCK) ||
> > +		(cmd->opcode == MMC_WRITE_MULTIPLE_BLOCK)))
> > +		davinci_fifo_data_trans(host, DAVINCI_MMC_FIFO_SIZE_BYTE);
> 
> I'm still not following the requirements here. Why would the hardware
> only need to have the FIFO primed for those two commands and not every
> kind of write?

This required by SD controller as suggested by IP designer. Please look at SD controller spec at http://www.ti.com/litv/pdf/sprue30d . Please check section 3.2/3.6 and point no 11/10 in the controller spec.  It does not talk about priming by 32 bytes for any other command. This restriction is from SD controller.
> 
> > +
> > +	/* We know sg_len and ccnt will never be out of range because
> > +	 * we told the mmc layer which in turn tells the block layer
> > +	 * to ensure that it only hands us one scatterlist segment
> > +	 * per EDMA PARAM entry.  Update the PARAM
> > +	 * entries needed for each segment of this scatterlist.
> > +	 */
> > +	for (slot = channel, link = 0, sg = data->sg, sg_len = host->sg_len;
> > +			sg_len-- != 0 && bytes_left;
> > +			sg = sg_next(sg), slot = host->links[link++]) {
> 
> You might be able to make this cleaner using the for_each_sg helper.
That particular loop can't use for_each_sg() since it's also iterating the EDMA slots:  channel, then links[]
> 
> > +static unsigned int calculate_freq_for_card(struct mmc_davinci_host *host,
> > +	unsigned int mmc_req_freq)
> > +{
> > +	unsigned int mmc_freq = 0, cpu_arm_clk = 0, mmc_push_pull = 0;
> > +
> > +	cpu_arm_clk = host->mmc_input_clk;
> > +	if (mmc_req_freq && cpu_arm_clk > (2 * mmc_req_freq))
> > +		mmc_push_pull = ((unsigned int)cpu_arm_clk
> > +				/ (2 * mmc_req_freq)) - 1;
> > +	else
> > +		mmc_push_pull = 0;
> > +
> > +	mmc_freq = (unsigned int)cpu_arm_clk / (2 * (mmc_push_pull + 1));
> > +
> > +	if (mmc_freq > mmc_req_freq)
> > +		mmc_push_pull = mmc_push_pull + 1;
> 
> The naming of the divider is a bit confusing here. :)

I am thinking to change " mmc_push_pull" to " mmc_push_pull_divider". Please suggest other appropriate name.

> 
> > +
> > +	/* Convert ns to clock cycles */
> > +	if (mmc_req_freq < 400000)
> > +		ns_in_one_cycle = 1000000 / ((cpu_arm_clk
> > +					/ (2 * (mmc_push_pull + 1)))/1000);
> > +	else
> > +		ns_in_one_cycle = 1000000 / ((cpu_arm_clk
> > +					/ (2 * (mmc_push_pull + 1)))/1000000);
> > +
> 
> The clock frequency is per host, so store this in the mmc_davinci_host
> structure.

You are correct and I will implement and re-submit the patch.
> 
> > +	if (ios->bus_mode == MMC_BUSMODE_OPENDRAIN) {
> > +		u32 temp;
> > +
> > +		/* Ignoring the init clock value passed for fixing the inter
> > +		 * operability with different cards.
> > +		 */
> > +		open_drain_freq = ((unsigned int)cpu_arm_clk
> > +				/ (2 * MMCSD_INIT_CLOCK)) - 1;
> > +
> > +		if (open_drain_freq > 0xFF)
> > +			open_drain_freq = 0xFF;
> > +
> > +		temp = readl(host->base + DAVINCI_MMCCLK) & ~MMCCLK_CLKRT_MASK;
> > +		temp |= open_drain_freq;
> > +		writel(temp, host->base + DAVINCI_MMCCLK);
> > +
> > +		/* Convert ns to clock cycles */
> > +		ns_in_one_cycle = (1000000) / (MMCSD_INIT_CLOCK/1000);
> 
> I'm still not sure why you need this. Open drain mode is always used at
> a low frequency anyway.


If my understanding is correct you are suggesting that at lower freq. there is no need to update the timeout parameter and can use the default value of ns_in_one_cycle.

The mmc_davinci_prepare_data() may  be called even during open drain frequency mode and here we are calculating the timeout value and updating the timeout reg. So ns_in_one_cycle should hold a proper value once we call mmc_davinci_prepare_data(). I think there is no harm in having this calculation here.

Regards,
Purushotam
