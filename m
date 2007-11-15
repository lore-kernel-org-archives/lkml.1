Return-Path: <linux-kernel-owner+w=401wt.eu-S932390AbXKOGtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbXKOGtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762853AbXKOGnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:43:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57682 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762652AbXKOGnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:43:09 -0500
Date: Wed, 14 Nov 2007 22:41:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 14/16] ipw2100: send WEXT scan events
Message-ID: <20071115064116.GO18951@kroah.com>
References: <20071115060353.071060513@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipw2100-send-wext-scan-events.patch"
In-Reply-To: <20071115063921.GA18827@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dcbw@redhat.com>

patch d20c678a450a25c1c12925f60c1b4cc040acc17d in mainline

ipw2100 wasn't sending WEXT scan events at all on scan completion.  And
like ipw2200, the driver aggressively auto-scans, requiring
non-user-requested scan events to be batched together and sent at
specific intervals instead of many times per seconds.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ipw2100.c |   39 +++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ipw2100.h |    4 ++++
 2 files changed, 43 insertions(+)

--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -2102,12 +2102,46 @@ static void isr_indicate_rf_kill(struct 
 	queue_delayed_work(priv->workqueue, &priv->rf_kill, round_jiffies(HZ));
 }
 
+static void send_scan_event(void *data)
+{
+	struct ipw2100_priv *priv = data;
+	union iwreq_data wrqu;
+
+	wrqu.data.length = 0;
+	wrqu.data.flags = 0;
+	wireless_send_event(priv->net_dev, SIOCGIWSCAN, &wrqu, NULL);
+}
+
+static void ipw2100_scan_event_later(struct work_struct *work)
+{
+	send_scan_event(container_of(work, struct ipw2100_priv,
+					scan_event_later.work));
+}
+
+static void ipw2100_scan_event_now(struct work_struct *work)
+{
+	send_scan_event(container_of(work, struct ipw2100_priv,
+					scan_event_now));
+}
+
 static void isr_scan_complete(struct ipw2100_priv *priv, u32 status)
 {
 	IPW_DEBUG_SCAN("scan complete\n");
 	/* Age the scan results... */
 	priv->ieee->scans++;
 	priv->status &= ~STATUS_SCANNING;
+
+	/* Only userspace-requested scan completion events go out immediately */
+	if (!priv->user_requested_scan) {
+		if (!delayed_work_pending(&priv->scan_event_later))
+			queue_delayed_work(priv->workqueue,
+					&priv->scan_event_later,
+					round_jiffies(msecs_to_jiffies(4000)));
+	} else {
+		priv->user_requested_scan = 0;
+		cancel_delayed_work(&priv->scan_event_later);
+		queue_work(priv->workqueue, &priv->scan_event_now);
+	}
 }
 
 #ifdef CONFIG_IPW2100_DEBUG
@@ -4376,6 +4410,7 @@ static void ipw2100_kill_workqueue(struc
 		cancel_delayed_work(&priv->wx_event_work);
 		cancel_delayed_work(&priv->hang_check);
 		cancel_delayed_work(&priv->rf_kill);
+		cancel_delayed_work(&priv->scan_event_later);
 		destroy_workqueue(priv->workqueue);
 		priv->workqueue = NULL;
 	}
@@ -6118,6 +6153,8 @@ static struct net_device *ipw2100_alloc_
 	INIT_DELAYED_WORK(&priv->wx_event_work, ipw2100_wx_event_work);
 	INIT_DELAYED_WORK(&priv->hang_check, ipw2100_hang_check);
 	INIT_DELAYED_WORK(&priv->rf_kill, ipw2100_rf_kill);
+	INIT_WORK(&priv->scan_event_now, ipw2100_scan_event_now);
+	INIT_DELAYED_WORK(&priv->scan_event_later, ipw2100_scan_event_later);
 
 	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
 		     ipw2100_irq_tasklet, (unsigned long)priv);
@@ -7427,6 +7464,8 @@ static int ipw2100_wx_set_scan(struct ne
 	}
 
 	IPW_DEBUG_WX("Initiating scan...\n");
+
+	priv->user_requested_scan = 1;
 	if (ipw2100_set_scan_options(priv) || ipw2100_start_scan(priv)) {
 		IPW_DEBUG_WX("Start scan failed.\n");
 
--- a/drivers/net/wireless/ipw2100.h
+++ b/drivers/net/wireless/ipw2100.h
@@ -588,6 +588,10 @@ struct ipw2100_priv {
 	struct delayed_work wx_event_work;
 	struct delayed_work hang_check;
 	struct delayed_work rf_kill;
+	struct work_struct scan_event_now;
+	struct delayed_work scan_event_later;
+
+	int user_requested_scan;
 
 	u32 interrupts;
 	int tx_interrupts;

-- 
