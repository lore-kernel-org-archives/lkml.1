Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbZKSHfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbZKSHfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 02:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZKSHfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 02:35:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbZKSHfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 02:35:31 -0500
Date: Thu, 19 Nov 2009 08:35:32 +0100
From: Michal Marek <mmarek@suse.cz>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kconfig: Add missing prototype
Message-ID: <20091119073532.GA19293@sepie.suse.cz>
References: <b9df5fa10911180212h5d74e640g859e7cebe952689@mail.gmail.com>
 <4B03CA6E.8080102@suse.cz>
 <b9df5fa10911180252l577deb1bm6d8aab76b912aad5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10911180252l577deb1bm6d8aab76b912aad5@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 04:52:48PM +0600, Rakib Mullick wrote:
> On 11/18/09, Michal Marek <mmarek@suse.cz> wrote:
> >
> > Hi Rakib,
> >
> >  thanks for the fix, but I already posted a new, simplified version that
> >  doesn't use the fprintf2() thing at all:
> >  http://patchwork.kernel.org/patch/50131/
> >
> Hi Michal,
> 
> Sorry I couldn't pick that up. Maybe it's not in the current -mm tree.
> Isn't it? Does your simplified version removes the use of fprintf2()?

Hm, yes, -mm has the old version. Andrew, could you please replace

  kbuild-generate-modulesbuiltin.patch

and

  kbuild-rebuild-fix-for-makefilemodbuiltin.patch

with the patch below?

Thanks!
Michal

From: Michal Marek <mmarek@suse.cz>
Subject: [PATCH] kbuild: generate modules.builtin

To make it easier for module-init-tools and scripts like mkinitrd to
distinguish builtin and missing modules, install a modules.builtin file
listing all builtin modules. This is done by generating an additional
config file (tristate.conf) with tristate options set to uppercase 'Y'
or 'M'. If we source that config file, the builtin modules appear in
obj-Y.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 .gitignore                       |    1 +
 Documentation/kbuild/kbuild.txt  |   14 +++++++++
 Documentation/kbuild/kconfig.txt |    5 +++
 Makefile                         |   17 ++++++++---
 scripts/Kbuild.include           |    6 ++++
 scripts/Makefile.modbuiltin      |   55 ++++++++++++++++++++++++++++++++++++++
 scripts/kconfig/confdata.c       |   21 ++++++++++++++-
 7 files changed, 113 insertions(+), 6 deletions(-)
 create mode 100644 scripts/Makefile.modbuiltin

diff --git a/.gitignore b/.gitignore
index b93fb7e..5835867 100644
--- a/.gitignore
+++ b/.gitignore
@@ -22,6 +22,7 @@
 *.lst
 *.symtypes
 *.order
+modules.builtin
 *.elf
 *.bin
 *.gz
diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
index bb3bf38..6f8c1ca 100644
--- a/Documentation/kbuild/kbuild.txt
+++ b/Documentation/kbuild/kbuild.txt
@@ -1,3 +1,17 @@
+Output files
+
+modules.order
+--------------------------------------------------
+This file records the order in which modules appear in Makefiles. This
+is used by modprobe to deterministically resolve aliases that match
+multiple modules.
+
+modules.builtin
+--------------------------------------------------
+This file lists all modules that are built into the kernel. This is used
+by modprobe to not fail when trying to load something builtin.
+
+
 Environment variables
 
 KCPPFLAGS
diff --git a/Documentation/kbuild/kconfig.txt b/Documentation/kbuild/kconfig.txt
index 849b5e5..40f0797 100644
--- a/Documentation/kbuild/kconfig.txt
+++ b/Documentation/kbuild/kconfig.txt
@@ -103,6 +103,11 @@ KCONFIG_AUTOCONFIG
 This environment variable can be set to specify the path & name of the
 "auto.conf" file.  Its default value is "include/config/auto.conf".
 
+KCONFIG_TRISTATE
+--------------------------------------------------
+This environment variable can be set to specify the path & name of the
+"tristate.conf" file.  Its default value is "include/config/tristate.conf".
+
 KCONFIG_AUTOHEADER
 --------------------------------------------------
 This environment variable can be set to specify the path & name of the
diff --git a/Makefile b/Makefile
index aa3e13a..5707b32 100644
--- a/Makefile
+++ b/Makefile
@@ -464,7 +464,7 @@ ifeq ($(KBUILD_EXTMOD),)
 # Carefully list dependencies so we do not try to build scripts twice
 # in parallel
 PHONY += scripts
