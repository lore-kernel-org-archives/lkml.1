Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbYDTUsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbYDTUsJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 16:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbYDTUr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 16:47:59 -0400
Received: from smtp04.mtu.ru ([62.5.255.51]:58269 "EHLO smtp04.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbYDTUr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 16:47:58 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86: remove NexGen support
Date: Mon, 21 Apr 2008 00:47:55 +0400
Message-Id: <1208724475-15360-1-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
X-DCC-STREAM-Metrics: smtp04.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is claimed that NexGen CPUs were never shipped:

http://lkml.org/lkml/2008/4/20/179

Also, the kernel support for these chips has been broken for
a long time, the code intended to support NexGen thereby being
essentially dead.

As an outcome of the discussion that can be found using the URL
above, this patch removes the NexGen support altogether.

The changes in this patch survived a defconfig build for i386, a
couple of successful randconfig builds, as well as a runtime test,
which consisted in booting a 32-bit x86 box up to the shell prompt.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/x86/Kconfig.cpu         |    4 +-
 arch/x86/kernel/cpu/Makefile |    1 -
 arch/x86/kernel/cpu/nexgen.c |   59 ------------------------------------------
 arch/x86/mm/init_32.c        |    6 ++--
 include/asm-x86/processor.h  |    1 -
 5 files changed, 5 insertions(+), 66 deletions(-)
 delete mode 100644 arch/x86/kernel/cpu/nexgen.c

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index ee7ab45..f6c8b38 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -21,8 +21,8 @@ config M386
 
 	  Here are the settings recommended for greatest speed:
 	  - "386" for the AMD/Cyrix/Intel 386DX/DXL/SL/SLC/SX, Cyrix/TI
-	  486DLC/DLC2, UMC 486SX-S and NexGen Nx586.  Only "386" kernels
-	  will run on a 386 class machine.
+	  486DLC/DLC2, and UMC 486SX-S.  Only "386" kernels will run on a 386
+	  class machine.
 	  - "486" for the AMD/Cyrix/IBM/Intel 486DX/DX2/DX4 or
 	  SL/SLC/SLC2/SLC3/SX/SX2 and UMC U5D or U5S.
 	  - "586" for generic Pentium CPUs lacking the TSC
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index ee7c452..a0c6f81 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -11,7 +11,6 @@ obj-$(CONFIG_X86_32)	+= cyrix.o
 obj-$(CONFIG_X86_32)	+= centaur.o
 obj-$(CONFIG_X86_32)	+= transmeta.o
 obj-$(CONFIG_X86_32)	+= intel.o
-obj-$(CONFIG_X86_32)	+= nexgen.o
 obj-$(CONFIG_X86_32)	+= umc.o
 
 obj-$(CONFIG_X86_MCE)	+= mcheck/
diff --git a/arch/x86/kernel/cpu/nexgen.c b/arch/x86/kernel/cpu/nexgen.c
deleted file mode 100644
index 5d5e1c1..0000000
--- a/arch/x86/kernel/cpu/nexgen.c
+++ /dev/null
@@ -1,59 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/string.h>
-#include <asm/processor.h>
-
-#include "cpu.h"
-
-/*
- *	Detect a NexGen CPU running without BIOS hypercode new enough
- *	to have CPUID. (Thanks to Herbert Oppmann)
- */
-
-static int __cpuinit deep_magic_nexgen_probe(void)
-{
-	int ret;
-
-	__asm__ __volatile__ (
-		"	movw	$0x5555, %%ax\n"
-		"	xorw	%%dx,%%dx\n"
-		"	movw	$2, %%cx\n"
-		"	divw	%%cx\n"
-		"	movl	$0, %%eax\n"
-		"	jnz	1f\n"
-		"	movl	$1, %%eax\n"
-		"1:\n"
-		: "=a" (ret) : : "cx", "dx");
-	return  ret;
-}
-
-static void __cpuinit init_nexgen(struct cpuinfo_x86 *c)
-{
-	c->x86_cache_size = 256; /* A few had 1 MB... */
-}
-
-static void __cpuinit nexgen_identify(struct cpuinfo_x86 *c)
-{
-	/* Detect NexGen with old hypercode */
-	if (deep_magic_nexgen_probe())
-		strcpy(c->x86_vendor_id, "NexGenDriven");
-}
-
-static struct cpu_dev nexgen_cpu_dev __cpuinitdata = {
-	.c_vendor	= "Nexgen",
-	.c_ident	= { "NexGenDriven" },
-	.c_models = {
-			{ .vendor = X86_VENDOR_NEXGEN,
-			  .family = 5,
-			  .model_names = { [1] = "Nx586" }
-			},
-	},
-	.c_init		= init_nexgen,
-	.c_identify	= nexgen_identify,
-};
-
-int __init nexgen_init_cpu(void)
-{
-	cpu_devs[X86_VENDOR_NEXGEN] = &nexgen_cpu_dev;
-	return 0;
-}
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index baf7c4f..4a47618 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -566,9 +566,9 @@ void __init paging_init(void)
 
 /*
  * Test if the WP bit works in supervisor mode. It isn't supported on 386's
- * and also on some strange 486's (NexGen etc.). All 586+'s are OK. This
- * used to involve black magic jumps to work around some nasty CPU bugs,
- * but fortunately the switch to using exceptions got rid of all that.
+ * and also on some strange 486's. All 586+'s are OK. This used to involve
+ * black magic jumps to work around some nasty CPU bugs, but fortunately the
+ * switch to using exceptions got rid of all that.
  */
 static void __init test_wp_bit(void)
 {
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 0b0a859..cf71977 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -119,7 +119,6 @@ struct cpuinfo_x86 {
 #define X86_VENDOR_CYRIX	1
 #define X86_VENDOR_AMD		2
 #define X86_VENDOR_UMC		3
-#define X86_VENDOR_NEXGEN	4
 #define X86_VENDOR_CENTAUR	5
 #define X86_VENDOR_TRANSMETA	7
 #define X86_VENDOR_NSC		8
-- 
1.5.3

