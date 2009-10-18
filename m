Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbZJRIMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbZJRIMw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 04:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbZJRIMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 04:12:12 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:50936 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbZJRILU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 04:11:20 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 13/14] kbuild: move autoconf.h to include/generated
Date: Sun, 18 Oct 2009 10:15:22 +0200
Message-Id: <1255853723-477-13-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <20091018080635.GA13767@merkur.ravnborg.org>
References: <20091018080635.GA13767@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 .gitignore                       |    1 -
 Documentation/kbuild/kconfig.txt |    3 ++-
 Makefile                         |   11 ++++++-----
 arch/m68k/kernel/head.S          |    2 +-
 scripts/basic/fixdep.c           |   10 +++++-----
 scripts/kconfig/confdata.c       |    2 +-
 scripts/mkcompile_h              |    2 +-
 7 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/.gitignore b/.gitignore
index 0f594d9..91f8e0c 100644
--- a/.gitignore
+++ b/.gitignore
@@ -45,7 +45,6 @@ Module.symvers
 # Generated include files
 #
 include/config
-include/linux/autoconf.h
 include/linux/version.h
 include/linux/utsrelease.h
 include/generated
diff --git a/Documentation/kbuild/kconfig.txt b/Documentation/kbuild/kconfig.txt
index 849b5e5..ab8dc35 100644
--- a/Documentation/kbuild/kconfig.txt
+++ b/Documentation/kbuild/kconfig.txt
@@ -106,7 +106,8 @@ This environment variable can be set to specify the path & name of the
 KCONFIG_AUTOHEADER
 --------------------------------------------------
 This environment variable can be set to specify the path & name of the
-"autoconf.h" (header) file.  Its default value is "include/linux/autoconf.h".
+"autoconf.h" (header) file.
+Its default value is "include/generated/autoconf.h".
 
 
 ======================================================================
diff --git a/Makefile b/Makefile
index 6570cf1..b125cd9 100644
--- a/Makefile
+++ b/Makefile
@@ -336,7 +336,7 @@ CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
 # Needed to be compatible with the O= option
 LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include -Iinclude \
                    $(if $(KBUILD_SRC), -I$(srctree)/include) \
-                   -include include/linux/autoconf.h
+                   -include include/generated/autoconf.h
 
 KBUILD_CPPFLAGS := -D__KERNEL__
 
@@ -491,17 +491,18 @@ $(KCONFIG_CONFIG) include/config/auto.conf.cmd: ;
 # if auto.conf.cmd is missing then we are probably in a cleaned tree so
 # we execute the config step to be sure to catch updated Kconfig files
 include/config/auto.conf: $(KCONFIG_CONFIG) include/config/auto.conf.cmd
+	$(Q)mkdir -p include/generated
 	$(Q)$(MAKE) -f $(srctree)/Makefile silentoldconfig
 else
-# external modules needs include/linux/autoconf.h and include/config/auto.conf
+# external modules needs include/generated/autoconf.h and include/config/auto.conf
 # but do not care if they are up-to-date. Use auto.conf to trigger the test
 PHONY += include/config/auto.conf
 
 include/config/auto.conf:
