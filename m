Return-Path: <linux-kernel-owner+w=401wt.eu-S1765760AbZDJTl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765760AbZDJTl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 15:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbZDJTlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 15:41:47 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:38841 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbZDJTlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 15:41:47 -0400
Date: Fri, 10 Apr 2009 21:41:43 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Purushotam Kumar <purushotam@ti.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
       linux-kernel@vger.kernel.org, purushotam@ti.com
Subject: Re: [PATCH 1/1] DaVinci: MMC: V4: MMC/SD controller driver for
 DaVinci family.
Message-ID: <20090410214143.4aa4045e@mjolnir.ossman.eu>
In-Reply-To: <1238666196-29979-1-git-send-email-purushotam@ti.com>
References: <1238666196-29979-1-git-send-email-purushotam@ti.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 Apr 2009 15:26:36 +0530
Purushotam Kumar <purushotam@ti.com> wrote:

>  arch/arm/mach-davinci/include/mach/mmc.h |   25 +
>  drivers/mmc/host/Kconfig                 |    8 +
>  drivers/mmc/host/Makefile                |    1 +
>  drivers/mmc/host/davinci_mmc.c           | 1264 ++++++++++++++++++++++++++++++
>  4 files changed, 1298 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-davinci/include/mach/mmc.h
>  create mode 100644 drivers/mmc/host/davinci_mmc.c

I want a MAINTAINERS entry for this driver as well.

> +	/*
> +	 * Before non-DMA WRITE commands the controller needs priming:
> +	 * FIFO should be populated with 32 bytes i.e. whatever is the FIFO size
> +	 */
> +	if (!host->do_dma && (host->data_dir == DAVINCI_MMC_DATADIR_WRITE) &&
> +		((cmd->opcode == MMC_WRITE_BLOCK) ||
> +		(cmd->opcode == MMC_WRITE_MULTIPLE_BLOCK)))
> +		davinci_fifo_data_trans(host, DAVINCI_MMC_FIFO_SIZE_BYTE);

I'm still not following the requirements here. Why would the hardware
only need to have the FIFO primed for those two commands and not every
kind of write?

> +
> +	/* We know sg_len and ccnt will never be out of range because
> +	 * we told the mmc layer which in turn tells the block layer
> +	 * to ensure that it only hands us one scatterlist segment
> +	 * per EDMA PARAM entry.  Update the PARAM
> +	 * entries needed for each segment of this scatterlist.
> +	 */
> +	for (slot = channel, link = 0, sg = data->sg, sg_len = host->sg_len;
> +			sg_len-- != 0 && bytes_left;
> +			sg = sg_next(sg), slot = host->links[link++]) {

You might be able to make this cleaner using the for_each_sg helper.

> +static unsigned int calculate_freq_for_card(struct mmc_davinci_host *host,
> +	unsigned int mmc_req_freq)
> +{
> +	unsigned int mmc_freq = 0, cpu_arm_clk = 0, mmc_push_pull = 0;
> +
> +	cpu_arm_clk = host->mmc_input_clk;
> +	if (mmc_req_freq && cpu_arm_clk > (2 * mmc_req_freq))
> +		mmc_push_pull = ((unsigned int)cpu_arm_clk
> +				/ (2 * mmc_req_freq)) - 1;
> +	else
> +		mmc_push_pull = 0;
> +
> +	mmc_freq = (unsigned int)cpu_arm_clk / (2 * (mmc_push_pull + 1));
> +
> +	if (mmc_freq > mmc_req_freq)
> +		mmc_push_pull = mmc_push_pull + 1;

The naming of the divider is a bit confusing here. :)

> +
> +	/* Convert ns to clock cycles */
> +	if (mmc_req_freq < 400000)
> +		ns_in_one_cycle = 1000000 / ((cpu_arm_clk
> +					/ (2 * (mmc_push_pull + 1)))/1000);
> +	else
> +		ns_in_one_cycle = 1000000 / ((cpu_arm_clk
> +					/ (2 * (mmc_push_pull + 1)))/1000000);
> +

The clock frequency is per host, so store this in the mmc_davinci_host
structure.

> +	if (ios->bus_mode == MMC_BUSMODE_OPENDRAIN) {
> +		u32 temp;
> +
> +		/* Ignoring the init clock value passed for fixing the inter
> +		 * operability with different cards.
> +		 */
> +		open_drain_freq = ((unsigned int)cpu_arm_clk
> +				/ (2 * MMCSD_INIT_CLOCK)) - 1;
> +
> +		if (open_drain_freq > 0xFF)
> +			open_drain_freq = 0xFF;
> +
> +		temp = readl(host->base + DAVINCI_MMCCLK) & ~MMCCLK_CLKRT_MASK;
> +		temp |= open_drain_freq;
> +		writel(temp, host->base + DAVINCI_MMCCLK);
> +
> +		/* Convert ns to clock cycles */
> +		ns_in_one_cycle = (1000000) / (MMCSD_INIT_CLOCK/1000);

I'm still not sure why you need this. Open drain mode is always used at
a low frequency anyway.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
  TigerVNC, core developer          http://www.tigervnc.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
