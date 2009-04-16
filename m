Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbZDPCFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbZDPCFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 22:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbZDPCFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 22:05:10 -0400
Received: from exprod6og106.obsmtp.com ([64.18.1.191]:52353 "HELO
	exprod6og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752032AbZDPCFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 22:05:09 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] usb/host/ohci-hcd.c: fix sparse warnings
Date: Wed, 15 Apr 2009 22:04:17 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909015F8DFC@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] usb/host/ohci-hcd.c: fix sparse warnings
Thread-Index: Acm+N6ZNzC2QDe0/SdCNxDiqA1A1nA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Apr 2009 02:05:06.0878 (UTC) FILETIME=[C379ADE0:01C9BE37]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warnings in drivers/usb/host/ohci-hcd.c.

	warning: symbol 'temp' shadows an earlier one

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 25db704..7635acf 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -571,7 +571,7 @@ static int ohci_init (struct ohci_hcd *ohci)
  */
 static int ohci_run (struct ohci_hcd *ohci)
 {
-	u32			mask, temp;
+	u32			mask, val;
 	int			first = ohci->fminterval == 0;
 	struct usb_hcd		*hcd = ohci_to_hcd(ohci);
 
@@ -580,8 +580,8 @@ static int ohci_run (struct ohci_hcd *ohci)
 	/* boot firmware should have set this up (5.1.1.3.1) */
 	if (first) {
 
-		temp = ohci_readl (ohci, &ohci->regs->fminterval);
-		ohci->fminterval = temp & 0x3fff;
+		val = ohci_readl (ohci, &ohci->regs->fminterval);
+		ohci->fminterval = val & 0x3fff;
 		if (ohci->fminterval != FI)
 			ohci_dbg (ohci, "fminterval delta %d\n",
 				ohci->fminterval - FI);
@@ -600,25 +600,25 @@ static int ohci_run (struct ohci_hcd *ohci)
 
 	switch (ohci->hc_control & OHCI_CTRL_HCFS) {
 	case OHCI_USB_OPER:
-		temp = 0;
+		val = 0;
 		break;
 	case OHCI_USB_SUSPEND:
 	case OHCI_USB_RESUME:
 		ohci->hc_control &= OHCI_CTRL_RWC;
 		ohci->hc_control |= OHCI_USB_RESUME;
-		temp = 10 /* msec wait */;
+		val = 10 /* msec wait */;
 		break;
 	// case OHCI_USB_RESET:
 	default:
 		ohci->hc_control &= OHCI_CTRL_RWC;
 		ohci->hc_control |= OHCI_USB_RESET;
-		temp = 50 /* msec wait */;
+		val = 50 /* msec wait */;
 		break;
 	}
 	ohci_writel (ohci, ohci->hc_control, &ohci->regs->control);
 	// flush the writes
 	(void) ohci_readl (ohci, &ohci->regs->control);
-	msleep(temp);
+	msleep(val);
 
 	memset (ohci->hcca, 0, sizeof (struct ohci_hcca));
 
@@ -628,9 +628,9 @@ static int ohci_run (struct ohci_hcd *ohci)
 retry:
 	/* HC Reset requires max 10 us delay */
 	ohci_writel (ohci, OHCI_HCR,  &ohci->regs->cmdstatus);
-	temp = 30;	/* ... allow extra time */
+	val = 30;	/* ... allow extra time */
 	while ((ohci_readl (ohci, &ohci->regs->cmdstatus) & OHCI_HCR) !=
0) {
-		if (--temp == 0) {
+		if (--val == 0) {
 			spin_unlock_irq (&ohci->lock);
 			ohci_err (ohci, "USB HC reset timed out!\n");
 			return -1;
@@ -699,23 +699,23 @@ retry:
 	ohci_writel (ohci, mask, &ohci->regs->intrenable);
 
 	/* handle root hub init quirks ... */
-	temp = roothub_a (ohci);
-	temp &= ~(RH_A_PSM | RH_A_OCPM);
+	val = roothub_a (ohci);
+	val &= ~(RH_A_PSM | RH_A_OCPM);
 	if (ohci->flags & OHCI_QUIRK_SUPERIO) {
 		/* NSC 87560 and maybe others */
-		temp |= RH_A_NOCP;
-		temp &= ~(RH_A_POTPGT | RH_A_NPS);
-		ohci_writel (ohci, temp, &ohci->regs->roothub.a);
+		val |= RH_A_NOCP;
+		val &= ~(RH_A_POTPGT | RH_A_NPS);
+		ohci_writel (ohci, val, &ohci->regs->roothub.a);
 	} else if ((ohci->flags & OHCI_QUIRK_AMD756) ||
 			(ohci->flags & OHCI_QUIRK_HUB_POWER)) {
 		/* hub power always on; required for AMD-756 and some
 		 * Mac platforms.  ganged overcurrent reporting, if any.
 		 */
-		temp |= RH_A_NPS;
-		ohci_writel (ohci, temp, &ohci->regs->roothub.a);
+		val |= RH_A_NPS;
+		ohci_writel (ohci, val, &ohci->regs->roothub.a);
 	}
 	ohci_writel (ohci, RH_HS_LPSC, &ohci->regs->roothub.status);
-	ohci_writel (ohci, (temp & RH_A_NPS) ? 0 : RH_B_PPCM,
+	ohci_writel (ohci, (val & RH_A_NPS) ? 0 : RH_B_PPCM,
 						&ohci->regs->roothub.b);
 	// flush those writes
 	(void) ohci_readl (ohci, &ohci->regs->control);
@@ -724,7 +724,7 @@ retry:
 	spin_unlock_irq (&ohci->lock);
 
 	// POTPGT delay is bits 24-31, in 2 ms units.
-	mdelay ((temp >> 23) & 0x1fe);
+	mdelay ((val >> 23) & 0x1fe);
 	hcd->state = HC_STATE_RUNNING;
 
 	if (quirk_zfmicro(ohci)) { 
