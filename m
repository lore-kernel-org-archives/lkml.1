Return-Path: <linux-kernel-owner+w=401wt.eu-S1761725AbZENNGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761725AbZENNGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761364AbZENNGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:06:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37538 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761742AbZENNGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:06:18 -0400
X-Sieve: CMU Sieve 2.2
From: Petr Tesarik <ptesarik@suse.cz>
To: linux-kernel@vger.kernel.org, linux-x86_64@vger.kernel.org, mingo@elte.hu,
       andi@firstfloor.org
Cc: zwane@arm.linux.org.uk, roland@redhat.com, Petr Tesarik <ptesarik@suse.cz>
Message-Id: <f249c3f58a699ce72b6cb416ddff98811848ff6f.1242299014.git.ptesarik@suse.cz>
In-Reply-To: <cover.1242299014.git.ptesarik@suse.cz>
References: <cover.1242299014.git.ptesarik@suse.cz>
In-Reply-To: <cover.1242299014.git.ptesarik@suse.cz>
References: <cover.1242299014.git.ptesarik@suse.cz>
Subject: [PATCH 1/4] x86: Use vdso*-syms.h instead of vdso*-syms.lds
Organization: SUSE LINUX
Date: Thu, 14 May 2009 15:06:18 +0200
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we post-process the object file anyway, we can define the
constants with pre-processor directives instead of special symbols
at link time. This approach makes it possible to use the include
files with other tools than the linker.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/include/asm/vdso.h  |   14 ++------------
 arch/x86/vdso/.gitignore     |   10 +++++-----
 arch/x86/vdso/Makefile       |   16 ++++++++--------
 arch/x86/vdso/vdso32-setup.c |    2 ++
 arch/x86/vdso/vma.c          |    1 +
 5 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index 9064052..a959ac9 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -2,31 +2,21 @@
 #define _ASM_X86_VDSO_H
 
 #ifdef CONFIG_X86_64
-extern const char VDSO64_PRELINK[];
-
 /*
  * Given a pointer to the vDSO image, find the pointer to VDSO64_name
  * as that symbol is defined in the vDSO sources or linker script.
  */
 #define VDSO64_SYMBOL(base, name)					\
-({									\
-	extern const char VDSO64_##name[];				\
-	(void *)(VDSO64_##name - VDSO64_PRELINK + (unsigned long)(base)); \
-})
+	((void *)(VDSO64_##name - VDSO64_PRELINK + (unsigned long)(base)))
 #endif
 
 #if defined CONFIG_X86_32 || defined CONFIG_COMPAT
-extern const char VDSO32_PRELINK[];
-
 /*
  * Given a pointer to the vDSO image, find the pointer to VDSO32_name
  * as that symbol is defined in the vDSO sources or linker script.
  */
 #define VDSO32_SYMBOL(base, name)					\
-({									\
-	extern const char VDSO32_##name[];				\
-	(void *)(VDSO32_##name - VDSO32_PRELINK + (unsigned long)(base)); \
-})
+	((void *)(VDSO32_##name - VDSO32_PRELINK + (unsigned long)(base)))
 #endif
 
 /*
diff --git a/arch/x86/vdso/.gitignore b/arch/x86/vdso/.gitignore
index 60274d5..6ac0a86 100644
--- a/arch/x86/vdso/.gitignore
+++ b/arch/x86/vdso/.gitignore
@@ -1,6 +1,6 @@
 vdso.lds
-vdso-syms.lds
-vdso32-syms.lds
-vdso32-syscall-syms.lds
-vdso32-sysenter-syms.lds
-vdso32-int80-syms.lds
+vdso-syms.h
+vdso32-syms.h
+vdso32-syscall-syms.h
+vdso32-sysenter-syms.h
+vdso32-int80-syms.h
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 16a9020..550dca0 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -42,26 +42,25 @@ CFL := $(PROFILING) -mcmodel=small -fPIC -O2 -fasynchronous-unwind-tables -m64 \
 
 $(vobjs): KBUILD_CFLAGS += $(CFL)
 
-targets += vdso-syms.lds
-obj-$(VDSO64-y)			+= vdso-syms.lds
+targets += vdso-syms.h
+$(obj)/vma.o: $(obj)/vdso-syms.h
 
 #
 # Match symbols in the DSO that look like VDSO*; produce a file of constants.
 #
 sed-vdsosym := -e 's/^00*/0/' \
-	-e 's/^\([0-9a-fA-F]*\) . \(VDSO[a-zA-Z0-9_]*\)$$/\2 = 0x\1;/p'
+	-e 's/^\([0-9a-fA-F]*\) . \(VDSO[a-zA-Z0-9_]*\)$$/\#define \2 0x\1/p'
 quiet_cmd_vdsosym = VDSOSYM $@
 define cmd_vdsosym
 	$(NM) $< | LC_ALL=C sed -n $(sed-vdsosym) | LC_ALL=C sort > $@
 endef
 
-$(obj)/%-syms.lds: $(obj)/%.so.dbg FORCE
+$(obj)/%-syms.h: $(obj)/%.so.dbg FORCE
 	$(call if_changed,vdsosym)
 
 #
 # Build multiple 32-bit vDSO images to choose from at boot time.
 #
-obj-$(VDSO32-y)			+= vdso32-syms.lds
 vdso32.so-$(VDSO32-y)		+= int80
 vdso32.so-$(CONFIG_COMPAT)	+= syscall
 vdso32.so-$(VDSO32-y)		+= sysenter
@@ -93,10 +92,11 @@ $(vdso32-images:%=$(obj)/%.dbg): $(obj)/vdso32-%.so.dbg: FORCE \
 				 $(obj)/vdso32/%.o
 	$(call if_changed,vdso)
 
-# Make vdso32-*-syms.lds from each image, and then make sure they match.
+# Make vdso32-*-syms.h from each image, and then make sure they match.
 # The only difference should be that some do not define VDSO32_SYSENTER_RETURN.
 
-targets += vdso32-syms.lds $(vdso32.so-y:%=vdso32-%-syms.lds)
+targets += vdso32-syms.h $(vdso32.so-y:%=vdso32-%-syms.h)
+$(obj)/vdso32-setup.o: $(obj)/vdso32-syms.h
 
 quiet_cmd_vdso32sym = VDSOSYM $@
 define cmd_vdso32sym
@@ -111,7 +111,7 @@ define cmd_vdso32sym
 	fi
 endef
 
-$(obj)/vdso32-syms.lds: $(vdso32.so-y:%=$(obj)/vdso32-%-syms.lds) FORCE
+$(obj)/vdso32-syms.h: $(vdso32.so-y:%=$(obj)/vdso32-%-syms.h) FORCE
 	$(call if_changed,vdso32sym)
 
 #
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 1241f11..7f39b89 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -26,6 +26,8 @@
 #include <asm/vdso.h>
 #include <asm/proto.h>
 
+#include "vdso32-syms.h"
+
 enum {
 	VDSO_DISABLED = 0,
 	VDSO_ENABLED = 1,
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 7133cdf..289d410 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -13,6 +13,7 @@
 #include <asm/proto.h>
 #include <asm/vdso.h>
 
+#include "vdso-syms.h"
 #include "vextern.h"		/* Just for VMAGIC.  */
 #undef VEXTERN
 
-- 
1.6.0.2


