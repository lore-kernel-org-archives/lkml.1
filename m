Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbXGWH07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbXGWH07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 03:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbXGWH0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 03:26:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbXGWH0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 03:26:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
X-Fcc: ~/Mail/linus
Cc: Paul Mackerras <paulus@samba.org>, Alan Modra <amodra@bigpond.net.au>,
       David Miller <davem@davemloft.net>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org
Subject: Re: "build-id" changes break sparc64
In-Reply-To: Sam Ravnborg's message of  Monday, 23 July 2007 08:27:59 +0200 <20070723062759.GB3933@uranus.ravnborg.org>
X-Zippy-Says: We have DIFFERENT amounts of HAIR --
Message-Id: <20070723072613.E3A504D0489@magilla.localdomain>
Date: Mon, 23 Jul 2007 00:26:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Should be doable without to much pain.
> Alan can you please share with us exactly why this is better and what we may
> run into of problems doing so.
> A sample script would be nice too....

This about does it.  Polish left as an exercise to the reader.
ld does "interesting" things if the linker scripts are inside --start-group.

diff --git a/Makefile b/Makefile
index cd47845..0000000 100644  
--- a/Makefile
+++ b/Makefile
@@ -613,12 +613,15 @@ vmlinux-all  := $(vmlinux-init) $(vmlinu
 vmlinux-lds  := arch/$(ARCH)/kernel/vmlinux.lds
 export KBUILD_VMLINUX_OBJS := $(vmlinux-all)
 
+vmlinux-link-main = $(filter-out %.a,$(vmlinux-main)) \
+		    --start-group $(filter %.a,$(vmlinux-main)) --end-group
+
 # Rule to link vmlinux - also used during CONFIG_KALLSYMS
 # May be overridden by arch/$(ARCH)/Makefile
 quiet_cmd_vmlinux__ ?= LD      $@
       cmd_vmlinux__ ?= $(LD) $(LDFLAGS) $(LDFLAGS_vmlinux) -o $@ \
       -T $(vmlinux-lds) $(vmlinux-init)                          \
-      --start-group $(vmlinux-main) --end-group                  \
+      $(vmlinux-link-main) \
       $(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o FORCE ,$^)
 
 # Generate new vmlinux version
@@ -747,7 +750,7 @@ endif # ifdef CONFIG_KALLSYMS
 # relevant sections renamed as per the linker script.
 quiet_cmd_vmlinux-modpost = LD      $@
       cmd_vmlinux-modpost = $(LD) $(LDFLAGS) -r -o $@                          \
-	 $(vmlinux-init) --start-group $(vmlinux-main) --end-group             \
+	 $(vmlinux-init) $(vmlinux-link-main) \
 	 $(filter-out $(vmlinux-init) $(vmlinux-main) $(vmlinux-lds) FORCE ,$^)
 define rule_vmlinux-modpost
 	:
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 3f7b451..0000000 100644  
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -274,11 +274,11 @@ $(sort $(subdir-obj-y)): $(subdir-ym) ;
 # Rule to compile a set of .o files into one .o file
 #
 ifdef builtin-target
-quiet_cmd_link_o_target = LD      $@
+quiet_cmd_link_o_target = LDS      $@
 # If the list of objects to link is empty, just create an empty built-in.o
-cmd_link_o_target = $(if $(strip $(obj-y)),\
-		      $(LD) $(ld_flags) -r -o $@ $(filter $(obj-y), $^),\
-		      rm -f $@; $(AR) rcs $@)
+cmd_link_o_target = echo > $@.new $(if $(strip $(obj-y)),\
+		    	   	       'INPUT($(filter $(obj-y), $^))') && \
+ 		    mv -f $@.new $@
 
 $(builtin-target): $(obj-y) FORCE
 	$(call if_changed,link_o_target)
@@ -311,11 +311,11 @@ $(filter $(addprefix $(obj)/,         \
 $($(subst $(obj)/,,$(@:.o=-objs)))    \
 $($(subst $(obj)/,,$(@:.o=-y)))), $^)
  
-quiet_cmd_link_multi-y = LD      $@
-cmd_link_multi-y = $(LD) $(ld_flags) -r -o $@ $(link_multi_deps)
+quiet_cmd_link_multi-y = LDS     $@
+cmd_link_multi-y = echo > $@.new 'INPUT($(link_multi_deps))' && mv -f $@.new $@
 
 quiet_cmd_link_multi-m = LD [M]  $@
-cmd_link_multi-m = $(LD) $(ld_flags) $(LDFLAGS_MODULE) -o $@ $(link_multi_deps)
+cmd_link_multi-m = $(cmd_link_multi-y)
 
 # We would rather have a list of rules like
 # 	foo.o: $(foo-objs)
