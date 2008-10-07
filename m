Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbYJGUjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbYJGUjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbYJGUjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:39:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39408 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbYJGUjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:39:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH] kbuild: AFTER_LINK
X-Fcc: ~/Mail/linus
X-Windows: complex nonsolutions to simple nonproblems.
Message-Id: <20081007203940.391B0154271@magilla.localdomain>
Date: Tue,  7 Oct 2008 13:39:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel builds for packaging systems, we want to do some magic diddling
of linked binaries before they get embedded in load images.  This means the
vDSO images before they get embedded inside vmlinux, and the vmlinux image
itself before it gets embedded inside bzImage or suchlike.

In Fedora's RPM builds, we have been doing this with a kludge using an
override for cmd_objcopy on the make command line.  This is fragile at
best, and broke down due to the excessive levels of make magic involved.

I'm trying to find a relatively clean way of doing this.  What I've come up
with so far is maybe not so hot, but it's a start.  This patch lets me set
AFTER_LINK for the make run, to a command line to run right after these
final links.  For context, this is how I set it:

    # This override tweaks the kernel makefiles so that we run debugedit on an
    # object before embedding it.  When we later run find-debuginfo.sh, it will
    # run debugedit again.  The edits it does change the build ID bits embedded
    # in the stripped object, but repeating debugedit is a no-op.  We do it
    # beforehand to get the proper final build ID bits into the embedded image.
    # This affects the vDSO images in vmlinux, and the vmlinux image in bzImage.
    export AFTER_LINK=\
    'sh -xc "/usr/lib/rpm/debugedit -b $$RPM_BUILD_DIR -d /usr/src/debug -i $@"'

Sam, what do you think would be the clean way to enable packaging builds to
do a hack like this?


Thanks,
Roland

---
If the make variable AFTER_LINK is set, it is a command line to run
after each final link.  This includes vmlinux itself and vDSO images.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 Makefile                            |    4 ++++
 arch/powerpc/kernel/vdso32/Makefile |    3 ++-
 arch/powerpc/kernel/vdso64/Makefile |    3 ++-
 arch/x86/vdso/Makefile              |    3 ++-
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index ce9eceb..b27b1b7 100644
--- a/Makefile
+++ b/Makefile
@@ -679,6 +679,10 @@ quiet_cmd_vmlinux__ ?= LD      $@
       --start-group $(vmlinux-main) --end-group                  \
       $(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o FORCE ,$^)
 
+ifdef AFTER_LINK
+cmd_vmlinux__ += ; $(AFTER_LINK)
+endif
+
 # Generate new vmlinux version
 quiet_cmd_vmlinux_version = GEN     .version
       cmd_vmlinux_version = set -e;                     \
diff --git a/arch/powerpc/kernel/vdso32/Makefile b/arch/powerpc/kernel/vdso32/Makefile
index c3d57bd..c9519c5 100644
--- a/arch/powerpc/kernel/vdso32/Makefile
+++ b/arch/powerpc/kernel/vdso32/Makefile
@@ -40,7 +40,8 @@ $(obj-vdso32): %.o: %.S
 
 # actual build commands
 quiet_cmd_vdso32ld = VDSO32L $@
-      cmd_vdso32ld = $(CROSS32CC) $(c_flags) -Wl,-T $^ -o $@
+      cmd_vdso32ld = $(CROSS32CC) $(c_flags) -Wl,-T $^ -o $@ \
+		     $(if $(AFTER_LINK),; $(AFTER_LINK))
 quiet_cmd_vdso32as = VDSO32A $@
       cmd_vdso32as = $(CROSS32CC) $(a_flags) -c -o $@ $<
 
diff --git a/arch/powerpc/kernel/vdso64/Makefile b/arch/powerpc/kernel/vdso64/Makefile
index fa7f1b8..712fe1d 100644
--- a/arch/powerpc/kernel/vdso64/Makefile
+++ b/arch/powerpc/kernel/vdso64/Makefile
@@ -34,7 +34,8 @@ $(obj-vdso64): %.o: %.S
 
 # actual build commands
 quiet_cmd_vdso64ld = VDSO64L $@
-      cmd_vdso64ld = $(CC) $(c_flags) -Wl,-T $^ -o $@
+      cmd_vdso64ld = $(CC) $(c_flags) -Wl,-T $^ -o $@ \
+		     $(if $(AFTER_LINK),; $(AFTER_LINK))
 quiet_cmd_vdso64as = VDSO64A $@
       cmd_vdso64as = $(CC) $(a_flags) -c -o $@ $<
 
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 4d6ef0a..5203ae9 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -120,7 +120,8 @@ $(obj)/vdso32-syms.lds: $(vdso32.so-y:%=$(obj)/vdso32-%-syms.lds) FORCE
 quiet_cmd_vdso = VDSO    $@
       cmd_vdso = $(CC) -nostdlib -o $@ \
 		       $(VDSO_LDFLAGS) $(VDSO_LDFLAGS_$(filter %.lds,$(^F))) \
-		       -Wl,-T,$(filter %.lds,$^) $(filter %.o,$^)
+		       -Wl,-T,$(filter %.lds,$^) $(filter %.o,$^) \
+		 $(if $(AFTER_LINK),; $(AFTER_LINK))
 
 VDSO_LDFLAGS = -fPIC -shared $(call ld-option, -Wl$(comma)--hash-style=sysv)
 
