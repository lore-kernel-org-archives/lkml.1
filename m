Return-Path: <linux-kernel-owner+w=401wt.eu-S1759678AbZFKJ3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678AbZFKJ3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 05:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757102AbZFKJ3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 05:29:46 -0400
Received: from h155.mvista.com ([63.81.120.155]:57508 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755648AbZFKJ3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 05:29:45 -0400
Message-ID: <4A30CE85.40508@ru.mvista.com>
Date: Thu, 11 Jun 2009 13:29:41 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
Cc: jeff@garzik.org, linuxppc-dev@ozlabs.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dave Liu <daveliu@freescale.com>
Subject: Re: [PATCH] sata_fsl: Add power mgmt support
References: <1244692417-18484-1-git-send-email-galak@kernel.crashing.org>
In-Reply-To: <1244692417-18484-1-git-send-email-galak@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Kumar Gala wrote:

> From: Dave Liu <daveliu@freescale.com>
>
> Signed-off-by: Dave Liu <daveliu@freescale.com>
> Signed-off-by: Liu Yu <yu.liu@freescale.com>
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
>  drivers/ata/sata_fsl.c |   35 +++++++++++++++++++++++++++++++++++
>  1 files changed, 35 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
> index 36b8629..94eaa43 100644
> --- a/drivers/ata/sata_fsl.c
> +++ b/drivers/ata/sata_fsl.c
> @@ -1378,6 +1378,37 @@ static int sata_fsl_remove(struct of_device *ofdev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM
> +static int sata_fsl_suspend(struct of_device *op, pm_message_t state)
> +{
> +	struct ata_host *host = dev_get_drvdata(&op->dev);
> +	return ata_host_suspend(host, state);
> +}
> +
> +static int sata_fsl_resume(struct of_device *op)
> +{
> +	struct ata_host *host = dev_get_drvdata(&op->dev);
> +	struct sata_fsl_host_priv *host_priv = host->private_data;
> +	int ret;
> +	void __iomem *hcr_base = host_priv->hcr_base;
> +	struct ata_port *ap = host->ports[0];
> +	struct sata_fsl_port_priv *pp = ap->private_data;
> +
> +	ret = sata_fsl_init_controller(host);
> +	if (ret) {
> +		dev_printk(KERN_ERR, &op->dev,
> +			"Error initialize hardware\n");
>   

   May be "initializing"?

> +		return ret;
> +	}
> +
> +	/* Recovery the CHBA register in host controller cmd register set */
>   

   Maybe "Recover"?

> +	iowrite32(pp->cmdslot_paddr & 0xffffffff, hcr_base + CHBA);
> +
> +	ata_host_resume(host);
> +	return 0;
> +}
> +#endif
>   

MBR, Sergei


