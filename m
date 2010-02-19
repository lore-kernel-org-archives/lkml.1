Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab0BST1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:27:25 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:34142 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab0BST1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:27:23 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 2/7] arm-dt: Allow CONFIG_OF on ARM
To: linux@arm.linux.org.uk, catalin.marinas@arm.com, jeremy.kerr@canonical.com,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: tim.bird@am.sony.com
Date: Fri, 19 Feb 2010 12:27:16 -0700
Message-ID: <20100219192705.15318.63737.stgit@angua>
In-Reply-To: <20100219185953.15318.4850.stgit@angua>
References: <20100219185953.15318.4850.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Kerr <jeremy.kerr@canonical.com>

Add some basic empty infrastructure for DT support on ARM.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 arch/arm/Kconfig            |    6 ++++++
 arch/arm/include/asm/prom.h |   19 +++++++++++++++++++
 arch/arm/kernel/Makefile    |    1 +
 arch/arm/kernel/devtree.c   |   34 ++++++++++++++++++++++++++++++++++
 4 files changed, 60 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/include/asm/prom.h
 create mode 100644 arch/arm/kernel/devtree.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4c33ca8..5a8edc2 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1258,6 +1258,12 @@ endmenu
 
 menu "Boot options"
 
+config OF
+	bool "Device tree support"
+	select OF_FLATTREE
+	help
+	  Support for OpenFirmware-style device trees
+
 # Compressed boot loader in ROM.  Yes, we really want to ask about
 # TEXT and BSS so we preserve their values in the config files.
 config ZBOOT_ROM_TEXT
diff --git a/arch/arm/include/asm/prom.h b/arch/arm/include/asm/prom.h
new file mode 100644
index 0000000..20b42fb
--- /dev/null
+++ b/arch/arm/include/asm/prom.h
@@ -0,0 +1,19 @@
+/*
+ *  arch/arm/include/asm/prom.h
+ *
+ *  Copyright (C) 2009 Canonical Ltd. <jeremy.kerr@canonical.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#ifndef __ASMARM_PROM_H
+#define __ASMARM_PROM_H
+
+#include <asm/setup.h>
+
+/* _ALIGN expects upwards alignment */
+#define _ALIGN(addr, size)		(((addr)+((size)-1))&(~((size)-1)))
+
+#endif
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index dd00f74..35c8bdf 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_ARM_THUMBEE)	+= thumbee.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_ARM_UNWIND)	+= unwind.o
 obj-$(CONFIG_HAVE_TCM)		+= tcm.o
+obj-$(CONFIG_OF)		+= devtree.o
 
 obj-$(CONFIG_CRUNCH)		+= crunch.o crunch-bits.o
 AFLAGS_crunch-bits.o		:= -Wa,-mcpu=ep9312
diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
new file mode 100644
index 0000000..5909d08
--- /dev/null
+++ b/arch/arm/kernel/devtree.c
@@ -0,0 +1,34 @@
+/*
+ *  linux/arch/arm/kernel/devtree.c
+ *
+ *  Copyright (C) 2009 Canonical Ltd. <jeremy.kerr@canonical.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/bootmem.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+
+#include <asm/setup.h>
+#include <asm/page.h>
+
+void __init early_init_dt_add_memory_arch(u64 base, u64 size)
+{
+	arm_add_memory(base, size);
+}
+
+u64 __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
+{
+	return __pa(__alloc_bootmem(size, align, __pa(MAX_DMA_ADDRESS)));
+}
+
+void early_init_dt_scan_chosen_arch(unsigned long node) { }
+
+void early_init_dt_setup_initrd_arch(unsigned long start,
+					    unsigned long end) { }

