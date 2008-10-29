Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbYJ2SEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbYJ2SEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 14:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbYJ2SEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 14:04:25 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:38995 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbYJ2SEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 14:04:23 -0400
Date: Wed, 29 Oct 2008 19:04:20 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [PATCH] [CRIS] Remove links from CRIS build
Message-ID: <20081029180420.GO4608@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the links to architecture and machine dependent directories
(boot, lib, drivers, arch, mach)

The links were created and used mostly from the arch/cris/Makefile,
so why not dispense with them altogether?
Changed $(ARCH) to "cris" in Makefile, it is easier to read this way.

The CRISv32 head.S common files for the kernel and compressed images
needed to be modified to use ifdefs instead of using the now removed
mach link. Since there are only two versions, this is not a huge loss
in readability.

The link to vmlinux.lds.S is also replaced with a merged version
which uses ifdefs to select the correct layout.
System.map before and after are identical.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/Makefile                        |   61 ++++--------
 arch/cris/arch-v10/vmlinux.lds.S          |  118 ----------------------
 arch/cris/arch-v32/boot/compressed/head.S |   16 +++-
 arch/cris/arch-v32/kernel/head.S          |   20 +++-
 arch/cris/arch-v32/vmlinux.lds.S          |  133 -------------------------
 arch/cris/kernel/vmlinux.lds.S            |  151 +++++++++++++++++++++++++++++
 6 files changed, 201 insertions(+), 298 deletions(-)
 delete mode 100644 arch/cris/arch-v10/vmlinux.lds.S
 delete mode 100644 arch/cris/arch-v32/vmlinux.lds.S
 create mode 100644 arch/cris/kernel/vmlinux.lds.S

diff --git a/arch/cris/Makefile b/arch/cris/Makefile
index 241e35b..3662cfb 100644
--- a/arch/cris/Makefile
+++ b/arch/cris/Makefile
@@ -23,7 +23,8 @@ mach-$(CONFIG_ETRAXFS) := fs
 
 ifneq ($(arch-y),)
 SARCH := arch-$(arch-y)
-inc := -Iarch/cris/include/arch-$(arch-y) -Iarch/cris/include/arch-$(arch-y)/arch
+inc := -Iarch/cris/include/$(SARCH)
+inc += -Iarch/cris/include/$(SARCH)/arch
 else
 SARCH :=
 inc :=
@@ -52,72 +53,48 @@ KBUILD_CFLAGS := $(subst -fomit-frame-pointer,,$(KBUILD_CFLAGS)) -g
 KBUILD_CFLAGS += -fno-omit-frame-pointer
 endif
 
-head-y := arch/$(ARCH)/$(SARCH)/kernel/head.o
+head-y := arch/cris/$(SARCH)/kernel/head.o
 
 LIBGCC = $(shell $(CC) $(KBUILD_CFLAGS) -print-file-name=libgcc.a)
 
-core-y		+= arch/$(ARCH)/kernel/ arch/$(ARCH)/mm/
-core-y		+= arch/$(ARCH)/$(SARCH)/kernel/ arch/$(ARCH)/$(SARCH)/mm/
+core-y		+= arch/cris/kernel/ arch/cris/mm/
+core-y		+= arch/cris/$(SARCH)/kernel/ arch/cris/$(SARCH)/mm/
 ifdef CONFIG_ETRAX_ARCH_V32
-core-y		+= arch/$(ARCH)/$(SARCH)/$(MACH)/
+core-y		+= arch/cris/$(SARCH)/$(MACH)/
 endif
-drivers-y	+= arch/$(ARCH)/$(SARCH)/drivers/
-libs-y		+= arch/$(ARCH)/$(SARCH)/lib/ $(LIBGCC)
+drivers-y	+= arch/cris/$(SARCH)/drivers/
+libs-y		+= arch/cris/$(SARCH)/lib/ $(LIBGCC)
 
 # cris source path
