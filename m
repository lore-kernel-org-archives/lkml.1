Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbYHEGWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbYHEGWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 02:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbYHEGU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 02:20:29 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:20297 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbYHEGU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 02:20:28 -0400
X-BigFish: VPS7(zzzz10dck10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K546XV-01-TAF-01
Subject: [PATCH] X86 Architecture: HPET Rework for SB700A12
From: crane cai <crane.cai@amd.com>
Reply-To: crane.cai@amd.com
To: mingo@elte.hu
CC: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: AMD
Date: Tue, 5 Aug 2008 14:20:10 +0800
Message-ID: <1217917210.20290.1.camel@crane-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 05 Aug 2008 06:20:17.0412 (UTC) FILETIME=[54574440:01C8F6C3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: HPET rework for SB700

SB700 supports the features to reduce EMI on system clocks. When this feature
is enabled in software, the HPET timer base frequency may change and its new
value needs to be reported to the OS or may need to be adjusted as it will 
differ from the default value reported by hardware power up value. This 
software routine accomplish this task to ensure that the system timer is 
adjusted accordingly by the OS to it accurate.

Signed-off-by: XiaoGang Zheng <gang.zheng@amd.com>
Signed-off-by: Crane Cai <crane.cai@amd.com>

----------------------------

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 4353cf5..74a3eb7 100644
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
+		hpet_rework = 1;
+		printk(KERN_INFO "SB700 rev 0x3a under detected!\n");
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
index ad2b15a..d940cca 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -23,6 +23,9 @@
  * HPET address is set in acpi/boot.c, when an ACPI entry exists
  */
 unsigned long hpet_address;
+
+int hpet_rework __initdata = 0;
+
 static void __iomem *hpet_virt_address;
 
 unsigned long hpet_readl(unsigned long a)
@@ -369,6 +372,12 @@ int __init hpet_enable(void)
 	 * Read the period and check for a sane value:
 	 */
 	hpet_period = hpet_readl(HPET_PERIOD);
+
+	if (hpet_rework) {
+		int timeout = 1000;
+		while (0xffffffff == hpet_readl(HPET_CFG) && timeout-- != 0)
+			;
+	}
 	if (hpet_period < HPET_MIN_PERIOD || hpet_period > HPET_MAX_PERIOD)
 		goto out_nohpet;
 
diff --git a/include/asm-x86/hpet.h b/include/asm-x86/hpet.h
index 82f1ac6..2536c21 100644
--- a/include/asm-x86/hpet.h
+++ b/include/asm-x86/hpet.h
@@ -55,6 +55,8 @@
  */
 #define HPET_MIN_PERIOD		100000UL
 
+extern int hpet_rework;
+
 /* hpet memory map physical address */
 extern unsigned long hpet_address;
 extern unsigned long force_hpet_address;


