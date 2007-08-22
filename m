Return-Path: <linux-kernel-owner+w=401wt.eu-S933241AbXHVUv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241AbXHVUv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763556AbXHVUvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:51:11 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:60924 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763533AbXHVUvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:51:09 -0400
Message-id: <22068254782054229736@wsc.cz>
In-reply-to: <2817865042758628064@wsc.cz>
Subject: [PATCH 3/3] Char: moxa, remove sleep_on
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed, 22 Aug 2007 22:52:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

moxa, remove sleep_on

interruptible_sleep_on is deprecated, use completion instead

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 81f45eb6929a344f932898f0dc7f93eec7fa399f
tree 1d5a05887985ef477fdf23d617dd6abfcd8b4e92
parent e55700b17d5769d01c935fe6ba54d9562b934591
author Jiri Slaby <jirislaby@gmail.com> Sat, 18 Aug 2007 16:19:49 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 18 Aug 2007 16:19:49 +0200

 drivers/char/moxa.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 40ac6de..2fc255a 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -41,6 +41,7 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
+#include <linux/completion.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -142,7 +143,7 @@ struct moxa_port {
 	struct tty_struct *tty;
 	int cflag;
 	wait_queue_head_t open_wait;
-	wait_queue_head_t close_wait;
+	struct completion close_wait;
 
 	struct timer_list emptyTimer;
 
@@ -374,7 +375,7 @@ static int __init moxa_init(void)
 		ch->closing_wait = 30 * HZ;
 		ch->cflag = B9600 | CS8 | CREAD | CLOCAL | HUPCL;
 		init_waitqueue_head(&ch->open_wait);
-		init_waitqueue_head(&ch->close_wait);
+		init_completion(&ch->close_wait);
 
 		setup_timer(&ch->emptyTimer, moxa_check_xmit_empty,
 				(unsigned long)ch);
@@ -577,7 +578,7 @@ static void moxa_close(struct tty_struct *tty, struct file *filp)
 		wake_up_interruptible(&ch->open_wait);
 	}
 	ch->asyncflags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_CLOSING);
-	wake_up_interruptible(&ch->close_wait);
+	complete_all(&ch->close_wait);
 }
 
 static int moxa_write(struct tty_struct *tty,
@@ -941,7 +942,7 @@ static int moxa_block_till_ready(struct tty_struct *tty, struct file *filp,
 	 */
 	if (tty_hung_up_p(filp) || (ch->asyncflags & ASYNC_CLOSING)) {
 		if (ch->asyncflags & ASYNC_CLOSING)
-			interruptible_sleep_on(&ch->close_wait);
+			wait_for_completion_interruptible(&ch->close_wait);
 #ifdef SERIAL_DO_RESTART
 		if (ch->asyncflags & ASYNC_HUP_NOTIFY)
 			return (-EAGAIN);
