Return-Path: <linux-kernel-owner+w=401wt.eu-S935073AbXGRSSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935073AbXGRSSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762759AbXGRSR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:17:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44488 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbXGRSR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:17:58 -0400
Date: Wed, 18 Jul 2007 19:17:53 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Paul Fulghum <paulkf@microgate.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>
Subject: Re: [PATCH] Use tty_schedule in VT code.
In-Reply-To: <alpine.LFD.0.999.0707171340360.27353@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707181821150.28741@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org>
 <alpine.LFD.0.999.0707171222060.27353@woody.linux-foundation.org>
 <469D2810.9080109@microgate.com> <alpine.LFD.0.999.0707171243220.27353@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707172050180.9131@pentafluge.infradead.org>
 <alpine.LFD.0.999.0707171340360.27353@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > What should be done is 
> > 
> >         if (tty->low_latency)
> >                 flush_to_ldisc(&tty->buf.work.work);
> >         else
> >                 schedule_delayed_work(&tty->buf.work, 1);
> > 
> > Is this acceptable to you?
> 
> In that case, we might as well just always do the scheduled_delayed_work() 
> with a zero timeout as per the earlier patch. I'd still like to know who 
> *cares*, though? Why not leave it at 1?

I have no problem leaving at one. Here is the new patch. I did address the 
problem with tty_flip_buffer_push in this patch. It is possible for a 
driver to call tty_flip_buffer_push within a interrupt context if they
set the low_latency flag.

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
index de37ebc..8533173 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -3647,11 +3647,7 @@ void tty_flip_buffer_push(struct tty_struct *tty)
 	if (tty->buf.tail != NULL)
 		tty->buf.tail->commit = tty->buf.tail->used;
 	spin_unlock_irqrestore(&tty->buf.lock, flags);
-
-	if (tty->low_latency)
-		flush_to_ldisc(&tty->buf.work.work);
-	else
-		schedule_delayed_work(&tty->buf.work, 1);
+	schedule_delayed_work(&tty->buf.work, 1);
 }
 
 EXPORT_SYMBOL(tty_flip_buffer_push);
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
