Return-Path: <linux-kernel-owner+w=401wt.eu-S1760170AbXEJAIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170AbXEJAIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 20:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759135AbXEJAIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 20:08:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50525 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759121AbXEJAIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 20:08:31 -0400
Message-ID: <4642627A.4030606@garzik.org>
Date: Wed, 09 May 2007 20:08:26 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: William Thompson <wt@electro-mechanical.com>, Mark Lord <liml@rtr.ca>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       albertcc@tw.ibm.com
Subject: Re: [PATCH] libata: fallback to the other IDENTIFY on device error
References: <20070427175205.GD7809@electro-mechanical.com> <4635C35D.1020807@gmail.com> <20070430202107.GF5942@electro-mechanical.com> <4636C2C7.8090206@gmail.com> <20070501121703.GH5942@electro-mechanical.com> <46373AEE.6070908@rtr.ca> <20070501131818.GA18521@electro-mechanical.com> <46374354.7040307@gmail.com> <20070501172117.GA20328@electro-mechanical.com> <463F56F2.3010106@gmail.com>
In-Reply-To: <463F56F2.3010106@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> It seems the world isn't as frank as we thought and some devices lie
> about who they are.  Fallback to the other IDENTIFY if IDENTIFY fails
> with device error.  As this is the strategy used by IDE for a long
> time, it shouldn't cause too much problem.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: William Thompson <wt@electro-mechanical.com>
> ---
> Willam, please verify this fixes your problem.  Jeff, after all, we
> seem to need this.  :-(
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index ca67484..f543109 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -1652,7 +1652,7 @@ int ata_dev_read_id(struct ata_device *d
>  	struct ata_taskfile tf;
>  	unsigned int err_mask = 0;
>  	const char *reason;
> -	int tried_spinup = 0;
> +	int may_fallback = 1, tried_spinup = 0;
>  	int rc;
>  
>  	if (ata_msg_ctl(ap))
> @@ -1696,11 +1696,30 @@ int ata_dev_read_id(struct ata_device *d
>  			return -ENOENT;
>  		}
>  
> +		if (may_fallback && (err_mask == AC_ERR_DEV)) {
> +			may_fallback = 0;
> +
> +			/* Device or controller might have reported
> +			 * the wrong device class.  Give a shot at then
> +			 * other IDENTIFY
> +			 */
> +			if (class == ATA_DEV_ATA)
> +				class = ATA_DEV_ATAPI;
> +			else
> +				class = ATA_DEV_ATA;

The error handling should be more specific -- check and make sure the 
error is 'command aborted'

	Jeff



