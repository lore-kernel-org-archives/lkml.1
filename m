Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbZERPbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbZERPbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 11:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZERPbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 11:31:10 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:63220 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbZERPbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 11:31:09 -0400
X-Greylist: delayed 667 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 May 2009 11:31:09 EDT
Date: Mon, 18 May 2009 16:20:01 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Wolfgang =?iso-8859-1?Q?M=FCes?= <wolfgang.mues@auerswald.de>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: do propper retry managment in the block layer
	- rewritten
Message-ID: <20090518152001.GA29472@console-pimps.org>
References: <200905181521.38959.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200905181521.38959.wolfgang.mues@auerswald.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 02:21:38PM +0100, Wolfgang Mües wrote:
> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
> 
> o This patch adds a propper retry managment for reading
>   and writing data blocks for mmc and mmc_spi. Blocks are
>   retransmitted if the cause of failure might be a transmission
>   fault. After a permanent failure, we try to read all other
>   pending sectors, but terminate on write.
>   This patch was tested with induced transmission errors
>   by ESD pulses (and survived).
> 
> Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
> 

When you say "proper retry management", what problem are you having
with the current code? Your changelog tells me what you changed but
not why you changed it.

> ---
> diff -uprN 2_6_29_rc7_patch_EILSEQ/drivers/mmc/card/block.c 2_6_29_rc7_patch_retries/drivers/mmc/card/block.c
> --- 2_6_29_rc7_patch_EILSEQ/drivers/mmc/card/block.c	2009-03-09 17:10:55.000000000 +0100
> +++ 2_6_29_rc7_patch_retries/drivers/mmc/card/block.c	2009-05-18 15:00:41.000000000 +0200

It's always a good idea to make your changes against the latest kernel
version to make sure that your patches apply cleanly. They applied OK
this time, but they might not in future.

> @@ -230,12 +230,14 @@ static int mmc_blk_issue_rq(struct mmc_q
>  	struct mmc_card *card = md->queue.card;
>  	struct mmc_blk_request brq;
>  	int ret = 1, disable_multi = 0;
> +	int retries = 3;
> 
>  	mmc_claim_host(card->host);
> 
>  	do {
>  		struct mmc_command cmd;
>  		u32 readcmd, writecmd, status = 0;
> +		int error = 0;
> 
>  		memset(&brq, 0, sizeof(struct mmc_blk_request));
>  		brq.mrq.cmd = &brq.cmd;
> @@ -251,10 +253,8 @@ static int mmc_blk_issue_rq(struct mmc_q
>  		brq.stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
>  		brq.data.blocks = req->nr_sectors;
> 
> -		/*
> -		 * After a read error, we redo the request one sector at a time
> -		 * in order to accurately determine which sectors can be read
> -		 * successfully.
> +		/* After an transmission error, we switch to single block
> +		 * transfer until the problem is solved or we fail.
>  		 */

Why did you change this comment? They seem to say roughly the same
things to me, only the first one is more descriptive. I think you
really need to combine the two,

		/*
		 * After a transmission error, we redo the request one sector
		 * at a time in order to accurately determine which sectors
		 * can be transmitted successfully. We keep retrying until
		 * the transmission succeeds or we exceed our retry count.
		 */

>  		if (disable_multi && brq.data.blocks > 1)
>  			brq.data.blocks = 1;
> @@ -262,10 +262,12 @@ static int mmc_blk_issue_rq(struct mmc_q
>  		if (brq.data.blocks > 1) {
>  			/* SPI multiblock writes terminate using a special
>  			 * token, not a STOP_TRANSMISSION request.
> +			 * Here, this request is set for ALL types of
> +			 * hosts, so that we can use it in the lower
> +			 * layers if the data transfer stage has failed
> +			 * and the card is not able to accept the token.
>  			 */
> -			if (!mmc_host_is_spi(card->host)
> -					|| rq_data_dir(req) == READ)
> -				brq.mrq.stop = &brq.stop;
> +			brq.mrq.stop = &brq.stop;
>  			readcmd = MMC_READ_MULTIPLE_BLOCK;
>  			writecmd = MMC_WRITE_MULTIPLE_BLOCK;
>  		} else {

Hmm.. is it OK to abuse the STOP_TRANSMISSION request like this? Does
SPI multiblock write still terminate with this patch?

> @@ -311,52 +313,71 @@ static int mmc_blk_issue_rq(struct mmc_q
>  		mmc_wait_for_req(card->host, &brq.mrq);
> 
>  		mmc_queue_bounce_post(mq);
> -
> -		/*
> -		 * Check for errors here, but don't jump to cmd_err
> -		 * until later as we need to wait for the card to leave
> -		 * programming mode even when things go wrong.
> -		 */
> -		if (brq.cmd.error || brq.data.error || brq.stop.error) {
> -			if (brq.data.blocks > 1 && rq_data_dir(req) == READ) {
> -				/* Redo read one sector at a time */
> -				printk(KERN_WARNING "%s: retrying using single "
> -				       "block read\n", req->rq_disk->disk_name);
> -				disable_multi = 1;
> -				continue;
> -			}
> -			status = get_card_status(card, req);
> -		}
> -
> +#if 0
> +		printk(KERN_INFO "%s transfer sector %d count %d\n",
> +			(rq_data_dir(req) == READ) ? "Read" : "Write",
> +			(int)req->sector, (int)brq.data.blocks);
> +#endif

This should probably be using pr_debug(). That way you can remove the
#if 0. Or delete it altogether.

[...]

> diff -uprN 2_6_29_rc7_patch_EILSEQ/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch_retries/drivers/mmc/host/mmc_spi.c
> --- 2_6_29_rc7_patch_EILSEQ/drivers/mmc/host/mmc_spi.c	2009-05-14 12:49:42.000000000 +0200
> +++ 2_6_29_rc7_patch_retries/drivers/mmc/host/mmc_spi.c	2009-05-14 15:01:15.000000000 +0200
> @@ -1087,7 +1089,15 @@ static void mmc_spi_request(struct mmc_h
>  	status = mmc_spi_command_send(host, mrq, mrq->cmd, mrq->data != NULL);
>  	if (status == 0 && mrq->data) {
>  		mmc_spi_data_do(host, mrq->cmd, mrq->data, mrq->data->blksz);
> -		if (mrq->stop)
> +		/* filter-out the stop command for multiblock writes,
> +		* only if the data stage has no transmission error.
> +		* If the data stage has a transmission error, send the
> +		* STOP command because there is a great chance that the
> +		* SPI stop token was not accepted by the card.
> +		*/
> +		if (mrq->stop &&
> +		  ((mrq->data->flags & MMC_DATA_READ)
> +		 || mrq->data->error))
>  			status = mmc_spi_command_send(host, mrq, mrq->stop, 0);
>  		else
>  			mmc_cs_off(host);

Again, does this still work for SPI? Have you tested it?
