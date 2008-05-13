Return-Path: <linux-kernel-owner+w=401wt.eu-S1761884AbYEMUNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761884AbYEMUNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761351AbYEMUMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:12:38 -0400
Received: from ns1.suse.de ([195.135.220.2]:37220 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761335AbYEMUMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:12:36 -0400
Date: Tue, 13 May 2008 13:11:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 04/37] OHCI: fix regression upon awakening from hibernation
Message-ID: <20080513201130.GE31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ohci-fix-regression-upon-awakening-from-hibernation.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 43bbb7e015c4380064796c5868b536437b165615 in upstream

Drivers in the ohci-hcd family should perform certain tasks whenever
their controller device is resumed.  These include checking for loss
of power during suspend, turning on port power, and enabling interrupt
requests.

Until now these jobs have been carried out when the root hub is
resumed, not when the controller is.  Many drivers work around the
resulting awkwardness by automatically resuming their root hub
whenever the controller is resumed.  But this is wasteful and
unnecessary.

In 2.6.25, ohci-pci doesn't even do that.  After waking up from
hibernation, it simply leaves the controller in a RESET state, which
is useless.

To simplify the situation, this patch (as1066b) adds a new core
routine, ohci_finish_controller_resume(), which can be used by all the
OHCI-variant drivers.  They can call the new routine instead of
resuming their root hubs.  And ohci-pci.c can call it instead of using
its own special-purpose handler.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ohci-at91.c   |    1 
 drivers/usb/host/ohci-ep93xx.c |    2 -
 drivers/usb/host/ohci-hub.c    |   43 +++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/ohci-omap.c   |    2 -
 drivers/usb/host/ohci-pci.c    |   43 -----------------------------------------
 drivers/usb/host/ohci-pxa27x.c |    3 --
 drivers/usb/host/ohci-sm501.c  |    2 -
 drivers/usb/host/ohci-ssb.c    |    1 
 8 files changed, 50 insertions(+), 47 deletions(-)

--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -348,6 +348,7 @@ static int ohci_hcd_at91_drv_resume(stru
 	if (!clocked)
 		at91_start_clock();
 
+	ohci_finish_controller_resume(hcd);
 	return 0;
 }
 #else
--- a/drivers/usb/host/ohci-ep93xx.c
+++ b/drivers/usb/host/ohci-ep93xx.c
@@ -194,8 +194,8 @@ static int ohci_hcd_ep93xx_drv_resume(st
 
 	ep93xx_start_hc(&pdev->dev);
 	pdev->dev.power.power_state = PMSG_ON;
-	usb_hcd_resume_root_hub(hcd);
 
+	ohci_finish_controller_resume(hcd);
 	return 0;
 }
 #endif
--- a/drivers/usb/host/ohci-hub.c
+++ b/drivers/usb/host/ohci-hub.c
@@ -326,6 +326,49 @@ static int ohci_bus_resume (struct usb_h
 	return rc;
 }
 
+/* Carry out the final steps of resuming the controller device */
+static void ohci_finish_controller_resume(struct usb_hcd *hcd)
+{
+	struct ohci_hcd		*ohci = hcd_to_ohci(hcd);
+	int			port;
+	bool			need_reinit = false;
+
+	/* See if the controller is already running or has been reset */
+	ohci->hc_control = ohci_readl(ohci, &ohci->regs->control);
+	if (ohci->hc_control & (OHCI_CTRL_IR | OHCI_SCHED_ENABLES)) {
+		need_reinit = true;
+	} else {
+		switch (ohci->hc_control & OHCI_CTRL_HCFS) {
+		case OHCI_USB_OPER:
+		case OHCI_USB_RESET:
+			need_reinit = true;
+		}
+	}
+
+	/* If needed, reinitialize and suspend the root hub */
+	if (need_reinit) {
+		spin_lock_irq(&ohci->lock);
+		hcd->state = HC_STATE_RESUMING;
+		ohci_rh_resume(ohci);
+		hcd->state = HC_STATE_QUIESCING;
+		ohci_rh_suspend(ohci, 0);
+		hcd->state = HC_STATE_SUSPENDED;
+		spin_unlock_irq(&ohci->lock);
+	}
+
+	/* Normally just turn on port power and enable interrupts */
+	else {
+		ohci_dbg(ohci, "powerup ports\n");
+		for (port = 0; port < ohci->num_ports; port++)
+			ohci_writel(ohci, RH_PS_PPS,
+					&ohci->regs->roothub.portstatus[port]);
+
+		ohci_writel(ohci, OHCI_INTR_MIE, &ohci->regs->intrenable);
+		ohci_readl(ohci, &ohci->regs->intrenable);
+		msleep(20);
+	}
+}
+
 /* Carry out polling-, autostop-, and autoresume-related state changes */
 static int ohci_root_hub_state_changes(struct ohci_hcd *ohci, int changed,
 		int any_connected)
