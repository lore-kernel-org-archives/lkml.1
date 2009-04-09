Return-Path: <linux-kernel-owner+w=401wt.eu-S1765524AbZDIUkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765524AbZDIUkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 16:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759885AbZDIUkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 16:40:18 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:36240 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758317AbZDIUkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 16:40:17 -0400
Date: Thu, 9 Apr 2009 22:42:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [ANNOUNCE] headercheck - check dependencies on header files
Message-ID: <20090409204219.GA31511@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have at several occasions discussed if our header files
should include their dependencies or not.

But we were lacking a tool to tell us if our header files
included the headerfiles they needed or not.

headercheck can be used to do so.

headercheck use the existing Kbuild files in
include/ to determine which directories to visit.

And for each directory it create one .c file for each
.h file and build it.

A .c file looks like this:

	$cat module.h.c
		#include <linux/module.h>


Building this file will tell us if module.h is
missing any dependencies (but NOT if it has too many) with
the current configuration.

We know that some header files are simply NOT supposed to be included
direct and thus is not eligble to such a check.

To avoid checking these we can say in Kbuild:

	ignore-y += compiler-gcc.h

This tells headercheck to ignore compiler-gcc.h when performing
the headercheck.

The current implementation leaves a lot of .c files.
I will address this if the concept is considered acceptable.

To visit all relevant directories we need to adjust the Kbuild
files but that can wait until we have the current pile fixed.
Likewise it does not support arch specific include files.
That can wait too.

I have tried running headercheck on an i386 defconfig and
the result shows that a lot af headers does not include there
dependencies.

The numbers (including sub-directories): 

     25 include/asm-generic
     12 include/drm
    282 include/linux
      2 include/mtd
     24 include/sound
     12 include/video

Remember we do not visit all directories - only those listed in include/Kbuild.

To try it yourself apply following patch and on a configured kernel use:

    make -k headercheck

Looking at the errors I would assume that at least 75% of the errors
can be fixed in one day but the rest may be a bit more troublesome.

The open question is if this is worthwhile? 

	Sam


>From a88159a3bcbae4e5748d25f71d761c142d89c85d Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 9 Apr 2009 21:56:03 +0200
Subject: [PATCH] kbuild: add headercheck

headercheck is used to check if all headerfiles include the
files that is needed for a headerfile to build.

It visits all directories listed in include/Kbuild using header-y.
And for each header file it creates a .c file that is then build.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile                   |    6 +++++
 include/linux/Kbuild       |    7 ++++++
 scripts/Kbuild.headercheck |   46 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 0 deletions(-)
 create mode 100644 scripts/Kbuild.headercheck

diff --git a/Makefile b/Makefile
index e5ad5fd..39ed688 100644
--- a/Makefile
+++ b/Makefile
@@ -837,6 +837,9 @@ vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o $(kallsyms.o)
 ifdef CONFIG_HEADERS_CHECK
 	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
 endif
+ifndef CONFIG_INCLUDE_HEADER_CHECK
+	$(Q)$(MAKE) -f $(srctree)/scripts/Kbuild.headercheck obj=include
+endif
 ifdef CONFIG_SAMPLES
 	$(Q)$(MAKE) $(build)=samples
 endif
@@ -1463,6 +1466,9 @@ namespacecheck:
 export_report:
 	$(PERL) $(srctree)/scripts/export_report.pl
 
+headercheck:
+	$(Q)$(MAKE) -f $(srctree)/scripts/Kbuild.headercheck obj=include
+
 endif #ifeq ($(config-targets),1)
 endif #ifeq ($(mixed-targets),1)
 
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index ca9b9b9..49b61ff 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -375,3 +375,10 @@ unifdef-y += xfrm.h
 objhdr-y += version.h
 header-y += wimax.h
 header-y += wimax/
+
+# header files that cannot be build alone
+# (not checked by make headercheck)
+ignore-y += compiler-intel.h
+ignore-y += compiler-gcc.h
+ignore-y += compiler-gcc3.h
+ignore-y += compiler-gcc4.h
diff --git a/scripts/Kbuild.headercheck b/scripts/Kbuild.headercheck
new file mode 100644
index 0000000..9701341
--- /dev/null
+++ b/scripts/Kbuild.headercheck
@@ -0,0 +1,46 @@
+# ==========================================================================
+# Check that the header files include all files needed for them to build
+# without errors
+#
+# The Kbuild files used for specifying exported header files are used
+# to tell what headerfile to check.
+#
+# header-y  - used to tell what directories to visit
+# ignore-y  - list files we should not check
+#
+# ==========================================================================
+
+.PHONY: __headercheck
+__headercheck:
+
+include scripts/Kbuild.include
+
+kbuild-file := $(srctree)/$(obj)/Kbuild
+include $(kbuild-file)
+
+include $(srctree)/scripts/Makefile.lib
+
+headers       := $(wildcard $(srctree)/$(obj)/*.h)
+ignores       := $(addprefix $(srctree)/$(obj)/,$(ignore-y))
+headers       := $(filter-out $(ignores), $(headers))
+headers       := $(sort $(headers))
+
+subdirs       := $(patsubst %/,%,$(filter %/, $(header-y)))
+
+o_files := $(addsuffix .o, $(headers))
+
+__headercheck: $(subdirs) $(o_files)
+	echo $^
+
+
+include_name = $(subst $(srctree)/include/,,$<)
+
+$(o_files): %.h.o : %.h
+	$(Q)echo "#include <$(include_name)>" > $(@:.o=.c)
+	$(Q)$(CC) $(c_flags) -c -o $@ $<
+
+
+.PHONY: $(subdirs)
+$(subdirs):
+	$(Q)$(MAKE) -f $(srctree)/scripts/Kbuild.headercheck obj=$(obj)/$@
+
-- 
1.6.0.2.GIT



