Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbYDMRqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbYDMRqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYDMRqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:46:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49204 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751970AbYDMRqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:46:33 -0400
Date: Sun, 13 Apr 2008 18:42:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: [PATCH] strip: Fix up strip for the new order
Message-ID: <20080413184205.43d13d3a@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Use the tty baud functions
- Call driver termios methods directly holding the right locking
- Check for a write method

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/net/wireless/strip.c linux-2.6.25-rc8-mm2/drivers/net/wireless/strip.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/net/wireless/strip.c	2008-04-13 15:36:54.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/net/wireless/strip.c	2008-04-13 15:42:02.000000000 +0100
@@ -768,41 +768,17 @@
 /* General routines for STRIP						*/
 
 /*
- * get_baud returns the current baud rate, as one of the constants defined in
- * termbits.h
- * If the user has issued a baud rate override using the 'setserial' command
- * and the logical current rate is set to 38.4, then the true baud rate
- * currently in effect (57.6 or 115.2) is returned.
- */
-static unsigned int get_baud(struct tty_struct *tty)
-{
-	if (!tty || !tty->termios)
-		return (0);
-	if ((tty->termios->c_cflag & CBAUD) == B38400 && tty->driver_data) {
-		struct async_struct *info =
-		    (struct async_struct *) tty->driver_data;
-		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
-			return (B57600);
-		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
-			return (B115200);
-	}
-	return (tty->termios->c_cflag & CBAUD);
-}
-
-/*
  * set_baud sets the baud rate to the rate defined by baudcode
- * Note: The rate B38400 should be avoided, because the user may have
- * issued a 'setserial' speed override to map that to a different speed.
- * We could achieve a true rate of 38400 if we needed to by cancelling
- * any user speed override that is in place, but that might annoy the
- * user, so it is simplest to just avoid using 38400.
- */
-static void set_baud(struct tty_struct *tty, unsigned int baudcode)
-{
-	struct ktermios old_termios = *(tty->termios);
-	tty->termios->c_cflag &= ~CBAUD;	/* Clear the old baud setting */
-	tty->termios->c_cflag |= baudcode;	/* Set the new baud setting */
-	tty->driver->set_termios(tty, &old_termios);
+ */
+static void set_baud(struct tty_struct *tty, speed_t baudrate)
+{
+	struct ktermios old_termios;
+
+	mutex_lock(&tty->termios_mutex);
+	old_termios =*(tty->termios);
+	tty_encode_baud_rate(tty, baudrate, baudrate);
+	tty->ops->set_termios(tty, &old_termios);
+	mutex_unlock(&tty->termios_mutex);
 }
 
 /*
@@ -1217,7 +1193,7 @@
 	strip_info->watchdog_doreset = jiffies + 1 * HZ;
 
 	/* If the user has selected a baud rate above 38.4 see what magic we have to do */
-	if (strip_info->user_baud > B38400) {
+	if (strip_info->user_baud > 38400) {
 		/*
 		 * Subtle stuff: Pay attention :-)
 		 * If the serial port is currently at the user's selected (>38.4) rate,
@@ -1227,17 +1203,17 @@
 		 * issued the ATS304 command last time through, so this time we restore
 		 * the user's selected rate and issue the normal starmode reset string.
 		 */
-		if (strip_info->user_baud == get_baud(tty)) {
+		if (strip_info->user_baud == tty_get_baud_rate(tty)) {
 			static const char b0[] = "ate0q1s304=57600\r";
 			static const char b1[] = "ate0q1s304=115200\r";
 			static const StringDescriptor baudstring[2] =
 			    { {b0, sizeof(b0) - 1}
 			, {b1, sizeof(b1) - 1}
 			};
-			set_baud(tty, B19200);
-			if (strip_info->user_baud == B57600)
+			set_baud(tty, 19200);
+			if (strip_info->user_baud == 57600)
 				s = baudstring[0];
-			else if (strip_info->user_baud == B115200)
+			else if (strip_info->user_baud == 115200)
 				s = baudstring[1];
 			else
 				s = baudstring[1];	/* For now */
@@ -1245,7 +1221,7 @@
 			set_baud(tty, strip_info->user_baud);
 	}
 
-	tty->driver->write(tty, s.string, s.length);
+	tty->ops->write(tty, s.string, s.length);
 #ifdef EXT_COUNTERS
 	strip_info->tx_ebytes += s.length;
 #endif
@@ -1267,7 +1243,7 @@
 
 	if (strip_info->tx_left > 0) {
 		int num_written =
-		    tty->driver->write(tty, strip_info->tx_head,
+		    tty->ops->write(tty, strip_info->tx_head,
 				      strip_info->tx_left);
 		strip_info->tx_left -= num_written;
 		strip_info->tx_head += num_written;
@@ -2457,7 +2433,7 @@
 	strip_info->working = FALSE;
 	strip_info->firmware_level = NoStructure;
 	strip_info->next_command = CompatibilityCommand;
-	strip_info->user_baud = get_baud(strip_info->tty);
+	strip_info->user_baud = tty_get_baud_rate(strip_info->tty);
 
 	printk(KERN_INFO "%s: Initializing Radio.\n",
 	       strip_info->dev->name);
@@ -2630,6 +2606,13 @@
 
 	if (strip_info && strip_info->magic == STRIP_MAGIC)
 		return -EEXIST;
+	
+	/*
+	 * We need a write method.
+	 */
+ 
+	if (tty->ops->write == NULL)
+		return -EOPNOTSUPP;
 
 	/*
 	 * OK.  Find a free STRIP channel to use.
@@ -2652,8 +2635,7 @@
 	tty->disc_data = strip_info;
 	tty->receive_room = 65536;
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	tty_driver_flush_buffer(tty);
 
 	/*
 	 * Restore default settings
