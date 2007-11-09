Return-Path: <linux-kernel-owner+w=401wt.eu-S1763517AbXKIXiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763517AbXKIXiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760068AbXKIXiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:38:11 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57146 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759740AbXKIXiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:38:08 -0500
Message-id: <26399208783217117685.slaby@pripojeni.net>
In-reply-to: <133622706419279219.slaby@pripojeni.net>
Subject: [PATCH 6/7] Char: stallion, fix compiler warnings
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Fri, 9 Nov 2007 18:38:08 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

stallion, fix compiler warnings

Don't emit warnings on 64 bit platforms from min(). sizeof() on those
is not uint, neither 2 pointers difference, cast it to uint by min_t in
both cases.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 7a411a4d1729e34bd7dc6697a8eedec7dd989c32
tree 2422610e5f3cdde71c9a5cec4d134baf9b72daa5
parent f412e3e0d4d012b7b57e381ae85ddfb1b5fc99bf
author Jiri Slaby <jirislaby@gmail.com> Tue, 23 Oct 2007 12:47:28 +0200
committer Jiri Slaby <jirislaby@gmail.com> Fri, 09 Nov 2007 22:36:31 +0100

 drivers/char/stallion.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 45758d5..5050aa5 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -3546,7 +3546,8 @@ static void stl_cd1400txisr(struct stlpanel *panelp, int ioaddr)
 	} else {
 		len = min(len, CD1400_TXFIFOSIZE);
 		portp->stats.txtotal += len;
-		stlen = min(len, ((portp->tx.buf + STL_TXBUFSIZE) - tail));
+		stlen = min_t(unsigned int, len,
+				(portp->tx.buf + STL_TXBUFSIZE) - tail);
 		outb((TDR + portp->uartaddr), ioaddr);
 		outsb((ioaddr + EREG_DATA), tail, stlen);
 		len -= stlen;
@@ -3599,7 +3600,7 @@ static void stl_cd1400rxisr(struct stlpanel *panelp, int ioaddr)
 		outb((RDCR + portp->uartaddr), ioaddr);
 		len = inb(ioaddr + EREG_DATA);
 		if (tty == NULL || (buflen = tty_buffer_request_room(tty, len)) == 0) {
-			len = min(len, sizeof(stl_unwanted));
+			len = min_t(unsigned int, len, sizeof(stl_unwanted));
 			outb((RDSR + portp->uartaddr), ioaddr);
 			insb((ioaddr + EREG_DATA), &stl_unwanted[0], len);
 			portp->stats.rxlost += len;
@@ -4465,7 +4466,8 @@ static void stl_sc26198txisr(struct stlport *portp)
 	} else {
 		len = min(len, SC26198_TXFIFOSIZE);
 		portp->stats.txtotal += len;
-		stlen = min(len, ((portp->tx.buf + STL_TXBUFSIZE) - tail));
+		stlen = min_t(unsigned int, len,
+				(portp->tx.buf + STL_TXBUFSIZE) - tail);
 		outb(GTXFIFO, (ioaddr + XP_ADDR));
 		outsb((ioaddr + XP_DATA), tail, stlen);
 		len -= stlen;
@@ -4506,7 +4508,7 @@ static void stl_sc26198rxisr(struct stlport *portp, unsigned int iack)
 
 	if ((iack & IVR_TYPEMASK) == IVR_RXDATA) {
 		if (tty == NULL || (buflen = tty_buffer_request_room(tty, len)) == 0) {
-			len = min(len, sizeof(stl_unwanted));
+			len = min_t(unsigned int, len, sizeof(stl_unwanted));
 			outb(GRXFIFO, (ioaddr + XP_ADDR));
 			insb((ioaddr + XP_DATA), &stl_unwanted[0], len);
 			portp->stats.rxlost += len;
