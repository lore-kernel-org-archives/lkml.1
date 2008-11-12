Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbYKLXZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbYKLXZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbYKLXX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:23:59 -0500
Received: from kroah.org ([198.145.64.141]:53411 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756008AbYKLXX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:23:58 -0500
Subject: patch staging-wlan-ng-p80211conv.c-copy-code-from-wlan-ng-devel-branch-to-not-drop-packets.patch added to gregkh-2.6 tree
To: richard@rsk.demon.co.uk, gregkh@suse.de, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Wed, 12 Nov 2008 15:15:56 -0800
In-Reply-To: <1225711494.3113.34.camel@castor.localdomain>
Message-ID: <12265317563426@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: wlan-ng: p80211conv.c copy code from wlan-ng-devel branch to not drop packets

to my gregkh-2.6 tree.  Its filename is

    staging-wlan-ng-p80211conv.c-copy-code-from-wlan-ng-devel-branch-to-not-drop-packets.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From richard@rsk.demon.co.uk  Wed Nov 12 14:31:45 2008
From: Richard Kennedy <richard@rsk.demon.co.uk>
Date: Mon, 03 Nov 2008 11:24:54 +0000
Subject: Staging: wlan-ng: p80211conv.c copy code from wlan-ng-devel branch to not drop packets
To: gregkh <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Message-ID: <1225711494.3113.34.camel@castor.localdomain>


allow card to correctly receive network packets,
without this change all incoming packets are dropped.
code copied from the latest wlan-ng-devel tree.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/wlan-ng/p80211conv.c |   49 ++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

--- a/drivers/staging/wlan-ng/p80211conv.c
+++ b/drivers/staging/wlan-ng/p80211conv.c
@@ -377,6 +377,14 @@ int skb_p80211_to_ether( wlandevice_t *w
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
@@ -396,6 +404,15 @@ int skb_p80211_to_ether( wlandevice_t *w
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
 
@@ -416,6 +433,18 @@ int skb_p80211_to_ether( wlandevice_t *w
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
 
@@ -440,6 +469,16 @@ int skb_p80211_to_ether( wlandevice_t *w
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
 
@@ -454,8 +493,16 @@ int skb_p80211_to_ether( wlandevice_t *w
 
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


Patches currently in gregkh-2.6 which might be from richard@rsk.demon.co.uk are

staging/staging-wlan-ng-hfa384x_usb.c-use-newest-version-of-384x_drvr_start.patch
staging/staging-wlan-ng-hfa384x_usbin_callback-check-for-hardware-removed.patch
staging/staging-wlan-ng-p80211conv.c-copy-code-from-wlan-ng-devel-branch-to-not-drop-packets.patch
staging/staging-wlan-ng-p80211netdev.c-fix-netdev-alloc-to-prevent-oops-on-device-start.patch
staging/staging-wlan-ng-p80211wext.c-add-latest-changes-remove-extra-nulls-from-wext_handlers.patch
staging/staging-wlan-ng-p80211wext-don-t-set-default-key-id-twice.patch
staging/staging-wlan-ng-prism2_usb.c-always-enable-the-card-in-probe_usb.patch
