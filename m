Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbXJISmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbXJISmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbXJISml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:42:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33967 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751889AbXJISml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:42:41 -0400
Date: Tue, 9 Oct 2007 14:42:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: David Miller <davem@davemloft.net>, David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB users list <linux-usb-users@lists.sourceforge.net>
Subject: Re: [Linux-usb-users] OHCI root_port_reset() deadly loop...
In-Reply-To: <20071009173925.GA6062@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0710091440130.4783-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2007, Greg KH wrote:

> > Anyway, it certainly would be easy enough to make port resets mutually
> > exclusive with EHCI initialization.  That would work on any platform,
> > PCI or not.
> 
> That's a good idea, any thoughts as to how to do this?  I think I can
> find some Intel and Dell people who would be glad to test this out if
> you have a proposed patch.

Here is a proposed patch.  I haven't tried running it, but it compiles 
okay.

Alan Stern



Index: usb-2.6/drivers/usb/core/hcd.h
===================================================================
--- usb-2.6.orig/drivers/usb/core/hcd.h
+++ usb-2.6/drivers/usb/core/hcd.h
@@ -19,6 +19,8 @@
 
 #ifdef __KERNEL__
 
+#include <linux/rwsem.h>
+
 /* This file contains declarations of usbcore internals that are mostly
  * used or exposed by Host Controller Drivers.
  */
@@ -470,5 +472,9 @@ static inline void usbmon_urb_complete(s
 		: (in_interrupt () ? "in_interrupt" : "can sleep"))
 
 
-#endif /* __KERNEL__ */
+/* Mutual exclusion for EHCI CF initialization.  This interferes with
+ * port reset on some companion controllers.
+ */
+extern struct rw_semaphore ehci_cf_port_reset_rwsem;
 
+#endif /* __KERNEL__ */
Index: usb-2.6/drivers/usb/core/hub.c
===================================================================
--- usb-2.6.orig/drivers/usb/core/hub.c
+++ usb-2.6/drivers/usb/core/hub.c
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
@@ -1579,6 +1585,8 @@ static int hub_port_reset(struct usb_hub
 {
 	int i, status;
 
+	down_read(&ehci_cf_port_reset_rwsem);
+
 	/* Reset the port */
 	for (i = 0; i < PORT_RESET_TRIES; i++) {
 		status = set_port_feature(hub->hdev,
@@ -1610,7 +1618,7 @@ static int hub_port_reset(struct usb_hub
 			usb_set_device_state(udev, status
 					? USB_STATE_NOTATTACHED
 					: USB_STATE_DEFAULT);
-			return status;
+			goto done;
 		}
 
 		dev_dbg (hub->intfdev,
@@ -1623,6 +1631,8 @@ static int hub_port_reset(struct usb_hub
 		"Cannot enable port %i.  Maybe the USB cable is bad?\n",
 		port1);
 
+ done:
+	up_read(&ehci_cf_port_reset_rwsem);
 	return status;
 }
 
Index: usb-2.6/drivers/usb/host/ehci-hcd.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-hcd.c
+++ usb-2.6/drivers/usb/host/ehci-hcd.c
@@ -646,9 +646,11 @@ static int ehci_run (struct usb_hcd *hcd
 	 * involved with the root hub.  (Except where one is integrated,
 	 * and there's no companion controller unless maybe for USB OTG.)
 	 */
+	down_write(&ehci_cf_port_reset_rwsem);
 	hcd->state = HC_STATE_RUNNING;
 	ehci_writel(ehci, FLAG_CF, &ehci->regs->configured_flag);
 	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
+	up_write(&ehci_cf_port_reset_rwsem);
 
 	temp = HC_VERSION(ehci_readl(ehci, &ehci->caps->hc_capbase));
 	ehci_info (ehci,