-SRC_ARCH              = $(srctree)/arch/$(ARCH)
+SRC_ARCH              = $(srctree)/arch/cris
 # cris object files path
-OBJ_ARCH              = $(objtree)/arch/$(ARCH)
+OBJ_ARCH              = $(objtree)/arch/cris
 
-boot := arch/$(ARCH)/boot
-MACHINE := arch/$(ARCH)/$(SARCH)
+boot := arch/cris/$(SARCH)/boot
+MACHINE := arch/cris/$(SARCH)
 
 all: zImage
 
 zImage Image: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
 
-archprepare: $(SRC_ARCH)/.links FORCE
-
-# Create some links to make all tools happy
-$(SRC_ARCH)/.links:
-	@rm -rf $(SRC_ARCH)/drivers
-	@ln -sfn $(SARCH)/drivers $(SRC_ARCH)/drivers
-	@rm -rf $(SRC_ARCH)/boot
-	@ln -sfn $(SARCH)/boot $(SRC_ARCH)/boot
-	@rm -rf $(SRC_ARCH)/lib
-	@ln -sfn $(SARCH)/lib $(SRC_ARCH)/lib
-	@rm -f $(SRC_ARCH)/arch/mach
-	@rm -rf $(SRC_ARCH)/arch
-	@ln -sfn $(SARCH) $(SRC_ARCH)/arch
-ifdef CONFIG_ETRAX_ARCH_V32
-	@ln -sfn ../$(SARCH)/$(MACH) $(SRC_ARCH)/arch/mach
-endif
-	@rm -rf $(SRC_ARCH)/kernel/vmlinux.lds.S
-	@ln -sfn ../$(SARCH)/vmlinux.lds.S $(SRC_ARCH)/kernel/vmlinux.lds.S
-	@touch $@
+archprepare:
 
 archclean:
-	$(Q)if [ -e arch/$(ARCH)/boot ]; then \
-		$(MAKE) $(clean)=arch/$(ARCH)/boot; \
+	$(Q)if [ -e arch/cris/$(SARCH)/boot ]; then \
+		$(MAKE) $(clean)=arch/cris/$(SARCH)/boot; \
 	fi
 
 CLEAN_FILES += \
 	$(MACHINE)/boot/zImage \
 	$(MACHINE)/boot/compressed/decompress.bin \
 	$(MACHINE)/boot/compressed/piggy.gz \
-	$(MACHINE)/boot/rescue/rescue.bin \
-	$(SRC_ARCH)/.links
+	$(MACHINE)/boot/rescue/rescue.bin
 
-MRPROPER_FILES += \
-	$(SRC_ARCH)/drivers \
-	$(SRC_ARCH)/boot \
-	$(SRC_ARCH)/lib \
-	$(SRC_ARCH)/arch \
-	$(SRC_ARCH)/kernel/vmlinux.lds.S
 
+# MRPROPER_FILES +=
 
 define archhelp
-  echo  '* zImage        - Compressed kernel image (arch/$(ARCH)/boot/zImage)'
-  echo  '* Image         - Uncompressed kernel image (arch/$(ARCH)/boot/Image)'
+  echo  '* zImage        - Compressed kernel image (arch/cris/boot/zImage)'
+  echo  '* Image         - Uncompressed kernel image (arch/cris/boot/Image)'
 endef
