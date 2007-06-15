Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbXFOTfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbXFOTfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757248AbXFOTfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:35:30 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:54625 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757119AbXFOTf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:35:29 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Ingo Korb <ml@akana.de>
Subject: [PATCH 1/1] Char: stallion, fix oops during init with ISA cards
In-reply-to: <utzt99jv9.fsf@dragon.akana.de>
Message-id: <32189297761566511950@wsc.cz>
Date: Fri, 15 Jun 2007 21:35:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, seems good to me. Next time, feel free Cc Andrew directly.

--

From: Ingo Korb <ml@akana.de>

stallion, fix oops during init with ISA cards

The stallion driver oopses while initializing ISA cards due to an
uninitialized variable. This patch changes the initialisation order to
match the PCI code path.

Signed-off-by: Ingo Korb <ml@akana.de>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
---
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 45bf2a2..8c73ccb 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -4753,13 +4753,14 @@ static int __init stallion_module_init(void)
 		brdp->ioaddr2 = conf.ioaddr2;
 		brdp->irq = conf.irq;
 		brdp->irqtype = conf.irqtype;
-		if (stl_brdinit(brdp))
+		stl_brds[brdp->brdnr] = brdp;
+		if (stl_brdinit(brdp)) {
+			stl_brds[brdp->brdnr] = NULL;
 			kfree(brdp);
-		else {
+		} else {
 			for (j = 0; j < brdp->nrports; j++)
 				tty_register_device(stl_serial,
 					brdp->brdnr * STL_MAXPORTS + j, NULL);
-			stl_brds[brdp->brdnr] = brdp;
 			stl_nrbrds = i + 1;
 		}
 	}

