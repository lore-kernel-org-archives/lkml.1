Return-Path: <linux-kernel-owner+w=401wt.eu-S1161362AbXDKXEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161362AbXDKXEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161368AbXDKXDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 19:03:51 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55588 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161344AbXDKWye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:54:34 -0400
Date: Wed, 11 Apr 2007 15:51:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Francois Romieu <romieu@fr.zoreil.com>,
       Ben Greear <greearb@candelatech.com>
Subject: [patch 12/31] 8139too: RTNL and flush_scheduled_work deadlock
Message-ID: <20070411225156.GM24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="8139too-rtnl-and-flush_scheduled_work-deadlock.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Francois Romieu <romieu@fr.zoreil.com>

Your usual dont-flush_scheduled_work-with-RTNL-held stuff.

It is a bit different here since the thread runs permanently
or is only occasionally kicked for recovery depending on the
hardware revision.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Ben Greear <greearb@candelatech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/8139too.c |   40 +++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

--- a/drivers/net/8139too.c
+++ b/drivers/net/8139too.c
@@ -1109,6 +1109,8 @@ static void __devexit rtl8139_remove_one
 
 	assert (dev != NULL);
 
+	flush_scheduled_work();
+
 	unregister_netdev (dev);
 
 	__rtl8139_cleanup_dev (dev);
@@ -1603,18 +1605,21 @@ static void rtl8139_thread (struct work_
 	struct net_device *dev = tp->mii.dev;
 	unsigned long thr_delay = next_tick;
 
+	rtnl_lock();
+
+	if (!netif_running(dev))
+		goto out_unlock;
+
 	if (tp->watchdog_fired) {
 		tp->watchdog_fired = 0;
 		rtl8139_tx_timeout_task(work);
-	} else if (rtnl_trylock()) {
-		rtl8139_thread_iter (dev, tp, tp->mmio_addr);
-		rtnl_unlock ();
-	} else {
-		/* unlikely race.  mitigate with fast poll. */
-		thr_delay = HZ / 2;
-	}
+	} else
+		rtl8139_thread_iter(dev, tp, tp->mmio_addr);
 
-	schedule_delayed_work(&tp->thread, thr_delay);
+	if (tp->have_thread)
+		schedule_delayed_work(&tp->thread, thr_delay);
+out_unlock:
+	rtnl_unlock ();
 }
 
 static void rtl8139_start_thread(struct rtl8139_private *tp)
@@ -1626,19 +1631,11 @@ static void rtl8139_start_thread(struct 
 		return;
 
 	tp->have_thread = 1;
+	tp->watchdog_fired = 0;
 
 	schedule_delayed_work(&tp->thread, next_tick);
 }
 
-static void rtl8139_stop_thread(struct rtl8139_private *tp)
-{
-	if (tp->have_thread) {
-		cancel_rearming_delayed_work(&tp->thread);
-		tp->have_thread = 0;
-	} else
-		flush_scheduled_work();
-}
-
 static inline void rtl8139_tx_clear (struct rtl8139_private *tp)
 {
 	tp->cur_tx = 0;
@@ -1696,12 +1693,11 @@ static void rtl8139_tx_timeout (struct n
 {
 	struct rtl8139_private *tp = netdev_priv(dev);
 
+	tp->watchdog_fired = 1;
 	if (!tp->have_thread) {
-		INIT_DELAYED_WORK(&tp->thread, rtl8139_tx_timeout_task);
+		INIT_DELAYED_WORK(&tp->thread, rtl8139_thread);
 		schedule_delayed_work(&tp->thread, next_tick);
-	} else
-		tp->watchdog_fired = 1;
-
+	}
 }
 
 static int rtl8139_start_xmit (struct sk_buff *skb, struct net_device *dev)
@@ -2233,8 +2229,6 @@ static int rtl8139_close (struct net_dev
 
 	netif_stop_queue (dev);
 
-	rtl8139_stop_thread(tp);
-
 	if (netif_msg_ifdown(tp))
 		printk(KERN_DEBUG "%s: Shutting down ethercard, status was 0x%4.4x.\n",
 			dev->name, RTL_R16 (IntrStatus));

-- 
