Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab0CBXhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:37:10 -0500
Received: from kroah.org ([198.145.64.141]:51603 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468Ab0CBXg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:36:58 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Rakib Mullick <rakib.mullick@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/36] ip2: remove #ifdef MODULE from ip2main.c
Date: Tue,  2 Mar 2010 15:36:23 -0800
Message-Id: <1267573003-782-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rakib Mullick <rakib.mullick@gmail.com>

On the kernel command line we can pass "module parameters".  So #ifdef
MODULE is obsolute now.  Remove it completely.  When CONFIG_PCI=n and
building ip2main.c then we are hit by the following warning.  So move
*pdev into #ifdef CONFIG_PCI.

drivers/char/ip2/ip2main.c: In function `ip2_loadmain':
drivers/char/ip2/ip2main.c:542: warning: unused variable `pdev'

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Acked-by: Michael H. Warfield <mhw@WittsEnd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/ip2/ip2main.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 517271c..2913d05 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -263,7 +263,7 @@ static int tracewrap;
 /* Macros */
 /**********/
 
-#if defined(MODULE) && defined(IP2DEBUG_OPEN)
+#ifdef IP2DEBUG_OPEN
 #define DBG_CNT(s) printk(KERN_DEBUG "(%s): [%x] ttyc=%d, modc=%x -> %s\n", \
 		    tty->name,(pCh->flags), \
 		    tty->count,/*GET_USE_COUNT(module)*/0,s)
@@ -487,7 +487,6 @@ static const struct firmware *ip2_request_firmware(void)
 	return fw;
 }
 
-#ifndef MODULE
 /******************************************************************************
  *	ip2_setup:
  *		str: kernel command line string
@@ -531,7 +530,6 @@ static int __init ip2_setup(char *str)
 	return 1;
 }
 __setup("ip2=", ip2_setup);
-#endif /* !MODULE */
 
 static int __init ip2_loadmain(void)
 {
@@ -539,7 +537,6 @@ static int __init ip2_loadmain(void)
 	int err = 0;
 	i2eBordStrPtr pB = NULL;
 	int rc = -1;
-	struct pci_dev *pdev = NULL;
 	const struct firmware *fw = NULL;
 
 	if (poll_only) {
@@ -612,6 +609,7 @@ static int __init ip2_loadmain(void)
 		case PCI:
 #ifdef CONFIG_PCI
 		{
+			struct pci_dev *pdev = NULL;
 			u32 addr;
 			int status;
 
@@ -626,7 +624,7 @@ static int __init ip2_loadmain(void)
 
 			if (pci_enable_device(pdev)) {
 				dev_err(&pdev->dev, "can't enable device\n");
-				break;
+				goto out;
 			}
 			ip2config.type[i] = PCI;
 			ip2config.pci_dev[i] = pci_dev_get(pdev);
@@ -638,6 +636,8 @@ static int __init ip2_loadmain(void)
 				dev_err(&pdev->dev, "I/O address error\n");
 
 			ip2config.irq[i] = pdev->irq;
+out:
+			pci_dev_put(pdev);
 		}
 #else
 			printk(KERN_ERR "IP2: PCI card specified but PCI "
@@ -656,7 +656,6 @@ static int __init ip2_loadmain(void)
 			break;
 		}	/* switch */
 	}	/* for */
-	pci_dev_put(pdev);
 
 	for (i = 0; i < IP2_MAX_BOARDS; ++i) {
 		if (ip2config.addr[i]) {
-- 
1.7.0.1

