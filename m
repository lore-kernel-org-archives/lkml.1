Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbXKSWGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbXKSWGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbXKSWF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:05:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbXKSWFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:05:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 07/18] x86 vDSO: vdso32 build
In-Reply-To: Roland McGrath's message of  Monday, 19 November 2007 13:59:43 -0800 <20071119215944.01B7C26F8BE@magilla.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20071119220532.029FC26F8BE@magilla.localdomain>
Date: Mon, 19 Nov 2007 14:05:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This builds the 32-bit vDSO images in the arch/x86/vdso subdirectory.
Nothing uses the images yet, but this paves the way for consolidating
the vDSO build logic all in one place.  The new images use a linker
script sharing the layout parts from vdso-layout.lds.S with the 64-bit
vDSO.  A new vdso32-syms.lds is generated in the style of vdso-syms.lds.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/vdso/Makefile            |   76 +++++++++++++++++++++++++++++++++++-
 arch/x86/vdso/vdso32/vdso32.lds.S |   37 ++++++++++++++++++
 2 files changed, 110 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/vdso/vdso32/vdso32.lds.S

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 6a665dd..a1e0418 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -1,7 +1,15 @@
 #
-# x86-64 vDSO.
+# Building vDSO images for x86.
 #
 
+VDSO64-$(CONFIG_X86_64)		:= y
+VDSO32-$(CONFIG_X86_32)		:= y
+VDSO32-$(CONFIG_COMPAT)		:= y
+
+vdso-install-$(VDSO64-y)	+= vdso.so
+vdso-install-$(VDSO32-y)	+= $(vdso32-y:=.so)
+
+
 # files to link into the vdso
 vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vvar.o
 
@@ -57,10 +65,72 @@ quiet_cmd_vdsosym = VDSOSYM $@
 $(obj)/%-syms.lds: $(obj)/%.so.dbg FORCE
 	$(call if_changed,vdsosym)
 
+#
+# Build multiple 32-bit vDSO images to choose from at boot time.
+#
+vdso32.so-$(CONFIG_X86_32)	+= int80
+vdso32.so-$(VDSO32-y)		+= sysenter
+
+CPPFLAGS_vdso32.lds = $(CPPFLAGS_vdso.lds)
+VDSO_LDFLAGS_vdso32.lds = -m elf_i386 -Wl,-soname=linux-gate.so.1
+
+# This makes sure the $(obj) subdirectory exists even though vdso32/
+# is not a kbuild sub-make subdirectory.
+override obj-dirs = $(dir $(obj)) $(obj)/vdso32/
+
+targets += vdso32/vdso32.lds
+targets += $(vdso32.so-y:%=vdso32-%.so.dbg) $(vdso32.so-y:%=vdso32-%.so)
+targets += vdso32/note.o $(vdso32.so-y:%=vdso32/%.o)
+
+extra-y	+= $(vdso32.so-y:%=vdso32-%.so)
+
+$(vdso32.so-y:%=$(obj)/vdso32-%.so.dbg): asflags-$(CONFIG_X86_64) += -m32
+
+$(vdso32.so-y:%=$(obj)/vdso32-%.so.dbg): $(obj)/vdso32-%.so.dbg: FORCE \
+					 $(obj)/vdso32/vdso32.lds \
+					 $(obj)/vdso32/note.o \
+					 $(obj)/vdso32/%.o
+	$(call if_changed,vdso)
+
+# Make vdso32-*-syms.lds from each image, and then make sure they match.
+# The only difference should be that some do not define VDSO32_SYSENTER_RETURN.
+
+targets += vdso32-syms.lds $(vdso32.so-y:%=vdso32-%-syms.lds)
+
+quiet_cmd_vdso32sym = VDSOSYM $@
+define cmd_vdso32sym
+	if LC_ALL=C sort -u $(filter-out FORCE,$^) > $(@D)/.tmp_$(@F) && \
+	   $(foreach H,$(filter-out FORCE,$^),\
+		     if grep -q VDSO32_SYSENTER_RETURN $H; \
+		     then diff -u $(@D)/.tmp_$(@F) $H; \
+		     else sed /VDSO32_SYSENTER_RETURN/d $(@D)/.tmp_$(@F) | \
+			  diff -u - $H; fi &&) : ;\
+	then mv -f $(@D)/.tmp_$(@F) $@; \
+	else rm -f $(@D)/.tmp_$(@F); exit 1; \
+	fi
+endef
+
+$(obj)/vdso32-syms.lds: $(vdso32.so-y:%=$(obj)/vdso32-%-syms.lds) FORCE
+	$(call if_changed,vdso32sym)
+
+#
+# The DSO images are built using a special linker script.
+#
+quiet_cmd_vdso = VDSO    $@
+      cmd_vdso = $(CC) -nostdlib -o $@ \
+		       $(VDSO_LDFLAGS) $(VDSO_LDFLAGS_$(filter %.lds,$(^F))) \
+		       -Wl,-T,$(filter %.lds,$^) $(filter %.o,$^)
+
+VDSO_LDFLAGS = -fPIC -shared $(call ld-option, -Wl$(comma)--hash-style=sysv)
+
+#
+# Install the unstripped copy of vdso*.so listed in $(vdso-install-y).
+#
 quiet_cmd_vdso_install = INSTALL $@
       cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
-vdso.so:
+$(vdso-install-y): %.so: $(obj)/%.so.dbg FORCE
 	@mkdir -p $(MODLIB)/vdso
 	$(call cmd,vdso_install)
 
-vdso_install: vdso.so
+PHONY += vdso_install $(vdso-install-y)
+vdso_install: $(vdso-install-y)
diff --git a/arch/x86/vdso/vdso32/vdso32.lds.S b/arch/x86/vdso/vdso32/vdso32.lds.S
new file mode 100644
index 0000000..976124b
--- /dev/null
+++ b/arch/x86/vdso/vdso32/vdso32.lds.S
@@ -0,0 +1,37 @@
+/*
+ * Linker script for 32-bit vDSO.
+ * We #include the file to define the layout details.
+ * Here we only choose the prelinked virtual address.
+ *
+ * This file defines the version script giving the user-exported symbols in
+ * the DSO.  We can define local symbols here called VDSO* to make their
+ * values visible using the asm-x86/vdso.h macros from the kernel proper.
+ */
+
+#define VDSO_PRELINK 0
+#include "../vdso-layout.lds.S"
+
+/* The ELF entry point can be used to set the AT_SYSINFO value.  */
+ENTRY(__kernel_vsyscall);
+
+/*
+ * This controls what userland symbols we export from the vDSO.
+ */
+VERSION
+{
+	LINUX_2.5 {
+	global:
+		__kernel_vsyscall;
+		__kernel_sigreturn;
+		__kernel_rt_sigreturn;
+	local: *;
+	};
+}
+
+/*
+ * Symbols we define here called VDSO* get their values into vdso32-syms.h.
+ */
+VDSO32_PRELINK		= VDSO_PRELINK;
+VDSO32_vsyscall		= __kernel_vsyscall;
+VDSO32_sigreturn	= __kernel_sigreturn;
+VDSO32_rt_sigreturn	= __kernel_rt_sigreturn;
