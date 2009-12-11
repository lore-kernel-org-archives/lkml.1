Return-Path: <linux-kernel-owner+w=401wt.eu-S934414AbZLKXcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934414AbZLKXcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934684AbZLKXcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:32:06 -0500
Received: from kroah.org ([198.145.64.141]:50466 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934459AbZLKX3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:33 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 50/58] tty: moxa: Kill off the throttle method
Date: Fri, 11 Dec 2009 15:28:34 -0800
Message-Id: <1260574122-10676-50-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The tty flag can be tested so the shadow flag isn't needed

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/moxa.c |   21 +--------------------
 1 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 7ab720f..d180aa9 100644
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
-- 
1.6.5.5

