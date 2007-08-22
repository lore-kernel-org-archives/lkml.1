Return-Path: <linux-kernel-owner+w=401wt.eu-S934234AbXHVV52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934234AbXHVV52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759688AbXHVV5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:57:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760147AbXHVV5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:57:16 -0400
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ogdEvcULkB"
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Alexey Dobriyan <adobriyan@sw.ru>, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1: cannot stat `vdso.so.dbg'
In-Reply-To: Andrew Morton's message of  Wednesday, 22 August 2007 08:36:50 -0700 <20070822083650.85fdfcea.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
X-Windows: it was hard to write; it should be hard to use.
Message-Id: <20070822215639.02D154D0418@magilla.localdomain>
Date: Wed, 22 Aug 2007 14:56:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ogdEvcULkB
Content-Type: text/plain; charset=us-ascii
Content-Description: message body text
Content-Transfer-Encoding: 7bit

> Those patches are in Andi's tree.  His tree has the old versions.  The
> patches are inter-tangled so it is non-trivial for me to generate
> incremental patches on top of Andi's tree which bring his old patches up to
> date with the new ones.  I could of course do so, but it'd be better if
> Andi's tree weren't carrying old versions of
> x86_64-ia32-vdso-install-unstripped-copies-on-disk and
> x86_64-vdso-install-unstripped-copies-on-disk
> 
> Please resend those patches to Andi.

These haven't changed since I sent them (including to Andi) on August 12.


Thanks,
Roland



--ogdEvcULkB
Content-Type: multipart/digest; boundary="ENA7miwK/g"
Content-Transfer-Encoding: 7bit

This is a digest, 2 messages, MIME encapsulation.

--ENA7miwK/g

MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Roland McGrath <roland@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: ak@suse.de, sam@ravnborg.org
Subject: [PATCH 1/2] x86_64 ia32 vDSO: install unstripped copies on disk
Date: Sun, 12 Aug 2007 19:17:00 -0700 (PDT)
Message-Id: <20070813021700.10E054D057D@magilla.localdomain>

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


--ENA7miwK/g

MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Roland McGrath <roland@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: ak@suse.de
Subject: [PATCH 2/2] x86_64 vDSO: install unstripped copies on disk
Date: Sun, 12 Aug 2007 19:19:31 -0700 (PDT)
Message-Id: <20070813021931.1406A4D057D@magilla.localdomain>

While integrating these with the Fedora kernel build, I worked out a few kinks.
This patch replaces x86_64-vdso-install-unstripped-copies-on-disk.patch
and expects x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
was applied first.


Thanks,
Roland

---

This keeps an unstripped copy of the vDSO images built before they are
stripped and embedded in the kernel.  The unstripped copies get installed
in $(MODLIB)/vdso/ by "make install" (or you can explicitly use the
subtarget "make vdso_install").  These files can be useful when they
contain source-level debugging information.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86_64/Makefile      |    1 +
 arch/x86_64/vdso/Makefile |   20 ++++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86_64/Makefile b/arch/x86_64/Makefile
index 93fc1f2..c0905ae 100644
--- a/arch/x86_64/Makefile
+++ b/arch/x86_64/Makefile
@@ -112,6 +112,7 @@ vdso_install:
 ifeq ($(CONFIG_IA32_EMULATION),y)
 	$(Q)$(MAKE) $(build)=arch/x86_64/ia32 $@
 endif
+	$(Q)$(MAKE) $(build)=arch/x86_64/vdso $@
 
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)

diff --git a/arch/x86_64/vdso/Makefile b/arch/x86_64/vdso/Makefile
index faaa72f..20ecf05 100644
--- a/arch/x86_64/vdso/Makefile
+++ b/arch/x86_64/vdso/Makefile
@@ -13,7 +13,7 @@ vobjs := $(foreach F,$(vobjs-y),$(obj)/$F)
 
 $(obj)/vdso.o: $(obj)/vdso.so
 
-targets += vdso.so vdso.lds $(vobjs-y) vdso-syms.o
+targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y) vdso-syms.o
 
 # The DSO images are built using a special linker script.
 quiet_cmd_syscall = SYSCALL $@
@@ -25,14 +25,18 @@ export CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
 vdso-flags = -fPIC -shared -Wl,-soname=linux-vdso.so.1 \
 		 $(call ld-option, -Wl$(comma)--hash-style=sysv) \
 		-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
-SYSCFLAGS_vdso.so = $(vdso-flags)
+SYSCFLAGS_vdso.so.dbg = $(vdso-flags)
 
 $(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
 
-$(obj)/vdso.so: $(src)/vdso.lds $(vobjs) FORCE
+$(obj)/vdso.so.dbg: $(src)/vdso.lds $(vobjs) FORCE
 	$(call if_changed,syscall)
 
-CFL := $(PROFILING) -mcmodel=small -fPIC -g0 -O2 -fasynchronous-unwind-tables -m64
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
+CFL := $(PROFILING) -mcmodel=small -fPIC $(if $(CONFIG_DEBUG_INFO),-g,-g0) -O2 -fasynchronous-unwind-tables -m64
 
 $(obj)/vclock_gettime.o: CFLAGS = $(CFL)
 $(obj)/vgetcpu.o: CFLAGS = $(CFL)
@@ -47,3 +51,11 @@ $(obj)/built-in.o: ld_flags += -R $(obj)/vdso-syms.o
 SYSCFLAGS_vdso-syms.o = -r -d
 $(obj)/vdso-syms.o: $(src)/vdso.lds $(vobjs) FORCE
 	$(call if_changed,syscall)
+
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
+vdso.so:
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
+
+vdso_install: vdso.so

--ENA7miwK/g--

--ogdEvcULkB--
