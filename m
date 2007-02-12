Return-Path: <linux-kernel-owner+w=401wt.eu-S965013AbXBLQzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965013AbXBLQzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965002AbXBLQwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:52:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965003AbXBLQv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:56 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [29/29] x86: Unify pcspeaker platform device code between i386/x86-64
Message-Id: <20070212165150.5D40313F7A@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:50 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial cleanup.

Only change is that it is always compiled in now on x86-64 like on i386.


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/Makefile    |    1 +
 arch/i386/kernel/pcspeaker.c |   20 ++++++++++++++++++++
 arch/i386/kernel/setup.c     |   26 --------------------------
 arch/x86_64/kernel/Makefile  |    2 ++
 arch/x86_64/kernel/setup.c   |   20 --------------------
 5 files changed, 23 insertions(+), 46 deletions(-)

Index: linux/arch/i386/kernel/Makefile
===================================================================
--- linux.orig/arch/i386/kernel/Makefile
+++ linux/arch/i386/kernel/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_K8_NB)		+= k8.o
 
 obj-$(CONFIG_VMI)		+= vmi.o vmitime.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o
+obj-y				+= pcspeaker.o
 
 EXTRA_AFLAGS   := -traditional
 
Index: linux/arch/i386/kernel/pcspeaker.c
===================================================================
--- /dev/null
+++ linux/arch/i386/kernel/pcspeaker.c
@@ -0,0 +1,20 @@
+#include <linux/platform_device.h>
+#include <linux/errno.h>
+#include <linux/init.h>
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
Index: linux/arch/i386/kernel/setup.c
===================================================================
--- linux.orig/arch/i386/kernel/setup.c
+++ linux/arch/i386/kernel/setup.c
@@ -33,7 +33,6 @@
 #include <linux/initrd.h>
 #include <linux/bootmem.h>
 #include <linux/seq_file.h>
-#include <linux/platform_device.h>
 #include <linux/console.h>
 #include <linux/mca.h>
 #include <linux/root_dev.h>
@@ -660,28 +659,3 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	tsc_init();
 }
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
-
-/*
- * Local Variables:
- * mode:c
- * c-file-style:"k&r"
- * c-basic-offset:8
- * End:
- */
Index: linux/arch/x86_64/kernel/Makefile
===================================================================
--- linux.orig/arch/x86_64/kernel/Makefile
+++ linux/arch/x86_64/kernel/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_PCI)		+= early-quirks.o
 
 obj-y				+= topology.o
 obj-y				+= intel_cacheinfo.o
+obj-y				+= pcspeaker.o
 
 CFLAGS_vsyscall.o		:= $(PROFILING) -g0
 
@@ -55,3 +56,4 @@ quirks-y			+= ../../i386/kernel/quirks.o
 i8237-y				+= ../../i386/kernel/i8237.o
 msr-$(subst m,y,$(CONFIG_X86_MSR))  += ../../i386/kernel/msr.o
 alternative-y			+= ../../i386/kernel/alternative.o
+pcspeaker-y			+= ../../i386/kernel/pcspeaker.o
Index: linux/arch/x86_64/kernel/setup.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup.c
+++ linux/arch/x86_64/kernel/setup.c
@@ -1104,23 +1104,3 @@ struct seq_operations cpuinfo_op = {
 	.stop =	c_stop,
 	.show =	show_cpuinfo,
 };
-
-#if defined(CONFIG_INPUT_PCSPKR) || defined(CONFIG_INPUT_PCSPKR_MODULE)
-#include <linux/platform_device.h>
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
-#endif
