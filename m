Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbXEFHlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbXEFHlX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 03:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbXEFHlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 03:41:22 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49365 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308AbXEFHlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 03:41:22 -0400
Date: Sun, 6 May 2007 09:42:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: kbuild: enable use of code from a different dir
Message-ID: <20070506074215.GC6492@uranus.ravnborg.org>
References: <20070502201741.GD9044@uranus.ravnborg.org> <20070506073615.GA6492@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070506073615.GA6492@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To introduce support for source in one directory but output files
in another directory during a non O= build prefix all paths
with $(src) repsectively $(obj).

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/Makefile.build |   19 +++++++++----------
 scripts/Makefile.host  |   14 +++++++-------
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index e2ad2dc..a525112 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -131,13 +131,13 @@ $(multi-objs-y:.o=.lst) : modname = $(modname-multi)
 quiet_cmd_cc_s_c = CC $(quiet_modtag)  $@
 cmd_cc_s_c       = $(CC) $(c_flags) -fverbose-asm -S -o $@ $<
 
-%.s: %.c FORCE
+$(obj)/%.s: $(src)/%.c FORCE
 	$(call if_changed_dep,cc_s_c)
 
 quiet_cmd_cc_i_c = CPP $(quiet_modtag) $@
 cmd_cc_i_c       = $(CPP) $(c_flags)   -o $@ $<
 
-%.i: %.c FORCE
+$(obj)/%.i: $(src)/%.c FORCE
 	$(call if_changed_dep,cc_i_c)
 
 quiet_cmd_cc_symtypes_c = SYM $(quiet_modtag) $@
@@ -146,7 +146,7 @@ cmd_cc_symtypes_c	   = \
 		| $(GENKSYMS) -T $@ >/dev/null;				\
 		test -s $@ || rm -f $@
 
-%.symtypes : %.c FORCE
+$(obj)/%.symtypes : $(src)/%.c FORCE
 	$(call if_changed_dep,cc_symtypes_c)
 
 # C (.c) files
@@ -198,14 +198,13 @@ define rule_cc_o_c
 endef
 
 # Built-in and composite module parts
-
-%.o: %.c FORCE
+$(obj)/%.o: $(src)/%.c FORCE
 	$(call cmd,force_checksrc)
 	$(call if_changed_rule,cc_o_c)
 
 # Single-part modules are special since we need to mark them in $(MODVERDIR)
 
-$(single-used-m): %.o: %.c FORCE
+$(single-used-m): $(obj)/%.o: $(src)/%.c FORCE
 	$(call cmd,force_checksrc)
 	$(call if_changed_rule,cc_o_c)
 	@{ echo $(@:.o=.ko); echo $@; } > $(MODVERDIR)/$(@F:.o=.mod)
@@ -215,7 +214,7 @@ quiet_cmd_cc_lst_c = MKLST   $@
 		     $(CONFIG_SHELL) $(srctree)/scripts/makelst $*.o \
 				     System.map $(OBJDUMP) > $@
 
-%.lst: %.c FORCE
+$(obj)/%.lst: $(src)/%.c FORCE
 	$(call if_changed_dep,cc_lst_c)
 
 # Compile assembler sources (.S)
@@ -229,13 +228,13 @@ $(real-objs-m:.o=.s): modkern_aflags := $(AFLAGS_MODULE)
 quiet_cmd_as_s_S = CPP $(quiet_modtag) $@
 cmd_as_s_S       = $(CPP) $(a_flags)   -o $@ $< 
 
-%.s: %.S FORCE
+$(obj)/%.s: $(src)/%.S FORCE
 	$(call if_changed_dep,as_s_S)
 
 quiet_cmd_as_o_S = AS $(quiet_modtag)  $@
 cmd_as_o_S       = $(CC) $(a_flags) -c -o $@ $<
 
-%.o: %.S FORCE
+$(obj)/%.o: $(src)/%.S FORCE
 	$(call if_changed_dep,as_o_S)
 
 targets += $(real-objs-y) $(real-objs-m) $(lib-y)
@@ -246,7 +245,7 @@ targets += $(extra-y) $(MAKECMDGOALS) $(always)
 quiet_cmd_cpp_lds_S = LDS     $@
       cmd_cpp_lds_S = $(CPP) $(cpp_flags) -D__ASSEMBLY__ -o $@ $<
 
