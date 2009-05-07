Return-Path: <linux-kernel-owner+w=401wt.eu-S932298AbZEGW37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298AbZEGW37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762737AbZEGW1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:27:15 -0400
Received: from mga06.intel.com ([134.134.136.21]:19804 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754934AbZEGW1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:27:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,312,1239001200"; 
   d="scan'208";a="410470448"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com, sam@ravnborg.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 07/14] x86, boot: simplify arch/x86/boot/compressed/Makefile
Date: Thu,  7 May 2009 15:26:55 -0700
Message-Id: <1241735222-6640-8-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Simplify the arch/x86/boot/compressed/Makefile, by using the new
capability of specifying multiple inputs to a compressor, and the
CONFIG_X86_NEED_RELOCS Kconfig symbol.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/boot/compressed/Makefile |   39 +++++-------------------------------
 1 files changed, 6 insertions(+), 33 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 0f4b5e2..b35c3bb 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -29,7 +29,7 @@ $(obj)/vmlinux.bin: vmlinux FORCE
 
 
 targets += vmlinux.bin.all vmlinux.relocs relocs
-hostprogs-$(CONFIG_X86_32) += relocs
+hostprogs-$(CONFIG_X86_NEED_RELOCS) += relocs
 
 quiet_cmd_relocs = RELOCS  $@
       cmd_relocs = $(obj)/relocs $< > $@;$(obj)/relocs --abs-relocs $<
@@ -37,46 +37,19 @@ $(obj)/vmlinux.relocs: vmlinux $(obj)/relocs FORCE
 	$(call if_changed,relocs)
 
 vmlinux.bin.all-y := $(obj)/vmlinux.bin
-vmlinux.bin.all-$(CONFIG_RELOCATABLE) += $(obj)/vmlinux.relocs
-quiet_cmd_relocbin = BUILD   $@
-      cmd_relocbin = cat $(filter-out FORCE,$^) > $@
-$(obj)/vmlinux.bin.all: $(vmlinux.bin.all-y) FORCE
-	$(call if_changed,relocbin)
+vmlinux.bin.all-$(CONFIG_X86_NEED_RELOCS) += $(obj)/vmlinux.relocs
 
-ifeq ($(CONFIG_X86_32),y)
-
-ifdef CONFIG_RELOCATABLE
-$(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin.all FORCE
-	$(call if_changed,gzip)
-$(obj)/vmlinux.bin.bz2: $(obj)/vmlinux.bin.all FORCE
-	$(call if_changed,bzip2)
-$(obj)/vmlinux.bin.lzma: $(obj)/vmlinux.bin.all FORCE
-	$(call if_changed,lzma)
-else
-$(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin FORCE
-	$(call if_changed,gzip)
-$(obj)/vmlinux.bin.bz2: $(obj)/vmlinux.bin FORCE
-	$(call if_changed,bzip2)
-$(obj)/vmlinux.bin.lzma: $(obj)/vmlinux.bin FORCE
-	$(call if_changed,lzma)
-endif
-LDFLAGS_piggy.o := -r --format binary --oformat elf32-i386 -T
-
-else
-
-$(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin FORCE
+$(obj)/vmlinux.bin.gz: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,gzip)
-$(obj)/vmlinux.bin.bz2: $(obj)/vmlinux.bin FORCE
+$(obj)/vmlinux.bin.bz2: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,bzip2)
-$(obj)/vmlinux.bin.lzma: $(obj)/vmlinux.bin FORCE
+$(obj)/vmlinux.bin.lzma: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,lzma)
 
-LDFLAGS_piggy.o := -r --format binary --oformat elf64-x86-64 -T
-endif
-
 suffix_$(CONFIG_KERNEL_GZIP)  = gz
 suffix_$(CONFIG_KERNEL_BZIP2) = bz2
 suffix_$(CONFIG_KERNEL_LZMA)  = lzma
 
+LDFLAGS_piggy.o := -r --format binary --oformat $(CONFIG_OUTPUT_FORMAT) -T
 $(obj)/piggy.o: $(obj)/vmlinux.scr $(obj)/vmlinux.bin.$(suffix_y) FORCE
 	$(call if_changed,ld)
-- 
1.6.0.6

