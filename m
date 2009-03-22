Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbZCVPMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbZCVPMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 11:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbZCVPM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 11:12:26 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:58620 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704AbZCVPMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 11:12:25 -0400
Date: Sun, 22 Mar 2009 16:12:20 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Purushotam Kumar <purushotam@ti.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
       linux-kernel@vger.kernel.org, purushotam@ti.com
Subject: Re: [PATCH 1/1] DaVinci: MMC: MMC/SD controller driver for
 DaVinci/DM6446.
Message-ID: <20090322161220.15faeb00@mjolnir.ossman.eu>
In-Reply-To: <1237214559-31345-1-git-send-email-purushotam@ti.com>
References: <1237214559-31345-1-git-send-email-purushotam@ti.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009 20:12:39 +0530
Purushotam Kumar <purushotam@ti.com> wrote:

> +
> +/* PIO only */
> +static void mmc_davinci_sg_to_buf(struct mmc_davinci_host *host)
> +{
> +	struct scatterlist *sg;
> +
> +	sg = host->data->sg + host->sg_idx;

You cannot do this to scatterlists any more. You need to use the
iterator functions to walk the list.

> +	host->buffer_bytes_left = sg_dma_len(sg);
> +	host->buffer = sg_virt(sg);
> +	if (host->buffer_bytes_left > host->bytes_left)
> +		host->buffer_bytes_left = host->bytes_left;
> +}

This is not HIGHMEM compatible. Probably not any issue right now, but
might be in the future.

> +	/* Setting initialize clock */
> +	if (cmd->opcode == 0)
> +		cmd_reg |= MMCCMD_INITCK;

This is not good. What does this do and is it really needed?

> +	/*
> +	 * Before non-DMA WRITE commands the controller needs priming:
> +	 * FIFO should be populated with 32 bytes
> +	 */
> +	if (!host->do_dma && (host->data_dir == DAVINCI_MMC_DATADIR_WRITE))
> +		davinci_fifo_data_trans(host, 32);

What if the transfer is smaller than 32 bytes?

> +	/* We know sg_len and ccnt will never be out of range because
> +	 * we told the block layer to ensure that it only hands us one

mmc layer really

> +	 * scatterlist segment per EDMA PARAM entry.  Update the PARAM
> +	 * entries needed for each segment of this scatterlist.
> +	 */
> +	for (slot = channel, link = 0, sg = data->sg, sg_len = host->sg_len;
> +			sg_len-- != 0 && bytes_left;
> +			sg++, slot = host->links[link++]) {

Incorrect way of traversing the sg list. Use sg_next().

> +	/* Convert ns to clock cycles by assuming 20MHz frequency
> +	 * 1 cycle at 20MHz = 500 ns
> +	 */
> +	timeout = data->timeout_clks + data->timeout_ns / 500;
> +	if (timeout > 0xffff)
> +		timeout = 0xffff;

So this might time out too early if we run at a lower clock frequency?

> +	if (ios->bus_mode == MMC_BUSMODE_OPENDRAIN) {
> +		u32 temp;
> +		open_drain_freq = ((unsigned int)cpu_arm_clk
> +				/ (2 * MMCSD_INIT_CLOCK)) - 1;
> +		temp = readl(host->base + DAVINCI_MMCCLK) & ~0xFF;
> +		temp |= open_drain_freq;
> +		writel(temp, host->base + DAVINCI_MMCCLK);

Why are you ignoring the given frequency if in open drain mode?

> +static void
> +davinci_abort_data(struct mmc_davinci_host *host, struct mmc_data *data)
> +{
> +	u32 temp;
> +
> +	/* record how much data we transferred */
> +	temp = readl(host->base + DAVINCI_MMCNBLC);
> +	data->bytes_xfered += (data->blocks - temp) * data->blksz;
> +

Does MMCNBLC record how many blocks you've sent, or how many blocks
that the card has acked? If it's not the latter, then you cannot use it
for bytes_xfered.

> +
> +	if (qstatus & MMCST0_DATDNE) {
> +		/* All blocks sent/received, and CRC checks passed */
> +		if (data != NULL) {
> +			if ((host->do_dma == 0) && (host->bytes_left > 0)) {
> +				/* if datasize < rw_threshold
> +				 * no RX ints are generated
> +				 */
> +				davinci_fifo_data_trans(host, host->bytes_left);
> +			}
> +			end_transfer = 1;
> +			data->bytes_xfered += data->blocks * data->blksz;

Why += and not =?

> +
> +	if (qstatus & MMCST0_CRCRS) {
> +		/* Command CRC error */
> +		dev_dbg(mmc_dev(host->mmc), "Command CRC error\n");
> +		if (host->cmd) {
> +			/* Ignore CMD CRC errors during high speed operation */
> +			if (host->mmc->ios.clock <= 25000000)
> +				host->cmd->error = -EILSEQ;
> +			end_command = 1;
> +		}
> +	}

?!!

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
