Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbZKJPFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbZKJPFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756631AbZKJPFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:05:36 -0500
Received: from smtp.nokia.com ([192.100.122.230]:26993 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630AbZKJPFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:05:35 -0500
Subject: Re: [PATCH] mtd-nand: davinci: Correct 4-bit error correction
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: linux-mtd@lists.infradead.org, akpm@linux-foundation.org,
       nsnehaprabha@ti.com, davinci-linux-open-source@linux.davincidsp.com,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1257244270-2433-1-git-send-email-sudhakar.raj@ti.com>
References: <1257244270-2433-1-git-send-email-sudhakar.raj@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 17:05:02 +0200
Message-Id: <1257865502.21596.773.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Nov 2009 15:05:04.0967 (UTC) FILETIME=[2F3B5D70:01CA6217]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 16:01 +0530, Sudhakar Rajashekhara wrote:
> On TI's DA830/OMAP-L137, DA850/OMAP-L138 and DM365, after
> setting the 4BITECC_ADD_CALC_START bit in the NAND Flash
> control register to 1 and before waiting for the NAND Flash
> status register to be equal to 1, 2 or 3, we have to wait
> till the ECC HW goes to correction state. Without this wait,
> ECC correction calculations will not be proper.
> 
> This has been tested on DA830/OMAP-L137, DA850/OMAP-L138,
> DM355 and DM365 EVMs.
> 
> Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
> Acked-by: Sneha Narnakaje <nsnehaprabha@ti.com>
> ---
>  drivers/mtd/nand/davinci_nand.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
> index fe3eba8..8a32999 100644
> --- a/drivers/mtd/nand/davinci_nand.c
> +++ b/drivers/mtd/nand/davinci_nand.c
> @@ -310,6 +310,7 @@ static int nand_davinci_correct_4bit(struct mtd_info *mtd,
>  	unsigned short ecc10[8];
>  	unsigned short *ecc16;
>  	u32 syndrome[4];
> +	u32 ecc_state;
>  	unsigned num_errors, corrected;
>  
>  	/* All bytes 0xff?  It's an erased page; ignore its ECC. */
> @@ -360,6 +361,21 @@ compare:
>  	 */
>  	davinci_nand_writel(info, NANDFCR_OFFSET,
>  			davinci_nand_readl(info, NANDFCR_OFFSET) | BIT(13));
> +
> +	/*
> +	 * ECC_STATE field reads 0x3 (Error correction complete) immediately
> +	 * after setting the 4BITECC_ADD_CALC_START bit. So if you immediately
> +	 * begin trying to poll for the state, you may fall right out of your
> +	 * loop without any of the correction calculations having taken place.
> +	 * The recommendation from the hardware team is to wait till ECC_STATE
> +	 * reads less than 4, which means ECC HW has entered correction state.
> +	 */
> +	do {
> +		ecc_state = (davinci_nand_readl(info,
> +				NANDFSR_OFFSET) >> 8) & 0x0f;
> +		cpu_relax();
> +	} while (ecc_state < 4);
> +
>  	for (;;) {
>  		u32	fsr = davinci_nand_readl(info, NANDFSR_OFFSET);

I see a lot of constructs like this in many mtd drivers. I wonder, what
happens if ecc_state never becomes < 4? Should there be some protection
against this, e.g., exit the loop with an error message if we are
looping for more than 1 or several seconds?

What is the "official" / "right" way for this kind of loops?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

