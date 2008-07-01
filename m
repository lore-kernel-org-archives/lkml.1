Return-Path: <linux-kernel-owner+w=401wt.eu-S1760404AbYGAPW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760404AbYGAPW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758132AbYGAPWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:22:04 -0400
Received: from ns.suse.de ([195.135.220.2]:43211 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757690AbYGAPWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:22:01 -0400
Date: Tue, 1 Jul 2008 08:18:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Cox <alan@redhat.com>
Subject: [patch 1/9] TTY: fix for tty operations bugs
Message-ID: <20080701151859.GB3536@suse.de>
References: <20080701151057.930340322@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tty-fix-for-tty-operations-bugs.patch"
In-Reply-To: <20080701151835.GA3536@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This is fixed with the recent tty operations rewrite in mainline in a
different way, this is a selective backport of the relevant portions to
the -stable tree.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/hamradio/6pack.c |    2 ++
 drivers/net/hamradio/mkiss.c |    8 ++++++--
 drivers/net/irda/irtty-sir.c |    4 +++-
 drivers/net/ppp_async.c      |    3 +++
 drivers/net/ppp_synctty.c    |    3 +++
 drivers/net/slip.c           |   14 ++++++++++----
 drivers/net/wan/x25_asy.c    |   10 ++++++++--
 drivers/net/wireless/strip.c |    3 ++-
 8 files changed, 37 insertions(+), 10 deletions(-)

--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -601,6 +601,8 @@ static int sixpack_open(struct tty_struc
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
+	if (!tty->driver->write)
+		return -EOPNOTSUPP;
 
 	dev = alloc_netdev(sizeof(struct sixpack), "sp%d", sp_setup);
 	if (!dev) {
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -529,6 +529,7 @@ static void ax_encaps(struct net_device 
 static int ax_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct mkiss *ax = netdev_priv(dev);
+	int cib = 0;
 
 	if (!netif_running(dev))  {
 		printk(KERN_ERR "mkiss: %s: xmit call when iface is down\n", dev->name);
@@ -544,10 +545,11 @@ static int ax_xmit(struct sk_buff *skb, 
 			/* 20 sec timeout not reached */
 			return 1;
 		}
+		if (ax->tty->drivers->chars_in_buffer)
+			cib = ax->tty->chars_in_buffer(ax->tty);
 
 		printk(KERN_ERR "mkiss: %s: transmit timed out, %s?\n", dev->name,
-		       (ax->tty->driver->chars_in_buffer(ax->tty) || ax->xleft) ?
-		       "bad line quality" : "driver error");
+		     cib || ax->xleft) ? "bad line quality" : "driver error");
 
 		ax->xleft = 0;
 		clear_bit(TTY_DO_WRITE_WAKEUP, &ax->tty->flags);
@@ -736,6 +738,8 @@ static int mkiss_open(struct tty_struct 
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
+	if (!tty->driver->write)
+		return -EOPNOTSUPP;
 
 	dev = alloc_netdev(sizeof(struct mkiss), "ax%d", ax_setup);
 	if (!dev) {
--- a/drivers/net/irda/irtty-sir.c
+++ b/drivers/net/irda/irtty-sir.c
@@ -64,7 +64,9 @@ static int irtty_chars_in_buffer(struct 
 	IRDA_ASSERT(priv != NULL, return -1;);
 	IRDA_ASSERT(priv->magic == IRTTY_MAGIC, return -1;);
 
-	return priv->tty->driver->chars_in_buffer(priv->tty);
+	if (priv->tty->drivers->chars_in_buffer)
+		return priv->tty->driver->chars_in_buffer(priv->tty);
+	return 0;
 }
 
 /* Wait (sleep) until underlaying hardware finished transmission
--- a/drivers/net/ppp_async.c
+++ b/drivers/net/ppp_async.c
@@ -157,6 +157,9 @@ ppp_asynctty_open(struct tty_struct *tty
 {
 	struct asyncppp *ap;
 	int err;
+
+	if (!tty->driver->write)
+		return -EOPNOTSUPP;
 
 	err = -ENOMEM;
 	ap = kzalloc(sizeof(*ap), GFP_KERNEL);
--- a/drivers/net/ppp_synctty.c
+++ b/drivers/net/ppp_synctty.c
@@ -207,6 +207,9 @@ ppp_sync_open(struct tty_struct *tty)
 	struct syncppp *ap;
 	int err;
 
+	if (!tty->driver->write)
+		return -EOPNOTSUPP;
+
 	ap = kzalloc(sizeof(*ap), GFP_KERNEL);
 	err = -ENOMEM;
 	if (!ap)
--- a/drivers/net/slip.c
+++ b/drivers/net/slip.c
@@ -460,10 +460,14 @@ static void sl_tx_timeout(struct net_dev
 			/* 20 sec timeout not reached */
 			goto out;
 		}
-		printk(KERN_WARNING "%s: transmit timed out, %s?\n",
-			dev->name,
-			(sl->tty->driver->chars_in_buffer(sl->tty) || sl->xleft) ?
-				"bad line quality" : "driver error");
+		{
+			int cib = 0;
+			if (sl->tty->driver->chars_in_buffer)
+				cib = sl->tty->driver->chars_in_buffer(sl->tty);
+			printk(KERN_WARNING "%s: transmit timed out, %s?\n",
+				dev->name, (cib || sl->xleft) ?
+				       "bad line quality" : "driver error");
+		}
 		sl->xleft = 0;
 		sl->tty->flags &= ~(1 << TTY_DO_WRITE_WAKEUP);
 		sl_unlock(sl);
@@ -829,6 +833,8 @@ static int slip_open(struct tty_struct *
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
+	if (!tty->driver->write)
+		return -EOPNOTSUPP;
 
 	/* RTnetlink lock is misused here to serialize concurrent
 	   opens of slip channels. There are better ways, but it is
--- a/drivers/net/wan/x25_asy.c
+++ b/drivers/net/wan/x25_asy.c
@@ -283,6 +283,10 @@ static void x25_asy_write_wakeup(struct 
 static void x25_asy_timeout(struct net_device *dev)
 {
 	struct x25_asy *sl = (struct x25_asy*)(dev->priv);
+	int cib = 0;
+
+	if (sl->tty->driver->chars_in_buffer)
+		cib = sl->tty->driver->chars_in_buffer(sl->tty);
 
 	spin_lock(&sl->lock);
 	if (netif_queue_stopped(dev)) {
@@ -290,8 +294,7 @@ static void x25_asy_timeout(struct net_d
 		 *      14 Oct 1994 Dmitry Gorodchanin.
 		 */
 		printk(KERN_WARNING "%s: transmit timed out, %s?\n", dev->name,
-		       (sl->tty->driver->chars_in_buffer(sl->tty) || sl->xleft) ?
-		       "bad line quality" : "driver error");
+		       (cib || sl->xleft) ? "bad line quality" : "driver error");
 		sl->xleft = 0;
 		sl->tty->flags &= ~(1 << TTY_DO_WRITE_WAKEUP);
 		x25_asy_unlock(sl);
@@ -561,6 +564,9 @@ static int x25_asy_open_tty(struct tty_s
 		return -EEXIST;
 	}
 
+	if (!tty->driver->write)
+		return -EOPNOTSUPP;
+
 	/* OK.  Find a free X.25 channel to use. */
 	if ((sl = x25_asy_alloc()) == NULL) {
 		return -ENFILE;
--- a/drivers/net/wireless/strip.c
+++ b/drivers/net/wireless/strip.c
@@ -802,7 +802,8 @@ static void set_baud(struct tty_struct *
 	struct ktermios old_termios = *(tty->termios);
 	tty->termios->c_cflag &= ~CBAUD;	/* Clear the old baud setting */
 	tty->termios->c_cflag |= baudcode;	/* Set the new baud setting */
-	tty->driver->set_termios(tty, &old_termios);
+	if (tty->driver->set_termios)
+		tty->driver->set_termios(tty, &old_termios);
 }
 
 /*

-- 
