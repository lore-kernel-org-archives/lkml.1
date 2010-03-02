Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab0CBXui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:50:38 -0500
Received: from kroah.org ([198.145.64.141]:51599 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab0CBXg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:36:57 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Rakib Mullick <rakib.mullick@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/36] tty: moxa: remove #ifdef MODULE completely.
Date: Tue,  2 Mar 2010 15:36:22 -0800
Message-Id: <1267573003-782-15-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rakib Mullick <rakib.mullick@gmail.com>

We can pass "module parameters" on the kernel command line even when
!MODULE.  So, #ifdef MODULE becomes obsolete.  Also move the declaration
moxa_board_conf at the start of the function, since we were hit by the
following warning.

drivers/char/moxa.c: In function `moxa_init':
drivers/char/moxa.c:1040: warning: ISO C90 forbids mixed declarations and code

Signed-off-by: Rakib Mullick<rakib.mullick@gmail.com>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/moxa.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 63ee3bb..49a1fc2 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -164,24 +164,22 @@ static unsigned int moxaFuncTout = HZ / 2;
 static unsigned int moxaLowWaterChk;
 static DEFINE_MUTEX(moxa_openlock);
 static DEFINE_SPINLOCK(moxa_lock);
-/* Variables for insmod */
-#ifdef MODULE
+
 static unsigned long baseaddr[MAX_BOARDS];
 static unsigned int type[MAX_BOARDS];
 static unsigned int numports[MAX_BOARDS];
-#endif
 
 MODULE_AUTHOR("William Chen");
 MODULE_DESCRIPTION("MOXA Intellio Family Multiport Board Device Driver");
 MODULE_LICENSE("GPL");
-#ifdef MODULE
+
 module_param_array(type, uint, NULL, 0);
 MODULE_PARM_DESC(type, "card type: C218=2, C320=4");
 module_param_array(baseaddr, ulong, NULL, 0);
 MODULE_PARM_DESC(baseaddr, "base address");
 module_param_array(numports, uint, NULL, 0);
 MODULE_PARM_DESC(numports, "numports (ignored for C218)");
-#endif
+
 module_param(ttymajor, int, 0);
 
 /*
@@ -1024,6 +1022,8 @@ static int __init moxa_init(void)
 {
 	unsigned int isabrds = 0;
 	int retval = 0;
+	struct moxa_board_conf *brd = moxa_boards;
+	unsigned int i;
 
 	printk(KERN_INFO "MOXA Intellio family driver version %s\n",
 			MOXA_VERSION);
@@ -1051,10 +1051,7 @@ static int __init moxa_init(void)
 	}
 
 	/* Find the boards defined from module args. */
-#ifdef MODULE
-	{
-	struct moxa_board_conf *brd = moxa_boards;
-	unsigned int i;
+
 	for (i = 0; i < MAX_BOARDS; i++) {
 		if (!baseaddr[i])
 			break;
@@ -1087,8 +1084,6 @@ static int __init moxa_init(void)
 			isabrds++;
 		}
 	}
-	}
-#endif
 
 #ifdef CONFIG_PCI
 	retval = pci_register_driver(&moxa_pci_driver);
-- 
1.7.0.1

