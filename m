Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbYLTOii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbYLTOii (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 09:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbYLTOax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 09:30:53 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:41309 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYLTOaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 09:30:07 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 10/26] tags and cscope support really belongs in a shell script
Date: Sat, 20 Dec 2008 15:31:21 +0100
Message-Id: <1229783497-19550-10-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081220142518.GA19390@uranus.ravnborg.org>
References: <20081220142518.GA19390@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving the support to a shell script has several benefits:
- The readability of the code has increased a lot
- More people is able to extend the tags support
- We see less changes to the top-level Makefile

The shell script version includes improvements from:
Alexey Dobriyan <adobriyan@gmail.com> (jump to kconfig symbols)
Alexey Dobriyan <adobriyan@gmail.com> (drop ./ in paths)
Ian Campbell <ijc@hellion.org.uk> (simplified find algorithms)

This version has a few caveats:
=> It does not support ALLSOURCE_ARCHS
   - it is easy to add if it is really used
=> It assumes all archs have moved to arch/$ARCH/include
   - until that happens we have a few additional hits in the archs

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Tested-by: Ian Campbell <ijc@hellion.org.uk>
---
 Makefile        |  117 +---------------------------------------
 scripts/tags.sh |  160 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 163 insertions(+), 114 deletions(-)
 create mode 100755 scripts/tags.sh

diff --git a/Makefile b/Makefile
index 3a6ac68..be462cf 100644
--- a/Makefile
+++ b/Makefile
@@ -1409,123 +1409,12 @@ endif # KBUILD_EXTMOD
 
 # Generate tags for editors
 # ---------------------------------------------------------------------------
+quiet_cmd_tags = GEN     $@
+      cmd_tags = $(CONFIG_SHELL) $(srctree)/scripts/tags.sh $@
 
