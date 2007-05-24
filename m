Return-Path: <linux-kernel-owner+w=401wt.eu-S1758511AbXEXMUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511AbXEXMUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbXEXMUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:20:37 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:37984 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755588AbXEXMUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:20:37 -0400
Message-id: <21152561019300868@wsc.cz>
Subject: [PATCH 1/3] Char: moxa, eliminate busy waiting
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Thu, 24 May 2007 14:20:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

moxa, eliminate busy waiting

blah, moxa delays 250+ ms in busy waiting, use msleep instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 3f4308a387d98370556455e729787cc47f200757
tree 26ae5bab0e6f56a06c71c8f15533f643d070da4f
parent 4ea1257b890befc706f6d43562ba68671db39195
author Jiri Slaby <jirislaby@gmail.com> Wed, 23 May 2007 16:24:40 +0200
committer Jiri Slaby <jirislaby@gmail.com> Wed, 23 May 2007 16:24:40 +0200

 drivers/char/moxa.c |   37 ++++++++++++-------------------------
 1 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index e0d35c2..ed76f0a 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -1405,7 +1405,6 @@ static int moxaCard;
 static struct mon_str moxaLog;
 static int moxaFuncTout = HZ / 2;
 
-static void moxadelay(int);
 static void moxafunc(void __iomem *, int, ushort);
 static void wait_finish(void __iomem *);
 static void low_water_check(void __iomem *);
@@ -2404,10 +2403,10 @@ void MoxaPortSendBreak(int port, int ms100)
 	ofsAddr = moxa_ports[port].tableAddr;
 	if (ms100) {
 		moxafunc(ofsAddr, FC_SendBreak, Magic_code);
-		moxadelay(ms100 * (HZ / 10));
+		msleep(ms100 * 10);
 	} else {
 		moxafunc(ofsAddr, FC_SendBreak, Magic_code);
-		moxadelay(HZ / 4);	/* 250 ms */
+		msleep(250);
 	}
 	moxafunc(ofsAddr, FC_StopBreak, Magic_code);
 }
@@ -2476,18 +2475,6 @@ static int moxa_set_serial_info(struct moxa_port *info,
 /*****************************************************************************
  *	Static local functions: 					     *
  *****************************************************************************/
-/*
- * moxadelay - delays a specified number ticks
- */
-static void moxadelay(int tick)
-{
-	unsigned long st, et;
-
-	st = jiffies;
-	et = st + tick;
-	while (time_before(jiffies, et));
-}
-
 static void moxafunc(void __iomem *ofsAddr, int cmd, ushort arg)
 {
 
@@ -2535,7 +2522,7 @@ static int moxaloadbios(int cardno, unsigned char __user *tmp, int len)
 		return -EFAULT;
 	baseAddr = moxa_boards[cardno].basemem;
 	writeb(HW_reset, baseAddr + Control_reg);	/* reset */
-	moxadelay(1);		/* delay 10 ms */
+	msleep(10);
 	for (i = 0; i < 4096; i++)
 		writeb(0, baseAddr + i);	/* clear fix page */
 	for (i = 0; i < len; i++)
@@ -2713,7 +2700,7 @@ static int moxaloadc218(int cardno, void __iomem *baseAddr, int len)
 			for (i = 0; i < 100; i++) {
 				if (readw(baseAddr + C218_key) == keycode)
 					break;
-				moxadelay(1);	/* delay 10 ms */
+				msleep(10);
 			}
 			if (readw(baseAddr + C218_key) != keycode) {
 				return (-1);
@@ -2725,7 +2712,7 @@ static int moxaloadc218(int cardno, void __iomem *baseAddr, int len)
 		for (i = 0; i < 100; i++) {
 			if (readw(baseAddr + C218_key) == keycode)
 				break;
-			moxadelay(1);	/* delay 10 ms */
+			msleep(10);
 		}
 		retry++;
 	} while ((readb(baseAddr + C218chksum_ok) != 1) && (retry < 3));
@@ -2736,7 +2723,7 @@ static int moxaloadc218(int cardno, void __iomem *baseAddr, int len)
 	for (i = 0; i < 100; i++) {
 		if (readw(baseAddr + Magic_no) == Magic_code)
 			break;
-		moxadelay(1);	/* delay 10 ms */
+		msleep(10);
 	}
 	if (readw(baseAddr + Magic_no) != Magic_code) {
 		return (-1);
@@ -2746,7 +2733,7 @@ static int moxaloadc218(int cardno, void __iomem *baseAddr, int len)
 	for (i = 0; i < 100; i++) {
 		if (readw(baseAddr + Magic_no) == Magic_code)
 			break;
-		moxadelay(1);	/* delay 10 ms */
+		msleep(10);
 	}
 	if (readw(baseAddr + Magic_no) != Magic_code) {
 		return (-1);
@@ -2788,7 +2775,7 @@ static int moxaloadc320(int cardno, void __iomem *baseAddr, int len, int *numPor
 			for (i = 0; i < 10; i++) {
 				if (readw(baseAddr + C320_key) == C320_KeyCode)
 					break;
-				moxadelay(1);
+				msleep(10);
 			}
 			if (readw(baseAddr + C320_key) != C320_KeyCode)
 				return (-1);
@@ -2799,7 +2786,7 @@ static int moxaloadc320(int cardno, void __iomem *baseAddr, int len, int *numPor
 		for (i = 0; i < 10; i++) {
 			if (readw(baseAddr + C320_key) == C320_KeyCode)
 				break;
-			moxadelay(1);
+			msleep(10);
 		}
 		retry++;
 	} while ((readb(baseAddr + C320chksum_ok) != 1) && (retry < 3));
@@ -2809,7 +2796,7 @@ static int moxaloadc320(int cardno, void __iomem *baseAddr, int len, int *numPor
 	for (i = 0; i < 600; i++) {
 		if (readw(baseAddr + Magic_no) == Magic_code)
 			break;
-		moxadelay(1);
+		msleep(10);
 	}
 	if (readw(baseAddr + Magic_no) != Magic_code)
 		return (-100);
@@ -2828,7 +2815,7 @@ static int moxaloadc320(int cardno, void __iomem *baseAddr, int len, int *numPor
 	for (i = 0; i < 500; i++) {
 		if (readw(baseAddr + Magic_no) == Magic_code)
 			break;
-		moxadelay(1);
+		msleep(10);
 	}
 	if (readw(baseAddr + Magic_no) != Magic_code)
 		return (-102);
@@ -2842,7 +2829,7 @@ static int moxaloadc320(int cardno, void __iomem *baseAddr, int len, int *numPor
 	for (i = 0; i < 600; i++) {
 		if (readw(baseAddr + Magic_no) == Magic_code)
 			break;
-		moxadelay(1);
+		msleep(10);
 	}
 	if (readw(baseAddr + Magic_no) != Magic_code)
 		return (-102);
