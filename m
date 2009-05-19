Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbZESL34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbZESL34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 07:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZESL3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 07:29:49 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:62643 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZESL3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 07:29:48 -0400
Date: Tue, 19 May 2009 12:29:48 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Wolfgang =?iso-8859-1?Q?M=FCes?= <wolfgang.mues@auerswald.de>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: use EILSEQ for possible transmission errors
Message-ID: <20090519112948.GB28564@console-pimps.org>
References: <200905141324.27908.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200905141324.27908.wolfgang.mues@auerswald.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 12:24:27PM +0100, Wolfgang Mües wrote:
> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
> 
> o This patch changes the reported error code for the responses
>   to a command from EINVAL/EIO to EILSEQ, as EINVAL is reserved
>   for non-recoverable host errors, and the responses from
>   the SD/MMC card may be because of recoverable transmission
>   errors in the command or in the response. Response codes
>   are NOT protected by a checksum, so don't trust them.
> 
> Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
> 
> ---
> diff -uprN 2_6_29_rc7_patch_wearout_speedup/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch_EILSEQ/drivers/mmc/host/mmc_spi.c
> --- 2_6_29_rc7_patch_wearout_speedup/drivers/mmc/host/mmc_spi.c	2009-04-08 11:11:20.000000000 +0200
> +++ 2_6_29_rc7_patch_EILSEQ/drivers/mmc/host/mmc_spi.c	2009-05-14 12:49:42.000000000 +0200
> @@ -334,17 +334,18 @@ checkstatus:
>  	cmd->error = 0;
> 
>  	/* Status byte: the entire seven-bit R1 response.  */
> -	if (cmd->resp[0] != 0) {
> -		if ((R1_SPI_PARAMETER | R1_SPI_ADDRESS
> -				      | R1_SPI_ILLEGAL_COMMAND)
> -				& cmd->resp[0])
> -			value = -EINVAL;
> -		else if (R1_SPI_COM_CRC & cmd->resp[0])
> -			value = -EILSEQ;
> -		else if ((R1_SPI_ERASE_SEQ | R1_SPI_ERASE_RESET)
> -				& cmd->resp[0])
> -			value = -EIO;
> -		/* else R1_SPI_IDLE, "it's resetting" */
> +	/*
> +	 * Note that we have a problem here: as the response is NOT protected
> +	 * by a CRC or checksum, a transmission error in the response will
> +	 * be interpreted as an error code. So we map all error codes to
> +	 * EILSEQ here, to allow for the upper layer to retry the command.
> +	 * If one of these error codes is a non-recoverable error, retries
> +	 * will do no harm.
> +	 */
> +
> +	/* Allow only 0 and R1_SPI_IDLE here */
> +	if (cmd->resp[0] & ~R1_SPI_IDLE) {
> +		value = -EILSEQ;
>  	}
> 
>  	switch (mmc_spi_resp_type(cmd)) {

Hmm, always returning -EILSEQ is devious. What happens if we sent an
illegal command? The value of "value" is passed up to the callers via
cmd->error and so may eventually get printed in the pr_debug() call in
mmc_request_done(), line 86.

Whereas before the error would display EINVAL for an illegal command
now it'll display EILSEQ, which makes no sense. Seeing EILSEQ in my
log when really the error is EINVAL is gonna really confuse me.

IMHO always assuming that command errors are caused by transmission
problems is not the right solution.
