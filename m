Return-Path: <linux-kernel-owner+w=401wt.eu-S1753073AbZKQRiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbZKQRiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbZKQRiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:38:22 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:48285 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbZKQRiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:38:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=HZ/18eDE/sMtwwKEC0lbI0eztINRfAzuTRu6/SY8ka1oecBOchakx3JVGDUkYp1AtJ
         LjQKp4sf3cdWbm9HT9BEzl2GHM1LADfIqto06bb2/udVybsEsMRM2/0uQyCgCX9aLXgF
         OmdHJbgB2d4UjC75PA3Cn/F+m3g/PjkPTmSyM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 3/5] cmd64x: implement serialization as per notes
Date: Tue, 17 Nov 2009 18:35:05 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <20091117145122.15430.70080.stgit@localhost.localdomain>
In-Reply-To: <20091117145122.15430.70080.stgit@localhost.localdomain>
MIME-Version: 1.0
Message-Id: <200911171835.05232.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009 15:51:32 Alan Cox wrote:

> +struct cmd_priv
> +{
> +	int dma_live;		/* Channel using DMA */
> +	int irq_t[2];		/* Register to check for IRQ */
> +	int irq_m[2];		/* Bit to check */
> +};

irq_t and irq_m content will be identical for all host instances
so you may as well add one instance for it, use ->private_data to
store dma_live information and remove cmd_priv allocation

> +	/* If the other port is not live then issue the command */
> +	if (alt == NULL || !alt->qc_active) {
> +		if (dma)
> +			priv->dma_live = qc->ap->port_no;
> +		return 0;
> +	}
> +	/* If there is a live DMA command then wait */
> +	if (priv->dma_live != -1)
> +		return 	ATA_DEFER_PORT;
> +	if (dma) {
> +		/* Cannot overlap our DMA command */
> +		if (alt->qc_active)
> +			return ATA_DEFER_PORT;

no need to check alt->qc_active again here

-- 
Bartlomiej Zolnierkiewicz
