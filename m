Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbYJEQ0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbYJEQ0n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757745AbYJEQWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:22:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57965 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758873AbYJEQWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:22:00 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 60/76] pty: Coding style and polish
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:22:00 +0100
Message-ID: <20081005162154.1997.77611.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've done the heavy lifting now its time to mop up a bit

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/pty.c |   86 +++++++++++++++++++++++++++-------------------------
 1 files changed, 44 insertions(+), 42 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index a391bad..c3ab8c3 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -8,10 +8,12 @@
  *  Added TTY_DO_WRITE_WAKEUP to enable n_tty to send POLL_OUT to
  *      waiting writers -- Sapan Bhatia <sapan@corewars.org>
  *
- *
+ *  When reading this code see also fs/devpts. In particular note that the
+ *  driver_data field is used by the devpts side as a binding to the devpts
+ *  inode.
  */
 
-#include <linux/module.h>	/* For EXPORT_SYMBOL */
+#include <linux/module.h>
 
 #include <linux/errno.h>
 #include <linux/interrupt.h>
@@ -24,26 +26,24 @@
 #include <linux/init.h>
 #include <linux/sysctl.h>
 #include <linux/device.h>
-
-#include <asm/uaccess.h>
-#include <asm/system.h>
+#include <linux/uaccess.h>
 #include <linux/bitops.h>
 #include <linux/devpts_fs.h>
 
+#include <asm/system.h>
+
 /* These are global because they are accessed in tty_io.c */
 #ifdef CONFIG_UNIX98_PTYS
 struct tty_driver *ptm_driver;
 static struct tty_driver *pts_driver;
 #endif
 
