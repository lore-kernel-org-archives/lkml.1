Return-Path: <linux-kernel-owner+w=401wt.eu-S932135AbXGKSzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbXGKSzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757189AbXGKSz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:55:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbXGKSz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:55:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] i386 vDSO: install unstripped copies on disk
X-Windows: garbage at your fingertips.
Message-Id: <20070711185445.2E8A04D0555@magilla.localdomain>
Date: Wed, 11 Jul 2007 11:54:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This keeps an unstripped copy of the vDSO images built before they are
stripped and embedded in the kernel.  The unstripped copies get installed
in $(MODLIB)/vdso/ by "make install".  These files can be useful when they
contain source-level debugging information.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/i386/Makefile        |    1 +
 arch/i386/kernel/Makefile |   28 ++++++++++++++++++++++------
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/arch/i386/Makefile b/arch/i386/Makefile
index bd28f9f..dfab520 100644
--- a/arch/i386/Makefile
+++ b/arch/i386/Makefile
@@ -139,6 +139,7 @@ fdimage fdimage144 fdimage288 isoimage: vmlinux
 
 install:
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) install
+	$(Q)$(MAKE) $(build)=arch/i386/kernel $@
 
 archclean:
 	$(Q)$(MAKE) $(clean)=arch/i386/boot
diff --git a/arch/i386/kernel/Makefile b/arch/i386/kernel/Makefile
index 06da59f..e624054 100644
--- a/arch/i386/kernel/Makefile
+++ b/arch/i386/kernel/Makefile
@@ -51,7 +51,8 @@ obj-$(CONFIG_SCx200)		+= scx200.o
 # We must build both images before we can assemble it.
 # Note: kbuild does not track this dependency due to usage of .incbin
 $(obj)/vsyscall.o: $(obj)/vsyscall-int80.so $(obj)/vsyscall-sysenter.so
-targets += $(foreach F,int80 sysenter,vsyscall-$F.o vsyscall-$F.so)
+targets += $(foreach F,$(addprefix vsyscall-,int80 sysenter),\
+		     $F.o $F.so $F.so.dbg)
 targets += vsyscall-note.o vsyscall.lds
 
 # The DSO images are built using a special linker script.
@@ -61,16 +62,32 @@ quiet_cmd_syscall = SYSCALL $@
 
 export CPPFLAGS_vsyscall.lds += -P -C -U$(ARCH)
 
-vsyscall-flags = -shared -s -Wl,-soname=linux-gate.so.1 \
+vsyscall-flags = -shared -Wl,-soname=linux-gate.so.1 \
 		 $(call ld-option, -Wl$(comma)--hash-style=sysv)
 SYSCFLAGS_vsyscall-sysenter.so	= $(vsyscall-flags)
 SYSCFLAGS_vsyscall-int80.so	= $(vsyscall-flags)
 
-$(obj)/vsyscall-int80.so $(obj)/vsyscall-sysenter.so: \
-$(obj)/vsyscall-%.so: $(src)/vsyscall.lds \
-		      $(obj)/vsyscall-%.o $(obj)/vsyscall-note.o FORCE
+$(obj)/vsyscall-int80.so.dbg $(obj)/vsyscall-sysenter.so.dbg: \
+$(obj)/vsyscall-%.so.dbg: $(src)/vsyscall.lds \
+			  $(obj)/vsyscall-%.o $(obj)/vsyscall-note.o FORCE
 	$(call if_changed,syscall)
 
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
+vdsos := vdso-int80.so vdso-sysenter.so
+
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $(@:vdso-%.so=$(obj)/vsyscall-%.so.dbg) \
+			    $(MODLIB)/vdso/$@
+
+$(vdsos):
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
+
+install: $(vdsos)
+
 # We also create a special relocatable object that should mirror the symbol
 # table and layout of the linked DSO.  With ld -R we can then refer to
 # these symbols in the kernel code rather than hand-coded addresses.
