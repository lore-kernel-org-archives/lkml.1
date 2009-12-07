Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbZLGAVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbZLGAVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758540AbZLGAVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:21:14 -0500
Received: from kroah.org ([198.145.64.141]:34671 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932825AbZLGANq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:46 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:56 2009
Message-Id: <20091207000656.725986786@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Neukum <oliver@neukum.org>
Subject: [090/119] USB: work around for EHCI with quirky periodic schedules
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=usb-work-around-for-ehci-with-quirky-periodic-schedules.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Oliver Neukum <oliver@neukum.org>

commit ee4ecb8ac63a5792bec448037d4b82ec4144f94b upstream.

a quirky chipset needs periodic schedules to run for a minimum
time before they can be disabled again. This enforces the requirement
with a time stamp and a calculated delay

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-hcd.c   |    2 ++
 drivers/usb/host/ehci-pci.c   |    6 ++++++
 drivers/usb/host/ehci-sched.c |   12 ++++++++++++
 drivers/usb/host/ehci.h       |    2 ++
 4 files changed, 22 insertions(+)

--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -118,6 +118,7 @@ struct ehci_hcd {			/* one per controlle
 	unsigned		stamp;
 	unsigned		random_frame;
 	unsigned long		next_statechange;
+	ktime_t			last_periodic_enable;
 	u32			command;
 
 	/* SILICON QUIRKS */
@@ -126,6 +127,7 @@ struct ehci_hcd {			/* one per controlle
 	unsigned		big_endian_mmio:1;
 	unsigned		big_endian_desc:1;
 	unsigned		has_amcc_usb23:1;
+	unsigned		broken_periodic:1;
 
 	/* required for usb32 quirk */
 	#define OHCI_CTRL_HCFS          (3 << 6)
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -28,6 +28,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/timer.h>
+#include <linux/ktime.h>
 #include <linux/list.h>
 #include <linux/interrupt.h>
 #include <linux/reboot.h>
@@ -655,6 +656,7 @@ static int ehci_run (struct usb_hcd *hcd
 	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
 	msleep(5);
 	up_write(&ehci_cf_port_reset_rwsem);
+	ehci->last_periodic_enable = ktime_get_real();
 
 	temp = HC_VERSION(ehci_readl(ehci, &ehci->caps->hc_capbase));
 	ehci_info (ehci,
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -72,6 +72,12 @@ static int ehci_pci_setup(struct usb_hcd
 	int			retval;
 
 	switch (pdev->vendor) {
+	case PCI_VENDOR_ID_INTEL:
+		if (pdev->device == 0x27cc) {
+			ehci->broken_periodic = 1;
+			ehci_info(ehci, "using broken periodic workaround\n");
+		}
+		break;
 	case PCI_VENDOR_ID_TOSHIBA_2:
 		/* celleb's companion chip */
 		if (pdev->device == 0x01b5) {
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -456,6 +456,8 @@ static int enable_periodic (struct ehci_
 	/* make sure ehci_work scans these */
 	ehci->next_uframe = ehci_readl(ehci, &ehci->regs->frame_index)
 		% (ehci->periodic_size << 3);
+	if (unlikely(ehci->broken_periodic))
+		ehci->last_periodic_enable = ktime_get_real();
 	return 0;
 }
 
@@ -467,6 +469,16 @@ static int disable_periodic (struct ehci
 	if (--ehci->periodic_sched)
 		return 0;
 
+	if (unlikely(ehci->broken_periodic)) {
+		/* delay experimentally determined */
+		ktime_t safe = ktime_add_us(ehci->last_periodic_enable, 1000);
+		ktime_t now = ktime_get_real();
+		s64 delay = ktime_us_delta(safe, now);
+
+		if (unlikely(delay > 0))
+			udelay(delay);
+	}
+
 	/* did setting PSE not take effect yet?
 	 * takes effect only at frame boundaries...
 	 */


