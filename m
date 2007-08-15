Return-Path: <linux-kernel-owner+w=401wt.eu-S1758344AbXHOGz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbXHOGz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 02:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbXHOGzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 02:55:05 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:3323 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbXHOGy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 02:54:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sFPiGRfSaCaOVXDyUcM6w56rduPAmG4e5mgihbnAuv8M/cgjltQwlsTBkYhIH8I+Us2rokEh3KIFvjfGR2AhCKdPydSr0yxpyaekNys1ch823+FsyS/wOlYdEv3CsGkSP2eDfEOsLN/93e2Nfll+yBjcYSXpyZWzMLdPNtKA4uI=
Message-ID: <4e5ebad50708142354l7a462684x7dbf84b4bac1fcb0@mail.gmail.com>
Date: Wed, 15 Aug 2007 14:54:57 +0800
From: "Sonic Zhang" <sonic.adi@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH again] [libata] libata driver for bf548 on chip ATAPI controller.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4e5ebad50708142314o6bb64b6bocf75166cb9999205@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1187056118.16255.1.camel@sevens.analog.com>
	 <4e5ebad50708131925k28d283f4k5057d0902ddc10ae@mail.gmail.com>
	 <20070814103013.6899813f@the-village.bc.nu>
	 <4e5ebad50708142314o6bb64b6bocf75166cb9999205@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

forgot to reply to all.

On 8/15/07, Sonic Zhang <sonic.adi@gmail.com> wrote:
> On 8/14/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > +/**
> > > + * Register transfer timing table
> > > + */
> >
> > Libata has a complete set of transfer mode tables and timing functions -
> > any reason for not using them ?
>
> These code are from the sample code in hardware manual. I will check
> the libata source to see if I can rewrite them in libata functions.
>
> >
> >
> > > +                       /* increase tcyc - tdvs (tcyc_tdvs) until we
> > > meed
> > > +                        * the minimum cycle length
> > > +                        */
> > > +                       while ( (tdvs + tcyc_tdvs) < tcyc ) {
> > > +                               tcyc_tdvs++;
> > > +                       }
> >
> > Why not
> >
> >                         if ((tdvs + tcyc_tvds) < tcyc)
> >                                 tcyc_tdvs = tcyc - tdvs;
> >
> > > +                       /* increase tk until we meed the minimum cycle
> > > length */
> > > +                       while ( (tkw+td) < n0 ) {
> > > +                               tkw++;
> > > +                       }
> >
> >
> >                         if (tkw + td < n0)
> >                                 tkw = n0 - td;
> >
> > (and fix up brackets)
>
> Yes, your suggestion is better.
>
> > >
> > > +static void inline wait_complete(unsigned long base, unsigned short
> > > mask)
> > > +{
> > > +       unsigned short status;
> > > +
> > > +       do {
> > > +               status = ATAPI_GET_INT_STATUS(base) & mask;
> > > +       } while (!status);
> >
> > Does this need a timeout or can a device write never get stuck ?
>
> The hardware manual says whenever an ATAPI operation is done or
> terminated in error by the devices, a bit in the status register is
> set. Is a timeout still necessary?
>
>
> >
> > > +static int bfin_port_start(struct ata_port *ap)
> > > +{
> > > +       pr_debug("in atapi port start\n");
> > > +       if (ap->udma_mask != 0 || ap->mwdma_mask != 0) {
> > > +               if (request_dma(CH_ATAPI_RX, "BFIN ATAPI RX DMA") >= 0)
> > > {
> > > +                       if (request_dma(CH_ATAPI_TX,
> > > +                               "BFIN ATAPI TX DMA") >= 0) {
> > > +                               return 0;
> > > +                       }
> > > +                       free_dma(CH_ATAPI_RX);
> > > +               }
> > > +               ap->udma_mask = 0;
> > > +               ap->mwdma_mask = 0;
> > > +               dev_err(ap->dev, "Unable to request ATAPI DMA!\n");
> > > +               return -EBUSY;
> >
> > Is this an error case - if you clear the UDMA/MWDMA mask then DMA won't
> > be needed will it so you can continue after the problem but slowly ?
>
> UDMA/MWDMA masks are set in ata_host_alloc_pinfo(), where it is
> cleared? If these masks are cleared before port starts, this driver
> falls back to PIO mode. Why this is an error case?
>
>
> >
> > Otherwise looks sound. A lot of reset method duplication but that isn't
> > your fault and something that wants more work in libata to avoid
> >
> >
>
