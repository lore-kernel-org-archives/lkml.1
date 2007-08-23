Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbXHWGeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbXHWGeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 02:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbXHWGeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 02:34:06 -0400
Received: from smtp5.actcom.co.il ([192.114.47.67]:40862 "EHLO
	smtp5.actcom.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbXHWGeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 02:34:05 -0400
Message-ID: <46CD290C.3020203@compulab.co.il>
Date: Thu, 23 Aug 2007 09:28:28 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.6 (X11/20070822)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Raphael Assenat <raph@8d.com>, Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH] RTC v3020 fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Acked-by: Raphael Assenat <raph@8d.com>

diff --git a/drivers/char/emv3020.c b/drivers/char/emv3020.c
index df7f1a4..1d93269 100644
--- a/drivers/char/emv3020.c
+++ b/drivers/char/emv3020.c
@@ -48,12 +48,16 @@ static void emv3020_set_reg(unsigned char address, unsigned char data)
 {
 	int i;

-	for ( i = 0; i < 4; i++ )
+	for ( i = 0; i < 4; i++ ) {
 		writel((address << (16-i)), EMV3020_VA_RTC);
+		udelay(1);
+	}

 	if ( address < 0xe)
-		for ( i = 0; i < 8; i++)
+		for ( i = 0; i < 8; i++) {
 			writel((data << (16-i)), EMV3020_VA_RTC);
+			udelay(1);
+		}
 }

 static unsigned char emv3020_get_reg(unsigned char address)
@@ -61,12 +65,16 @@ static unsigned char emv3020_get_reg(unsigned char address)
 	unsigned int data=0;
 	int i, tmp;

-	for ( i = 0; i < 4; i++ )
+	for ( i = 0; i < 4; i++ ) {
 		writel((address << (16-i)), EMV3020_VA_RTC);
+		udelay(1);
+	}
+

 	for ( i = 0; i < 8; i++ ) {
 		tmp = readl(EMV3020_VA_RTC);
 		data |= ((tmp & 0x10000) >> (16 - i));
+		udelay(1);
 	}

 	return data;
@@ -108,7 +116,7 @@ static int emv3020_rtc_gettime(struct rtc_time *dt)
 	BCD_TO_BIN(dt->tm_min);
 	BCD_TO_BIN(dt->tm_hour);
 	BCD_TO_BIN(dt->tm_mday);
-	BCD_TO_BIN(dt->tm_mon);
+	BCD_TO_BIN(dt->tm_mon - 1);
 	BCD_TO_BIN(dt->tm_wday);
 	BCD_TO_BIN(dt->tm_year);
 	dt->tm_year += 100;
@@ -148,7 +156,7 @@ static int emv3020_rtc_settime(struct rtc_time *dt)
 	emv3020_set_reg(0x03, dt->tm_min);
 	emv3020_set_reg(0x04, dt->tm_hour);
 	emv3020_set_reg(0x05, dt->tm_mday);
-	emv3020_set_reg(0x06, dt->tm_mon);
+	emv3020_set_reg(0x06, dt->tm_mon + 1);
 	emv3020_set_reg(0x08, dt->tm_wday);
 	emv3020_set_reg(0x07, dt->tm_year);


