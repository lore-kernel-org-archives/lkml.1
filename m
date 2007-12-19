Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbXLSQKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbXLSQKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbXLSQKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:10:22 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:56737 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752689AbXLSQKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:10:20 -0500
Date: Wed, 19 Dec 2007 17:09:35 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Remy Bohmer" <linux@bohmer.net>
Cc: "Andrew Victor" <linux@maxim.org.za>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       "Russell King" <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org
Subject: Re: [PATCH v2 0/6] atmel_serial: Cleanups, irq handler splitup &
 DMA
Message-ID: <20071219170935.4df62471@dhcp-252-066.norway.atmel.com>
In-Reply-To: <3efb10970712190757m18f8851cq54061ff109790805@mail.gmail.com>
References: <1198077130-9021-1-git-send-email-hskinnemoen@atmel.com>
	<3efb10970712190757m18f8851cq54061ff109790805@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 16:57:04 +0100
"Remy Bohmer" <linux@bohmer.net> wrote:

> Hello Haavard,
> 
> Sorry.. But I get an Oops on Preempt-RT with the latest set of
> patches. I did not see it earlier today with the other set of patches.

Hmm...from the backtrace, it looks like lock recursion -- port->lock is
held for the whole duration of the tasklet, but we somehow end up in
uart_start(), which grabs the lock again.

Could you try the patch below? It's a bit strange that you got an oops
though...

Haavard

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 7967054..948c643 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -666,7 +666,13 @@ static void atmel_rx_from_ring(struct uart_port *port)
 		uart_insert_char(port, status, ATMEL_US_OVRE, c.ch, flg);
 	}
 
+	/*
+	 * Drop the lock here since it might end up calling
+	 * uart_start(), which takes the lock.
+	 */
+	spin_unlock(&port->lock);
 	tty_flip_buffer_push(port->info->tty);
+	spin_lock(&port->lock);
 }
 
 static void atmel_rx_from_dma(struct uart_port *port)
