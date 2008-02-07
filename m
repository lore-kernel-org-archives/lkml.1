Return-Path: <linux-kernel-owner+w=401wt.eu-S933392AbYBGTQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392AbYBGTQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762007AbYBGTPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:15:33 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:39224 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761987AbYBGTPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:15:30 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: "Oyvind Aabling" <Oyvind.Aabling@uni-c.dk>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: [RFT 7/9] Char: moxa, introduce MOXA_IS_320 macro
Date: Thu,  7 Feb 2008 20:11:23 +0100
Message-Id: <1202411485-16022-7-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1202411485-16022-1-git-send-email-jirislaby@gmail.com>
References: <1202411485-16022-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It allows to simplify the code, especially MoxaPortSetBaud.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/moxa.c |   65 +++++++++++++++------------------------------------
 1 files changed, 19 insertions(+), 46 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 5f7fb38..3b1760f 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -59,6 +59,9 @@
 #define MAX_PORTS_PER_BOARD	32	/* Don't change this value */
 #define MAX_PORTS		(MAX_BOARDS * MAX_PORTS_PER_BOARD)
 
+#define MOXA_IS_320(brd) ((brd)->boardType == MOXA_BOARD_C320_ISA || \
+		(brd)->boardType == MOXA_BOARD_C320_PCI)
+
 /*
  *    Define the Moxa PCI vendor and device IDs.
  */
@@ -493,11 +496,9 @@ static int moxa_real_load_code(struct moxa_board_conf *brd, const void *ptr,
 	const u16 *uptr = ptr;
 	size_t wlen, len2, j;
 	unsigned long key, loadbuf, loadlen, checksum, checksum_ok;
-	unsigned int i, retry, c320;
+	unsigned int i, retry;
 	u16 usum, keycode;
 
-	c320 = brd->boardType == MOXA_BOARD_C320_PCI ||
-			brd->boardType == MOXA_BOARD_C320_ISA;
 	keycode = (brd->boardType == MOXA_BOARD_CP204J) ? CP204J_KeyCode :
 				C218_KeyCode;
 
@@ -567,7 +568,7 @@ static int moxa_real_load_code(struct moxa_board_conf *brd, const void *ptr,
 	if (readw(baseAddr + Magic_no) != Magic_code)
 		return -EIO;
 
-	if (c320) {
+	if (MOXA_IS_320(brd)) {
 		if (brd->busType == MOXA_BUS_TYPE_PCI) {	/* ASIC board */
 			writew(0x3800, baseAddr + TMS320_PORT1);
 			writew(0x3900, baseAddr + TMS320_PORT2);
@@ -588,7 +589,7 @@ static int moxa_real_load_code(struct moxa_board_conf *brd, const void *ptr,
 	if (readw(baseAddr + Magic_no) != Magic_code)
 		return -EIO;
 
-	if (c320) {
+	if (MOXA_IS_320(brd)) {
 		j = readw(baseAddr + Module_cnt);
 		if (j <= 0)
 			return -EIO;
@@ -1596,18 +1597,9 @@ static void MoxaPortFlushData(struct moxa_port *port, int mode)
  *           int port           : port number (0 - 127)
  *
  *
- *      Function 8:     Get the maximun available baud rate of this port.
- *      Syntax:
- *      long MoxaPortGetMaxBaud(int port);
- *           int port           : port number (0 - 127)
- *
- *           return:    0       : this port is invalid
- *                      38400/57600/115200 bps
- *
- *
  *      Function 10:    Setting baud rate of this port.
  *      Syntax:
- *      long MoxaPortSetBaud(int port, long baud);
+ *      speed_t MoxaPortSetBaud(int port, speed_t baud);
  *           int port           : port number (0 - 127)
  *           long baud          : baud rate (50 - 115200)
  *
@@ -1756,8 +1748,7 @@ static void MoxaPortEnable(struct moxa_port *port)
 
 	ofsAddr = port->tableAddr;
 	writew(lowwater, ofsAddr + Low_water);
-	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
-			port->board->boardType == MOXA_BOARD_C320_PCI)
+	if (MOXA_IS_320(port->board))
 		moxafunc(ofsAddr, FC_SetBreakIrq, 0);
 	else
 		writew(readw(ofsAddr + HostStat) | WakeupBreak,
@@ -1780,33 +1771,18 @@ static void MoxaPortDisable(struct moxa_port *port)
 	moxafunc(ofsAddr, FC_DisableCH, Magic_code);
 }
 
-static long MoxaPortGetMaxBaud(struct moxa_port *port)
-{
-	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
-			port->board->boardType == MOXA_BOARD_C320_PCI)
-		return 460800L;
-	else
-		return 921600L;
-}
-
-
-static long MoxaPortSetBaud(struct moxa_port *port, long baud)
+static speed_t MoxaPortSetBaud(struct moxa_port *port, speed_t baud)
 {
-	void __iomem *ofsAddr;
-	long max, clock;
-	unsigned int val;
+	void __iomem *ofsAddr = port->tableAddr;
+	unsigned int clock, val;
+	speed_t max;
 
-	if (baud < 50L || (max = MoxaPortGetMaxBaud(port)) == 0)
+	max = MOXA_IS_320(port->board) ? 460800 : 921600;
+	if (baud < 50)
 		return 0;
-	ofsAddr = port->tableAddr;
 	if (baud > max)
 		baud = max;
-	if (max == 38400L)
-		clock = 614400L;	/* for 9.8304 Mhz : max. 38400 bps */
-	else if (max == 57600L)
-		clock = 691200L;	/* for 11.0592 Mhz : max. 57600 bps */
-	else
-		clock = 921600L;	/* for 14.7456 Mhz : max. 115200 bps */
+	clock = 921600;
 	val = clock / baud;
 	moxafunc(ofsAddr, FC_SetBaud, val);
 	baud = clock / val;
@@ -1851,11 +1827,9 @@ static int MoxaPortSetTermio(struct moxa_port *port, struct ktermios *termio,
 
 	moxafunc(ofsAddr, FC_SetDataMode, (u16)mode);
 
-	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
-			port->board->boardType == MOXA_BOARD_C320_PCI) {
-		if (baud >= 921600L)
-			return -1;
-	}
+	if (MOXA_IS_320(port->board) && baud >= 921600)
+		return -1;
+
 	baud = MoxaPortSetBaud(port, baud);
 
 	if (termio->c_iflag & (IXON | IXOFF | IXANY)) {
@@ -1915,8 +1889,7 @@ static int MoxaPortLineStatus(struct moxa_port *port)
 	int val;
 
 	ofsAddr = port->tableAddr;
-	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
-			port->board->boardType == MOXA_BOARD_C320_PCI) {
+	if (MOXA_IS_320(port->board)) {
 		moxafunc(ofsAddr, FC_LineStatus, 0);
 		val = readw(ofsAddr + FuncArg);
 	} else {
-- 
1.5.3.8

