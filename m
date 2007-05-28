Return-Path: <linux-kernel-owner+w=401wt.eu-S1761165AbXE1N1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761165AbXE1N1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbXE1N1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:27:09 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:42031 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753360AbXE1N1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:27:06 -0400
Message-id: <200872663611365858@wsc.cz>
In-reply-to: <12191294601255228079@wsc.cz>
Subject: [PATCH 2/8] Char: tty_ioctl, use wait_event_interruptible_timeout
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Mon, 28 May 2007 15:27:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

tty_ioctl, use wait_event_interruptible_timeout

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

---
commit f030662cbc20e758047c5ec07396862761ea8643
tree 113645cd1e51b8469b77022f2c68fdb94ab54449
parent 29f15033f00e36f622d0bcd5a2dd0f9a49981481
author Jiri Slaby <jirislaby@gmail.com> Sat, 26 May 2007 20:56:41 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 26 May 2007 20:56:41 +0200

 drivers/char/tty_ioctl.c |   21 +++------------------
 1 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index 918e24c..2b6a384 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -52,8 +52,6 @@
 
 void tty_wait_until_sent(struct tty_struct * tty, long timeout)
 {
-	DECLARE_WAITQUEUE(wait, current);
-
 #ifdef TTY_DEBUG_WAIT_UNTIL_SENT
 	char buf[64];
 	
@@ -61,26 +59,13 @@ void tty_wait_until_sent(struct tty_struct * tty, long timeout)
 #endif
 	if (!tty->driver->chars_in_buffer)
 		return;
-	add_wait_queue(&tty->write_wait, &wait);
 	if (!timeout)
 		timeout = MAX_SCHEDULE_TIMEOUT;
-	do {
-#ifdef TTY_DEBUG_WAIT_UNTIL_SENT
-		printk(KERN_DEBUG "waiting %s...(%d)\n", tty_name(tty, buf),
-		       tty->driver->chars_in_buffer(tty));
-#endif
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (signal_pending(current))
-			goto stop_waiting;
-		if (!tty->driver->chars_in_buffer(tty))
-			break;
-		timeout = schedule_timeout(timeout);
-	} while (timeout);
+	if (wait_event_interruptible_timeout(tty->write_wait,
+			!tty->driver->chars_in_buffer(tty), timeout))
+		return;
 	if (tty->driver->wait_until_sent)
 		tty->driver->wait_until_sent(tty, timeout);
-stop_waiting:
-	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&tty->write_wait, &wait);
 }
 
 EXPORT_SYMBOL(tty_wait_until_sent);