-%.lds: %.lds.S FORCE
+$(obj)/%.lds: $(src)/%.lds.S FORCE
 	$(call if_changed_dep,cpp_lds_S)
 
 # Build the compiled-in targets
diff --git a/scripts/Makefile.host b/scripts/Makefile.host
index 575afbe..6943a7a 100644
--- a/scripts/Makefile.host
+++ b/scripts/Makefile.host
@@ -114,7 +114,7 @@ hostcxx_flags  = -Wp,-MD,$(depfile) $(__hostcxx_flags)
 quiet_cmd_host-csingle 	= HOSTCC  $@
       cmd_host-csingle	= $(HOSTCC) $(hostc_flags) -o $@ $< \
 	  	$(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F))
-$(host-csingle): %: %.c FORCE
+$(host-csingle): $(obj)/%: $(src)/%.c FORCE
 	$(call if_changed_dep,host-csingle)
 
 # Link an executable based on list of .o files, all plain c
@@ -123,14 +123,14 @@ quiet_cmd_host-cmulti	= HOSTLD  $@
       cmd_host-cmulti	= $(HOSTCC) $(HOSTLDFLAGS) -o $@ \
 			  $(addprefix $(obj)/,$($(@F)-objs)) \
 			  $(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F))
-$(host-cmulti): %: $(host-cobjs) $(host-cshlib) FORCE
+$(host-cmulti): $(obj)/%: $(host-cobjs) $(host-cshlib) FORCE
 	$(call if_changed,host-cmulti)
 
 # Create .o file from a single .c file
 # host-cobjs -> .o
 quiet_cmd_host-cobjs	= HOSTCC  $@
       cmd_host-cobjs	= $(HOSTCC) $(hostc_flags) -c -o $@ $<
-$(host-cobjs): %.o: %.c FORCE
+$(host-cobjs): $(obj)/%.o: $(src)/%.c FORCE
 	$(call if_changed_dep,host-cobjs)
 
 # Link an executable based on list of .o files, a mixture of .c and .cc
@@ -140,20 +140,20 @@ quiet_cmd_host-cxxmulti	= HOSTLD  $@
 			  $(foreach o,objs cxxobjs,\
 			  $(addprefix $(obj)/,$($(@F)-$(o)))) \
 			  $(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F))
-$(host-cxxmulti): %: $(host-cobjs) $(host-cxxobjs) $(host-cshlib) FORCE
+$(host-cxxmulti): $(obj)/%: $(host-cobjs) $(host-cxxobjs) $(host-cshlib) FORCE
 	$(call if_changed,host-cxxmulti)
 
 # Create .o file from a single .cc (C++) file
 quiet_cmd_host-cxxobjs	= HOSTCXX $@
       cmd_host-cxxobjs	= $(HOSTCXX) $(hostcxx_flags) -c -o $@ $<
-$(host-cxxobjs): %.o: %.cc FORCE
+$(host-cxxobjs): $(obj)/%.o: $(src)/%.cc FORCE
 	$(call if_changed_dep,host-cxxobjs)
 
 # Compile .c file, create position independent .o file
 # host-cshobjs -> .o
 quiet_cmd_host-cshobjs	= HOSTCC  -fPIC $@
       cmd_host-cshobjs	= $(HOSTCC) $(hostc_flags) -fPIC -c -o $@ $<
-$(host-cshobjs): %.o: %.c FORCE
+$(host-cshobjs): $(obj)/%.o: $(src)/%.c FORCE
 	$(call if_changed_dep,host-cshobjs)
 
 # Link a shared library, based on position independent .o files
@@ -162,7 +162,7 @@ quiet_cmd_host-cshlib	= HOSTLLD -shared $@
       cmd_host-cshlib	= $(HOSTCC) $(HOSTLDFLAGS) -shared -o $@ \
 			  $(addprefix $(obj)/,$($(@F:.so=-objs))) \
 			  $(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F))
-$(host-cshlib): %: $(host-cshobjs) FORCE
+$(host-cshlib): $(obj)/%: $(host-cshobjs) FORCE
 	$(call if_changed,host-cshlib)
 
 targets += $(host-csingle)  $(host-cmulti) $(host-cobjs)\
-- 
1.5.1.rc3.20.gaa453

