Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbYEAERL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbYEAERL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 00:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbYEAEQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 00:16:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:40598 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbYEAEQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 00:16:58 -0400
Date: Wed, 30 Apr 2008 23:12:17 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: linuxppc-dev@ozlabs.org
cc: Andrew Morton <akpm@osdl.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       htejun@gmail.com, Jeff Garzik <jeff@garzik.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Emilian.Medve@Freescale.com
Subject: [PATCH v5] [POWERPC] devres: Add devm_ioremap_prot()
Message-ID: <Pine.LNX.4.64.0804302310300.19424@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emil Medve <Emilian.Medve@Freescale.com>

We provide an ioremap_flags so provide a corresponding devm_ioremap_prot.
The slight name difference is at Ben Herrenschmidt request as he plans
on changing ioremap_flags to ioremap_prot in the future.

Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Acked-by: Tejun Heo <htejun@gmail.com>
---

v4 was labeled as v3.  this is fresh version against a recent linus tree
so it applies cleanly

 arch/powerpc/lib/Makefile |    1 +
 arch/powerpc/lib/devres.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/asm-powerpc/io.h  |    8 +++++++-
 include/linux/io.h        |    1 +
 lib/devres.c              |    2 +-
 5 files changed, 52 insertions(+), 2 deletions(-)
 create mode 100644 arch/powerpc/lib/devres.c

diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 4bb023f..f1d2cdc 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -23,3 +23,4 @@ obj-$(CONFIG_SMP)	+= locks.o
 endif

 obj-$(CONFIG_PPC_LIB_RHEAP) += rheap.o
+obj-$(CONFIG_HAS_IOMEM)	+= devres.o
diff --git a/arch/powerpc/lib/devres.c b/arch/powerpc/lib/devres.c
new file mode 100644
index 0000000..292115d
--- /dev/null
+++ b/arch/powerpc/lib/devres.c
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) 2008 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/device.h>	/* devres_*(), devm_ioremap_release() */
+#include <linux/io.h>		/* ioremap_flags() */
+#include <linux/module.h>	/* EXPORT_SYMBOL() */
+
+/**
+ * devm_ioremap_prot - Managed ioremap_flags()
+ * @dev: Generic device to remap IO address for
+ * @offset: BUS offset to map
+ * @size: Size of map
+ * @flags: Page flags
+ *
+ * Managed ioremap_prot().  Map is automatically unmapped on driver
+ * detach.
+ */
+void __iomem *devm_ioremap_prot(struct device *dev, resource_size_t offset,
+				 size_t size, unsigned long flags)
+{
+	void __iomem **ptr, *addr;
+
+	ptr = devres_alloc(devm_ioremap_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	addr = ioremap_flags(offset, size, flags);
+	if (addr) {
+		*ptr = addr;
+		devres_add(dev, ptr);
+	} else
+		devres_free(ptr);
+
+	return addr;
+}
+EXPORT_SYMBOL(devm_ioremap_prot);
diff --git a/include/asm-powerpc/io.h b/include/asm-powerpc/io.h
index afae069..e0062d7 100644
--- a/include/asm-powerpc/io.h
+++ b/include/asm-powerpc/io.h
@@ -2,7 +2,7 @@
 #define _ASM_POWERPC_IO_H
 #ifdef __KERNEL__

-/*
+/*
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * as published by the Free Software Foundation; either version
@@ -18,6 +18,9 @@ extern int check_legacy_ioport(unsigned long base_port);
 #define _PNPWRP		0xa79
 #define PNPBIOS_BASE	0xf000

+#include <linux/device.h>
+#include <linux/io.h>
+
 #include <linux/compiler.h>
 #include <asm/page.h>
 #include <asm/byteorder.h>
@@ -744,6 +747,9 @@ static inline void * bus_to_virt(unsigned long address)

 #define clrsetbits_8(addr, clear, set) clrsetbits(8, addr, clear, set)

+void __iomem *devm_ioremap_prot(struct device *dev, resource_size_t offset,
+				size_t size, unsigned long flags);
+
 #endif /* __KERNEL__ */

 #endif /* _ASM_POWERPC_IO_H */
diff --git a/include/linux/io.h b/include/linux/io.h
index 3a03a36..ada8c74 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -58,6 +58,7 @@ static inline void devm_ioport_unmap(struct device *dev, void __iomem *addr)
 }
 #endif

+void devm_ioremap_release(struct device *dev, void *res);
 void __iomem *devm_ioremap(struct device *dev, resource_size_t offset,
 			    unsigned long size);
 void __iomem *devm_ioremap_nocache(struct device *dev, resource_size_t offset,
diff --git a/lib/devres.c b/lib/devres.c
index 26c87c4..72c8909 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -2,7 +2,7 @@
 #include <linux/io.h>
 #include <linux/module.h>

-static void devm_ioremap_release(struct device *dev, void *res)
+void devm_ioremap_release(struct device *dev, void *res)
 {
 	iounmap(*(void __iomem **)res);
 }
-- 
1.5.4.1

