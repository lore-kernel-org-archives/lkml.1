Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbYFEJxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbYFEJxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 05:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbYFEJwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:52:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33622 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbYFEJwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:52:42 -0400
To: linux-kernel@vger.kernel.org
In-Reply-To: <20080605.foo@pmac.infradead.org>
References: <20080605.foo@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
Date: Fri, 23 May 2008 13:58:12 +0100
Subject: [PATCH 02/18] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Message-Id: <E1K4C9B-0001cD-MF@bombadil.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows arbitrary firmware files to be included in the static kernel
where the firmware loader can find them without requiring userspace to
be alive.

(Updated and CONFIG_BUILTIN_FIRMWARE_DIR added with lots of help from
Johannes Berg).

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 Makefile             |    2 +-
 drivers/base/Kconfig |   33 +++++++++++++++++++
 firmware/Makefile    |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 122 insertions(+), 1 deletions(-)
 create mode 100644 firmware/Makefile

diff --git a/Makefile b/Makefile
index 8db70fe..56c243c 100644
--- a/Makefile
+++ b/Makefile
@@ -450,7 +450,7 @@ scripts: scripts_basic include/config/auto.conf
 
 # Objects we will link into vmlinux / subdirs we need to visit
 init-y		:= init/
-drivers-y	:= drivers/ sound/
+drivers-y	:= drivers/ sound/ firmware/
 net-y		:= net/
 libs-y		:= lib/
 core-y		:= usr/
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index d7da109..f204ae7 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -34,6 +34,39 @@ config FW_LOADER
 	  require userspace firmware loading support, but a module built outside
 	  the kernel tree does.
 
+config BUILTIN_FIRMWARE
+	string "Firmware blobs to build into the kernel binary"
+	depends on FW_LOADER
+	help
+	  This option allows firmware to be built into the kernel, for the
+	  cases where the user either cannot or doesn't want to provide it from
+	  userspace at runtime (for example, when the firmware in question is
+	  required for accessing the boot device, and the user doesn't want to
+	  use an initrd).
+
+	  This option is a string, and takes the (space-separated) names of the
+	  firmware files -- the same names which appear in MODULE_FIRMWARE()
+	  and request_firmware() in the source. These files should exist under
+	  the directory specified by the BUILTIN_FIRMWARE_DIR option, which is
+	  by default the firmware/ subdirectory of the kernel source tree.
+
+	  So, for example, you might set CONFIG_BUILTIN_FIRMWARE="usb8388.bin",
+	  copy the usb8388.bin file into the firmware/ directory, and build the
+	  kernel. Then any request_firmware("usb8388.bin") will be
+	  satisfied internally without needing to call out to userspace.
+
+config BUILTIN_FIRMWARE_DIR
+	string "Firmware blobs root directory"
+	depends on BUILTIN_FIRMWARE != ""
+	default "firmware"
+	help
+	  This option controls the directory in which the kernel build system
+	  looks for the firmware files listed in the BUILTIN_FIRMWARE option.
+	  The default is the firmware/ directory in the kernel source tree,
+	  but by changing this option you can point it elsewhere, such as
+	  the /lib/firmware/ directory or another separate directory
+	  containing firmware files.
+
 config DEBUG_DRIVER
 	bool "Driver Core verbose debug messages"
 	depends on DEBUG_KERNEL
