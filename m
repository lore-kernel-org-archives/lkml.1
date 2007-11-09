Return-Path: <linux-kernel-owner+w=401wt.eu-S1763469AbXKIXtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763469AbXKIXtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:49:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761133AbXKIXsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:48:54 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57244 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761493AbXKIXsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:48:53 -0500
Message-id: <25311158751454229887.slaby@pripojeni.net>
In-reply-to: <10551261882075921134.slaby@pripojeni.net>
Subject: [RFC 9/13] Char: nozomi, lock cleanup
From: Jiri Slaby <jirislaby@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: Frank Seidel <fseidel@suse.de>
Date: Fri, 9 Nov 2007 18:48:53 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nozomi, lock cleanup

- semaphore is deprecated, use mutex instead
- don't return -ERESTARTSYS when signal might not be pending since it's not
  permitted (unknown retval mioght reach userspace)
- don't lock interruptible in close or the card might not be stopped on last
  close

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 19a0196a97ed70efdc421b359e28684e058d7121
tree 1c65691920ac6efddc7d9e221ee302a0b32b2831
parent d0b01ce89a7b18ba37ea6192eea6a98cdc01d62e
author Jiri Slaby <jirislaby@gmail.com> Mon, 05 Nov 2007 13:53:39 +0100
committer Jiri Slaby <jirislaby@gmail.com> Sat, 10 Nov 2007 00:13:46 +0100

 drivers/char/nozomi.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 4a3ab38..2c4d388 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -406,7 +406,7 @@ struct port {
 
 	struct tty_struct *tty;
 	int tty_open_count;
-	struct semaphore tty_sem;
+	struct mutex tty_sem;
 	wait_queue_head_t tty_wait;
 	struct async_icount tty_icount;
 };
@@ -1560,7 +1560,7 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 	dc->index_start = ndev_idx * NOZOMI_MAX_PORTS;
 	ndevs[ndev_idx] = dc;
 	for (i = 0; i < NOZOMI_MAX_PORTS; i++) {
-		init_MUTEX(&dc->port[i].tty_sem);
+		mutex_init(&dc->port[i].tty_sem);
 		dc->port[i].tty_open_count = 0;
 		dc->port[i].tty = NULL;
 		tty_register_device(ntty_driver, dc->index_start + i,
@@ -1687,7 +1687,7 @@ static int ntty_open(struct tty_struct *tty, struct file *file)
 	if (!port || !dc)
 		return -ENODEV;
 
-	if (down_interruptible(&port->tty_sem))
+	if (mutex_lock_interruptible(&port->tty_sem))
 		return -ERESTARTSYS;
 
 	port->tty_open_count++;
@@ -1706,7 +1706,7 @@ static int ntty_open(struct tty_struct *tty, struct file *file)
 		spin_unlock_irqrestore(&dc->spin_mutex, flags);
 	}
 
-	up(&port->tty_sem);
+	mutex_unlock(&port->tty_sem);
 
 	return 0;
 }
@@ -1721,8 +1721,7 @@ static void ntty_close(struct tty_struct *tty, struct file *file)
 	if (!dc || !port)
 		return;
 
-	if (down_interruptible(&port->tty_sem))
-		return;
+	mutex_lock(&port->tty_sem);
 
 	if (!port->tty_open_count)
 		goto exit;
@@ -1739,7 +1738,7 @@ static void ntty_close(struct tty_struct *tty, struct file *file)
 	}
 
 exit:
-	up(&port->tty_sem);
+	mutex_unlock(&port->tty_sem);
 }
 
 /*
@@ -1759,14 +1758,14 @@ static int ntty_write(struct tty_struct *tty, const unsigned char *buffer,
 	if (!dc || !port)
 		return -ENODEV;
 
-	if (unlikely(down_trylock(&port->tty_sem))) {
+	if (unlikely(mutex_trylock(&port->tty_sem))) {
 		/*
 		 * must test lock as tty layer wraps calls
 		 * to this function with BKL
 		 */
 		dev_err(&dc->pdev->dev, "Would have deadlocked - "
-			"return ERESTARTSYS\n");
-		return -ERESTARTSYS;
+			"return EAGAIN\n");
+		return -EAGAIN;
 	}
 
 	if (unlikely(!port->tty_open_count)) {
@@ -1798,7 +1797,7 @@ static int ntty_write(struct tty_struct *tty, const unsigned char *buffer,
 	spin_unlock_irqrestore(&dc->spin_mutex, flags);
 
 exit:
-	up(&port->tty_sem);
+	mutex_unlock(&port->tty_sem);
 	return rval;
 }
 
@@ -1816,7 +1815,7 @@ static int ntty_write_room(struct tty_struct *tty)
 
 	if (!dc || !port)
 		return 0;
-	if (down_trylock(&port->tty_sem))
+	if (mutex_trylock(&port->tty_sem))
 		return 0;
 
 	if (!port->tty_open_count)
@@ -1825,7 +1824,7 @@ static int ntty_write_room(struct tty_struct *tty)
 	room = port->fifo_ul->size - __kfifo_len(port->fifo_ul);
 
 exit:
-	up(&port->tty_sem);
+	mutex_unlock(&port->tty_sem);
 	return room;
 }
 
