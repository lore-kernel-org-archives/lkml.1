Return-Path: <linux-kernel-owner+w=401wt.eu-S1759487AbXKMC0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbXKMC0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 21:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbXKMC0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 21:26:05 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:50208 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbXKMC0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 21:26:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EXv6L8j9WzCdVlHio3Mm6/sgboFdsxUzGUI/OZZWAt07rIMRGWEXXmJxxelPwcpsugXRyBD2ZC0UsgoMAtQwoeQ++CcImhUmdhGeraAgTDz4xvPMy9arsBfg7/Fw3MGWgjBIR8zxD+g7OCxL0CrJ9RwmFcNevrTH4e/Z9ROFOs8=
Message-ID: <47390B2F.7090105@gmail.com>
Date: Tue, 13 Nov 2007 11:25:51 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB
References: <4738DE21.8090702@shaw.ca>
In-Reply-To: <4738DE21.8090702@shaw.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Robert.

Robert Hancock wrote:
> @@ -747,11 +748,29 @@
>  		   on the port. */
>  		adma_enable = 0;
>  		nv_adma_register_mode(ap);
> +		if (!(pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)) {
> +			/* Transitioning to legacy mode. Free the pad buffer. */
> +			ata_pad_free(ap, ap->host->dev);
> +			ap->pad = NULL;
> +			ap->pad_dma = 0;
> +		}
>  	} else {
> -		bounce_limit = *ap->dev->dma_mask;
> +		bounce_limit = pp->adma_dma_mask;
>  		segment_boundary = NV_ADMA_DMA_BOUNDARY;
>  		sg_tablesize = NV_ADMA_SGTBL_TOTAL_LEN;
>  		adma_enable = 1;
> +
> +		if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) {
> +			/* Transitioning to ADMA mode. Free legacy PRD table
> +			   and the pad buffer. */
> +			ata_pad_free(ap, ap->host->dev);
> +			ap->pad = NULL;
> +			ap->pad_dma = 0;
> +			dmam_free_coherent(ap->host->dev, ATA_PRD_TBL_SZ,
> +				ap->prd, ap->prd_dma);
> +			ap->prd = NULL;
> +			ap->prd_dma = 0;
> +		}

How about always initialize DMA mask to ATA_DMA_MASK regardless of ADMA
mode such that PRD and PAD buffers are always accessible by register
mode and just raising PCI dma mask and queue bounce limit if ADMA mode
is active?

> +	/* Set appropriate DMA mask. */
> +	pci_set_dma_mask(pdev, bounce_limit);
> +	pci_set_consistent_dma_mask(pdev, bounce_limit);

These can fail.

Also, please separate out the result TF handling to a separate patch.  I
know it's a small change but as both introduces important behavior
changes, I think it would be nice to have a bisection point inbetween.

Thanks.

-- 
tejun
