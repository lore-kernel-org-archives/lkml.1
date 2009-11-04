Return-Path: <linux-kernel-owner+w=401wt.eu-S932661AbZKDV0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661AbZKDV0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758176AbZKDV0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:26:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:47087 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190AbZKDV0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:26:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xGNGIc4+IYt6uyc8dmBg/PNORe08QMzo0xMCqQMkvDZIeESSlOWMz9XK823kgWfpUH
         d1dz5k1IFExn6iCHFqw8TCWWj0sdsiAO2Sqcb/IpDfhxd/J0KQGG/HZhWNG6wrNNRO2j
         5M/RRd0PvQPb3n9Iio20TUbfYAWiXn2QxDwLo=
From: Paul Fertser <fercerpav@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH 5/6] power: pcf50633: properly reenable charging when the supply conditions change
Date: Thu,  5 Nov 2009 00:24:58 +0300
Message-Id: <1257369899-325-5-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1257369899-325-4-git-send-email-fercerpav@gmail.com>
References: <1257369899-325-1-git-send-email-fercerpav@gmail.com>
 <1257369899-325-2-git-send-email-fercerpav@gmail.com>
 <1257369899-325-3-git-send-email-fercerpav@gmail.com>
 <1257369899-325-4-git-send-email-fercerpav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If chgmod == BATFULL, setting chgena has no effect. Datasheet says we
need to set resume instead but when autoresume is used resume doesn't
work. Clear and set chgena instead.

This enables a user to force charging by re-plugging USB even when the
charger entered Battery Full mode, might be handy before a long trip.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/power/pcf50633-charger.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
index 3383119..4718733 100644
--- a/drivers/power/pcf50633-charger.c
+++ b/drivers/power/pcf50633-charger.c
@@ -92,14 +92,18 @@ int pcf50633_mbc_usb_curlim_set(struct pcf50633 *pcf, int ma)
 	chgmod = (mbcs2 & PCF50633_MBCS2_MBC_MASK);
 
 	/* If chgmod == BATFULL, setting chgena has no effect.
-	 * We need to set resume instead.
+	 * Datasheet says we need to set resume instead but when autoresume is
+	 * used resume doesn't work. Clear and set chgena instead.
 	 */
 	if (chgmod != PCF50633_MBCS2_MBC_BAT_FULL)
 		pcf50633_reg_set_bit_mask(pcf, PCF50633_REG_MBCC1,
 				PCF50633_MBCC1_CHGENA, PCF50633_MBCC1_CHGENA);
-	else
+	else {
+		pcf50633_reg_clear_bits(pcf, PCF50633_REG_MBCC1,
+				PCF50633_MBCC1_CHGENA);
 		pcf50633_reg_set_bit_mask(pcf, PCF50633_REG_MBCC1,
-				PCF50633_MBCC1_RESUME, PCF50633_MBCC1_RESUME);
+				PCF50633_MBCC1_CHGENA, PCF50633_MBCC1_CHGENA);
+	}
 
 	mbc->usb_active = charging_start;
 
-- 
1.6.4.4

