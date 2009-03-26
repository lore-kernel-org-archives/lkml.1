Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZCZI7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZCZI7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 04:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbZCZI7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 04:59:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52481 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbZCZI7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 04:59:11 -0400
From: "Kumar, Purushotam" <purushotam@ti.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 26 Mar 2009 14:28:53 +0530
Subject: RE: [PATCH 1/1] DaVinci: MMC: MMC/SD controller driver for
 DaVinci/DM6446.
Thread-Topic: [PATCH 1/1] DaVinci: MMC: MMC/SD controller driver for
 DaVinci/DM6446.
Thread-Index: AcmrAKQBXE8Ny9rfTpSmFrPlDX4hTgC62mKw
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301CC4FE08B@dbde02.ent.ti.com>
References: <1237214559-31345-1-git-send-email-purushotam@ti.com>
 <20090322161220.15faeb00@mjolnir.ossman.eu>
In-Reply-To: <20090322161220.15faeb00@mjolnir.ossman.eu>
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

 
> On Mon, 16 Mar 2009 20:12:39 +0530
> Purushotam Kumar <purushotam@ti.com> wrote:
> > +/* PIO only */
> > +static void mmc_davinci_sg_to_buf(struct mmc_davinci_host *host)
> > +{
> > +	struct scatterlist *sg;
> > +
> > +	sg = host->data->sg + host->sg_idx;
> You cannot do this to scatterlists any more. You need to use the
> iterator functions to walk the list.

I will incorporate this comment.

 
> > +	host->buffer_bytes_left = sg_dma_len(sg);
> > +	host->buffer = sg_virt(sg);
> > +	if (host->buffer_bytes_left > host->bytes_left)
> > +		host->buffer_bytes_left = host->bytes_left;
> This is not HIGHMEM compatible. Probably not any issue right now, but
> might be in the future.

As you have suggested that it is not an issue at this point and so I will look into this latter if needed.

> > +	/* Setting initialize clock */
> > +	if (cmd->opcode == 0)
> > +		cmd_reg |= MMCCMD_INITCK;
> This is not good. What does this do and is it really needed?
I think you are right and it is needed. I will check it and do needful.

> > +	 * Before non-DMA WRITE commands the controller needs priming:
> > +	 * FIFO should be populated with 32 bytes
> > +	 */
> > +	if (!host->do_dma && (host->data_dir == DAVINCI_MMC_DATADIR_WRITE))
> > +		davinci_fifo_data_trans(host, 32);
> What if the transfer is smaller than 32 bytes?
This is required only for CMD24 and CMD25 on this controller and I will add that check in the code for CMD24 and CMD25. It is equal to depth of FIFO which defined by rw_threshold in the code. Now, transfer on CMD24 and CMD25 will also be multiple of 32.

> > +	/* We know sg_len and ccnt will never be out of range because
> > +	 * we told the block layer to ensure that it only hands us one
> 
> mmc layer really
I will update comments here.

> > +	 * scatterlist segment per EDMA PARAM entry.  Update the PARAM
> > +	 * entries needed for each segment of this scatterlist.
> > +	 */
> > +	for (slot = channel, link = 0, sg = data->sg, sg_len = host->sg_len;
> > +			sg_len-- != 0 && bytes_left;
> > +			sg++, slot = host->links[link++]) {
> 
> Incorrect way of traversing the sg list. Use sg_next().
I will look into this and update the patch.

> > +	/* Convert ns to clock cycles by assuming 20MHz frequency
> > +	 * 1 cycle at 20MHz = 500 ns
> > +	 */
> > +	timeout = data->timeout_clks + data->timeout_ns / 500;
> > +	if (timeout > 0xffff)
> > +		timeout = 0xffff;
> 
> So this might time out too early if we run at a lower clock frequency?
I will look into this. As such timeout on this controller is 24 bit value. 16 bit value on DAVINCI_MMCTOD register and remaining 8 bit value on DAVINCI_MMCTOR register.

> > +	if (ios->bus_mode == MMC_BUSMODE_OPENDRAIN) {
> > +		u32 temp;
> > +		open_drain_freq = ((unsigned int)cpu_arm_clk
> > +				/ (2 * MMCSD_INIT_CLOCK)) - 1;
> > +		temp = readl(host->base + DAVINCI_MMCCLK) & ~0xFF;
> > +		temp |= open_drain_freq;
> > +		writel(temp, host->base + DAVINCI_MMCCLK);
> 
> Why are you ignoring the given frequency if in open drain mode?
This has been done in order to fix inter operability with different card. We have observed that some of cards have not been detected at 400KHz on our controller.

> > +static void
> > +davinci_abort_data(struct mmc_davinci_host *host, struct mmc_data *data)
> > +{
> > +	u32 temp;
> > +
> > +	/* record how much data we transferred */
> > +	temp = readl(host->base + DAVINCI_MMCNBLC);
> > +	data->bytes_xfered += (data->blocks - temp) * data->blksz;
> Does MMCNBLC record how many blocks you've sent, or how many blocks
> that the card has acked? If it's not the latter, then you cannot use it
> for bytes_xfered.
This is self decrementing register and it provides information on number of blocks has been transferred and not acked. In fact, there is no cleaner way to detect number of blocks acked by cards. May be in such case, we could increment bytes_xfered by 0 for particular transaction.
 
> > +
> > +	if (qstatus & MMCST0_DATDNE) {
> > +		/* All blocks sent/received, and CRC checks passed */
> > +		if (data != NULL) {
> > +			if ((host->do_dma == 0) && (host->bytes_left > 0)) {
> > +				/* if datasize < rw_threshold
> > +				 * no RX ints are generated
> > +				 */
> > +				davinci_fifo_data_trans(host, host->bytes_left);
> > +			}
> > +			end_transfer = 1;
> > +			data->bytes_xfered += data->blocks * data->blksz;
> Why += and not =?
I will look into and it seems that we could use =

> > +
> > +	if (qstatus & MMCST0_CRCRS) {
> > +		/* Command CRC error */
> > +		dev_dbg(mmc_dev(host->mmc), "Command CRC error\n");
> > +		if (host->cmd) {
> > +			/* Ignore CMD CRC errors during high speed operation */
> > +			if (host->mmc->ios.clock <= 25000000)
> > +				host->cmd->error = -EILSEQ;
> > +			end_command = 1;
I agree with you and I remove check of whether clock is less than 25MHz or not.

I will work on these comments and submit updated patch in next 4-5 days.
-Purushotam
