Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbYE1MAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbYE1MAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 08:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYE1MAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 08:00:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55983 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbYE1MAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 08:00:07 -0400
Subject: Re: [PATCHv4 27/28] firmware: Add CONFIG_BUILTIN_FIRMWARE option
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       johannes@sipsolutions.net
In-Reply-To: <1211792300.23085.1.camel@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
	 <E1K0DOP-0007EW-F0@shinybook.infradead.org>
	 <1211734802.31212.129.camel@shinybook.infradead.org>
	 <1211792300.23085.1.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Wed, 28 May 2008 14:46:03 +0300
Message-Id: <1211975163.3902.11.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More feedback... Andrew wanted the help text to be a little more...
well, helpful. And Johannes wanted to add a CONFIG_BUILTIN_FIRMWARE_DIR
option, which lets you just point it at /lib/firmware or somewhere else
outside the kernel tree. And we fixed up a bunch of other details, like
the dependencies on directories, and the fact that the .S file doesn't
actually need to change when the binary blob does.

I even made the Makefile fit in 80 characters. It's going to make your
brain hurt either way -- but that's normal for kernel Makefiles.

commit 4311743f8ef92ab462c06a9dd2ff8e0d735b3dae
Author: David Woodhouse <dwmw2@infradead.org>
Date:   Fri May 23 13:58:12 2008 +0100

    firmware: Add CONFIG_BUILTIN_FIRMWARE option
    
    This allows arbitrary firmware files to be included in the static kernel
    where the firmware loader can find them without requiring userspace to
    be alive.
    
    (Updated and CONFIG_BUILTIN_FIRMWARE_DIR added with lots of help from
    Johannes Berg).
    
    Signed-off-by: David Woodhouse <dwmw2@infradead.org>
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

diff --git a/Makefile b/Makefile
index 20b3235..ac2ab7e 100644
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
index 0000000..c79bbe7
--- /dev/null
+++ b/firmware/Makefile
@@ -0,0 +1,86 @@
+#
+# kbuild file for firmware/
+#
+
+# Create $(fwdir) from $(CONFIG_BUILTIN_FIRMWARE_DIR) -- if it doesn't have a
+# leading /, it's relative to $(srctree).
+fwdir := $(subst ",,$(CONFIG_BUILTIN_FIRMWARE_DIR))
+fwabs := $(addprefix $(srctree)/,$(filter-out /%,$(fwdir)))$(filter /%,$(fwdir))
+
+fw-external-y := $(subst ",,$(CONFIG_BUILTIN_FIRMWARE))
+
+firmware-y    := $(fw-external-y) $(fw-shipped-y)
+firmware-dirs := $(sort $(patsubst %,$(objtree)/$(obj)/%/,$(dir $(firmware-y))))
+
+quiet_cmd_mkdir = MKDIR   $(subst $(srctree)/,,$@)
+      cmd_mkdir = mkdir -p $@
+
+quiet_cmd_ihex  = IHEX    $@
+      cmd_ihex  = objcopy -Iihex -Obinary $< $@
+
+ifdef CONFIG_64BIT
+ASM_WORD := .quad
+ASM_ALIGN := 3
+else
+ASM_WORD := .long
+ASM_ALIGN := 2
+endif
+
+quiet_cmd_fwbin = MK_FW   $@
+      cmd_fwbin = FWNAME="$(patsubst firmware/%.S,%,$@)";		     \
+		  FWSTR="$(subst /,_,$(subst .,_,$(patsubst 		     \
+				firmware/%.S,%,$@)))";			     \
+		  echo "/* Generated by firmware/Makefile */"		> $@;\
+		  echo "    .section .rodata"				>>$@;\
+		  echo "    .align $(ASM_ALIGN)"			>>$@;\
+		  echo "_fw_$${FWSTR}_bin:"				>>$@;\
+		  echo "    .incbin \"$(2)\""				>>$@;\
+		  echo "_fw_end:"					>>$@;\
+		  echo "   .section .rodata.str,\"aMS\",@progbits,1"	>>$@;\
+		  echo "    .align $(ASM_ALIGN)"			>>$@;\
+		  echo "_fw_$${FWSTR}_name:"				>>$@;\
+		  echo "    .string \"$$FWNAME\""			>>$@;\
+		  echo "    .section .builtin_fw,\"a\",@progbits"	>>$@;\
+		  echo "    .align $(ASM_ALIGN)"			>>$@;\
+		  echo "    $(ASM_WORD) _fw_$${FWSTR}_name" 		>>$@;\
+		  echo "    $(ASM_WORD) _fw_$${FWSTR}_bin" 		>>$@;\
+		  echo "    $(ASM_WORD) _fw_end - _fw_$${FWSTR}_bin"	>>$@;
+
+# One of these files will change, or come into existence, whenever
+# the configuration changes between 32-bit and 64-bit. The .S files
+# need to change when that happens.
+wordsize_deps := $(wildcard include/config/64bit.h include/config/32bit.h \
+		include/config/ppc32.h include/config/ppc64.h \
+		include/config/superh32.h include/config/superh64.h \
+		include/config/x86_32.h include/config/x86_64.h)
+
+# For the $$(dir %) trick, where we need % to be expanded first.
+.SECONDEXPANSION:
+
+$(patsubst %,$(obj)/%.S, $(fw-shipped-y)): %: $(wordsize_deps) \
+		| $(objtree)/$$(dir %)
+	$(call cmd,fwbin,$(patsubst %.S,%,$@))
+$(patsubst %,$(obj)/%.S, $(fw-external-y)): %: $(wordsize_deps) \
+		include/config/builtin/firmware/dir.h | $(objtree)/$$(dir %)
+	$(call cmd,fwbin,$(fwabs)/$(patsubst $(obj)/%.S,%,$@))
+
+# The .o files depend on the binaries directly; the .S files don't.
+$(patsubst %,$(obj)/%.o, $(fw-shipped-y)): %.o: %
+$(patsubst %,$(obj)/%.o, $(fw-external-y)): $(obj)/%.o: $(fwdir)/%
+
+$(obj)/%: $(obj)/%.ihex | $(objtree)/$(obj)/$$(dir %)
+	$(call cmd,ihex)
+
+$(firmware-dirs):
+	$(call cmd,mkdir)
+
+obj-y := $(patsubst %,%.o, $(firmware-y))
+
+# Remove .S files and binaries created from ihex
+# (during 'make clean' .config isn't included so they're all in $(fw-shipped-))
+targets := $(patsubst $(obj)/%,%, $(shell find $(obj) -name \*.S 2>/dev/null))
+targets += $(fw-shipped-)
+
+# Without this, built-in.o won't be created when it's empty, and the
+# final vmlinux link will fail.
+obj-n := dummy


-- 
dwmw2

