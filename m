Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbYBVOrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbYBVOrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbYBVOr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:47:29 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:42251 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbYBVOr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:47:28 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <alan@lxorguk.ukuu.org.uk>,
       Oyvind Aabling <Oyvind.Aabling@uni-c.dk>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 02/19] Char: moxa, cleanup module-param passed isa init
Date: Fri, 22 Feb 2008 15:46:29 +0100
Message-Id: <1203691606-9310-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
References: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the code more readable, remap the base address directly. Describe
module parameters.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
---
 drivers/char/moxa.c |   64 ++++++++++++++++++++++++++------------------------
 1 files changed, 33 insertions(+), 31 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 7f4d1ec..2701f7c 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -95,7 +95,6 @@ MODULE_DEVICE_TABLE(pci, moxa_pcibrds);
 static struct moxa_board_conf {
 	int boardType;
 	int numPorts;
-	unsigned long baseAddr;
 	int busType;
 
 	int loadstat;
@@ -159,18 +158,21 @@ struct moxa_port {
 static int ttymajor = MOXAMAJOR;
 /* Variables for insmod */
 #ifdef MODULE
-static int baseaddr[4];
-static int type[4];
-static int numports[4];
+static unsigned long baseaddr[MAX_BOARDS];
+static unsigned int type[MAX_BOARDS];
+static unsigned int numports[MAX_BOARDS];
 #endif
 
 MODULE_AUTHOR("William Chen");
 MODULE_DESCRIPTION("MOXA Intellio Family Multiport Board Device Driver");
 MODULE_LICENSE("GPL");
 #ifdef MODULE
-module_param_array(type, int, NULL, 0);
-module_param_array(baseaddr, int, NULL, 0);
-module_param_array(numports, int, NULL, 0);
+module_param_array(type, uint, NULL, 0);
+MODULE_PARM_DESC(type, "card type: C218=2, C320=4");
+module_param_array(baseaddr, ulong, NULL, 0);
+MODULE_PARM_DESC(baseaddr, "base address");
+module_param_array(numports, uint, NULL, 0);
+MODULE_PARM_DESC(numports, "numports (ignored for C218)");
 #endif
 module_param(ttymajor, int, 0);
 
@@ -335,8 +337,9 @@ static struct pci_driver moxa_pci_driver = {
 
 static int __init moxa_init(void)
 {
-	int i, numBoards = 0, retval = 0;
 	struct moxa_port *ch;
+	unsigned int i, isabrds = 0;
+	int retval = 0;
 
 	printk(KERN_INFO "MOXA Intellio family driver version %s\n",
 			MOXA_VERSION);
@@ -380,46 +383,45 @@ static int __init moxa_init(void)
 
 	mod_timer(&moxaTimer, jiffies + HZ / 50);
 
-	/* Find the boards defined form module args. */
+	/* Find the boards defined from module args. */
 #ifdef MODULE
+	{
+	struct moxa_board_conf *brd = moxa_boards;
 	for (i = 0; i < MAX_BOARDS; i++) {
-		if ((type[i] == MOXA_BOARD_C218_ISA) ||
-		    (type[i] == MOXA_BOARD_C320_ISA)) {
+		if (!baseaddr[i])
+			break;
+		if (type[i] == MOXA_BOARD_C218_ISA ||
+				type[i] == MOXA_BOARD_C320_ISA) {
 			pr_debug("Moxa board %2d: %s board(baseAddr=%lx)\n",
-			       numBoards + 1, moxa_brdname[type[i] - 1],
-			       (unsigned long)baseaddr[i]);
-			if (numBoards >= MAX_BOARDS) {
-				printk(KERN_WARNING "More than %d MOXA "
-					"Intellio family boards found. Board "
-					"is ignored.\n", MAX_BOARDS);
+					isabrds + 1, moxa_brdname[type[i] - 1],
+					baseaddr[i]);
+			brd->boardType = type[i];
+			brd->numPorts = type[i] == MOXA_BOARD_C218_ISA ? 8 :
+					numports[i];
+			brd->busType = MOXA_BUS_TYPE_ISA;
+			brd->basemem = ioremap(baseaddr[i], 0x4000);
+			if (!brd->basemem) {
+				printk(KERN_ERR "moxa: can't remap %lx\n",
+						baseaddr[i]);
 				continue;
 			}
-			moxa_boards[numBoards].boardType = type[i];
-			if (type[i] == MOXA_BOARD_C218_ISA)
-				moxa_boards[numBoards].numPorts = 8;
-			else
-				moxa_boards[numBoards].numPorts = numports[i];
-			moxa_boards[numBoards].busType = MOXA_BUS_TYPE_ISA;
-			moxa_boards[numBoards].baseAddr = baseaddr[i];
-			numBoards++;
+
+			brd++;
+			isabrds++;
 		}
 	}
+	}
 #endif
 
 #ifdef CONFIG_PCI
 	retval = pci_register_driver(&moxa_pci_driver);
 	if (retval) {
 		printk(KERN_ERR "Can't register moxa pci driver!\n");
-		if (numBoards)
+		if (isabrds)
 			retval = 0;
 	}
 #endif
 
-	for (i = 0; i < numBoards; i++) {
-		moxa_boards[i].basemem = ioremap(moxa_boards[i].baseAddr,
-				0x4000);
-	}
-
 	return retval;
 }
 
-- 
1.5.4.1

