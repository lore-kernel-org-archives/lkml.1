Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbXLQSN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbXLQSN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 13:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756218AbXLQSNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 13:13:46 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53404 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753733AbXLQSNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 13:13:45 -0500
Date: Mon, 17 Dec 2007 19:13:02 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Remy Bohmer" <linux@bohmer.net>
Cc: "Andrew Victor" <linux@maxim.org.za>, RT <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Atmel Serial Console interrupt handler splitup
Message-ID: <20071217191302.7385f8cc@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20071217131701.6b2cdf2c@dhcp-252-066.norway.atmel.com>
References: <3efb10970712070724i6fa66666t2b8422329759ce24@mail.gmail.com>
	<Pine.LNX.4.58.0712121606241.23712@gandalf.stny.rr.com>
	<3efb10970712121429l7b41d57md4f826f6aaf4b71@mail.gmail.com>
	<3efb10970712130840r7a2c5f72jca641d1cac545464@mail.gmail.com>
	<cd73a99e0712130933s6f601ef7sed90f48c08d9adaa@mail.gmail.com>
	<3efb10970712131232j5f747420g4aa8b5bd956e3dd3@mail.gmail.com>
	<3efb10970712131235t47a9ceb5y7d9a7d5023d07bf6@mail.gmail.com>
	<3efb10970712140346l1845d563k900d72d8788ac6f5@mail.gmail.com>
	<20071217131701.6b2cdf2c@dhcp-252-066.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 13:17:01 +0100
Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> > 3) NEW: optional:  add-atmel-serial-dma.patch, this merged the DMA
> > code (from Chip Coldwell) in your 2.6.23 patch back on top of this
> > series. Because the AT32 bug is not been fixed for a very long time, I
> > do not expect it to be fixed soon, so I think a reordering is better
> > to make preempt-RT work on AT91.  
> 
> I'll give it a shot, but first I have some comments on your other
> patches.

I found a bug. The RX DMA buffer isn't invalidated before it's handed
over to the hardware. With the below patch, it seems to behave a lot
better on AVR32, but it still does funny things now and then (it seems
to dump a good chunk of stale TX data before rebooting), and magic sysrq
doesn't work.

I think I've spotted other potential races in the DMA code as well, but
they look a bit more difficult to hunt down. I'll give it another try
tomorrow.

Haavard

From: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] atmel_serial: Sync DMA RX buffer after copying from it

Calling dma_sync_single_for_cpu() before reading the buffer isn't
enough. We need to call dma_sync_single_for_device() after we're done
reading as well.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/serial/atmel_serial.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 0610ad9..e23a3ba 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -391,6 +391,8 @@ static void atmel_pdc_endrx(struct uart_port *port)
 		tty_insert_flip_string(tty, pdc->buf + pdc->ofs, count);
 		tty_flip_buffer_push(tty);
 
+		dma_sync_single_for_device(port->dev, pdc->dma_addr,
+				pdc->dma_size, DMA_FROM_DEVICE);
 		port->icount.rx += count;
 	}
 
@@ -425,6 +427,8 @@ static void atmel_pdc_timeout(struct uart_port *port)
 		tty_insert_flip_string(tty, pdc->buf + pdc->ofs, count);
 		tty_flip_buffer_push(tty);
 
+		dma_sync_single_for_device(port->dev, pdc->dma_addr,
+				pdc->dma_size, DMA_FROM_DEVICE);
 		pdc->ofs = ofs;
 		port->icount.rx += count;
 	}
-- 
1.5.3.4

