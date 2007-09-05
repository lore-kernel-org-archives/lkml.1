Return-Path: <linux-kernel-owner+w=401wt.eu-S1757827AbXIEUpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbXIEUpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 16:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbXIEUpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 16:45:08 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48761 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768AbXIEUpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 16:45:05 -0400
Date: Wed, 5 Sep 2007 22:46:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: kai@germaschewski.name, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] build system: section garbage collection for vmlinux
Message-ID: <20070905204628.GE30812@uranus.ravnborg.org>
References: <200709051443.21522.vda.linux@googlemail.com> <200709051449.22567.vda.linux@googlemail.com> <200709051455.05508.vda.linux@googlemail.com> <200709051940.15653.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709051940.15653.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2007 at 07:40:15PM +0100, Denys Vlasenko wrote:
> On Wednesday 05 September 2007 14:55, Denys Vlasenko wrote:
> > Part 3:
> > 
> > Makefile:
> > init/Kconfig:
> >   add config DISCARD_UNUSED_SECTIONS with appropriate
> >   big scary warning. It enables gcc and ld options
> >   for section garbage collection.
> 
> At it typically happens, last-minute "obviously correct" change was a mistake.
> 
> This doesn't work as intended:
> 
> LDFLAGS_vmlinux += $(call ld-option, --gc-sections)
> 
> With the above line, --gc-sections doesn't get added,
> and vmlinux is not garbage collected.
Did you find out why it does not work?
> 
> It must be
> 
> LDFLAGS_vmlinux += --gc-sections
Doing a normal kernel build will link vmlinux three or four times.
If we introduce --gc-sections we should add a preparational link of
vmlinux where we use --gc-sections and skip it for the rest of the links
assuming that --gc-sections takes some time for ld to do.

I have already tried to introduce such a preparatioanl link
of vmlinux - patch attached.
I skipped this patch because suprisingly it was no win for a kernelbuild.
ld seems not to be more effective using a prelinked vmlinux.o compared to several
.o files.

I know ths prelinked vmlinux.o does not include the init stuff but
that is so little that it is not interesting for your patch.

	Sam

diff --git a/Makefile b/Makefile
index 350dedb..2cc0fd7 100644
--- a/Makefile
+++ b/Makefile
@@ -592,7 +592,7 @@ libs-y		:= $(libs-y1) $(libs-y2)
 #   +-< $(vmlinux-init)
 #   |   +--< init/version.o + more
 #   |
-#   +--< $(vmlinux-main)
+#   +--< vmlinux.o
 #   |    +--< driver/built-in.o mm/built-in.o + more
 #   |
 #   +-< kallsyms.o (see description in CONFIG_KALLSYMS section)
@@ -608,17 +608,16 @@ libs-y		:= $(libs-y1) $(libs-y2)
 
 vmlinux-init := $(head-y) $(init-y)
 vmlinux-main := $(core-y) $(libs-y) $(drivers-y) $(net-y)
-vmlinux-all  := $(vmlinux-init) $(vmlinux-main)
 vmlinux-lds  := arch/$(ARCH)/kernel/vmlinux.lds
-export KBUILD_VMLINUX_OBJS := $(vmlinux-all)
+export KBUILD_VMLINUX_OBJS := $(vmlinux-init) vmlinux.o
 
 # Rule to link vmlinux - also used during CONFIG_KALLSYMS
 # May be overridden by arch/$(ARCH)/Makefile
 quiet_cmd_vmlinux__ ?= LD      $@
       cmd_vmlinux__ ?= $(LD) $(LDFLAGS) $(LDFLAGS_vmlinux) -o $@ \
       -T $(vmlinux-lds) $(vmlinux-init)                          \
-      --start-group $(vmlinux-main) --end-group                  \
-      $(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o FORCE ,$^)
+      --start-group vmlinux.o --end-group                        \
+      $(filter-out $(vmlinux-lds) $(vmlinux-init) vmlinux.o FORCE ,$^)
 
 # Generate new vmlinux version
 quiet_cmd_vmlinux_version = GEN     .version
@@ -718,13 +717,13 @@ quiet_cmd_kallsyms = KSYM    $@
 	$(call cmd,kallsyms)
 
 # .tmp_vmlinux1 must be complete except kallsyms, so update vmlinux version
-.tmp_vmlinux1: $(vmlinux-lds) $(vmlinux-all) FORCE
+.tmp_vmlinux1: $(vmlinux-lds) $(vmlinux-init) vmlinux.o FORCE
 	$(call if_changed_rule,ksym_ld)
 
-.tmp_vmlinux2: $(vmlinux-lds) $(vmlinux-all) .tmp_kallsyms1.o FORCE
+.tmp_vmlinux2: $(vmlinux-lds) $(vmlinux-init) vmlinux.o .tmp_kallsyms1.o FORCE
 	$(call if_changed,vmlinux__)
 
-.tmp_vmlinux3: $(vmlinux-lds) $(vmlinux-all) .tmp_kallsyms2.o FORCE
+.tmp_vmlinux3: $(vmlinux-lds) $(vmlinux-init) vmlinux.o .tmp_kallsyms2.o FORCE
 	$(call if_changed,vmlinux__)
 
 # Needs to visit scripts/ before $(KALLSYMS) can be used.
@@ -742,31 +741,22 @@ debug_kallsyms: .tmp_map$(last_kallsyms)
 
 endif # ifdef CONFIG_KALLSYMS
 
-# Do modpost on a prelinked vmlinux. The finally linked vmlinux has
-# relevant sections renamed as per the linker script.
-quiet_cmd_vmlinux-modpost = LD      $@
-      cmd_vmlinux-modpost = $(LD) $(LDFLAGS) -r -o $@                          \
-	 $(vmlinux-init) --start-group $(vmlinux-main) --end-group             \
-	 $(filter-out $(vmlinux-init) $(vmlinux-main) $(vmlinux-lds) FORCE ,$^)
-define rule_vmlinux-modpost
-	:
-	+$(call cmd,vmlinux-modpost)
-	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost $@
-	$(Q)echo 'cmd_$@ := $(cmd_vmlinux-modpost)' > $(dot-target).cmd
-endef
+# Link the kernel except init parts - for use in subsequent links
+quiet_cmd_vmlinux-main = LD      $@
+      cmd_vmlinux-main = $(LD) $(LDFLAGS) -r -o $@             \
+	 --start-group $(filter-out FORCE, $^) --end-group
+
+vmlinux.o: $(vmlinux-main) FORCE
+	$(call if_changed,vmlinux-main)
 
 # vmlinux image - including updated kernel symbols
-vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) $(kallsyms.o) vmlinux.o FORCE
+vmlinux: $(vmlinux-lds) $(vmlinux-init) $(kallsyms.o) vmlinux.o FORCE
 ifdef CONFIG_HEADERS_CHECK
 	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
 endif
-	$(call vmlinux-modpost)
 	$(call if_changed_rule,vmlinux__)
 	$(Q)rm -f .old_version
 
-vmlinux.o: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) $(kallsyms.o) FORCE
-	$(call if_changed_rule,vmlinux-modpost)
-
 # The actual objects are generated when descending, 
 # make sure no implicit rule kicks in
 $(sort $(vmlinux-init) $(vmlinux-main)) $(vmlinux-lds): $(vmlinux-dirs) ;
