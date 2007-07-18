Return-Path: <linux-kernel-owner+w=401wt.eu-S935359AbXGRT56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935359AbXGRT56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 15:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757698AbXGRT5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 15:57:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57586 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbXGRT5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 15:57:47 -0400
Date: Wed, 18 Jul 2007 20:57:40 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Paul Fulghum <paulkf@microgate.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>
Subject: Re: [PATCH] Use tty_schedule in VT code.
In-Reply-To: <1184783279.3444.15.camel@x2.microgate.com>
Message-ID: <Pine.LNX.4.64.0707182056170.28741@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org> 
 <alpine.LFD.0.999.0707171222060.27353@woody.linux-foundation.org> 
 <469D2810.9080109@microgate.com>  <alpine.LFD.0.999.0707171243220.27353@woody.linux-foundation.org>
  <Pine.LNX.4.64.0707172050180.9131@pentafluge.infradead.org> 
 <alpine.LFD.0.999.0707171340360.27353@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0707181821150.28741@pentafluge.infradead.org>
 <1184783279.3444.15.camel@x2.microgate.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> While I have no problem with this, it would be a significant
> behavior change (more so than changing the initial delay to 0).
> 
> IIRC, when the serial_core dead lock was being debugged
> (by Russel King with some Dell guy who reported it 1-2 years ago) 
> this change was suggested and rejected because some callers
> are not running at IRQ context and want to use low_latency.
> In the end, I think they decided to leave the correct use of
> low_latency WRT running in IRQ context to the caller.
> 
> It might be safest to drop this portion so you can get the
> obvious part of the patch accepted (consolidating
> the redundant xxx_schedule_flip functions).

Done. I still smell a dead lock issue tho.

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
