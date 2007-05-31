Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbXEaVvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbXEaVvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 17:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbXEaVvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 17:51:17 -0400
Received: from hansmi.home.forkbomb.ch ([213.144.146.165]:50887 "EHLO
	hansmi.home.forkbomb.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbXEaVvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 17:51:16 -0400
X-Greylist: delayed 634 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2007 17:51:13 EDT
Date: Thu, 31 May 2007 23:34:27 +0200
From: Michael Hanselmann <linux-kernel@hansmi.ch>
To: linux-kernel@vger.kernel.org
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@killerfox.forkbomb.ch,
       dbrownell@users.sourceforge.net
Subject: [PATCH] Fix NEC OHCI chip silicon bug
Message-ID: <20070531213427.GA25154@hansmi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a silicon bug in some NEC OHCI chips. The bug appears
at random times and is very, very difficult to reproduce. Without the
following patch, Linux would shut the chip and its associated devices
down. In Apple PowerBooks this leads to an unusable keyboard and mouse
(SSH still working). The idea of restarting the chip is taken from
public Darwin code.

Signed-off-by: Michael Hanselmann <linux-kernel@hansmi.ch>

---
The OHCI driver uses inconsistent code formatting. I tried to stay with
the used style where I modified functions while using Doc/CodingStyle
for new functions.

diff -Nurp --exclude-from=linux-exclude-from linux-2.6.22-rc3.orig/drivers/usb/host/ohci.h linux-2.6.22-rc3/drivers/usb/host/ohci.h
--- linux-2.6.22-rc3.orig/drivers/usb/host/ohci.h	2007-05-31 22:53:54.000000000 +0200
+++ linux-2.6.22-rc3/drivers/usb/host/ohci.h	2007-05-31 22:54:27.000000000 +0200
@@ -397,8 +397,10 @@ struct ohci_hcd {
 #define	OHCI_QUIRK_BE_DESC	0x08			/* BE descriptors */
 #define	OHCI_QUIRK_BE_MMIO	0x10			/* BE registers */
 #define	OHCI_QUIRK_ZFMICRO	0x20			/* Compaq ZFMicro chipset*/
+#define	OHCI_QUIRK_NEC		0x40			/* lost interrupts */
 	// there are also chip quirks/bugs in init logic
 
+	struct work_struct	nec_work;	/* Worker for NEC quirk */
 };
 
 /* convert between an hcd pointer and the corresponding ohci_hcd */
diff -Nurp --exclude-from=linux-exclude-from linux-2.6.22-rc3.orig/drivers/usb/host/ohci-hcd.c linux-2.6.22-rc3/drivers/usb/host/ohci-hcd.c
--- linux-2.6.22-rc3.orig/drivers/usb/host/ohci-hcd.c	2007-05-31 22:53:54.000000000 +0200
+++ linux-2.6.22-rc3/drivers/usb/host/ohci-hcd.c	2007-05-31 23:24:56.000000000 +0200
@@ -35,6 +35,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
 #include <linux/reboot.h>
+#include <linux/workqueue.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -82,6 +83,8 @@ static const char	hcd_name [] = "ohci_hc
 static void ohci_dump (struct ohci_hcd *ohci, int verbose);
 static int ohci_init (struct ohci_hcd *ohci);
 static void ohci_stop (struct usb_hcd *hcd);
+static int ohci_restart (struct ohci_hcd *ohci);
+static void ohci_quirk_nec_worker (struct work_struct *work);
 
 #include "ohci-hub.c"
 #include "ohci-dbg.c"
@@ -659,9 +662,20 @@ static irqreturn_t ohci_irq (struct usb_
 	}
 
 	if (ints & OHCI_INTR_UE) {
-		disable (ohci);
-		ohci_err (ohci, "OHCI Unrecoverable Error, disabled\n");
 		// e.g. due to PCI Master/Target Abort
+		if (ohci->flags & OHCI_QUIRK_NEC) {
+			/* Workaround for a silicon bug in some NEC chips used
+			 * in Apple's PowerBooks. Adapted from Darwin code.
+			 */
+			ohci_err (ohci, "OHCI Unrecoverable Error, scheduling NEC chip restart\n");
+
+			ohci_writel (ohci, OHCI_INTR_UE, &regs->intrdisable);
+
+			schedule_work (&ohci->nec_work);
+		} else {
+			disable (ohci);
+			ohci_err (ohci, "OHCI Unrecoverable Error, disabled\n");
+		}
 
 		ohci_dump (ohci, 1);
 		ohci_usb_reset (ohci);
@@ -763,9 +777,6 @@ static void ohci_stop (struct usb_hcd *h
 /*-------------------------------------------------------------------------*/
 
 /* must not be called from interrupt context */
-
-#ifdef	CONFIG_PM
-
 static int ohci_restart (struct ohci_hcd *ohci)
 {
 	int temp;
@@ -779,7 +790,11 @@ static int ohci_restart (struct ohci_hcd
 	 */
 	spin_lock_irq(&ohci->lock);
 	disable (ohci);
+
+#ifdef CONFIG_PM
 	usb_root_hub_lost_power(ohci_to_hcd(ohci)->self.root_hub);
+#endif
+
 	if (!list_empty (&ohci->pending))
 		ohci_dbg(ohci, "abort schedule...\n");
 	list_for_each_entry (priv, &ohci->pending, pending) {
@@ -839,7 +854,27 @@ static int ohci_restart (struct ohci_hcd
 	}
 	return 0;
 }
-#endif
+
+/*-------------------------------------------------------------------------*/
+
+/* NEC workaround */
+static void ohci_quirk_nec_worker(struct work_struct *work)
+{
+	struct ohci_hcd *ohci = container_of(work, struct ohci_hcd, nec_work);
+	int status;
+
+	status = ohci_init(ohci);
+	if (status != 0) {
+		ohci_err(ohci, "Restarting NEC controller failed "
+			 "in ohci_init, %d\n", status);
+		return;
+	}
+
+	status = ohci_restart(ohci);
+	if (status != 0)
+		ohci_err(ohci, "Restarting NEC controller failed "
+			 "in ohci_restart, %d\n", status);
+}
 
 /*-------------------------------------------------------------------------*/
 
diff -Nurp --exclude-from=linux-exclude-from linux-2.6.22-rc3.orig/drivers/usb/host/ohci-hub.c linux-2.6.22-rc3/drivers/usb/host/ohci-hub.c
--- linux-2.6.22-rc3.orig/drivers/usb/host/ohci-hub.c	2007-05-31 22:53:54.000000000 +0200
+++ linux-2.6.22-rc3/drivers/usb/host/ohci-hub.c	2007-05-31 22:54:27.000000000 +0200
@@ -55,8 +55,6 @@ static void dl_done_list (struct ohci_hc
 static void finish_unlinks (struct ohci_hcd *, u16);
 
 #ifdef	CONFIG_PM
-static int ohci_restart(struct ohci_hcd *ohci);
-
 static int ohci_rh_suspend (struct ohci_hcd *ohci, int autostop)
 __releases(ohci->lock)
 __acquires(ohci->lock)
diff -Nurp --exclude-from=linux-exclude-from linux-2.6.22-rc3.orig/drivers/usb/host/ohci-mem.c linux-2.6.22-rc3/drivers/usb/host/ohci-mem.c
--- linux-2.6.22-rc3.orig/drivers/usb/host/ohci-mem.c	2007-05-31 22:53:54.000000000 +0200
+++ linux-2.6.22-rc3/drivers/usb/host/ohci-mem.c	2007-05-31 23:24:43.000000000 +0200
@@ -28,6 +28,7 @@ static void ohci_hcd_init (struct ohci_h
 	ohci->next_statechange = jiffies;
 	spin_lock_init (&ohci->lock);
 	INIT_LIST_HEAD (&ohci->pending);
+	INIT_WORK (&ohci->nec_work, ohci_quirk_nec_worker);
 }
 
 /*-------------------------------------------------------------------------*/
diff -Nurp --exclude-from=linux-exclude-from linux-2.6.22-rc3.orig/drivers/usb/host/ohci-pci.c linux-2.6.22-rc3/drivers/usb/host/ohci-pci.c
--- linux-2.6.22-rc3.orig/drivers/usb/host/ohci-pci.c	2007-05-31 22:53:54.000000000 +0200
+++ linux-2.6.22-rc3/drivers/usb/host/ohci-pci.c	2007-05-31 22:54:27.000000000 +0200
@@ -111,6 +111,18 @@ static int ohci_quirk_toshiba_scc(struct
 #endif
 }
 
+/* Check for NEC chip and apply quirk for allegedly lost interrupts.
+ */
+static int ohci_quirk_nec(struct usb_hcd *hcd)
+{
+	struct ohci_hcd	*ohci = hcd_to_ohci (hcd);
+
+	ohci->flags |= OHCI_QUIRK_NEC;
+	ohci_dbg (ohci, "enabled NEC chipset lost interrupt quirk\n");
+
+	return 0;
+}
+
 /* List of quirks for OHCI */
 static const struct pci_device_id ohci_pci_quirks[] = {
 	{
@@ -134,6 +146,10 @@ static const struct pci_device_id ohci_p
 		.driver_data = (unsigned long)ohci_quirk_toshiba_scc,
 	},
 	{
+		PCI_DEVICE(PCI_VENDOR_ID_NEC, PCI_DEVICE_ID_NEC_USB),
+		.driver_data = (unsigned long)ohci_quirk_nec,
+	},
+	{
 		/* Toshiba portege 4000 */
 		.vendor		= PCI_VENDOR_ID_AL,
 		.device		= 0x5237,
