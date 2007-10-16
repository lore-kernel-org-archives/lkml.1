Return-Path: <linux-kernel-owner+w=401wt.eu-S965273AbXJPSMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965273AbXJPSMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964807AbXJPSMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:12:24 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:46094 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934844AbXJPSMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:12:22 -0400
Date: Tue, 16 Oct 2007 19:12:11 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tty_ioctl: Fix the baud_table check in encode_baud_rate
Message-ID: <Pine.LNX.4.64N.0710161857280.22596@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 The tty_termios_encode_baud_rate() function as defined by tty_ioctl.c has 
a problem with the baud_table within.  The comparison operators are 
reversed and as a result this table's entries never match and BOTHER is 
always used.

 Additionally this function's prototype is not exported unlike the 
function itself.

 This fix addresses both issues.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 It has been tested with checkpatch.pl and at the run time, with a serial 
driver (dz) for which I have a change to be submitted soon that will make 
it use the function.  The hardware being handled only supports some 
discrete baud rates (a choice of 15 fixed settings plus an external rate 
input), which is why it wants to adjust termios settings according to the 
rate setting actually chosen.

 Please apply,

  Maciej

patch-mips-2.6.23-rc5-20070904-termios-baud-rate-0
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/drivers/char/tty_ioctl.c linux-mips-2.6.23-rc5-20070904/drivers/char/tty_ioctl.c
--- linux-mips-2.6.23-rc5-20070904.macro/drivers/char/tty_ioctl.c	2007-09-04 04:55:31.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/drivers/char/tty_ioctl.c	2007-10-13 23:07:27.000000000 +0000
@@ -227,7 +227,8 @@ EXPORT_SYMBOL(tty_termios_input_baud_rat
  *	when calling this function from the driver termios handler.
  */
 
-void tty_termios_encode_baud_rate(struct ktermios *termios, speed_t ibaud, speed_t obaud)
+void tty_termios_encode_baud_rate(struct ktermios *termios,
+				  speed_t ibaud, speed_t obaud)
 {
 	int i = 0;
 	int ifound = -1, ofound = -1;
@@ -251,12 +252,15 @@ void tty_termios_encode_baud_rate(struct
 	termios->c_cflag &= ~CBAUD;
 
 	do {
-		if (obaud - oclose >= baud_table[i] && obaud + oclose <= baud_table[i]) {
+		if (obaud - oclose <= baud_table[i] &&
+		    obaud + oclose >= baud_table[i]) {
 			termios->c_cflag |= baud_bits[i];
 			ofound = i;
 		}
-		if (ibaud - iclose >= baud_table[i] && ibaud + iclose <= baud_table[i]) {
-			/* For the case input == output don't set IBAUD bits if the user didn't do so */
+		if (ibaud - iclose <= baud_table[i] &&
+		    ibaud + iclose >= baud_table[i]) {
+			/* For the case input == output don't set IBAUD bits
+			   if the user didn't do so */
 			if (ofound != i || ibinput)
 				termios->c_cflag |= (baud_bits[i] << IBSHIFT);
 			ifound = i;
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/include/linux/tty.h linux-mips-2.6.23-rc5-20070904/include/linux/tty.h
--- linux-mips-2.6.23-rc5-20070904.macro/include/linux/tty.h	2007-09-04 04:56:20.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/include/linux/tty.h	2007-10-13 22:06:06.000000000 +0000
@@ -322,6 +322,8 @@ extern void tty_flip_buffer_push(struct 
 extern speed_t tty_get_baud_rate(struct tty_struct *tty);
 extern speed_t tty_termios_baud_rate(struct ktermios *termios);
 extern speed_t tty_termios_input_baud_rate(struct ktermios *termios);
+extern void tty_termios_encode_baud_rate(struct ktermios *termios,
+					 speed_t ibaud, speed_t obaud);
 
 extern struct tty_ldisc *tty_ldisc_ref(struct tty_struct *);
 extern void tty_ldisc_deref(struct tty_ldisc *);
