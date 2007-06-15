Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbXFOSCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbXFOSCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbXFOSCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:02:31 -0400
Received: from snowcat.de ([89.31.32.98]:2284 "EHLO snowcat.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbXFOSCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:02:31 -0400
To: linux-kernel@vger.kernel.org
CC: Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] Char: stallion, fix oops during init with ISA cards
Organization: Disorganized
From: Ingo Korb <ml@akana.de>
Date: Fri, 15 Jun 2007 20:02:18 +0200
Message-ID: <utzt99jv9.fsf@dragon.akana.de>
User-Agent: Gnus/5.1002 (Gnus v5.10.2) Emacs/21.3 (windows-nt)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:21:070615:jirislaby@gmail.com::vDPx1B3PcGc0JtBe:000000000000000000
	0000000000000000000000002jPT
X-Hashcash: 1:21:070615:linux-kernel@vger.kernel.org::hYqkKlLduZHLfDpB:000000000
	0000000000000000000000009hlN
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The stallion driver oopses while initializing ISA cards due to an
uninitialized variable. This patch changes the initialisation order to
match the PCI code path.

Signed-off-by: Ingo Korb <ml@akana.de>
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

