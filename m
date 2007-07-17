Return-Path: <linux-kernel-owner+w=401wt.eu-S934392AbXGQSiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934392AbXGQSiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbXGQSh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:37:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58974 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbXGQSh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:37:59 -0400
Date: Tue, 17 Jul 2007 19:37:57 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Linus Torvalds <torvalds@osdl.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>
Subject: [PATCH] Use tty_schedule in VT code. 
Message-ID: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch has the VT subsystem use tty_schedule_flip instead of
con_schedule_flip. The patch has been tested for several weeks 
on my local system and has been in the linuxconsole repository
for some time. Please apply.

Signed-Off: James Simmons <jsimmons@infradead.org>

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index 2ce0af1..68eab40 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -278,7 +278,7 @@ static void put_queue(struct vc_data *vc, int ch)
 
 	if (tty) {
 		tty_insert_flip_char(tty, ch, 0);
-		con_schedule_flip(tty);
+		tty_schedule_flip(tty);
 	}
 }
 
@@ -293,7 +293,7 @@ static void puts_queue(struct vc_data *vc, char *cp)
 		tty_insert_flip_char(tty, *cp, 0);
 		cp++;
 	}
-	con_schedule_flip(tty);
+	tty_schedule_flip(tty);
 }
 
 static void applkey(struct vc_data *vc, int key, char mode)
@@ -533,7 +533,7 @@ static void fn_send_intr(struct vc_data *vc)
 	if (!tty)
 		return;
 	tty_insert_flip_char(tty, 0, TTY_BREAK);
-	con_schedule_flip(tty);
+	tty_schedule_flip(tty);
 }
 
 static void fn_scroll_forw(struct vc_data *vc)
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index de37ebc..34894e5 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -559,7 +559,7 @@ void tty_schedule_flip(struct tty_struct *tty)
 	if (tty->buf.tail != NULL)
 		tty->buf.tail->commit = tty->buf.tail->used;
 	spin_unlock_irqrestore(&tty->buf.lock, flags);
-	schedule_delayed_work(&tty->buf.work, 1);
+	schedule_delayed_work(&tty->buf.work, 0);
 }
 EXPORT_SYMBOL(tty_schedule_flip);
 
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index edb7002..d17cfcd 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -1260,7 +1260,7 @@ static void respond_string(const char *p, struct tty_struct *tty)
 		tty_insert_flip_char(tty, *p, 0);
 		p++;
 	}
-	con_schedule_flip(tty);
+	tty_schedule_flip(tty);
 }
 
 static void cursor_report(struct vc_data *vc, struct tty_struct *tty)
diff --git a/include/linux/kbd_kern.h b/include/linux/kbd_kern.h
index 506ad20..7b24a0d 100644
--- a/include/linux/kbd_kern.h
+++ b/include/linux/kbd_kern.h
@@ -149,16 +149,4 @@ void compute_shiftstate(void);
 
 extern unsigned int keymap_count;
 
-/* console.c */
-
-static inline void con_schedule_flip(struct tty_struct *t)
-{
-	unsigned long flags;
-	spin_lock_irqsave(&t->buf.lock, flags);
-	if (t->buf.tail != NULL)
-		t->buf.tail->commit = t->buf.tail->used;
-	spin_unlock_irqrestore(&t->buf.lock, flags);
-	schedule_delayed_work(&t->buf.work, 0);
-}
-
 #endif
