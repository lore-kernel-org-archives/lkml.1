Return-Path: <linux-kernel-owner+w=401wt.eu-S1761981AbZENNHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761981AbZENNHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761986AbZENNGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:06:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:41815 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761682AbZENNGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:06:53 -0400
X-Sieve: CMU Sieve 2.2
From: Petr Tesarik <ptesarik@suse.cz>
To: linux-kernel@vger.kernel.org, linux-x86_64@vger.kernel.org, mingo@elte.hu,
       andi@firstfloor.org
Cc: zwane@arm.linux.org.uk, roland@redhat.com, Petr Tesarik <ptesarik@suse.cz>
Message-Id: <7921ac39159b69e2154857655259c7bb6d4589cc.1242299014.git.ptesarik@suse.cz>
In-Reply-To: <2bc7564b5c902a0ebabd5ab652b12c1ffa4214eb.1242299014.git.ptesarik@suse.cz>
References: <cover.1242299014.git.ptesarik@suse.cz>
	 <f249c3f58a699ce72b6cb416ddff98811848ff6f.1242299014.git.ptesarik@suse.cz>
	 <2bc7564b5c902a0ebabd5ab652b12c1ffa4214eb.1242299014.git.ptesarik@suse.cz>
In-Reply-To: <cover.1242299014.git.ptesarik@suse.cz>
References: <cover.1242299014.git.ptesarik@suse.cz>
Subject: [PATCH 3/4] x86-64: link vDSO into the kernel with relocations
Organization: SUSE LINUX
Date: Thu, 14 May 2009 15:06:53 +0200
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preserve relocation info about the sections in the vDSO.
This is achieved by linking the vDSO twice.

First link produces a complete vdso.so as seen by user-space.
This image is used to:

 - determine the final layout of the vDSO
   (extracted by nm to vdso-syms.h)
 - obtain the ELF headers and linker-generated sections
   (copied by the assembler .incbin directive to .vdso_head and
    .vdso_tail sections of vdso-parts.o)

The second link combines the head and tail portions with the
rodata, data and text sections of the object which make up the vDSO,
but doesn't produce a shared library, but a relocatable object for
further linking.

Advantages of this approach:

 1. No run-time bloat. All that can be done at link time is done
    at link time.
 2. No user-space bloat. Only those sections which are needed by
    user-space are mapped into the process space.
 3. Possibility to re-use the technique for more general linking,
    e.g. get rid of VMAGIC and run-time vDSO "resolving" of vDSO
    variables in init_vdso_vars().

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/vdso/.gitignore        |    1 +
 arch/x86/vdso/Makefile          |   25 ++++++++++----
 arch/x86/vdso/vdso-layout.lds.S |   16 +++++++++
 arch/x86/vdso/vdso-parts.S      |    7 ++++
 arch/x86/vdso/vdso-reloc.lds.S  |   66 +++++++++++++++++++++++++++++++++++++++
 arch/x86/vdso/vdso.S            |   10 ------
 arch/x86/vdso/vdso.lds.S        |    1 +
 7 files changed, 109 insertions(+), 17 deletions(-)
 create mode 100644 arch/x86/vdso/vdso-parts.S
 create mode 100644 arch/x86/vdso/vdso-reloc.lds.S
 delete mode 100644 arch/x86/vdso/vdso.S

diff --git a/arch/x86/vdso/.gitignore b/arch/x86/vdso/.gitignore
index 6ac0a86..9d887a8 100644
--- a/arch/x86/vdso/.gitignore
+++ b/arch/x86/vdso/.gitignore
@@ -1,4 +1,5 @@
 vdso.lds
+vdso-reloc.lds
 vdso-syms.h
 vdso32-syms.h
 vdso32-syscall-syms.h
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 550dca0..194db49 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -19,17 +19,17 @@ obj-$(VDSO32-y)			+= vdso32.o vdso32-setup.o
 
 vobjs := $(foreach F,$(vobjs-y),$(obj)/$F)
 
-$(obj)/vdso.o: $(obj)/vdso.so
+#
+# Rules for the vDSO as visible to user-space
+#
 
 targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y)
 
 export CPPFLAGS_vdso.lds += -P -C
 
