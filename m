Return-Path: <linux-kernel-owner+w=401wt.eu-S1759687AbZDHFNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687AbZDHFNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZDHFNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:13:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:20739 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZDHFNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:13:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Bwm8yLhFWyXqIOw9zQVOCf0CYMoSY6pLXM9kXcX/p5NEkmx5KcahC1yDD08Qgoi9l9
         yEtwneGyNb+hOxY2ldbc9XsJrDDm25EptRzN2Nw/D63pfsQ6WHNbIlwyOGHOgTM7PBQU
         PeyK1OQd49Ex9xDQurbxpu6NP9Fr7k3GuXXaM=
MIME-Version: 1.0
In-Reply-To: <20090407232331.GA16190@havoc.gtf.org>
References: <20090407232247.GA16086@havoc.gtf.org>
	 <20090407232331.GA16190@havoc.gtf.org>
Date: Wed, 8 Apr 2009 10:43:31 +0530
Message-ID: <3fb94e50904072213n637525b1w4b032544dcef3618@mail.gmail.com>
Subject: Re: [PATCH 2/2] sata_sil: disable DMA engine in ->freeze
From: Sagar Borikar <sagar.borikar@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, d.harrison@sutus.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch works for our platform.

Thanks
Sagar

On Wed, Apr 8, 2009 at 4:53 AM, Jeff Garzik <jeff@garzik.org> wrote:
>
> Dustin, please see if these two patches solve your problem?
>
>
> commit a6a2da59f2a4ba834a6e20e2d2a4d030bb9371ea
> Author: Jeff Garzik <jeff@garzik.org>
> Date:   Tue Apr 7 19:18:32 2009 -0400
>
>    [libata] sata_sil: disable DMA engine in sil_freeze()
>
>    We must disable the DMA engine before accessing taskfile registers.
>
>    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
>
> diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
> index e67ce8e..896975f 100644
> --- a/drivers/ata/sata_sil.c
> +++ b/drivers/ata/sata_sil.c
> @@ -565,6 +565,19 @@ static void sil_freeze(struct ata_port *ap)
>        tmp |= SIL_MASK_IDE0_INT << ap->port_no;
>        writel(tmp, mmio_base + SIL_SYSCFG);
>        readl(mmio_base + SIL_SYSCFG);  /* flush */
> +
> +       /* Ensure DMA_ENABLE is off.
> +        *
> +        * This is because the controller will not give us access to the
> +        * taskfile registers while a DMA is in progress
> +        */
> +       iowrite8(ioread8(ap->ioaddr.bmdma_addr) & ~SIL_DMA_ENABLE,
> +                ap->ioaddr.bmdma_addr);
> +
> +       /* According to ata_bmdma_stop, an HDMA transition requires
> +        * on PIO cycle. But we can't read a taskfile register.
> +        */
> +       ioread8(ap->ioaddr.bmdma_addr);
>  }
>
>  static void sil_thaw(struct ata_port *ap)
>
