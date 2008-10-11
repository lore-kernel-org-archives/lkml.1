Return-Path: <linux-kernel-owner+w=401wt.eu-S1761742AbYJKGwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761742AbYJKGwH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbYJKGjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:39:14 -0400
Received: from vms172069pub.verizon.net ([206.46.172.69]:32774 "EHLO
	vms172069pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYJKGhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:16 -0400
Date: Sat, 11 Oct 2008 02:36:13 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 53/85] i7300_idle driver v1.55
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Andy Henroid <andrew.d.henroid@intel.com>,
       Len Brown <len.brown@intel.com>
Message-id: <e8b529091b2ab65f5a4783e292c2b472e309116e.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

The Intel 7300 Memory Controller supports dynamic throttling of memory which can
be used to save power when system is idle. This driver does the memory
throttling when all CPUs are idle on such a system.

Refer to "Intel 7300 Memory Controller Hub (MCH)" datasheet
for the config space description.

Signed-off-by: Andy Henroid <andrew.d.henroid@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 MAINTAINERS                  |    6 ++++++
 arch/x86/Kconfig             |    2 ++
 arch/x86/kernel/process_64.c |    7 +++++++
 drivers/Makefile             |    1 +
 drivers/dma/ioat_dma.c       |    3 +++
 include/asm-x86/idle.h       |    1 +
 include/linux/pci_ids.h      |    1 +
 7 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8dae455..43f71b0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2078,6 +2078,12 @@ L:	linux-ide@vger.kernel.org
 L:	linux-scsi@vger.kernel.org
 S:	Orphan
 
+IDLE-I7300
+P:	Andy Henroid
+M:	andrew.d.henroid@intel.com
+L:	linux-pm@lists.linux-foundation.org
+S:	Supported
+
 IEEE 1394 SUBSYSTEM (drivers/ieee1394)
 P:	Ben Collins
 M:	ben.collins@ubuntu.com
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ed92864..19cdfe1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1536,6 +1536,8 @@ source "arch/x86/kernel/cpu/cpufreq/Kconfig"
 
 source "drivers/cpuidle/Kconfig"
 
+source "drivers/idle/Kconfig"
+
 endmenu
 
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index e12e0e4..3e3d503 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -62,6 +62,13 @@ void idle_notifier_register(struct notifier_block *n)
 {
 	atomic_notifier_chain_register(&idle_notifier, n);
 }
+EXPORT_SYMBOL_GPL(idle_notifier_register);
+
+void idle_notifier_unregister(struct notifier_block *n)
+{
+	atomic_notifier_chain_unregister(&idle_notifier, n);
+}
+EXPORT_SYMBOL_GPL(idle_notifier_unregister);
 
 void enter_idle(void)
 {
diff --git a/drivers/Makefile b/drivers/Makefile
index 2735bde..f443a8a 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -82,6 +82,7 @@ obj-$(CONFIG_EISA)		+= eisa/
 obj-y				+= lguest/
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
 obj-$(CONFIG_CPU_IDLE)		+= cpuidle/
+obj-y				+= idle/
 obj-$(CONFIG_MMC)		+= mmc/
 obj-$(CONFIG_MEMSTICK)		+= memstick/
 obj-$(CONFIG_NEW_LEDS)		+= leds/
diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index bc8c6e3..f8396ca 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -171,6 +171,9 @@ static int ioat_dma_enumerate_channels(struct ioatdma_device *device)
 	xfercap_scale = readb(device->reg_base + IOAT_XFERCAP_OFFSET);
 	xfercap = (xfercap_scale == 0 ? -1 : (1UL << xfercap_scale));
 
+#if CONFIG_I7300_IDLE_IOAT_CHANNEL
+	device->common.chancnt--;
+#endif
 	for (i = 0; i < device->common.chancnt; i++) {
 		ioat_chan = kzalloc(sizeof(*ioat_chan), GFP_KERNEL);
 		if (!ioat_chan) {
diff --git a/include/asm-x86/idle.h b/include/asm-x86/idle.h
index cbb6491..54ce018 100644
--- a/include/asm-x86/idle.h
+++ b/include/asm-x86/idle.h
@@ -6,6 +6,7 @@
 
 struct notifier_block;
 void idle_notifier_register(struct notifier_block *n);
+void idle_notifier_unregister(struct notifier_block *n);
 
 void enter_idle(void);
 void exit_idle(void);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f1624b3..efb786d 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2422,6 +2422,7 @@
 #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
 #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
 #define PCI_DEVICE_ID_INTEL_IOAT_CNB	0x360b
+#define PCI_DEVICE_ID_INTEL_FBD_CNB	0x360c
 #define PCI_DEVICE_ID_INTEL_ICH10_0	0x3a14
 #define PCI_DEVICE_ID_INTEL_ICH10_1	0x3a16
 #define PCI_DEVICE_ID_INTEL_ICH10_2	0x3a18
-- 
1.5.5.1

