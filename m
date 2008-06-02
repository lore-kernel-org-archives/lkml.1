Return-Path: <linux-kernel-owner+w=401wt.eu-S1761351AbYFBNgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761351AbYFBNgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbYFBNff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:35:35 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:63137 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760861AbYFBNfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:35:32 -0400
Message-ID: <4843F6EB.6040901@de.ibm.com>
Date: Mon, 02 Jun 2008 15:34:35 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: [PATCH 5/6] gcov: create links to .gcda files in build directory
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Modify kbuild to create symbolic links in the build directory which
refer to the .gcda files in sysfs.

Required by the gcov profiling infrastructure: the gcov tool requires
all data files (x.gcda, x.gcno) to be found in the same directory.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 Makefile               |   11 ++++++-----
 scripts/Makefile.build |    9 ++++++++-
 2 files changed, 14 insertions(+), 6 deletions(-)

Index: linux-2.6.26-rc4/Makefile
===================================================================
--- linux-2.6.26-rc4.orig/Makefile
+++ linux-2.6.26-rc4/Makefile
@@ -321,7 +321,7 @@ LDFLAGS_MODULE  =
 CFLAGS_KERNEL	=
 AFLAGS_KERNEL	=
 CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
-
+GCOV_DATA_DIR	= /sys/kernel/debug/gcov
 
 # Use LINUXINCLUDE when you must reference the include/ directory.
 # Needed to be compatible with the O= option
@@ -343,7 +343,7 @@ KERNELVERSION = $(VERSION).$(PATCHLEVEL)
 export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION
 export ARCH SRCARCH CONFIG_SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
 export CPP AR NM STRIP OBJCOPY OBJDUMP MAKE AWK GENKSYMS PERL UTS_MACHINE
-export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
+export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS GCOV_DATA_DIR
 
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS LDFLAGS
 export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE CFLAGS_GCOV
@@ -1135,8 +1135,8 @@ clean: archclean $(clean-dirs)
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
 		-o -name '*.symtypes' -o -name 'modules.order' \
-		-o -name '*.gcno' \) \
-		-type f -print | xargs rm -f
+		-o -name '*.gcno' -o -name '*.gcda' \) \
+		\( -type f -o -type l \) -print | xargs rm -f
 
 # mrproper - Delete all generated files, including .config
 #
@@ -1340,7 +1340,8 @@ clean: $(clean-dirs)
 	@find $(KBUILD_EXTMOD) $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
-		-o -name '*.gcno' \) -type f -print | xargs rm -f
+		-o -name '*.gcno' -o -name '*.gcda' \) \
+		\( -type f -o -type l \) -print | xargs rm -f
 
 help:
 	@echo  '  Building external modules.'
Index: linux-2.6.26-rc4/scripts/Makefile.build
===================================================================
--- linux-2.6.26-rc4.orig/scripts/Makefile.build
+++ linux-2.6.26-rc4/scripts/Makefile.build
@@ -198,6 +198,12 @@ cmd_modversions =							\
 	fi;
 endif
 
+ifdef CONFIG_GCOV_PROFILE
+# Create a link to the gcov data file in /sys
+cmd_gcov = ln -s -f $(GCOV_DATA_DIR)$(if \
+	$(filter-out /%,$(@D)),$(objtree)/$(@D),$(@D))/$(@F:.o=.gcda) $(@D)
+endif
+
 define rule_cc_o_c
 	$(call echo-cmd,checksrc) $(cmd_checksrc)			  \
 	$(call echo-cmd,cc_o_c) $(cmd_cc_o_c);				  \
@@ -205,7 +211,8 @@ define rule_cc_o_c
 	scripts/basic/fixdep $(depfile) $@ '$(call make-cmd,cc_o_c)' >    \
 	                                              $(dot-target).tmp;  \
 	rm -f $(depfile);						  \
-	mv -f $(dot-target).tmp $(dot-target).cmd
+	mv -f $(dot-target).tmp $(dot-target).cmd;			  \
+	$(cmd_gcov)
 endef
 
 # Built-in and composite module parts




