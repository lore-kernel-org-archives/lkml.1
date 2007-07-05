Return-Path: <linux-kernel-owner+w=401wt.eu-S1761247AbXGETzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761247AbXGETzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 15:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758902AbXGETzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 15:55:05 -0400
Received: from mail.queued.net ([207.210.101.209]:1172 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758230AbXGETzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 15:55:04 -0400
X-Greylist: delayed 1180 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jul 2007 15:55:04 EDT
Date: Thu, 5 Jul 2007 15:36:55 -0400
From: Andres Salomon <dilinger@queued.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jordan Crouse <jordan.crouse@amd.com>, info-linux@geode.amd.com
Subject: [PATCH] GEODE: reboot fixup for geode machines with CS5536 boards
Message-Id: <20070705153655.f509eb76.dilinger@queued.net>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Writing to MSR 0x51400017 forces a hard reset on CS5536-based machines,
this has the reboot fixup do just that if such a board is detected.

Acked-by: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 arch/i386/Kconfig                |    4 ++--
 arch/i386/kernel/reboot_fixups.c |   13 +++++++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index 7be62ca..f6f6e4b 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -441,8 +441,8 @@ config X86_REBOOTFIXUPS
 	  this config is intended, is when reboot ends with a stalled/hung
 	  system.
 
-	  Currently, the only fixup is for the Geode GX1/CS5530A/TROM2.1.
-	  combination.
+	  Currently, the only fixup is for the Geode machines using
+	  CS5530A and CS5536 chipsets.
 
 	  Say Y if you want to enable the fixup. Currently, it's safe to
 	  enable this option even if you don't need it.
diff --git a/arch/i386/kernel/reboot_fixups.c b/arch/i386/kernel/reboot_fixups.c
index 2d78d91..03e1cce 100644
--- a/arch/i386/kernel/reboot_fixups.c
+++ b/arch/i386/kernel/reboot_fixups.c
@@ -5,12 +5,14 @@
  *
  * List of supported fixups:
  * geode-gx1/cs5530a - Jaya Kumar <jayalk@intworks.biz>
+ * geode-gx/lx/cs5536 - Andres Salomon <dilinger@debian.org>
  *
  */
 
 #include <asm/delay.h>
 #include <linux/pci.h>
 #include <asm/reboot_fixups.h>
+#include <asm/msr.h>
 
 static void cs5530a_warm_reset(struct pci_dev *dev)
 {
@@ -21,6 +23,16 @@ static void cs5530a_warm_reset(struct pci_dev *dev)
 	return;
 }
 
+static void cs5536_warm_reset(struct pci_dev *dev)
+{
+	/*
+	 * 6.6.2.12 Soft Reset (DIVIL_SOFT_RESET)
+	 * writing 1 to the LSB of this MSR causes a hard reset.
+	 */
+	wrmsrl(0x51400017, 1ULL);
+	udelay(50); /* shouldn't get here but be safe and spin a while */
+}
+
 struct device_fixup {
 	unsigned int vendor;
 	unsigned int device;
@@ -29,6 +41,7 @@ struct device_fixup {
 
 static struct device_fixup fixups_table[] = {
 { PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_LEGACY, cs5530a_warm_reset },
+{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA, cs5536_warm_reset },
 };
 
 /*
-- 
1.5.2.2