diff --git a/arch/cris/arch-v10/vmlinux.lds.S b/arch/cris/arch-v10/vmlinux.lds.S
deleted file mode 100644
index 93c9f0e..0000000
--- a/arch/cris/arch-v10/vmlinux.lds.S
+++ /dev/null
@@ -1,118 +0,0 @@
-/* ld script to make the Linux/CRIS kernel
- * Authors: Bjorn Wesen (bjornw@axis.com)
- *
- * It is VERY DANGEROUS to fiddle around with the symbols in this
- * script. It is for example quite vital that all generated sections
- * that are used are actually named here, otherwise the linker will
- * put them at the end, where the init stuff is which is FREED after
- * the kernel has booted. 
- */	
-
-#include <asm-generic/vmlinux.lds.h>
-#include <asm/page.h>
-
-jiffies = jiffies_64;
-SECTIONS
-{
-	. = DRAM_VIRTUAL_BASE;
-	dram_start = .;
-	ibr_start = .;
-	. = . + 0x4000; /* see head.S and pages reserved at the start */
-
-	_text = .;                    /* Text and read-only data */
-	text_start = .;              /* lots of aliases */
-	_stext = .;
-	__stext = .;
-	.text : {
-		TEXT_TEXT
-		SCHED_TEXT
-		LOCK_TEXT
-		*(.fixup)
-		*(.text.__*)
-	}
-
-	_etext = . ;                  /* End of text section */ 
-	__etext = .;
-
-	. = ALIGN(4);                /* Exception table */
-  	__start___ex_table = .;
-  	__ex_table : { *(__ex_table) }
-  	__stop___ex_table = .;
-
-	RODATA
-
-	. = ALIGN (4);
-	___data_start = . ;
-	__Sdata = . ;
-	.data : {                     /* Data */
-		DATA_DATA
-	}
-	__edata = . ;                 /* End of data section */
-	_edata = . ;
-
-	. = ALIGN(PAGE_SIZE);	/* init_task and stack, must be aligned */
-  	.data.init_task : { *(.data.init_task) }
-
-	. = ALIGN(PAGE_SIZE);	/* Init code and data */
-  	__init_begin = .;
-	.init.text : { 
-		   _sinittext = .;
-		   INIT_TEXT
-		   _einittext = .;
-	}
-	.init.data : { INIT_DATA }
-  	. = ALIGN(16);
-  	__setup_start = .;
-  	.init.setup : { *(.init.setup) }
-  	__setup_end = .;
-  	.initcall.init : {
-		__initcall_start = .;
-		INITCALLS
-		__initcall_end = .;	
-	}
-
-	.con_initcall.init : {
-		__con_initcall_start = .;
-		*(.con_initcall.init)
-		__con_initcall_end = .;
-	}	
-	SECURITY_INIT
-
-#ifdef CONFIG_BLK_DEV_INITRD
-	.init.ramfs : {
-		__initramfs_start = .;
-		*(.init.ramfs)
-		__initramfs_end = .;
-	}
-#endif
-	__vmlinux_end = .;            /* last address of the physical file */
-
-	/*
-	 * We fill to the next page, so we can discard all init
-	 * pages without needing to consider what payload might be
-	 * appended to the kernel image.
-	 */
-	. = ALIGN(PAGE_SIZE);
-
-	__init_end = .;
-
-	__data_end = . ;              /* Move to _edata ? */
-	__bss_start = .;              /* BSS */
-	.bss : {
-		*(COMMON)
-		*(.bss)
-	}
-
-	. =  ALIGN (0x20);
-	_end = .;
-	__end = .;
-
-	/* Sections to be discarded */
-  	/DISCARD/ : {
-		EXIT_TEXT
-		EXIT_DATA
-		*(.exitcall.exit)
-        }
-
-	dram_end = dram_start + CONFIG_ETRAX_DRAM_SIZE*1024*1024;
-}
diff --git a/arch/cris/arch-v32/boot/compressed/head.S b/arch/cris/arch-v32/boot/compressed/head.S
index ea30129..a4a65c5 100644
--- a/arch/cris/arch-v32/boot/compressed/head.S
+++ b/arch/cris/arch-v32/boot/compressed/head.S
@@ -28,7 +28,13 @@ _start:
 	beq	dram_init_finished
 	nop
 
-#include "../../mach/dram_init.S"
+#if defined CONFIG_ETRAXFS
+#include "../../mach-fs/dram_init.S"
+#elif defined CONFIG_CRIS_MACH_ARTPEC3
+#include "../../mach-a3/dram_init.S"
+#else
+#error Only ETRAXFS and ARTPEC-3 supported!
+#endif
 
 dram_init_finished:
 
