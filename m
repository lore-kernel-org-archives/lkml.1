Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbYA1KVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbYA1KVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 05:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760256AbYA1KUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 05:20:54 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49730 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760233AbYA1KUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 05:20:53 -0500
Date: Mon, 28 Jan 2008 02:20:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux@maxim.org.za, linux@bohmer.net, coldwell@redhat.com,
       marc.pignat@hevs.ch, david-b@pacbell.net, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH -mm v4 7/9] atmel_serial: Add DMA support
Message-Id: <20080128022000.82ac86ab.akpm@linux-foundation.org>
In-Reply-To: <20080128105909.0fa8a431@dhcp-252-066.norway.atmel.com>
References: <1201178511-12133-1-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-2-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-3-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-4-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-5-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-6-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-7-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-8-git-send-email-hskinnemoen@atmel.com>
	<20080126220200.368742e7.akpm@linux-foundation.org>
	<20080128105909.0fa8a431@dhcp-252-066.norway.atmel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 10:59:09 +0100 Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> > ho-hum.  The generic uart buffer-handling code does ringbuffers the wrong
> > way.  Maybe it has to handle non-power-of-two buffer sizes.
> 
> Hmm...I don't understand. What does it do wrong?

An faq ;) If the buffer size is a power-of-two it's better to allow the
head and tail indices wrap through 0xffffffff and only mask them when
subscripting.  It ends up faster (usually) and you can use all of the
elements of the buffer (rather than all-1) and you get nice things like:

is_empty = (head == tail)
is_full = (tail - head == size)
nr_items_in_ring = (tail - head)


> > > +		/* more to transmit - setup next transfer */
> > > +
> > > +		/* disable PDC transmit */
> > > +		UART_PUT_PTCR(port, ATMEL_PDC_TXTDIS);
> > > +		dma_sync_single_for_device(port->dev,
> > > +					   pdc->dma_addr,
> > > +					   pdc->dma_size,
> > > +					   DMA_TO_DEVICE);
> > > +
> > > +		if (xmit->tail < xmit->head)
> > > +			count = xmit->head - xmit->tail;
> > > +		else
> > > +			count = SERIAL_XMIT_SIZE - xmit->tail;
> > 
> > Doesn't uart_circ_chars_pending() do this?
> 
> Hmm...no. I think we really want something CIRC_CNT_TO_END()-ish.
> 
> > All those uart_circ_*() macros reference their arg more than once and ... 
> > you know the deal.
> 
> Yeah. Would you like a patch that inline-ifies <linux/circ.h>?

uh, if you're feeling especially keen.  We have bigger problems than this.


