Return-Path: <linux-kernel-owner+w=401wt.eu-S937290AbXHMCRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937290AbXHMCRn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 22:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934687AbXHMCRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 22:17:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934597AbXHMCRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 22:17:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: akpm@linux-foundation.org
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Cc: ak@suse.de, sam@ravnborg.org
Subject: [PATCH 1/2] x86_64 ia32 vDSO: install unstripped copies on disk
In-Reply-To: akpm@linux-foundation.org's message of  Friday, 10 August 2007 14:59:46 -0700 <200708102159.l7ALxkLx011796@imap1.linux-foundation.org>
X-Fcc: ~/Mail/linus
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20070813021700.10E054D057D@magilla.localdomain>
Date: Sun, 12 Aug 2007 19:17:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While integrating these with the Fedora kernel build, I worked out a few kinks.
This patch replaces x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch


Thanks,
Roland

---

This keeps an unstripped copy of the vDSO images built before they are
stripped and embedded in the kernel.  The unstripped copies get installed
in $(MODLIB)/vdso/ by "make install" (or you can explicitly use the
subtarget "make vdso_install").  These files can be useful when they
contain source-level debugging information.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>
---

 arch/x86_64/Makefile      |    3 +++
 arch/x86_64/ia32/Makefile |   25 +++++++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/Makefile~x86_64-ia32-vdso-install-unstripped-copies-on-disk arch/x86_64/Makefile
--- a/arch/x86_64/Makefile~x86_64-ia32-vdso-install-unstripped-copies-on-disk
+++ a/arch/x86_64/Makefile
@@ -105,9 +105,14 @@ bzdisk: vmlinux
 fdimage fdimage144 fdimage288 isoimage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) $@
 
-install:
+install: vdso_install
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) $@ 
 
+vdso_install:
+ifeq ($(CONFIG_IA32_EMULATION),y)
+	$(Q)$(MAKE) $(build)=arch/x86_64/ia32 $@
+endif
+
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)

diff -puN arch/x86_64/ia32/Makefile~x86_64-ia32-vdso-install-unstripped-copies-on-disk arch/x86_64/ia32/Makefile
--- a/arch/x86_64/ia32/Makefile~x86_64-ia32-vdso-install-unstripped-copies-on-disk
+++ a/arch/x86_64/ia32/Makefile
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
+vdso_install: $(vdsos)

