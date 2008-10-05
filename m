Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbYJEQRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbYJEQRt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757184AbYJEQKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:10:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48486 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757174AbYJEQKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:10:50 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 37/76] tty: Move tty_write_message out of kernel/printk
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:10:51 +0100
Message-ID: <20081005161047.1997.23739.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is pure tty code so put it in the tty layer where it can be with the
locking relevant material it uses

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_io.c |   25 +++++++++++++++++++++++++
 kernel/printk.c       |   16 ----------------
 2 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 4c0e4ed..913b502 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1081,6 +1081,31 @@ out:
 	return ret;
 }
 
+/**
+ * tty_write_message - write a message to a certain tty, not just the console.
+ * @tty: the destination tty_struct
+ * @msg: the message to write
+ *
+ * This is used for messages that need to be redirected to a specific tty.
+ * We don't put it into the syslog queue right now maybe in the future if
+ * really needed.
+ *
+ * We must still hold the BKL and test the CLOSING flag for the moment.
+ */
+
+void tty_write_message(struct tty_struct *tty, char *msg)
+{
+	lock_kernel();
+	if (tty) {
+		mutex_lock(&tty->atomic_write_lock);
+		if (tty->ops->write && !test_bit(TTY_CLOSING, &tty->flags))
+			tty->ops->write(tty, msg, strlen(msg));
+		tty_write_unlock(tty);
+	}
+	unlock_kernel();
+	return;
+}
+
 
 /**
  *	tty_write		-	write method for tty device file
diff --git a/kernel/printk.c b/kernel/printk.c
index b51b156..a430fd0 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1291,22 +1291,6 @@ static int __init disable_boot_consoles(void)
 }
 late_initcall(disable_boot_consoles);
 
-/**
- * tty_write_message - write a message to a certain tty, not just the console.
- * @tty: the destination tty_struct
- * @msg: the message to write
- *
- * This is used for messages that need to be redirected to a specific tty.
- * We don't put it into the syslog queue right now maybe in the future if
- * really needed.
- */
-void tty_write_message(struct tty_struct *tty, char *msg)
-{
-	if (tty && tty->ops->write)
-		tty->ops->write(tty, msg, strlen(msg));
-	return;
-}
-
 #if defined CONFIG_PRINTK
 
 /*

