Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbYIDOr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbYIDOr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 10:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYIDOrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 10:47:18 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:23917 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYIDOrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:47:17 -0400
X-BigFish: VPS3(z518kz4015M19c2kzz10d3izzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K6OEEB-02-M7W-01
Date: Thu, 4 Sep 2008 16:46:57 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Revert commit e8aa4667baf74dfd85fbaab86861465acb811085
Message-ID: <20080904144657.GC15987@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 04 Sep 2008 14:47:04.0497 (UTC) FILETIME=[18C4BA10:01C90E9D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit e8aa4667baf74dfd85fbaab86861465acb811085
 (x86: enable hpet=force for AMD SB400)

Since ATI/AMD decided not to support HPET on SB4xx it doesn't
make sense to enable this unsupported feature.
(I was not aware of this when submitting the quirk.)

If a system with SB4xx chipset provides an ACPI HPET table and does
not boot, "nohpet" should be used as kernel parameter.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/quirks.c |   34 ----------------------------------
 1 files changed, 0 insertions(+), 34 deletions(-)

Please apply for 2.6.27.


Thanks,

Andreas

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index d138588..9ed3a64 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -65,7 +65,6 @@ static enum {
 	ICH_FORCE_HPET_RESUME,
 	VT8237_FORCE_HPET_RESUME,
 	NVIDIA_FORCE_HPET_RESUME,
-	ATI_FORCE_HPET_RESUME,
 } force_hpet_resume_type;
 
 static void __iomem *rcba_base;
@@ -348,36 +347,6 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8235,
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8237,
 			 vt8237_force_enable_hpet);
 
-static void ati_force_hpet_resume(void)
-{
-	pci_write_config_dword(cached_dev, 0x14, 0xfed00000);
-	printk(KERN_DEBUG "Force enabled HPET at resume\n");
-}
-
-static void ati_force_enable_hpet(struct pci_dev *dev)
-{
-	u32 uninitialized_var(val);
-
-	if (hpet_address || force_hpet_address)
-		return;
-
-	if (!hpet_force_user) {
-		hpet_print_force_info();
-		return;
-	}
-
-	pci_write_config_dword(dev, 0x14, 0xfed00000);
-	pci_read_config_dword(dev, 0x14, &val);
-	force_hpet_address = val;
-	force_hpet_resume_type = ATI_FORCE_HPET_RESUME;
-	dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at 0x%lx\n",
-		   force_hpet_address);
-	cached_dev = dev;
-	return;
-}
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS,
-			 ati_force_enable_hpet);
-
 /*
  * Undocumented chipset feature taken from LinuxBIOS.
  */
@@ -450,9 +419,6 @@ void force_hpet_resume(void)
 	case NVIDIA_FORCE_HPET_RESUME:
 		nvidia_force_hpet_resume();
 		return;
-	case ATI_FORCE_HPET_RESUME:
-		ati_force_hpet_resume();
-		return;
 	default:
 		break;
 	}
-- 
1.6.0.1



