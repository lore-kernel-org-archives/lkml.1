Return-Path: <linux-kernel-owner+w=401wt.eu-S1760124AbYFIKOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbYFIKOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 06:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759359AbYFIKOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 06:14:24 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:58573 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759925AbYFIKOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 06:14:23 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] Char: mxser, remove predefined isa support
Date: Mon,  9 Jun 2008 12:08:31 +0200
Message-Id: <1213006112-25965-6-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213006112-25965-1-git-send-email-jirislaby@gmail.com>
References: <1213006112-25965-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a support of ISA addresses predefined on the compile time.
It is unused (filled by zeroes) and prolongs the code.
Don't initialize global array and add `ioaddr' module param
description.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/mxser.c |   67 ++++++++++++++++++++-----------------------------
 1 files changed, 27 insertions(+), 40 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 800b609..8f7afdc 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -173,14 +173,15 @@ static struct pci_device_id mxser_pcibrds[] = {
 };
 MODULE_DEVICE_TABLE(pci, mxser_pcibrds);
 
-static int ioaddr[MXSER_BOARDS] = { 0, 0, 0, 0 };
+static unsigned long ioaddr[MXSER_BOARDS];
 static int ttymajor = MXSERMAJOR;
 
 /* Variables for insmod */
 
 MODULE_AUTHOR("Casper Yang");
 MODULE_DESCRIPTION("MOXA Smartio/Industio Family Multiport Board Device Driver");
-module_param_array(ioaddr, int, NULL, 0);
+module_param_array(ioaddr, ulong, NULL, 0);
+MODULE_PARM_DESC(ioaddr, "ISA io addresses to look for a moxa board");
 module_param(ttymajor, int, 0);
 MODULE_LICENSE("GPL");
 
@@ -289,11 +290,6 @@ struct mxser_mstatus {
 	int dcd;
 };
 
-static int mxserBoardCAP[MXSER_BOARDS] = {
-	0, 0, 0, 0
-	/*  0x180, 0x280, 0x200, 0x320 */
-};
-
 static struct mxser_board mxser_boards[MXSER_BOARDS];
 static struct tty_driver *mxvar_sdriver;
 static struct mxser_log mxvar_log;
@@ -2772,9 +2768,8 @@ static struct pci_driver mxser_driver = {
 static int __init mxser_module_init(void)
 {
 	struct mxser_board *brd;
-	unsigned long cap;
-	unsigned int i, m, isaloop;
-	int retval, b;
+	unsigned int b, i, m;
+	int retval;
 
 	pr_debug("Loading module mxser ...\n");
 
@@ -2806,41 +2801,33 @@ static int __init mxser_module_init(void)
 		goto err_put;
 	}
 
-	m = 0;
 	/* Start finding ISA boards here */
-	for (isaloop = 0; isaloop < 2; isaloop++)
-		for (b = 0; b < MXSER_BOARDS && m < MXSER_BOARDS; b++) {
-			if (!isaloop)
-				cap = mxserBoardCAP[b]; /* predefined */
-			else
-				cap = ioaddr[b]; /* module param */
-
-			if (!cap)
-				continue;
-
-			brd = &mxser_boards[m];
-			retval = mxser_get_ISA_conf(cap, brd);
-			if (retval <= 0) {
-				brd->info = NULL;
-				continue;
-			}
+	for (m = 0, b = 0; b < MXSER_BOARDS; b++) {
+		if (!ioaddr[b])
+			continue;
+
+		brd = &mxser_boards[m];
+		retval = mxser_get_ISA_conf(!ioaddr[b], brd);
+		if (retval <= 0) {
+			brd->info = NULL;
+			continue;
+		}
 
-			printk(KERN_INFO "mxser: found MOXA %s board "
-				"(CAP=0x%x)\n",	brd->info->name, ioaddr[b]);
+		printk(KERN_INFO "mxser: found MOXA %s board (CAP=0x%lx)\n",
+				brd->info->name, ioaddr[b]);
 
-			/* mxser_initbrd will hook ISR. */
-			if (mxser_initbrd(brd, NULL) < 0) {
-				brd->info = NULL;
-				continue;
-			}
+		/* mxser_initbrd will hook ISR. */
+		if (mxser_initbrd(brd, NULL) < 0) {
+			brd->info = NULL;
+			continue;
+		}
 
-			brd->idx = m * MXSER_PORTS_PER_BOARD;
-			for (i = 0; i < brd->info->nports; i++)
-				tty_register_device(mxvar_sdriver, brd->idx + i,
-						NULL);
+		brd->idx = m * MXSER_PORTS_PER_BOARD;
+		for (i = 0; i < brd->info->nports; i++)
+			tty_register_device(mxvar_sdriver, brd->idx + i, NULL);
 
-			m++;
-		}
+		m++;
+	}
 
 	retval = pci_register_driver(&mxser_driver);
 	if (retval) {
-- 
1.5.4.5

