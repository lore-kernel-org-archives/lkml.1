Return-Path: <linux-kernel-owner+w=401wt.eu-S934117AbYDQJak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934117AbYDQJak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763616AbYDQJLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:55 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:59088
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763409AbYDQJLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:11:14 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Xiantao Zhang <xiantao.zhang@intel.com>
Subject: [PATCH 44/45] KVM: ia64: Enable kvm build for ia64
Date: Thu, 17 Apr 2008 12:10:49 +0300
Message-Id: <1208423450-29415-45-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

Update the related Makefile and KConfig for kvm build

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/ia64/Kconfig      |    3 ++
 arch/ia64/Makefile     |    1 +
 arch/ia64/kvm/Kconfig  |   46 ++++++++++++++++++++++++++++++++++++
 arch/ia64/kvm/Makefile |   61 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 111 insertions(+), 0 deletions(-)
 create mode 100644 arch/ia64/kvm/Kconfig
 create mode 100644 arch/ia64/kvm/Makefile

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 8fa3faf..a7bb62e 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -19,6 +19,7 @@ config IA64
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_KVM
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
@@ -589,6 +590,8 @@ config MSPEC
 
 source "fs/Kconfig"
 
+source "arch/ia64/kvm/Kconfig"
+
 source "lib/Kconfig"
 
 #
diff --git a/arch/ia64/Makefile b/arch/ia64/Makefile
index f1645c4..ec4cca4 100644
--- a/arch/ia64/Makefile
+++ b/arch/ia64/Makefile
@@ -57,6 +57,7 @@ core-$(CONFIG_IA64_GENERIC) 	+= arch/ia64/dig/
 core-$(CONFIG_IA64_HP_ZX1)	+= arch/ia64/dig/
 core-$(CONFIG_IA64_HP_ZX1_SWIOTLB) += arch/ia64/dig/
 core-$(CONFIG_IA64_SGI_SN2)	+= arch/ia64/sn/
+core-$(CONFIG_KVM) 		+= arch/ia64/kvm/
 
 drivers-$(CONFIG_PCI)		+= arch/ia64/pci/
 drivers-$(CONFIG_IA64_HP_SIM)	+= arch/ia64/hp/sim/
diff --git a/arch/ia64/kvm/Kconfig b/arch/ia64/kvm/Kconfig
new file mode 100644
index 0000000..d2e54b9
--- /dev/null
+++ b/arch/ia64/kvm/Kconfig
@@ -0,0 +1,46 @@
+#
+# KVM configuration
+#
+config HAVE_KVM
+	bool
+
+menuconfig VIRTUALIZATION
+	bool "Virtualization"
+	depends on HAVE_KVM || IA64
+	default y
+	---help---
+	  Say Y here to get to see options for using your Linux host to run other
+	  operating systems inside virtual machines (guests).
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
+
+if VIRTUALIZATION
+
+config KVM
+	tristate "Kernel-based Virtual Machine (KVM) support"
+	depends on HAVE_KVM && EXPERIMENTAL
+	select PREEMPT_NOTIFIERS
+	select ANON_INODES
+	---help---
+	  Support hosting fully virtualized guest machines using hardware
+	  virtualization extensions.  You will need a fairly recent
+	  processor equipped with virtualization extensions. You will also
+	  need to select one or more of the processor modules below.
+
+	  This module provides access to the hardware capabilities through
+	  a character device node named /dev/kvm.
+
+	  To compile this as a module, choose M here: the module
+	  will be called kvm.
+
+	  If unsure, say N.
+
+config KVM_INTEL
+	tristate "KVM for Intel Itanium 2 processors support"
+	depends on KVM && m
+	---help---
+	  Provides support for KVM on Itanium 2 processors equipped with the VT
+	  extensions.
+
+endif # VIRTUALIZATION
diff --git a/arch/ia64/kvm/Makefile b/arch/ia64/kvm/Makefile
new file mode 100644
index 0000000..41b034f
--- /dev/null
+++ b/arch/ia64/kvm/Makefile
@@ -0,0 +1,61 @@
+#This Make file is to generate asm-offsets.h and build source.
+#
+
+#Generate asm-offsets.h for vmm module build
+offsets-file := asm-offsets.h
+
+always  := $(offsets-file)
+targets := $(offsets-file)
+targets += arch/ia64/kvm/asm-offsets.s
+clean-files := $(addprefix $(objtree)/,$(targets) $(obj)/memcpy.S $(obj)/memset.S)
+
+# Default sed regexp - multiline due to syntax constraints
+define sed-y
+	"/^->/{s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; s:->::; p;}"
+endef
+
+quiet_cmd_offsets = GEN     $@
+define cmd_offsets
+	(set -e; \
+	 echo "#ifndef __ASM_KVM_OFFSETS_H__"; \
+	 echo "#define __ASM_KVM_OFFSETS_H__"; \
+	 echo "/*"; \
+	 echo " * DO NOT MODIFY."; \
+	 echo " *"; \
+	 echo " * This file was generated by Makefile"; \
+	 echo " *"; \
+	 echo " */"; \
+	 echo ""; \
+	 sed -ne $(sed-y) $<; \
+	 echo ""; \
+	 echo "#endif" ) > $@
+endef
+# We use internal rules to avoid the "is up to date" message from make
+arch/ia64/kvm/asm-offsets.s: arch/ia64/kvm/asm-offsets.c
+	$(call if_changed_dep,cc_s_c)
+
+$(obj)/$(offsets-file): arch/ia64/kvm/asm-offsets.s
+	$(call cmd,offsets)
+
+#
+# Makefile for Kernel-based Virtual Machine module
+#
+
+EXTRA_CFLAGS += -Ivirt/kvm -Iarch/ia64/kvm/
+
+$(addprefix $(objtree)/,$(obj)/memcpy.S $(obj)/memset.S):
+	$(shell ln -snf ../lib/memcpy.S $(src)/memcpy.S)
+	$(shell ln -snf ../lib/memset.S $(src)/memset.S)
+
+common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o)
+
+kvm-objs := $(common-objs) kvm-ia64.o kvm_fw.o
+obj-$(CONFIG_KVM) += kvm.o
+
+FORCE : $(obj)/$(offsets-file)
+EXTRA_CFLAGS_vcpu.o += -mfixed-range=f2-f5,f12-f127
+kvm-intel-objs = vmm.o vmm_ivt.o trampoline.o vcpu.o optvfault.o mmio.o \
+	vtlb.o process.o
+#Add link memcpy and memset to avoid possible structure assignment error
+kvm-intel-objs += memset.o memcpy.o
+obj-$(CONFIG_KVM_INTEL) += kvm-intel.o
-- 
1.5.5

