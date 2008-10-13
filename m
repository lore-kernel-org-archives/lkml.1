Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbYJMIr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbYJMIr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbYJMIrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:47:17 -0400
Received: from perso1.free.fr ([212.27.63.203]:59522 "EHLO perso1.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994AbYJMIrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:47:16 -0400
XPARM: thesermon.free.fr
XPARAM2: 193.50.29.42
Subject: [RFC][PATCH] tty: remove the BKL in n_tty.c
From: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 13 Oct 2008 10:47:18
To: Ingo Molnar <mingo@elte.hu>
Message-Id: <20081013084719.03972D1B9DE@perso1.free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


By using a bkl tracer, I saw that the opost function in n_tty.c, used when we 
write to the console, requests a lock_kernel(). And since I'm displaying the 
trace during the tracing, I see this lock very often.

The opost and opost_block functions in drivers/char/n_tty.c use 
the bkl to protect the field tty->column.
Actually this attribute seems to be only touched on these two functions and
also we are in user context.

A mutex seems to be sufficient to prevent from race conditions here.
I made some tests by writing on a tty console whith several threads and it
seems to be correct.

I don't know where to post this patch. I'm not sure if the kill-the-bkl is 
still on the air on the -tip tree.

Any comments?

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 708c2b1..55c963f 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -62,6 +62,13 @@
 #define TTY_THRESHOLD_THROTTLE		128 /* now based on remaining room */
 #define TTY_THRESHOLD_UNTHROTTLE 	128
 
+
+/*
+ * This Mutex is used to replace a big kernel lock that protected
+ * the access to tty->column.
+ */
+static DEFINE_MUTEX(tty_column_mutex);
+
 static inline unsigned char *alloc_buf(void)
 {
 	gfp_t prio = in_interrupt() ? GFP_ATOMIC : GFP_KERNEL;
@@ -264,18 +271,19 @@ static inline int is_continuation(unsigned char c, struct tty_struct *tty)
  *	relevant in the world today. If you ever need them, add them here.
  *
  *	Called from both the receive and transmit sides and can be called
- *	re-entrantly. Relies on lock_kernel() for tty->column state.
+ *	re-entrantly.
  */
 
 static int opost(unsigned char c, struct tty_struct *tty)
 {
 	int	space, spaces;
+	int	ret = 0;
 
 	space = tty_write_room(tty);
 	if (!space)
 		return -1;
 
-	lock_kernel();
+	mutex_lock(&tty_column_mutex);
 	if (O_OPOST(tty)) {
 		switch (c) {
 		case '\n':
@@ -283,8 +291,8 @@ static int opost(unsigned char c, struct tty_struct *tty)
 				tty->column = 0;
 			if (O_ONLCR(tty)) {
 				if (space < 2) {
-					unlock_kernel();
-					return -1;
+					ret = -1;
+					goto out;
 				}
 				tty_put_char(tty, '\r');
 				tty->column = 0;
@@ -293,8 +301,7 @@ static int opost(unsigned char c, struct tty_struct *tty)
 			break;
 		case '\r':
 			if (O_ONOCR(tty) && tty->column == 0) {
-				unlock_kernel();
-				return 0;
+				goto out;
 			}
 			if (O_OCRNL(tty)) {
 				c = '\n';
@@ -308,13 +315,12 @@ static int opost(unsigned char c, struct tty_struct *tty)
 			spaces = 8 - (tty->column & 7);
 			if (O_TABDLY(tty) == XTABS) {
 				if (space < spaces) {
-					unlock_kernel();
-					return -1;
+					ret = -1;
+					goto out;
 				}
 				tty->column += spaces;
 				tty->ops->write(tty, "        ", spaces);
-				unlock_kernel();
-				return 0;
+				goto out;
 			}
 			tty->column += spaces;
 			break;
@@ -331,8 +337,9 @@ static int opost(unsigned char c, struct tty_struct *tty)
 		}
 	}
 	tty_put_char(tty, c);
-	unlock_kernel();
-	return 0;
+out:
+	mutex_unlock(&tty_column_mutex);
+	return ret;
 }
 
 /**
@@ -346,8 +353,7 @@ static int opost(unsigned char c, struct tty_struct *tty)
  *	the simple cases normally found and helps to generate blocks of
  *	symbols for the console driver and thus improve performance.
  *
- *	Called from write_chan under the tty layer write lock. Relies
- *	on lock_kernel for the tty->column state.
+ *	Called from write_chan under the tty layer write lock.
  */
 
 static ssize_t opost_block(struct tty_struct *tty,
@@ -363,7 +369,7 @@ static ssize_t opost_block(struct tty_struct *tty,
 	if (nr > space)
 		nr = space;
 
-	lock_kernel();
+	mutex_lock(&tty_column_mutex);
 	for (i = 0, cp = buf; i < nr; i++, cp++) {
 		switch (*cp) {
 		case '\n':
@@ -398,7 +404,8 @@ break_out:
 	if (tty->ops->flush_chars)
 		tty->ops->flush_chars(tty);
 	i = tty->ops->write(tty, buf, i);
-	unlock_kernel();
+
+	mutex_unlock(&tty_column_mutex);
 	return i;
 }
 

