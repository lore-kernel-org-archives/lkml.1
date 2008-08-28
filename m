Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbYH1Wfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbYH1Wfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 18:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756201AbYH1Wfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 18:35:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:51028 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200AbYH1Wfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 18:35:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,289,1217833200"; 
   d="scan'208";a="330024423"
From: Seth Heasley <seth.heasley@intel.com>
To: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org, khali@linux-fr.org
Subject: [PATCH 2.6.27-rc4][RESEND] irq: irq and pci_ids patch for Intel Ibex Peak DeviceIDs
Date: Thu, 28 Aug 2008 15:40:59 -0700
User-Agent: KMail/1.9.1
Cc: seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808281540.59657.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the Intel Ibex Peak (PCH) LPC and SMBus Controller DeviceIDs.

The LPC Controller ID is set by Firmware within the range of 0x3b00-3b1f.  This range is included in pci_ids.h using min and max values, and irq.c now has code to handle the range (in lieu of 32 additions to a SWITCH statement).

The SMBus Controller ID is a fixed-value and will not change.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6/include/linux/pci_ids.h.orig	2008-08-27 11:54:07.000000000 -0700
+++ linux-2.6/include/linux/pci_ids.h	2008-08-28 14:59:35.000000000 -0700
@@ -2428,9 +2428,9 @@
 #define PCI_DEVICE_ID_INTEL_ICH10_3	0x3a1a
 #define PCI_DEVICE_ID_INTEL_ICH10_4	0x3a30
 #define PCI_DEVICE_ID_INTEL_ICH10_5	0x3a60
-#define PCI_DEVICE_ID_INTEL_PCH_0	0x3b10
-#define PCI_DEVICE_ID_INTEL_PCH_1	0x3b11
-#define PCI_DEVICE_ID_INTEL_PCH_2	0x3b30
+#define PCI_DEVICE_ID_INTEL_PCH_LPC_MIN	0x3b00
+#define PCI_DEVICE_ID_INTEL_PCH_LPC_MAX	0x3b1f
+#define PCI_DEVICE_ID_INTEL_PCH_SMBUS	0x3b30
 #define PCI_DEVICE_ID_INTEL_IOAT_SNB	0x402f
 #define PCI_DEVICE_ID_INTEL_5100_16	0x65f0
 #define PCI_DEVICE_ID_INTEL_5100_21	0x65f5
--- linux-2.6/arch/x86/pci/irq.c.orig	2008-08-27 11:53:13.000000000 -0700
+++ linux-2.6/arch/x86/pci/irq.c	2008-08-28 15:12:04.000000000 -0700
@@ -590,13 +590,20 @@
 	case PCI_DEVICE_ID_INTEL_ICH10_1:
 	case PCI_DEVICE_ID_INTEL_ICH10_2:
 	case PCI_DEVICE_ID_INTEL_ICH10_3:
-	case PCI_DEVICE_ID_INTEL_PCH_0:
-	case PCI_DEVICE_ID_INTEL_PCH_1:
 		r->name = "PIIX/ICH";
 		r->get = pirq_piix_get;
 		r->set = pirq_piix_set;
 		return 1;
 	}
+
+	if ((device >= PCI_DEVICE_ID_INTEL_PCH_LPC_MIN) && 
+		(device <= PCI_DEVICE_ID_INTEL_PCH_LPC_MAX)) {
+		r->name = "PIIX/ICH";
+		r->get = pirq_piix_get;
+		r->set = pirq_piix_set;
+		return 1;
+	}
+
 	return 0;
 }
 
