Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbZIXPk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbZIXPk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbZIXPk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:40:28 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:31071 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZIXPkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:40:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=TdiTk7iQiJrNwcRGvgKTJjgRYGnErIgiq+etMZdZZEJ0s9QXcWbOMXROkCfdfJe/WD
         W5BAlPB8NWB8KIlogzUBr0C43aSCWBZ/au+o/ocXL8Ouq3xLwF2Oia7yuceD5pyQbT6+
         95vdeiEIZ8S7ObAuN5/4G4lVDYfhMhDWhvUdc=
Date: Thu, 24 Sep 2009 17:40:23 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Cc: Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Message-ID: <20090924154023.GA27480@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes tty_flip_buffer_push being called from hard interrupt context with
low_latency set.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---

Hi, 

I keep running into:

  BUG: sleeping function called from invalid context at kernel/mutex.c:280

in both the throttle and echo paths (see traces below).

Is there a reason why this was not fixed in ftdi_sio (and whiteheat?)
along with the other drivers?

Regards,
Johan Hovold


Call Trace:
[<c1035b6d>] ? do_softirq+0x5d/0x70
[<c1028091>] __might_sleep+0x101/0x130
[<c133db0e>] mutex_lock_nested+0x1e/0x330
[<c1183527>] ?  n_tty_receive_buf+0x437/0x1210
[<c118495b>] tty_throttle+0x1b/0x50
[<c11834d7>] n_tty_receive_buf+0x3e7/0x1210
[<c11865f4>] ? flush_to_ldisc+0x34/0x1c0
[<c1053eeb>] ?  trace_hardirqs_off+0xb/0x10
[<c11866a5>] flush_to_ldisc+0xe5/0x1c0
[<c11867eb>] tty_flip_buffer_push+0x6b/0x80
[<f922cea7>] ftdi_process_read+0x447/0x740 [ftdi_sio]
[<f922d2bb>] ftdi_read_bulk_callback+0x11b/0x270 [ftdi_sio]
[<c1237880>] ?  usb_hcd_unlink_urb_from_ep+0x10/0x40
[<c1237b46>] usb_hcd_giveback_urb+0x36/0x90
[<c124bf96>] uhci_giveback_urb+0x86/0x230
[<c124bda7>] ? uhci_free_td+0x87/0x90
[<c124c60d>] uhci_scan_schedule+0x3ad/0x9f0
[<c124e873>] uhci_irq+0x63/0x160
[<c12376cd>] usb_hcd_irq+0x2d/0x90
[<c106411e>] handle_IRQ_event+0x2e/0xc0
[<c1065ed2>] handle_fasteoi_irq+0x62/0xd0
[<c1005a18>] handle_irq+0x18/0x30
[<c1004f2a>] do_IRQ+0x4a/0xc0
[<c104d2d1>] ? getnstimeofday+0x51/0x110
[<c100356e>] common_interrupt+0x2e/0x34
[<c105007b>] ?  __timecompare_update+0x11b/0x140
[<c1173e4a>] ?  acpi_idle_enter_simple+0x12b/0x156
[<c1268c9e>] cpuidle_idle_call+0x7e/0xe0
[<c1001e6c>] cpu_idle+0x4c/0xa0
[<c1339587>] start_secondary+0x1c3/0x1ca

=================================
[ INFO: inconsistent lock state ]
2.6.31-gkh-1 #35
---------------------------------
inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
(&tty->termios_mutex){?.+...}, at: [<c118495b>] tty_throttle+0x1b/0x50

and 

[<c1035b6d>] ? do_softirq+0x5d/0x70
[<c1028091>] __might_sleep+0x101/0x130
[<c133db0e>] mutex_lock_nested+0x1e/0x330
[<c100d2fb>] ? save_stack_trace+0x2b/0x50
[<c1053d3b>] ? save_trace+0x3b/0xb0
[<c118185e>] echo_set_canon_col+0x1e/0x50
[<c1183bf6>] n_tty_receive_buf+0xb06/0x1210
[<c108d59b>] ?  cache_alloc_refill+0x8b/0x4f0
[<c11865f4>] ? flush_to_ldisc+0x34/0x1c0
[<c1053eeb>] ?  trace_hardirqs_off+0xb/0x10
[<c11866a5>] flush_to_ldisc+0xe5/0x1c0
[<c11867eb>] tty_flip_buffer_push+0x6b/0x80
[<f82a9ea7>] ftdi_process_read+0x447/0x740 [ftdi_sio]
[<f82aa2bb>] ftdi_read_bulk_callback+0x11b/0x270 [ftdi_sio]
[<c1237880>] ?  usb_hcd_unlink_urb_from_ep+0x10/0x40
[<c1237b46>] usb_hcd_giveback_urb+0x36/0x90
[<c124bf96>] uhci_giveback_urb+0x86/0x230
[<c124bda7>] ? uhci_free_td+0x87/0x90
[<c124c60d>] uhci_scan_schedule+0x3ad/0x9f0
[<c124e873>] uhci_irq+0x63/0x160
[<c12376cd>] usb_hcd_irq+0x2d/0x90
[<c106411e>] handle_IRQ_event+0x2e/0xc0
[<c1065ed2>] handle_fasteoi_irq+0x62/0xd0
[<c1005a18>] handle_irq+0x18/0x30
[<c1004f2a>] do_IRQ+0x4a/0xc0
[<c104d2d1>] ? getnstimeofday+0x51/0x110
[<c100356e>] common_interrupt+0x2e/0x34
[<c105007b>] ?  __timecompare_update+0x11b/0x140
[<c1173e4a>] ?  acpi_idle_enter_simple+0x12b/0x156
[<c1268c9e>] cpuidle_idle_call+0x7e/0xe0
[<c1001e6c>] cpu_idle+0x4c/0xa0
[<c1339587>] start_secondary+0x1c3/0x1ca
Sep 22 12:10:04 vostro kernel:
=================================
[ INFO: inconsistent lock state ]
2.6.31-gkh-1 #35
---------------------------------
inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
(&tty->echo_lock){?.+...}, at: [<c118185e>] echo_set_canon_col+0x1e/0x50


 drivers/usb/serial/ftdi_sio.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 4f883b1..0ac2c2f 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1234,7 +1234,6 @@ static int set_serial_info(struct tty_struct *tty,
 					(new_serial.flags & ASYNC_FLAGS));
 	priv->custom_divisor = new_serial.custom_divisor;
 
-	tty->low_latency = (priv->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 	write_latency_timer(port);
 
 check_and_exit:
@@ -1704,9 +1703,6 @@ static int ftdi_open(struct tty_struct *tty, struct usb_serial_port *port)
 	priv->rx_bytes = 0;
 	spin_unlock_irqrestore(&priv->rx_lock, flags);
 
-	if (tty)
-		tty->low_latency = (priv->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
-
 	write_latency_timer(port);
 
 	/* No error checking for this (will get errors later anyway) */
-- 
1.6.4.2

