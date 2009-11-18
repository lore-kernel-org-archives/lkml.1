Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbZKROdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbZKROdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:33:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757309AbZKROdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:33:00 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40615 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757242AbZKROc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:32:59 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 09/12] moxa: Kill off the throttle method
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:16:34 +0000
Message-ID: <20091118141631.3346.87055.stgit@localhost.localdomain>
In-Reply-To: <20091118141354.3346.16910.stgit@localhost.localdomain>
References: <20091118141354.3346.16910.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty flag can be tested so the shadow flag isn't needed

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/moxa.c |   21 +--------------------
 1 files changed, 1 insertions(+), 20 deletions(-)


diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index e6a79b0..b640409 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -154,7 +154,6 @@ struct mon_str {
 #define TXSTOPPED	1
 #define LOWWAIT 	2
 #define EMPTYWAIT	3
-#define THROTTLE	4
 
 #define SERIAL_DO_RESTART
 
@@ -194,8 +193,6 @@ static int moxa_write(struct tty_struct *, const unsigned char *, int);
 static int moxa_write_room(struct tty_struct *);
 static void moxa_flush_buffer(struct tty_struct *);
 static int moxa_chars_in_buffer(struct tty_struct *);
-static void moxa_throttle(struct tty_struct *);
-static void moxa_unthrottle(struct tty_struct *);
 static void moxa_set_termios(struct tty_struct *, struct ktermios *);
 static void moxa_stop(struct tty_struct *);
 static void moxa_start(struct tty_struct *);
@@ -415,8 +412,6 @@ static const struct tty_operations moxa_ops = {
 	.flush_buffer = moxa_flush_buffer,
 	.chars_in_buffer = moxa_chars_in_buffer,
 	.ioctl = moxa_ioctl,
-	.throttle = moxa_throttle,
-	.unthrottle = moxa_unthrottle,
 	.set_termios = moxa_set_termios,
 	.stop = moxa_stop,
 	.start = moxa_start,
@@ -1327,20 +1322,6 @@ static int moxa_tiocmset(struct tty_struct *tty, struct file *file,
 	return 0;
 }
 
-static void moxa_throttle(struct tty_struct *tty)
-{
-	struct moxa_port *ch = tty->driver_data;
-
-	set_bit(THROTTLE, &ch->statusflags);
-}
-
-static void moxa_unthrottle(struct tty_struct *tty)
-{
-	struct moxa_port *ch = tty->driver_data;
-
-	clear_bit(THROTTLE, &ch->statusflags);
-}
-
 static void moxa_set_termios(struct tty_struct *tty,
 		struct ktermios *old_termios)
 {
@@ -1418,7 +1399,7 @@ static int moxa_poll_port(struct moxa_port *p, unsigned int handle,
 			tty_wakeup(tty);
 		}
 
-		if (inited && !test_bit(THROTTLE, &p->statusflags) &&
+		if (inited && !test_bit(TTY_THROTTLED, &tty->flags) &&
 				MoxaPortRxQueue(p) > 0) { /* RX */
 			MoxaPortReadData(p);
 			tty_schedule_flip(tty);

