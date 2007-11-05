Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbXKET3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbXKET3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 14:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbXKET2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 14:28:14 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:47847 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbXKET2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 14:28:08 -0500
Date: Mon, 5 Nov 2007 14:27:47 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 4/6] UML - Console driver cleanups
Message-ID: <20071105192747.GA8798@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Console driver cleanups -
	Changed an instance of foo = bar + foo to foo += bar
	Removed checks of tty->stopped - I don't think the low-level
driver has any business looking at that
	Removed an annoying warning

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/line.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/um/drivers/line.c
===================================================================
--- linux-2.6.orig/arch/um/drivers/line.c	2007-11-05 14:06:09.000000000 -0500
+++ linux-2.6/arch/um/drivers/line.c	2007-11-05 14:13:24.000000000 -0500
@@ -48,7 +48,7 @@ static int write_room(struct line *line)
 	n = line->head - line->tail;
 
 	if (n <= 0)
-		n = LINE_BUFSIZE + n; /* The other case */
+		n += LINE_BUFSIZE; /* The other case */
 	return n - 1;
 }
 
@@ -58,17 +58,10 @@ int line_write_room(struct tty_struct *t
 	unsigned long flags;
 	int room;
 
-	if (tty->stopped)
-		return 0;
-
 	spin_lock_irqsave(&line->lock, flags);
 	room = write_room(line);
 	spin_unlock_irqrestore(&line->lock, flags);
 
-	/*XXX: Warning to remove */
-	if (0 == room)
-		printk(KERN_DEBUG "%s: %s: no room left in buffer\n",
-		       __FUNCTION__,tty->name);
 	return room;
 }
 
@@ -79,8 +72,7 @@ int line_chars_in_buffer(struct tty_stru
 	int ret;
 
 	spin_lock_irqsave(&line->lock, flags);
-
-	/*write_room subtracts 1 for the needed NULL, so we readd it.*/
+	/* write_room subtracts 1 for the needed NULL, so we readd it.*/
 	ret = LINE_BUFSIZE - (write_room(line) + 1);
 	spin_unlock_irqrestore(&line->lock, flags);
 
@@ -184,10 +176,6 @@ void line_flush_buffer(struct tty_struct
 	unsigned long flags;
 	int err;
 
-	/*XXX: copied from line_write, verify if it is correct!*/
-	if (tty->stopped)
-		return;
-
 	spin_lock_irqsave(&line->lock, flags);
 	err = flush_buffer(line);
 	spin_unlock_irqrestore(&line->lock, flags);
@@ -213,9 +201,6 @@ int line_write(struct tty_struct *tty, c
 	unsigned long flags;
 	int n, ret = 0;
 
-	if (tty->stopped)
-		return 0;
-
 	spin_lock_irqsave(&line->lock, flags);
 	if (line->head != line->tail)
 		ret = buffer_data(line, buf, len);
