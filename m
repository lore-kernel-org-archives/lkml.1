Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab0BST3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:29:12 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:45459 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab0BST3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:29:08 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC/PATCH 6/7] arm/devicetree: Allow .dtb to be carried in the
	zImage payload
To: linux@arm.linux.org.uk, catalin.marinas@arm.com, jeremy.kerr@canonical.com,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: tim.bird@am.sony.com
Date: Fri, 19 Feb 2010 12:29:00 -0700
Message-ID: <20100219192805.15318.23437.stgit@angua>
In-Reply-To: <20100219185953.15318.4850.stgit@angua>
References: <20100219185953.15318.4850.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows a device tree blob to be linked into the zImage
executable to be passed into the kernel via an ATAG.  The kernel
can either use the linked in .dtb, or override it with a .dtb
passed in by firmware.

This patch doesn't handle relocation correctly yet.  Not ready to be merged
---

 arch/arm/Kconfig                        |   13 +++++++++++++
 arch/arm/boot/compressed/Makefile       |   23 ++++++++++++++++++++---
 arch/arm/boot/compressed/head.S         |   10 ++++++++++
 arch/arm/boot/compressed/misc.c         |   30 ++++++++++++++++++++++++++++++
 arch/arm/boot/compressed/piggy.dtb.S    |    6 ++++++
 arch/arm/boot/compressed/vmlinux.lds.in |    2 ++
 6 files changed, 81 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/boot/compressed/piggy.dtb.S

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 50eea35..fa957c8 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1272,6 +1272,19 @@ config PROC_DEVICETREE
 	  an image of the device tree that the kernel copies from Open
 	  Firmware or other boot firmware. If unsure, say Y here.
 
+config FDT_LINKED_INTO_ZIMAGE
+	bool "Link a flattened device tree blob into the kernel image"
+	select DTC
+	depends on OF_FLATTREE
+
+config FDT_SOURCE
+	string "Flattened Device Tree source filename"
+	depends on FDT_LINKED_INTO_ZIMAGE
+	default "board.dts"
+
+config DTC
+	bool
+
 # Compressed boot loader in ROM.  Yes, we really want to ask about
 # TEXT and BSS so we preserve their values in the config files.
 config ZBOOT_ROM_TEXT
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 2d4d88b..558b31f 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -66,8 +66,13 @@ SEDFLAGS	= s/TEXT_START/$(ZTEXTADDR)/;s/BSS_START/$(ZBSSADDR)/
 suffix_$(CONFIG_KERNEL_GZIP) = gzip
 suffix_$(CONFIG_KERNEL_LZO)  = lzo
 
-targets       := vmlinux vmlinux.lds \
-		 piggy.$(suffix_y) piggy.$(suffix_y).o \
+# Payload objects
+OBJS	+= piggy.$(suffix_y).o
+ifeq ($(CONFIG_FDT_LINKED_INTO_ZIMAGE),y)
+OBJS	+= piggy.dtb.o
+endif
+
+targets       := vmlinux vmlinux.lds piggy.$(suffix_y) \
 		 font.o font.c head.o misc.o $(OBJS)
 
 ifeq ($(CONFIG_FUNCTION_TRACER),y)
@@ -110,7 +115,7 @@ $(obj)/lib1funcs.S: $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.S FORCE
 # would otherwise mess up our GOT table
 CFLAGS_misc.o := -Dstatic=
 
-$(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD) $(obj)/piggy.$(suffix_y).o \
+$(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD) \
 	 	$(addprefix $(obj)/, $(OBJS)) $(lib1funcs) FORCE
 	$(call if_changed,ld)
 	@:
@@ -127,3 +132,15 @@ $(obj)/font.c: $(FONTC)
 
 $(obj)/vmlinux.lds: $(obj)/vmlinux.lds.in arch/arm/boot/Makefile .config
 	@sed "$(SEDFLAGS)" < $< > $@
