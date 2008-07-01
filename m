Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbYGAPDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbYGAPDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbYGAPC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:02:58 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:17363 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756229AbYGAPC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:02:56 -0400
Date: Tue, 1 Jul 2008 19:02:54 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: [PATCH v2] serial: 8250: fix shared interrupts issues with SMP and
	RT kernels
Message-ID: <20080701150254.GA13390@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080623232957.GA5111@polina.dev.rtsoft.ru> <20080624001221.GA20685@elte.hu> <20080701134343.GA1865@polina.dev.rtsoft.ru> <20080701144353.7285805d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080701144353.7285805d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With SMP kernels _irqsave spinlock disables only local interrupts, while
the shared serial interrupt could be assigned to the CPU that is not
currently starting up the serial port.

This might cause issues because serial8250_startup() routine issues
IRQ-triggering operations before registering the port in the IRQ chain
(though, this is fine to do and done explicitly because we don't want to
process any interrupts on the port startup).

With RT kernels and preemptable hardirqs, _irqsave spinlock does not
disable local hardirqs, and the bug could be reproduced much easily:

$ cat /dev/ttyS0 &
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

On Tue, Jul 01, 2008 at 02:43:53PM +0100, Alan Cox wrote:
> > > again, please let the -rt maintainers sort out which patches need to be 
> > > propagated to upstream maintainers.
> > 
> > This appears to be not only RT issue though. In theory, this can be
> 
> Agreed - RT is showing up a real bug here.
> 
> > triggered on SMP also. Thanks to Daniel Walker for pointing this out.
> 
> It looks correct to me except that you cannot use spin_lock/disable_irq
> in that way safely. You must always disable_irq before taking the lock,
> or prove it is safe and use disable_irq_nosync
> 
> The reason:
> 		CPU#0 spin_lock_... [taken]
> 		CPU#1 IRQ
> 		CPU#1 spin_lock [waits]
> 		CPU#0 disable_irq (deadlock)

This deadlock possibility is interesting by itself, thanks for
mentioning it.

But this can't happen here. IRQ will not grab the up->port.lock,
because port isn't registered in the 8250 IRQ handling chain (yet).

As for _nosync, probably this is good idea indeed, and should be safe
AFAICS.

 drivers/serial/8250.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 76ccef7..cad0c2d 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1831,7 +1831,9 @@ static int serial8250_startup(struct uart_port *port)
 		 * the interrupt is enabled.  Delays are necessary to
 		 * allow register changes to become visible.
 		 */
-		spin_lock_irqsave(&up->port.lock, flags);
+		spin_lock(&up->port.lock);
+		if (up->port.flags & UPF_SHARE_IRQ)
+			disable_irq_nosync(up->port.irq);
 
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