-static void pty_close(struct tty_struct * tty, struct file * filp)
+static void pty_close(struct tty_struct *tty, struct file *filp)
 {
-	if (!tty)
-		return;
-	if (tty->driver->subtype == PTY_TYPE_MASTER) {
-		if (tty->count > 1)
-			printk("master pty_close: count = %d!!\n", tty->count);
-	} else {
+	BUG_ON(!tty);
+	if (tty->driver->subtype == PTY_TYPE_MASTER)
+		WARN_ON(tty->count > 1);
+	else {
 		if (tty->count > 2)
 			return;
 	}
@@ -70,13 +70,13 @@ static void pty_close(struct tty_struct * tty, struct file * filp)
  * The unthrottle routine is called by the line discipline to signal
  * that it can receive more characters.  For PTY's, the TTY_THROTTLED
  * flag is always set, to force the line discipline to always call the
- * unthrottle routine when there are fewer than TTY_THRESHOLD_UNTHROTTLE 
+ * unthrottle routine when there are fewer than TTY_THRESHOLD_UNTHROTTLE
  * characters in the queue.  This is necessary since each time this
  * happens, we need to wake up any sleeping processes that could be
  * (1) trying to send data to the pty, or (2) waiting in wait_until_sent()
  * for the pty buffer to be drained.
  */
-static void pty_unthrottle(struct tty_struct * tty)
+static void pty_unthrottle(struct tty_struct *tty)
 {
 	struct tty_struct *o_tty = tty->link;
 
@@ -88,7 +88,7 @@ static void pty_unthrottle(struct tty_struct * tty)
 }
 
 /*
- * WSH 05/24/97: modified to 
+ * WSH 05/24/97: modified to
  *   (1) use space in tty->flip instead of a shared temp buffer
  *	 The flip buffers aren't being used for a pty, so there's lots
  *	 of space available.  The buffer is protected by a per-pty
@@ -101,7 +101,8 @@ static void pty_unthrottle(struct tty_struct * tty)
  * not our partners. We can't just take the other one blindly without
  * risking deadlocks.
  */
-static int pty_write(struct tty_struct * tty, const unsigned char *buf, int count)
+static int pty_write(struct tty_struct *tty, const unsigned char *buf,
+								int count)
 {
 	struct tty_struct *to = tty->link;
 	int	c;
@@ -113,7 +114,7 @@ static int pty_write(struct tty_struct * tty, const unsigned char *buf, int coun
 	if (c > count)
 		c = count;
 	to->ldisc.ops->receive_buf(to, buf, NULL, c);
-	
+
 	return c;
 }
 
@@ -129,17 +130,17 @@ static int pty_write_room(struct tty_struct *tty)
 
 /*
  *	WSH 05/24/97:  Modified for asymmetric MASTER/SLAVE behavior
- *	The chars_in_buffer() value is used by the ldisc select() function 
+ *	The chars_in_buffer() value is used by the ldisc select() function
  *	to hold off writing when chars_in_buffer > WAKEUP_CHARS (== 256).
  *	The pty driver chars_in_buffer() Master/Slave must behave differently:
  *
  *      The Master side needs to allow typed-ahead commands to accumulate
  *      while being canonicalized, so we report "our buffer" as empty until
  *	some threshold is reached, and then report the count. (Any count >
- *	WAKEUP_CHARS is regarded by select() as "full".)  To avoid deadlock 
- *	the count returned must be 0 if no canonical data is available to be 
+ *	WAKEUP_CHARS is regarded by select() as "full".)  To avoid deadlock
+ *	the count returned must be 0 if no canonical data is available to be
  *	read. (The N_TTY ldisc.chars_in_buffer now knows this.)
- *  
+ *
  *	The Slave side passes all characters in raw mode to the Master side's
  *	buffer where they can be read immediately, so in this case we can
  *	return the true count in the buffer.
@@ -156,21 +157,22 @@ static int pty_chars_in_buffer(struct tty_struct *tty)
 	/* The ldisc must report 0 if no characters available to be read */
 	count = to->ldisc.ops->chars_in_buffer(to);
 
-	if (tty->driver->subtype == PTY_TYPE_SLAVE) return count;
+	if (tty->driver->subtype == PTY_TYPE_SLAVE)
+		return count;
 
-	/* Master side driver ... if the other side's read buffer is less than 
+	/* Master side driver ... if the other side's read buffer is less than
 	 * half full, return 0 to allow writers to proceed; otherwise return
-	 * the count.  This leaves a comfortable margin to avoid overflow, 
+	 * the count.  This leaves a comfortable margin to avoid overflow,
 	 * and still allows half a buffer's worth of typed-ahead commands.
 	 */
-	return ((count < N_TTY_BUF_SIZE/2) ? 0 : count);
+	return (count < N_TTY_BUF_SIZE/2) ? 0 : count;
 }
 
 /* Set the lock flag on a pty */
-static int pty_set_lock(struct tty_struct *tty, int __user * arg)
+static int pty_set_lock(struct tty_struct *tty, int __user *arg)
 {
 	int val;
-	if (get_user(val,arg))
+	if (get_user(val, arg))
 		return -EFAULT;
 	if (val)
 		set_bit(TTY_PTY_LOCK, &tty->flags);
@@ -183,13 +185,13 @@ static void pty_flush_buffer(struct tty_struct *tty)
 {
 	struct tty_struct *to = tty->link;
 	unsigned long flags;
-	
+
 	if (!to)
 		return;
-	
+
 	if (to->ldisc.ops->flush_buffer)
 		to->ldisc.ops->flush_buffer(to);
-	
+
 	if (to->packet) {
 		spin_lock_irqsave(&tty->ctrl_lock, flags);
 		tty->ctrl_status |= TIOCPKT_FLUSHWRITE;
@@ -198,7 +200,7 @@ static void pty_flush_buffer(struct tty_struct *tty)
 	}
 }
 
-static int pty_open(struct tty_struct *tty, struct file * filp)
+static int pty_open(struct tty_struct *tty, struct file *filp)
 {
 	int	retval = -ENODEV;
 
@@ -221,10 +223,11 @@ out:
 	return retval;
 }
 
-static void pty_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
+static void pty_set_termios(struct tty_struct *tty,
+					struct ktermios *old_termios)
 {
-        tty->termios->c_cflag &= ~(CSIZE | PARENB);
-        tty->termios->c_cflag |= (CS8 | CREAD);
+	tty->termios->c_cflag &= ~(CSIZE | PARENB);
+	tty->termios->c_cflag |= (CS8 | CREAD);
 }
 
 static int pty_install(struct tty_driver *driver, struct tty_struct *tty)
@@ -254,7 +257,7 @@ static int pty_install(struct tty_driver *driver, struct tty_struct *tty)
 		tty_free_termios(tty);
 		goto free_mem_out;
 	}
-	
+
 	/*
 	 * Everything allocated ... set up the o_tty structure.
 	 */
@@ -381,9 +384,9 @@ static inline void legacy_pty_init(void) { }
  * Otherwise one can eat up all kernel memory by opening /dev/ptmx repeatedly.
  */
 int pty_limit = NR_UNIX98_PTY_DEFAULT;
-static int pty_limit_min = 0;
+static int pty_limit_min;
 static int pty_limit_max = NR_UNIX98_PTY_MAX;
-static int pty_count = 0;
+static int pty_count;
 
 static struct cdev ptmx_cdev;
 
@@ -537,11 +540,10 @@ static int pty_unix98_install(struct tty_driver *driver, struct tty_struct *tty)
 	pty_count++;
 	return 0;
 free_mem_out:
-	kfree(o_tty->termios);
+	pty_unix98_shutdown(o_tty);
 	module_put(o_tty->driver->owner);
 	free_tty_struct(o_tty);
-	kfree(tty->termios_locked);
-	kfree(tty->termios);
+	pty_unix98_shutdown(tty);
 	free_tty_struct(tty);
 	module_put(driver->owner);
 	return -ENOMEM;
@@ -691,13 +693,13 @@ static void __init unix98_pty_init(void)
 		TTY_DRIVER_DYNAMIC_DEV | TTY_DRIVER_DEVPTS_MEM;
 	pts_driver->other = ptm_driver;
 	tty_set_operations(pts_driver, &pty_unix98_ops);
-	
+
 	if (tty_register_driver(ptm_driver))
 		panic("Couldn't register Unix98 ptm driver");
 	if (tty_register_driver(pts_driver))
 		panic("Couldn't register Unix98 pts driver");
 
-	register_sysctl_table(pty_root_table);	
+	register_sysctl_table(pty_root_table);
 
 	/* Now create the /dev/ptmx special device */
 	tty_default_fops(&ptmx_fops);

