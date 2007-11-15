Return-Path: <linux-kernel-owner+w=401wt.eu-S933404AbXKOHBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404AbXKOHBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763544AbXKOGri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:47:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58061 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525AbXKOGrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:47:35 -0500
Date: Wed, 14 Nov 2007 22:45:07 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-usb-devel@lists.sourceforge.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>,
       David Miller <davem@davemloft.net>, Dely L Sy <dely.l.sy@intel.com>
Subject: [patch 22/40] USB: mutual exclusion for EHCI init and port resets
Message-ID: <20071115064507.GW19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-mutual-exclusion-for-ehci-init-and-port-resets.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

patch 32fe01985aa2cb2562f6fc171e526e279abe10db in mainline.

This patch (as999) fixes a problem that sometimes shows up when host
controller driver modules are loaded in the wrong order.  If ehci-hcd
happens to initialize an EHCI controller while the companion OHCI or
UHCI controller is in the middle of a port reset, the reset can fail
and the companion may get very confused.  The patch adds an
rw-semaphore and uses it to keep EHCI initialization and port resets
mutually exclusive.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: David Brownell <david-b@pacbell.net>
Cc: David Miller <davem@davemloft.net>
Cc: Dely L Sy <dely.l.sy@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/core/hcd.h      |    8 +++++++-
 drivers/usb/core/hub.c      |   15 ++++++++++++++-
 drivers/usb/host/ehci-hcd.c |    8 ++++++++
 3 files changed, 29 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hcd.h
+++ b/drivers/usb/core/hcd.h
@@ -19,6 +19,8 @@
 
 #ifdef __KERNEL__
 
+#include <linux/rwsem.h>
+
 /* This file contains declarations of usbcore internals that are mostly
  * used or exposed by Host Controller Drivers.
  */
@@ -454,5 +456,9 @@ static inline void usbmon_urb_complete(s
 		: (in_interrupt () ? "in_interrupt" : "can sleep"))
 
 
-#endif /* __KERNEL__ */
+/* This rwsem is for use only by the hub driver and ehci-hcd.
+ * Nobody else should touch it.
+ */
+extern struct rw_semaphore ehci_cf_port_reset_rwsem;
 
+#endif /* __KERNEL__ */
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -125,6 +125,12 @@ MODULE_PARM_DESC(use_both_schemes,
 		"try the other device initialization scheme if the "
 		"first one fails");
 
+/* Mutual exclusion for EHCI CF initialization.  This interferes with
+ * port reset on some companion controllers.
+ */
+DECLARE_RWSEM(ehci_cf_port_reset_rwsem);
+EXPORT_SYMBOL_GPL(ehci_cf_port_reset_rwsem);
+
 
 static inline char *portspeed(int portstatus)
 {
@@ -1460,6 +1466,11 @@ static int hub_port_reset(struct usb_hub
 {
 	int i, status;
 
+	/* Block EHCI CF initialization during the port reset.
+	 * Some companion controllers don't like it when they mix.
+	 */
+	down_read(&ehci_cf_port_reset_rwsem);
+
 	/* Reset the port */
 	for (i = 0; i < PORT_RESET_TRIES; i++) {
 		status = set_port_feature(hub->hdev,
@@ -1490,7 +1501,7 @@ static int hub_port_reset(struct usb_hub
 			usb_set_device_state(udev, status
 					? USB_STATE_NOTATTACHED
 					: USB_STATE_DEFAULT);
-			return status;
+			goto done;
 		}
 
 		dev_dbg (hub->intfdev,
@@ -1503,6 +1514,8 @@ static int hub_port_reset(struct usb_hub
 		"Cannot enable port %i.  Maybe the USB cable is bad?\n",
 		port1);
 
+ done:
+	up_read(&ehci_cf_port_reset_rwsem);
 	return status;
 }
 
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -570,10 +570,18 @@ static int ehci_run (struct usb_hcd *hcd
 	 * are explicitly handed to companion controller(s), so no TT is
 	 * involved with the root hub.  (Except where one is integrated,
 	 * and there's no companion controller unless maybe for USB OTG.)
+	 *
+	 * Turning on the CF flag will transfer ownership of all ports
+	 * from the companions to the EHCI controller.  If any of the
+	 * companions are in the middle of a port reset at the time, it
+	 * could cause trouble.  Write-locking ehci_cf_port_reset_rwsem
+	 * guarantees that no resets are in progress.
 	 */
+	down_write(&ehci_cf_port_reset_rwsem);
 	hcd->state = HC_STATE_RUNNING;
 	ehci_writel(ehci, FLAG_CF, &ehci->regs->configured_flag);
 	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
+	up_write(&ehci_cf_port_reset_rwsem);
 
 	temp = HC_VERSION(ehci_readl(ehci, &ehci->caps->hc_capbase));
 	ehci_info (ehci,

-- 
