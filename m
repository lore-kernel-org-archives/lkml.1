Return-Path: <linux-kernel-owner+w=401wt.eu-S1760680AbXHUTGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680AbXHUTGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 15:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756444AbXHUTGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 15:06:15 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:22938 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755719AbXHUTGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 15:06:14 -0400
Date: Tue, 21 Aug 2007 21:10:29 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [WATCHDOG] v2.6.23-rc3 patches
Message-ID: <20070821191029.GA3255@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 Documentation/watchdog/00-INDEX      |   10 ++++++++++
 drivers/char/watchdog/alim1535_wdt.c |    7 +++++--
 drivers/char/watchdog/eurotechwdt.c  |   13 +++++++++----
 3 files changed, 24 insertions(+), 6 deletions(-)

with these Changes:

Author: Andrey Borzenkov <arvidjaar@mail.ru>
Date:   Thu Aug 16 19:32:19 2007 +0000

    [WATCHDOG] Add support for 1533 bridge to alim1535_wdt
    From: Andrey Borzenkov <arvidjaar@mail.ru>
    
    They are apparently pretty close (even lspci combines them). The patch
    adds support for 0x1533 bridge in addition to 0x1535.
    
    Tested on Toshiba Portege 4000 with
    
    00:07.0 ISA bridge [0601]: ALi Corporation M1533/M1535 PCI to ISA Bridge
    [Aladdin IV/V/V+] [10b9:1533]
    00:08.0 Bridge [0680]: ALi Corporation M7101 Power Management Controller
    [PMU] [10b9:7101]
    
    with result
    
    [ 2090.906736] PCI: Enabling device 0000:00:08.0 (0000 -> 0001)
    [ 2090.914034] ALi_M1535: initialized. timeout=3D60 sec (nowayout=3D0)
    
    Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Jesper Juhl <jesper.juhl@gmail.com>
Date:   Sun Aug 12 00:49:14 2007 +0200

    [WATCHDOG] Add a 00-INDEX file to Documentation/watchdog/
    
    Add a 00-INDEX file to Documentation/watchdog/
    
    Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu Aug 9 19:38:00 2007 +0000

    [WATCHDOG] Eurotechwdt.c - clean-up comments
    
    Clean-up history and add a comment about the fact that
    the watchdog is actually part of the SMSC FDC 37B782
    super I/O chipset.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/watchdog/00-INDEX b/Documentation/watchdog/00-INDEX
new file mode 100644
index 0000000..c3ea47e
--- /dev/null
+++ b/Documentation/watchdog/00-INDEX
@@ -0,0 +1,10 @@
+00-INDEX
+	- this file.
+pcwd-watchdog.txt
+	- documentation for Berkshire Products PC Watchdog ISA cards.
+src/
+	- directory holding watchdog related example programs.
+watchdog-api.txt
+	- description of the Linux Watchdog driver API.
+wdt.txt
+	- description of the Watchdog Timer Interfaces for Linux.
diff --git a/drivers/char/watchdog/alim1535_wdt.c b/drivers/char/watchdog/alim1535_wdt.c
index e3f6a7d..c404fc6 100644
--- a/drivers/char/watchdog/alim1535_wdt.c
+++ b/drivers/char/watchdog/alim1535_wdt.c
@@ -312,6 +312,7 @@ static int ali_notify_sys(struct notifier_block *this, unsigned long code, void
  */
 
 static struct pci_device_id ali_pci_tbl[] = {
+	{ PCI_VENDOR_ID_AL, 0x1533, PCI_ANY_ID, PCI_ANY_ID,},
 	{ PCI_VENDOR_ID_AL, 0x1535, PCI_ANY_ID, PCI_ANY_ID,},
 	{ 0, },
 };
@@ -329,9 +330,11 @@ static int __init ali_find_watchdog(void)
 	struct pci_dev *pdev;
 	u32 wdog;
 
-	/* Check for a 1535 series bridge */
+	/* Check for a 1533/1535 series bridge */
 	pdev = pci_get_device(PCI_VENDOR_ID_AL, 0x1535, NULL);
-	if(pdev == NULL)
+	if (pdev == NULL)
+		pdev = pci_get_device(PCI_VENDOR_ID_AL, 0x1533, NULL);
+	if (pdev == NULL)
 		return -ENODEV;
 	pci_dev_put(pdev);
 
diff --git a/drivers/char/watchdog/eurotechwdt.c b/drivers/char/watchdog/eurotechwdt.c
index b070324..b14e9d1 100644
--- a/drivers/char/watchdog/eurotechwdt.c
+++ b/drivers/char/watchdog/eurotechwdt.c
@@ -1,5 +1,5 @@
 /*
- *	Eurotech CPU-1220/1410 on board WDT driver
+ *	Eurotech CPU-1220/1410/1420 on board WDT driver
  *
  *	(c) Copyright 2001 Ascensit <support@ascensit.com>
  *	(c) Copyright 2001 Rodolfo Giometti <giometti@ascensit.com>
@@ -25,6 +25,9 @@
 
 /* Changelog:
  *
+ * 2001 - Rodolfo Giometti
+ *	Initial release
+ *
  * 2002/04/25 - Rob Radez
  *	clean up #includes
  *	clean up locking
@@ -33,13 +36,15 @@
  *	add WDIOC_GETSTATUS and WDIOC_SETOPTIONS ioctls
  *	add expect_close support
  *
- * 2001 - Rodolfo Giometti
- *	Initial release
- *
  * 2002.05.30 - Joel Becker <joel.becker@oracle.com>
  * 	Added Matt Domsch's nowayout module option.
  */
 
+/*
+ *	The eurotech CPU-1220/1410/1420's watchdog is a part
+ *	of the on-board SUPER I/O device SMSC FDC 37B782.
+ */
+
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
