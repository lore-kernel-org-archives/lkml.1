Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbYDHQ13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbYDHQ13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYDHQ1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:27:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbYDHQ1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:27:03 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 01/28] x86: introduce pci-dma.c
Date: Tue,  8 Apr 2008 13:20:43 -0300
Message-Id: <12076716782131-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces pci-dma.c, a common file for pci dma
between i386 and x86_64. As a start, dma_set_mask() is the same
between architectures, and is placed there.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/Makefile     |    2 +-
 arch/x86/kernel/pci-dma.c    |   14 ++++++++++++++
 arch/x86/kernel/pci-dma_32.c |   12 ------------
 arch/x86/kernel/pci-dma_64.c |    9 ---------
 4 files changed, 15 insertions(+), 22 deletions(-)
 create mode 100644 arch/x86/kernel/pci-dma.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 53c8fa4..befe901 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -24,7 +24,7 @@ obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o setup64.o
 obj-y			+= pci-dma_$(BITS).o  bootflag.o e820_$(BITS).o
-obj-y			+= quirks.o i8237.o topology.o kdebugfs.o
+obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o
 obj-$(CONFIG_X86_64)	+= pci-nommu_64.o bugs_64.o
 obj-$(CONFIG_X86_32)	+= pci-base_32.o
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
new file mode 100644
index 0000000..f1c24d8
--- /dev/null
+++ b/arch/x86/kernel/pci-dma.c
@@ -0,0 +1,14 @@
+#include <linux/dma-mapping.h>
+
+int dma_set_mask(struct device *dev, u64 mask)
+{
+	if (!dev->dma_mask || !dma_supported(dev, mask))
+		return -EIO;
+
+	*dev->dma_mask = mask;
+
+	return 0;
+}
+EXPORT_SYMBOL(dma_set_mask);
+
+
diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
index be6b1f6..9e82976 100644
--- a/arch/x86/kernel/pci-dma_32.c
+++ b/arch/x86/kernel/pci-dma_32.c
@@ -182,18 +182,6 @@ dma_supported(struct device *dev, u64 mask)
 }
 EXPORT_SYMBOL(dma_supported);
 
-int
-dma_set_mask(struct device *dev, u64 mask)
-{
-	if (!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-
-	*dev->dma_mask = mask;
-
-	return 0;
-}
-EXPORT_SYMBOL(dma_set_mask);
-
 
 static __devinit void via_no_dac(struct pci_dev *dev)
 {
diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index f97a08d..e697b86 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -213,15 +213,6 @@ int dma_supported(struct device *dev, u64 mask)
 }
 EXPORT_SYMBOL(dma_supported);
 
-int dma_set_mask(struct device *dev, u64 mask)
-{
-	if (!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-	*dev->dma_mask = mask;
-	return 0;
-}
-EXPORT_SYMBOL(dma_set_mask);
-
 /*
  * See <Documentation/x86_64/boot-options.txt> for the iommu kernel parameter
  * documentation.
-- 
1.5.0.6

