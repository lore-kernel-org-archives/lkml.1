Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZGTUf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZGTUf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZGTUfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:35:25 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:35287 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbZGTUfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:35:23 -0400
Date: Mon, 20 Jul 2009 22:35:21 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>, Tim Abbott <tabbott@ksplice.com>,
       Arnaud Lacombe <lacombar@gmail.com>, maximilian attems <max@stro.at>
Subject: [GIT] kbuild fixes
Message-ID: <20090720203521.GA6904@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Four kbuild fixlets:

1) Fix to newly introduced vmlinux macros.
   There is one in-tree user which is fixed up.

2) Two fixlets to make menuconfig more cygwin friendly

3) install scrip fix for deb-pkg

This has been in -next at least for one iteration with no comments.
Combined diff below.

Please pull - thanks!

	Sam

The following changes since commit 4b0a84043e0c14088958fddb62f416d050368011:
  Linus Torvalds (1):
        Merge branch 'sched-fixes-for-linus' of git://git.kernel.org/.../peterz/linux-2.6-sched

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git master

Arnaud Lacombe (2):
      kconfig: variable argument lists needs `stdarg.h'
      kconfig: initialize the screen before using curses(3) functions

Tim Abbott (1):
      vmlinux.lds.h: restructure BSS linker script macros

maximilian attems (1):
      kbuild, deb-pkg: fix install scripts for posix sh

 arch/mn10300/kernel/vmlinux.lds.S |    2 +-
 include/asm-generic/vmlinux.lds.h |   19 +++++++++----------
 scripts/kconfig/lxdialog/util.c   |    2 ++
 scripts/kconfig/mconf.c           |    2 ++
 scripts/package/builddeb          |    2 +-
 5 files changed, 15 insertions(+), 12 deletions(-)


diff --git a/arch/mn10300/kernel/vmlinux.lds.S b/arch/mn10300/kernel/vmlinux.lds.S
index c96ba3d..f4aa079 100644
--- a/arch/mn10300/kernel/vmlinux.lds.S
+++ b/arch/mn10300/kernel/vmlinux.lds.S
@@ -107,7 +107,7 @@ SECTIONS
   __init_end = .;
   /* freed after init ends here */
 
-  BSS(4)
+  BSS_SECTION(0, PAGE_SIZE, 4)
 
   _end = . ;
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index a553f10..6ad76bf 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -30,9 +30,7 @@
  *	EXCEPTION_TABLE(...)
  *	NOTES
  *
- *	__bss_start = .;
- *	BSS_SECTION(0, 0)
- *	__bss_stop = .;
+ *	BSS_SECTION(0, 0, 0)
  *	_end = .;
  *
  *	/DISCARD/ : {
@@ -489,7 +487,8 @@
  * bss (Block Started by Symbol) - uninitialized data
  * zeroed during startup
  */
-#define SBSS								\
+#define SBSS(sbss_align)						\
+	. = ALIGN(sbss_align);						\
 	.sbss : AT(ADDR(.sbss) - LOAD_OFFSET) {				\
 		*(.sbss)						\
 		*(.scommon)						\
@@ -498,12 +497,10 @@
 #define BSS(bss_align)							\
 	. = ALIGN(bss_align);						\
 	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {				\
-		VMLINUX_SYMBOL(__bss_start) = .;			\
 		*(.bss.page_aligned)					\
 		*(.dynbss)						\
 		*(.bss)							\
 		*(COMMON)						\
-		VMLINUX_SYMBOL(__bss_stop) = .;				\
 	}
 
 /*
@@ -735,8 +732,10 @@
 		INIT_RAM_FS						\
 	}
 
-#define BSS_SECTION(sbss_align, bss_align)				\
-	SBSS								\
+#define BSS_SECTION(sbss_align, bss_align, stop_align)			\
+	. = ALIGN(sbss_align);						\
+	VMLINUX_SYMBOL(__bss_start) = .;				\
+	SBSS(sbss_align)						\
 	BSS(bss_align)							\
-	. = ALIGN(4);
-
+	. = ALIGN(stop_align);						\
+	VMLINUX_SYMBOL(__bss_stop) = .;
diff --git a/scripts/kconfig/lxdialog/util.c b/scripts/kconfig/lxdialog/util.c
index 86d95cc..f2375ad 100644
--- a/scripts/kconfig/lxdialog/util.c
+++ b/scripts/kconfig/lxdialog/util.c
@@ -19,6 +19,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <stdarg.h>
+
 #include "dialog.h"
 
 struct dialog_info dlg;
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 3bcacb4..25b60bc 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -888,6 +888,8 @@ int main(int ac, char **av)
 			single_menu_mode = 1;
 	}
 
+	initscr();
+
 	getyx(stdscr, saved_y, saved_x);
 	if (init_dialog(NULL)) {
 		fprintf(stderr, N_("Your display is too small to run Menuconfig!\n"));
diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index b19f1f4..8b357b0 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -89,7 +89,7 @@ for script in postinst postrm preinst prerm ; do
 set -e
 
 # Pass maintainer script parameters to hook scripts
-export DEB_MAINT_PARAMS="\$@"
+export DEB_MAINT_PARAMS="\$*"
 
 test -d $debhookdir/$script.d && run-parts --arg="$version" $debhookdir/$script.d
 exit 0
