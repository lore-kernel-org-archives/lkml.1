Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbZBKAnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbZBKAnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbZBKA2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:47 -0500
Received: from kroah.org ([198.145.64.141]:51518 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756256AbZBKA2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:45 -0500
Date: Tue, 10 Feb 2009 16:25:44 -0800
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
       alan@lxorguk.ukuu.org.uk, Helmut Schaa <helmut.schaa@googlemail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 43/56] ipw2200: fix scanning while associated
Message-ID: <20090211002544.GR14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipw2200-fix-scanning-while-associated.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Helmut Schaa <helmut.schaa@googlemail.com>

commit 14a4dfe2ff8c353f59ae8324059ded1cfe22c7d9 upstream.

This patch fixes sporadic firmware restarts when scanning while associated.

The firmware will quietly cancel a scan (while associated) if the dwell time
for a channel to be scanned is larger than the time it may stay away from the
operating channel (because of DTIM catching). Unfortunately the driver is not
notified about the canceled scan and therefore the scan watchdog timeout will
be hit and the driver causes a firmware restart which results in
disassociation. This mainly happens on passive channels which use a dwell time
of 120 whereas a typical beacon interval is around 100.

The patch changes the dwell time for passive channels to be slightly smaller
than the actual beacon interval to work around the firmware issue. Furthermore
the number of allowed beacon misses is increased from one to three as otherwise
most scans (while associated) won't complete successfully.

However scanning while associated will still fail in corner cases such as a
beacon intervals below 30.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ipw2200.c |   28 ++++++++++++++++++++++------
 drivers/net/wireless/ipw2200.h |    1 +
 2 files changed, 23 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -4346,7 +4346,8 @@ static void ipw_handle_missed_beacon(str
 		return;
 	}
 
-	if (priv->status & STATUS_SCANNING) {
+	if (priv->status & STATUS_SCANNING &&
+	    missed_count > IPW_MB_SCAN_CANCEL_THRESHOLD) {
 		/* Stop scan to keep fw from getting
 		 * stuck (only if we aren't roaming --
 		 * otherwise we'll never scan more than 2 or 3
@@ -6276,6 +6277,20 @@ static void ipw_add_scan_channels(struct
 	}
 }
 
+static int ipw_passive_dwell_time(struct ipw_priv *priv)
+{
+	/* staying on passive channels longer than the DTIM interval during a
+	 * scan, while associated, causes the firmware to cancel the scan
+	 * without notification. Hence, don't stay on passive channels longer
+	 * than the beacon interval.
+	 */
+	if (priv->status & STATUS_ASSOCIATED
+	    && priv->assoc_network->beacon_interval > 10)
+		return priv->assoc_network->beacon_interval - 10;
+	else
+		return 120;
+}
+
 static int ipw_request_scan_helper(struct ipw_priv *priv, int type, int direct)
 {
 	struct ipw_scan_request_ext scan;
@@ -6319,16 +6334,16 @@ static int ipw_request_scan_helper(struc
 	scan.full_scan_index = cpu_to_le32(ieee80211_get_scans(priv->ieee));
 
 	if (type == IW_SCAN_TYPE_PASSIVE) {
-	  	IPW_DEBUG_WX("use passive scanning\n");
-	  	scan_type = IPW_SCAN_PASSIVE_FULL_DWELL_SCAN;
+		IPW_DEBUG_WX("use passive scanning\n");
+		scan_type = IPW_SCAN_PASSIVE_FULL_DWELL_SCAN;
 		scan.dwell_time[IPW_SCAN_PASSIVE_FULL_DWELL_SCAN] =
-			cpu_to_le16(120);
+			cpu_to_le16(ipw_passive_dwell_time(priv));
 		ipw_add_scan_channels(priv, &scan, scan_type);
 		goto send_request;
 	}
 
 	/* Use active scan by default. */
-  	if (priv->config & CFG_SPEED_SCAN)
+	if (priv->config & CFG_SPEED_SCAN)
 		scan.dwell_time[IPW_SCAN_ACTIVE_BROADCAST_SCAN] =
 			cpu_to_le16(30);
 	else
@@ -6338,7 +6353,8 @@ static int ipw_request_scan_helper(struc
 	scan.dwell_time[IPW_SCAN_ACTIVE_BROADCAST_AND_DIRECT_SCAN] =
 		cpu_to_le16(20);
 
-  	scan.dwell_time[IPW_SCAN_PASSIVE_FULL_DWELL_SCAN] = cpu_to_le16(120);
+	scan.dwell_time[IPW_SCAN_PASSIVE_FULL_DWELL_SCAN] =
+		cpu_to_le16(ipw_passive_dwell_time(priv));
 	scan.dwell_time[IPW_SCAN_ACTIVE_DIRECT_SCAN] = cpu_to_le16(20);
 
 #ifdef CONFIG_IPW2200_MONITOR
--- a/drivers/net/wireless/ipw2200.h
+++ b/drivers/net/wireless/ipw2200.h
@@ -244,6 +244,7 @@ enum connection_manager_assoc_states {
 #define HOST_NOTIFICATION_S36_MEASUREMENT_REFUSED       31
 
 #define HOST_NOTIFICATION_STATUS_BEACON_MISSING         1
+#define IPW_MB_SCAN_CANCEL_THRESHOLD                    3
 #define IPW_MB_ROAMING_THRESHOLD_MIN                    1
 #define IPW_MB_ROAMING_THRESHOLD_DEFAULT                8
 #define IPW_MB_ROAMING_THRESHOLD_MAX                    30

