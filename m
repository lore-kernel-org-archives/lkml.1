Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbYAWWcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbYAWWcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbYAWWbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:31:53 -0500
Received: from sd-6163.dedibox.fr ([88.191.46.45]:1208 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbYAWWbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:31:51 -0500
From: Michael Opdenacker <michael-lists@free-electrons.com>
Organization: Free Electrons
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] x86: =?utf-8?q?fix=09unconditional=09arch/x86/kernel/pcspeaker=2Ec=3Fcompiling?=
Date: Wed, 23 Jan 2008 23:30:11 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linux-tiny@selenic.com, Thomas Gleixner <tglx@linutronix.de>,
       ralf@linux-mips.org
References: <200801171643.49301.michael-lists@free-electrons.com> <4790D3E3.4060409@free-electrons.com> <1200676219.3835.8.camel@cinder.waste.org>
In-Reply-To: <1200676219.3835.8.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801232330.12331.michael-lists@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2008, Matt Mackall wrote:
> 
> Probably makes sense to define it right next to INPUT_PCSPKR in
> drivers/input/Kconfig.
> 
> Then do the appropriate fix for all arches mentioned in INPUT_PCSPKR.
> 
> For extra points, you can move the duplicate pcspeaker.c code out of all
> those arches and stash it somewhere in drivers/input. Presumably it's
> possible to get it to link into the kernel even when INPUT is modular.

Here's the patch, after spending some time to get familiar with git.

The patch is against git x86/mm, and it seems to work fine on x86. However,
on x86, you no longer have /sys/devices/platform/pcspkr after
running "make allnoconfig". To get it, you have to explicitely add support
to CONFIG_INPUT_PCSPKR (m or y). I hope this is fine.

I'm copying the MIPS maintainer as this patch touches his tree too.

On MIPS, there should be no impact though, as CONFIG_PCSPEAKER is set in
defconfig files.

In other architectures where CONFIG_INPUT_PCSPKR can exist,
there is a change: when CONFIG_INPUT_PCSPKR is set, the platform device
will be added, while it didn't exist before. I hope this is fine.

In a nutshell, this patch looks good because it removes a small amount
of duplication between mips and x86. On the other hand, it introduces
changes that may not be wanted. Is this worth it?

Michael.

--
Signed-off-by: Michael Opdenacker <michael@free-electrons.com>

---
 arch/mips/kernel/Makefile      |    1 -
 arch/mips/kernel/pcspeaker.c   |   28 ----------------------------
 arch/x86/kernel/Makefile       |    4 ----
 arch/x86/kernel/pcspeaker.c    |   20 --------------------
 drivers/input/misc/Kconfig     |    4 ++++
 drivers/input/misc/Makefile    |    1 +
 drivers/input/misc/pcspeaker.c |   28 ++++++++++++++++++++++++++++
 7 files changed, 33 insertions(+), 53 deletions(-)
 delete mode 100644 arch/mips/kernel/pcspeaker.c
 delete mode 100644 arch/x86/kernel/pcspeaker.c
 create mode 100644 drivers/input/misc/pcspeaker.c

diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index ffa0836..9e78e1a 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -76,7 +76,6 @@ obj-$(CONFIG_PROC_FS)		+= proc.o
 obj-$(CONFIG_64BIT)		+= cpu-bugs64.o
 
 obj-$(CONFIG_I8253)		+= i8253.o
-obj-$(CONFIG_PCSPEAKER)		+= pcspeaker.o
 
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
diff --git a/arch/mips/kernel/pcspeaker.c b/arch/mips/kernel/pcspeaker.c
deleted file mode 100644
index 475df69..0000000
--- a/arch/mips/kernel/pcspeaker.c
+++ /dev/null
@@ -1,28 +0,0 @@
-/*
- * Copyright (C) 2006 IBM Corporation
- *
- * Implements device information for i8253 timer chip
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License version
- * 2 as published by the Free Software Foundation
- */
-
-#include <linux/platform_device.h>
-
-static __init int add_pcspkr(void)
-{
-	struct platform_device *pd;
-	int ret;
-
-	pd = platform_device_alloc("pcspkr", -1);
-	if (!pd)
-		return -ENOMEM;
-
-	ret = platform_device_add(pd);
-	if (ret)
-		platform_device_put(pd);
-
-	return ret;
-}
-device_initcall(add_pcspkr);
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index e8386eb..959ab30 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -69,10 +69,6 @@ obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
 
-ifdef CONFIG_INPUT_PCSPKR
-obj-y				+= pcspeaker.o
-endif
-
 obj-$(CONFIG_SCx200)		+= scx200_32.o
 
 ###
diff --git a/arch/x86/kernel/pcspeaker.c b/arch/x86/kernel/pcspeaker.c
deleted file mode 100644
index bc1f2d3..0000000
--- a/arch/x86/kernel/pcspeaker.c
+++ /dev/null
@@ -1,20 +0,0 @@
-#include <linux/platform_device.h>
-#include <linux/errno.h>
-#include <linux/init.h>
-
-static __init int add_pcspkr(void)
-{
-	struct platform_device *pd;
-	int ret;
-
-	pd = platform_device_alloc("pcspkr", -1);
-	if (!pd)
-		return -ENOMEM;
-
-	ret = platform_device_add(pd);
-	if (ret)
-		platform_device_put(pd);
-
-	return ret;
-}
-device_initcall(add_pcspkr);
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 8f5c7b9..45b14ce 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -14,6 +14,7 @@ if INPUT_MISC
 
 config INPUT_PCSPKR
 	tristate "PC Speaker support"
+	select PCSPEAKER
 	depends on ALPHA || X86 || MIPS || PPC_PREP || PPC_CHRP || PPC_PSERIES
 	help
 	  Say Y here if you want the standard PC Speaker to be used for
@@ -24,6 +25,9 @@ config INPUT_PCSPKR
 	  To compile this driver as a module, choose M here: the
 	  module will be called pcspkr.
 
+config PCSPEAKER
+        bool
+
 config INPUT_SPARCSPKR
 	tristate "SPARC Speaker support"
 	depends on PCI && SPARC64
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 3585b50..4e51822 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -6,6 +6,7 @@
 
 obj-$(CONFIG_INPUT_SPARCSPKR)		+= sparcspkr.o
 obj-$(CONFIG_INPUT_PCSPKR)		+= pcspkr.o
+obj-$(CONFIG_PCSPEAKER)			+= pcspeaker.o
 obj-$(CONFIG_INPUT_M68K_BEEP)		+= m68kspkr.o
 obj-$(CONFIG_INPUT_IXP4XX_BEEPER)	+= ixp4xx-beeper.o
 obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
diff --git a/drivers/input/misc/pcspeaker.c b/drivers/input/misc/pcspeaker.c
new file mode 100644
index 0000000..475df69
--- /dev/null
+++ b/drivers/input/misc/pcspeaker.c
@@ -0,0 +1,28 @@
+/*
+ * Copyright (C) 2006 IBM Corporation
+ *
+ * Implements device information for i8253 timer chip
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation
+ */
+
+#include <linux/platform_device.h>
+
+static __init int add_pcspkr(void)
+{
+	struct platform_device *pd;
+	int ret;
+
+	pd = platform_device_alloc("pcspkr", -1);
+	if (!pd)
+		return -ENOMEM;
+
+	ret = platform_device_add(pd);
+	if (ret)
+		platform_device_put(pd);
+
+	return ret;
+}
+device_initcall(add_pcspkr);
-- 
1.5.2.5

-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)
