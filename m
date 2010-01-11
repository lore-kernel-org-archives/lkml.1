Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513Ab0AKPk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab0AKPk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 10:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072Ab0AKPkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 10:40:25 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:41714 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab0AKPkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 10:40:24 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #14406] uvcvideo stopped work on Toshiba
Date: Mon, 11 Jan 2010 16:30:14 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "okias" <d.okias@gmail.com>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera> <CXIfLt-ygXM.A.ubE.NjlSLB@chimera>
In-Reply-To: <CXIfLt-ygXM.A.ubE.NjlSLB@chimera>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_GQ0SLLCQbMLYt83"
Message-Id: <201001111630.14289.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_GQ0SLLCQbMLYt83
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

Am Sonntag, 10. Januar 2010 23:56:10 schrieb Rafael J. Wysocki:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14406
> Subject		: uvcvideo stopped work on Toshiba
> Submitter	: okias <d.okias@gmail.com>
> Date		: 2009-10-14 19:08 (89 days old)

Have you tested with a kernel that has the attached patch?
If it doesn't help, the problem will have to be bisected.

	Regards
		Oliver

--Boundary-00=_GQ0SLLCQbMLYt83
Content-Type: text/x-patch;
  charset="UTF-8";
  name="ehci_periodic_breakage.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ehci_periodic_breakage.diff"

commit c222ad7196f0baa2b7341bfaf8c2821aaa089c3a
Author: Oliver Neukum <oliver@neukum.org>
Date:   Fri Nov 27 15:08:08 2009 +0100

    usb: add a work around for a quirk with the periodic schedule
    
    a quirky chipset needs periodic schedules to run for a minimum
    time before they can be disabled again. This enforces the requirement
    with a time stamp and a calculated delay

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 9835e07..f5f5601 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -28,6 +28,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/timer.h>
+#include <linux/ktime.h>
 #include <linux/list.h>
 #include <linux/interrupt.h>
 #include <linux/usb.h>
@@ -676,6 +677,7 @@ static int ehci_run (struct usb_hcd *hcd)
 	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
 	msleep(5);
 	up_write(&ehci_cf_port_reset_rwsem);
+	ehci->last_periodic_enable = ktime_get_real();
 
 	temp = HC_VERSION(ehci_readl(ehci, &ehci->caps->hc_capbase));
 	ehci_info (ehci,
diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 378861b..ead5f4f 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -111,6 +111,10 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
 	switch (pdev->vendor) {
 	case PCI_VENDOR_ID_INTEL:
 		ehci->need_io_watchdog = 0;
+		if (pdev->device == 0x27cc) {
+			ehci->broken_periodic = 1;
+			ehci_info(ehci, "using broken periodic workaround\n");
+		}
 		break;
 	case PCI_VENDOR_ID_TDI:
 		if (pdev->device == PCI_DEVICE_ID_TDI_EHCI) {
diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index b25cdea..5b68a34 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -475,6 +475,8 @@ static int enable_periodic (struct ehci_hcd *ehci)
 	/* make sure ehci_work scans these */
 	ehci->next_uframe = ehci_readl(ehci, &ehci->regs->frame_index)
 		% (ehci->periodic_size << 3);
+	if (unlikely(ehci->broken_periodic))
+		ehci->last_periodic_enable = ktime_get_real();
 	return 0;
 }
 
@@ -486,6 +488,16 @@ static int disable_periodic (struct ehci_hcd *ehci)
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
diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index 064e768..2d85e21 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -118,6 +118,7 @@ struct ehci_hcd {			/* one per controller */
 	unsigned		stamp;
 	unsigned		random_frame;
 	unsigned long		next_statechange;
+	ktime_t			last_periodic_enable;
 	u32			command;
 
 	/* SILICON QUIRKS */
@@ -127,6 +128,7 @@ struct ehci_hcd {			/* one per controller */
 	unsigned		big_endian_desc:1;
 	unsigned		has_amcc_usb23:1;
 	unsigned		need_io_watchdog:1;
+	unsigned		broken_periodic:1;
 
 	/* required for usb32 quirk */
 	#define OHCI_CTRL_HCFS          (3 << 6)

--Boundary-00=_GQ0SLLCQbMLYt83--
