Return-Path: <linux-kernel-owner+w=401wt.eu-S1750875AbXBMTxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750875AbXBMTxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 14:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbXBMTxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 14:53:08 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:51898 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750875AbXBMTxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 14:53:07 -0500
Date: Tue, 13 Feb 2007 14:53:06 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: stable@kernel.org
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] EHCI: turn off remote wakeup during shutdown
Message-ID: <Pine.LNX.4.44L0.0702131448400.2573-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as850b) disables remote wakeup (and everything else!) on
all EHCI ports when the shutdown() method is called.  If remote wakeup
is left active then some systems will reboot instead of powering off.
This fixes Bugzilla #7828.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

I'm submitting this for 2.6.20.stable.  The problem it addresses can occur
with earlier kernels, but not unless the user explicitly enables remote
wakeup by doing a runtime suspend of the EHCI root hub.  In 2.6.20 the
root hub will autosuspend itself, enabling remote wakeup and thus
triggering the problem.

A slightly different version of this patch will be submitted separately
for Greg KH's USB development tree.

Alan Stern


Index: 2.6.20/drivers/usb/host/ehci-hcd.c
===================================================================
--- 2.6.20.orig/drivers/usb/host/ehci-hcd.c
+++ 2.6.20/drivers/usb/host/ehci-hcd.c
@@ -296,6 +296,18 @@ static void ehci_watchdog (unsigned long
 	spin_unlock_irqrestore (&ehci->lock, flags);
 }
 
+/* On some systems, leaving remote wakeup enabled prevents system shutdown.
+ * The firmware seems to think that powering off is a wakeup event!
+ * This routine turns off remote wakeup and everything else, on all ports.
+ */
+static void ehci_turn_off_all_ports(struct ehci_hcd *ehci)
+{
+	int	port = HCS_N_PORTS(ehci->hcs_params);
+
+	while (port--)
+		writel(PORT_RWC_BITS, &ehci->regs->port_status[port]);
+}
+
 /* ehci_shutdown kick in for silicon on any bus (not just pci, etc).
  * This forcibly disables dma and IRQs, helping kexec and other cases
  * where the next system software may expect clean state.
@@ -307,9 +319,13 @@ ehci_shutdown (struct usb_hcd *hcd)
 
 	ehci = hcd_to_ehci (hcd);
 	(void) ehci_halt (ehci);
+	ehci_turn_off_all_ports(ehci);
 
 	/* make BIOS/etc use companion controller during reboot */
 	writel (0, &ehci->regs->configured_flag);
+
+	/* unblock posted writes */
+	readl(&ehci->regs->configured_flag);
 }
 
 static void ehci_port_power (struct ehci_hcd *ehci, int is_on)

