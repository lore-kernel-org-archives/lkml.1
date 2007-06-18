Return-Path: <linux-kernel-owner+w=401wt.eu-S932615AbXFRU50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbXFRU50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761059AbXFRU5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:57:19 -0400
Received: from snowcat.de ([89.31.32.98]:3110 "EHLO snowcat.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760830AbXFRU5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:57:18 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] Char: istallion, init+locking fixes
Organization: Disorganized
From: Ingo Korb <ml@akana.de>
Date: Mon, 18 Jun 2007 22:57:12 +0200
Message-ID: <uir9l9e1j.fsf@dragon.akana.de>
User-Agent: Gnus/5.1002 (Gnus v5.10.2) Emacs/21.3 (windows-nt)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:21:070618:linux-kernel@vger.kernel.org::3XKsYgpzqwi0BilF:000000000
	0000000000000000000000002Z8L
X-Hashcash: 1:21:070618:akpm@linux-foundation.org::+tIAPLFHxtxGFdR+:000000000000
	0000000000000000000000008Ci5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move brdp->iosize assignment in stli_initecp up a few lines to stop the
driver from requesting an I/O region of length 0.

Remove spin_lock_irqsave/spin_unlock_irqrestore from __stli_sendcmd as
all users of that function take the lock already.

Signed-off-by: Ingo Korb <ml@akana.de>
---
One thing I dislike about this driver: It polls its cards every jiffy to
look for new data. The cards are able to use interrupts (some of the
drivers for other OSes use them), but as far as I know there is no open
documentation. Unfortunately the DOS driver (probably easiest to
analyze) also uses polling. =(


diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 7b279d1..0bc1c37 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -2168,8 +2168,6 @@ static void __stli_sendcmd(struct stlibrd *brdp, struct stliport *portp, unsigne
 	unsigned char __iomem *bits;
 	unsigned long flags;
 
-	spin_lock_irqsave(&brd_lock, flags);
-
 	if (test_bit(ST_CMDING, &portp->state)) {
 		printk(KERN_ERR "STALLION: command already busy, cmd=%x!\n",
 				(int) cmd);
@@ -2194,7 +2192,6 @@ static void __stli_sendcmd(struct stlibrd *brdp, struct stliport *portp, unsigne
 	writeb(readb(bits) | portp->portbit, bits);
 	set_bit(ST_CMDING, &portp->state);
 	EBRDDISABLE(brdp);
-	spin_unlock_irqrestore(&brd_lock, flags);
 }
 
 static void stli_sendcmd(struct stlibrd *brdp, struct stliport *portp, unsigned long cmd, void *arg, int size, int copyback)
@@ -3218,13 +3215,13 @@ static int stli_initecp(struct stlibrd *brdp)
 		goto err;
 	}
 
+	brdp->iosize = ECP_IOSIZE;
+
 	if (!request_region(brdp->iobase, brdp->iosize, "istallion")) {
 		retval = -EIO;
 		goto err;
 	}
 
-	brdp->iosize = ECP_IOSIZE;
-
 /*
  *	Based on the specific board type setup the common vars to access
  *	and enable shared memory. Set all board specific information now

