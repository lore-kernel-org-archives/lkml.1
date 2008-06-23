Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbYFWXaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbYFWXaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYFWXaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:30:00 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:32462 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751521AbYFWX37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:29:59 -0400
Date: Tue, 24 Jun 2008 03:29:57 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: linux-serial@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -rt] serial: 8250: fix shared interrupts issues under RT
	kernels
Message-ID: <20080623232957.GA5111@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8250's initialization routines relies on the fact that _irqsave spinlock
will disable local hardirqs, so that the driver can issue IRQ-triggering
operations before registering the port in the IRQ chain.

With RT kernels and preemptable hardirqs this isn't true, _irqsave
spinlock does not disable local hardirqs, and this causes following
trace:

$ cat /dev/ttyS1
irq 42: nobody cared (try booting with the "irqpoll" option)
Call Trace:
[C0475EB0] [C0008A98] show_stack+0x4c/0x1ac (unreliable)
[C0475EF0] [C004BBD4] __report_bad_irq+0x34/0xb8
[C0475F10] [C004BD38] note_interrupt+0xe0/0x308
[C0475F50] [C004B09C] thread_simple_irq+0xdc/0x104
[C0475F70] [C004B3FC] do_irqd+0x338/0x3c8
[C0475FC0] [C00398E0] kthread+0xf8/0x100
[C0475FF0] [C0011FE0] original_kernel_thread+0x44/0x60
handlers:
[<c02112c4>] (serial8250_interrupt+0x0/0x138)
Disabling IRQ #42

After this, all serial ports on the given IRQ are non-functional.

To fix the issue we should explicitly disable shared IRQ before
issuing any IRQ-triggering operations.

I also changed spin_lock_irqsave to the ordinary spin_lock, since it
seems to be safe: chain does not contain new port (yet), thus nobody
will interfere us from the ISRs.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/serial/8250.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 76ccef7..702e0d3 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1831,7 +1831,9 @@ static int serial8250_startup(struct uart_port *port)
 		 * the interrupt is enabled.  Delays are necessary to
 		 * allow register changes to become visible.
 		 */
-		spin_lock_irqsave(&up->port.lock, flags);
+		spin_lock(&up->port.lock);
+		if (up->port.flags & UPF_SHARE_IRQ)
+			disable_irq(up->port.irq);
 
 		wait_for_xmitr(up, UART_LSR_THRE);
 		serial_out_sync(up, UART_IER, UART_IER_THRI);
@@ -1843,7 +1845,9 @@ static int serial8250_startup(struct uart_port *port)
 		iir = serial_in(up, UART_IIR);
 		serial_out(up, UART_IER, 0);
 
-		spin_unlock_irqrestore(&up->port.lock, flags);
+		if (up->port.flags & UPF_SHARE_IRQ)
+			enable_irq(up->port.irq);
+		spin_unlock(&up->port.lock);
 
 		/*
 		 * If the interrupt is not reasserted, setup a timer to
-- 
1.5.5.4