-scripts: scripts_basic include/config/auto.conf
+scripts: scripts_basic include/config/auto.conf include/config/tristate.conf
 	$(Q)$(MAKE) $(build)=$(@)
 
 # Objects we will link into vmlinux / subdirs we need to visit
@@ -491,7 +491,7 @@ $(KCONFIG_CONFIG) include/config/auto.conf.cmd: ;
 # with it and forgot to run make oldconfig.
 # if auto.conf.cmd is missing then we are probably in a cleaned tree so
 # we execute the config step to be sure to catch updated Kconfig files
-include/config/auto.conf: $(KCONFIG_CONFIG) include/config/auto.conf.cmd
+include/config/%.conf: $(KCONFIG_CONFIG) include/config/auto.conf.cmd
 	$(Q)$(MAKE) -f $(srctree)/Makefile silentoldconfig
 else
 # external modules needs include/linux/autoconf.h and include/config/auto.conf
@@ -876,6 +876,9 @@ $(sort $(vmlinux-init) $(vmlinux-main)) $(vmlinux-lds): $(vmlinux-dirs) ;
 PHONY += $(vmlinux-dirs)
 $(vmlinux-dirs): prepare scripts
 	$(Q)$(MAKE) $(build)=$@
+ifdef CONFIG_MODULES
+	$(Q)$(MAKE) $(modbuiltin)=$@
+endif
 
 # Build the kernel release string
 #
@@ -1126,6 +1129,7 @@ all: modules
 PHONY += modules
 modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux)
 	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.order) > $(objtree)/modules.order
+	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.builtin) > $(objtree)/modules.builtin
 	@$(kecho) '  Building modules, stage 2.';
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware __fw_modbuild
@@ -1155,6 +1159,7 @@ _modinst_:
 		ln -s $(objtree) $(MODLIB)/build ; \
 	fi
 	@cp -f $(objtree)/modules.order $(MODLIB)/
+	@cp -f $(objtree)/modules.builtin $(MODLIB)/
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
 
 # This depmod is only for convenience to give the initial
@@ -1217,8 +1222,9 @@ clean: archclean $(clean-dirs)
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
 		-o -name '*.symtypes' -o -name 'modules.order' \
-		-o -name 'Module.markers' -o -name '.tmp_*.o.*' \
-		-o -name '*.gcno' \) -type f -print | xargs rm -f
+		-o -name 'modules.builtin' -o -name 'Module.markers' \
+		-o -name '.tmp_*.o.*' -o -name '*.gcno' \) \
+		-type f -print | xargs rm -f
 
 # mrproper - Delete all generated files, including .config
 #
@@ -1416,7 +1422,8 @@ $(clean-dirs):
 clean:	rm-dirs := $(MODVERDIR)
 clean: rm-files := $(KBUILD_EXTMOD)/Module.symvers \
                    $(KBUILD_EXTMOD)/Module.markers \