+
+# Rule to build device tree blobs
+
+DTC = $(objtree)/scripts/dtc/dtc
+
+$(obj)/piggy.dts: $(obj)/../$(subst ",,$(CONFIG_FDT_SOURCE))
+	cp $< $@
+
+$(obj)/piggy.dtb.o: $(obj)/piggy.dtb
+
+$(obj)/%.dtb: $(obj)/%.dts
+	$(DTC) -O dtb -o $(obj)/$*.dtb -b 0 $(DTS_FLAGS) $(obj)/$*.dts
diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 4fddc50..820e0e1 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -240,6 +240,16 @@ not_relocated:	mov	r0, #0
 		 */
 		bl	cache_on
 
+#if defined(CONFIG_FDT_LINKED_INTO_ZIMAGE)
+/*
+ * Graft device tree pointer onto the end of the ATAGs list
+ * r0    = atags pointer
+ * r1-r3 = unused
+ */
+		mov	r0, r8			@ Pass atags pointer
+		bl	graft_devicetree_atag
+#endif
+
 		mov	r1, sp			@ malloc space above stack
 		add	r2, sp, #0x10000	@ 64k max
 
diff --git a/arch/arm/boot/compressed/misc.c b/arch/arm/boot/compressed/misc.c
index 56a0d11..694a541 100644
--- a/arch/arm/boot/compressed/misc.c
+++ b/arch/arm/boot/compressed/misc.c
@@ -27,6 +27,7 @@ unsigned int __machine_arch_type;
 #include <linux/linkage.h>
 
 #include <asm/unaligned.h>
+#include <asm/setup.h>
 
 #ifdef STANDALONE_DEBUG
 #define putstr printf
@@ -272,6 +273,35 @@ asmlinkage void __div0(void)
 	error("Attempting division by 0!");
 }
 
+#if defined(CONFIG_FDT_LINKED_INTO_ZIMAGE)
+extern char dtb_data[];
+extern char dtb_data_end[];
+
+void graft_devicetree_atag(unsigned long atag_list)
+{
+	struct tag *tag;
+
+	/* Loop over ATAG list and find the end.  If a devicetree tag
+	 * already exists, then just bail */
+	for_each_tag(tag, (void *)atag_list) {
+		if (tag->hdr.tag == ATAG_DEVTREE)
+			return;
+	}
+
+	/* Replace the end of the list with an ATAG_DEVTREE */
+	putstr("Appending device tree tag\n");
+	tag->hdr.size = tag_size(tag_devtree);
+	tag->hdr.tag = ATAG_DEVTREE;
+	tag->u.devtree.start = (__u32)dtb_data;
+	tag->u.devtree.size = (__u32)dtb_data_end - (__u32)dtb_data;
+
+	/* And create a new ATAG_NONE tag after it */
+	tag = tag_next(tag);
+	tag->hdr.size = 0;
+	tag->hdr.tag = ATAG_NONE;
+}
+#endif
+
 #ifndef STANDALONE_DEBUG
 
 unsigned long
diff --git a/arch/arm/boot/compressed/piggy.dtb.S b/arch/arm/boot/compressed/piggy.dtb.S
new file mode 100644
index 0000000..822337f
--- /dev/null
+++ b/arch/arm/boot/compressed/piggy.dtb.S
@@ -0,0 +1,6 @@
+	.section .piggydtb,#alloc
+	.globl	dtb_data
+dtb_data:
+	.incbin	"arch/arm/boot/compressed/piggy.dtb"
+	.globl	dtb_data_end
+dtb_data_end:
diff --git a/arch/arm/boot/compressed/vmlinux.lds.in b/arch/arm/boot/compressed/vmlinux.lds.in
index a5924b9..7f50b64 100644
--- a/arch/arm/boot/compressed/vmlinux.lds.in
+++ b/arch/arm/boot/compressed/vmlinux.lds.in
@@ -30,6 +30,8 @@ SECTIONS
     *(.rodata.*)
     *(.glue_7)
     *(.glue_7t)
+    . = ALIGN(4096); /* Page aligned DTBs can be directly used by the kernel */
+    *(.piggydtb)
     *(.piggydata)
     . = ALIGN(4);
   }

