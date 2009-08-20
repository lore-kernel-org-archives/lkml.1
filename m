Return-Path: <linux-kernel-owner+w=401wt.eu-S932146AbZHTUml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbZHTUml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 16:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932119AbZHTUmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 16:42:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:51314 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113AbZHTUme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 16:42:34 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>,
       Alan Stern <stern@rowland.harvard.edu>, dbrownell@users.sourceforge.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 07/11] ehci-dbgp,ehci: Allow early or late use of the dbgp device
Date: Thu, 20 Aug 2009 15:39:54 -0500
Message-Id: <1250800798-31559-8-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1250800798-31559-7-git-send-email-jason.wessel@windriver.com>
References: <1250800798-31559-1-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-2-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-3-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-4-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-5-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-6-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-7-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 20 Aug 2009 20:40:56.0258 (UTC) FILETIME=[8476DA20:01CA21D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the EHCI debug port is initialized and in use, the EHCI host
controller driver must follow two rules.

1) If the EHCI host driver issues a controller reset, the debug
   controller driver re-initialization must get called after the reset
   is completed.

2) The EHCI host driver should ignore any requests to the physical
   EHCI debug port when the EHCI debug port is in use.

The code to check for the debug port was moved from ehci_pci_reinit()
to ehci_pci_setup because it must get called prior to ehci_reset()
which will clear the debug port registers.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: dbrownell@users.sourceforge.net
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
---
 drivers/usb/early/ehci-dbgp.c |   23 +++++++++++++++++++++++
 drivers/usb/host/ehci-hcd.c   |    8 ++++++++
 drivers/usb/host/ehci-hub.c   |   10 ++++++++++
 drivers/usb/host/ehci-pci.c   |   39 +++++++++++++++++++--------------------
 include/linux/usb/ehci_def.h  |   10 ++++++++++
 5 files changed, 70 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/early/ehci-dbgp.c b/drivers/usb/early/ehci-dbgp.c
index 06e05ea..b88cb65 100644
--- a/drivers/usb/early/ehci-dbgp.c
+++ b/drivers/usb/early/ehci-dbgp.c
@@ -933,3 +933,26 @@ struct console early_dbgp_console = {
 	.flags =	CON_PRINTBUFFER,
 	.index =	-1,
 };
+
+int dbgp_reset_prep(void)
+{
+	u32 ctrl;
+
+	dbgp_not_safe = 1;
+	if (!ehci_debug)
+		return 0;
+
+	if (early_dbgp_console.index != -1 &&
+		!(early_dbgp_console.flags & CON_BOOT))
+		return 1;
+	/* This means the console is not initialized, or should get
+	 * shutdown so as to allow for reuse of the usb device, which
+	 * means it is time to shutdown the usb debug port. */
+	ctrl = readl(&ehci_debug->control);
+	if (ctrl & DBGP_ENABLED) {
+		ctrl &= ~(DBGP_CLAIM);
+		writel(ctrl, &ehci_debug->control);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dbgp_reset_prep);
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 11c627c..06048f4 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -239,6 +239,11 @@ static int ehci_reset (struct ehci_hcd *ehci)
 	int	retval;
 	u32	command = ehci_readl(ehci, &ehci->regs->command);
 
+	/* If the EHCI debug controller is active, special care must be
+	 * taken before and after a host controller reset */
+	if (ehci->debug && !dbgp_reset_prep())
+		ehci->debug = NULL;
+
 	command |= CMD_RESET;
 	dbg_cmd (ehci, "reset", command);
 	ehci_writel(ehci, command, &ehci->regs->command);
@@ -253,6 +258,9 @@ static int ehci_reset (struct ehci_hcd *ehci)
 	if (ehci_is_TDI(ehci))
 		tdi_reset (ehci);
 
+	if (ehci->debug)
+		dbgp_external_startup();
+
 	return retval;
 }
 
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index f46ad27..452380e 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -816,6 +816,15 @@ static int ehci_hub_control (
 	case SetPortFeature:
 		selector = wIndex >> 8;
 		wIndex &= 0xff;
+		if (unlikely(ehci->debug)) {
+			/* If the debug port is active any port
+			 * feature requests should get denied */
+			if (wIndex == HCS_DEBUG_PORT(ehci->hcs_params) &&
+			    (readl(&ehci->debug->control) & DBGP_ENABLED)) {
+				retval = -ENODEV;
+				goto error_exit;
+			}
+		}
 		if (!wIndex || wIndex > ports)
 			goto error;
 		wIndex--;
@@ -894,6 +903,7 @@ error:
 		/* "stall" on error */
 		retval = -EPIPE;
 	}
+error_exit:
 	spin_unlock_irqrestore (&ehci->lock, flags);
 	return retval;
 }
diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index c2f1b7d..ea36c1c 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -27,28 +27,8 @@
 /* called after powerup, by probe or system-pm "wakeup" */
 static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
 {
-	u32			temp;
 	int			retval;
 
-	/* optional debug port, normally in the first BAR */
-	temp = pci_find_capability(pdev, 0x0a);
-	if (temp) {
-		pci_read_config_dword(pdev, temp, &temp);
-		temp >>= 16;
-		if ((temp & (3 << 13)) == (1 << 13)) {
-			temp &= 0x1fff;
-			ehci->debug = ehci_to_hcd(ehci)->regs + temp;
-			temp = ehci_readl(ehci, &ehci->debug->control);
-			ehci_info(ehci, "debug port %d%s\n",
-				HCS_DEBUG_PORT(ehci->hcs_params),
-				(temp & DBGP_ENABLED)
-					? " IN USE"
-					: "");
-			if (!(temp & DBGP_ENABLED))
-				ehci->debug = NULL;
-		}
-	}
-
 	/* we expect static quirk code to handle the "extended capabilities"
 	 * (currently just BIOS handoff) allowed starting with EHCI 0.96
 	 */
@@ -192,6 +172,25 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
 		break;
 	}
 
+	/* optional debug port, normally in the first BAR */
+	temp = pci_find_capability(pdev, 0x0a);
+	if (temp) {
+		pci_read_config_dword(pdev, temp, &temp);
+		temp >>= 16;
+		if ((temp & (3 << 13)) == (1 << 13)) {
+			temp &= 0x1fff;
+			ehci->debug = ehci_to_hcd(ehci)->regs + temp;
+			temp = ehci_readl(ehci, &ehci->debug->control);
+			ehci_info(ehci, "debug port %d%s\n",
+				HCS_DEBUG_PORT(ehci->hcs_params),
+				(temp & DBGP_ENABLED)
+					? " IN USE"
+					: "");
+			if (!(temp & DBGP_ENABLED))
+				ehci->debug = NULL;
+		}
+	}
+
 	ehci_reset(ehci);
 
 	/* at least the Genesys GL880S needs fixup here */
diff --git a/include/linux/usb/ehci_def.h b/include/linux/usb/ehci_def.h
index e1346fd..7290daf 100644
--- a/include/linux/usb/ehci_def.h
+++ b/include/linux/usb/ehci_def.h
@@ -166,6 +166,16 @@ extern struct console early_dbgp_console;
 #ifdef CONFIG_EARLY_PRINTK_DBGP
 /* Call backs from ehci host driver to ehci debug driver */
 extern int dbgp_external_startup(void);
+extern int dbgp_reset_prep(void);
+#else
+static inline int dbgp_reset_prep(void)
+{
+	return 1;
+}
+static inline int dbgp_external_startup(void)
+{
+	return -1;
+}
 #endif
 
 #endif /* __LINUX_USB_EHCI_DEF_H */
-- 
1.6.3.1.9.g95405b

