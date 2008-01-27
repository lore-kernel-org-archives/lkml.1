Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbYA0GEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbYA0GEf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 01:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757865AbYA0GER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 01:04:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53825 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757856AbYA0GEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 01:04:15 -0500
Date: Sat, 26 Jan 2008 22:02:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux@maxim.org.za, linux@bohmer.net, coldwell@redhat.com,
       marc.pignat@hevs.ch, david-b@pacbell.net, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, hskinnemoen@atmel.com
Subject: Re: [PATCH -mm v4 7/9] atmel_serial: Add DMA support
Message-Id: <20080126220200.368742e7.akpm@linux-foundation.org>
In-Reply-To: <1201178511-12133-8-git-send-email-hskinnemoen@atmel.com>
References: <1201178511-12133-1-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-2-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-3-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-4-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-5-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-6-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-7-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-8-git-send-email-hskinnemoen@atmel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 24 Jan 2008 13:41:49 +0100 Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> From: Chip Coldwell <coldwell@redhat.com>
> 
> This patch is based on the DMA-patch by Chip Coldwell for the
> AT91/AT32 serial USARTS, with some tweaks to make it apply neatly on
> top of the other patches in this series.
> 
> The RX and TX code has been moved to a tasklet and reworked a bit.
> Instead of depending on the ENDRX and TIMEOUT bits in CSR, we simply
> grab as much data as we can from the DMA buffers. I think this closes
> a race where the ENDRX bit is set after we read CSR but before we read
> RPR, although I haven't confirmed this.
> 
> Similarly, the two TX handlers (ENDTX and TXBUFE) have been combined
> into one. Since the current code only uses a single TX buffer, there's
> no point in handling those interrupts separately.
> 
> This also fixes a DMA sync bug in the original patch.
> 
> ...
>  
> +#define PDC_RX_BUF(port)	&(port)->pdc_rx[(port)->pdc_rx_idx]
> +#define PDC_RX_SWITCH(port)	(port)->pdc_rx_idx = !(port)->pdc_rx_idx

These macros refer to their arg more than one time and hance are dangerous.
Think of the effects of PDC_RX_BUF(foo++).

Generally, please don't use macros for anything which can be coded as a
regular C function.

> +/*
> + * Called from tasklet with ENDTX and TXBUFE interrupts disabled.
> + */
> +static void atmel_tx_dma(struct uart_port *port)
> +{
> +	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
> +	struct circ_buf *xmit = &port->info->xmit;
> +	struct atmel_dma_buffer *pdc = &atmel_port->pdc_tx;
> +	int count;
> +
> +	xmit->tail += pdc->ofs;
> +	if (xmit->tail >= SERIAL_XMIT_SIZE)
> +		xmit->tail -= SERIAL_XMIT_SIZE;

Maybe this should be a uart_circ_whatever() helper rather than open-coded.

> +	port->icount.tx += pdc->ofs;
> +	pdc->ofs = 0;
> +
> +	if (!uart_circ_empty(xmit)) {

ho-hum.  The generic uart buffer-handling code does ringbuffers the wrong
way.  Maybe it has to handle non-power-of-two buffer sizes.


> +		/* more to transmit - setup next transfer */
> +
> +		/* disable PDC transmit */
> +		UART_PUT_PTCR(port, ATMEL_PDC_TXTDIS);
> +		dma_sync_single_for_device(port->dev,
> +					   pdc->dma_addr,
> +					   pdc->dma_size,
> +					   DMA_TO_DEVICE);
> +
> +		if (xmit->tail < xmit->head)
> +			count = xmit->head - xmit->tail;
> +		else
> +			count = SERIAL_XMIT_SIZE - xmit->tail;

Doesn't uart_circ_chars_pending() do this?

All those uart_circ_*() macros reference their arg more than once and ... 
you know the deal.

> +		pdc->ofs = count;
> +
> +		UART_PUT_TPR(port, pdc->dma_addr + xmit->tail);
> +		UART_PUT_TCR(port, count);
> +		/* re-enable PDC transmit and interrupts */
> +		UART_PUT_PTCR(port, ATMEL_PDC_TXTEN);
> +		UART_PUT_IER(port, ATMEL_US_ENDTX | ATMEL_US_TXBUFE);
> +	} else {
> +		/* nothing left to transmit - disable the transmitter */
> +
> +		/* disable PDC transmit */
> +		UART_PUT_PTCR(port, ATMEL_PDC_TXTDIS);
>  	}
> -	return IRQ_HANDLED;
> +
> +	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
> +		uart_write_wakeup(port);
>  }
>  
>  static void atmel_rx_from_ring(struct uart_port *port)
> @@ -502,6 +667,76 @@ static void atmel_rx_from_ring(struct uart_port *port)
>  	spin_lock(&port->lock);
>  }
>  
> +static void atmel_rx_from_dma(struct uart_port *port)
> +{
> +	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
> +	struct tty_struct *tty = port->info->tty;
> +	struct atmel_dma_buffer *pdc;
> +	int rx_idx = atmel_port->pdc_rx_idx;
> +	unsigned int head;
> +	unsigned int tail;
> +	unsigned int count;
> +
> +	do {
> +		/* Reset the UART timeout early so that we don't miss one */
> +		UART_PUT_CR(port, ATMEL_US_STTTO);
> +
> +		pdc = &atmel_port->pdc_rx[rx_idx];
> +		head = UART_GET_RPR(port) - pdc->dma_addr;
> +		tail = pdc->ofs;
> +
> +		/* If the PDC has switched buffers, RPR won't contain
> +		 * any address within the current buffer. Since head
> +		 * is unsigned, we just need a one-way comparison to
> +		 * find out.
> +		 *
> +		 * In this case, we just need to consume the entire
> +		 * buffer and resubmit it for DMA. This will clear the
> +		 * ENDRX bit as well, so that we can safely re-enable
> +		 * all interrupts below.
> +		 */
> +		if (head >= pdc->dma_size)
> +			head = pdc->dma_size;

min()?

> +		if (likely(head != tail)) {
> +			dma_sync_single_for_cpu(port->dev, pdc->dma_addr,
> +					pdc->dma_size, DMA_FROM_DEVICE);
> +
> +			count = head - tail;

No wraparound issues here?

> +			tty_insert_flip_string(tty, pdc->buf + pdc->ofs, count);
> +
> +			dma_sync_single_for_device(port->dev, pdc->dma_addr,
> +					pdc->dma_size, DMA_FROM_DEVICE);
> +
> +			port->icount.rx += count;
> +			pdc->ofs = head;
> +		}
> +
> +		/*
> +		 * If the current buffer is full, we need to check if
> +		 * the next one contains any additional data.
> +		 */
> +		if (head >= pdc->dma_size) {
> +			pdc->ofs = 0;
> +			UART_PUT_RNPR(port, pdc->dma_addr);
> +			UART_PUT_RNCR(port, pdc->dma_size);
> +
> +			rx_idx = !rx_idx;
> +			atmel_port->pdc_rx_idx = rx_idx;
> +		}
> +	} while (head >= pdc->dma_size);
> +
> +	/*
> +	 * Drop the lock here since it might end up calling
> +	 * uart_start(), which takes the lock.
> +	 */
> +	spin_unlock(&port->lock);
> +	tty_flip_buffer_push(tty);
> +	spin_lock(&port->lock);
> +
> +	UART_PUT_IER(port, ATMEL_US_ENDRX | ATMEL_US_TIMEOUT);
> +}
> +

