Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYJGAut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYJGAut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756938AbYJGAoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:44:01 -0400
Received: from ns2.suse.de ([195.135.220.15]:60549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757489AbYJGAn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:43:59 -0400
Date: Mon, 6 Oct 2008 17:38:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 28/71] rt2x00: Use ieee80211_hw->workqueue again
Message-ID: <20081007003838.GC3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rt2x00-use-ieee80211_hw-workqueue-again.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Ivo van Doorn <ivdoorn@gmail.com>

commit 8e260c22238dd8b57aefb1f5e4bd114486a9c17d upstream

Remove the rt2x00 singlethreaded workqueue and move
the link tuner and packet filter scheduled work to
the ieee80211_hw->workqueue again.
The only exception is the interface scheduled work
handler which uses the mac80211 interface iterator
under the RTNL lock. This work needs to be handled
on the kernel workqueue to prevent lockdep issues.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rt2x00/rt2x00.h    |    4 +++-
 drivers/net/wireless/rt2x00/rt2x00dev.c |   17 +++--------------
 drivers/net/wireless/rt2x00/rt2x00mac.c |    4 ++--
 3 files changed, 8 insertions(+), 17 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -75,7 +75,7 @@ static void rt2x00lib_start_link_tuner(s
 
 	rt2x00lib_reset_link_tuner(rt2x00dev);
 
-	queue_delayed_work(rt2x00dev->workqueue,
+	queue_delayed_work(rt2x00dev->hw->workqueue,
 			   &rt2x00dev->link.work, LINK_TUNE_INTERVAL);
 }
 
@@ -390,7 +390,7 @@ static void rt2x00lib_link_tuner(struct 
 	 * Increase tuner counter, and reschedule the next link tuner run.
 	 */
 	rt2x00dev->link.count++;
-	queue_delayed_work(rt2x00dev->workqueue,
+	queue_delayed_work(rt2x00dev->hw->workqueue,
 			   &rt2x00dev->link.work, LINK_TUNE_INTERVAL);
 }
 
@@ -488,7 +488,7 @@ void rt2x00lib_beacondone(struct rt2x00_
 						   rt2x00lib_beacondone_iter,
 						   rt2x00dev);
 
-	queue_work(rt2x00dev->workqueue, &rt2x00dev->intf_work);
+	schedule_work(&rt2x00dev->intf_work);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_beacondone);
 
@@ -1131,10 +1131,6 @@ int rt2x00lib_probe_dev(struct rt2x00_de
 	/*
 	 * Initialize configuration work.
 	 */
-	rt2x00dev->workqueue = create_singlethread_workqueue("rt2x00lib");
-	if (!rt2x00dev->workqueue)
-		goto exit;
-
 	INIT_WORK(&rt2x00dev->intf_work, rt2x00lib_intf_scheduled);
 	INIT_WORK(&rt2x00dev->filter_work, rt2x00lib_packetfilter_scheduled);
 	INIT_DELAYED_WORK(&rt2x00dev->link.work, rt2x00lib_link_tuner);
@@ -1195,13 +1191,6 @@ void rt2x00lib_remove_dev(struct rt2x00_
 	rt2x00leds_unregister(rt2x00dev);
 
 	/*
-	 * Stop all queued work. Note that most tasks will already be halted
-	 * during rt2x00lib_disable_radio() and rt2x00lib_uninitialize().
-	 */
-	flush_workqueue(rt2x00dev->workqueue);
-	destroy_workqueue(rt2x00dev->workqueue);
-
-	/*
 	 * Free ieee80211_hw memory.
 	 */
 	rt2x00lib_remove_hw(rt2x00dev);
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -820,8 +820,10 @@ struct rt2x00_dev {
 
 	/*
 	 * Scheduled work.
+	 * NOTE: intf_work will use ieee80211_iterate_active_interfaces()
+	 * which means it cannot be placed on the hw->workqueue
+	 * due to RTNL locking requirements.
 	 */
-	struct workqueue_struct *workqueue;
 	struct work_struct intf_work;
 	struct work_struct filter_work;
 
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -428,7 +428,7 @@ void rt2x00mac_configure_filter(struct i
 	if (!test_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags))
 		rt2x00dev->ops->lib->config_filter(rt2x00dev, *total_flags);
 	else
-		queue_work(rt2x00dev->workqueue, &rt2x00dev->filter_work);
+		queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->filter_work);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_configure_filter);
 
@@ -509,7 +509,7 @@ void rt2x00mac_bss_info_changed(struct i
 	memcpy(&intf->conf, bss_conf, sizeof(*bss_conf));
 	if (delayed) {
 		intf->delayed_flags |= delayed;
-		queue_work(rt2x00dev->workqueue, &rt2x00dev->intf_work);
+		schedule_work(&rt2x00dev->intf_work);
 	}
 	spin_unlock(&intf->lock);
 }

-- 
