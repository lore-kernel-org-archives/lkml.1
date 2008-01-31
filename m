Return-Path: <linux-kernel-owner+w=401wt.eu-S1760071AbYAaPHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071AbYAaPHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbYAaPHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:07:25 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:52259 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753241AbYAaPHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:07:24 -0500
Date: Thu, 31 Jan 2008 16:07:21 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: michael <trimarchi@gandalf.sssup.it>
Cc: Remy Bohmer <linux@bohmer.net>, fabio@gandalf.sssup.it,
       Andrew Victor <linux@maxim.org.za>, Chip Coldwell <coldwell@redhat.com>,
       Marc Pignat <marc.pignat@hevs.ch>, David Brownell <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
Message-ID: <20080131160721.6dddf30e@dhcp-252-066.norway.atmel.com>
In-Reply-To: <47A12A2E.5040309@gandalf.sssup.it>
References: <20080129224316.GA23155@gandalf.sssup.it>
	<479FB2D7.4020804@gandalf.sssup.it>
	<20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>
	<47A051A7.7030004@gandalf.sssup.it>
	<20080130133659.55ebd828@dhcp-252-066.norway.atmel.com>
	<47A09723.7020000@gandalf.sssup.it>
	<20080130164631.7de4f6bd@dhcp-252-066.norway.atmel.com>
	<47A12A2E.5040309@gandalf.sssup.it>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 02:53:50 +0100
michael <trimarchi@gandalf.sssup.it> wrote:

> The overrun still remain. An lrz receive session is impossible using
> full preemption. I will try the dma patch too and test in iso mode for 
> smart card.

Hmm. Seems to work reasonably well on a non-rt kernel -- I get quite a
few overruns, but nothing more than the Zmodem protocol can handle.

It seems to be very sensitive to network traffic though...could it have
something to do with softirq scheduling? Could you try the patch below
and see if you can trigger the error message?

Haavard

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 477950f..c61fcc3 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -337,9 +337,12 @@ atmel_buffer_rx_char(struct uart_port *port, unsigned int status,
 	struct circ_buf *ring = &atmel_port->rx_ring;
 	struct atmel_uart_char *c;
 
-	if (!CIRC_SPACE(ring->head, ring->tail, ATMEL_SERIAL_RINGSIZE))
+	if (!CIRC_SPACE(ring->head, ring->tail, ATMEL_SERIAL_RINGSIZE)) {
+		dev_err(port->dev, "RX ring buffer full, dropping data\n");
+
 		/* Buffer overflow, ignore char */
 		return;
+	}
 
 	c = &((struct atmel_uart_char *)ring->buf)[ring->head];
 	c->status	= status;
