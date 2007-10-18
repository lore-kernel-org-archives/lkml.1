Return-Path: <linux-kernel-owner+w=401wt.eu-S1764971AbXJRN4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764971AbXJRN4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 09:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765257AbXJRNyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 09:54:53 -0400
Received: from mx1.minet.net ([157.159.40.25]:43558 "EHLO mx1.minet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764971AbXJRNyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 09:54:51 -0400
From: Florian Fainelli <florian.fainelli@telecomint.eu>
Date: Thu, 18 Oct 2007 15:51:39 +0200
Subject: [PATCH 4/4 resend] [x86] : Add the RDC machine specific reboot fixup
MIME-Version: 1.0
X-Length: 2409
To: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Message-Id: <200710181551.39694.florian.fainelli@telecomint.eu>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_rT2FHaJZkTZxfZv"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--Boundary-00=_rT2FHaJZkTZxfZv
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The RDC R-321x SoC needs a reboot fixup which
uses its internal hardware watchdog set to
reset the CPU on next tick.

Signed-off-by: Florian Fainelli <florian.fainelli@telecomint.eu>
---
 arch/x86/kernel/reboot_fixups_32.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)
---
diff --git a/arch/x86/kernel/reboot_fixups_32.c b/arch/x86/kernel/reboot_fixups_32.c
index 8b30b26..26e23fc 100644
--- a/arch/x86/kernel/reboot_fixups_32.c
+++ b/arch/x86/kernel/reboot_fixups_32.c
@@ -32,6 +32,19 @@ static void cs5536_warm_reset(struct pci_dev *dev)
 	udelay(50); /* shouldn't get here but be safe and spin a while */
 }
 
+static void rdc321x_reset(struct pci_dev *dev)
+{
+	unsigned i;
+	/* Voluntary reset the watchdog timer */
+	outl(0x80003840, 0xCF8);
+	/* Generate a CPU reset on next tick */
+	i = inl(0xCFC);
+	/* Use the minimum timer resolution */
+	i |= 0x1600;
+	outl(i, 0xCFC);
+	outb(1, 0x92);
+}
+
 struct device_fixup {
 	unsigned int vendor;
 	unsigned int device;
@@ -41,6 +54,7 @@ struct device_fixup {
 static struct device_fixup fixups_table[] = {
 { PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_LEGACY, cs5530a_warm_reset },
 { PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA, cs5536_warm_reset },
+{ PCI_VENDOR_ID_RDC, PCI_DEVICE_ID_RDC_R6030, rdc321x_reset },
 };
 
 /*

--Boundary-00=_rT2FHaJZkTZxfZv
Content-Type: text/plain;
  charset="utf-8";
  name="aa62d42093f0d41c12f8eb4dc07644fdd4f86637.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="aa62d42093f0d41c12f8eb4dc07644fdd4f86637.diff"

diff --git a/arch/x86/kernel/reboot_fixups_32.c b/arch/x86/kernel/reboot_fixups_32.c
index 8b30b26..26e23fc 100644
--- a/arch/x86/kernel/reboot_fixups_32.c
+++ b/arch/x86/kernel/reboot_fixups_32.c
@@ -32,6 +32,19 @@ static void cs5536_warm_reset(struct pci_dev *dev)
 	udelay(50); /* shouldn't get here but be safe and spin a while */
 }
 
+static void rdc321x_reset(struct pci_dev *dev)
+{
+	unsigned i;
+	/* Voluntary reset the watchdog timer */
+	outl(0x80003840, 0xCF8);
+	/* Generate a CPU reset on next tick */
+	i = inl(0xCFC);
+	/* Use the minimum timer resolution */
+	i |= 0x1600;
+	outl(i, 0xCFC);
+	outb(1, 0x92);
+}
+
 struct device_fixup {
 	unsigned int vendor;
 	unsigned int device;
@@ -41,6 +54,7 @@ struct device_fixup {
 static struct device_fixup fixups_table[] = {
 { PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_LEGACY, cs5530a_warm_reset },
 { PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA, cs5536_warm_reset },
+{ PCI_VENDOR_ID_RDC, PCI_DEVICE_ID_RDC_R6030, rdc321x_reset },
 };
 
 /*

--Boundary-00=_rT2FHaJZkTZxfZv--


