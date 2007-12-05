Return-Path: <linux-kernel-owner+w=401wt.eu-S1753781AbXLETYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbXLETYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXLETX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:23:58 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:41090 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbXLETX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:23:57 -0500
Date: Wed, 5 Dec 2007 20:06:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       rusty@rustcorp.com.au, kay.sievers@vrfy.org, greg@kroah.com
Subject: Re: [PATCH] depmod: sort output according to modules.order
Message-ID: <20071205190609.GA14997@uranus.ravnborg.org>
References: <47555AF1.8090304@gmail.com> <47555C64.8070607@gmail.com> <20071205072529.GA5681@uranus.ravnborg.org> <47565452.3010800@gmail.com> <47565486.8050701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47565486.8050701@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 04:34:30PM +0900, Tejun Heo wrote:
> Tejun Heo wrote:
> >> It would also simplify the kbuild integration if depmod
> >> could read the modules as a space separated list where
> >> duplicates are allowed.
> >> If we do so then the is no reason to escape to the shell
> >> in Makeilfe.build and we do not have to remove duplicates either.
> > 
> > I'm no Makefile expert so no doubt my modifications are ugly.  But I
> > think producing a file w/ duplicates in it is just ugly.
> 
> Oh, and, depmod should do just fine with duplicate entries as it is.
What is the purpose of REMOVE-DUP then?
If depmod handle duplicate entries there is no need to remove them.

And this change in Makefile.lib seems bogus:
+# make sure '/' follows subdirs
+subdir-y       := $(patsubst %//,%/, $(addsuffix, /,$subdir-y))
+subdir-m       := $(patsubst %//,%/, $(addsuffix, /,$subdir-m))

I commented it out and with my config everything seems to still
work as expected.
And I get scripts/mod/modpost built in a mrproper tree again (bug!).

subdir-y and subdir-m does not point to directories that
contains modules (built-in or not) so they can be ignored for modorder.


I did a quick hack up top of your patch and came up with the following.
I just checked that if I manually ran remove-dup then the resulting
module.order files were identical with a simple configuration (50 modules).

And I did not try out depmod at all.
Feel free to use this as an updated patch.

	Sam

diff --git a/Makefile b/Makefile
index 92dc3cb..9309e89 100644
--- a/Makefile
+++ b/Makefile
@@ -1023,6 +1023,7 @@ all: modules
 
 PHONY += modules
 modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux)
+	$(Q)cat $(vmlinux-dirs:%=$(objtree)/%/modules.order) > $(objtree)/modules.order
 	@echo '  Building modules, stage 2.';
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
 
@@ -1050,6 +1051,7 @@ _modinst_:
 		rm -f $(MODLIB)/build ; \
 		ln -s $(objtree) $(MODLIB)/build ; \
 	fi
+	@cp -f $(objtree)/modules.order $(MODLIB)/
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
 
 # This depmod is only for convenience to give the initial
@@ -1109,7 +1111,7 @@ clean: archclean $(clean-dirs)
 	@find . $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
-		-o -name '*.symtypes' \) \
+		-o -name '*.symtypes' -o -name 'modules.order' \) \
 		-type f -print | xargs rm -f
 
 # mrproper - Delete all generated files, including .config
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index de9836e..ac68c70 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -83,10 +83,12 @@ ifneq ($(strip $(obj-y) $(obj-m) $(obj-n) $(obj-) $(lib-target)),)
 builtin-target := $(obj)/built-in.o
 endif
 
+modorder-target := $(obj)/modules.order
+
 # We keep a list of all modules in $(MODVERDIR)
 
 __build: $(if $(KBUILD_BUILTIN),$(builtin-target) $(lib-target) $(extra-y)) \
-	 $(if $(KBUILD_MODULES),$(obj-m)) \
+	 $(if $(KBUILD_MODULES),$(obj-m) $(modorder-target)) \
 	 $(subdir-ym) $(always)
 	@:
 
@@ -276,6 +278,18 @@ targets += $(builtin-target)
 endif # builtin-target
 
 #
+# Rule to create modules.order file
+#
+# Create commands to etiher record .ko file
+# or cat modules.order from a subdirectory
+modorder-cmds =                                        \
+	$(foreach m, $(modorder),                      \
+		$(if $(filter %/modules.order, $m),    \
+	 		cat $m;, echo kernel/$m;)) 
+
+$(modorder-target): $(subdir-ym) FORCE
+	$(Q)(cat /dev/null; $(modorder-cmds)) > $@
+#
 # Rule to compile a set of .o files into one .a file
 #
 ifdef lib-target
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 3c5e88b..4dedea1 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -25,6 +25,11 @@ lib-y := $(filter-out $(obj-y), $(sort $(lib-y) $(lib-m)))
 # o if we encounter foo/ in $(obj-m), remove it from $(obj-m) 
 #   and add the directory to the list of dirs to descend into: $(subdir-m)
 
+# Determine modorder. 
+# Unfortunately we don't have information about ordering between -y
+# and -m subdirs.  Just put -y's first.
+modorder	:= $(patsubst %/,%/modules.order, $(filter %/, $(obj-y)) $(obj-m:.o=.ko))
+
 __subdir-y	:= $(patsubst %/,%,$(filter %/, $(obj-y)))
 subdir-y	+= $(__subdir-y)
 __subdir-m	:= $(patsubst %/,%,$(filter %/, $(obj-m)))
@@ -64,6 +69,7 @@ real-objs-m := $(foreach m, $(obj-m), $(if $(strip $($(m:.o=-objs)) $($(m:.o=-y)
 extra-y		:= $(addprefix $(obj)/,$(extra-y))
 always		:= $(addprefix $(obj)/,$(always))
 targets		:= $(addprefix $(obj)/,$(targets))
+modorder	:= $(addprefix $(obj)/,$(modorder))
 obj-y		:= $(addprefix $(obj)/,$(obj-y))
 obj-m		:= $(addprefix $(obj)/,$(obj-m))
 lib-y		:= $(addprefix $(obj)/,$(lib-y))
