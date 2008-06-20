Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbYFTUPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbYFTUPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756737AbYFTUPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:15:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51947 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755787AbYFTUPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:15:31 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 01/70] tty: Ldisc revamp
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 20:58:05 +0100
Message-ID: <20080620195801.1479.24228.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Move the line disciplines towards a conventional ->ops arrangement. For the
moment the actual 'tty_ldisc' struct in the tty is kept as part of the tty
struct but this can then be changed if it turns out that when it all settles
down we want to refcount ldiscs separately to the tty.

Pull the ldisc code out of /proc and put it with our ldisc code.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/bluetooth/hci_ldisc.c      |    6 -
 drivers/char/cyclades.c            |    3 
 drivers/char/epca.c                |    4 
 drivers/char/ip2/i2lib.c           |    4 
 drivers/char/ip2/ip2main.c         |    7 -
 drivers/char/n_hdlc.c              |    6 -
 drivers/char/n_r3964.c             |    2 
 drivers/char/n_tty.c               |    2 
 drivers/char/pcmcia/synclink_cs.c  |    4 
 drivers/char/pty.c                 |   10 +
 drivers/char/selection.c           |    3 
 drivers/char/synclink.c            |    4 
 drivers/char/synclink_gt.c         |    4 
 drivers/char/synclinkmp.c          |    4 
 drivers/char/tty_io.c              |  336 +++++++++++++++++++++++-------------
 drivers/char/tty_ioctl.c           |   16 +-
 drivers/input/serio/serport.c      |    2 
 drivers/isdn/capi/capi.c           |    4 
 drivers/isdn/gigaset/ser-gigaset.c |    2 
 drivers/net/hamradio/6pack.c       |    2 
 drivers/net/hamradio/mkiss.c       |    2 
 drivers/net/irda/irtty-sir.c       |    2 
 drivers/net/ppp_async.c            |    2 
 drivers/net/ppp_synctty.c          |    2 
 drivers/net/slip.c                 |    2 
 drivers/net/wan/pc300_tty.c        |    4 
 drivers/net/wan/x25_asy.c          |    2 
 drivers/net/wireless/strip.c       |    2 
 fs/proc/proc_tty.c                 |   48 -----
 include/linux/tty.h                |    9 -
 include/linux/tty_ldisc.h          |    7 +
 net/bluetooth/rfcomm/tty.c         |   13 -
 net/irda/ircomm/ircomm_tty.c       |   14 +-
 33 files changed, 287 insertions(+), 247 deletions(-)


diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index e5cd856..69df187 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -282,8 +282,8 @@ static int hci_uart_tty_open(struct tty_struct *tty)
 	/* FIXME: why is this needed. Note don't use ldisc_ref here as the
 	   open path is before the ldisc is referencable */
 
-	if (tty->ldisc.flush_buffer)
-		tty->ldisc.flush_buffer(tty);
+	if (tty->ldisc.ops->flush_buffer)
+		tty->ldisc.ops->flush_buffer(tty);
 	tty_driver_flush_buffer(tty);
 
 	return 0;
