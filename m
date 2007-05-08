Return-Path: <linux-kernel-owner+w=401wt.eu-S1031992AbXEHUKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031992AbXEHUKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967846AbXEHUKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:10:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45459 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967084AbXEHUKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:10:13 -0400
Date: Tue, 8 May 2007 21:10:12 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Linux console project <linuxconsole-dev@lists.sourceforge.net>
Subject: [PATCH] Use tty_schedule in VT code.
Message-ID: <Pine.LNX.4.64.0705082107460.3459@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



This patch has the VT subsystem use tty_schedule_flip instead of 
con_schedule_flip. There are two ways we can approach this. We can
do the below path or extend tty_schedule_flip to accept a time field.
Comments welcomed.

Signed-Off: James Simmons <jsimmons@infradead.org>

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index cb8d691..2db8973 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -303,7 +303,7 @@ static void put_queue(struct vc_data *vc, int ch)
 
 	if (tty) {
 		tty_insert_flip_char(tty, ch, 0);
-		con_schedule_flip(tty);
+		tty_schedule_flip(tty);
 	}
 }
 
@@ -318,7 +318,7 @@ static void puts_queue(struct vc_data *vc, char *cp)
 		tty_insert_flip_char(tty, *cp, 0);
 		cp++;
 	}
-	con_schedule_flip(tty);
+	tty_schedule_flip(tty);
 }
 
 static void applkey(struct vc_data *vc, int key, char mode)
@@ -549,7 +549,7 @@ static void fn_send_intr(struct vc_data *vc)
 	if (!tty)
 		return;
 	tty_insert_flip_char(tty, 0, TTY_BREAK);
-	con_schedule_flip(tty);
+	tty_schedule_flip(tty);
 }
 
 static void fn_scroll_forw(struct vc_data *vc)
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 1bbb45b..c9bbb14 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -1240,7 +1240,7 @@ static void respond_string(const char *p, struct tty_struct *tty)
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
