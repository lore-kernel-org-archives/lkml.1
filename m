Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbYBVOvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbYBVOvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbYBVOrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:47:40 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:42299 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbYBVOre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:47:34 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <alan@lxorguk.ukuu.org.uk>,
       Oyvind Aabling <Oyvind.Aabling@uni-c.dk>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 13/19] Char: moxa, cleanup rx/tx
Date: Fri, 22 Feb 2008 15:46:40 +0100
Message-Id: <1203691606-9310-13-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
References: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- cleanup types
- use tty_prepare_flip_string and io memcpys

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
---
 drivers/char/moxa.c |  124 ++++++++++++++++++++------------------------------
 drivers/char/moxa.h |    2 +-
 2 files changed, 51 insertions(+), 75 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index ea4cd4c..f73ea41 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -224,7 +224,7 @@ static void MoxaPortLineCtrl(struct moxa_port *, int, int);
 static void MoxaPortFlowCtrl(struct moxa_port *, int, int, int, int, int);
 static int MoxaPortLineStatus(struct moxa_port *);
 static void MoxaPortFlushData(struct moxa_port *, int);
-static int MoxaPortWriteData(struct moxa_port *, unsigned char *, int);
+static int MoxaPortWriteData(struct moxa_port *, const unsigned char *, int);
 static int MoxaPortReadData(struct moxa_port *);
 static int MoxaPortTxQueue(struct moxa_port *);
 static int MoxaPortRxQueue(struct moxa_port *);
