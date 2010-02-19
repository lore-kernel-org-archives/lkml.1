Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab0BSRG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:06:28 -0500
Received: from kroah.org ([198.145.64.141]:57768 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab0BSRBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:07 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:51 2010
Message-Id: <20100219163251.746419966@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dick Hollenbeck <dick@softplc.com>, Alan Cox <alan@linux.intel.com>,
       Kees Schoenmakers <k.schoenmakers@sigmae.nl>
Subject: [76/93] serial: 8250: add serial transmitter fully empty test
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dick Hollenbeck <dick@softplc.com>

commit bca476139d2ded86be146dae09b06e22548b67f3 upstream.

When controlling an industrial radio modem it can be necessary to
manipulate the handshake lines in order to control the radio modem's
transmitter, from userspace.

The transmitter should not be turned off before all characters have been
transmitted.  serial8250_tx_empty() was reporting that all characters were
transmitted before they actually were.

===

Discovered in parallel with more testing and analysis by Kees Schoenmakers
as follows:

I ran into an NetMos 9835 serial pci board which behaves a little
different than the standard.  This type of expansion board is very common.

"Standard" 8250 compatible devices clear the 'UART_LST_TEMT" bit together
with the "UART_LSR_THRE" bit when writing data to the device.

The NetMos device does it slightly different

I believe that the TEMT bit is coupled to the shift register.  The problem
is that after writing data to the device and very quickly after that one
does call serial8250_tx_empty, it returns the wrong information.

My patch makes the test more robust (and solves the problem) and it does
not affect the already correct devices.

Alan:

  We may yet need to quirk this but now we know which chips we have a
  way to do that should we find this breaks some other 8250 clone with
  dodgy THRE.

Signed-off-by: Dick Hollenbeck <dick@softplc.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Kees Schoenmakers <k.schoenmakers@sigmae.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/8250.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -83,6 +83,9 @@ static unsigned int skip_txen_test; /* f
 
 #define PASS_LIMIT	256
 
+#define BOTH_EMPTY 	(UART_LSR_TEMT | UART_LSR_THRE)
+
+
 /*
  * We default to IRQ0 for the "no irq" hack.   Some
  * machine types want others as well - they're free
@@ -1792,7 +1795,7 @@ static unsigned int serial8250_tx_empty(
 	up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
 	spin_unlock_irqrestore(&up->port.lock, flags);
 
-	return lsr & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
+	return (lsr & BOTH_EMPTY) == BOTH_EMPTY ? TIOCSER_TEMT : 0;
 }
 
 static unsigned int serial8250_get_mctrl(struct uart_port *port)
@@ -1850,8 +1853,6 @@ static void serial8250_break_ctl(struct
 	spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
-#define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
-
 /*
  *	Wait for transmitter & holding register to empty
  */