-                   $(KBUILD_EXTMOD)/modules.order
+                   $(KBUILD_EXTMOD)/modules.order \
+                   $(KBUILD_EXTMOD)/modules.builtin
 clean: $(clean-dirs)
 	$(call cmd,rmdirs)
 	$(call cmd,rmfiles)
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index c67e73e..ed2773e 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -149,6 +149,12 @@ ld-option = $(call try-run,\
 # $(Q)$(MAKE) $(build)=dir
 build := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.build obj
 
+###
+# Shorthand for $(Q)$(MAKE) -f scripts/Makefile.modbuiltin obj=
+# Usage:
+# $(Q)$(MAKE) $(modbuiltin)=dir
+modbuiltin := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.modbuiltin obj
+
 # Prefix -I with $(srctree) if it is not an absolute path.
 # skip if -I has no parameter
 addtree = $(if $(patsubst -I%,%,$(1)), \
diff --git a/scripts/Makefile.modbuiltin b/scripts/Makefile.modbuiltin
new file mode 100644
index 0000000..102a276
--- /dev/null
+++ b/scripts/Makefile.modbuiltin
@@ -0,0 +1,55 @@
+# ==========================================================================
+# Generating modules.builtin
+# ==========================================================================
+
+src := $(obj)
+
+PHONY := __modbuiltin
+__modbuiltin:
+
+-include include/config/auto.conf
+# tristate.conf sets tristate variables to uppercase 'Y' or 'M'
+# That way, we get the list of built-in modules in obj-Y
+-include include/config/tristate.conf
+
+include scripts/Kbuild.include
+
+# The filename Kbuild has precedence over Makefile
+kbuild-dir := $(if $(filter /%,$(src)),$(src),$(srctree)/$(src))
+kbuild-file := $(if $(wildcard $(kbuild-dir)/Kbuild),$(kbuild-dir)/Kbuild,$(kbuild-dir)/Makefile)
+include $(kbuild-file)
+
+include scripts/Makefile.lib
+__subdir-Y     := $(patsubst %/,%,$(filter %/, $(obj-Y)))
+subdir-Y       += $(__subdir-Y)
+subdir-ym      := $(sort $(subdir-y) $(subdir-Y) $(subdir-m))
+subdir-ym      := $(addprefix $(obj)/,$(subdir-ym))
+obj-Y          := $(addprefix $(obj)/,$(obj-Y))
+
+modbuiltin-subdirs := $(patsubst %,%/modules.builtin, $(subdir-ym))
+modbuiltin-mods    := $(filter %.ko, $(obj-Y:.o=.ko))
+modbuiltin-target  := $(obj)/modules.builtin
+
+__modbuiltin: $(modbuiltin-target) $(subdir-ym)
+	@:
+
+$(modbuiltin-target): $(subdir-ym) FORCE
+	$(Q)(for m in $(modbuiltin-mods); do echo kernel/$$m; done;	\
+	cat /dev/null $(modbuiltin-subdirs)) > $@
+
+PHONY += FORCE
+
+FORCE:
+
+# Descending
+# ---------------------------------------------------------------------------
+
+PHONY += $(subdir-ym)
+$(subdir-ym):
+	$(Q)$(MAKE) $(modbuiltin)=$@
+
+
+# Declare the contents of the .PHONY variable as phony.  We keep that
+# information in a variable se we can use it in if_changed and friends.
+
+.PHONY: $(PHONY)
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index b55e72f..94721f2 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -677,7 +677,7 @@ int conf_write_autoconf(void)
 	struct symbol *sym;
 	const char *str;
 	const char *name;
-	FILE *out, *out_h;
+	FILE *out, *tristate, *out_h;
 	time_t now;
 	int i, l;
 
@@ -692,9 +692,16 @@ int conf_write_autoconf(void)
 	if (!out)
 		return 1;
 
+	tristate = fopen(".tmpconfig_tristate", "w");
+	if (!tristate) {
+		fclose(out);
+		return 1;
+	}
+
 	out_h = fopen(".tmpconfig.h", "w");
 	if (!out_h) {
 		fclose(out);
+		fclose(tristate);
 		return 1;
 	}
 
@@ -707,6 +714,9 @@ int conf_write_autoconf(void)
 		     "# %s"
 		     "#\n",
 		     sym_get_string_value(sym), ctime(&now));
+	fprintf(tristate, "#\n"
+	                  "# Automatically generated - do not edit\n"
+	                  "\n");
 	fprintf(out_h, "/*\n"
 		       " * Automatically generated C config: don't edit\n"
 		       " * Linux kernel version: %s\n"
@@ -727,10 +737,13 @@ int conf_write_autoconf(void)
 				break;
 			case mod:
 				fprintf(out, "CONFIG_%s=m\n", sym->name);
+				fprintf(tristate, "CONFIG_%s=M\n", sym->name);
 				fprintf(out_h, "#define CONFIG_%s_MODULE 1\n", sym->name);
 				break;
 			case yes:
 				fprintf(out, "CONFIG_%s=y\n", sym->name);
+				fprintf(tristate, "CONFIG_%s=%c\n", sym->name,
+					sym->type == S_BOOLEAN ? 'y' : 'Y');
 				fprintf(out_h, "#define CONFIG_%s 1\n", sym->name);
 				break;
 			}
@@ -772,6 +785,7 @@ int conf_write_autoconf(void)
 		}
 	}
 	fclose(out);
+	fclose(tristate);
 	fclose(out_h);
 
 	name = getenv("KCONFIG_AUTOHEADER");
@@ -779,6 +793,11 @@ int conf_write_autoconf(void)
 		name = "include/linux/autoconf.h";
 	if (rename(".tmpconfig.h", name))
 		return 1;
+	name = getenv("KCONFIG_TRISTATE");
+	if (!name)
+		name = "include/config/tristate.conf";
+	if (rename(".tmpconfig_tristate", name))
+		return 1;
 	name = conf_get_autoconfig_name();
 	/*
 	 * This must be the last step, kbuild has a dependency on auto.conf
-- 
1.6.4.2

