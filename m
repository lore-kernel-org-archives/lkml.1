Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbYDMRKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbYDMRKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbYDMRKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:10:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46917 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752629AbYDMRKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:10:11 -0400
Date: Sun, 13 Apr 2008 18:06:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] s390 tty: Prepare for put_char to return success/fail
Message-ID: <20080413180608.1cc6f867@core>
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

Put the changes into the drivers first. This will still compile/work but
produce a warning if bisected so can still be debugged

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/s390/char/con3215.c linux-2.6.25-rc8-mm2/drivers/s390/char/con3215.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/s390/char/con3215.c	2008-04-13 12:55:48.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/s390/char/con3215.c	2008-04-13 15:40:58.000000000 +0100
@@ -982,15 +982,16 @@
 /*
  * Put character routine for 3215 ttys
  */
-static void
+static int
 tty3215_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct raw3215_info *raw;
 
 	if (!tty)
-		return;
+		return 0;
 	raw = (struct raw3215_info *) tty->driver_data;
 	raw3215_putchar(raw, ch);
+	return 1;
 }
 
 static void
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/s390/char/sclp_tty.c linux-2.6.25-rc8-mm2/drivers/s390/char/sclp_tty.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/s390/char/sclp_tty.c	2008-04-13 15:36:54.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/s390/char/sclp_tty.c	2008-04-13 15:40:58.000000000 +0100
@@ -412,14 +412,14 @@
  * - including previous characters from sclp_tty_put_char() and strings from
  * sclp_write() without final '\n' - will be written.
  */
-static void
+static int
 sclp_tty_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	sclp_tty_chars[sclp_tty_chars_count++] = ch;
 	if (ch == '\n' || sclp_tty_chars_count >= SCLP_TTY_BUF_SIZE) {
 		sclp_tty_write_string(sclp_tty_chars, sclp_tty_chars_count);
 		sclp_tty_chars_count = 0;
-	}
+	} return 1;
 }
 
 /*
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/s390/char/sclp_vt220.c linux-2.6.25-rc8-mm2/drivers/s390/char/sclp_vt220.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/s390/char/sclp_vt220.c	2008-04-13 15:36:54.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/s390/char/sclp_vt220.c	2008-04-13 15:40:58.000000000 +0100
@@ -524,11 +524,15 @@
  * NOTE: include/linux/tty_driver.h specifies that a character should be
  * ignored if there is no room in the queue. This driver implements a different
  * semantic in that it will block when there is no more room left.
+ *
+ * FIXME: putchar can currently be called from BH and other non blocking
+ * handlers so  this semantic isn't a good idea.
  */
-static void
+static int
 sclp_vt220_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	__sclp_vt220_write(&ch, 1, 0, 0, 1);
+	return 1;
 }
 
 /*
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/s390/char/tty3270.c linux-2.6.25-rc8-mm2/drivers/s390/char/tty3270.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/s390/char/tty3270.c	2008-04-13 12:55:48.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/s390/char/tty3270.c	2008-04-13 15:40:58.000000000 +0100
@@ -965,7 +965,7 @@
  * Insert character into the screen at the current position with the
  * current color and highlight. This function does NOT do cursor movement.
  */
-static void
+static int
 tty3270_put_character(struct tty3270 *tp, char ch)
 {
 	struct tty3270_line *line;
@@ -986,6 +986,7 @@
 	cell->character = tp->view.ascebc[(unsigned int) ch];
 	cell->highlight = tp->highlight;
 	cell->f_color = tp->f_color;
+	return 1;
 }
 
 /*
