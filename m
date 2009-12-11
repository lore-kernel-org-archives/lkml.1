Return-Path: <linux-kernel-owner+w=401wt.eu-S934743AbZLKXcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934743AbZLKXcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934477AbZLKXcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:32:32 -0500
Received: from kroah.org ([198.145.64.141]:50451 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933911AbZLKX3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:31 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 48/58] tty: moxa: rework the locking a bit
Date: Fri, 11 Dec 2009 15:28:32 -0800
Message-Id: <1260574122-10676-48-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Introduce a lock for moxafunc() to protect the cases where were get collisions
between two function requests at the same time.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/moxa.c |   27 ++++++++++++++++++++++-----
 1 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index d8bcbed..474d936 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -248,9 +248,25 @@ static void moxa_wait_finish(void __iomem *ofsAddr)
 
 static void moxafunc(void __iomem *ofsAddr, u16 cmd, u16 arg)
 {
+        unsigned long flags;
+        spin_lock_irqsave(&moxafunc_lock, flags);
 	writew(arg, ofsAddr + FuncArg);
 	writew(cmd, ofsAddr + FuncCode);
 	moxa_wait_finish(ofsAddr);
+	spin_unlock_irqrestore(&moxafunc_lock, flags);
+}
+
+static int moxafuncret(void __iomem *ofsAddr, u16 cmd, u16 arg)
+{
+        unsigned long flags;
+        u16 ret;
+        spin_lock_irqsave(&moxafunc_lock, flags);
+	writew(arg, ofsAddr + FuncArg);
+	writew(cmd, ofsAddr + FuncCode);
+	moxa_wait_finish(ofsAddr);
+	ret = readw(ofsAddr + FuncArg);
+	spin_unlock_irqrestore(&moxafunc_lock, flags);
+	return ret;
 }
 
 static void moxa_low_water_check(void __iomem *ofsAddr)
@@ -417,6 +433,7 @@ static const struct tty_port_operations moxa_port_ops = {
 static struct tty_driver *moxaDriver;
 static DEFINE_TIMER(moxaTimer, moxa_poll, 0, 0);
 static DEFINE_SPINLOCK(moxa_lock);
+static DEFINE_SPINLOCK(moxafunc_lock);
 
 /*
  * HW init
@@ -1823,10 +1840,12 @@ static int MoxaPortSetTermio(struct moxa_port *port, struct ktermios *termio,
 	baud = MoxaPortSetBaud(port, baud);
 
 	if (termio->c_iflag & (IXON | IXOFF | IXANY)) {
+	        spin_lock_irq(&moxafunc_lock);
 		writeb(termio->c_cc[VSTART], ofsAddr + FuncArg);
 		writeb(termio->c_cc[VSTOP], ofsAddr + FuncArg1);
 		writeb(FC_SetXonXoff, ofsAddr + FuncCode);
 		moxa_wait_finish(ofsAddr);
+		spin_unlock_irqrestore(&moxafunc_lock);
 
 	}
 	return baud;
@@ -1879,12 +1898,10 @@ static int MoxaPortLineStatus(struct moxa_port *port)
 	int val;
 
 	ofsAddr = port->tableAddr;
-	if (MOXA_IS_320(port->board)) {
-		moxafunc(ofsAddr, FC_LineStatus, 0);
-		val = readw(ofsAddr + FuncArg);
-	} else {
+	if (MOXA_IS_320(port->board))
+		val = moxafuncret(ofsAddr, FC_LineStatus, 0);
+	else
 		val = readw(ofsAddr + FlagStat) >> 4;
-	}
 	val &= 0x0B;
 	if (val & 8)
 		val |= 4;
-- 
1.6.5.5

