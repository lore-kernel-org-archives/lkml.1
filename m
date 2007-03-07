Return-Path: <linux-kernel-owner+w=401wt.eu-S1422786AbXCGRvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422786AbXCGRvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422796AbXCGROm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:14:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:43671 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422786AbXCGROd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:14:33 -0500
Message-Id: <20070307171256.756095421@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 030/101] EHCI: turn off remote wakeup during shutdown
Content-Disposition: inline; filename=ehci-turn-off-remote-wakeup-during-shutdown.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as850b) disables remote wakeup (and everything else!) on
all EHCI ports when the shutdown() method is called.  If remote wakeup
is left active then some systems will reboot instead of powering off.
This fixes Bugzilla #7828.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-hcd.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- linux-2.6.20.1.orig/drivers/usb/host/ehci-hcd.c
+++ linux-2.6.20.1/drivers/usb/host/ehci-hcd.c
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

--
