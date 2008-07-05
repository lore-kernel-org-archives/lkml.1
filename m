Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYGEV6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYGEV6K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 17:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbYGEV55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 17:57:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:12530 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbYGEV54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 17:57:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:from:content-type:mime-version
         :content-transfer-encoding:message-id:user-agent:sender;
        b=piYCRJ9rpGH1chpAEGxJyQiaZVrsIY8GrG1LkdVnX/g49DynKZxRHQBYHzo/3dQtn1
         Kw2Mtpe537SV/Uk9+PWlpWRmWSwLPqDjsitBWofvYXBKZ7f/zmKHdlL7h76kFLPbLZbQ
         TKMHy3e+eI+MzNld3r3KvsJre4Fo8ydwCR6bU=
Date: Sat, 05 Jul 2008 23:55:10 +0200
To: linux-kernel@vger.kernel.org
Subject: [PATCH] make decrypt messages depend on CONFIG_IEEE80211_DEBUG
From: "Jonas Karlsson" <jonas@gobolinux.org>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-1
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.udt9t8avdefb7q@localhost.localdomain>
User-Agent: Opera Mail/9.51 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a corresponding patch for commit  
7f3ad8943e2e6336ba229b208be8c7a80730c5d4 but for the old ieee80211 stack,  
which is still used for, at least, ipw2x00 cards. It will make decrypt and  
key debug errors depend on CONFIG_IEEE80211_DEBUG. Without this the logs  
will be filled with debug printouts.

-- 
Jonas Karlsson

(please CC me when replying)

--- linux-2.6.25.10/net/ieee80211/ieee80211_crypt_ccmp.c.old	2008-07-05  
22:36:45.000000000 +0200
+++ linux-2.6.25.10/net/ieee80211/ieee80211_crypt_ccmp.c	2008-07-05  
22:38:30.000000000 +0200
@@ -307,25 +307,31 @@
  	pos = skb->data + hdr_len;
  	keyidx = pos[3];
  	if (!(keyidx & (1 << 5))) {
+#ifdef CONFIG_IEEE80211_DEBUG
  		if (net_ratelimit()) {
  			printk(KERN_DEBUG "CCMP: received packet without ExtIV"
  			       " flag from %s\n", print_mac(mac, hdr->addr2));
  		}
+#endif
  		key->dot11RSNAStatsCCMPFormatErrors++;
  		return -2;
  	}
  	keyidx >>= 6;
  	if (key->key_idx != keyidx) {
+#ifdef CONFIG_IEEE80211_DEBUG
  		printk(KERN_DEBUG "CCMP: RX tkey->key_idx=%d frame "
  		       "keyidx=%d priv=%p\n", key->key_idx, keyidx, priv);
+#endif
  		return -6;
  	}
  	if (!key->key_set) {
+#ifdef CONFIG_IEEE80211_DEBUG
  		if (net_ratelimit()) {
  			printk(KERN_DEBUG "CCMP: received packet from %s"
  			       " with keyid=%d that does not have a configured"
  			       " key\n", print_mac(mac, hdr->addr2), keyidx);
  		}
+#endif
  		return -3;
  	}

@@ -338,6 +344,7 @@
  	pos += 8;

  	if (ccmp_replay_check(pn, key->rx_pn)) {
+#ifdef CONFIG_IEEE80211_DEBUG
  		if (ieee80211_ratelimit_debug(IEEE80211_DL_DROP)) {
  			IEEE80211_DEBUG_DROP("CCMP: replay detected: STA=%s "
  				 "previous PN %02x%02x%02x%02x%02x%02x "
@@ -347,6 +354,7 @@
  				 key->rx_pn[3], key->rx_pn[4], key->rx_pn[5],
  				 pn[0], pn[1], pn[2], pn[3], pn[4], pn[5]);
  		}
+#endif
  		key->dot11RSNAStatsCCMPReplays++;
  		return -4;
  	}
@@ -371,10 +379,12 @@
  	}

  	if (memcmp(mic, a, CCMP_MIC_LEN) != 0) {
+#ifdef CONFIG_IEEE80211_DEBUG
  		if (net_ratelimit()) {
  			printk(KERN_DEBUG "CCMP: decrypt failed: STA="
  			       "%s\n", print_mac(mac, hdr->addr2));
  		}
+#endif
  		key->dot11RSNAStatsCCMPDecryptErrors++;
  		return -5;
  	}


