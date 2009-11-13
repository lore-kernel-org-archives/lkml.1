Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbZKMLQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbZKMLQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 06:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbZKMLQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 06:16:52 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52193 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753835AbZKMLQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 06:16:51 -0500
Date: Fri, 13 Nov 2009 11:18:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dick Hollenbeck <dick@softplc.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] 8250 serial transmitter fully empty test
Message-ID: <20091113111840.12302ead@lxorguk.ukuu.org.uk>
In-Reply-To: <4AD61BFE.2000607@softplc.com>
References: <4AD61BFE.2000607@softplc.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got further explanation on this from Kees Schoenmakers who came up
with the same patch and identified the offending devices as well as
testing it didn't seem to break other clones.

So Andrew can we drop this one back in and see if it busts anything
obscure. If it does we now know what to quirk it against should that be a
problem.

--

From: Dick Hollenbeck <dick@softplc.com>

8250: serial transmitter fully empty test

When controlling an industrial radio modem it can be necessary to
manipulate the handshake lines in order to control the radio modem's 
transmitter, from userspace.

The transmitter should not be turned off before all characters have been 
transmitted.  serial8250_tx_empty() was reporting that all characters were
transmitted before they actually were.

----------

Discovered in parallel with more testing and analysis by Kees Schoenmakers
<k.schoenmakers@sigmae.nl> as follows

I ran into an NetMos 9835 serial pci board which behaves a little different
than the standard. This type of expansion board is very common.

"Standard" 8250 compatible devices clear the 'UART_LST_TEMT" bit together
with the "UART_LSR_THRE" bit when writing data to the device.

The NetMos device does it slightly different

I believe that the TEMT bit is coupled to the shift register. The problem is
that after writing data to the device and very quickly after that one does
call serial8250_tx_empty, it returns the wrong information.

My patch makes the test more robust (and solves the problem) and it does not
affect the already correct devices.


[We may yet need to quirk this but now we know which chips we have a way to
 do that should we find this breaks some other 8250 clone  with dodgy THRE
  -- Alan]

-------------

Signed-off-by: Dick Hollenbeck <dick@softplc.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>

--- drivers/serial/8250.c.orig	2009-09-26 14:06:55.000000000 -0500
+++ drivers/serial/8250.c	2009-09-26 14:12:37.000000000 -0500
@@ -81,6 +81,9 @@ static int serial_index(struct uart_port
 
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

