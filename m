Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab0BHKbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 05:31:39 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48802 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753274Ab0BHKbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 05:31:37 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/3] nozomi: Fix mutex handling
To: greg@kroah.com, linux-kernel@vger.kernel.org, p.hardwick@option.com
Date: Mon, 08 Feb 2010 10:07:04 +0000
Message-ID: <20100208100650.2794.82836.stgit@localhost.localdomain>
In-Reply-To: <20100208100642.2794.73225.stgit@localhost.localdomain>
References: <20100208100642.2794.73225.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original author didn't realise the kernel lock was a drop while sleep
lock so did clever (and wrong) things to work around the non need to avoid
deadlocks. Remove the cleverness and the comment (as we don't hold the BKL
now anyway in those paths)

Signed-off-by: Alan Cox <alan@linux.intel.com>
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
 

