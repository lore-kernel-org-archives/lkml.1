Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbYA1J71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbYA1J71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbYA1J7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:59:19 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:62531 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751622AbYA1J7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:59:17 -0500
Date: Mon, 28 Jan 2008 10:59:09 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux@maxim.org.za, linux@bohmer.net, coldwell@redhat.com,
       marc.pignat@hevs.ch, david-b@pacbell.net, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH -mm v4 7/9] atmel_serial: Add DMA support
Message-ID: <20080128105909.0fa8a431@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080126220200.368742e7.akpm@linux-foundation.org>
References: <1201178511-12133-1-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-2-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-3-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-4-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-5-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-6-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-7-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-8-git-send-email-hskinnemoen@atmel.com>
	<20080126220200.368742e7.akpm@linux-foundation.org>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jan 2008 22:02:00 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Thu, 24 Jan 2008 13:41:49 +0100 Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> > +#define PDC_RX_BUF(port)	&(port)->pdc_rx[(port)->pdc_rx_idx]
> > +#define PDC_RX_SWITCH(port)	(port)->pdc_rx_idx = !(port)->pdc_rx_idx
> 
> These macros refer to their arg more than one time and hance are dangerous.
> Think of the effects of PDC_RX_BUF(foo++).

They're also unused...I'll remove them.

> Generally, please don't use macros for anything which can be coded as a
> regular C function.

Agree.

> > +/*
> > + * Called from tasklet with ENDTX and TXBUFE interrupts disabled.
> > + */
> > +static void atmel_tx_dma(struct uart_port *port)
> > +{
> > +	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
> > +	struct circ_buf *xmit = &port->info->xmit;
> > +	struct atmel_dma_buffer *pdc = &atmel_port->pdc_tx;
> > +	int count;
> > +
> > +	xmit->tail += pdc->ofs;
> > +	if (xmit->tail >= SERIAL_XMIT_SIZE)
> > +		xmit->tail -= SERIAL_XMIT_SIZE;
> 
> Maybe this should be a uart_circ_whatever() helper rather than open-coded.

Hmm. uart_circ_get_multiple() or something?

Also, we should probably be using UART_XMIT_SIZE here, not
SERIAL_XMIT_SIZE. Why do we have two such definitions (which both
happen to be PAGE_SIZE)?

> > +	port->icount.tx += pdc->ofs;
> > +	pdc->ofs = 0;
> > +
> > +	if (!uart_circ_empty(xmit)) {
> 
> ho-hum.  The generic uart buffer-handling code does ringbuffers the wrong
> way.  Maybe it has to handle non-power-of-two buffer sizes.

Hmm...I don't understand. What does it do wrong?

> > +		/* more to transmit - setup next transfer */
> > +
> > +		/* disable PDC transmit */
> > +		UART_PUT_PTCR(port, ATMEL_PDC_TXTDIS);
> > +		dma_sync_single_for_device(port->dev,
> > +					   pdc->dma_addr,
> > +					   pdc->dma_size,
> > +					   DMA_TO_DEVICE);
> > +
> > +		if (xmit->tail < xmit->head)
> > +			count = xmit->head - xmit->tail;
> > +		else
> > +			count = SERIAL_XMIT_SIZE - xmit->tail;
> 
> Doesn't uart_circ_chars_pending() do this?

Hmm...no. I think we really want something CIRC_CNT_TO_END()-ish.

> All those uart_circ_*() macros reference their arg more than once and ... 
> you know the deal.

Yeah. Would you like a patch that inline-ifies <linux/circ.h>?

> > +		if (head >= pdc->dma_size)
> > +			head = pdc->dma_size;
> 
> min()?

Absolutely.

> > +		if (likely(head != tail)) {
> > +			dma_sync_single_for_cpu(port->dev, pdc->dma_addr,
> > +					pdc->dma_size, DMA_FROM_DEVICE);
> > +
> > +			count = head - tail;
> 
> No wraparound issues here?

No. "head" is the current offset that the DMA controller is reading
from, while "tail" is the offset we stopped at the last time around.
head will only wrap around when we recycle the DMA buffer, and when
that happens, we explicitly set tail to 0.

Haavard
