Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155Ab0AJJLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab0AJJLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 04:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572Ab0AJJLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 04:11:16 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:51447 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab0AJJLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 04:11:15 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: samuel@sortiz.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       netdev@vger.kernel.org
Subject: [PATCH 1/1] NET: irda, fix potential null dereference
Date: Sun, 10 Jan 2010 10:11:14 +0100
Message-Id: <1263114674-10433-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a potential null dereference in ircomm_tty_close
and ircomm_tty_hangup. There is a check for tty being NULL,
but it is dereferenced earlier. Move the dereference after
the check.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: netdev@vger.kernel.org
---
 net/irda/ircomm/ircomm_tty.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index 811984d..42a7d75 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -491,7 +491,7 @@ static int ircomm_tty_open(struct tty_struct *tty, struct file *filp)
  */
 static void ircomm_tty_close(struct tty_struct *tty, struct file *filp)
 {
-	struct ircomm_tty_cb *self = (struct ircomm_tty_cb *) tty->driver_data;
+	struct ircomm_tty_cb *self;
 	unsigned long flags;
 
 	IRDA_DEBUG(0, "%s()\n", __func__ );
@@ -499,6 +499,8 @@ static void ircomm_tty_close(struct tty_struct *tty, struct file *filp)
 	if (!tty)
 		return;
 
+	self = tty->driver_data;
+
 	IRDA_ASSERT(self != NULL, return;);
 	IRDA_ASSERT(self->magic == IRCOMM_TTY_MAGIC, return;);
 
@@ -999,17 +1001,19 @@ static void ircomm_tty_shutdown(struct ircomm_tty_cb *self)
  */
 static void ircomm_tty_hangup(struct tty_struct *tty)
 {
-	struct ircomm_tty_cb *self = (struct ircomm_tty_cb *) tty->driver_data;
+	struct ircomm_tty_cb *self;
 	unsigned long	flags;
 
 	IRDA_DEBUG(0, "%s()\n", __func__ );
 
-	IRDA_ASSERT(self != NULL, return;);
-	IRDA_ASSERT(self->magic == IRCOMM_TTY_MAGIC, return;);
-
 	if (!tty)
 		return;
 
+	self = tty->driver_data;
+
+	IRDA_ASSERT(self != NULL, return;);
+	IRDA_ASSERT(self->magic == IRCOMM_TTY_MAGIC, return;);
+
 	/* ircomm_tty_flush_buffer(tty); */
 	ircomm_tty_shutdown(self);
 
-- 
1.6.5.7

