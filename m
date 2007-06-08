Return-Path: <linux-kernel-owner+w=401wt.eu-S968178AbXFHLPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968178AbXFHLPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 07:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966473AbXFHLO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 07:14:56 -0400
Received: from canuck.infradead.org ([209.217.80.40]:40776 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966359AbXFHLOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 07:14:55 -0400
Subject: [SERIAL] Don't optimise away baud rate changes when BOTHER is used
	(v2)
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, paulus@samba.org
In-Reply-To: <1181133010.4096.26.camel@pmac.infradead.org>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	 <1180012135.8303.89.camel@shinybook.infradead.org>
	 <20070524144109.7bd0f4d0@the-village.bc.nu>
	 <1180014338.8303.95.camel@shinybook.infradead.org>
	 <20070524160559.54c2c639@the-village.bc.nu>
	 <1181133010.4096.26.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 12:14:49 +0100
Message-Id: <1181301289.2801.26.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The uart_set_termios() function will bail out early without bothering to
touch the hardware, if it decides that nothing "relevant" has changed.
Unfortunately, its idea of "relevant" doesn't include c_[io]speed. So if
the baud rate bits are BOTHER and you just change the speed, the change
gets optimised away.

This patch makes it ignore the old Bfoo bits in c_cflag and just check
whether c_ispeed and c_ospeed have changed. Those integers are always
set appropriately for us by set_termios().

This version of the patch lacks the debugging printk which I
accidentally left in the previous one.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index e8be3b5..4480990 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1146,11 +1146,19 @@ static void uart_set_termios(struct tty_struct *tty, struct ktermios *old_termio
 
 	/*
 	 * These are the bits that are used to setup various
-	 * flags in the low level driver.
+	 * flags in the low level driver. We can ignore the Bfoo
+	 * bits in c_cflag; c_[io]speed will always be set
+	 * appropriately by set_termios() in tty_ioctl.c
 	 */
+#ifdef CIBAUD
+#define RELEVANT_CFLAG(cflag)	((cflag) & ~(CIBAUD|CBAUD)
+#else
+#define RELEVANT_CFLAG(cflag)	((cflag) & ~(CIBAUD|CBAUD)
+#endif
 #define RELEVANT_IFLAG(iflag)	((iflag) & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
-
 	if ((cflag ^ old_termios->c_cflag) == 0 &&
+	    tty->termios->c_ospeed == old_termios->c_ospeed &&
+	    tty->termios->c_ispeed == old_termios->c_ispeed &&
 	    RELEVANT_IFLAG(tty->termios->c_iflag ^ old_termios->c_iflag) == 0)
 		return;
 

-- 
dwmw2