-#We want __srctree to totally vanish out when KBUILD_OUTPUT is not set
-#(which is the most common case IMHO) to avoid unneeded clutter in the big tags file.
-#Adding $(srctree) adds about 20M on i386 to the size of the output file!
-
-ifeq ($(src),$(obj))
-__srctree =
-else
-__srctree = $(srctree)/
-endif
-
-ifeq ($(ALLSOURCE_ARCHS),)
-ifeq ($(ARCH),um)
-ALLINCLUDE_ARCHS := $(ARCH) $(SUBARCH)
-else
-ALLINCLUDE_ARCHS := $(SRCARCH)
-endif
-else
-#Allow user to specify only ALLSOURCE_PATHS on the command line, keeping existing behaviour.
-ALLINCLUDE_ARCHS := $(ALLSOURCE_ARCHS)
-endif
-
-ALLSOURCE_ARCHS := $(SRCARCH)
-
-define find-sources
-        ( for arch in $(ALLSOURCE_ARCHS) ; do \
-	       find $(__srctree)arch/$${arch} $(RCS_FIND_IGNORE) \
-		    -wholename $(__srctree)arch/$${arch}/include/asm -type d -prune \
-	            -o -name $1 -print; \
-	  done ; \
-	  find $(__srctree)security/selinux/include $(RCS_FIND_IGNORE) \
-	       -name $1 -print; \
-	  find $(__srctree)include $(RCS_FIND_IGNORE) \
-	       \( -name config -o -name 'asm-*' \) -prune \
-	       -o -name $1 -print; \
-	  for arch in $(ALLINCLUDE_ARCHS) ; do \
-	       test -e $(__srctree)include/asm-$${arch} && \
-                 find $(__srctree)include/asm-$${arch} $(RCS_FIND_IGNORE) \
-	            -name $1 -print; \
-	       test -e $(__srctree)arch/$${arch}/include/asm && \
-	         find $(__srctree)arch/$${arch}/include/asm $(RCS_FIND_IGNORE) \
-	            -name $1 -print; \
-	  done ; \
-	  find $(__srctree)include/asm-generic $(RCS_FIND_IGNORE) \
-	       -name $1 -print; \
-	  find $(__srctree) $(RCS_FIND_IGNORE) \
-	       \( -name include -o -name arch -o -name '.tmp_*' \) -prune -o \
-	       -name $1 -print; \
-	  )
-endef
-
-define all-sources
-	$(call find-sources,'*.[chS]')
-endef
-define all-kconfigs
-	$(call find-sources,'Kconfig*')
-endef
-define all-defconfigs
-	$(call find-sources,'defconfig')
-endef
-
-define xtags
-	if $1 --version 2>&1 | grep -iq exuberant; then \
-	    $(all-sources) | xargs $1 -a \
-		-I __initdata,__exitdata,__acquires,__releases \
-		-I __read_mostly,____cacheline_aligned,____cacheline_aligned_in_smp,____cacheline_internodealigned_in_smp \
-		-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL \
-		--extra=+f --c-kinds=+px \
-		--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'; \
-	    $(all-kconfigs) | xargs $1 -a \
-		--langdef=kconfig \
-		--language-force=kconfig \
-		--regex-kconfig='/^[[:blank:]]*(menu|)config[[:blank:]]+([[:alnum:]_]+)/\2/'; \
-	    $(all-defconfigs) | xargs -r $1 -a \
-		--langdef=dotconfig \
-		--language-force=dotconfig \
-		--regex-dotconfig='/^#?[[:blank:]]*(CONFIG_[[:alnum:]_]+)/\1/'; \
-	elif $1 --version 2>&1 | grep -iq emacs; then \
-	    $(all-sources) | xargs $1 -a; \
-	    $(all-kconfigs) | xargs $1 -a \
-		--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'; \
-	    $(all-defconfigs) | xargs -r $1 -a \
-		--regex='/^#?[ \t]?\(CONFIG_[a-zA-Z0-9_]+\)/\1/'; \
-	else \
-	    $(all-sources) | xargs $1 -a; \
-	fi
-endef
-
-quiet_cmd_cscope-file = FILELST cscope.files
-      cmd_cscope-file = (echo \-k; echo \-q; $(all-sources)) > cscope.files
-
-quiet_cmd_cscope = MAKE    cscope.out
-      cmd_cscope = cscope -b -f cscope.out
-
-cscope: FORCE
-	$(call cmd,cscope-file)
-	$(call cmd,cscope)
-
-quiet_cmd_TAGS = MAKE   $@
-define cmd_TAGS
-	rm -f $@; \
-	$(call xtags,etags)
-endef
-
-TAGS: FORCE
-	$(call cmd,TAGS)
-
-quiet_cmd_tags = MAKE   $@
-define cmd_tags
-	rm -f $@; \
-	$(call xtags,ctags)
-endef
-
-tags: FORCE
+tags TAGS cscope: FORCE
 	$(call cmd,tags)
 
-
 # Scripts to check various things for consistency
 # ---------------------------------------------------------------------------
 
