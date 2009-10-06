Return-Path: <linux-kernel-owner+w=401wt.eu-S1751879AbZJFEYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbZJFEYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 00:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZJFEYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 00:24:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55423 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbZJFEYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 00:24:48 -0400
Message-ID: <4ACAC665.7070109@garzik.org>
Date: Tue, 06 Oct 2009 00:24:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: "Jung-Ik (John) Lee" <jilee@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Grant Grundler <grundler@google.com>,
       Gwendal Gringo <gwendal@google.com>
Subject: Re: [git patches] libata updates
References: <20090917204935.GA7432@havoc.gtf.org> <200909202305.06199.bzolnier@gmail.com> <8b5805ff0909211936s4968d11fnd3e6604d38e31c79@mail.gmail.com> <200909281734.11090.bzolnier@gmail.com>
In-Reply-To: <200909281734.11090.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2009 11:34 AM, Bartlomiej Zolnierkiewicz wrote:
> Thanks, your patch looks good to me but since there are still some
> leftover issues left we would also need something like the incremental
> patch below:
>
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] pata_atp867x: PIO support fixes
>
> * use  8 clk setting for active clocks == 7 (was 12 clk)
> * use 12 clk setting for active clocks>  12 (was  8 clk)
> * do 66MHz bus fixup before mapping active clocks
> * fix setup of PIO command timings
>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
>   drivers/ata/pata_atp867x.c |   36 +++++++++++++++++++-----------------
>   1 file changed, 19 insertions(+), 17 deletions(-)
>
> Index: b/drivers/ata/pata_atp867x.c
> ===================================================================
> --- a/drivers/ata/pata_atp867x.c
> +++ b/drivers/ata/pata_atp867x.c
> @@ -155,30 +155,31 @@ static int atp867x_get_active_clocks_shi
>   	struct atp867x_priv *dp = ap->private_data;
>   	unsigned char clocks = clk;
>
> +	/*
> +	 * Doc 6.6.9: increase the clock value by 1 for safer PIO speed
> +	 * on 66MHz bus
> +	 */
> +	if (dp->pci66mhz)
> +		clocks++;
> +
>   	switch (clocks) {
>   	case 0:
>   		clocks = 1;
>   		break;
> -	case 1 ... 7:
> -		break;
> -	case 9 ... 12:
> -		clocks = 7;
> +	case 1 ... 6:
>   		break;
>   	default:
>   		printk(KERN_WARNING "ATP867X: active %dclk is invalid. "
> -			"Using default 8clk.\n", clk);
> +			"Using 12clk.\n", clk);
> +	case 9 ... 12:
> +		clocks = 7;	/* 12 clk */
> +		break;
> +	case 7:
>   	case 8:	/* default 8 clk */
>   		clocks = 0;
>   		goto active_clock_shift_done;
>   	}
>
> -	/*
> -	 * Doc 6.6.9: increase the clock value by 1 for safer PIO speed
> -	 * on 66MHz bus
> -	 */
> -	if (dp->pci66mhz&&  clocks<  7)
> -		clocks++;
> -
>   active_clock_shift_done:
>   	return clocks<<  ATP867X_IO_PIOSPD_ACTIVE_SHIFT;
>   }
> @@ -193,7 +194,8 @@ static int atp867x_get_recover_clocks_sh
>   		break;
>   	case 1 ... 11:
>   		break;
> -	case 13: case 14:
> +	case 13:
> +	case 14:
>   		--clocks;	/* by the spec */
>   		break;
>   	case 15:
> @@ -235,16 +237,16 @@ static void atp867x_set_piomode(struct a
>   	iowrite8(b, dp->dma_mode);
>
>   	b = atp867x_get_active_clocks_shifted(ap, t.active) |
> -		atp867x_get_recover_clocks_shifted(t.recover);
> +	    atp867x_get_recover_clocks_shifted(t.recover);
>
>   	if (adev->devno&  1)
>   		iowrite8(b, dp->slave_piospd);
>   	else
>   		iowrite8(b, dp->mstr_piospd);
>
> -	/*
> -	 * use the same value for comand timing as for PIO timimg
> -	 */
> +	b = atp867x_get_active_clocks_shifted(ap, t.act8b) |
> +	    atp867x_get_recover_clocks_shifted(t.rec8b);
> +
>   	iowrite8(b, dp->eightb_piospd);
>   }
>
>

This was incremental to the previous patch, or upstream?

	Jeff


