Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbYBVOsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbYBVOsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbYBVOrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:47:32 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:42275 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbYBVOr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:47:29 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <alan@lxorguk.ukuu.org.uk>,
       Oyvind Aabling <Oyvind.Aabling@uni-c.dk>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 06/19] Char: moxa, merge c2xx and c320 firmware loading
Date: Fri, 22 Feb 2008 15:46:33 +0100
Message-Id: <1203691606-9310-6-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
References: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
---
 drivers/char/moxa.c |  188 +++++++++++++++++++--------------------------------
 1 files changed, 69 insertions(+), 119 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 133819c..fa58fa1 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -368,92 +368,40 @@ static int moxa_load_320b(struct moxa_board_conf *brd, const u8 *ptr,
 	return 0;
 }
 
-static int moxa_load_c218(struct moxa_board_conf *brd, const void *ptr,
+static int moxa_real_load_code(struct moxa_board_conf *brd, const void *ptr,
 		size_t len)
 {
 	void __iomem *baseAddr = brd->basemem;
 	const u16 *uptr = ptr;
 	size_t wlen, len2, j;
-	unsigned int i, retry;
+	unsigned long key, loadbuf, loadlen, checksum, checksum_ok;
+	unsigned int i, retry, c320;
 	u16 usum, keycode;
 
-	if (brd->boardType == MOXA_BOARD_CP204J)
-		keycode = CP204J_KeyCode;
-	else
-		keycode = C218_KeyCode;
-	usum = 0;
-	wlen = len >> 1;
-	for (i = 0; i < wlen; i++)
-		usum += le16_to_cpu(uptr[i]);
-	retry = 0;
-	do {
-		wlen = len >> 1;
-		j = 0;
-		while (wlen) {
-			len2 = (wlen > 2048) ? 2048 : wlen;
-			wlen -= len2;
-			memcpy_toio(baseAddr + C218_LoadBuf, ptr + j,
-					len2 << 1);
-			j += len2 << 1;
-
-			writew(len2, baseAddr + C218DLoad_len);
-			writew(0, baseAddr + C218_key);
-			for (i = 0; i < 100; i++) {
-				if (readw(baseAddr + C218_key) == keycode)
-					break;
-				msleep(10);
-			}
-			if (readw(baseAddr + C218_key) != keycode)
-				return -EIO;
-		}
-		writew(0, baseAddr + C218DLoad_len);
-		writew(usum, baseAddr + C218check_sum);
-		writew(0, baseAddr + C218_key);
-		for (i = 0; i < 100; i++) {
-			if (readw(baseAddr + C218_key) == keycode)
-				break;
-			msleep(10);
-		}
-		retry++;
-	} while ((readb(baseAddr + C218chksum_ok) != 1) && (retry < 3));
-	if (readb(baseAddr + C218chksum_ok) != 1)
-		return -EIO;
+	c320 = brd->boardType == MOXA_BOARD_C320_PCI ||
+			brd->boardType == MOXA_BOARD_C320_ISA;
+	keycode = (brd->boardType == MOXA_BOARD_CP204J) ? CP204J_KeyCode :
+				C218_KeyCode;
 
-	writew(0, baseAddr + C218_key);
-	for (i = 0; i < 100; i++) {
-		if (readw(baseAddr + Magic_no) == Magic_code)
-			break;
-		msleep(10);
-	}
-	if (readw(baseAddr + Magic_no) != Magic_code)
-		return -EIO;
-
-	writew(1, baseAddr + Disable_IRQ);
-	writew(0, baseAddr + Magic_no);
-	for (i = 0; i < 100; i++) {
-		if (readw(baseAddr + Magic_no) == Magic_code)
-			break;
-		msleep(10);
+	switch (brd->boardType) {
+	case MOXA_BOARD_CP204J:
+	case MOXA_BOARD_C218_ISA:
+	case MOXA_BOARD_C218_PCI:
+		key = C218_key;
+		loadbuf = C218_LoadBuf;
+		loadlen = C218DLoad_len;
+		checksum = C218check_sum;
+		checksum_ok = C218chksum_ok;
+		break;
+	default:
+		key = C320_key;
+		keycode = C320_KeyCode;
+		loadbuf = C320_LoadBuf;
+		loadlen = C320DLoad_len;
+		checksum = C320check_sum;
+		checksum_ok = C320chksum_ok;
+		break;
 	}
-	if (readw(baseAddr + Magic_no) != Magic_code)
-		return -EIO;
-
-	moxaCard = 1;
-	brd->intNdx = baseAddr + IRQindex;
-	brd->intPend = baseAddr + IRQpending;
-	brd->intTable = baseAddr + IRQtable;
-
-	return 0;
-}
-
-static int moxa_load_c320(struct moxa_board_conf *brd, const void *ptr,
-		size_t len)
-{
-	void __iomem *baseAddr = brd->basemem;
-	const u16 *uptr = ptr;
-	size_t wlen, len2, j;
-	unsigned int i, retry;
-	u16 usum;
 
 	usum = 0;
 	wlen = len >> 1;
@@ -466,33 +414,33 @@ static int moxa_load_c320(struct moxa_board_conf *brd, const void *ptr,
 		while (wlen) {
 			len2 = (wlen > 2048) ? 2048 : wlen;
 			wlen -= len2;
-			memcpy_toio(baseAddr + C320_LoadBuf, ptr + j,
-					len2 << 1);
+			memcpy_toio(baseAddr + loadbuf, ptr + j, len2 << 1);
 			j += len2 << 1;
-			writew(len2, baseAddr + C320DLoad_len);
-			writew(0, baseAddr + C320_key);
-			for (i = 0; i < 10; i++) {
-				if (readw(baseAddr + C320_key) == C320_KeyCode)
+
+			writew(len2, baseAddr + loadlen);
+			writew(0, baseAddr + key);
+			for (i = 0; i < 100; i++) {
+				if (readw(baseAddr + key) == keycode)
 					break;
 				msleep(10);
 			}
-			if (readw(baseAddr + C320_key) != C320_KeyCode)
+			if (readw(baseAddr + key) != keycode)
 				return -EIO;
 		}
-		writew(0, baseAddr + C320DLoad_len);
-		writew(usum, baseAddr + C320check_sum);
-		writew(0, baseAddr + C320_key);
-		for (i = 0; i < 10; i++) {
-			if (readw(baseAddr + C320_key) == C320_KeyCode)
+		writew(0, baseAddr + loadlen);
+		writew(usum, baseAddr + checksum);
+		writew(0, baseAddr + key);
+		for (i = 0; i < 100; i++) {
+			if (readw(baseAddr + key) == keycode)
 				break;
 			msleep(10);
 		}
 		retry++;
-	} while ((readb(baseAddr + C320chksum_ok) != 1) && (retry < 3));
-	if (readb(baseAddr + C320chksum_ok) != 1)
+	} while ((readb(baseAddr + checksum_ok) != 1) && (retry < 3));
+	if (readb(baseAddr + checksum_ok) != 1)
 		return -EIO;
 
-	writew(0, baseAddr + C320_key);
+	writew(0, baseAddr + key);
 	for (i = 0; i < 600; i++) {
 		if (readw(baseAddr + Magic_no) == Magic_code)
 			break;
@@ -501,14 +449,16 @@ static int moxa_load_c320(struct moxa_board_conf *brd, const void *ptr,
 	if (readw(baseAddr + Magic_no) != Magic_code)
 		return -EIO;
 
-	if (brd->busType == MOXA_BUS_TYPE_PCI) {	/* ASIC board */
-		writew(0x3800, baseAddr + TMS320_PORT1);
-		writew(0x3900, baseAddr + TMS320_PORT2);
-		writew(28499, baseAddr + TMS320_CLOCK);
-	} else {
-		writew(0x3200, baseAddr + TMS320_PORT1);
-		writew(0x3400, baseAddr + TMS320_PORT2);
-		writew(19999, baseAddr + TMS320_CLOCK);
+	if (c320) {
+		if (brd->busType == MOXA_BUS_TYPE_PCI) {	/* ASIC board */
+			writew(0x3800, baseAddr + TMS320_PORT1);
+			writew(0x3900, baseAddr + TMS320_PORT2);
+			writew(28499, baseAddr + TMS320_CLOCK);
+		} else {
+			writew(0x3200, baseAddr + TMS320_PORT1);
+			writew(0x3400, baseAddr + TMS320_PORT2);
+			writew(19999, baseAddr + TMS320_CLOCK);
+		}
 	}
 	writew(1, baseAddr + Disable_IRQ);
 	writew(0, baseAddr + Magic_no);
@@ -520,19 +470,21 @@ static int moxa_load_c320(struct moxa_board_conf *brd, const void *ptr,
 	if (readw(baseAddr + Magic_no) != Magic_code)
 		return -EIO;
 
-	j = readw(baseAddr + Module_cnt);
-	if (j <= 0)
-		return -EIO;
-	brd->numPorts = j * 8;
-	writew(j, baseAddr + Module_no);
-	writew(0, baseAddr + Magic_no);
-	for (i = 0; i < 600; i++) {
-		if (readw(baseAddr + Magic_no) == Magic_code)
-			break;
-		msleep(10);
+	if (c320) {
+		j = readw(baseAddr + Module_cnt);
+		if (j <= 0)
+			return -EIO;
+		brd->numPorts = j * 8;
+		writew(j, baseAddr + Module_no);
+		writew(0, baseAddr + Magic_no);
+		for (i = 0; i < 600; i++) {
+			if (readw(baseAddr + Magic_no) == Magic_code)
+				break;
+			msleep(10);
+		}
+		if (readw(baseAddr + Magic_no) != Magic_code)
+			return -EIO;
 	}
-	if (readw(baseAddr + Magic_no) != Magic_code)
-		return -EIO;
 	moxaCard = 1;
 	brd->intNdx = baseAddr + IRQindex;
 	brd->intPend = baseAddr + IRQpending;
@@ -549,17 +501,18 @@ static int moxa_load_code(struct moxa_board_conf *brd, const void *ptr,
 	int retval, i;
 
 	if (len % 2) {
-		printk(KERN_ERR "moxa: C2XX bios length is not even\n");
+		printk(KERN_ERR "moxa: bios length is not even\n");
 		return -EINVAL;
 	}
 
+	retval = moxa_real_load_code(brd, ptr, len); /* may change numPorts */
+	if (retval)
+		return retval;
+
 	switch (brd->boardType) {
 	case MOXA_BOARD_C218_ISA:
 	case MOXA_BOARD_C218_PCI:
 	case MOXA_BOARD_CP204J:
-		retval = moxa_load_c218(brd, ptr, len);
-		if (retval)
-			return retval;
 		port = brd->ports;
 		for (i = 0; i < brd->numPorts; i++, port++) {
 			port->chkPort = 1;
@@ -579,9 +532,6 @@ static int moxa_load_code(struct moxa_board_conf *brd, const void *ptr,
 		}
 		break;
 	default:
-		retval = moxa_load_c320(brd, ptr, len); /* fills in numPorts */
-		if (retval)
-			return retval;
 		port = brd->ports;
 		for (i = 0; i < brd->numPorts; i++, port++) {
 			port->chkPort = 1;
-- 
1.5.4.1

