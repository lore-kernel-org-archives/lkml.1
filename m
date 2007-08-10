Return-Path: <linux-kernel-owner+w=401wt.eu-S1751032AbXHJVlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751032AbXHJVlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbXHJVjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:39:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57124 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753545AbXHJVjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:39:17 -0400
Message-Id: <200708102138.l7ALcfhb010811@imap1.linux-foundation.org>
Subject: [patch 1/6] serial: don't optimise away baud rate changes when BOTHER is used
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, alan@redhat.com, m.kozlowski@tuxland.pl,
       rmk@arm.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 10 Aug 2007 14:38:41 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>

The uart_set_termios() function will bail out early without bothering to
touch the hardware, if it decides that nothing "relevant" has changed. 
Unfortunately, its idea of "relevant" doesn't include c_[io]speed.  So if
the baud rate bits are BOTHER and you just change the speed, the change
gets optimised away.

This patch makes it ignore the old Bfoo bits in c_cflag and just check
whether c_ispeed and c_ospeed have changed.  Those integers are always set
appropriately for us by set_termios().

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/serial/serial_core.c~dont-optimise-away-baud-rate-changes-when-bother-is-used drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~dont-optimise-away-baud-rate-changes-when-bother-is-used
+++ a/drivers/serial/serial_core.c
@@ -1146,11 +1146,14 @@ static void uart_set_termios(struct tty_
 
 	/*
 	 * These are the bits that are used to setup various
-	 * flags in the low level driver.
+	 * flags in the low level driver. We can ignore the Bfoo
+	 * bits in c_cflag; c_[io]speed will always be set
+	 * appropriately by set_termios() in tty_ioctl.c
 	 */
 #define RELEVANT_IFLAG(iflag)	((iflag) & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
-
 	if ((cflag ^ old_termios->c_cflag) == 0 &&
+	    tty->termios->c_ospeed == old_termios->c_ospeed &&
+	    tty->termios->c_ispeed == old_termios->c_ispeed &&
 	    RELEVANT_IFLAG(tty->termios->c_iflag ^ old_termios->c_iflag) == 0)
 		return;
 
_
