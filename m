Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbZBHTiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbZBHTiB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 14:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZBHThL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 14:37:11 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:46151 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752915AbZBHThD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 14:37:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=P5UeeI3PM4gTMnPuOKUBS5+5earT1L25+GfQNrrApFsIbxmOXQX2V7Bh+YAW/6K8B76HJQUN3C97qVd2i6Kd4/6LLba0k8TwOIihQXfM2BvemFkuZNyN8wxOcFaJo9ior4E8xvfaiEZAsDwsPFli5J0z9hhIerp5xIAOUh4psOI=  ;
X-YMail-OSG: GZBEOOQVM1nBWvG2YsHfIhugVwumEvYc1BBhiJyE__dWxcvPe4HicLHvpUK7mDlnFUlDmLqIqBrarRGvSFAkaSiKUTCG4l8m3yMGX.c3lUD0U4ezawRd9QUNU5rN7neNarm283kAlzYGEkTNROBWqW6lW9lYAw.f9mF6FwXYcgjEhD.W0foeGMhbRB44
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Grazvydas Ignotas <notasas@gmail.com>
Subject: Re: [PATCH] OMAP HSMMC: fix MMC3 dma
Date: Sun, 8 Feb 2009 11:10:24 -0800
User-Agent: KMail/1.9.10
Cc: tony@atomide.com, drzeus-mmc@drzeus.cx, ext-adrian.hunter@nokia.com,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1233052573-6223-1-git-send-email-notasas@gmail.com>
In-Reply-To: <1233052573-6223-1-git-send-email-notasas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902081110.25166.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 January 2009, Grazvydas Ignotas wrote:
> @@ -1058,6 +1054,25 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
>         OMAP_HSMMC_WRITE(host->base, HCTL,
>                         OMAP_HSMMC_READ(host->base, HCTL) | SDBP);
>  
> +       /* Select DMA lines */
> +       switch (host->id) {
> +       case OMAP_MMC1_DEVID:
> +               host->dma_line_tx = OMAP24XX_DMA_MMC1_TX;
> +               host->dma_line_rx = OMAP24XX_DMA_MMC1_RX;
> +               break;

Actually the cleanest way to do that is through IORESOURCE_DMA
type resources associated with the platform devices ... but
doing it that way requires reworking the MMC platform device
setup logic.  Which I can understand wanting to avoid here.

(I think that rework is worth doing for multiple reasons; this
is just one more.)


> +       case OMAP_MMC2_DEVID:
> +               host->dma_line_tx = OMAP24XX_DMA_MMC2_TX;
> +               host->dma_line_rx = OMAP24XX_DMA_MMC2_RX;
> +               break;
> +       case OMAP_MMC3_DEVID:
> +               host->dma_line_tx = OMAP34XX_DMA_MMC3_TX;
> +               host->dma_line_rx = OMAP34XX_DMA_MMC3_RX;
> +               break;
> +       default:
> +               dev_err(mmc_dev(host->mmc), "Invalid MMC id\n");
> +               goto err_irq;
> +       }
> +
>         /* Request IRQ for MMC operations */
>         ret = request_irq(host->irq, mmc_omap_irq, IRQF_DISABLED,
>                         mmc_hostname(mmc), host);