--- a/drivers/usb/host/ohci-omap.c
+++ b/drivers/usb/host/ohci-omap.c
@@ -519,7 +519,7 @@ static int ohci_omap_resume(struct platf
 
 	omap_ohci_clock_power(1);
 	dev->dev.power.power_state = PMSG_ON;
-	usb_hcd_resume_root_hub(platform_get_drvdata(dev));
+	ohci_finish_controller_resume(hcd);
 	return 0;
 }
 
--- a/drivers/usb/host/ohci-pci.c
+++ b/drivers/usb/host/ohci-pci.c
@@ -238,42 +238,6 @@ static int __devinit ohci_pci_start (str
 	return ret;
 }
 
-#if	defined(CONFIG_USB_PERSIST) && (defined(CONFIG_USB_EHCI_HCD) || \
-		defined(CONFIG_USB_EHCI_HCD_MODULE))
-
-/* Following a power loss, we must prepare to regain control of the ports
- * we used to own.  This means turning on the port power before ehci-hcd
- * tries to switch ownership.
- *
- * This isn't a 100% perfect solution.  On most systems the OHCI controllers
- * lie at lower PCI addresses than the EHCI controller, so they will be
- * discovered (and hence resumed) first.  But there is no guarantee things
- * will always work this way.  If the EHCI controller is resumed first and
- * the OHCI ports are unpowered, then the handover will fail.
- */
-static void prepare_for_handover(struct usb_hcd *hcd)
-{
-	struct ohci_hcd	*ohci = hcd_to_ohci(hcd);
-	int		port;
-
-	/* Here we "know" root ports should always stay powered */
-	ohci_dbg(ohci, "powerup ports\n");
-	for (port = 0; port < ohci->num_ports; port++)
-		ohci_writel(ohci, RH_PS_PPS,
-				&ohci->regs->roothub.portstatus[port]);
-
-	/* Flush those writes */
-	ohci_readl(ohci, &ohci->regs->control);
-	msleep(20);
-}
-
-#else
-
-static inline void prepare_for_handover(struct usb_hcd *hcd)
-{ }
-
-#endif	/* CONFIG_USB_PERSIST etc. */
-
 #ifdef	CONFIG_PM
 
 static int ohci_pci_suspend (struct usb_hcd *hcd, pm_message_t message)
@@ -312,13 +276,8 @@ static int ohci_pci_suspend (struct usb_
 
 static int ohci_pci_resume (struct usb_hcd *hcd)
 {
-	struct ohci_hcd	*ohci = hcd_to_ohci(hcd);
-
 	set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
-
-	/* FIXME: we should try to detect loss of VBUS power here */
-	prepare_for_handover(hcd);
-	ohci_writel(ohci, OHCI_INTR_MIE, &ohci->regs->intrenable);
+	ohci_finish_controller_resume(hcd);
 	return 0;
 }
 
--- a/drivers/usb/host/ohci-pxa27x.c
+++ b/drivers/usb/host/ohci-pxa27x.c
@@ -358,8 +358,7 @@ static int ohci_hcd_pxa27x_drv_resume(st
 		return status;
 
 	pdev->dev.power.power_state = PMSG_ON;
-	usb_hcd_resume_root_hub(hcd);
-
+	ohci_finish_controller_resume(hcd);
 	return 0;
 }
 #endif
--- a/drivers/usb/host/ohci-sm501.c
+++ b/drivers/usb/host/ohci-sm501.c
@@ -239,7 +239,7 @@ static int ohci_sm501_resume(struct plat
 
 	sm501_unit_power(dev->parent, SM501_GATE_USB_HOST, 1);
 	dev->power.power_state = PMSG_ON;
-	usb_hcd_resume_root_hub(platform_get_drvdata(pdev));
+	ohci_finish_controller_resume(hcd);
 	return 0;
 }
 #endif
--- a/drivers/usb/host/ohci-ssb.c
+++ b/drivers/usb/host/ohci-ssb.c
@@ -224,6 +224,7 @@ static int ssb_ohci_resume(struct ssb_de
 
 	ssb_device_enable(dev, ohcidev->enable_flags);
 
+	ohci_finish_controller_resume(hcd);
 	return 0;
 }
 

-- 
