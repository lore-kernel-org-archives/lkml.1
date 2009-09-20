Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbZITSfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbZITSfP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbZITSfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:35:12 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:43074 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbZITSfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:35:10 -0400
Date: Sun, 20 Sep 2009 20:35:13 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: akpm@linux-foundation.org, Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, JBeulich@novell.com,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Feedback on "kbuild: generate modules.builtin"
Message-ID: <20090920183513.GB26958@merkur.ravnborg.org>
References: <200909181949.n8IJnT4R019097@imap1.linux-foundation.org> <20090920132856.GA26845@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090920132856.GA26845@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Got some time (finally) to look at this.
> I understand the functionality and I have myself had the need
> to see builtin modules.

I just did a quick patch that address most of my comments.
I'm heading out of the door in a few minutes
so I decided to post it despite Makefile.modbuiltin is not
updated.

I went for a file named tristate.conf that includes
all tristate symbols. Then we may use it for other
purposes later.
And I kept the "=Y" syntax. In the end this is rather elegant.

They basic idea is to do:
-include include/config/auto.conf
-include include/config/tristate.conf

Where the latter assing new values to all
symbols that refer to builtin modules.

Notice how much simpler the changes to confdata are.

	Sam

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
diff --git a/Makefile b/Makefile
index f908acc..a14705e 100644
--- a/Makefile
+++ b/Makefile
@@ -883,6 +883,9 @@ endef
 
 # vmlinux image - including updated kernel symbols
 vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o $(kallsyms.o) FORCE
+ifdef CONFIG_MODULES
+	$(Q)$(MAKE) $(modbuiltin)=$@
+endif
 ifdef CONFIG_HEADERS_CHECK
 	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
 endif
@@ -1168,6 +1171,7 @@ all: modules
 PHONY += modules
 modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux)
 	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.order) > $(objtree)/modules.order
+	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.builtin) > $(objtree)/modules.builtin
 	@$(kecho) '  Building modules, stage 2.';
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware __fw_modbuild
@@ -1196,7 +1200,7 @@ _modinst_:
 		rm -f $(MODLIB)/build ; \
 		ln -s $(objtree) $(MODLIB)/build ; \
 	fi
-	@cp -f $(objtree)/modules.order $(MODLIB)/
+	@cp -f $(objtree)/modules.{order,builtin} $(MODLIB)/
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
 
 # This depmod is only for convenience to give the initial
@@ -1259,8 +1263,9 @@ clean: archclean $(clean-dirs)
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
@@ -1458,7 +1463,8 @@ $(clean-dirs):
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
index 4f9c190..dd641e1 100644
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
