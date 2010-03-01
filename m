Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab0CAUP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 15:15:57 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:51850 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab0CAUPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 15:15:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rag99H/ol0rwZlfOQ3RxM2CqgOMRzXXrM9v+7AhEsAj+z1Y7k0q+7goAVPh/T3Y8mE
         Mpg9Zme22VL+Pdsgj+B1HJQ/PuiwaJSaJ4i9U0+5lPbtbsf81x32ukjpecObm5ZtIpWO
         Q+++tKB62quFWPQu/CBcFd/JNHg1gqxi5f2T4=
Message-ID: <4B8C2079.7010607@garzik.org>
Date: Mon, 01 Mar 2010 15:15:53 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: jeff@garzik.org.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [RFC 1/4] libata: cache device select
References: <20100217130847.16338.55586.stgit@localhost.localdomain>
In-Reply-To: <20100217130847.16338.55586.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2010 08:10 AM, Alan Cox wrote:
> Avoid the device select overhead on every qc_issue (>  10uS) by caching the
> currently selected device. This shows up on profiles under load. Best case
> this costs us 10uS for the delay, worst case with a dumb interface it's
> costing us about *1mS* a command.
>
> I believe the logic here is sufficient, but would welcome some second reviews
> as its not something you want to get wrong !
>
>
> Signed-off-by: Alan Cox<alan@linux.intel.com>
> ---
>
>   drivers/ata/libata-sff.c |    8 ++++++--
>   include/linux/libata.h   |    1 +
>   2 files changed, 7 insertions(+), 2 deletions(-)
>
>
> diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
> index 63d9c6a..cf0332a 100644
> --- a/drivers/ata/libata-sff.c
> +++ b/drivers/ata/libata-sff.c
> @@ -469,6 +469,7 @@ void ata_sff_dev_select(struct ata_port *ap, unsigned int device)
>
>   	iowrite8(tmp, ap->ioaddr.device_addr);
>   	ata_sff_pause(ap);	/* needed; also flushes, for mmio */
> +	ap->sff_selected = device;
>   }
>   EXPORT_SYMBOL_GPL(ata_sff_dev_select);
>
> @@ -1538,7 +1539,8 @@ unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc)
>   	}
>
>   	/* select the device */
> -	ata_dev_select(ap, qc->dev->devno, 1, 0);
> +	if (qc->dev->devno != ap->sff_selected)
> +        	ata_dev_select(ap, qc->dev->devno, 1, 0);
>
>   	/* start the command */
>   	switch (qc->tf.protocol) {

My main worry here is that this logic excises the 150ms wait in 
ata_dev_select() that has been used effectively to allow ATAPI devices 
to "collect themselves" after waiting for idle, prior to command issuance.

	Jeff




