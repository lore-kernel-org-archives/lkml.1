Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbXEIMBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbXEIMBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756251AbXEIMAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:00:08 -0400
Received: from p2020-adsah02tachib-acca.tokyo.ocn.ne.jp ([219.161.11.20]:60868
	"EHLO eggplant.ddo.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbXEIMAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:00:05 -0400
Message-ID: <1657.192.168.1.10.1178712003.squirrel@eggplant.ddo.jp>
Date: Wed, 9 May 2007 21:00:03 +0900 (JST)
Subject: [PATCH 3/3] rtc:rtc-rs5c313.c : add error handling toavoidhardware
 hangup.
From: "kogiidena" <kogiidena@eggplant.ddo.jp>
To: linux-kernel@vger.kernel.org
Reply-To: kogiidena@eggplant.ddo.jp
User-Agent: SquirrelMail/1.4.5
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It is a patch that adds error processing.
Hanging up by an infinite loop is evaded.
Please apply.

Signed-off-by: kogiidena <kogiidena@eggplant.ddo.jp>
---
diff -urpN OLD/drivers/rtc/rtc-rs5c313.c NEW/drivers/rtc/rtc-rs5c313.c
--- OLD/drivers/rtc/rtc-rs5c313.c	2007-05-08 19:52:11.000000000 +0900
+++ NEW/drivers/rtc/rtc-rs5c313.c	2007-05-08 19:59:15.000000000 +0900
@@ -212,7 +212,9 @@ static inline void rs5c313_write_intintv
 static int rs5c313_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	int data;
+	int cnt;

+	cnt = 0;
 	while (1) {
 		RS5C313_CEENABLE;	/* CE:H */

@@ -225,6 +227,10 @@ static int rs5c313_rtc_read_time(struct
 		RS5C313_CEDISABLE;
 		ndelay(700);	/* CE:L */

+		if (cnt++ > 100) {
+			dev_err(dev, "%s: timeout error\n", __FUNCTION__);
+			return -EIO;
+		}
 	}

 	data = rs5c313_read_reg(RS5C313_ADDR_SEC);
@@ -266,7 +272,9 @@ static int rs5c313_rtc_read_time(struct
 static int rs5c313_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	int data;
+	int cnt;

+	cnt = 0;
 	/* busy check. */
 	while (1) {
 		RS5C313_CEENABLE;	/* CE:H */
@@ -279,6 +287,11 @@ static int rs5c313_rtc_set_time(struct d
 		RS5C313_MISCOP;
 		RS5C313_CEDISABLE;
 		ndelay(700);	/* CE:L */
+
+		if (cnt++ > 100) {
+			dev_err(dev, "%s: timeout error\n", __FUNCTION__);
+			return -EIO;
+		}
 	}

 	data = BIN2BCD(tm->tm_sec);
@@ -317,6 +330,7 @@ static int rs5c313_rtc_set_time(struct d
 static void rs5c313_check_xstp_bit(void)
 {
 	struct rtc_time tm;
+	int cnt;

 	RS5C313_CEENABLE;	/* CE:H */
 	if (rs5c313_read_cntreg() & RS5C313_CNTREG_WTEN_XSTP) {
@@ -326,8 +340,11 @@ static void rs5c313_check_xstp_bit(void)
 		rs5c313_write_cntreg(0x07);

 		/* busy check. */
-		while (rs5c313_read_cntreg() & RS5C313_CNTREG_ADJ_BSY)
+		for (cnt = 0; cnt < 100; cnt++) {
+			if (!(rs5c313_read_cntreg() & RS5C313_CNTREG_ADJ_BSY))
+				break;
 			RS5C313_MISCOP;
+		}

 		memset(&tm, 0, sizeof(struct rtc_time));
 		tm.tm_mday 	= 1;




