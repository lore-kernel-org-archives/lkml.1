Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab0BOWoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 17:44:11 -0500
Received: from mail.perches.com ([173.55.12.10]:1095 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574Ab0BOWoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 17:44:09 -0500
Subject: Re: [PATCH] USB: misplaced parenthesis
From: Joe Perches <joe@perches.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-usb@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B79CD49.8070607@gmail.com>
References: <4B79CD49.8070607@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Feb 2010 14:44:08 -0800
Message-ID: <1266273848.29987.21.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-15 at 23:40 +0100, Roel Kluin wrote:
> The parenthesis was misplaced
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Is this maybe, as the comment states, why blanking a cdrw at speed 4
> was unreliable?
> 
> diff --git a/drivers/usb/storage/shuttle_usbat.c b/drivers/usb/storage/shuttle_usbat.c
> index b62a288..b958db5 100644
> --- a/drivers/usb/storage/shuttle_usbat.c
> +++ b/drivers/usb/storage/shuttle_usbat.c
> @@ -1645,8 +1645,8 @@ static int usbat_hp8200e_transport(struct scsi_cmnd *srb, struct us_data *us)
>  
>  	if ((result = usbat_write_block(us,
>  			USBAT_ATA, srb->cmnd, 12,
> -				(srb->cmnd[0]==GPCMD_BLANK ? 75 : 10), 0) !=
> -			     USB_STOR_TRANSPORT_GOOD)) {
> +				(srb->cmnd[0]==GPCMD_BLANK ? 75 : 10), 0)) !=
> +			     USB_STOR_TRANSPORT_GOOD) {
>  		return result;
>  	}

I think it'd be better if you hoisted the set'n'test out of the if()

Isn't this the current logic?

	result = usbat_write_block(us, USBAT_ATA, srb->cmnd, 12,
				   srb->cmnd[0] == GPCMD_BLANK ? 75 : 10, 0);
	result = result != USB_STOR_TRANSPORT_GOOD;
	if (result)
		return result;

I wonder if it should be:

	result = usbat_write_block(us, USBAT_ATA, srb->cmnd, 12,
				   srb->cmnd[0] == GPCMD_BLANK ? 75 : 10, 0);
	if (result != USB_STOR_TRANSPORT_GOOD)
		return result;