-	$(Q)test -e include/linux/autoconf.h -a -e $@ || (		\
+	$(Q)test -e include/generated/autoconf.h -a -e $@ || (		\
 	echo;								\
 	echo "  ERROR: Kernel configuration is invalid.";		\
-	echo "         include/linux/autoconf.h or $@ are missing.";	\
+	echo "         include/generated/autoconf.h or $@ are missing.";\
 	echo "         Run 'make oldconfig && make prepare' on kernel src to fix it.";	\
 	echo;								\
 	/bin/false)
@@ -1148,7 +1149,7 @@ CLEAN_FILES +=	vmlinux System.map \
 # Directories & files removed with 'make mrproper'
 MRPROPER_DIRS  += include/config usr/include include/generated
 MRPROPER_FILES += .config .config.old .version .old_version             \
-                  include/linux/autoconf.h include/linux/version.h      \
+                  include/linux/version.h                               \
                   include/linux/utsrelease.h                            \
 		  Module.symvers Module.markers tags TAGS cscope*
 
diff --git a/arch/m68k/kernel/head.S b/arch/m68k/kernel/head.S
index 86edb5f..ef54128 100644
--- a/arch/m68k/kernel/head.S
+++ b/arch/m68k/kernel/head.S
@@ -196,7 +196,7 @@
  * for them and trying to understand what they mean.
  *
  * CONFIG_xxx:	These are the obvious machine configuration defines created
- * during configuration.  These are defined in include/linux/autoconf.h.
+ * during configuration.  These are defined in autoconf.h.
  *
  * CONSOLE:	There is support for head.S console in this file.  This
  * console can talk to a Mac frame buffer, but could easily be extrapolated
diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
index 6bf21f8..ea26b23 100644
--- a/scripts/basic/fixdep.c
+++ b/scripts/basic/fixdep.c
@@ -16,15 +16,15 @@
  * tells make when to remake a file.
  *
  * To use this list as-is however has the drawback that virtually
- * every file in the kernel includes <linux/autoconf.h>.
+ * every file in the kernel includes autoconf.h.
  *
- * If the user re-runs make *config, linux/autoconf.h will be
+ * If the user re-runs make *config, autoconf.h will be
  * regenerated.  make notices that and will rebuild every file which
  * includes autoconf.h, i.e. basically all files. This is extremely
  * annoying if the user just changed CONFIG_HIS_DRIVER from n to m.
  *
  * So we play the same trick that "mkdep" played before. We replace
- * the dependency on linux/autoconf.h by a dependency on every config
+ * the dependency on autoconf.h by a dependency on every config
  * option which is mentioned in any of the listed prequisites.
  *
  * kconfig populates a tree in include/config/ with an empty file
@@ -73,7 +73,7 @@
  *   cmd_<target> = <cmdline>
  *
  * and then basically copies the .<target>.d file to stdout, in the
- * process filtering out the dependency on linux/autoconf.h and adding
+ * process filtering out the dependency on autoconf.h and adding
  * dependencies on include/config/my/option.h for every
  * CONFIG_MY_OPTION encountered in any of the prequisites.
  *
@@ -324,7 +324,7 @@ static void parse_dep_file(void *map, size_t len)
 			p++;
 		}
 		memcpy(s, m, p-m); s[p-m] = 0;
-		if (strrcmp(s, "include/linux/autoconf.h") &&
+		if (strrcmp(s, "include/generated/autoconf.h") &&
 		    strrcmp(s, "arch/um/include/uml-config.h") &&
 		    strrcmp(s, ".ver")) {
 			printf("  %s \\\n", s);
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index b55e72f..797a741 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -776,7 +776,7 @@ int conf_write_autoconf(void)
 
 	name = getenv("KCONFIG_AUTOHEADER");
 	if (!name)
-		name = "include/linux/autoconf.h";
+		name = "include/generated/autoconf.h";
 	if (rename(".tmpconfig.h", name))
 		return 1;
 	name = conf_get_autoconfig_name();
diff --git a/scripts/mkcompile_h b/scripts/mkcompile_h
index bce3d0f..23dbad8 100755
--- a/scripts/mkcompile_h
+++ b/scripts/mkcompile_h
@@ -14,7 +14,7 @@ vecho() { [ "${quiet}" = "silent_" ] || echo "$@" ; }
 # So "sudo make install" won't change the "compiled by <user>"
 # do "compiled by root"
 
-if [ -r $TARGET -a ! -O include/linux/autoconf.h ]; then
+if [ -r $TARGET -a ! -O include/generated/autoconf.h ]; then
   vecho "  SKIPPED $TARGET"
   exit 0
 fi
-- 
1.6.2.5

