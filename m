Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab0CBXqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:46:30 -0500
Received: from kroah.org ([198.145.64.141]:51641 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755694Ab0CBXhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:37:07 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 28/36] nozomi: Fix mutex handling
Date: Tue,  2 Mar 2010 15:36:35 -0800
Message-Id: <1267573003-782-28-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The original author didn't realise the kernel lock was a drop while sleep
lock so did clever (and wrong) things to work around the non need to avoid
deadlocks. Remove the cleverness and the comment (as we don't hold the BKL
now anyway in those paths)

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/nozomi.c |   34 ++++++++++++----------------------
 1 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index cd405bc..fac9157 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1693,15 +1693,7 @@ static int ntty_write(struct tty_struct *tty, const unsigned char *buffer,
 	if (!dc || !port)
 		return -ENODEV;
 
-	if (unlikely(!mutex_trylock(&port->tty_sem))) {
-		/*
-		 * must test lock as tty layer wraps calls
-		 * to this function with BKL
-		 */
-		dev_err(&dc->pdev->dev, "Would have deadlocked - "
-			"return EAGAIN\n");
-		return -EAGAIN;
-	}
+	mutex_lock(&port->tty_sem);
 
 	if (unlikely(!port->port.count)) {
 		DBG1(" ");
@@ -1741,25 +1733,23 @@ exit:
  * This method is called by the upper tty layer.
  *   #according to sources N_TTY.c it expects a value >= 0 and
  *    does not check for negative values.
+ *
+ * If the port is unplugged report lots of room and let the bits
+ * dribble away so we don't block anything.
  */
 static int ntty_write_room(struct tty_struct *tty)
 {
 	struct port *port = tty->driver_data;
-	int room = 0;
+	int room = 4096;
 	const struct nozomi *dc = get_dc_by_tty(tty);
 
-	if (!dc || !port)
-		return 0;
-	if (!mutex_trylock(&port->tty_sem))
-		return 0;
-
-	if (!port->port.count)
-		goto exit;
-
-	room = port->fifo_ul.size - kfifo_len(&port->fifo_ul);
-
-exit:
-	mutex_unlock(&port->tty_sem);
+	if (dc) {
+		mutex_lock(&port->tty_sem);
+		if (port->port.count)
+			room = port->fifo_ul.size -
+					kfifo_len(&port->fifo_ul);
+		mutex_unlock(&port->tty_sem);
+	}
 	return room;
 }
 
-- 
1.7.0.1

