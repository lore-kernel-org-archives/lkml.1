Return-Path: <linux-kernel-owner+w=401wt.eu-S1760210AbYEIJtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210AbYEIJtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 05:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758974AbYEIJte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 05:49:34 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:40044 "EHLO
	outbound3-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758146AbYEIJtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 05:49:32 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0K0LHYA-01-DPM-01
Date: Fri, 9 May 2008 11:49:11 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: enable hpet=force for AMD SB400
Message-ID: <20080509094911.GG5023@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 09 May 2008 09:49:07.0040 (UTC) FILETIME=[EC3AC600:01C8B1B9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: enable hpet=force for ATI SB400

Add quirk to allow forced usage of HPET on ATI SB400.
I stumbled over machines where HPET is enabled but not reported
by BIOS. This patch configures the HPET base address and makes
it known to the OS.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/quirks.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index d89a648..5fe6bd5 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -65,6 +65,7 @@ static enum {
 	ICH_FORCE_HPET_RESUME,
 	VT8237_FORCE_HPET_RESUME,
 	NVIDIA_FORCE_HPET_RESUME,
+	ATI_FORCE_HPET_RESUME,
 } force_hpet_resume_type;
 
 static void __iomem *rcba_base;
@@ -330,6 +331,31 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8235,
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8237,
 			 vt8237_force_enable_hpet);
 
+static void ati_force_hpet_resume(void)
+{
+	pci_write_config_dword(cached_dev, 0x14, 0xfed00000);
+	printk(KERN_DEBUG "Force enabled HPET at resume\n");
+}
+
+static void ati_force_enable_hpet(struct pci_dev *dev)
+{
+	u32 uninitialized_var(val);
+
+	if (!hpet_force_user || hpet_address || force_hpet_address)
+		return;
+
+	pci_write_config_dword(dev, 0x14, 0xfed00000);
+	pci_read_config_dword(dev, 0x14, &val);
+	force_hpet_address = val;
+	force_hpet_resume_type = ATI_FORCE_HPET_RESUME;
+	dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at 0x%lx\n",
+		   force_hpet_address);
+	cached_dev = dev;
+	return;
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS,
+			 ati_force_enable_hpet);
+
 /*
  * Undocumented chipset feature taken from LinuxBIOS.
  */
@@ -397,6 +423,9 @@ void force_hpet_resume(void)
 	case NVIDIA_FORCE_HPET_RESUME:
 		nvidia_force_hpet_resume();
 		return;
+	case ATI_FORCE_HPET_RESUME:
+		ati_force_hpet_resume();
+		return;
 	default:
 		break;
 	}
-- 
1.5.4.5



