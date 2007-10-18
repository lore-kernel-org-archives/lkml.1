Return-Path: <linux-kernel-owner+w=401wt.eu-S1765666AbXJROCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765666AbXJROCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 10:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757757AbXJROCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 10:02:12 -0400
Received: from smtp1.int-evry.fr ([157.159.10.44]:57659 "EHLO
	smtp1.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbXJROCK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:02:10 -0400
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4 resend] [x86] : Add the RDC machine specific reboot fixup
Date: Thu, 18 Oct 2007 15:59:00 +0200
User-Agent: KMail/1.9.7
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
References: <200710181551.39694.florian.fainelli@telecomint.eu>
In-Reply-To: <200710181551.39694.florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710181559.00957.florian.fainelli@telecomint.eu>
X-int-MailScanner-Information: Please contact the ISP for more information
X-int-MailScanner: Found to be clean
X-int-MailScanner-SpamCheck: 
X-int-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This one also had the attachment, sorry for the noise.

The RDC R-321x SoC needs a reboot fixup which
uses its internal hardware watchdog set to
reset the CPU on next tick.

Signed-off-by: Florian Fainelli <florian.fainelli@telecomint.eu>
---
 arch/x86/kernel/reboot_fixups_32.c |   14 ++++++++++++++
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
