Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbYDMRYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbYDMRYx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbYDMRYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:24:46 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54837 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751539AbYDMRYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:24:45 -0400
Date: Sun, 13 Apr 2008 18:20:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, paulkf@microgate.com
Subject: [PATCH] synclink series: switch to int put_char method
Message-ID: <20080413182007.283b98b9@core>
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

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/char/synclink.c linux-2.6.25-rc8-mm2/drivers/char/synclink.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/char/synclink.c	2008-04-13 15:36:53.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/char/synclink.c	2008-04-13 15:41:05.000000000 +0100
@@ -2029,10 +2029,11 @@
  * 		
  * Return Value:	None
  */
-static void mgsl_put_char(struct tty_struct *tty, unsigned char ch)
+static int mgsl_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct mgsl_struct *info = (struct mgsl_struct *)tty->driver_data;
 	unsigned long flags;
+	int ret;
 
 	if ( debug_level >= DEBUG_LEVEL_INFO ) {
 		printk( "%s(%d):mgsl_put_char(%d) on %s\n",
@@ -2040,23 +2041,23 @@
 	}		
 	
 	if (mgsl_paranoia_check(info, tty->name, "mgsl_put_char"))
-		return;
+		return 0;
 
 	if (!tty || !info->xmit_buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&info->irq_spinlock,flags);
 	
 	if ( (info->params.mode == MGSL_MODE_ASYNC ) || !info->tx_active ) {
-	
 		if (info->xmit_cnt < SERIAL_XMIT_SIZE - 1) {
 			info->xmit_buf[info->xmit_head++] = ch;
 			info->xmit_head &= SERIAL_XMIT_SIZE-1;
 			info->xmit_cnt++;
+			ret = 1;
 		}
 	}
-	
 	spin_unlock_irqrestore(&info->irq_spinlock,flags);
+	return ret;
 	
 }	/* end of mgsl_put_char() */
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/char/synclink_gt.c linux-2.6.25-rc8-mm2/drivers/char/synclink_gt.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/char/synclink_gt.c	2008-04-13 15:36:53.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/char/synclink_gt.c	2008-04-13 15:40:58.000000000 +0100
@@ -151,7 +151,7 @@
 static void set_termios(struct tty_struct *tty, struct ktermios *old_termios);
 
 static int  write(struct tty_struct *tty, const unsigned char *buf, int count);
-static void put_char(struct tty_struct *tty, unsigned char ch);
+static int put_char(struct tty_struct *tty, unsigned char ch);
 static void send_xchar(struct tty_struct *tty, char ch);
 static void wait_until_sent(struct tty_struct *tty, int timeout);
 static int  write_room(struct tty_struct *tty);
@@ -913,20 +913,24 @@
 	return ret;
 }
 
-static void put_char(struct tty_struct *tty, unsigned char ch)
+static int put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct slgt_info *info = tty->driver_data;
 	unsigned long flags;
+	int ret;
 
 	if (sanity_check(info, tty->name, "put_char"))
-		return;
+		return 0;
 	DBGINFO(("%s put_char(%d)\n", info->device_name, ch));
 	if (!info->tx_buf)
-		return;
+		return 0;
 	spin_lock_irqsave(&info->lock,flags);
-	if (!info->tx_active && (info->tx_count < info->max_frame_size))
+	if (!info->tx_active && (info->tx_count < info->max_frame_size)) {
 		info->tx_buf[info->tx_count++] = ch;
+		ret = 1;
+	}
 	spin_unlock_irqrestore(&info->lock,flags);
+	return ret;
 }
 
 static void send_xchar(struct tty_struct *tty, char ch)
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/char/synclinkmp.c linux-2.6.25-rc8-mm2/drivers/char/synclinkmp.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/char/synclinkmp.c	2008-04-13 15:36:53.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/char/synclinkmp.c	2008-04-13 15:40:58.000000000 +0100
@@ -519,7 +519,7 @@
 static void set_termios(struct tty_struct *tty, struct ktermios *old_termios);
 
 static int  write(struct tty_struct *tty, const unsigned char *buf, int count);
-static void put_char(struct tty_struct *tty, unsigned char ch);
+static int put_char(struct tty_struct *tty, unsigned char ch);
 static void send_xchar(struct tty_struct *tty, char ch);
 static void wait_until_sent(struct tty_struct *tty, int timeout);
 static int  write_room(struct tty_struct *tty);
@@ -1045,10 +1045,11 @@
 
 /* Add a character to the transmit buffer.
  */
-static void put_char(struct tty_struct *tty, unsigned char ch)
+static int put_char(struct tty_struct *tty, unsigned char ch)
 {
 	SLMP_INFO *info = (SLMP_INFO *)tty->driver_data;
 	unsigned long flags;
+	int ret = 0;
 
 	if ( debug_level >= DEBUG_LEVEL_INFO ) {
 		printk( "%s(%d):%s put_char(%d)\n",
@@ -1056,10 +1057,10 @@
 	}
 
 	if (sanity_check(info, tty->name, "put_char"))
-		return;
+		return 0;
 
 	if (!info->tx_buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&info->lock,flags);
 
@@ -1071,10 +1072,12 @@
 			if (info->tx_put >= info->max_frame_size)
 				info->tx_put -= info->max_frame_size;
 			info->tx_count++;
+			ret = 1;
 		}
 	}
 
 	spin_unlock_irqrestore(&info->lock,flags);
+	return ret;
 }
 
 /* Send a high-priority XON/XOFF character
