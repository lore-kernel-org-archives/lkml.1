Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbYAHFvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbYAHFvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 00:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbYAHFum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 00:50:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:39562 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756756AbYAHFuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 00:50:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,256,1196668800"; 
   d="scan'208";a="318316021"
Subject: [PATCH -mm] x86 boot : export boot_params via debugfs for debugging
From: "Huang, Ying" <ying.huang@intel.com>
To: Greg KH <greg@kroah.com>, akpm@linux-foundation.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 08 Jan 2008 13:40:20 +0800
Message-Id: <1199770820.11041.6.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 08 Jan 2008 05:39:32.0977 (UTC) FILETIME=[D8989610:01C851B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch export the boot parameters via debugfs for debugging.

The files added are as follow:

boot_params/data    :  binary file for struct boot_params
boot_params/version :  boot protocol version

This patch is based on 2.6.24-rc5-mm1 and has been tested on i386 and
x86_64 platform.

This patch is based on the Peter Anvin's proposal.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/Kconfig.debug      |    7 ++++
 arch/x86/kernel/Makefile_32 |    3 +-
 arch/x86/kernel/Makefile_64 |    2 -
 arch/x86/kernel/kdebugfs.c  |   65 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup64.c   |    4 ++
 arch/x86/kernel/setup_32.c  |    4 ++
 6 files changed, 83 insertions(+), 2 deletions(-)

--- /dev/null
+++ b/arch/x86/kernel/kdebugfs.c
@@ -0,0 +1,65 @@
+/*
+ * Architecture specific debugfs files
+ *
+ * Copyright (C) 2007, Intel Corp.
+ *	Huang Ying <ying.huang@intel.com>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/stat.h>
+#include <linux/init.h>
+
+#include <asm/setup.h>
+
+#ifdef CONFIG_DEBUG_BOOT_PARAMS
+static struct debugfs_blob_wrapper boot_params_blob = {
+	.data = &boot_params,
+	.size = sizeof(boot_params),
+};
+
+static int __init boot_params_kdebugfs_init(void)
+{
+	int error;
+	struct dentry *dbp, *version, *data;
+
+	dbp = debugfs_create_dir("boot_params", NULL);
+	if (!dbp) {
+		error = -ENOMEM;
+		goto err_return;
+	}
+	version = debugfs_create_x16("version", S_IRUGO, dbp,
+				     &boot_params.hdr.version);
+	if (!version) {
+		error = -ENOMEM;
+		goto err_dir;
+	}
+	data = debugfs_create_blob("data", S_IRUGO, dbp,
+				   &boot_params_blob);
+	if (!data) {
+		error = -ENOMEM;
+		goto err_version;
+	}
+	return 0;
+err_version:
+	debugfs_remove(version);
+err_dir:
+	debugfs_remove(dbp);
+err_return:
+	return error;
+}
+#endif
+
+static int __init arch_kdebugfs_init(void)
+{
+	int error = 0;
+
+#ifdef CONFIG_DEBUG_BOOT_PARAMS
+	error = boot_params_kdebugfs_init();
+#endif
+
+	return error;
+}
+
+arch_initcall(arch_kdebugfs_init);
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -112,4 +112,11 @@ config IOMMU_LEAK
 	  Add a simple leak tracer to the IOMMU code. This is useful when you
 	  are debugging a buggy device driver that leaks IOMMU mappings.
 
+config DEBUG_BOOT_PARAMS
+	bool "Debug boot parameters"
+	depends on DEBUG_KERNEL
+	depends on DEBUG_FS
+	help
+	  This option will cause struct boot_params to be exported via debugfs.
+
 endmenu
--- a/arch/x86/kernel/Makefile_32
+++ b/arch/x86/kernel/Makefile_32
@@ -8,7 +8,8 @@ CPPFLAGS_vmlinux.lds += -Ui386
 obj-y	:= process_32.o signal_32.o entry_32.o traps_32.o irq_32.o \
 		time_32.o ioport_32.o ldt.o setup_32.o i8259_32.o sys_i386_32.o \
 		pci-dma_32.o i386_ksyms_32.o i387_32.o bootflag.o e820_32.o\
-		quirks.o i8237.o topology.o alternative.o i8253.o tsc_32.o rtc.o
+		quirks.o i8237.o topology.o alternative.o i8253.o tsc_32.o \
+		rtc.o kdebugfs.o
 
 obj-y				+= ptrace.o
 obj-y				+= ds.o
--- a/arch/x86/kernel/Makefile_64
+++ b/arch/x86/kernel/Makefile_64
@@ -10,7 +10,7 @@ obj-y	:= process_64.o signal_64.o entry_
 		x8664_ksyms_64.o i387_64.o syscall_64.o vsyscall_64.o \
 		setup64.o bootflag.o e820_64.o reboot_64.o quirks.o i8237.o \
 		pci-dma_64.o pci-nommu_64.o alternative.o hpet.o tsc_64.o bugs_64.o \
-		i8253.o rtc.o
+		i8253.o rtc.o kdebugfs.o
 
 obj-y				+= ptrace.o
 obj-y				+= ds.o
--- a/arch/x86/kernel/setup64.c
+++ b/arch/x86/kernel/setup64.c
@@ -24,7 +24,11 @@
 #include <asm/sections.h>
 #include <asm/setup.h>
 
+#ifndef CONFIG_DEBUG_BOOT_PARAMS
 struct boot_params __initdata boot_params;
+#else
+struct boot_params boot_params;
+#endif
 
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -194,7 +194,11 @@ unsigned long saved_videomode;
 
 static char __initdata command_line[COMMAND_LINE_SIZE];
 
+#ifndef CONFIG_DEBUG_BOOT_PARAMS
 struct boot_params __initdata boot_params;
+#else
+struct boot_params boot_params;
+#endif
 
 #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
 struct edd edd;

