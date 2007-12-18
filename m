Return-Path: <linux-kernel-owner+w=401wt.eu-S934349AbXLRCvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934349AbXLRCvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 21:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbXLRCvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 21:51:08 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:9048 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbXLRCvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 21:51:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=I4e6JbXxsQs3UbTFZbjKqOYy5/BeThkgPuYiS5+7IJDMc4OI0vE1cbi+J/oLcxbLRiloqVx7EeB7zi9z04YOoBP31YPe24iZMWYksyGah/y9YxqM6PC18sazCUykitiB/AUZvba8LTNjuqwtBYfl/yHZ6BBpLirHCoeIyMjIPI0=
Message-ID: <47673593.6040104@gmail.com>
Date: Tue, 18 Dec 2007 11:50:59 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: shyam_iyer@dell.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB (v3)
References: <12954112.1197908230928.JavaMail.root@wombat.diezmil.com>
In-Reply-To: <12954112.1197908230928.JavaMail.root@wombat.diezmil.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

shyam_iyer@dell.com wrote:
> --- sata_nv.c.orig	2007-12-17 21:08:12.000000000 +0530
> +++ sata_nv.c	2007-12-17 21:08:25.000000000 +0530
> @@ -2407,6 +2407,12 @@
>  			type = GENERIC;
>  	}
>  
> +	/* set 64bit dma masks, may fail */
> +	if (type == ADMA) {
> +		if (pci_set_dma_mask(pdev, DMA_64BIT_MASK) == 0)
> +			pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
> +	}
> +
>  	ppi[0] = &nv_port_info[type];
>  	rc = ata_pci_prepare_sff_host(pdev, ppi, &host);
>  	if (rc)
> @@ -2418,12 +2424,6 @@
>  	hpriv->type = type;
>  	host->private_data = hpriv;
>  
> -	/* set 64bit dma masks, may fail */
> -	if (type == ADMA) {
> -		if (pci_set_dma_mask(pdev, DMA_64BIT_MASK) == 0)
> -			pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
> -	}
> -

This is weird.  IIRC, the problem is caused by allocating consistent
memory for legacy DMA over 32bit limit.  Your patch moves setting 64bit
DMA mask upward but it doesn't affect anything because
ata_pci_prepare_sff_host() and hpriv allocation are not DMA memory
allocations and thus unaffected by DMA mask.

Robert's last patch seems correct to me.  I have no idea why it doesn't
work for you tho.  Another interesting point is that you are reporting
data corruption instead of time out or HSM violation, which indicates
that the PRD table is accessible but what it contains is incorrect.

I guess it's time to print out some memory addresses.  I'll prep a debug
patch soon.

Thanks.

-- 
tejun
