Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbXFSOkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbXFSOkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbXFSOj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:39:58 -0400
Received: from snowcat.de ([89.31.32.98]:4429 "EHLO snowcat.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbXFSOj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:39:58 -0400
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/1] Char: istallion, init+locking fixes (try 2)
Organization: Disorganized
From: Ingo Korb <ml@akana.de>
In-Reply-To: <467788D0.4060802@gmail.com> (Jiri Slaby's message of "Tue, 19
 Jun 2007 09:42:08 +0200")
References: <uir9l9e1j.fsf@dragon.akana.de> <467788D0.4060802@gmail.com>
Date: Tue, 19 Jun 2007 16:39:45 +0200
Message-ID: <uabuw9ff2.fsf_-_@dragon.akana.de>
User-Agent: Gnus/5.1002 (Gnus v5.10.2) Emacs/21.3 (windows-nt)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:21:070619:alan@lxorguk.ukuu.org.uk::KkADvnsBuJMLvOM6:0000000000000
	000000000000000000000000BEmt
X-Hashcash: 1:21:070619:linux-kernel@vger.kernel.org::aKQRoUVz7DHmhsPd:000000000
	000000000000000000000000IWXN
X-Hashcash: 1:21:070619:akpm@linux-foundation.org::oD7U0VOoWZ9A51Pt:000000000000
	0000000000000000000000008kWU
X-Hashcash: 1:21:070619:jirislaby@gmail.com::5jin3l63/qFEhsiQ:000000000000000000
	000000000000000000000000Egdg
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move brdp->iosize assignment in stli_initecp up a few lines to stop the
driver from requesting an I/O region of length 0.

Remove spin_lock_irqsave/spin_unlock_irqrestore from __stli_sendcmd as
all users of that function take the lock already.

Signed-off-by: Ingo Korb <ml@akana.de>
---
diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 7b279d1..becba24 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -2166,14 +2166,10 @@ static void __stli_sendcmd(struct stlibrd *brdp, struct stliport *portp, unsigne
 	cdkhdr_t __iomem *hdrp;
 	cdkctrl_t __iomem *cp;
 	unsigned char __iomem *bits;
-	unsigned long flags;
-
-	spin_lock_irqsave(&brd_lock, flags);
 
 	if (test_bit(ST_CMDING, &portp->state)) {
 		printk(KERN_ERR "STALLION: command already busy, cmd=%x!\n",
 				(int) cmd);
-		spin_unlock_irqrestore(&brd_lock, flags);
 		return;
 	}
 
@@ -2194,7 +2190,6 @@ static void __stli_sendcmd(struct stlibrd *brdp, struct stliport *portp, unsigne
 	writeb(readb(bits) | portp->portbit, bits);
 	set_bit(ST_CMDING, &portp->state);
 	EBRDDISABLE(brdp);
-	spin_unlock_irqrestore(&brd_lock, flags);
 }
 
 static void stli_sendcmd(struct stlibrd *brdp, struct stliport *portp, unsigned long cmd, void *arg, int size, int copyback)
@@ -3218,13 +3213,13 @@ static int stli_initecp(struct stlibrd *brdp)
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

