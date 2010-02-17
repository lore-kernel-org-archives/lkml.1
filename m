Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782Ab0BQAMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 19:12:07 -0500
Received: from kroah.org ([198.145.64.141]:41532 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933756Ab0BQAMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 19:12:00 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dick Hollenbeck <dick@softplc.com>, Alan Cox <alan@linux.intel.com>,
       Kees Schoenmakers <k.schoenmakers@sigmae.nl>,
       Andrew Morton <akpm@linux-foundation.org>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/1] serial: 8250: add serial transmitter fully empty test
Date: Tue, 16 Feb 2010 16:11:57 -0800
Message-Id: <1266365517-32131-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20100217000217.GC31137@kroah.com>
References: <20100217000217.GC31137@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dick Hollenbeck <dick@softplc.com>

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
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index c3e37c8..e9b15c3 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -83,6 +83,9 @@ static unsigned int skip_txen_test; /* force skip of txen test at init time */
 
 #define PASS_LIMIT	256
 
+#define BOTH_EMPTY 	(UART_LSR_TEMT | UART_LSR_THRE)
+
+
 /*
  * We default to IRQ0 for the "no irq" hack.   Some
  * machine types want others as well - they're free
@@ -1792,7 +1795,7 @@ static unsigned int serial8250_tx_empty(struct uart_port *port)
 	up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
 	spin_unlock_irqrestore(&up->port.lock, flags);
 
-	return lsr & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
+	return (lsr & BOTH_EMPTY) == BOTH_EMPTY ? TIOCSER_TEMT : 0;
 }
 
 static unsigned int serial8250_get_mctrl(struct uart_port *port)
@@ -1850,8 +1853,6 @@ static void serial8250_break_ctl(struct uart_port *port, int break_state)
 	spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
-#define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
-
 /*
  *	Wait for transmitter & holding register to empty
  */
-- 
1.7.0

