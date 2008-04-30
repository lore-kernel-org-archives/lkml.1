Return-Path: <linux-kernel-owner+w=401wt.eu-S1762631AbYD3QGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762631AbYD3QGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 12:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbYD3QGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 12:06:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:40078 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081AbYD3QGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 12:06:23 -0400
Date: Wed, 30 Apr 2008 11:01:24 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: Greg KH <greg@kroah.com>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Emilian.Medve@Freescale.com,
       htejun@gmail.com, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] [POWERPC] devres: Add devm_ioremap_flags()
Message-ID: <Pine.LNX.4.64.0804301059430.22937@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emil Medve <Emilian.Medve@Freescale.com>

We provide an ioremap_flags so provide a coresphonding devm_ioremap_flags.

Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---

Which tree should this go through, powerpc.git?

 arch/powerpc/lib/Makefile |    1 +
 include/asm-powerpc/io.h  |    8 +++++++-
 include/linux/io.h        |    1 +
 lib/devres.c              |    2 +-
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 4bb023f..f1d2cdc 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -23,3 +23,4 @@ obj-$(CONFIG_SMP)	+= locks.o
 endif

 obj-$(CONFIG_PPC_LIB_RHEAP) += rheap.o
+obj-$(CONFIG_HAS_IOMEM)	+= devres.o
diff --git a/include/asm-powerpc/io.h b/include/asm-powerpc/io.h
index afae069..3b8c334 100644
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

+void __iomem *devm_ioremap_flags(struct device *dev, resource_size_t offset,
+				 size_t size, unsigned long flags);
+
 #endif /* __KERNEL__ */

 #endif /* _ASM_POWERPC_IO_H */
diff --git a/include/linux/io.h b/include/linux/io.h
index 831f57c..7a390cf 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -58,6 +58,7 @@ static inline void devm_ioport_unmap(struct device *dev, void __iomem *addr)
 }
 #endif

+void devm_ioremap_release(struct device *dev, void *res);
 void __iomem * devm_ioremap(struct device *dev, resource_size_t offset,
 			    unsigned long size);
 void __iomem * devm_ioremap_nocache(struct device *dev, resource_size_t offset,
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

