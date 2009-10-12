Return-Path: <linux-kernel-owner+w=401wt.eu-S1756441AbZJLLpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbZJLLpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 07:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbZJLLpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 07:45:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48517 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754267AbZJLLpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 07:45:03 -0400
Date: Mon, 12 Oct 2009 12:45:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] NULL pointer dereference at IP: [<ffffffff812e9ccb>]
 uart_close+0x2a/0x1e4
Message-ID: <20091012124501.3c1ac94f@lxorguk.ukuu.org.uk>
In-Reply-To: <20091012112504.GA10002@elte.hu>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain>
	<20091012080511.GA22607@elte.hu>
	<20091012091954.GA31171@elte.hu>
	<20091012092713.GA32647@elte.hu>
	<20091012112504.GA10002@elte.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Unfortunately 46d57a449aa13d9c6adcc9d1dbc7b9a0ecfb69d8 is not easy to 
> revert, at all. Would be glad to try any patch - fixes or some manual 
> revert as well (if that's feasible).

The patch doesn't do anything but create local variables of state->port.
I'm now glad I did it that way as it makes it easy to spot the mistake.

the tty_port lock is ->lock, the uart lock is ->lock both are different..

Spot the mistake:

 	if (state->flags & UIF_INITIALIZED) {
 		unsigned long flags;
 		spin_lock_irqsave(&port->lock, flags);
-		port->ops->stop_rx(port);
+		uport->ops->stop_rx(uport);
 		spin_unlock_irqrestore(&port->lock, flags);
 		/*
 		 * Before we drop DTR, make sure the UART transmitter
 		 * has completely drained; this is especially
 		 * important if there is a transmit FIFO!
 		 */
-		uart_wait_until_sent(tty, port->timeout);
+		uart_wait_until_sent(tty, uport->timeout);
 	}


so uart_close takes the wrong lock. I've checked the rest of the patch for
the same error and I don't see any other screwups.

uart: uart_close crash fix

From: Alan Cox <alan@linux.intel.com>

uart_close takes the wrong lock at one point due to a bug introduced in the
port/uport renaming and tty_port local introduction in
46d57a449aa13d9c6adcc9d1dbc7b9a0ecfb69d8. The race in question is very
hard to hit but fortunately Ingo hit it twice..

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/serial/serial_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 1689bda..3005231 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1316,9 +1316,9 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	 */
 	if (port->flags & ASYNC_INITIALIZED) {
 		unsigned long flags;
-		spin_lock_irqsave(&port->lock, flags);
+		spin_lock_irqsave(&uport->lock, flags);
 		uport->ops->stop_rx(uport);
-		spin_unlock_irqrestore(&port->lock, flags);
+		spin_unlock_irqrestore(&uport->lock, flags);
 		/*
 		 * Before we drop DTR, make sure the UART transmitter
 		 * has completely drained; this is especially