@@ -130,4 +136,10 @@ _cmd_line_addr:
 _boot_source:
 	.dword 0
 
-#include "../../mach/hw_settings.S"
+#if defined CONFIG_ETRAXFS
+#include "../../mach-fs/hw_settings.S"
+#elif defined CONFIG_CRIS_MACH_ARTPEC3
+#include "../../mach-a3/hw_settings.S"
+#else
+#error Only ETRAXFS and ARTPEC-3 supported!
+#endif
diff --git a/arch/cris/arch-v32/kernel/head.S b/arch/cris/arch-v32/kernel/head.S
index f902d87..3db478e 100644
--- a/arch/cris/arch-v32/kernel/head.S
+++ b/arch/cris/arch-v32/kernel/head.S
@@ -10,8 +10,9 @@
  * The macros found in mmu_defs_asm.h uses the ## concatenation operator, so
  * -traditional must not be used when assembling this file.
  */
-#include <hwregs/reg_rdwr.h>
+#include <linux/autoconf.h>
 #include <arch/memmap.h>
+#include <hwregs/reg_rdwr.h>
 #include <hwregs/intr_vect.h>
 #include <hwregs/asm/mmu_defs_asm.h>
 #include <hwregs/asm/reg_map_asm.h>
@@ -217,7 +218,14 @@ _inflash:
 	beq	_dram_initialized
 	nop
 
-#include "../mach/dram_init.S"
+#if defined CONFIG_ETRAXFS
+#include "../mach-fs/dram_init.S"
+#elif defined CONFIG_CRIS_MACH_ARTPEC3
+#include "../mach-a3/dram_init.S"
+#else
+#error Only ETRAXFS and ARTPEC-3 supported!
+#endif
+
 
 _dram_initialized:
 	;; Copy the text and data section to DRAM. This depends on that the
@@ -472,4 +480,10 @@ swapper_pg_dir = 0xc0002000
 
 	.section ".init.data", "aw"
 