@@ -1164,7 +1164,7 @@ static int moxa_write(struct tty_struct *tty,
 		return 0;
 
 	spin_lock_bh(&moxa_lock);
-	len = MoxaPortWriteData(ch, (unsigned char *) buf, count);
+	len = MoxaPortWriteData(ch, buf, count);
 	spin_unlock_bh(&moxa_lock);
 
 	/*********************************************
@@ -2029,15 +2029,13 @@ static int MoxaPortLineStatus(struct moxa_port *port)
 	return val;
 }
 
-static int MoxaPortWriteData(struct moxa_port *port, unsigned char *buffer,
-		int len)
+static int MoxaPortWriteData(struct moxa_port *port,
+		const unsigned char *buffer, int len)
 {
-	int c, total, i;
-	ushort tail;
-	int cnt;
-	ushort head, tx_mask, spage, epage;
-	ushort pageno, pageofs, bufhead;
 	void __iomem *baseAddr, *ofsAddr, *ofs;
+	unsigned int c, total;
+	u16 head, tail, tx_mask, spage, epage;
+	u16 pageno, pageofs, bufhead;
 
 	ofsAddr = port->tableAddr;
 	baseAddr = port->board->basemem;
@@ -2046,8 +2044,7 @@ static int MoxaPortWriteData(struct moxa_port *port, unsigned char *buffer,
 	epage = readw(ofsAddr + EndPage_txb);
 	tail = readw(ofsAddr + TXwptr);
 	head = readw(ofsAddr + TXrptr);
-	c = (head > tail) ? (head - tail - 1)
-	    : (head - tail + tx_mask);
+	c = (head > tail) ? (head - tail - 1) : (head - tail + tx_mask);
 	if (c > len)
 		c = len;
 	moxaLog.txcnt[port->tty->index] += c;
@@ -2062,46 +2059,42 @@ static int MoxaPortWriteData(struct moxa_port *port, unsigned char *buffer,
 				len = tx_mask + 1 - tail;
 			len = (c > len) ? len : c;
 			ofs = baseAddr + DynPage_addr + bufhead + tail;
-			for (i = 0; i < len; i++)
-				writeb(*buffer++, ofs + i);
+			memcpy_toio(ofs, buffer, len);
+			buffer += len;
 			tail = (tail + len) & tx_mask;
 			c -= len;
 		}
-		writew(tail, ofsAddr + TXwptr);
 	} else {
-		len = c;
 		pageno = spage + (tail >> 13);
 		pageofs = tail & Page_mask;
-		do {
-			cnt = Page_size - pageofs;
-			if (cnt > c)
-				cnt = c;
-			c -= cnt;
+		while (c > 0) {
+			len = Page_size - pageofs;
+			if (len > c)
+				len = c;
 			writeb(pageno, baseAddr + Control_reg);
 			ofs = baseAddr + DynPage_addr + pageofs;
-			for (i = 0; i < cnt; i++)
-				writeb(*buffer++, ofs + i);
-			if (c == 0) {
-				writew((tail + len) & tx_mask, ofsAddr + TXwptr);
-				break;
-			}
+			memcpy_toio(ofs, buffer, len);
+			buffer += len;
 			if (++pageno == epage)
 				pageno = spage;
 			pageofs = 0;
-		} while (1);
+			c -= len;
+		}
+		tail = (tail + total) & tx_mask;
 	}
+	writew(tail, ofsAddr + TXwptr);
 	writeb(1, ofsAddr + CD180TXirq);	/* start to send */
-	return (total);
+	return total;
 }
 
 static int MoxaPortReadData(struct moxa_port *port)
 {
 	struct tty_struct *tty = port->tty;
-	register ushort head, pageofs;
-	int i, count, cnt, len, total, remain;
-	ushort tail, rx_mask, spage, epage;
-	ushort pageno, bufhead;
+	unsigned char *dst;
 	void __iomem *baseAddr, *ofsAddr, *ofs;
+	unsigned int count, len, total;
+	u16 tail, rx_mask, spage, epage;
+	u16 pageno, pageofs, bufhead, head;
 
 	ofsAddr = port->tableAddr;
 	baseAddr = port->board->basemem;
@@ -2110,101 +2103,84 @@ static int MoxaPortReadData(struct moxa_port *port)
 	rx_mask = readw(ofsAddr + RX_mask);
 	spage = readw(ofsAddr + Page_rxb);
 	epage = readw(ofsAddr + EndPage_rxb);
-	count = (tail >= head) ? (tail - head)
-	    : (tail - head + rx_mask + 1);
+	count = (tail >= head) ? (tail - head) : (tail - head + rx_mask + 1);
 	if (count == 0)
 		return 0;
 
 	total = count;
-	remain = count - total;
 	moxaLog.rxcnt[tty->index] += total;
-	count = total;
 	if (spage == epage) {
 		bufhead = readw(ofsAddr + Ofs_rxb);
 		writew(spage, baseAddr + Control_reg);
 		while (count > 0) {
-			if (tail >= head)
-				len = tail - head;
-			else
-				len = rx_mask + 1 - head;
-			len = (count > len) ? len : count;
 			ofs = baseAddr + DynPage_addr + bufhead + head;
-			for (i = 0; i < len; i++)
-				tty_insert_flip_char(tty, readb(ofs + i), TTY_NORMAL);
+			len = (tail >= head) ? (tail - head) :
+					(rx_mask + 1 - head);
+			len = tty_prepare_flip_string(tty, &dst,
+					min(len, count));
+			memcpy_fromio(dst, ofs, len);
 			head = (head + len) & rx_mask;
 			count -= len;
 		}
-		writew(head, ofsAddr + RXrptr);
 	} else {
-		len = count;
 		pageno = spage + (head >> 13);
 		pageofs = head & Page_mask;
-		do {
-			cnt = Page_size - pageofs;
-			if (cnt > count)
-				cnt = count;
-			count -= cnt;
+		while (count > 0) {
 			writew(pageno, baseAddr + Control_reg);
 			ofs = baseAddr + DynPage_addr + pageofs;
-			for (i = 0; i < cnt; i++)
-				tty_insert_flip_char(tty, readb(ofs + i), TTY_NORMAL);
-			if (count == 0) {
-				writew((head + len) & rx_mask, ofsAddr + RXrptr);
-				break;
-			}
-			if (++pageno == epage)
+			len = tty_prepare_flip_string(tty, &dst,
+					min(Page_size - pageofs, count));
+			memcpy_fromio(dst, ofs, len);
+
+			count -= len;
+			pageofs = (pageofs + len) & Page_mask;
+			if (pageofs == 0 && ++pageno == epage)
 				pageno = spage;
-			pageofs = 0;
-		} while (1);
+		}
+		head = (head + total) & rx_mask;
 	}
-	if ((readb(ofsAddr + FlagStat) & Xoff_state) && (remain < LowWater)) {
+	writew(head, ofsAddr + RXrptr);
+	if (readb(ofsAddr + FlagStat) & Xoff_state) {
 		moxaLowWaterChk = 1;
 		port->lowChkFlag = 1;
 	}
-	return (total);
+	return total;
 }
 
 
 static int MoxaPortTxQueue(struct moxa_port *port)
 {
 	void __iomem *ofsAddr = port->tableAddr;
-	ushort rptr, wptr, mask;
-	int len;
+	u16 rptr, wptr, mask;
 
 	rptr = readw(ofsAddr + TXrptr);
 	wptr = readw(ofsAddr + TXwptr);
 	mask = readw(ofsAddr + TX_mask);
-	len = (wptr - rptr) & mask;
-	return (len);
+	return (wptr - rptr) & mask;
 }
 
 static int MoxaPortTxFree(struct moxa_port *port)
 {
 	void __iomem *ofsAddr = port->tableAddr;
-	ushort rptr, wptr, mask;
-	int len;
+	u16 rptr, wptr, mask;
 
 	rptr = readw(ofsAddr + TXrptr);
 	wptr = readw(ofsAddr + TXwptr);
 	mask = readw(ofsAddr + TX_mask);
-	len = mask - ((wptr - rptr) & mask);
-	return (len);
+	return mask - ((wptr - rptr) & mask);
 }
 
 static int MoxaPortRxQueue(struct moxa_port *port)
 {
 	void __iomem *ofsAddr = port->tableAddr;
-	ushort rptr, wptr, mask;
-	int len;
+	u16 rptr, wptr, mask;
 
 	rptr = readw(ofsAddr + RXrptr);
 	wptr = readw(ofsAddr + RXwptr);
 	mask = readw(ofsAddr + RX_mask);
-	len = (wptr - rptr) & mask;
-	return (len);
+	return (wptr - rptr) & mask;
 }
 
-
 static void MoxaPortTxDisable(struct moxa_port *port)
 {
 	moxafunc(port->tableAddr, FC_SetXoffState, Magic_code);
diff --git a/drivers/char/moxa.h b/drivers/char/moxa.h
index 0b16506..87d16ce 100644
--- a/drivers/char/moxa.h
+++ b/drivers/char/moxa.h
@@ -217,7 +217,7 @@
 #define C320p32rx_mask	(C320p32rx_size - 1)
 #define C320p32tx_mask	(C320p32tx_size - 1)
 
-#define Page_size	0x2000
+#define Page_size	0x2000U
 #define Page_mask	(Page_size - 1)
 #define C218rx_spage	3
 #define C218tx_spage	4
-- 
1.5.4.1

