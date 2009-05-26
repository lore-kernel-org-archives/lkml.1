Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbZEZPZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbZEZPZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 11:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbZEZPZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 11:25:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbZEZPZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 11:25:40 -0400
Date: Tue, 26 May 2009 17:25:40 +0200
From: Michal Marek <mmarek@suse.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: generate modules.builtin
Message-ID: <20090526152540.GA28341@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make it easier for tools like mkinitrd to detect whether a needed
module is missing or whether it is compiled into the kernel, install a
modules.builtin file listing all modules built into the kernel. This is
done by generating an alternate config file with all tristate =y options
set to =Y and reading the makefiles with this config included. The built
in modules then appear in obj-Y.

Known issues (found when comparing results with allyesconfig and
allmodconfig):
 * ALSA makefiles do some substitutions on the CONFIG_*
   variables sometimes, which breaks the logic if the alsa modules are
   built-in. Patch sent to alsa-devel.
 * samples/kobject/*.o could be compiled built-in, but doesn't show up
   in modules.builtin (and not even in vmlinux.o). Patch sent to Greg to
   make it module-only.
 * net/{8021q/vlan_core,ethernet/pe2,ipv6/inet6_hashtables}.o are always
   built-in, even though the corresponding config option is tristate:
   obj-$(subst m,y,$(CONFIG_IPX)) += pe2.o
   The result is that modules.builtin can contain three built-in
   "modules" that can't possibly exist as modules. No fix for this so far,
   as it is not a big issue IMO.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 .gitignore                  |    1 +
 Makefile                    |   12 ++++++++--
 scripts/Kbuild.include      |    6 +++++
 scripts/Makefile.lib        |    5 +++-
 scripts/Makefile.modbuiltin |   48 +++++++++++++++++++++++++++++++++++++++++++
 scripts/kconfig/confdata.c  |   48 ++++++++++++++++++++++++++++++++++++------
 6 files changed, 109 insertions(+), 11 deletions(-)
 create mode 100644 scripts/Makefile.modbuiltin

diff --git a/.gitignore b/.gitignore
index 51bd99d..7479069 100644
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
diff --git a/Makefile b/Makefile
index b57e1f5..d2265ba 100644
--- a/Makefile
+++ b/Makefile
@@ -878,6 +878,9 @@ $(sort $(vmlinux-init) $(vmlinux-main)) $(vmlinux-lds): $(vmlinux-dirs) ;
 PHONY += $(vmlinux-dirs)
 $(vmlinux-dirs): prepare scripts
 	$(Q)$(MAKE) $(build)=$@
+ifdef CONFIG_MODULES
+	$(Q)$(MAKE) $(modbuiltin)=$@
+endif
 
 # Build the kernel release string
 #
@@ -1133,6 +1136,7 @@ all: modules
 PHONY += modules
 modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux)
 	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.order) > $(objtree)/modules.order
+	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.builtin) > $(objtree)/modules.builtin
 	@$(kecho) '  Building modules, stage 2.';
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware __fw_modbuild
@@ -1161,7 +1165,7 @@ _modinst_:
 		rm -f $(MODLIB)/build ; \
 		ln -s $(objtree) $(MODLIB)/build ; \
 	fi
-	@cp -f $(objtree)/modules.order $(MODLIB)/
+	@cp -f $(objtree)/modules.{order,builtin} $(MODLIB)/
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
 
 # This depmod is only for convenience to give the initial
@@ -1224,7 +1228,8 @@ clean: archclean $(clean-dirs)
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
 		-o -name '*.symtypes' -o -name 'modules.order' \
-		-o -name 'Module.markers' -o -name '.tmp_*.o.*' \) \
+		-o -name 'modules.builtin' -o -name 'Module.markers' \
+		-o -name '.tmp_*.o.*' \) \
 		-type f -print | xargs rm -f
 
 # mrproper - Delete all generated files, including .config
@@ -1423,7 +1428,8 @@ $(clean-dirs):
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
index c29be8f..1cded3b 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -143,6 +143,12 @@ ld-option = $(call try-run,\
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
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index cba61ca..427375e 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -37,6 +37,8 @@ modorder	:= $(patsubst %/,%/modules.order, $(filter %/, $(obj-y)) $(obj-m:.o=.ko
 
 __subdir-y	:= $(patsubst %/,%,$(filter %/, $(obj-y)))
 subdir-y	+= $(__subdir-y)
+__subdir-Y	:= $(patsubst %/,%,$(filter %/, $(obj-Y)))
+subdir-Y	+= $(__subdir-Y)
 __subdir-m	:= $(patsubst %/,%,$(filter %/, $(obj-m)))
 subdir-m	+= $(__subdir-m)
 obj-y		:= $(patsubst %/, %/built-in.o, $(obj-y))
@@ -44,7 +46,7 @@ obj-m		:= $(filter-out %/, $(obj-m))
 
 # Subdirectories we need to descend into
 
-subdir-ym	:= $(sort $(subdir-y) $(subdir-m))
+subdir-ym	:= $(sort $(subdir-y) $(subdir-Y) $(subdir-m))
 
 # if $(foo-objs) exists, foo.o is a composite object 
 multi-used-y := $(sort $(foreach m,$(obj-y), $(if $(strip $($(m:.o=-objs)) $($(m:.o=-y))), $(m))))
@@ -76,6 +78,7 @@ always		:= $(addprefix $(obj)/,$(always))
 targets		:= $(addprefix $(obj)/,$(targets))
 modorder	:= $(addprefix $(obj)/,$(modorder))
 obj-y		:= $(addprefix $(obj)/,$(obj-y))
+obj-Y		:= $(addprefix $(obj)/,$(obj-Y))
 obj-m		:= $(addprefix $(obj)/,$(obj-m))
 lib-y		:= $(addprefix $(obj)/,$(lib-y))
 subdir-obj-y	:= $(addprefix $(obj)/,$(subdir-obj-y))
diff --git a/scripts/Makefile.modbuiltin b/scripts/Makefile.modbuiltin
new file mode 100644
index 0000000..55e1885
--- /dev/null
+++ b/scripts/Makefile.modbuiltin
@@ -0,0 +1,48 @@
+# ==========================================================================
+# Generating modules.builtin
+# ==========================================================================
+
+src := $(obj)
+
+PHONY := __modbuiltin
+__modbuiltin:
+
+# Read auto2.conf which sets tristate variables to 'Y' instead of 'y'
+# That way, we get the list of built-in modules in obj-Y
+-include include/config/auto2.conf
+
+include scripts/Kbuild.include
+
+# The filename Kbuild has precedence over Makefile
+kbuild-dir := $(if $(filter /%,$(src)),$(src),$(srctree)/$(src))
+kbuild-file := $(if $(wildcard $(kbuild-dir)/Kbuild),$(kbuild-dir)/Kbuild,$(kbuild-dir)/Makefile)
+include $(kbuild-file)
+
+include scripts/Makefile.lib
+
+modbuiltin-subdirs := $(patsubst %,%/modules.builtin, $(subdir-ym))
+modbuiltin-mods    := $(filter %.ko, $(obj-Y:.o=.ko))
+modbuiltin-target  := $(obj)/modules.builtin
+
+__modbuiltin: $(modbuiltin-target) $(subdir-ym)
+	@:
+
+modbuiltin-cmds =						\
+	for m in $(modbuiltin-mods); do echo kernel/$$m; done;	\
+	cat /dev/null $(modbuiltin-subdirs);
+
+$(modbuiltin-target): $(subdir-ym)
+	$(Q)($(modbuiltin-cmds)) > $@
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
index 273d738..4982aa2 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -666,12 +666,27 @@ out:
 	return res;
 }
 
+int fprintf2(FILE *f1, FILE *f2, const char *fmt, ...)
+{
+	va_list ap;
+	int res;
+
+	va_start(ap, fmt);
+	vfprintf(f1, fmt, ap);
+	va_end(ap);
+	va_start(ap, fmt);
+	res = vfprintf(f2, fmt, ap);
+	va_end(ap);
+
+	return res;
+}
+
 int conf_write_autoconf(void)
 {
 	struct symbol *sym;
 	const char *str;
 	char *name;
-	FILE *out, *out_h;
+	FILE *out, *out2, *out_h;
 	time_t now;
 	int i, l;
 
@@ -686,16 +701,23 @@ int conf_write_autoconf(void)
 	if (!out)
 		return 1;
 
+	out2 = fopen(".tmpconfig2", "w");
+	if (!out2) {
+		fclose(out);
+		return 1;
+	}
+
 	out_h = fopen(".tmpconfig.h", "w");
 	if (!out_h) {
 		fclose(out);
+		fclose(out2);
 		return 1;
 	}
 
 	sym = sym_lookup("KERNELVERSION", 0);
 	sym_calc_value(sym);
 	time(&now);
-	fprintf(out, "#\n"
+	fprintf2(out, out2, "#\n"
 		     "# Automatically generated make config: don't edit\n"
 		     "# Linux kernel version: %s\n"
 		     "# %s"
@@ -720,45 +742,51 @@ int conf_write_autoconf(void)
 			case no:
 				break;
 			case mod:
-				fprintf(out, "CONFIG_%s=m\n", sym->name);
+				fprintf2(out, out2, "CONFIG_%s=m\n",
+						sym->name);
 				fprintf(out_h, "#define CONFIG_%s_MODULE 1\n", sym->name);
 				break;
 			case yes:
 				fprintf(out, "CONFIG_%s=y\n", sym->name);
+				fprintf(out2, "CONFIG_%s=%c\n", sym->name,
+					sym->type == S_BOOLEAN ? 'y' : 'Y');
 				fprintf(out_h, "#define CONFIG_%s 1\n", sym->name);
 				break;
 			}
 			break;
 		case S_STRING:
 			str = sym_get_string_value(sym);
-			fprintf(out, "CONFIG_%s=\"", sym->name);
+			fprintf2(out, out2, "CONFIG_%s=\"", sym->name);
 			fprintf(out_h, "#define CONFIG_%s \"", sym->name);
 			while (1) {
 				l = strcspn(str, "\"\\");
 				if (l) {
 					fwrite(str, l, 1, out);
+					fwrite(str, l, 1, out2);
 					fwrite(str, l, 1, out_h);
 					str += l;
 				}
 				if (!*str)
 					break;
-				fprintf(out, "\\%c", *str);
+				fprintf2(out, out2, "\\%c", *str);
 				fprintf(out_h, "\\%c", *str);
 				str++;
 			}
 			fputs("\"\n", out);
+			fputs("\"\n", out2);
 			fputs("\"\n", out_h);
 			break;
 		case S_HEX:
 			str = sym_get_string_value(sym);
 			if (str[0] != '0' || (str[1] != 'x' && str[1] != 'X')) {
-				fprintf(out, "CONFIG_%s=%s\n", sym->name, str);
+				fprintf2(out, out2, "CONFIG_%s=%s\n",
+						sym->name, str);
 				fprintf(out_h, "#define CONFIG_%s 0x%s\n", sym->name, str);
 				break;
 			}
 		case S_INT:
 			str = sym_get_string_value(sym);
-			fprintf(out, "CONFIG_%s=%s\n", sym->name, str);
+			fprintf2(out, out2, "CONFIG_%s=%s\n", sym->name, str);
 			fprintf(out_h, "#define CONFIG_%s %s\n", sym->name, str);
 			break;
 		default:
@@ -766,6 +794,7 @@ int conf_write_autoconf(void)
 		}
 	}
 	fclose(out);
+	fclose(out2);
 	fclose(out_h);
 
 	name = getenv("KCONFIG_AUTOHEADER");
@@ -773,6 +802,11 @@ int conf_write_autoconf(void)
 		name = "include/linux/autoconf.h";
 	if (rename(".tmpconfig.h", name))
 		return 1;
+	name = getenv("KCONFIG_AUTOCONFIG2");
+	if (!name)
+		name = "include/config/auto2.conf";
+	if (rename(".tmpconfig2", name))
+		return 1;
 	name = getenv("KCONFIG_AUTOCONFIG");
 	if (!name)
 		name = "include/config/auto.conf";
-- 
1.6.3
