Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab0BMQDy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 11:03:54 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:45038 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab0BMQCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 11:02:52 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 4/9] of/flattree: Don't assume HAVE_LMB
To: monstr@monstr.eu, sfr@canb.auug.org.au, benh@kernel.crashing.org,
       jeremy.kerr@canonical.com, davem@davemloft.net,
       microblaze-uclinux@itee.uq.edu.au, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       linux-kernel@vger.kernel.org
Date: Sat, 13 Feb 2010 09:02:47 -0700
Message-ID: <20100213160247.4767.74578.stgit@angua>
In-Reply-To: <20100213154838.4767.83881.stgit@angua>
References: <20100213154838.4767.83881.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Kerr <jeremy.kerr@canonical.com>

We don't always have lmb available, so make arches provide an
early_init_dt_alloc_memory_arch() to handle the allocation of
memory in the fdt code.

When we don't have lmb.h included, we need asm/page.h for __va.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 arch/microblaze/kernel/prom.c |    5 +++++
 arch/powerpc/kernel/prom.c    |    5 +++++
 drivers/of/fdt.c              |    9 ++++++---
 include/linux/of_fdt.h        |    1 +
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index 050b799..a7dcaf0 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -55,6 +55,11 @@ void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 	lmb_add(base, size);
 }
 
+u64 __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
+{
+	return lmb_alloc(size, align);
+}
+
 #ifdef CONFIG_EARLY_PRINTK
 /* MS this is Microblaze specifig function */
 static int __init early_init_dt_scan_serial(unsigned long node,
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 43c78d7..5bbbdb2 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -510,6 +510,11 @@ void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 	memstart_addr = min((u64)memstart_addr, base);
 }
 
+u64 __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
+{
+	return lmb_alloc(size, align);
+}
+
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init early_init_dt_setup_initrd_arch(unsigned long start,
 		unsigned long end)
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index b51f797..406757a 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -10,16 +10,18 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/lmb.h>
 #include <linux/initrd.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
-
+#include <linux/string.h>
+#include <linux/errno.h>
 
 #ifdef CONFIG_PPC
 #include <asm/machdep.h>
 #endif /* CONFIG_PPC */
 
+#include <asm/page.h>
+
 int __initdata dt_root_addr_cells;
 int __initdata dt_root_size_cells;
 
@@ -560,7 +562,8 @@ void __init unflatten_device_tree(void)
 	pr_debug("  size is %lx, allocating...\n", size);
 
 	/* Allocate memory for the expanded device tree */
-	mem = lmb_alloc(size + 4, __alignof__(struct device_node));
+	mem = early_init_dt_alloc_memory_arch(size + 4,
+			__alignof__(struct device_node));
 	mem = (unsigned long) __va(mem);
 
 	((__be32 *)mem)[size / 4] = cpu_to_be32(0xdeadbeef);
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index c9cb8a7..a1ca92c 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -78,6 +78,7 @@ extern void early_init_dt_check_for_initrd(unsigned long node);
 extern int early_init_dt_scan_memory(unsigned long node, const char *uname,
 				     int depth, void *data);
 extern void early_init_dt_add_memory_arch(u64 base, u64 size);
+extern u64 early_init_dt_alloc_memory_arch(u64 size, u64 align);
 extern u64 dt_mem_next_cell(int s, __be32 **cellp);
 
 /*

