Return-Path: <linux-kernel-owner+w=401wt.eu-S932714AbYHRTFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714AbYHRTFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932547AbYHRTD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:03:26 -0400
Received: from ns1.suse.de ([195.135.220.2]:44029 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932541AbYHRTDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:03:25 -0400
Date: Mon, 18 Aug 2008 11:45:14 -0700
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
       alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
       Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
       Hin-Tak Leung <htl10@users.sourceforge.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 46/60] rtl8187: Fix lockups due to concurrent access to
	config routine
Message-ID: <20080818184514.GU29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rtl8187-fix-lockups-due-to-concurrent-access-to-config-routine.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Larry Finger <Larry.Finger@lwfinger.net>

With the rtl8187 driver, the config routine is not protected against
access before a previous call has completed. When this happens, the
TX loopback that is needed to change channels may cause the chip to
be locked with a reset needed to restore communications. This patch
entered mainline as commit 7dcdd073bf78bb6958bbc12a1a47754a0f3c4721.

The problem was found by Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
who also suggested this type of fix.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Acked-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/net/wireless/rtl8187.h     |    4 ++++
 drivers/net/wireless/rtl8187_dev.c |    3 +++
 2 files changed, 7 insertions(+)

--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -580,6 +580,7 @@ static int rtl8187_config(struct ieee802
 	struct rtl8187_priv *priv = dev->priv;
 	u32 reg;
 
+	mutex_lock(&priv->conf_mutex);
 	reg = rtl818x_ioread32(priv, &priv->map->TX_CONF);
 	/* Enable TX loopback on MAC level to avoid TX during channel
 	 * changes, as this has be seen to causes problems and the
@@ -610,6 +611,7 @@ static int rtl8187_config(struct ieee802
 	rtl818x_iowrite16(priv, &priv->map->ATIMTR_INTERVAL, 100);
 	rtl818x_iowrite16(priv, &priv->map->BEACON_INTERVAL, 100);
 	rtl818x_iowrite16(priv, &priv->map->BEACON_INTERVAL_TIME, 100);
+	mutex_unlock(&priv->conf_mutex);
 	return 0;
 }
 
@@ -814,6 +816,7 @@ static int __devinit rtl8187_probe(struc
 		printk(KERN_ERR "rtl8187: Cannot register device\n");
 		goto err_free_dev;
 	}
+	mutex_init(&priv->conf_mutex);
 
 	printk(KERN_INFO "%s: hwaddr %s, rtl8187 V%d + %s\n",
 	       wiphy_name(dev->wiphy), print_mac(mac, dev->wiphy->perm_addr),
--- a/drivers/net/wireless/rtl8187.h
+++ b/drivers/net/wireless/rtl8187.h
@@ -67,6 +67,10 @@ struct rtl8187_priv {
 	const struct rtl818x_rf_ops *rf;
 	struct ieee80211_vif *vif;
 	int mode;
+	/* The mutex protects the TX loopback state.
+	 * Any attempt to set channels concurrently locks the device.
+	 */
+	struct mutex conf_mutex;
 
 	/* rtl8187 specific */
 	struct ieee80211_channel channels[14];

-- 