diff --git a/firmware/Makefile b/firmware/Makefile
new file mode 100644
index 0000000..9b5152a
--- /dev/null
+++ b/firmware/Makefile
@@ -0,0 +1,88 @@
+#
+# kbuild file for firmware/
+#
+
+# Create $(fwabs) from $(CONFIG_BUILTIN_FIRMWARE_DIR) -- if it doesn't have a
+# leading /, it's relative to $(srctree).
+fwdir := $(subst ",,$(CONFIG_BUILTIN_FIRMWARE_DIR))
+fwabs := $(addprefix $(srctree)/,$(filter-out /%,$(fwdir)))$(filter /%,$(fwdir))
+
+fw-external-y := $(subst ",,$(CONFIG_BUILTIN_FIRMWARE))
+
+firmware-y    := $(fw-external-y) $(fw-shipped-y)
+firmware-dirs := $(sort $(patsubst %,$(objtree)/$(obj)/%/,$(dir $(firmware-y))))
+
+quiet_cmd_mkdir = MKDIR   $(patsubst $(objtree)/%,%,$@)
+      cmd_mkdir = mkdir -p $@
+
+quiet_cmd_ihex  = IHEX    $@
+      cmd_ihex  = $(OBJCOPY) -Iihex -Obinary $< $@
+
+quiet_cmd_fwbin = MK_FW   $@
+      cmd_fwbin = FWNAME="$(patsubst firmware/%.gen.S,%,$@)";		     \
+		  FWSTR="$(subst /,_,$(subst .,_,$(subst -,_,$(patsubst	     \
+				firmware/%.gen.S,%,$@))))";		     \
+		  ASM_WORD=$(if $(CONFIG_64BIT),.quad,.long);		     \
+		  ASM_ALIGN=$(if $(CONFIG_64BIT),3,2);			     \
+		  PROGBITS=$(if $(CONFIG_ARM),%,@)progbits;		     \
+		  echo "/* Generated by firmware/Makefile */"		> $@;\
+		  echo "    .section .rodata"				>>$@;\
+		  echo "    .p2align $${ASM_ALIGN}"			>>$@;\
+		  echo "_fw_$${FWSTR}_bin:"				>>$@;\
+		  echo "    .incbin \"$(2)\""				>>$@;\
+		  echo "_fw_end:"					>>$@;\
+		  echo "   .section .rodata.str,\"aMS\",$${PROGBITS},1"	>>$@;\
+		  echo "    .p2align $${ASM_ALIGN}"			>>$@;\
+		  echo "_fw_$${FWSTR}_name:"				>>$@;\
+		  echo "    .string \"$$FWNAME\""			>>$@;\
+		  echo "    .section .builtin_fw,\"a\",$${PROGBITS}"	>>$@;\
+		  echo "    .p2align $${ASM_ALIGN}"			>>$@;\
+		  echo "    $${ASM_WORD} _fw_$${FWSTR}_name"		>>$@;\
+		  echo "    $${ASM_WORD} _fw_$${FWSTR}_bin"		>>$@;\
+		  echo "    $${ASM_WORD} _fw_end - _fw_$${FWSTR}_bin"	>>$@;
+
+# One of these files will change, or come into existence, whenever
+# the configuration changes between 32-bit and 64-bit. The .S files
+# need to change when that happens.
+wordsize_deps := $(wildcard include/config/64bit.h include/config/32bit.h \
+		include/config/ppc32.h include/config/ppc64.h \
+		include/config/superh32.h include/config/superh64.h \
+		include/config/x86_32.h include/config/x86_64.h)
+
+# Workaround for make < 3.81, where .SECONDEXPANSION doesn't work.
+# It'll end up depending on these targets, so make them a PHONY rule which
+# depends on _all_ the directories in $(firmware-dirs), and it'll work out OK.
+PHONY += $(objtree)/$$(%) $(objtree)/$(obj)/$$(%)
+$(objtree)/$$(%) $(objtree)/$(obj)/$$(%): $(firmware-dirs)
+	@true
+
+# For the $$(dir %) trick, where we need % to be expanded first.
+.SECONDEXPANSION:
+
+$(patsubst %,$(obj)/%.gen.S, $(fw-shipped-y)): %: $(wordsize_deps) \
+		| $(objtree)/$$(dir %)
+	$(call cmd,fwbin,$(patsubst %.gen.S,%,$@))
+$(patsubst %,$(obj)/%.gen.S, $(fw-external-y)): %: $(wordsize_deps) \
+		include/config/builtin/firmware/dir.h | $(objtree)/$$(dir %)
+	$(call cmd,fwbin,$(fwabs)/$(patsubst $(obj)/%.gen.S,%,$@))
+
+# The .o files depend on the binaries directly; the .S files don't.
+$(patsubst %,$(obj)/%.gen.o, $(fw-shipped-y)): %.gen.o: %
+$(patsubst %,$(obj)/%.gen.o, $(fw-external-y)): $(obj)/%.gen.o: $(fwdir)/%
+
+$(obj)/%: $(obj)/%.ihex | $(objtree)/$(obj)/$$(dir %)
+	$(call cmd,ihex)
+
+$(firmware-dirs):
+	$(call cmd,mkdir)
+
+obj-y := $(patsubst %,%.gen.o, $(firmware-y))
+
+# Remove .S files and binaries created from ihex
+# (during 'make clean' .config isn't included so they're all in $(fw-shipped-))
+targets := $(fw-shipped-) $(patsubst $(obj)/%,%, \
+				$(shell find $(obj) -name \*.gen.S 2>/dev/null))
+
+# Without this, built-in.o won't be created when it's empty, and the
+# final vmlinux link will fail.
+obj-n := dummy
-- 
1.5.4.5

