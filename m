Return-Path: <linux-kernel-owner+w=401wt.eu-S1758809AbYGBVTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbYGBVTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756341AbYGBVSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:18:18 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:5578 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772AbYGBVSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:18:17 -0400
X-BigFish: VPS27(zz225amzz10d3izzz32i87il65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3EDTW-02-CU0-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 01/11] x86/pci: Makefile merge: Removing Makefile_*
Date: Wed, 2 Jul 2008 22:50:19 +0200
Message-ID: <1215031829-29124-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
References: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 02 Jul 2008 21:17:55.0943 (UTC) FILETIME=[187B6770:01C8DC89]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional nor ordering changes here.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/Makefile    |   47 ++++++++++++++++++++++++++++++++++++++++++++-
 arch/x86/pci/Makefile_32 |   25 ------------------------
 arch/x86/pci/Makefile_64 |   17 ----------------
 3 files changed, 45 insertions(+), 44 deletions(-)
 delete mode 100644 arch/x86/pci/Makefile_32
 delete mode 100644 arch/x86/pci/Makefile_64

diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index c5c8e48..8d1648d 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -1,5 +1,48 @@
 ifeq ($(CONFIG_X86_32),y)
-include ${srctree}/arch/x86/pci/Makefile_32
+
+obj-y				:= i386.o init.o
+
+obj-$(CONFIG_PCI_BIOS)		+= pcbios.o
+obj-$(CONFIG_PCI_MMCONFIG)	+= mmconfig_32.o direct.o mmconfig-shared.o
+obj-$(CONFIG_PCI_DIRECT)	+= direct.o
+obj-$(CONFIG_PCI_OLPC)		+= olpc.o
+
+pci-y				:= fixup.o
+
+# Do not change the ordering here. There is a nasty init function
+# ordering dependency which breaks when you move acpi.o below
+# legacy/irq.o
+pci-$(CONFIG_ACPI)		+= acpi.o
+pci-y				+= legacy.o irq.o
+
+# Careful: VISWS and NUMAQ overrule the pci-y above. The colons are
+# therefor correct. This needs a proper fix by distangling the code.
+pci-$(CONFIG_X86_VISWS)		:= visws.o fixup.o
+pci-$(CONFIG_X86_NUMAQ)		:= numa.o irq.o
+
+# Necessary for NUMAQ as well
+pci-$(CONFIG_NUMA)		+= mp_bus_to_node.o
+
+obj-y				+= $(pci-y) common.o early.o
+obj-y				+= amd_bus.o
+
 else
-include ${srctree}/arch/x86/pci/Makefile_64
+
+#
+# Makefile for X86_64 specific PCI routines
+#
+# Reuse the i386 PCI subsystem
+#
+EXTRA_CFLAGS += -Iarch/x86/pci
+
+obj-y		:= i386.o
+obj-$(CONFIG_PCI_DIRECT)+= direct.o
+obj-y		+= fixup.o init.o
+obj-$(CONFIG_ACPI)	+= acpi.o
+obj-y			+= legacy.o irq.o common.o early.o
+# mmconfig has a 64bit special
+obj-$(CONFIG_PCI_MMCONFIG) += mmconfig_64.o direct.o mmconfig-shared.o
+
+obj-y		+= amd_bus.o
+
 endif
diff --git a/arch/x86/pci/Makefile_32 b/arch/x86/pci/Makefile_32
deleted file mode 100644
index f647e7e..0000000
--- a/arch/x86/pci/Makefile_32
+++ /dev/null
@@ -1,25 +0,0 @@
-obj-y				:= i386.o init.o
-
-obj-$(CONFIG_PCI_BIOS)		+= pcbios.o
-obj-$(CONFIG_PCI_MMCONFIG)	+= mmconfig_32.o direct.o mmconfig-shared.o
-obj-$(CONFIG_PCI_DIRECT)	+= direct.o
-obj-$(CONFIG_PCI_OLPC)		+= olpc.o
-
-pci-y				:= fixup.o
-
-# Do not change the ordering here. There is a nasty init function
-# ordering dependency which breaks when you move acpi.o below
-# legacy/irq.o
-pci-$(CONFIG_ACPI)		+= acpi.o
-pci-y				+= legacy.o irq.o
-
-# Careful: VISWS and NUMAQ overrule the pci-y above. The colons are
-# therefor correct. This needs a proper fix by distangling the code.
-pci-$(CONFIG_X86_VISWS)		:= visws.o fixup.o
-pci-$(CONFIG_X86_NUMAQ)		:= numa.o irq.o
-
-# Necessary for NUMAQ as well
-pci-$(CONFIG_NUMA)		+= mp_bus_to_node.o
-
-obj-y				+= $(pci-y) common.o early.o
-obj-y				+= amd_bus.o
diff --git a/arch/x86/pci/Makefile_64 b/arch/x86/pci/Makefile_64
deleted file mode 100644
index fd47068..0000000
--- a/arch/x86/pci/Makefile_64
+++ /dev/null
@@ -1,17 +0,0 @@
-#
-# Makefile for X86_64 specific PCI routines
-#
-# Reuse the i386 PCI subsystem
-#
-EXTRA_CFLAGS += -Iarch/x86/pci
-
-obj-y		:= i386.o
-obj-$(CONFIG_PCI_DIRECT)+= direct.o
-obj-y		+= fixup.o init.o
-obj-$(CONFIG_ACPI)	+= acpi.o
-obj-y			+= legacy.o irq.o common.o early.o
-# mmconfig has a 64bit special
-obj-$(CONFIG_PCI_MMCONFIG) += mmconfig_64.o direct.o mmconfig-shared.o
-
-obj-y		+= amd_bus.o
-
-- 
1.5.5.4


