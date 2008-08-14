Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbYHNDOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbYHNDOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 23:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbYHNDN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 23:13:58 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:9715 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYHNDN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 23:13:57 -0400
X-BigFish: VPS-2(zz936fQzz10dck10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K5KMAI-02-ZIQ-01
Subject: [PATCH] HPET: Workaround for a BIOS workaround on AMD SB700
	platform
From: crane cai <crane.cai@amd.com>
Reply-To: crane.cai@amd.com
To: vojtech@suse.cz
CC: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: AMD
Date: Thu, 14 Aug 2008 11:13:36 +0800
Message-ID: <1218683616.20466.13.camel@crane-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 14 Aug 2008 03:13:38.0437 (UTC) FILETIME=[BEF30B50:01C8FDBB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9bd2f534f986768f1944e626e37af1c323e47dbb Mon Sep 17 00:00:00 2001
From: Crane Cai <crane.cai@amd.com>
Date: Thu, 14 Aug 2008 10:31:01 +0800
Subject: [PATCH] HPET: Workaround for a BIOS workaround on AMD SB700 platform

On the AMD SB700 southbridge, between the revisions 0x30 to 0x3a, when its
spread-spectrum frequency modulation feature is enabled, the base frequency
used by the HPET will not be running on average slower than nominal 14.318
MHz.
Since there is no provision in the OS for HPET to work with properly with
slower frequency, the BIOS on this platform uses SMM to emulate accesses to
the HPET config register to supply a corrected base frequency to compensate
for it.
However, due to the implementation of the SMM BIOS code, there is a time
window after the first access to the HPET, which triggers initialization of
the SMM code, in which the HPET isn't available. Thus it's necessary to wait
until the HPET emulation is ready, and this is what the patch does on the
affected machines.

Signed-off-by: XiaoGang Zheng <gang.zheng@amd.com>
Signed-off-by: Crane Cai <crane.cai@amd.com>
---
 arch/x86/kernel/early-quirks.c |   13 +++++++++++++
 arch/x86/kernel/hpet.c         |   24 ++++++++++++++++++++++++
 include/asm-x86/hpet.h         |    2 ++
 3 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 4353cf5..5f6f543 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -17,6 +17,7 @@
 #include <asm/io_apic.h>
 #include <asm/apic.h>
 #include <asm/iommu.h>
+#include <asm/hpet.h>
 
 static void __init fix_hypertransport_config(int num, int slot, int func)
 {
@@ -95,6 +96,16 @@ static void __init nvidia_bugs(int num, int slot, int func)
 
 }
 
+static void __init amd_sb700_hpet(int num, int slot, int func)
+{
+	int rev;
+	rev = read_pci_config_byte(num, slot, func, 0x08);
+	if (rev <= 0x3a && rev >= 0x30) {
+		sb700_hpet_workaround = 1;
+		printk(KERN_INFO "SB700 rev 0x3a or lower detected!\n");
+	}
+}
+
 #define QFLAG_APPLY_ONCE 	0x1
 #define QFLAG_APPLIED		0x2
 #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
@@ -114,6 +125,8 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, via_bugs },
 	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB,
 	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, fix_hypertransport_config },
+	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
+	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, amd_sb700_hpet },
 	{}
 };
 
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ad2b15a..3d7f71d 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -23,6 +23,24 @@
  * HPET address is set in acpi/boot.c, when an ACPI entry exists
  */
 unsigned long hpet_address;
+
+/*
+ * On the AMD SB700 southbridge, between the revisions 0x30 to 0x3a, when its
+ * spread-spectrum frequency modulation feature is enabled, the base frequency
+ * used by the HPET will not be running on average slower than nominal 14.318
+ * MHz.
+ * Since there is no provision in the OS for HPET to work with properly with
+ * slower frequency, the BIOS on this platform uses SMM to emulate accesses to
+ * the HPET config register to supply a corrected base frequency to compensate
+ * for it.
+ * However, due to the implementation of the SMM BIOS code, there is a time
+ * window after the first access to the HPET, which triggers initialization of
+ * the SMM code, in which the HPET isn't available. Thus it's necessary to wait
+ * until the HPET emulation is ready, and this is what the patch does on the
+ * affected machines.
+ */
+int sb700_hpet_workaround __initdata = 0;
+
 static void __iomem *hpet_virt_address;
 
 unsigned long hpet_readl(unsigned long a)
@@ -369,6 +387,12 @@ int __init hpet_enable(void)
 	 * Read the period and check for a sane value:
 	 */
 	hpet_period = hpet_readl(HPET_PERIOD);
+
+	if (sb700_hpet_workaround) {
+		int timeout = 1000;
+		while (0xffffffff == hpet_readl(HPET_CFG) && timeout-- != 0)
+			;
+	}
 	if (hpet_period < HPET_MIN_PERIOD || hpet_period > HPET_MAX_PERIOD)
 		goto out_nohpet;
 
diff --git a/include/asm-x86/hpet.h b/include/asm-x86/hpet.h
index 82f1ac6..8f9a4e2 100644
--- a/include/asm-x86/hpet.h
+++ b/include/asm-x86/hpet.h
@@ -55,6 +55,8 @@
  */
 #define HPET_MIN_PERIOD		100000UL
 
+extern int sb700_hpet_workaround;
+
 /* hpet memory map physical address */
 extern unsigned long hpet_address;
 extern unsigned long force_hpet_address;
-- 
1.5.4.4



