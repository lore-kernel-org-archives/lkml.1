Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbXHNJWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbXHNJWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 05:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbXHNJW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 05:22:26 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37036 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753641AbXHNJWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 05:22:25 -0400
Date: Tue, 14 Aug 2007 10:30:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Sonic Zhang" <sonic.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH again] [libata] libata driver for bf548 on chip ATAPI
 controller.
Message-ID: <20070814103013.6899813f@the-village.bc.nu>
In-Reply-To: <4e5ebad50708131925k28d283f4k5057d0902ddc10ae@mail.gmail.com>
References: <1187056118.16255.1.camel@sevens.analog.com>
	<4e5ebad50708131925k28d283f4k5057d0902ddc10ae@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +/**
> + * Register transfer timing table
> + */

Libata has a complete set of transfer mode tables and timing functions -
any reason for not using them ?


> +                       /* increase tcyc - tdvs (tcyc_tdvs) until we
> meed
> +                        * the minimum cycle length
> +                        */
> +                       while ( (tdvs + tcyc_tdvs) < tcyc ) {
> +                               tcyc_tdvs++;
> +                       }

Why not 

			if ((tdvs + tcyc_tvds) < tcyc)
				tcyc_tdvs = tcyc - tdvs;

> +                       /* increase tk until we meed the minimum cycle
> length */
> +                       while ( (tkw+td) < n0 ) {
> +                               tkw++;
> +                       }


			if (tkw + td < n0)
				tkw = n0 - td;

(and fix up brackets)

>
> +static void inline wait_complete(unsigned long base, unsigned short
> mask)
> +{
> +       unsigned short status;
> +
> +       do {
> +               status = ATAPI_GET_INT_STATUS(base) & mask;
> +       } while (!status);

Does this need a timeout or can a device write never get stuck ?

> +static int bfin_port_start(struct ata_port *ap)
> +{
> +       pr_debug("in atapi port start\n");
> +       if (ap->udma_mask != 0 || ap->mwdma_mask != 0) {
> +               if (request_dma(CH_ATAPI_RX, "BFIN ATAPI RX DMA") >= 0)
> {
> +                       if (request_dma(CH_ATAPI_TX,
> +                               "BFIN ATAPI TX DMA") >= 0) {
> +                               return 0;
> +                       }
> +                       free_dma(CH_ATAPI_RX);
> +               }
> +               ap->udma_mask = 0;
> +               ap->mwdma_mask = 0;
> +               dev_err(ap->dev, "Unable to request ATAPI DMA!\n");
> +               return -EBUSY;

Is this an error case - if you clear the UDMA/MWDMA mask then DMA won't
be needed will it so you can continue after the problem but slowly ?


Otherwise looks sound. A lot of reset method duplication but that isn't
your fault and something that wants more work in libata to avoid