@@ -514,7 +514,7 @@ static unsigned int hci_uart_tty_poll(struct tty_struct *tty,
 
 static int __init hci_uart_init(void)
 {
-	static struct tty_ldisc hci_uart_ldisc;
+	static struct tty_ldisc_ops hci_uart_ldisc;
 	int err;
 
 	BT_INFO("HCI UART driver ver %s", VERSION);
diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index ef73e72..2bf4b4a 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -5246,7 +5246,8 @@ cyclades_get_proc_info(char *buf, char **start, off_t offset, int length,
 					HZ, info->idle_stats.recv_bytes,
 					(cur_jifs - info->idle_stats.recv_idle)/
 					HZ, info->idle_stats.overruns,
-					(long)info->tty->ldisc.num);
+					/* FIXME: double check locking */
+					(long)info->tty->ldisc.ops->num);
 			else
 				size = sprintf(buf + len, "%3d %8lu %10lu %8lu "
 					"%10lu %8lu %9lu %6ld\n",
diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index 60a4df7..aa8e19f 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -2262,8 +2262,8 @@ static int pc_ioctl(struct tty_struct *tty, struct file *file,
 			tty_wait_until_sent(tty, 0);
 		} else {
 			/* ldisc lock already held in ioctl */
-			if (tty->ldisc.flush_buffer)
-				tty->ldisc.flush_buffer(tty);
+			if (tty->ldisc.ops->flush_buffer)
+				tty->ldisc.ops->flush_buffer(tty);
 		}
 		unlock_kernel();
 		/* Fall Thru */
diff --git a/drivers/char/ip2/i2lib.c b/drivers/char/ip2/i2lib.c
index 938879c..897468b 100644
--- a/drivers/char/ip2/i2lib.c
+++ b/drivers/char/ip2/i2lib.c
@@ -868,11 +868,11 @@ i2Input(i2ChanStrPtr pCh)
 		amountToMove = count;
 	}
 	// Move the first block
-	pCh->pTTY->ldisc.receive_buf( pCh->pTTY, 
+	pCh->pTTY->ldisc.ops->receive_buf( pCh->pTTY, 
 		 &(pCh->Ibuf[stripIndex]), NULL, amountToMove );
 	// If we needed to wrap, do the second data move
 	if (count > amountToMove) {
-		pCh->pTTY->ldisc.receive_buf( pCh->pTTY, 
+		pCh->pTTY->ldisc.ops->receive_buf( pCh->pTTY, 
 		 pCh->Ibuf, NULL, count - amountToMove );
 	}
 	// Bump and wrap the stripIndex all at once by the amount of data read. This
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index c12cf8f..85f068c 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -1263,11 +1263,12 @@ static void do_input(struct work_struct *work)
 // code duplicated from n_tty (ldisc)
 static inline void  isig(int sig, struct tty_struct *tty, int flush)
 {
+	/* FIXME: This is completely bogus */
 	if (tty->pgrp)
 		kill_pgrp(tty->pgrp, sig, 1);
 	if (flush || !L_NOFLSH(tty)) {
-		if ( tty->ldisc.flush_buffer )  
-			tty->ldisc.flush_buffer(tty);
+		if ( tty->ldisc.ops->flush_buffer )  
+			tty->ldisc.ops->flush_buffer(tty);
 		i2InputFlush( tty->driver_data );
 	}
 }
@@ -1316,7 +1317,7 @@ static void do_status(struct work_struct *work)
 		}
 		tmp = pCh->pTTY->real_raw;
 		pCh->pTTY->real_raw = 0;
-		pCh->pTTY->ldisc.receive_buf( pCh->pTTY, &brkc, &brkf, 1 );
+		pCh->pTTY->ldisc->ops.receive_buf( pCh->pTTY, &brkc, &brkf, 1 );
 		pCh->pTTY->real_raw = tmp;
 	}
 #endif /* NEVER_HAPPENS_AS_SETUP_XXX */
diff --git a/drivers/char/n_hdlc.c b/drivers/char/n_hdlc.c
index a35bfd7..ed4e033 100644
--- a/drivers/char/n_hdlc.c
+++ b/drivers/char/n_hdlc.c
@@ -199,7 +199,7 @@ static void n_hdlc_tty_wakeup(struct tty_struct *tty);
 #define tty2n_hdlc(tty)	((struct n_hdlc *) ((tty)->disc_data))
 #define n_hdlc2tty(n_hdlc)	((n_hdlc)->tty)
 
-static struct tty_ldisc n_hdlc_ldisc = {
+static struct tty_ldisc_ops n_hdlc_ldisc = {
 	.owner		= THIS_MODULE,
 	.magic		= TTY_LDISC_MAGIC,
 	.name		= "hdlc",
@@ -342,8 +342,8 @@ static int n_hdlc_tty_open (struct tty_struct *tty)
 #endif
 	
 	/* Flush any pending characters in the driver and discipline. */
-	if (tty->ldisc.flush_buffer)
-		tty->ldisc.flush_buffer(tty);
+	if (tty->ldisc.ops->flush_buffer)
+		tty->ldisc.ops->flush_buffer(tty);
 
 	tty_driver_flush_buffer(tty);
 		
diff --git a/drivers/char/n_r3964.c b/drivers/char/n_r3964.c
index 9021690..ae377aa 100644
--- a/drivers/char/n_r3964.c
+++ b/drivers/char/n_r3964.c
@@ -143,7 +143,7 @@ static unsigned int r3964_poll(struct tty_struct *tty, struct file *file,
 static void r3964_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 		char *fp, int count);
 
-static struct tty_ldisc tty_ldisc_N_R3964 = {
+static struct tty_ldisc_ops tty_ldisc_N_R3964 = {
 	.owner = THIS_MODULE,
 	.magic = TTY_LDISC_MAGIC,
 	.name = "R3964",
diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 8096389..708c2b1 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -1573,7 +1573,7 @@ static unsigned int normal_poll(struct tty_struct *tty, struct file *file,
 	return mask;
 }
 
-struct tty_ldisc tty_ldisc_N_TTY = {
+struct tty_ldisc_ops tty_ldisc_N_TTY = {
 	.magic           = TTY_LDISC_MAGIC,
 	.name            = "n_tty",
 	.open            = n_tty_open,
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 1dd0e99..95743e2 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -514,8 +514,8 @@ static void ldisc_receive_buf(struct tty_struct *tty,
 		return;
 	ld = tty_ldisc_ref(tty);
 	if (ld) {
-		if (ld->receive_buf)
-			ld->receive_buf(tty, data, flags, count);
+		if (ld->ops->receive_buf)
+			ld->ops->receive_buf(tty, data, flags, count);
 		tty_ldisc_deref(ld);
 	}
 }
diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 0a05c03..76b2793 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -111,7 +111,7 @@ static int pty_write(struct tty_struct * tty, const unsigned char *buf, int coun
 	c = to->receive_room;
 	if (c > count)
 		c = count;
-	to->ldisc.receive_buf(to, buf, NULL, c);
+	to->ldisc.ops->receive_buf(to, buf, NULL, c);
 	
 	return c;
 }
@@ -149,11 +149,11 @@ static int pty_chars_in_buffer(struct tty_struct *tty)
 	int count;
 
 	/* We should get the line discipline lock for "tty->link" */
-	if (!to || !to->ldisc.chars_in_buffer)
+	if (!to || !to->ldisc.ops->chars_in_buffer)
 		return 0;
 
 	/* The ldisc must report 0 if no characters available to be read */
-	count = to->ldisc.chars_in_buffer(to);
+	count = to->ldisc.ops->chars_in_buffer(to);
 
 	if (tty->driver->subtype == PTY_TYPE_SLAVE) return count;
 
@@ -186,8 +186,8 @@ static void pty_flush_buffer(struct tty_struct *tty)
 	if (!to)
 		return;
 	
-	if (to->ldisc.flush_buffer)
-		to->ldisc.flush_buffer(to);
+	if (to->ldisc.ops->flush_buffer)
+		to->ldisc.ops->flush_buffer(to);
 	
 	if (to->packet) {
 		spin_lock_irqsave(&tty->ctrl_lock, flags);
diff --git a/drivers/char/selection.c b/drivers/char/selection.c
index d63f5cc..2978a49 100644
--- a/drivers/char/selection.c
+++ b/drivers/char/selection.c
@@ -327,7 +327,8 @@ int paste_selection(struct tty_struct *tty)
 		}
 		count = sel_buffer_lth - pasted;
 		count = min(count, tty->receive_room);
-		tty->ldisc.receive_buf(tty, sel_buffer + pasted, NULL, count);
+		tty->ldisc.ops->receive_buf(tty, sel_buffer + pasted,
+								NULL, count);
 		pasted += count;
 	}
 	remove_wait_queue(&vc->paste_wait, &wait);
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index ac5080d..5e4b2e6 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -975,8 +975,8 @@ static void ldisc_receive_buf(struct tty_struct *tty,
 		return;
 	ld = tty_ldisc_ref(tty);
 	if (ld) {
-		if (ld->receive_buf)
-			ld->receive_buf(tty, data, flags, count);
+		if (ld->ops->receive_buf)
+			ld->ops->receive_buf(tty, data, flags, count);
 		tty_ldisc_deref(ld);
 	}
 }
diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index 55c1653..e473778 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -641,8 +641,8 @@ static void ldisc_receive_buf(struct tty_struct *tty,
 		return;
 	ld = tty_ldisc_ref(tty);
 	if (ld) {
-		if (ld->receive_buf)
-			ld->receive_buf(tty, data, flags, count);
+		if (ld->ops->receive_buf)
+			ld->ops->receive_buf(tty, data, flags, count);
 		tty_ldisc_deref(ld);
 	}
 }
diff --git a/drivers/char/synclinkmp.c b/drivers/char/synclinkmp.c
index bec5486..5341b5a 100644
--- a/drivers/char/synclinkmp.c
+++ b/drivers/char/synclinkmp.c
@@ -712,8 +712,8 @@ static void ldisc_receive_buf(struct tty_struct *tty,
 		return;
 	ld = tty_ldisc_ref(tty);
 	if (ld) {
-		if (ld->receive_buf)
-			ld->receive_buf(tty, data, flags, count);
+		if (ld->ops->receive_buf)
+			ld->ops->receive_buf(tty, data, flags, count);
 		tty_ldisc_deref(ld);
 	}
 }
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index e94bee0..ab1dd0a 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -95,8 +95,9 @@
 #include <linux/wait.h>
 #include <linux/bitops.h>
 #include <linux/delay.h>
+#include <linux/seq_file.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/system.h>
 
 #include <linux/kbd_kern.h>
@@ -682,7 +683,7 @@ static void tty_set_termios_ldisc(struct tty_struct *tty, int num)
 static DEFINE_SPINLOCK(tty_ldisc_lock);
 static DECLARE_WAIT_QUEUE_HEAD(tty_ldisc_wait);
 /* Line disc dispatch table */
-static struct tty_ldisc tty_ldiscs[NR_LDISCS];
+static struct tty_ldisc_ops *tty_ldiscs[NR_LDISCS];
 
 /**
  *	tty_register_ldisc	-	install a line discipline
@@ -697,7 +698,7 @@ static struct tty_ldisc tty_ldiscs[NR_LDISCS];
  *		takes tty_ldisc_lock to guard against ldisc races
  */
 
-int tty_register_ldisc(int disc, struct tty_ldisc *new_ldisc)
+int tty_register_ldisc(int disc, struct tty_ldisc_ops *new_ldisc)
 {
 	unsigned long flags;
 	int ret = 0;
@@ -706,10 +707,9 @@ int tty_register_ldisc(int disc, struct tty_ldisc *new_ldisc)
 		return -EINVAL;
 
 	spin_lock_irqsave(&tty_ldisc_lock, flags);
-	tty_ldiscs[disc] = *new_ldisc;
-	tty_ldiscs[disc].num = disc;
-	tty_ldiscs[disc].flags |= LDISC_FLAG_DEFINED;
-	tty_ldiscs[disc].refcount = 0;
+	tty_ldiscs[disc] = new_ldisc;
+	new_ldisc->num = disc;
+	new_ldisc->refcount = 0;
 	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
 
 	return ret;
@@ -737,19 +737,56 @@ int tty_unregister_ldisc(int disc)
 		return -EINVAL;
 
 	spin_lock_irqsave(&tty_ldisc_lock, flags);
-	if (tty_ldiscs[disc].refcount)
+	if (tty_ldiscs[disc]->refcount)
 		ret = -EBUSY;
 	else
-		tty_ldiscs[disc].flags &= ~LDISC_FLAG_DEFINED;
+		tty_ldiscs[disc] = NULL;
 	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
 
 	return ret;
 }
 EXPORT_SYMBOL(tty_unregister_ldisc);
 
+
+/**
+ *	tty_ldisc_try_get	-	try and reference an ldisc
+ *	@disc: ldisc number
+ *	@ld: tty ldisc structure to complete
+ *
+ *	Attempt to open and lock a line discipline into place. Return
+ *	the line discipline refcounted and assigned in ld. On an error
+ *	report the error code back
+ */
+
+static int tty_ldisc_try_get(int disc, struct tty_ldisc *ld)
+{
+	unsigned long flags;
+	struct tty_ldisc_ops *ldops;
+	int err = -EINVAL;
+	
+	spin_lock_irqsave(&tty_ldisc_lock, flags);
+	ld->ops = NULL;
+	ldops = tty_ldiscs[disc];
+	/* Check the entry is defined */
+	if (ldops) {
+		/* If the module is being unloaded we can't use it */
+		if (!try_module_get(ldops->owner))
+			err = -EAGAIN;
+		else {
+			/* lock it */
+			ldops->refcount++;
+			ld->ops = ldops;
+			err = 0;
+		}
+	}
+	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+	return err;
+}
+
 /**
  *	tty_ldisc_get		-	take a reference to an ldisc
  *	@disc: ldisc number
+ *	@ld: tty line discipline structure to use
  *
  *	Takes a reference to a line discipline. Deals with refcounts and
  *	module locking counts. Returns NULL if the discipline is not available.
@@ -760,32 +797,20 @@ EXPORT_SYMBOL(tty_unregister_ldisc);
  *		takes tty_ldisc_lock to guard against ldisc races
  */
 
-struct tty_ldisc *tty_ldisc_get(int disc)
+static int tty_ldisc_get(int disc, struct tty_ldisc *ld)
 {
-	unsigned long flags;
-	struct tty_ldisc *ld;
+	int err;
 
 	if (disc < N_TTY || disc >= NR_LDISCS)
-		return NULL;
-
-	spin_lock_irqsave(&tty_ldisc_lock, flags);
-
-	ld = &tty_ldiscs[disc];
-	/* Check the entry is defined */
-	if (ld->flags & LDISC_FLAG_DEFINED) {
-		/* If the module is being unloaded we can't use it */
-		if (!try_module_get(ld->owner))
-			ld = NULL;
-		else /* lock it */
-			ld->refcount++;
-	} else
-		ld = NULL;
-	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
-	return ld;
+		return -EINVAL;
+	err = tty_ldisc_try_get(disc, ld);
+	if (err == -EAGAIN) {
+		request_module("tty-ldisc-%d", disc);
+		err = tty_ldisc_try_get(disc, ld);
+	}
+	return err;
 }
 
-EXPORT_SYMBOL_GPL(tty_ldisc_get);
-
 /**
  *	tty_ldisc_put		-	drop ldisc reference
  *	@disc: ldisc number
@@ -797,22 +822,67 @@ EXPORT_SYMBOL_GPL(tty_ldisc_get);
  *		takes tty_ldisc_lock to guard against ldisc races
  */
 
-void tty_ldisc_put(int disc)
+static void tty_ldisc_put(struct tty_ldisc_ops *ld)
 {
-	struct tty_ldisc *ld;
 	unsigned long flags;
+	int disc = ld->num;
 
 	BUG_ON(disc < N_TTY || disc >= NR_LDISCS);
 
 	spin_lock_irqsave(&tty_ldisc_lock, flags);
-	ld = &tty_ldiscs[disc];
+	ld = tty_ldiscs[disc];
 	BUG_ON(ld->refcount == 0);
 	ld->refcount--;
 	module_put(ld->owner);
 	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
 }
 
-EXPORT_SYMBOL_GPL(tty_ldisc_put);
+static void * tty_ldiscs_seq_start(struct seq_file *m, loff_t *pos)
+{
+	return (*pos < NR_LDISCS) ? pos : NULL;
+}
+
+static void * tty_ldiscs_seq_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	(*pos)++;
+	return (*pos < NR_LDISCS) ? pos : NULL;
+}
+
+static void tty_ldiscs_seq_stop(struct seq_file *m, void *v)
+{
+}
+
+static int tty_ldiscs_seq_show(struct seq_file *m, void *v)
+{
+	int i = *(loff_t *)v;
+	struct tty_ldisc ld;
+	
+	if (tty_ldisc_get(i, &ld) < 0)
+		return 0;
+	seq_printf(m, "%-10s %2d\n", ld.ops->name ? ld.ops->name : "???", i);
+	tty_ldisc_put(ld.ops);
+	return 0;
+}
+
+static const struct seq_operations tty_ldiscs_seq_ops = {
+	.start	= tty_ldiscs_seq_start,
+	.next	= tty_ldiscs_seq_next,
+	.stop	= tty_ldiscs_seq_stop,
+	.show	= tty_ldiscs_seq_show,
+};
+
+static int proc_tty_ldiscs_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &tty_ldiscs_seq_ops);
+}
+
+const struct file_operations tty_ldiscs_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= proc_tty_ldiscs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
 
 /**
  *	tty_ldisc_assign	-	set ldisc on a tty
@@ -829,8 +899,8 @@ EXPORT_SYMBOL_GPL(tty_ldisc_put);
 
 static void tty_ldisc_assign(struct tty_struct *tty, struct tty_ldisc *ld)
 {
+	ld->refcount = 0;
 	tty->ldisc = *ld;
-	tty->ldisc.refcount = 0;
 }
 
 /**
@@ -954,6 +1024,41 @@ static void tty_ldisc_enable(struct tty_struct *tty)
 }
 
 /**
+ *	tty_ldisc_restore	-	helper for tty ldisc change
+ *	@tty: tty to recover
+ *	@old: previous ldisc
+ *
+ *	Restore the previous line discipline or N_TTY when a line discipline
+ *	change fails due to an open error
+ */
+
+static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
+{
+	char buf[64];
+	struct tty_ldisc new_ldisc;
+
+	/* There is an outstanding reference here so this is safe */
+	tty_ldisc_get(old->ops->num, old);
+	tty_ldisc_assign(tty, old);
+	tty_set_termios_ldisc(tty, old->ops->num);
+	if (old->ops->open && (old->ops->open(tty) < 0)) {
+		tty_ldisc_put(old->ops);
+		/* This driver is always present */
+		if (tty_ldisc_get(N_TTY, &new_ldisc) < 0)
+			panic("n_tty: get");
+		tty_ldisc_assign(tty, &new_ldisc);
+		tty_set_termios_ldisc(tty, N_TTY);
+		if (new_ldisc.ops->open) {
+			int r = new_ldisc.ops->open(tty);
+				if (r < 0)
+				panic("Couldn't open N_TTY ldisc for "
+				      "%s --- error %d.",
+				      tty_name(tty, buf), r);
+		}
+	}
+}
+
+/**
  *	tty_set_ldisc		-	set line discipline
  *	@tty: the terminal to set
  *	@ldisc: the line discipline
@@ -967,28 +1072,18 @@ static void tty_ldisc_enable(struct tty_struct *tty)
 
 static int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 {
-	int retval = 0;
-	struct tty_ldisc o_ldisc;
-	char buf[64];
+	int retval;
+	struct tty_ldisc o_ldisc, new_ldisc;
 	int work;
 	unsigned long flags;
-	struct tty_ldisc *ld;
 	struct tty_struct *o_tty;
 
-	if ((ldisc < N_TTY) || (ldisc >= NR_LDISCS))
-		return -EINVAL;
-
 restart:
-
-	ld = tty_ldisc_get(ldisc);
-	/* Eduardo Blanco <ejbs@cs.cs.com.uy> */
-	/* Cyrus Durgin <cider@speakeasy.org> */
-	if (ld == NULL) {
-		request_module("tty-ldisc-%d", ldisc);
-		ld = tty_ldisc_get(ldisc);
-	}
-	if (ld == NULL)
-		return -EINVAL;
+	/* This is a bit ugly for now but means we can break the 'ldisc
+	   is part of the tty struct' assumption later */
+	retval = tty_ldisc_get(ldisc, &new_ldisc);
+	if (retval)
+		return retval;
 
 	/*
 	 *	Problem: What do we do if this blocks ?
@@ -996,8 +1091,8 @@ restart:
 
 	tty_wait_until_sent(tty, 0);
 
-	if (tty->ldisc.num == ldisc) {
-		tty_ldisc_put(ldisc);
+	if (tty->ldisc.ops->num == ldisc) {
+		tty_ldisc_put(new_ldisc.ops);
 		return 0;
 	}
 
@@ -1024,7 +1119,7 @@ restart:
 			/* Free the new ldisc we grabbed. Must drop the lock
 			   first. */
 			spin_unlock_irqrestore(&tty_ldisc_lock, flags);
-			tty_ldisc_put(ldisc);
+			tty_ldisc_put(o_ldisc.ops);
 			/*
 			 * There are several reasons we may be busy, including
 			 * random momentary I/O traffic. We must therefore
@@ -1038,7 +1133,7 @@ restart:
 		}
 		if (o_tty && o_tty->ldisc.refcount) {
 			spin_unlock_irqrestore(&tty_ldisc_lock, flags);
-			tty_ldisc_put(ldisc);
+			tty_ldisc_put(o_tty->ldisc.ops);
 			if (wait_event_interruptible(tty_ldisc_wait, o_tty->ldisc.refcount == 0) < 0)
 				return -ERESTARTSYS;
 			goto restart;
@@ -1049,8 +1144,9 @@ restart:
 	 *	another ldisc change
 	 */
 	if (!test_bit(TTY_LDISC, &tty->flags)) {
+		struct tty_ldisc *ld;
 		spin_unlock_irqrestore(&tty_ldisc_lock, flags);
-		tty_ldisc_put(ldisc);
+		tty_ldisc_put(new_ldisc.ops);
 		ld = tty_ldisc_ref_wait(tty);
 		tty_ldisc_deref(ld);
 		goto restart;
@@ -1060,7 +1156,7 @@ restart:
 	if (o_tty)
 		clear_bit(TTY_LDISC, &o_tty->flags);
 	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
-
+	
 	/*
 	 *	From this point on we know nobody has an ldisc
 	 *	usage reference, nor can they obtain one until
@@ -1070,45 +1166,30 @@ restart:
 	work = cancel_delayed_work(&tty->buf.work);
 	/*
 	 * Wait for ->hangup_work and ->buf.work handlers to terminate
+	 * MUST NOT hold locks here.
 	 */
 	flush_scheduled_work();
 	/* Shutdown the current discipline. */
-	if (tty->ldisc.close)
-		(tty->ldisc.close)(tty);
+	if (o_ldisc.ops->close)
+		(o_ldisc.ops->close)(tty);
 
 	/* Now set up the new line discipline. */
-	tty_ldisc_assign(tty, ld);
+	tty_ldisc_assign(tty, &new_ldisc);
 	tty_set_termios_ldisc(tty, ldisc);
-	if (tty->ldisc.open)
-		retval = (tty->ldisc.open)(tty);
+	if (new_ldisc.ops->open)
+		retval = (new_ldisc.ops->open)(tty);
 	if (retval < 0) {
-		tty_ldisc_put(ldisc);
-		/* There is an outstanding reference here so this is safe */
-		tty_ldisc_assign(tty, tty_ldisc_get(o_ldisc.num));
-		tty_set_termios_ldisc(tty, tty->ldisc.num);
-		if (tty->ldisc.open && (tty->ldisc.open(tty) < 0)) {
-			tty_ldisc_put(o_ldisc.num);
-			/* This driver is always present */
-			tty_ldisc_assign(tty, tty_ldisc_get(N_TTY));
-			tty_set_termios_ldisc(tty, N_TTY);
-			if (tty->ldisc.open) {
-				int r = tty->ldisc.open(tty);
-
-				if (r < 0)
-					panic("Couldn't open N_TTY ldisc for "
-					      "%s --- error %d.",
-					      tty_name(tty, buf), r);
-			}
-		}
+		tty_ldisc_put(new_ldisc.ops);
+		tty_ldisc_restore(tty, &o_ldisc);
 	}
 	/* At this point we hold a reference to the new ldisc and a
 	   a reference to the old ldisc. If we ended up flipping back
 	   to the existing ldisc we have two references to it */
 
-	if (tty->ldisc.num != o_ldisc.num && tty->ops->set_ldisc)
+	if (tty->ldisc.ops->num != o_ldisc.ops->num && tty->ops->set_ldisc)
 		tty->ops->set_ldisc(tty);
 
-	tty_ldisc_put(o_ldisc.num);
+	tty_ldisc_put(o_ldisc.ops);
 
 	/*
 	 *	Allow ldisc referencing to occur as soon as the driver
@@ -1335,8 +1416,8 @@ void tty_wakeup(struct tty_struct *tty)
 	if (test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags)) {
 		ld = tty_ldisc_ref(tty);
 		if (ld) {
-			if (ld->write_wakeup)
-				ld->write_wakeup(tty);
+			if (ld->ops->write_wakeup)
+				ld->ops->write_wakeup(tty);
 			tty_ldisc_deref(ld);
 		}
 	}
@@ -1357,8 +1438,8 @@ void tty_ldisc_flush(struct tty_struct *tty)
 {
 	struct tty_ldisc *ld = tty_ldisc_ref(tty);
 	if (ld) {
-		if (ld->flush_buffer)
-			ld->flush_buffer(tty);
+		if (ld->ops->flush_buffer)
+			ld->ops->flush_buffer(tty);
 		tty_ldisc_deref(ld);
 	}
 	tty_buffer_flush(tty);
@@ -1386,7 +1467,7 @@ static void tty_reset_termios(struct tty_struct *tty)
  *	do_tty_hangup		-	actual handler for hangup events
  *	@work: tty device
  *
- *	This can be called by the "eventd" kernel thread.  That is process
+k *	This can be called by the "eventd" kernel thread.  That is process
  *	synchronous but doesn't hold any locks, so we need to make sure we
  *	have the appropriate locks for what we're doing.
  *
@@ -1449,14 +1530,14 @@ static void do_tty_hangup(struct work_struct *work)
 	ld = tty_ldisc_ref(tty);
 	if (ld != NULL) {
 		/* We may have no line discipline at this point */
-		if (ld->flush_buffer)
-			ld->flush_buffer(tty);
+		if (ld->ops->flush_buffer)
+			ld->ops->flush_buffer(tty);
 		tty_driver_flush_buffer(tty);
 		if ((test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags)) &&
-		    ld->write_wakeup)
-			ld->write_wakeup(tty);
-		if (ld->hangup)
-			ld->hangup(tty);
+		    ld->ops->write_wakeup)
+			ld->ops->write_wakeup(tty);
+		if (ld->ops->hangup)
+			ld->ops->hangup(tty);
 	}
 	/*
 	 * FIXME: Once we trust the LDISC code better we can wait here for
@@ -1825,8 +1906,8 @@ static ssize_t tty_read(struct file *file, char __user *buf, size_t count,
 	/* We want to wait for the line discipline to sort out in this
 	   situation */
 	ld = tty_ldisc_ref_wait(tty);
-	if (ld->read)
-		i = (ld->read)(tty, file, buf, count);
+	if (ld->ops->read)
+		i = (ld->ops->read)(tty, file, buf, count);
 	else
 		i = -EIO;
 	tty_ldisc_deref(ld);
@@ -1978,10 +2059,10 @@ static ssize_t tty_write(struct file *file, const char __user *buf,
 		printk(KERN_ERR "tty driver %s lacks a write_room method.\n",
 			tty->driver->name);
 	ld = tty_ldisc_ref_wait(tty);
-	if (!ld->write)
+	if (!ld->ops->write)
 		ret = -EIO;
 	else
-		ret = do_tty_write(ld->write, tty, file, buf, count);
+		ret = do_tty_write(ld->ops->write, tty, file, buf, count);
 	tty_ldisc_deref(ld);
 	return ret;
 }
@@ -2076,6 +2157,7 @@ static int init_dev(struct tty_driver *driver, int idx,
 	struct ktermios *tp, **tp_loc, *o_tp, **o_tp_loc;
 	struct ktermios *ltp, **ltp_loc, *o_ltp, **o_ltp_loc;
 	int retval = 0;
+	struct tty_ldisc *ld;
 
 	/* check whether we're reopening an existing tty */
 	if (driver->flags & TTY_DRIVER_DEVPTS_MEM) {
@@ -2224,17 +2306,19 @@ static int init_dev(struct tty_driver *driver, int idx,
 	 * If we fail here just call release_tty to clean up.  No need
 	 * to decrement the use counts, as release_tty doesn't care.
 	 */
+	 
+	ld = &tty->ldisc;
 
-	if (tty->ldisc.open) {
-		retval = (tty->ldisc.open)(tty);
+	if (ld->ops->open) {
+		retval = (ld->ops->open)(tty);
 		if (retval)
 			goto release_mem_out;
 	}
-	if (o_tty && o_tty->ldisc.open) {
-		retval = (o_tty->ldisc.open)(o_tty);
+	if (o_tty && o_tty->ldisc.ops->open) {
+		retval = (o_tty->ldisc.ops->open)(o_tty);
 		if (retval) {
-			if (tty->ldisc.close)
-				(tty->ldisc.close)(tty);
+			if (ld->ops->close)
+				(ld->ops->close)(tty);
 			goto release_mem_out;
 		}
 		tty_ldisc_enable(o_tty);
@@ -2378,6 +2462,7 @@ static void release_tty(struct tty_struct *tty, int idx)
 static void release_dev(struct file *filp)
 {
 	struct tty_struct *tty, *o_tty;
+	struct tty_ldisc ld;
 	int	pty_master, tty_closing, o_tty_closing, do_sleep;
 	int	devpts;
 	int	idx;
@@ -2611,26 +2696,27 @@ static void release_dev(struct file *filp)
 	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
 	/*
 	 * Shutdown the current line discipline, and reset it to N_TTY.
-	 * N.B. why reset ldisc when we're releasing the memory??
 	 *
 	 * FIXME: this MUST get fixed for the new reflocking
 	 */
-	if (tty->ldisc.close)
-		(tty->ldisc.close)(tty);
-	tty_ldisc_put(tty->ldisc.num);
+	if (tty->ldisc.ops->close)
+		(tty->ldisc.ops->close)(tty);
+	tty_ldisc_put(tty->ldisc.ops);
 
 	/*
 	 *	Switch the line discipline back
 	 */
-	tty_ldisc_assign(tty, tty_ldisc_get(N_TTY));
+	WARN_ON(tty_ldisc_get(N_TTY, &ld));
+	tty_ldisc_assign(tty, &ld);
 	tty_set_termios_ldisc(tty, N_TTY);
 	if (o_tty) {
 		/* FIXME: could o_tty be in setldisc here ? */
 		clear_bit(TTY_LDISC, &o_tty->flags);
-		if (o_tty->ldisc.close)
-			(o_tty->ldisc.close)(o_tty);
-		tty_ldisc_put(o_tty->ldisc.num);
-		tty_ldisc_assign(o_tty, tty_ldisc_get(N_TTY));
+		if (o_tty->ldisc.ops->close)
+			(o_tty->ldisc.ops->close)(o_tty);
+		tty_ldisc_put(o_tty->ldisc.ops);
+		WARN_ON(tty_ldisc_get(N_TTY, &ld));
+		tty_ldisc_assign(o_tty, &ld);
 		tty_set_termios_ldisc(o_tty, N_TTY);
 	}
 	/*
@@ -2876,8 +2962,8 @@ static unsigned int tty_poll(struct file *filp, poll_table *wait)
 		return 0;
 
 	ld = tty_ldisc_ref_wait(tty);
-	if (ld->poll)
-		ret = (ld->poll)(tty, filp, wait);
+	if (ld->ops->poll)
+		ret = (ld->ops->poll)(tty, filp, wait);
 	tty_ldisc_deref(ld);
 	return ret;
 }
@@ -2947,7 +3033,7 @@ static int tiocsti(struct tty_struct *tty, char __user *p)
 	if (get_user(ch, p))
 		return -EFAULT;
 	ld = tty_ldisc_ref_wait(tty);
-	ld->receive_buf(tty, &ch, &mbz, 1);
+	ld->ops->receive_buf(tty, &ch, &mbz, 1);
 	tty_ldisc_deref(ld);
 	return 0;
 }
@@ -3501,7 +3587,7 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case TIOCGSID:
 		return tiocgsid(tty, real_tty, p);
 	case TIOCGETD:
-		return put_user(tty->ldisc.num, (int __user *)p);
+		return put_user(tty->ldisc.ops->num, (int __user *)p);
 	case TIOCSETD:
 		return tiocsetd(tty, p);
 #ifdef CONFIG_VT
@@ -3554,8 +3640,8 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	}
 	ld = tty_ldisc_ref_wait(tty);
 	retval = -EINVAL;
-	if (ld->ioctl) {
-		retval = ld->ioctl(tty, file, cmd, arg);
+	if (ld->ops->ioctl) {
+		retval = ld->ops->ioctl(tty, file, cmd, arg);
 		if (retval == -ENOIOCTLCMD)
 			retval = -EINVAL;
 	}
@@ -3582,8 +3668,8 @@ static long tty_compat_ioctl(struct file *file, unsigned int cmd,
 	}
 
 	ld = tty_ldisc_ref_wait(tty);
-	if (ld->compat_ioctl)
-		retval = ld->compat_ioctl(tty, file, cmd, arg);
+	if (ld->ops->compat_ioctl)
+		retval = ld->ops->compat_ioctl(tty, file, cmd, arg);
 	tty_ldisc_deref(ld);
 
 	return retval;
@@ -3755,7 +3841,8 @@ static void flush_to_ldisc(struct work_struct *work)
 			flag_buf = head->flag_buf_ptr + head->read;
 			head->read += count;
 			spin_unlock_irqrestore(&tty->buf.lock, flags);
-			disc->receive_buf(tty, char_buf, flag_buf, count);
+			disc->ops->receive_buf(tty, char_buf,
+							flag_buf, count);
 			spin_lock_irqsave(&tty->buf.lock, flags);
 		}
 		/* Restore the queue head */
@@ -3816,9 +3903,12 @@ EXPORT_SYMBOL(tty_flip_buffer_push);
 
 static void initialize_tty_struct(struct tty_struct *tty)
 {
+	struct tty_ldisc ld;
 	memset(tty, 0, sizeof(struct tty_struct));
 	tty->magic = TTY_MAGIC;
-	tty_ldisc_assign(tty, tty_ldisc_get(N_TTY));
+	if (tty_ldisc_get(N_TTY, &ld) < 0)
+		panic("n_tty: init_tty");
+	tty_ldisc_assign(tty, &ld);
 	tty->session = NULL;
 	tty->pgrp = NULL;
 	tty->overrun_time = jiffies;
diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index b1a757a..ea41b1f 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -491,8 +491,8 @@ static void change_termios(struct tty_struct *tty, struct ktermios *new_termios)
 
 	ld = tty_ldisc_ref(tty);
 	if (ld != NULL) {
-		if (ld->set_termios)
-			(ld->set_termios)(tty, &old_termios);
+		if (ld->ops->set_termios)
+			(ld->ops->set_termios)(tty, &old_termios);
 		tty_ldisc_deref(ld);
 	}
 	mutex_unlock(&tty->termios_mutex);
@@ -552,8 +552,8 @@ static int set_termios(struct tty_struct *tty, void __user *arg, int opt)
 	ld = tty_ldisc_ref(tty);
 
 	if (ld != NULL) {
-		if ((opt & TERMIOS_FLUSH) && ld->flush_buffer)
-			ld->flush_buffer(tty);
+		if ((opt & TERMIOS_FLUSH) && ld->ops->flush_buffer)
+			ld->ops->flush_buffer(tty);
 		tty_ldisc_deref(ld);
 	}
 
@@ -959,12 +959,12 @@ int tty_perform_flush(struct tty_struct *tty, unsigned long arg)
 	ld = tty_ldisc_ref(tty);
 	switch (arg) {
 	case TCIFLUSH:
-		if (ld && ld->flush_buffer)
-			ld->flush_buffer(tty);
+		if (ld && ld->ops->flush_buffer)
+			ld->ops->flush_buffer(tty);
 		break;
 	case TCIOFLUSH:
-		if (ld && ld->flush_buffer)
-			ld->flush_buffer(tty);
+		if (ld && ld->ops->flush_buffer)
+			ld->ops->flush_buffer(tty);
 		/* fall through */
 	case TCOFLUSH:
 		tty_driver_flush_buffer(tty);
diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index 7ff71ba..b9694b6 100644
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -216,7 +216,7 @@ static void serport_ldisc_write_wakeup(struct tty_struct * tty)
  * The line discipline structure.
  */
 
-static struct tty_ldisc serport_ldisc = {
+static struct tty_ldisc_ops serport_ldisc = {
 	.owner =	THIS_MODULE,
 	.name =		"input",
 	.open =		serport_ldisc_open,
diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 6ca0bb9..18deefa 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -465,7 +465,7 @@ static int handle_recv_skb(struct capiminor *mp, struct sk_buff *skb)
 	ld = tty_ldisc_ref(mp->tty);
 	if (ld == NULL)
 		return -1;
-	if (ld->receive_buf == NULL) {
+	if (ld->ops->receive_buf == NULL) {
 #if defined(_DEBUG_DATAFLOW) || defined(_DEBUG_TTYFUNCS)
 		printk(KERN_DEBUG "capi: ldisc has no receive_buf function\n");
 #endif
@@ -500,7 +500,7 @@ static int handle_recv_skb(struct capiminor *mp, struct sk_buff *skb)
 	printk(KERN_DEBUG "capi: DATA_B3_RESP %u len=%d => ldisc\n",
 				datahandle, skb->len);
 #endif
-	ld->receive_buf(mp->tty, skb->data, NULL, skb->len);
+	ld->ops->receive_buf(mp->tty, skb->data, NULL, skb->len);
 	kfree_skb(skb);
 	tty_ldisc_deref(ld);
 	return 0;
diff --git a/drivers/isdn/gigaset/ser-gigaset.c b/drivers/isdn/gigaset/ser-gigaset.c
index 45d1ee9..5e89fa1 100644
--- a/drivers/isdn/gigaset/ser-gigaset.c
+++ b/drivers/isdn/gigaset/ser-gigaset.c
@@ -766,7 +766,7 @@ gigaset_tty_wakeup(struct tty_struct *tty)
 	cs_put(cs);
 }
 
-static struct tty_ldisc gigaset_ldisc = {
+static struct tty_ldisc_ops gigaset_ldisc = {
 	.owner		= THIS_MODULE,
 	.magic		= TTY_LDISC_MAGIC,
 	.name		= "ser_gigaset",
diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 9d57212..19dd0a6 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -783,7 +783,7 @@ static int sixpack_ioctl(struct tty_struct *tty, struct file *file,
 	return err;
 }
 
-static struct tty_ldisc sp_ldisc = {
+static struct tty_ldisc_ops sp_ldisc = {
 	.owner		= THIS_MODULE,
 	.magic		= TTY_LDISC_MAGIC,
 	.name		= "6pack",
diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 6516603..c6ca475 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -969,7 +969,7 @@ out:
 	mkiss_put(ax);
 }
 
-static struct tty_ldisc ax_ldisc = {
+static struct tty_ldisc_ops ax_ldisc = {
 	.owner		= THIS_MODULE,
 	.magic		= TTY_LDISC_MAGIC,
 	.name		= "mkiss",
diff --git a/drivers/net/irda/irtty-sir.c b/drivers/net/irda/irtty-sir.c
index e6f40b7..9e33196 100644
--- a/drivers/net/irda/irtty-sir.c
+++ b/drivers/net/irda/irtty-sir.c
@@ -533,7 +533,7 @@ static void irtty_close(struct tty_struct *tty)
 
 /* ------------------------------------------------------- */
 
-static struct tty_ldisc irda_ldisc = {
+static struct tty_ldisc_ops irda_ldisc = {
 	.magic		= TTY_LDISC_MAGIC,
  	.name		= "irda",
 	.flags		= 0,
diff --git a/drivers/net/ppp_async.c b/drivers/net/ppp_async.c
index f1a52de..451bdb5 100644
--- a/drivers/net/ppp_async.c
+++ b/drivers/net/ppp_async.c
@@ -378,7 +378,7 @@ ppp_asynctty_wakeup(struct tty_struct *tty)
 }
 
 
-static struct tty_ldisc ppp_ldisc = {
+static struct tty_ldisc_ops ppp_ldisc = {
 	.owner  = THIS_MODULE,
 	.magic	= TTY_LDISC_MAGIC,
 	.name	= "ppp",
diff --git a/drivers/net/ppp_synctty.c b/drivers/net/ppp_synctty.c
index b8f0369..801d8f9 100644
--- a/drivers/net/ppp_synctty.c
+++ b/drivers/net/ppp_synctty.c
@@ -418,7 +418,7 @@ ppp_sync_wakeup(struct tty_struct *tty)
 }
 
 
-static struct tty_ldisc ppp_sync_ldisc = {
+static struct tty_ldisc_ops ppp_sync_ldisc = {
 	.owner	= THIS_MODULE,
 	.magic	= TTY_LDISC_MAGIC,
 	.name	= "pppsync",
diff --git a/drivers/net/slip.c b/drivers/net/slip.c
index 84af68f..1d58991 100644
--- a/drivers/net/slip.c
+++ b/drivers/net/slip.c
@@ -1301,7 +1301,7 @@ static int sl_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 #endif
 /* VSV changes end */
 
-static struct tty_ldisc	sl_ldisc = {
+static struct tty_ldisc_ops sl_ldisc = {
 	.owner 		= THIS_MODULE,
 	.magic 		= TTY_LDISC_MAGIC,
 	.name 		= "slip",
diff --git a/drivers/net/wan/pc300_tty.c b/drivers/net/wan/pc300_tty.c
index e03eef2..c2c10c6 100644
--- a/drivers/net/wan/pc300_tty.c
+++ b/drivers/net/wan/pc300_tty.c
@@ -688,9 +688,9 @@ static void cpc_tty_rx_work(struct work_struct *work)
 				if (cpc_tty->tty) {
 					ld = tty_ldisc_ref(cpc_tty->tty);
 					if (ld) {
-						if (ld->receive_buf) {
+						if (ld->ops->receive_buf) {
 							CPC_TTY_DBG("%s: call line disc. receive_buf\n",cpc_tty->name);
-							ld->receive_buf(cpc_tty->tty, (char *)(buf->data), &flags, buf->size);
+							ld->ops->receive_buf(cpc_tty->tty, (char *)(buf->data), &flags, buf->size);
 						}
 						tty_ldisc_deref(ld);
 					}
diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
index 249e180..183806e 100644
--- a/drivers/net/wan/x25_asy.c
+++ b/drivers/net/wan/x25_asy.c
@@ -751,7 +751,7 @@ static void x25_asy_setup(struct net_device *dev)
 	dev->flags		= IFF_NOARP;
 }
 
-static struct tty_ldisc x25_ldisc = {
+static struct tty_ldisc_ops x25_ldisc = {
 	.owner		= THIS_MODULE,
 	.magic		= TTY_LDISC_MAGIC,
 	.name		= "X.25",
diff --git a/drivers/net/wireless/strip.c b/drivers/net/wireless/strip.c
index 883af89..417e9e6 100644
--- a/drivers/net/wireless/strip.c
+++ b/drivers/net/wireless/strip.c
@@ -2728,7 +2728,7 @@ static int strip_ioctl(struct tty_struct *tty, struct file *file,
 /************************************************************************/
 /* Initialization							*/
 
-static struct tty_ldisc strip_ldisc = {
+static struct tty_ldisc_ops strip_ldisc = {
 	.magic = TTY_LDISC_MAGIC,
 	.name = "strip",
 	.owner = THIS_MODULE,
diff --git a/fs/proc/proc_tty.c b/fs/proc/proc_tty.c
index 21f490f..d153946 100644
--- a/fs/proc/proc_tty.c
+++ b/fs/proc/proc_tty.c
@@ -136,54 +136,6 @@ static const struct file_operations proc_tty_drivers_operations = {
 	.release	= seq_release,
 };
 
-static void * tty_ldiscs_seq_start(struct seq_file *m, loff_t *pos)
-{
-	return (*pos < NR_LDISCS) ? pos : NULL;
-}
-
-static void * tty_ldiscs_seq_next(struct seq_file *m, void *v, loff_t *pos)
-{
-	(*pos)++;
-	return (*pos < NR_LDISCS) ? pos : NULL;
-}
-
-static void tty_ldiscs_seq_stop(struct seq_file *m, void *v)
-{
-}
-
-static int tty_ldiscs_seq_show(struct seq_file *m, void *v)
-{
-	int i = *(loff_t *)v;
-	struct tty_ldisc *ld;
-	
-	ld = tty_ldisc_get(i);
-	if (ld == NULL)
-		return 0;
-	seq_printf(m, "%-10s %2d\n", ld->name ? ld->name : "???", i);
-	tty_ldisc_put(i);
-	return 0;
-}
-
-static const struct seq_operations tty_ldiscs_seq_ops = {
-	.start	= tty_ldiscs_seq_start,
-	.next	= tty_ldiscs_seq_next,
-	.stop	= tty_ldiscs_seq_stop,
-	.show	= tty_ldiscs_seq_show,
-};
-
-static int proc_tty_ldiscs_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &tty_ldiscs_seq_ops);
-}
-
-static const struct file_operations tty_ldiscs_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= proc_tty_ldiscs_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 /*
  * This function is called by tty_register_driver() to handle
  * registering the driver's /proc handler into /proc/tty/driver/<foo>
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 324a3b2..013711e 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -185,6 +185,7 @@ struct tty_struct {
 	struct tty_driver *driver;
 	const struct tty_operations *ops;
 	int index;
+	/* The ldisc objects are protected by tty_ldisc_lock at the moment */
 	struct tty_ldisc ldisc;
 	struct mutex termios_mutex;
 	spinlock_t ctrl_lock;
@@ -289,7 +290,7 @@ extern void tty_wait_until_sent(struct tty_struct * tty, long timeout);
 extern int tty_check_change(struct tty_struct * tty);
 extern void stop_tty(struct tty_struct * tty);
 extern void start_tty(struct tty_struct * tty);
-extern int tty_register_ldisc(int disc, struct tty_ldisc *new_ldisc);
+extern int tty_register_ldisc(int disc, struct tty_ldisc_ops *new_ldisc);
 extern int tty_unregister_ldisc(int disc);
 extern int tty_register_driver(struct tty_driver *driver);
 extern int tty_unregister_driver(struct tty_driver *driver);
@@ -330,9 +331,7 @@ extern int tty_termios_hw_change(struct ktermios *a, struct ktermios *b);
 extern struct tty_ldisc *tty_ldisc_ref(struct tty_struct *);
 extern void tty_ldisc_deref(struct tty_ldisc *);
 extern struct tty_ldisc *tty_ldisc_ref_wait(struct tty_struct *);
-
-extern struct tty_ldisc *tty_ldisc_get(int);
-extern void tty_ldisc_put(int);
+extern const struct file_operations tty_ldiscs_proc_fops;
 
 extern void tty_wakeup(struct tty_struct *tty);
 extern void tty_ldisc_flush(struct tty_struct *tty);
@@ -354,7 +353,7 @@ extern int tty_write_lock(struct tty_struct *tty, int ndelay);
 
 
 /* n_tty.c */
-extern struct tty_ldisc tty_ldisc_N_TTY;
+extern struct tty_ldisc_ops tty_ldisc_N_TTY;
 
 /* tty_audit.c */
 #ifdef CONFIG_AUDIT
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index 6226504..40f38d8 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -104,7 +104,7 @@
 #include <linux/fs.h>
 #include <linux/wait.h>
 
-struct tty_ldisc {
+struct tty_ldisc_ops {
 	int	magic;
 	char	*name;
 	int	num;
@@ -142,6 +142,11 @@ struct tty_ldisc {
 	int refcount;
 };
 
+struct tty_ldisc {
+	struct tty_ldisc_ops *ops;
+	int refcount;
+};
+
 #define TTY_LDISC_MAGIC	0x5403
 
 #define LDISC_FLAG_DEFINED	0x00000001
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index c919187..0a387f2 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -617,14 +617,7 @@ static void rfcomm_tty_wakeup(unsigned long arg)
 		return;
 
 	BT_DBG("dev %p tty %p", dev, tty);
-
-	if (test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags) && tty->ldisc.write_wakeup)
-		(tty->ldisc.write_wakeup)(tty);
-
-	wake_up_interruptible(&tty->write_wait);
-#ifdef SERIAL_HAVE_POLL_WAIT
-	wake_up_interruptible(&tty->poll_wait);
-#endif
+	tty_wakeup(tty);
 }
 
 static int rfcomm_tty_open(struct tty_struct *tty, struct file *filp)
@@ -1005,9 +998,7 @@ static void rfcomm_tty_flush_buffer(struct tty_struct *tty)
 		return;
 
 	skb_queue_purge(&dev->dlc->tx_queue);
-
-	if (test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags) && tty->ldisc.write_wakeup)
-		tty->ldisc.write_wakeup(tty);
+	tty_wakeup(tty);
 }
 
 static void rfcomm_tty_send_xchar(struct tty_struct *tty, char ch)
diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index 76c3057..e4e2cae 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -650,12 +650,7 @@ static void ircomm_tty_do_softint(struct work_struct *work)
 	}
 
 	/* Check if user (still) wants to be waken up */
-	if ((tty->flags & (1 << TTY_DO_WRITE_WAKEUP)) &&
-	    tty->ldisc.write_wakeup)
-	{
-		(tty->ldisc.write_wakeup)(tty);
-	}
-	wake_up_interruptible(&tty->write_wait);
+	tty_wakeup(tty);
 }
 
 /*
@@ -1141,6 +1136,7 @@ static int ircomm_tty_data_indication(void *instance, void *sap,
 				      struct sk_buff *skb)
 {
 	struct ircomm_tty_cb *self = (struct ircomm_tty_cb *) instance;
+	struct tty_ldisc *ld;
 
 	IRDA_DEBUG(2, "%s()\n", __func__ );
 
@@ -1173,7 +1169,11 @@ static int ircomm_tty_data_indication(void *instance, void *sap,
 	 * involve the flip buffers, since we are not running in an interrupt
 	 * handler
 	 */
-	self->tty->ldisc.receive_buf(self->tty, skb->data, NULL, skb->len);
+
+	ld = tty_ldisc_ref(self->tty);
+	if (ld)
+		ld->ops->receive_buf(self->tty, skb->data, NULL, skb->len);
+	tty_ldisc_deref(ld);
 
 	/* No need to kfree_skb - see ircomm_ttp_data_indication() */
 

