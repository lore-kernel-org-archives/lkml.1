Return-Path: <linux-kernel-owner+w=401wt.eu-S1764729AbXIUUvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764729AbXIUUvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761777AbXIUUpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:10 -0400
Received: from mx1.suse.de ([195.135.220.2]:50040 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763315AbXIUUpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:02 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [19/45] x86_64: Always accumulate compiler options in CFLAGS
Message-Id: <20070921204501.1CF6214EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This way they are used in further down cc-options tries
This avoids a problem with a probe not failing without -m64.
Analysis of original bug by Andy Whitcroft

TBD do for i386 too

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/Makefile |   62 +++++++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 29 deletions(-)

Index: linux/arch/x86_64/Makefile
===================================================================
--- linux.orig/arch/x86_64/Makefile
+++ linux/arch/x86_64/Makefile
@@ -26,50 +26,54 @@ OBJCOPYFLAGS	:= -O binary -R .note -R .c
 LDFLAGS_vmlinux :=
 CHECKFLAGS      += -D__x86_64__ -m64
 
-cflags-y	:=
-cflags-kernel-y	:=
-cflags-$(CONFIG_MK8) += $(call cc-option,-march=k8)
-cflags-$(CONFIG_MPSC) += $(call cc-option,-march=nocona)
-# gcc doesn't support -march=core2 yet as of gcc 4.3, but I hope it
-# will eventually. Use -mtune=generic as fallback
-cflags-$(CONFIG_MCORE2) += \
-	$(call cc-option,-march=core2,$(call cc-option,-mtune=generic))
-cflags-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=generic)
-
-cflags-y += -m64
-cflags-y += -mno-red-zone
-cflags-y += -mcmodel=kernel
-cflags-y += -pipe
-cflags-y += -Wno-sign-compare
-cflags-y += -fno-asynchronous-unwind-tables
-ifneq ($(CONFIG_DEBUG_INFO),y)
+AFLAGS += -m64
+CFLAGS += -m64
+CFLAGS += -mno-red-zone
+CFLAGS += -mcmodel=kernel
+CFLAGS += -pipe
+CFLAGS += -Wno-sign-compare
+CFLAGS += -fno-asynchronous-unwind-tables
+#ifneq ($(CONFIG_DEBUG_INFO),y)
 # -fweb shrinks the kernel a bit, but the difference is very small
 # it also messes up debugging, so don't use it for now.
-#cflags-y += $(call cc-option,-fweb)
-endif
+#CFLAGS += $(call cc-option,-fweb)
+#endif
 # -funit-at-a-time shrinks the kernel .text considerably
 # unfortunately it makes reading oopses harder.
-cflags-y += $(call cc-option,-funit-at-a-time)
+CFLAGS += $(call cc-option,-funit-at-a-time)
 # prevent gcc from generating any FP code by mistake
-cflags-y += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
+CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
 # this works around some issues with generating unwind tables in older gccs
 # newer gccs do it by default
-cflags-y += -maccumulate-outgoing-args
+CFLAGS += -maccumulate-outgoing-args
 
 # do binutils support CFI?
-cflags-y += $(call as-instr,.cfi_startproc\n.cfi_rel_offset rsp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
+CFLAGS += $(call as-instr,.cfi_startproc\n.cfi_rel_offset rsp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
 AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_rel_offset rsp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
 
 # is .cfi_signal_frame supported too?
-cflags-y += $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1,)
+CFLAGS += $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1,)
 AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1,)
+CFLAGS_KERNEL += $(cflags-kernel-y)
 
-cflags-$(CONFIG_CC_STACKPROTECTOR) += $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-x86_64-has-stack-protector.sh "$(CC)" -fstack-protector )
-cflags-$(CONFIG_CC_STACKPROTECTOR_ALL) += $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-x86_64-has-stack-protector.sh "$(CC)" -fstack-protector-all )
+# CFLAGS is used by cc-option, so if combinations fail we notice
 
-CFLAGS += $(cflags-y)
-CFLAGS_KERNEL += $(cflags-kernel-y)
-AFLAGS += -m64
+cflags-k8-$(CONFIG_MK8) += $(call cc-option,-march=k8)
+CFLAGS += $(cflags-k8-y)
+
+cflags-nocona-$(CONFIG_MPSC) += $(call cc-option,-march=nocona)
+CFLAGS += $(cflags-nocona-y)
+# gcc doesn't support -march=core2 yet as of gcc 4.3, but I hope it
+# will eventually. Use -mtune=generic as fallback
+cflags-core2-$(CONFIG_MCORE2) += \
+	$(call cc-option,-march=core2,$(call cc-option,-mtune=generic))
+CFLAGS += $(cflags-core2-y)
+cflags-generic-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=generic)
+CFLAGS += $(cflags-generic-y)
+
+cflags-sp-$(CONFIG_CC_STACKPROTECTOR) += $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-x86_64-has-stack-protector.sh "$(CC)" -fstack-protector )
+cflags-sp-$(CONFIG_CC_STACKPROTECTOR_ALL) += $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-x86_64-has-stack-protector.sh "$(CC)" -fstack-protector-all )
+CFLAGS += $(cflags-sp-y)
 
 head-y := arch/x86_64/kernel/head.o arch/x86_64/kernel/head64.o arch/x86_64/kernel/init_task.o
 
