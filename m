Return-Path: <linux-kernel-owner+w=401wt.eu-S932158AbZKDRdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbZKDRdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757451AbZKDRdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:33:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:5665 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958AbZKDRdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:33:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=M42YT9cIENmwrQuoIMXkEkltVTRFRFwzR4DQTZBLFyMnobs7+QXd8r5Zf/QgO+b7mR
         1u8b38fh7iUyTvkmxzNO+wuAlYwdJn6pm39vPigeGfKJ3N0/T1IfC37v3hDGdCO26490
         vFNaxfC5K8h3tEa/Vjjt3IEwf8zSZxEWRN4Kw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:32:58 +0100
Message-Id: <20091104173258.28463.94619.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/41] rt2800usb: use rt2x00usb_register_multiwrite() to set key entries
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800usb: use rt2x00usb_register_multiwrite() to set key entries

Since struct hw_key_entry is 32-bytes large and is smaller than
CSR cache size (which is 64-bytes large) we can use the standard
rt2x00usb_register_multiwrite() helper to set key entries.

This cleanup is a part of preparations for later code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -392,7 +392,6 @@ static int rt2800usb_config_shared_key(s
 {
 	struct hw_key_entry key_entry;
 	struct rt2x00_field32 field;
-	int timeout;
 	u32 offset;
 	u32 reg;
 
@@ -407,12 +406,8 @@ static int rt2800usb_config_shared_key(s
 		       sizeof(key_entry.rx_mic));
 
 		offset = SHARED_KEY_ENTRY(key->hw_key_idx);
-		timeout = REGISTER_TIMEOUT32(sizeof(key_entry));
-		rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
-						    USB_VENDOR_REQUEST_OUT,
-						    offset, &key_entry,
-						    sizeof(key_entry),
-						    timeout);
+		rt2x00usb_register_multiwrite(rt2x00dev, offset,
+					      &key_entry, sizeof(key_entry));
 	}
 
 	/*
@@ -445,7 +440,6 @@ static int rt2800usb_config_pairwise_key
 					 struct ieee80211_key_conf *key)
 {
 	struct hw_key_entry key_entry;
-	int timeout;
 	u32 offset;
 
 	if (crypto->cmd == SET_KEY) {
@@ -467,12 +461,8 @@ static int rt2800usb_config_pairwise_key
 		       sizeof(key_entry.rx_mic));
 
 		offset = PAIRWISE_KEY_ENTRY(key->hw_key_idx);
-		timeout = REGISTER_TIMEOUT32(sizeof(key_entry));
-		rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
-						    USB_VENDOR_REQUEST_OUT,
-						    offset, &key_entry,
-						    sizeof(key_entry),
-						    timeout);
+		rt2x00usb_register_multiwrite(rt2x00dev, offset,
+					      &key_entry, sizeof(key_entry));
 	}
 
 	/*
