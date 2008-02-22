Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbYBVOrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbYBVOrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:47:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYBVOqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:46:50 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:42245 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbYBVOqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:46:49 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <alan@lxorguk.ukuu.org.uk>,
       Oyvind Aabling <Oyvind.Aabling@uni-c.dk>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 01/19] Char: moxa, remove static isa support
Date: Fri, 22 Feb 2008 15:46:28 +0100
Message-Id: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Static ISA field is empty and probably will never be filled in, remove it.
The driver still supports ISA cards passed through module parameter.
This actually fixes one bug inside the initialization of module-param passed
cards initialization.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
---
 drivers/char/moxa.c |   34 ++--------------------------------
 1 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 64b7b2b..7f4d1ec 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -92,17 +92,6 @@ static struct pci_device_id moxa_pcibrds[] = {
 MODULE_DEVICE_TABLE(pci, moxa_pcibrds);
 #endif /* CONFIG_PCI */
 
-struct moxa_isa_board_conf {
-	int boardType;
-	int numPorts;
-	unsigned long baseAddr;
-};
-
-static struct moxa_isa_board_conf moxa_isa_boards[] =
-{
-/*       {MOXA_BOARD_C218_ISA,8,0xDC000}, */
-};
-
 static struct moxa_board_conf {
 	int boardType;
 	int numPorts;
@@ -346,7 +335,7 @@ static struct pci_driver moxa_pci_driver = {
 
 static int __init moxa_init(void)
 {
-	int i, numBoards, retval = 0;
+	int i, numBoards = 0, retval = 0;
 	struct moxa_port *ch;
 
 	printk(KERN_INFO "MOXA Intellio family driver version %s\n",
@@ -391,25 +380,6 @@ static int __init moxa_init(void)
 
 	mod_timer(&moxaTimer, jiffies + HZ / 50);
 
-	/* Find the boards defined in source code */
-	numBoards = 0;
-	for (i = 0; i < MAX_BOARDS; i++) {
-		if ((moxa_isa_boards[i].boardType == MOXA_BOARD_C218_ISA) ||
-		 (moxa_isa_boards[i].boardType == MOXA_BOARD_C320_ISA)) {
-			moxa_boards[numBoards].boardType = moxa_isa_boards[i].boardType;
-			if (moxa_isa_boards[i].boardType == MOXA_BOARD_C218_ISA)
-				moxa_boards[numBoards].numPorts = 8;
-			else
-				moxa_boards[numBoards].numPorts = moxa_isa_boards[i].numPorts;
-			moxa_boards[numBoards].busType = MOXA_BUS_TYPE_ISA;
-			moxa_boards[numBoards].baseAddr = moxa_isa_boards[i].baseAddr;
-			pr_debug("Moxa board %2d: %s board(baseAddr=%lx)\n",
-			       numBoards + 1,
-			       moxa_brdname[moxa_boards[numBoards].boardType-1],
-			       moxa_boards[numBoards].baseAddr);
-			numBoards++;
-		}
-	}
 	/* Find the boards defined form module args. */
 #ifdef MODULE
 	for (i = 0; i < MAX_BOARDS; i++) {
@@ -425,7 +395,7 @@ static int __init moxa_init(void)
 				continue;
 			}
 			moxa_boards[numBoards].boardType = type[i];
-			if (moxa_isa_boards[i].boardType == MOXA_BOARD_C218_ISA)
+			if (type[i] == MOXA_BOARD_C218_ISA)
 				moxa_boards[numBoards].numPorts = 8;
 			else
 				moxa_boards[numBoards].numPorts = numports[i];
-- 
1.5.4.1

