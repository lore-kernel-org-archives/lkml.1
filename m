Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbYKCLZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbYKCLZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 06:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbYKCLY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 06:24:57 -0500
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:42887 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755076AbYKCLY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 06:24:56 -0500
Subject: [PATCH 8/8] p80211conv.c copy code from wlan-ng-devel branch to
	not drop packets
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: gregkh <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1225710353.3113.5.camel@castor.localdomain>
References: <1225710353.3113.5.camel@castor.localdomain>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 11:24:54 +0000
Message-Id: <1225711494.3113.34.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

allow card to correctly receive network packets,
without this change all incoming packets are dropped.
code copied from the latest wlan-ng-devel tree.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
 drivers/staging/wlan-ng/p80211conv.c |   49 +++++++++++++++++++++++++++++++++-
 1 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211conv.c b/drivers/staging/wlan-ng/p80211conv.c
index 749ea8d..b09a9ab 100644
--- a/drivers/staging/wlan-ng/p80211conv.c
+++ b/drivers/staging/wlan-ng/p80211conv.c
@@ -380,6 +380,14 @@ int skb_p80211_to_ether( wlandevice_t *wlandev, UINT32 ethconv, struct sk_buff *
 	     (memcmp(saddr, e_hdr->saddr, WLAN_ETHADDR_LEN) == 0))) {
 		WLAN_LOG_DEBUG(3, "802.3 ENCAP len: %d\n", payload_length);
 		/* 802.3 Encapsulated */
+		/* Test for an overlength frame */
+		if ( payload_length > (netdev->mtu + WLAN_ETHHDR_LEN)) {
+			/* A bogus length ethfrm has been encap'd. */
+			/* Is someone trying an oflow attack? */
+			WLAN_LOG_ERROR("ENCAP frame too large (%d > %d)\n",
+				payload_length, netdev->mtu + WLAN_ETHHDR_LEN);
+			return 1;
+		}
 
 		/* Chop off the 802.11 header.  it's already sane. */
 		skb_pull(skb, payload_offset);
@@ -399,6 +407,15 @@ int skb_p80211_to_ether( wlandevice_t *wlandev, UINT32 ethconv, struct sk_buff *
 		/* it's a SNAP + RFC1042 frame && protocol is in STT */
 		/* build 802.3 + RFC1042 */
 
+		/* Test for an overlength frame */
+		if ( payload_length > netdev->mtu ) {
+			/* A bogus length ethfrm has been sent. */
+			/* Is someone trying an oflow attack? */
+			WLAN_LOG_ERROR("SNAP frame too large (%d > %d)\n",
+				payload_length, netdev->mtu);
+			return 1;
+		}
+
 		/* chop 802.11 header from skb. */
 		skb_pull(skb, payload_offset);
 
@@ -419,6 +436,18 @@ int skb_p80211_to_ether( wlandevice_t *wlandev, UINT32 ethconv, struct sk_buff *
 		/* it's an 802.1h frame || (an RFC1042 && protocol is not in STT) */
 		/* build a DIXII + RFC894 */
 
+		/* Test for an overlength frame */
+		if ((payload_length - sizeof(wlan_llc_t) - sizeof(wlan_snap_t))
+		    > netdev->mtu) {
+			/* A bogus length ethfrm has been sent. */
+			/* Is someone trying an oflow attack? */
+			WLAN_LOG_ERROR("DIXII frame too large (%ld > %d)\n",
+					(long int) (payload_length - sizeof(wlan_llc_t) -
+						    sizeof(wlan_snap_t)),
+					netdev->mtu);
+			return 1;
+		}
+
 		/* chop 802.11 header from skb. */
 		skb_pull(skb, payload_offset);
 
@@ -443,6 +472,16 @@ int skb_p80211_to_ether( wlandevice_t *wlandev, UINT32 ethconv, struct sk_buff *
 		/*  build an 802.3 frame */
 		/* allocate space and setup hostbuf */
 
+		/* Test for an overlength frame */
+		if ( payload_length > netdev->mtu ) {
+			/* A bogus length ethfrm has been sent. */
+			/* Is someone trying an oflow attack? */
+			WLAN_LOG_ERROR("OTHER frame too large (%d > %d)\n",
+				payload_length,
+				netdev->mtu);
+			return 1;
+		}
+
 		/* Chop off the 802.11 header. */
 		skb_pull(skb, payload_offset);
 
@@ -457,8 +496,16 @@ int skb_p80211_to_ether( wlandevice_t *wlandev, UINT32 ethconv, struct sk_buff *
 
 	}
 
+        /*
+         * Note that eth_type_trans() expects an skb w/ skb->data pointing
+         * at the MAC header, it then sets the following skb members:
+         * skb->mac_header, 
+         * skb->data, and
+         * skb->pkt_type.
+         * It then _returns_ the value that _we're_ supposed to stuff in
+         * skb->protocol.  This is nuts.
+         */
 	skb->protocol = eth_type_trans(skb, netdev);
-	skb_reset_mac_header(skb);
 
         /* jkriegl: process signal and noise as set in hfa384x_int_rx() */
 	/* jkriegl: only process signal/noise if requested by iwspy */
-- 
1.5.6.5



