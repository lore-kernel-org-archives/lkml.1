Return-Path: <linux-kernel-owner+w=401wt.eu-S933695AbXGQOO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695AbXGQOO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763525AbXGQOIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:08:09 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35931 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbXGQOHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:52 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 22/33] kbuild: do section mismatch check on full vmlinux
Date: Tue, 17 Jul 2007 16:08:51 +0200
Message-Id: <11846813442810-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1184681344985-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org> <11846813432300-git-send-email-sam@ravnborg.org> <11846813432072-git-send-email-sam@ravnborg.org> <11846813431389-git-send-email-sam@ravnborg.org> <1184681343412-git-send-email-sam@ravnborg.org> <11846813432249-git-send-email-sam@ravnborg.org> <1184681343297-git-send-email-sam@ravnborg.org> <11846813432231-git-send-email-sam@ravnborg.org> <1184681343423-git-send-email-sam@ravnborg.org> <11846813432234-git-send-email-sam@ravnborg.org> <11846813441521-git-send-email-sam@ravnborg.org> <11846813443387-git-send-email-sam@ravnborg.org> <1184681344594-git-send-email-sam@ravnborg.org> <11846813444176-git-send-email-sam@ravnborg.org> <11846813442297-git-send-email-sam@ravnborg.org> <11846813443187-git-send-email-sam@ravnborg.org> <11846813
 444171-git-send-email-sam@ravnborg.org> <1184681344985-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we did do the check on the .o files used to link
vmlinux but that failed to find questionable references across
the .o files.
Create a dedicated vmlinux.o file used only for section mismatch checks
that uses the defualt linker script so section does not get renamed.

The vmlinux.o may later be used as part of the the final link of vmlinux
but for now it is used fo section mismatch only.
For a defconfig build this is instant but for an allyesconfig this
add two minutes to a full build (that anyways takes ~2 hours).

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile                 |   22 +++++++++++++++++++---
 scripts/Makefile.modpost |    4 ++--
 scripts/mod/modpost.c    |    3 ++-
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index ddbfcac..4f0bd65 100644
--- a/Makefile
+++ b/Makefile
@@ -612,7 +612,7 @@ quiet_cmd_vmlinux__ ?= LD      $@
       cmd_vmlinux__ ?= $(LD) $(LDFLAGS) $(LDFLAGS_vmlinux) -o $@ \
       -T $(vmlinux-lds) $(vmlinux-init)                          \
       --start-group $(vmlinux-main) --end-group                  \
-      $(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) FORCE ,$^)
+      $(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o FORCE ,$^)
 
 # Generate new vmlinux version
 quiet_cmd_vmlinux_version = GEN     .version
@@ -736,15 +736,31 @@ debug_kallsyms: .tmp_map$(last_kallsyms)
 
 endif # ifdef CONFIG_KALLSYMS
 
+# Do modpost on a prelinked vmlinux. The finally linked vmlinux has
+# relevant sections renamed as per the linker script.
+quiet_cmd_vmlinux-modpost = LD      $@
+      cmd_vmlinux-modpost = $(LD) $(LDFLAGS) -r -o $@                          \
+	 $(vmlinux-init) --start-group $(vmlinux-main) --end-group             \
+	 $(filter-out $(vmlinux-init) $(vmlinux-main) $(vmlinux-lds) FORCE ,$^)
+define rule_vmlinux-modpost
+	:
+	+$(call cmd,vmlinux-modpost)
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost $@
+	$(Q)echo 'cmd_$@ := $(cmd_vmlinux-modpost)' > $(dot-target).cmd
+endef
+
 # vmlinux image - including updated kernel symbols
-vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) $(kallsyms.o) FORCE
+vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) $(kallsyms.o) vmlinux.o FORCE
 ifdef CONFIG_HEADERS_CHECK
 	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
 endif
+	$(call vmlinux-modpost)
 	$(call if_changed_rule,vmlinux__)
-	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost $@
 	$(Q)rm -f .old_version
 
+vmlinux.o: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) $(kallsyms.o) FORCE
+	$(call if_changed_rule,vmlinux-modpost)
+
 # The actual objects are generated when descending, 
 # make sure no implicit rule kicks in
 $(sort $(vmlinux-init) $(vmlinux-main)) $(vmlinux-lds): $(vmlinux-dirs) ;
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index d5bbbcc..c6fcc59 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -70,10 +70,10 @@ __modpost: $(modules:.ko=.o) FORCE
 	$(call cmd,modpost) $(wildcard vmlinux) $(filter-out FORCE,$^)
 
 quiet_cmd_kernel-mod = MODPOST $@
-      cmd_kernel-mod = $(cmd_modpost) $(KBUILD_VMLINUX_OBJS)
+      cmd_kernel-mod = $(cmd_modpost) $@
 
 PHONY += vmlinux
-vmlinux: FORCE
+vmlinux.o: FORCE
 	$(call cmd,kernel-mod)
 
 # Declare generated files as targets for modpost
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index bb895b1..ec036c2 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -75,7 +75,8 @@ static int is_vmlinux(const char *modname)
 	else
 		myname = modname;
 
-	return strcmp(myname, "vmlinux") == 0;
+	return (strcmp(myname, "vmlinux") == 0) ||
+	       (strcmp(myname, "vmlinux.o") == 0);
 }
 
 void *do_nofail(void *ptr, const char *expr)
-- 
1.5.0.6

