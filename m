Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616AbZISVjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbZISVjz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZISVjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:39:54 -0400
Received: from kroah.org ([198.145.64.141]:50959 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbZISVjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:39:52 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 21/79] slip: Clean up create and destroy
Date: Sat, 19 Sep 2009 14:36:26 -0700
Message-Id: <1253396244-7885-21-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The network layer now has a destructor we can hook to clean up the slip
devices array. That needs us to initiate unregister events in the right
places which with the current tty layer we can do, and with network
refcounting is safe to do.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/slip.c |   96 ++++++++++++---------------------------------------
 1 files changed, 23 insertions(+), 73 deletions(-)

diff --git a/drivers/net/slip.c b/drivers/net/slip.c
index 26f6ee9..e17c535 100644
--- a/drivers/net/slip.c
+++ b/drivers/net/slip.c
@@ -616,6 +616,14 @@ static void sl_uninit(struct net_device *dev)
 	sl_free_bufs(sl);
 }
 
+/* Hook the destructor so we can free slip devices at the right point in time */
+static void sl_free_netdev(struct net_device *dev)
+{
+	int i = dev->base_addr;
+	free_netdev(dev);
+	slip_devs[i] = NULL;
+}
+
 static const struct net_device_ops sl_netdev_ops = {
 	.ndo_init		= sl_init,
 	.ndo_uninit	  	= sl_uninit,
@@ -634,7 +642,7 @@ static const struct net_device_ops sl_netdev_ops = {
 static void sl_setup(struct net_device *dev)
 {
 	dev->netdev_ops		= &sl_netdev_ops;
-	dev->destructor		= free_netdev;
+	dev->destructor		= sl_free_netdev;
 
 	dev->hard_header_len	= 0;
 	dev->addr_len		= 0;
@@ -712,8 +720,6 @@ static void sl_sync(void)
 static struct slip *sl_alloc(dev_t line)
 {
 	int i;
-	int sel = -1;
-	int score = -1;
 	struct net_device *dev = NULL;
 	struct slip       *sl;
 
@@ -724,55 +730,7 @@ static struct slip *sl_alloc(dev_t line)
 		dev = slip_devs[i];
 		if (dev == NULL)
 			break;
-
-		sl = netdev_priv(dev);
-		if (sl->leased) {
-			if (sl->line != line)
-				continue;
-			if (sl->tty)
-				return NULL;
-
-			/* Clear ESCAPE & ERROR flags */
-			sl->flags &= (1 << SLF_INUSE);
-			return sl;
-		}
-
-		if (sl->tty)
-			continue;
-
-		if (current->pid == sl->pid) {
-			if (sl->line == line && score < 3) {
-				sel = i;
-				score = 3;
-				continue;
-			}
-			if (score < 2) {
-				sel = i;
-				score = 2;
-			}
-			continue;
-		}
-		if (sl->line == line && score < 1) {
-			sel = i;
-			score = 1;
-			continue;
-		}
-		if (score < 0) {
-			sel = i;
-			score = 0;
-		}
-	}
-
-	if (sel >= 0) {
-		i = sel;
-		dev = slip_devs[i];
-		if (score > 1) {
-			sl = netdev_priv(dev);
-			sl->flags &= (1 << SLF_INUSE);
-			return sl;
-		}
 	}
-
 	/* Sorry, too many, all slots in use */
 	if (i >= slip_maxdev)
 		return NULL;
@@ -909,30 +867,13 @@ err_exit:
 }
 
 /*
-
-  FIXME: 1,2 are fixed 3 was never true anyway.
-
-   Let me to blame a bit.
-   1. TTY module calls this funstion on soft interrupt.
-   2. TTY module calls this function WITH MASKED INTERRUPTS!
-   3. TTY module does not notify us about line discipline
-      shutdown,
-
-   Seems, now it is clean. The solution is to consider netdevice and
-   line discipline sides as two independent threads.
-
-   By-product (not desired): sl? does not feel hangups and remains open.
-   It is supposed, that user level program (dip, diald, slattach...)
-   will catch SIGHUP and make the rest of work.
-
-   I see no way to make more with current tty code. --ANK
- */
-
-/*
  * Close down a SLIP channel.
  * This means flushing out any pending queues, and then returning. This
  * call is serialized against other ldisc functions.
+ *
+ * We also use this method fo a hangup event
  */
+
 static void slip_close(struct tty_struct *tty)
 {
 	struct slip *sl = tty->disc_data;
@@ -951,10 +892,16 @@ static void slip_close(struct tty_struct *tty)
 	del_timer_sync(&sl->keepalive_timer);
 	del_timer_sync(&sl->outfill_timer);
 #endif
-
-	/* Count references from TTY module */
+	/* Flush network side */
+	unregister_netdev(sl->dev);
+	/* This will complete via sl_free_netdev */
 }
 
+static int slip_hangup(struct tty_struct *tty)
+{
+	slip_close(tty);
+	return 0;
+}
  /************************************************************************
   *			STANDARD SLIP ENCAPSULATION		  	 *
   ************************************************************************/
@@ -1311,6 +1258,7 @@ static struct tty_ldisc_ops sl_ldisc = {
 	.name 		= "slip",
 	.open 		= slip_open,
 	.close	 	= slip_close,
+	.hangup	 	= slip_hangup,
 	.ioctl		= slip_ioctl,
 	.receive_buf	= slip_receive_buf,
 	.write_wakeup	= slip_write_wakeup,
@@ -1384,6 +1332,8 @@ static void __exit slip_exit(void)
 		}
 	} while (busy && time_before(jiffies, timeout));
 
+	/* FIXME: hangup is async so we should wait when doing this second
+	   phase */
 
 	for (i = 0; i < slip_maxdev; i++) {
 		dev = slip_devs[i];
-- 
1.6.4.2

