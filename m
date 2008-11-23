Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbYKWIwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbYKWIwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 03:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbYKWIwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 03:52:44 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:40443 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbYKWIwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 03:52:43 -0500
Date: Sun, 23 Nov 2008 09:54:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Jim Radford <radford@galvanix.net>, Ian Campbell <ijc@hellion.org.uk>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC PATCH] kbuild: move tags support to a shell script
Message-ID: <20081123085406.GA29543@uranus.ravnborg.org>
References: <20081122231631.GA6456@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081122231631.GA6456@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My naive transformation to a shell script could benefit from
> a pair of critical eyes too.

And so I did.
Improved version follows.
Changes:
- Fixed several bugs compared to first version
- introduced a few more functions to improve readability
- simplified find logic based on patches previously submitted
  by Ian Campbell <ijc@hellion.org.uk>
- improved kconfig support based on patches previously submitted
  by Alexey Dobriyan <adobriyan@gmail.com>
- tried to squeze it into 80 char limit but the regexs did not fully allow that


	Sam

>From 915f5d850d6273c0c2a348a63a738f49fba712e8 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 23 Nov 2008 09:41:23 +0100
Subject: [PATCH] kbuild: move tags support to a shell script

tags and cscope support really belongs in a shell script
as they do not benefit from the make functionality.

Moving the support to a shell script has several benefits:
- The readability of the code has increased a lot
- More people is able to extend the tags support
- We see less changes to the top-level Makefile

The shell script version includes improvements from:
Alexey Dobriyan <adobriyan@gmail.com> (jump to kconfig symbols)
Ian Campbell <ijc@hellion.org.uk> (simplified find algorithms)

This version has a few caveats:
=> It does not support ALLSOURCE_ARCHS
   - it is easy to add if it is really used
=> It assumes all archs have moved to arch/$ARCH/include

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile        |  118 +-------------------------------------------
 scripts/tags.sh |  148 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 150 insertions(+), 116 deletions(-)
 create mode 100644 scripts/tags.sh

diff --git a/Makefile b/Makefile
index 391b2da..3e6cb2b 100644
--- a/Makefile
+++ b/Makefile
@@ -1409,122 +1409,8 @@ endif # KBUILD_EXTMOD
 
 # Generate tags for editors
 # ---------------------------------------------------------------------------
-
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
-	$(call cmd,tags)
-
+tags TAGS cscope: FORCE
+	$(CONFIG_SHELL) $(srctree)/scripts/tags.sh $@
 
 # Scripts to check various things for consistency
 # ---------------------------------------------------------------------------
diff --git a/scripts/tags.sh b/scripts/tags.sh
new file mode 100644
index 0000000..00e785f
--- /dev/null
+++ b/scripts/tags.sh
@@ -0,0 +1,148 @@
+#!/bin/sh
+# Generate tags or cscope files
+# Usage tags.sh <mode>
+#
+# mode may be any of: tags, TAGS, cscope
+#
+# Uses the following environment variables:
+# ARCH, SUBARCH, srctree, src, obj
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
+	for arch in $1; do
+		find_arch_sources $arch $2
+	done
+
+	find_include_sources "$2"
+	find_other_sources "$2"
+}
+
+all_sources()
+{
+	find_sources "${archs}" *.[chS]
+}
+
+all_kconfigs()
+{
+	find_sources "${archs}" "Kconfig*"
+}
+
+all_defconfigs()
+{
+	find_sources "${archs}" "defconfig"
+}
+
+docscope()
+{
+	(echo \-k; echo \-q; all_sources) > cscope.files
+	cnt=$(wc -l cscope.files | cut -d ' ' -f 1)
+	echo "  GEN     cscope.out (from $cnt files)"
+	cscope -b -f cscope.out
+}
+
+exuberant()
+{
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
+# Support um (which has SUBARCH)
+# FIXME: add support for ALLSOURCE_ARCHS if really used
+if [ "${ARCH}" == "${SUBARCH}" ]; then
+	archs="${ARCH} ${SUBARCH}"
+else
+	archs="${SRCARCH}"
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
1.5.6.GIT

