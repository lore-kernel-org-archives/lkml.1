Return-Path: <linux-kernel-owner+w=401wt.eu-S933576AbXEPVO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576AbXEPVO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 17:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759121AbXEPVOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 17:14:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:8197 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbXEPVOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 17:14:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GZyHTUdfP3grRrw8gPVj1+BlOdOz5hSjlNBI0Cw6BIGk3F+d272Kh7d30GuCGyXofHk2TxY0Iipv4ODnpIZByTFnWC/pe3FdczZDyOljs5AimdMzV0N3mvG1zBJL955M+emwV6CFodhCIwIrkuGq10EqDAapxx451ZYctXJixqc=
Message-ID: <1defaf580705161414i67e753d7x883a78da347f7d55@mail.gmail.com>
Date: Wed, 16 May 2007 23:14:18 +0200
From: "=?ISO-8859-1?Q?H=E5vard_Skinnemoen?=" <hskinnemoen@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH] atmel_spi: Pass correct DMA address to controller
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>, wux@landicorp.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <200705161254.59308.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11793107892086-git-send-email-hskinnemoen@atmel.com>
	 <200705161254.59308.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/07, David Brownell <david-b@pacbell.net> wrote:
> On Wednesday 16 May 2007, Haavard Skinnemoen wrote:
> > -     tx_dma = xfer->tx_dma;
> > -     rx_dma = xfer->rx_dma;
> > +     tx_dma = xfer->tx_dma + xfer->len - len;
> > +     rx_dma = xfer->rx_dma + xfer->len - len;
> >
> >       /* use scratch buffer only when rx or tx data is unspecified */
> > -     if (rx_dma == INVALID_DMA_ADDRESS) {
> > +     if (!xfer->rx_buf) {
>
> This test ...
>
> >               rx_dma = as->buffer_dma;
> >               if (len > BUFFER_SIZE)
> >                       len = BUFFER_SIZE;
> >       }
> > -     if (tx_dma == INVALID_DMA_ADDRESS) {
> > +     if (!xfer->tx_buf) {
>
> ... and this one must not assume that the relevant buffer
> is always NULL when the tx_dma has been set up.  Keep the
> test against INVALID_DMA_ADDRESS, but fetch the address
> from the spi_transfer.

No it doesn't -- it's the other way around. It assumes that if
xfer->tx_buf is NULL, the user didn't provide a buffer so it has to
use the scratch buffer instead. The driver never does PIO transfers,
so if tx_buf is valid, tx_dma ought to be valid  too. This is taken
care of elsewhere by calling dma_map_single() if the user provided a
virtual pointer but not a dma address.

Checking for an invalid cpu-virtual pointer really should be
equivalent to checking for an invalid DMA address at this point.

I could perhaps add else blocks to those two ifs and add the offset to
the respective dma addresses there instead if it makes it clearer. The
tests are supposed to be the same as before, but I had to change them
one way or another because of the added offset (which would make an
invalid dma address non-invalid.)

> It's legit to set up cpu-virtual (for PIO) and dma addresses
> for each buffer, since the upper layer driver has no way to
> know if the underlying controller driver is DMA-capable, or
> for that matter PIO-capable.

Yes, but are there any drivers that will provide a valid dma address
and a NULL cpu-virtual pointer? That would indeed break my
assumptions, but it would also break any PIO-only drivers, wouldn't
it?

Haavard
