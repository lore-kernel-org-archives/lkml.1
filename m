Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbZKROcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbZKROcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbZKROcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:32:22 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40607 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757269AbZKROcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:32:20 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 07/12] moxa: rework the locking a bit
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:15:56 +0000
Message-ID: <20091118141551.3346.76915.stgit@localhost.localdomain>
In-Reply-To: <20091118141354.3346.16910.stgit@localhost.localdomain>
References: <20091118141354.3346.16910.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a lock for moxafunc() to protect the cases where were get collisions
between two function requests at the same time.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/moxa.c |   27 ++++++++++++++++++++++-----
 1 files changed, 22 insertions(+), 5 deletions(-)


diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 96b2985..ba84c4d 100644
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

