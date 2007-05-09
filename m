Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbXEIU4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbXEIU4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 16:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbXEIU4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 16:56:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50128 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758715AbXEIU4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 16:56:40 -0400
Date: Wed, 9 May 2007 21:56:33 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Paul Fulghum <paulkf@microgate.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Use tty_schedule in VT code.
In-Reply-To: <464235F4.6080006@microgate.com>
Message-ID: <Pine.LNX.4.64.0705092154290.20229@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0705082107460.3459@pentafluge.infradead.org>
 <1178656361.14867.7.camel@x2.microgate.com> <464235F4.6080006@microgate.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Paul Fulghum wrote:
> > As the tty flip buffer code has evolved, that delay value of 1
> > was carried along. It may have had some historical purpose, but
> > I can't figure it out and it appears to have no use currently.
> 
> I looked further back and in the 2.4 kernels this scheduling
> was done with the timer task queue (process receive data on
> next timer tick).
> 
> I guess the schedule_delayed_work() with a time delay of 1
> was the best approximation of the previous behavior.
> 
> There is no logical reason to delay the first attempt at
> processing receive data so schedule_delayed_work() in
> tty_schedule_flip() should be changed to 0 (as was the
> case for con_schedule_flip).
> 
> The schedule_delayed_work in flush_to_ldisc() will continue
> to use a delay of 1 if the ldisc can't accept more data.
> This allows the user app and ldisc to catch up.
> 
> Subsequent calls to tty_schedule_flip won't affect
> this 'back off' delay because once the work is scheduled
> (with a delay of 1) new scheduling calls are ignored for
> the same work structure.
> 
> I've been testing the change to 0 in tty_schedule_flip()
> under various loads and data rates with no ill effects.

Great!!!! Here is the patch updated with the delay value set to zero.

Signed-Off: James Simmons <jsimmons@infradead.org>

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index 1b09450..0027736 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -277,7 +277,7 @@ static void put_queue(struct vc_data *vc, int ch)
 
 	if (tty) {
 		tty_insert_flip_char(tty, ch, 0);
-		con_schedule_flip(tty);
+		tty_schedule_flip(tty);
 	}
 }
 
@@ -292,7 +292,7 @@ static void puts_queue(struct vc_data *vc, char *cp)
 		tty_insert_flip_char(tty, *cp, 0);
 		cp++;
 	}
-	con_schedule_flip(tty);
+	tty_schedule_flip(tty);
 }
 
 static void applkey(struct vc_data *vc, int key, char mode)
@@ -523,7 +523,7 @@ static void fn_send_intr(struct vc_data *vc)
 	if (!tty)
 		return;
 	tty_insert_flip_char(tty, 0, TTY_BREAK);
-	con_schedule_flip(tty);
+	tty_schedule_flip(tty);
 }
 
 static void fn_scroll_forw(struct vc_data *vc)
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 7710a6a..0174c3f 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -530,7 +530,7 @@ void tty_schedule_flip(struct tty_struct *tty)
 	if (tty->buf.tail != NULL)
 		tty->buf.tail->commit = tty->buf.tail->used;
 	spin_unlock_irqrestore(&tty->buf.lock, flags);
-	schedule_delayed_work(&tty->buf.work, 1);
+	schedule_delayed_work(&tty->buf.work, 0);
 }
 EXPORT_SYMBOL(tty_schedule_flip);
 
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index bbd9fc4..283e189 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -1261,7 +1261,7 @@ static void respond_string(const char *p, struct tty_struct *tty)
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


