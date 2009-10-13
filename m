Return-Path: <linux-kernel-owner+w=401wt.eu-S934426AbZJMWA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934426AbZJMWA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934416AbZJMWA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:00:27 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:38202 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbZJMWAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:00:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QG0UoJzM9lDoywOsKcSSlpMSt8F8PFjNQpghdQsDb863hfk/d2lfdPhgrp6npKEfXg
         bpMAC/ZVXphYWSQBk7hjczSwA6uKBcM1iZPaWbHqJiIVkvmEDMsL1H9InRiG9gzVk6Oc
         3k43H2j2/JUtZcUWbzbfovN/fi6BCH0zc1v6E=
From: Paul Fertser <fercerpav@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Nelson Castillo <arhuaco@freaks-unidos.net>,
       Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH] power: pcf50633: properly reenable charging when the supply conditions change
Date: Wed, 14 Oct 2009 01:59:07 +0400
Message-Id: <1255471148-29047-5-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1255471148-29047-4-git-send-email-fercerpav@gmail.com>
References: <1255471148-29047-1-git-send-email-fercerpav@gmail.com>
 <1255471148-29047-2-git-send-email-fercerpav@gmail.com>
 <1255471148-29047-3-git-send-email-fercerpav@gmail.com>
 <1255471148-29047-4-git-send-email-fercerpav@gmail.com>
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
index 644c7eb..e0115d7 100644
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
1.6.0.6