-#include "../mach/hw_settings.S"
+#if defined CONFIG_ETRAXFS
+#include "../mach-fs/hw_settings.S"
+#elif defined CONFIG_CRIS_MACH_ARTPEC3
+#include "../mach-a3/hw_settings.S"
+#else
+#error Only ETRAXFS and ARTPEC-3 supported!
+#endif
diff --git a/arch/cris/arch-v32/vmlinux.lds.S b/arch/cris/arch-v32/vmlinux.lds.S
deleted file mode 100644
index d5f28e4..0000000
--- a/arch/cris/arch-v32/vmlinux.lds.S
+++ /dev/null
@@ -1,133 +0,0 @@
-/* ld script to make the Linux/CRIS kernel
- * Authors: Bjorn Wesen (bjornw@axis.com)
- *
- * It is VERY DANGEROUS to fiddle around with the symbols in this
- * script. It is for example quite vital that all generated sections
- * that are used are actually named here, otherwise the linker will
- * put them at the end, where the init stuff is which is FREED after
- * the kernel has booted.
- */
-
-#include <asm-generic/vmlinux.lds.h>
-#include <asm/page.h>
-
-#ifdef CONFIG_ETRAX_VMEM_SIZE
-#define __CONFIG_ETRAX_VMEM_SIZE CONFIG_ETRAX_VMEM_SIZE
-#else
-#define __CONFIG_ETRAX_VMEM_SIZE 0
-#endif
-
-jiffies = jiffies_64;
-SECTIONS
-{
-	. = DRAM_VIRTUAL_BASE;
-	dram_start = .;
-	ebp_start = .;
-
-	/* The boot section is only necessary until the VCS top */
-	/* level testbench includes both flash and DRAM. */
-	.boot : { *(.boot) }
-
-	/* See head.S and pages reserved at the start. */
-	. = DRAM_VIRTUAL_BASE + 0x4000;
-
-	_text = .;		/* Text and read-only data. */
-	text_start = .;		/* Lots of aliases. */
-	_stext = .;
-	__stext = .;
-	.text : {
-		TEXT_TEXT
-		SCHED_TEXT
-		LOCK_TEXT
-		*(.fixup)
-		*(.text.__*)
-	}
-
-	_etext = . ;		/* End of text section. */
-	__etext = .;
-
-	. = ALIGN(4);		/* Exception table. */
-	__start___ex_table = .;
-	__ex_table : { *(__ex_table) }
-	__stop___ex_table = .;
-
-	RODATA
-
-	. = ALIGN (4);
-	___data_start = . ;
-	__Sdata = . ;
-	.data : {                     /* Data */
-		DATA_DATA
-	}
-	__edata = . ;		/* End of data section. */
-	_edata = . ;
-
-	. = ALIGN(PAGE_SIZE);	/* init_task and stack, must be aligned. */
-	.data.init_task : { *(.data.init_task) }
-
-	. = ALIGN(PAGE_SIZE);	/* Init code and data. */
-	__init_begin = .;
-	.init.text : {
-		   _sinittext = .;
-		   INIT_TEXT
-		   _einittext = .;
-	}
-	.init.data : { INIT_DATA }
-	. = ALIGN(16);
-	__setup_start = .;
-	.init.setup : { *(.init.setup) }
-	__setup_end = .;
-	__start___param = .;
-	__param : { *(__param) }
-	__stop___param = .;
-	.initcall.init : {
-		__initcall_start = .;
-		INITCALLS
-		__initcall_end = .;
-	}
-
-	.con_initcall.init : {
-		__con_initcall_start = .;
-		*(.con_initcall.init)
-		__con_initcall_end = .;
-	}
-	SECURITY_INIT
-
-	__vmlinux_end = .;	/* Last address of the physical file. */
-	PERCPU(PAGE_SIZE)
-
-	.init.ramfs : {
-		__initramfs_start = .;
-		*(.init.ramfs)
-		__initramfs_end = .;
-	}
-
-	/*
-	 * We fill to the next page, so we can discard all init
-	 * pages without needing to consider what payload might be
-	 * appended to the kernel image.
-	 */
-	. = ALIGN (PAGE_SIZE);
-
-	__init_end = .;
-
-	__data_end = . ;	/* Move to _edata? */
-	__bss_start = .;	/* BSS. */
-	.bss : {
-		*(COMMON)
-		*(.bss)
-	}
-
-	. =  ALIGN (0x20);
-	_end = .;
-	__end = .;
-
-	/* Sections to be discarded */
-	/DISCARD/ : {
-		EXIT_TEXT
-		EXIT_DATA
-		*(.exitcall.exit)
-        }
-
-	dram_end = dram_start + (CONFIG_ETRAX_DRAM_SIZE - __CONFIG_ETRAX_VMEM_SIZE)*1024*1024;
-}
diff --git a/arch/cris/kernel/vmlinux.lds.S b/arch/cris/kernel/vmlinux.lds.S
new file mode 100644
index 0000000..0d2adfc
--- /dev/null
+++ b/arch/cris/kernel/vmlinux.lds.S
@@ -0,0 +1,151 @@
+/* ld script to make the Linux/CRIS kernel
+ * Authors: Bjorn Wesen (bjornw@axis.com)
+ *
+ * It is VERY DANGEROUS to fiddle around with the symbols in this
+ * script. It is for example quite vital that all generated sections
+ * that are used are actually named here, otherwise the linker will
+ * put them at the end, where the init stuff is which is FREED after
+ * the kernel has booted.
+ */
+
+#include <linux/autoconf.h>
+#include <asm-generic/vmlinux.lds.h>
+#include <asm/page.h>
+
+#ifdef CONFIG_ETRAX_VMEM_SIZE
+#define __CONFIG_ETRAX_VMEM_SIZE CONFIG_ETRAX_VMEM_SIZE
+#else
+#define __CONFIG_ETRAX_VMEM_SIZE 0
+#endif
+
+
+jiffies = jiffies_64;
+SECTIONS
+{
+	. = DRAM_VIRTUAL_BASE;
+	dram_start = .;
+#ifdef CONFIG_ETRAX_ARCH_V10
+	ibr_start = .;
+#else
+	ebp_start = .;
+	/* The boot section is only necessary until the VCS top */
+	/* level testbench includes both flash and DRAM. */
+	.boot : { *(.boot) }
+#endif
+
+	/* see head.S and pages reserved at the start */
+	. = DRAM_VIRTUAL_BASE + 0x4000;
+
+	_text = .;			/* Text and read-only data. */
+	text_start = .;			/* Lots of aliases. */
+	_stext = .;
+	__stext = .;
+	.text : {
+		TEXT_TEXT
+		SCHED_TEXT
+		LOCK_TEXT
+		*(.fixup)
+		*(.text.__*)
+	}
+
+	_etext = . ;			/* End of text section. */
+	__etext = .;
+
+	. = ALIGN(4);			/* Exception table. */
+	__start___ex_table = .;
+	__ex_table : { *(__ex_table) }
+	__stop___ex_table = .;
+
+	RODATA
+
+	. = ALIGN (4);
+	___data_start = . ;
+	__Sdata = . ;
+	.data : {			/* Data */
+		DATA_DATA
+	}
+	__edata = . ;			/* End of data section. */
+	_edata = . ;
+
+	. = ALIGN(PAGE_SIZE);	/* init_task and stack, must be aligned. */
+	.data.init_task : { *(.data.init_task) }
+
+	. = ALIGN(PAGE_SIZE);		/* Init code and data. */
+	__init_begin = .;
+	.init.text : {
+		   _sinittext = .;
+		   INIT_TEXT
+		   _einittext = .;
+	}
+	.init.data : { INIT_DATA }
+	. = ALIGN(16);
+	__setup_start = .;
+	.init.setup : { *(.init.setup) }
+	__setup_end = .;
+#ifdef CONFIG_ETRAX_ARCH_V32
+	__start___param = .;
+	__param : { *(__param) }
+	__stop___param = .;
+#endif
+	.initcall.init : {
+		__initcall_start = .;
+		INITCALLS
+		__initcall_end = .;
+	}
+
+	.con_initcall.init : {
+		__con_initcall_start = .;
+		*(.con_initcall.init)
+		__con_initcall_end = .;
+	}
+	SECURITY_INIT
+
+#ifdef CONFIG_ETRAX_ARCH_V10
+#ifdef CONFIG_BLK_DEV_INITRD
+	.init.ramfs : {
+		__initramfs_start = .;
+		*(.init.ramfs)
+		__initramfs_end = .;
+	}
+#endif
+#endif
+	__vmlinux_end = .;		/* Last address of the physical file. */
+#ifdef CONFIG_ETRAX_ARCH_V32
+	PERCPU(PAGE_SIZE)
+
+	.init.ramfs : {
+		__initramfs_start = .;
+		*(.init.ramfs)
+		__initramfs_end = .;
+	}
+#endif
+
+	/*
+	 * We fill to the next page, so we can discard all init
+	 * pages without needing to consider what payload might be
+	 * appended to the kernel image.
+	 */
+	. = ALIGN(PAGE_SIZE);
+
+	__init_end = .;
+
+	__data_end = . ;		/* Move to _edata ? */
+	__bss_start = .;		/* BSS. */
+	.bss : {
+		*(COMMON)
+		*(.bss)
+	}
+
+	. =  ALIGN (0x20);
+	_end = .;
+	__end = .;
+
+	/* Sections to be discarded */
+	/DISCARD/ : {
+		EXIT_TEXT
+		EXIT_DATA
+		*(.exitcall.exit)
+        }
+
+	dram_end = dram_start + (CONFIG_ETRAX_DRAM_SIZE - __CONFIG_ETRAX_VMEM_SIZE)*1024*1024;
+}
-- 
1.5.6.5


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
