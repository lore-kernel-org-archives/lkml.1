Return-Path: <linux-kernel-owner+w=401wt.eu-S932699AbXGKSzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbXGKSzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932628AbXGKSzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:55:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420AbXGKSzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:55:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64 ia32 vDSO: install unstripped copies on disk
X-Zippy-Says: Yow!  Legally-imposed CULTURE-reduction is CABBAGE-BRAINED!
Message-Id: <20070711185528.304D74D0555@magilla.localdomain>
Date: Wed, 11 Jul 2007 11:55:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This keeps an unstripped copy of the vDSO images built before they are
stripped and embedded in the kernel.  The unstripped copies get installed
in $(MODLIB)/vdso/ by "make install".  These files can be useful when they
contain source-level debugging information.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86_64/Makefile      |    3 +++
 arch/x86_64/ia32/Makefile |   25 +++++++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86_64/Makefile b/arch/x86_64/Makefile
index 29617ae..dab404e 100644
--- a/arch/x86_64/Makefile
+++ b/arch/x86_64/Makefile
@@ -106,6 +106,9 @@ fdimage fdimage144 fdimage288 isoimage: vmlinux
 
 install:
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) $@ 
+ifeq ($(CONFIG_IA32_EMULATION),y)
+	$(Q)$(MAKE) $(build)=arch/x86_64/ia32 $@
+endif
 
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
diff --git a/arch/x86_64/ia32/Makefile b/arch/x86_64/ia32/Makefile
index cdae364..a4afa79 100644
--- a/arch/x86_64/ia32/Makefile
+++ b/arch/x86_64/ia32/Makefile
@@ -18,18 +18,35 @@ $(obj)/syscall32_syscall.o: \
 	$(foreach F,sysenter syscall,$(obj)/vsyscall-$F.so)
 
 # Teach kbuild about targets
-targets := $(foreach F,sysenter syscall,vsyscall-$F.o vsyscall-$F.so)
+targets := $(foreach F,$(addprefix vsyscall-,sysenter syscall),\
+		     $F.o $F.so $F.so.dbg)
 
 # The DSO images are built using a special linker script
 quiet_cmd_syscall = SYSCALL $@
-      cmd_syscall = $(CC) -m32 -nostdlib -shared -s \
+      cmd_syscall = $(CC) -m32 -nostdlib -shared \
 			  $(call ld-option, -Wl$(comma)--hash-style=sysv) \
 			   -Wl,-soname=linux-gate.so.1 -o $@ \
 			   -Wl,-T,$(filter-out FORCE,$^)
 
-$(obj)/vsyscall-sysenter.so $(obj)/vsyscall-syscall.so: \
-$(obj)/vsyscall-%.so: $(src)/vsyscall.lds $(obj)/vsyscall-%.o FORCE
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
+$(obj)/vsyscall-sysenter.so.dbg $(obj)/vsyscall-syscall.so.dbg: \
+$(obj)/vsyscall-%.so.dbg: $(src)/vsyscall.lds $(obj)/vsyscall-%.o FORCE
 	$(call if_changed,syscall)
 
 AFLAGS_vsyscall-sysenter.o = -m32 -Wa,-32
 AFLAGS_vsyscall-syscall.o = -m32 -Wa,-32
+
+vdsos := vdso32-sysenter.so vdso32-syscall.so
+
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $(@:vdso32-%.so=$(obj)/vsyscall-%.so.dbg) \
+			    $(MODLIB)/vdso/$@
+
+$(vdsos):
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
+
+install: $(vdsos)
