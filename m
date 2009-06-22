Return-Path: <linux-kernel-owner+w=401wt.eu-S1752099AbZFVQqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbZFVQqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756772AbZFVQo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:44:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53533 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752496AbZFVQoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:44:55 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 12/15] tty: n_hdlc add buffer flushing
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Jun 2009 18:42:56 +0100
Message-ID: <20090622174254.25341.14653.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
References: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Fulghum <paulkf@microgate.com>

Add flush_buffer tty callback to flush rx buffers.
Add TCFLSH ioctl processing to flush tx buffers.
Increase default tx buffers from 1 to 3.
Remove unneeded flush_buffer call in open callback.
Remove vendor specific CVS version string.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/n_hdlc.c |   46 +++++++++++++++++++++++++++++++++++++---------
 1 files changed, 37 insertions(+), 9 deletions(-)


diff --git a/drivers/char/n_hdlc.c b/drivers/char/n_hdlc.c
index 461ece5..1c43c8c 100644
--- a/drivers/char/n_hdlc.c
+++ b/drivers/char/n_hdlc.c
@@ -10,7 +10,6 @@
  *	Paul Mackerras <Paul.Mackerras@cs.anu.edu.au>
  *
  * Original release 01/11/99
- * $Id: n_hdlc.c,v 4.8 2003/05/06 21:18:51 paulkf Exp $
  *
  * This code is released under the GNU General Public License (GPL)
  *
@@ -79,7 +78,6 @@
  */
 
 #define HDLC_MAGIC 0x239e
-#define HDLC_VERSION "$Revision: 4.8 $"
 
 #include <linux/module.h>
 #include <linux/init.h>
@@ -114,7 +112,7 @@
 #define MAX_HDLC_FRAME_SIZE 65535 
 #define DEFAULT_RX_BUF_COUNT 10
 #define MAX_RX_BUF_COUNT 60
-#define DEFAULT_TX_BUF_COUNT 1
+#define DEFAULT_TX_BUF_COUNT 3
 
 struct n_hdlc_buf {
 	struct n_hdlc_buf *link;
@@ -199,6 +197,31 @@ static void n_hdlc_tty_wakeup(struct tty_struct *tty);
 #define tty2n_hdlc(tty)	((struct n_hdlc *) ((tty)->disc_data))
 #define n_hdlc2tty(n_hdlc)	((n_hdlc)->tty)
 
+static void flush_rx_queue(struct tty_struct *tty)
+{
+	struct n_hdlc *n_hdlc = tty2n_hdlc(tty);
+	struct n_hdlc_buf *buf;
+
+	while ((buf = n_hdlc_buf_get(&n_hdlc->rx_buf_list)))
+		n_hdlc_buf_put(&n_hdlc->rx_free_buf_list, buf);
+}
+
+static void flush_tx_queue(struct tty_struct *tty)
+{
+	struct n_hdlc *n_hdlc = tty2n_hdlc(tty);
+	struct n_hdlc_buf *buf;
+	unsigned long flags;
+
+	while ((buf = n_hdlc_buf_get(&n_hdlc->tx_buf_list)))
+		n_hdlc_buf_put(&n_hdlc->tx_free_buf_list, buf);
+ 	spin_lock_irqsave(&n_hdlc->tx_buf_list.spinlock, flags);
+	if (n_hdlc->tbuf) {
+		n_hdlc_buf_put(&n_hdlc->tx_free_buf_list, n_hdlc->tbuf);
+		n_hdlc->tbuf = NULL;
+	}
+	spin_unlock_irqrestore(&n_hdlc->tx_buf_list.spinlock, flags);
+}
+
 static struct tty_ldisc_ops n_hdlc_ldisc = {
 	.owner		= THIS_MODULE,
 	.magic		= TTY_LDISC_MAGIC,
@@ -211,6 +234,7 @@ static struct tty_ldisc_ops n_hdlc_ldisc = {
 	.poll		= n_hdlc_tty_poll,
 	.receive_buf	= n_hdlc_tty_receive,
 	.write_wakeup	= n_hdlc_tty_wakeup,
+	.flush_buffer   = flush_rx_queue,
 };
 
 /**
@@ -341,10 +365,7 @@ static int n_hdlc_tty_open (struct tty_struct *tty)
 	set_bit(TTY_NO_WRITE_SPLIT,&tty->flags);
 #endif
 	
-	/* Flush any pending characters in the driver and discipline. */
-	if (tty->ldisc->ops->flush_buffer)
-		tty->ldisc->ops->flush_buffer(tty);
-
+	/* flush receive data from driver */
 	tty_driver_flush_buffer(tty);
 		
 	if (debuglevel >= DEBUG_LEVEL_INFO)	
@@ -763,6 +784,14 @@ static int n_hdlc_tty_ioctl(struct tty_struct *tty, struct file *file,
 		error = put_user(count, (int __user *)arg);
 		break;
 
+	case TCFLSH:
+		switch (arg) {
+		case TCIOFLUSH:
+		case TCOFLUSH:
+			flush_tx_queue(tty);
+		}
+		/* fall through to default */
+
 	default:
 		error = n_tty_ioctl_helper(tty, file, cmd, arg);
 		break;
@@ -919,8 +948,7 @@ static struct n_hdlc_buf* n_hdlc_buf_get(struct n_hdlc_buf_list *list)
 }	/* end of n_hdlc_buf_get() */
 
 static char hdlc_banner[] __initdata =
-	KERN_INFO "HDLC line discipline: version " HDLC_VERSION
-	", maxframe=%u\n";
+	KERN_INFO "HDLC line discipline maxframe=%u\n";
 static char hdlc_register_ok[] __initdata =
 	KERN_INFO "N_HDLC line discipline registered.\n";
 static char hdlc_register_fail[] __initdata =