-VDSO_LDFLAGS_vdso.lds = -m elf_x86_64 -Wl,-soname=linux-vdso.so.1 \
+VDSO_LDFLAGS_vdso.lds = -shared -m elf_x86_64 -Wl,-soname=linux-vdso.so.1 \
 		      	-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
 
-$(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
-
 $(obj)/vdso.so.dbg: $(src)/vdso.lds $(vobjs) FORCE
 	$(call if_changed,vdso)
 
@@ -42,9 +42,20 @@ CFL := $(PROFILING) -mcmodel=small -fPIC -O2 -fasynchronous-unwind-tables -m64 \
 
 $(vobjs): KBUILD_CFLAGS += $(CFL)
 
-targets += vdso-syms.h
+#
+# Rules for the vDSO as linked into the kernel
+#
+
+targets += vdso-syms.h vdso-parts.o vdso-reloc.lds
+
+$(obj)/vdso-parts.o: $(obj)/vdso-syms.h $(obj)/vdso.so
 $(obj)/vma.o: $(obj)/vdso-syms.h
 
+export CPPFLAGS_vdso-reloc.lds += -P -C
+VDSO_LDFLAGS_vdso.o = -r -m elf_x86_64
+$(obj)/vdso.o: $(src)/vdso-reloc.lds $(vobjs) $(obj)/vdso-parts.o
+	$(call if_changed,vdso)
+
 #
 # Match symbols in the DSO that look like VDSO*; produce a file of constants.
 #
@@ -68,7 +79,7 @@ vdso32.so-$(VDSO32-y)		+= sysenter
 vdso32-images			= $(vdso32.so-y:%=vdso32-%.so)
 
 CPPFLAGS_vdso32.lds = $(CPPFLAGS_vdso.lds)
-VDSO_LDFLAGS_vdso32.lds = -m elf_i386 -Wl,-soname=linux-gate.so.1
+VDSO_LDFLAGS_vdso32.lds = -shared -m elf_i386 -Wl,-soname=linux-gate.so.1
 
 # This makes sure the $(obj) subdirectory exists even though vdso32/
 # is not a kbuild sub-make subdirectory.
@@ -122,7 +133,7 @@ quiet_cmd_vdso = VDSO    $@
 		       $(VDSO_LDFLAGS) $(VDSO_LDFLAGS_$(filter %.lds,$(^F))) \
 		       -Wl,-T,$(filter %.lds,$^) $(filter %.o,$^)
 
-VDSO_LDFLAGS = -fPIC -shared $(call ld-option, -Wl$(comma)--hash-style=sysv)
+VDSO_LDFLAGS = -fPIC $(call ld-option, -Wl$(comma)--hash-style=sysv)
 
 #
 # Install the unstripped copy of vdso*.so listed in $(vdso-install-y).
diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index aaa3026..c2c6aef 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -4,6 +4,12 @@
  * This script controls its layout.
  */
 
+#ifdef VDSO_MARK_SECTIONS
+# define MARK(sym)	VDSO_ ## sym = .;
+#else
+# define MARK(sym)
+#endif
+
 SECTIONS
 {
 	. = VDSO_PRELINK + SIZEOF_HEADERS;
@@ -27,17 +33,25 @@ SECTIONS
 	.got.plt	: { *(.got.plt) }
 	.dynbss		: { *(.dynbss) }
 
+	/* IMPORTANT
+	 * If you change the link order here, make sure you also
+	 * reflect your changes in vdso-reloc.lds.S.
+	 */
 	.rodata		: {
+	      MARK(rodata_start)
 	      *(.rodata*)
 	      *(.gnu.linkonce.r.*)
+	      MARK(rodata_end)
 	}
 	.data		: {
+	      MARK(data_start)
 	      *(.data*)
 	      *(.sdata*)
 	      *(.gnu.linkonce.d.*)
 	      *(.bss*)
 	      *(.sbss*)
 	      *(.gnu.linkonce.b.*)
+	      MARK(data_end)
 	}
 
 	/*
@@ -47,8 +61,10 @@ SECTIONS
 	. = ALIGN(0x100);
 
 	.text		: {
+	      MARK(text_start)
 	      *(.text*)
 	      *(.gnu.linkonce.t.*)
+	      MARK(text_end)
 	}						:text	=0x90909090
 
 	/DISCARD/ : {
diff --git a/arch/x86/vdso/vdso-parts.S b/arch/x86/vdso/vdso-parts.S
new file mode 100644
index 0000000..6c34c5e
--- /dev/null
+++ b/arch/x86/vdso/vdso-parts.S
@@ -0,0 +1,7 @@
+#include "vdso-syms.h"
+
+	.section .vdso_head,"a"
+	.incbin "arch/x86/vdso/vdso.so", 0, VDSO_rodata_start-VDSO64_PRELINK
+
+	.section .vdso_tail,"a"
+	.incbin "arch/x86/vdso/vdso.so", VDSO_text_end-VDSO64_PRELINK
diff --git a/arch/x86/vdso/vdso-reloc.lds.S b/arch/x86/vdso/vdso-reloc.lds.S
new file mode 100644
index 0000000..44e0fb5
--- /dev/null
+++ b/arch/x86/vdso/vdso-reloc.lds.S
@@ -0,0 +1,66 @@
+#include "vdso-syms.h"
+
+#define STRINGIFY(x)	#x
+
+/* Choose a name which is not a valid C identifier to prevent conflicts */
+#define MARKER(sym)	STRINGIFY(.vdso. ## sym)
+
+/* Saved value from vdso-syms.h */
+#define VDSOSYM(sym)	(VDSO_ ## sym - VDSO64_PRELINK)
+
+/* Older binutils do not allow ASSERT() inside SECTIONS, so we must
+ * save the current pointer and check it later at file level.
+ */
+#define MARK(sym)	MARKER(sym) = .;
+#define CHECK(sym) \
+	ASSERT(VDSOSYM(sym) == MARKER(sym) - vdso_start, \
+		STRINGIFY(sym in kernel does not match the pre-linked image))
+
+SECTIONS {
+	.init.data	: {
+	      FILL(0);
+
+	      vdso_start = .;
+	      *(.vdso_head)
+
+	/* .rodata */
+	      MARK(rodata_start)
+	      *(.rodata*)
+	      *(.gnu.linkonce.r.*)
+	      MARK(rodata_end)
+
+	/* .data */
+	      MARK(data_start)
+	      *(.data*)
+	      *(.sdata*)
+	      *(.gnu.linkonce.d.*)
+	      *(.bss*)
+	      *(.sbss*)
+	      *(.gnu.linkonce.b.*)
+	      MARK(data_end)
+
+	/* .text */
+	      . = ALIGN(. - vdso_start,0x100);
+	      FILL(0x90909090);
+	      MARK(text_start)
+	      *(.text*)
+	      *(.gnu.linkonce.t.*)
+	      MARK(text_end)
+
+	      *(.vdso_tail)
+	      vdso_end = .;
+	}						=0x90909090
+
+	.altinstructions	: { *(.altinstructions) }
+	.altinstr_replacement	: { *(.altinstr_replacement) }
+
+	/* The custom vDSO note section is not understood in vmlinux */
+	/DISCARD/		: { *(.note.Linux) }
+}
+
+CHECK(rodata_start)
+CHECK(rodata_end)
+CHECK(data_start)
+CHECK(data_end)
+CHECK(text_start)
+CHECK(text_end)
diff --git a/arch/x86/vdso/vdso.S b/arch/x86/vdso/vdso.S
deleted file mode 100644
index 1d3aa6b..0000000
--- a/arch/x86/vdso/vdso.S
+++ /dev/null
@@ -1,10 +0,0 @@
-#include <linux/init.h>
-
-__INITDATA
-
-	.globl vdso_start, vdso_end
-vdso_start:
-	.incbin "arch/x86/vdso/vdso.so"
-vdso_end:
-
-__FINIT
diff --git a/arch/x86/vdso/vdso.lds.S b/arch/x86/vdso/vdso.lds.S
index 4e5dd3b..d5cf24f 100644
--- a/arch/x86/vdso/vdso.lds.S
+++ b/arch/x86/vdso/vdso.lds.S
@@ -9,6 +9,7 @@
  */
 
 #define VDSO_PRELINK 0xffffffffff700000
+#define VDSO_MARK_SECTIONS 1
 #include "vdso-layout.lds.S"
 
 /*
-- 
1.6.0.2


