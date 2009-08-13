Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbZHMRAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbZHMRAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 13:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZHMRAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 13:00:39 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51704 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZHMRAj (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 13:00:39 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Zhu Yi <yi.zhu@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net
Subject: mmotm0812 - something in linux-next killed iwl-3945.c
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1250182794_3970P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 13 Aug 2009 12:59:54 -0400
Message-ID: <19728.1250182794@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1250182794_3970P
Content-Type: text/plain; charset=us-ascii

Build bombs out:

  CC      drivers/net/wireless/iwlwifi/iwl-3945.o
drivers/net/wireless/iwlwifi/iwl-3945.c: In function 'iwl3945_pass_packet_to_mac80211':
drivers/net/wireless/iwlwifi/iwl-3945.c:580: error: 'hdr' undeclared (first use in this function)
drivers/net/wireless/iwlwifi/iwl-3945.c:580: error: (Each undeclared identifier is reported only once
drivers/net/wireless/iwlwifi/iwl-3945.c:580: error: for each function it appears in.)
make[1]: *** [drivers/net/wireless/iwlwifi/iwl-3945.o] Error 1

due to this in linux-next.patch:

index 46288e7..ae7f163 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
(skipping)
@@ -577,7 +577,10 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv
 *priv,
        if (ieee80211_is_data(hdr->frame_control))
                priv->rxtxpackets += len;
 #endif
-       ieee80211_rx_irqsafe(priv->hw, rxb->skb, stats);
+       iwl_update_stats(priv, false, hdr->frame_control, len);
+
+       memcpy(IEEE80211_SKB_RXCB(rxb->skb), stats, sizeof(*stats));
+       ieee80211_rx_irqsafe(priv->hw, rxb->skb);
        rxb->skb = NULL;

Sorry, don't have a linux-next git tree, so no 'git blame' for what did it.
Hopefully somebody recognizes their handiwork... ;)

--==_Exmh_1250182794_3970P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKhEaKcC3lWbTT17ARAsAPAKC3u6aJQvZHnwQRCJO79r5NHvHw3ACfZSd0
Xr8EhV4G5ef8ihpmCa2ko9Q=
=jqP2
-----END PGP SIGNATURE-----

--==_Exmh_1250182794_3970P--