diff --git a/scripts/tags.sh b/scripts/tags.sh
new file mode 100755
index 0000000..47274dc
--- /dev/null
+++ b/scripts/tags.sh
@@ -0,0 +1,160 @@
+#!/bin/sh
+# Generate tags or cscope files
+# Usage tags.sh <mode>
+#
+# mode may be any of: tags, TAGS, cscope
+#
+# Uses the following environment variables:
+# ARCH, SUBARCH, srctree, src, obj
+
+if [ $KBUILD_VERBOSE == 1 ]; then
+	set -x
+fi
+
+# This is a duplicate of RCS_FIND_IGNORE without escaped '()'
+ignore="( -name SCCS -o -name BitKeeper -o -name .svn -o \
+          -name CVS  -o -name .pc       -o -name .hg  -o \
+          -name .git )                                   \
+          -prune -o"
+
+# Do not use full path is we do not use O=.. builds
+if [ ${src} == ${obj} ]; then
+	tree=
+else
+	tree=${srctree}
+fi
+
+# find sources in arch/$ARCH
+find_arch_sources()
+{
+	find ${tree}arch/$1 $ignore -name $2 -print;
+}
+
+# find sources in arch/$1/include
+find_arch_include_sources()
+{
+	find ${tree}arch/$1/include $ignore -name $2 -print;
+}
+
+# find sources in include/
+find_include_sources()
+{
+	find ${tree}include $ignore -name config -prune -o -name $1 -print;
+}
+
+# find sources in rest of tree
+# we could benefit from a list of dirs to search in here
+find_other_sources()
+{
+	find ${tree}* $ignore \
+	     \( -name include -o -name arch -o -name '.tmp_*' \) -prune -o \
+	       -name $1 -print;
+}
+
+find_sources()
+{
+	find_arch_sources $1 $2
+	find_include_sources $2
+	find_other_sources $2
+}
+
+all_sources()
+{
+	find_sources $SRCARCH *.[chS]
+	if [ ! -z "$archinclude" ]; then
+		find_arch_include_sources $archinclude *.[chS]
+	fi
+}
+
+all_kconfigs()
+{
+	find_sources $SRCARCH "Kconfig*"
+}
+
+all_defconfigs()
+{
+	find_sources $SRCARCH "defconfig"
+}
+
+docscope()
+{
+	(echo \-k; echo \-q; all_sources) > cscope.files
+	cscope -b -f cscope.out
+}
+
+exuberant()
+{
+	all_sources > all
+	all_sources | xargs $1 -a                               \
+	-I __initdata,__exitdata,__acquires,__releases          \
+	-I __read_mostly,____cacheline_aligned                  \
+	-I ____cacheline_aligned_in_smp                         \
+	-I ____cacheline_internodealigned_in_smp                \
+	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL                      \
+	--extra=+f --c-kinds=+px                                \
+	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'
+
+	all_kconfigs | xargs $1 -a                              \
+	--langdef=kconfig --language-force=kconfig              \
+	--regex-kconfig='/^[[:blank:]]*(menu|)config[[:blank:]]+([[:alnum:]_]+)/\2/'
+
+	all_kconfigs | xargs $1 -a                              \
+	--langdef=kconfig --language-force=kconfig              \
+	--regex-kconfig='/^[[:blank:]]*(menu|)config[[:blank:]]+([[:alnum:]_]+)/CONFIG_\2/'
+
+	all_defconfigs | xargs -r $1 -a                         \
+	--langdef=dotconfig --language-force=dotconfig          \
+	--regex-dotconfig='/^#?[[:blank:]]*(CONFIG_[[:alnum:]_]+)/\1/'
+
+}
+
+emacs()
+{
+	all_sources | xargs $1 -a
+
+	all_kconfigs | xargs $1 -a                              \
+	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'
+
+	all_kconfigs | xargs $1 -a                              \
+	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/CONFIG_\3/'
+
+	all_defconfigs | xargs -r $1 -a                         \
+	--regex='/^#?[ \t]?\(CONFIG_[a-zA-Z0-9_]+\)/\1/'
+}
+
+xtags()
+{
+	if $1 --version 2>&1 | grep -iq exuberant; then
+		exuberant $1
+	elif $1 --version 2>&1 | grep -iq emacs; then
+		emacs $1
+	else
+		all_sources | xargs $1 -a
+        fi
+}
+
+
+# Support um (which uses SUBARCH)
+if [ ${ARCH} == um ]; then
+	if [ $SUBARCH == i386 ]; then
+		archinclude=x86
+	elif [ $SUBARCH == x86_64 ]; then
+		archinclude=x86
+	else
+		archinclude=${SUBARCH}
+	fi
+fi
+
+case "$1" in
+	"cscope")
+		docscope
+		;;
+
+	"tags")
+		xtags ctags
+		;;
+
+	"TAGS")
+		xtags etags
+		;;
+esac
-- 
1.6.0.2.GIT

