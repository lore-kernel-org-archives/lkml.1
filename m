Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbZFPPDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbZFPPDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbZFPPDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:03:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44045 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756172AbZFPPDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:03:31 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 5/9] pty: Narrow the race on ldisc locking
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 16 Jun 2009 17:01:13 +0100
Message-ID: <20090616160108.10041.3646.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090616155552.10041.63479.stgit@t61.ukuu.org.uk>
References: <20090616155552.10041.63479.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The pty code has always been buggy on its ldisc handling. The recent
changes made the window for the race much bigger. Pending fixing it
properly which is not at all trivial, at least make the race small again so
we don't disrupt other dev work.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/pty.c |   53 +++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 40 insertions(+), 13 deletions(-)


diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 5acd29e..daebe1b 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -95,23 +95,34 @@ static void pty_unthrottle(struct tty_struct *tty)
  * a count.
  *
  * FIXME: Our pty_write method is called with our ldisc lock held but
- * not our partners. We can't just take the other one blindly without
- * risking deadlocks.
+ * not our partners. We can't just wait on the other one blindly without
+ * risking deadlocks. At some point when everything has settled down we need
+ * to look into making pty_write at least able to sleep over an ldisc change.
+ *
+ * The return on no ldisc is a bit counter intuitive but the logic works
+ * like this. During an ldisc change the other end will flush its buffers. We
+ * thus return the full length which is identical to the case where we had
+ * proper locking and happened to queue the bytes just before the flush during
+ * the ldisc change.
  */
 static int pty_write(struct tty_struct *tty, const unsigned char *buf,
 								int count)
 {
 	struct tty_struct *to = tty->link;
-	int	c;
+	struct tty_ldisc *ld;
+	int c = count;
 
 	if (!to || tty->stopped)
 		return 0;
-
-	c = to->receive_room;
-	if (c > count)
-		c = count;
-	to->ldisc->ops->receive_buf(to, buf, NULL, c);
-
+	ld = tty_ldisc_ref(to);
+
+	if (ld) {
+		c = to->receive_room;
+		if (c > count)
+			c = count;
+		ld->ops->receive_buf(to, buf, NULL, c);
+		tty_ldisc_deref(ld);
+	}
 	return c;
 }
 
@@ -145,14 +156,23 @@ static int pty_write_room(struct tty_struct *tty)
 static int pty_chars_in_buffer(struct tty_struct *tty)
 {
 	struct tty_struct *to = tty->link;
-	int count;
+	struct tty_ldisc *ld;
+	int count = 0;
 
 	/* We should get the line discipline lock for "tty->link" */
-	if (!to || !to->ldisc->ops->chars_in_buffer)
+	if (!to)
+		return 0;
+	/* We cannot take a sleeping reference here without deadlocking with
+	   an ldisc change - but it doesn't really matter */
+	ld = tty_ldisc_ref(to);
+	if (ld == NULL)
 		return 0;
 
 	/* The ldisc must report 0 if no characters available to be read */
-	count = to->ldisc->ops->chars_in_buffer(to);
+	if (ld->ops->chars_in_buffer)
+		count = ld->ops->chars_in_buffer(to);
+
+	tty_ldisc_deref(ld);
 
 	if (tty->driver->subtype == PTY_TYPE_SLAVE)
 		return count;
@@ -182,12 +202,19 @@ static void pty_flush_buffer(struct tty_struct *tty)
 {
 	struct tty_struct *to = tty->link;
 	unsigned long flags;
+	struct tty_ldisc *ld;
 
 	if (!to)
 		return;
+	ld = tty_ldisc_ref(to);
+
+	/* The other end is changing discipline */
+	if (!ld)
+		return;
 
-	if (to->ldisc->ops->flush_buffer)
+	if (ld->ops->flush_buffer)
 		to->ldisc->ops->flush_buffer(to);
+	tty_ldisc_deref(ld);
 
 	if (to->packet) {
 		spin_lock_irqsave(&tty->ctrl_lock, flags);

