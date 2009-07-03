Return-Path: <linux-kernel-owner+w=401wt.eu-S1759304AbZGCVlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbZGCVlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 17:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757786AbZGCVkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 17:40:52 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:53722 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365AbZGCVku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 17:40:50 -0400
Date: Fri, 3 Jul 2009 23:43:09 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, WANG Cong <amwang@redhat.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       Floris Kraak <randakar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Frans Pop <elendil@planet.nl>,
       maximilian attems <max@stro.at>, Tim Abbott <tabbott@ksplice.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [GIT] kbuild fixes
Message-ID: <20090703214309.GA15265@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

- various .gitignore updates
- disabling of -Wformat-security
  We looked at it and 'fixing' the warnings was not pleasant
- fixes/improvements for the newly introduced macros in asm-generic/vmlinux.lds.h

Nothing earth-shaking..
And it has been in -next for a few days with no issues.

I am heading for a two week vacation in Sweden and will
be offline in that period.
Enjoy the kernel hacking while I enjoy my vacation :-) 

	Sam


The following changes since commit 4075ea8c54a7506844a69f674990241e7766357b:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../bp/bp

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git master

Amerigo Wang (2):
      gitignore: ignore gcov output files
      kbuild: finally remove the obsolete variable $TOPDIR

Floris Kraak (1):
      Kbuild: Disable the -Wformat-security gcc flag

Jaswinder Singh Rajput (1):
      gitignore: ignore scripts/ihex2fw

Paul Mundt (1):
      asm-generic/vmlinux.lds.h: Fix up RW_DATA_SECTION definition.

Tim Abbott (3):
      Add new macros for page-aligned data and bss sections.
      asm-generic/vmlinux.lds.h: shuffle INIT_TASK* macro names in vmlinux.lds.h
      Add new __init_task_data macro to be used in arch init_task.c files.

maximilian attems (1):
      kbuild: deb-pkg ship changelog

 .gitignore                        |    1 +
 Makefile                          |    7 +++----
 arch/mn10300/kernel/vmlinux.lds.S |    2 +-
 drivers/scsi/cxgb3i/Kbuild        |    2 +-
 include/asm-generic/vmlinux.lds.h |   12 ++++++------
 include/linux/init_task.h         |    3 +++
 include/linux/linkage.h           |    9 +++++++++
 scripts/.gitignore                |    1 +
 scripts/package/builddeb          |    2 ++
 9 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/.gitignore b/.gitignore
index cecb3b0..b93fb7e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -27,6 +27,7 @@
 *.gz
 *.lzma
 *.patch
+*.gcno
 
 #
 # Top-level generic files
diff --git a/Makefile b/Makefile
index d1216fe..b4c7ef5 100644
--- a/Makefile
+++ b/Makefile
@@ -140,15 +140,13 @@ _all: modules
 endif
 
 srctree		:= $(if $(KBUILD_SRC),$(KBUILD_SRC),$(CURDIR))
-TOPDIR		:= $(srctree)
-# FIXME - TOPDIR is obsolete, use srctree/objtree
 objtree		:= $(CURDIR)
 src		:= $(srctree)
 obj		:= $(objtree)
 
 VPATH		:= $(srctree)$(if $(KBUILD_EXTMOD),:$(KBUILD_EXTMOD))
 
-export srctree objtree VPATH TOPDIR
+export srctree objtree VPATH
 
 
 # SUBARCH tells the usermode build what the underlying arch is.  That is set
@@ -344,7 +342,8 @@ KBUILD_CPPFLAGS := -D__KERNEL__
 
 KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common \
-		   -Werror-implicit-function-declaration
+		   -Werror-implicit-function-declaration \
+		   -Wno-format-security
 KBUILD_AFLAGS   := -D__ASSEMBLY__
 
 # Read KERNELRELEASE from include/config/kernel.release (if it exists)
diff --git a/arch/mn10300/kernel/vmlinux.lds.S b/arch/mn10300/kernel/vmlinux.lds.S
index bcebcef..c96ba3d 100644
--- a/arch/mn10300/kernel/vmlinux.lds.S
+++ b/arch/mn10300/kernel/vmlinux.lds.S
@@ -61,7 +61,7 @@ SECTIONS
 	_edata = .;		/* End of data section */
   }
 
-  .data.init_task : { INIT_TASK(THREAD_SIZE); }
+  .data.init_task : { INIT_TASK_DATA(THREAD_SIZE); }
 
   /* might get freed after init */
   . = ALIGN(PAGE_SIZE);
diff --git a/drivers/scsi/cxgb3i/Kbuild b/drivers/scsi/cxgb3i/Kbuild
index 25a2032..70d060b 100644
--- a/drivers/scsi/cxgb3i/Kbuild
+++ b/drivers/scsi/cxgb3i/Kbuild
@@ -1,4 +1,4 @@
-EXTRA_CFLAGS += -I$(TOPDIR)/drivers/net/cxgb3
+EXTRA_CFLAGS += -I$(srctree)/drivers/net/cxgb3
 
 cxgb3i-y := cxgb3i_init.o cxgb3i_iscsi.o cxgb3i_pdu.o cxgb3i_offload.o cxgb3i_ddp.o
 obj-$(CONFIG_SCSI_CXGB3_ISCSI) += cxgb3i.o
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 92b73b6..720af4c 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -191,7 +191,7 @@
 	. = ALIGN(align);						\
 	*(.data.cacheline_aligned)
 
-#define INIT_TASK(align)						\
+#define INIT_TASK_DATA(align)						\
 	. = ALIGN(align);						\
 	*(.data.init_task)
 
@@ -434,10 +434,10 @@
 /*
  * Init task
  */
-#define INIT_TASK_DATA(align)						\
+#define INIT_TASK_DATA_SECTION(align)					\
 	. = ALIGN(align);						\
 	.data.init_task : {						\
-		INIT_TASK						\
+		INIT_TASK_DATA(align)					\
 	}
 
 #ifdef CONFIG_CONSTRUCTORS
@@ -704,15 +704,15 @@
  * matches the requirment of PAGE_ALIGNED_DATA.
  *
  * use 0 as page_align if page_aligned data is not used */
-#define RW_DATA_SECTION(cacheline, nosave, pagealigned, inittask)	\
+#define RW_DATA_SECTION(cacheline, pagealigned, inittask)		\
 	. = ALIGN(PAGE_SIZE);						\
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {				\
-		INIT_TASK(inittask)					\
+		INIT_TASK_DATA(inittask)				\
 		CACHELINE_ALIGNED_DATA(cacheline)			\
 		READ_MOSTLY_DATA(cacheline)				\
 		DATA_DATA						\
 		CONSTRUCTORS						\
-		NOSAVE_DATA(nosave)					\
+		NOSAVE_DATA						\
 		PAGE_ALIGNED_DATA(pagealigned)				\
 	}
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 5368fbd..7fc01b1 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -183,5 +183,8 @@ extern struct cred init_cred;
 	LIST_HEAD_INIT(cpu_timers[2]),					\
 }
 
+/* Attach to the init_task data structure for proper alignment */
+#define __init_task_data __attribute__((__section__(".data.init_task")))
+
 
 #endif
diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index fee9e59..691f591 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -22,6 +22,15 @@
 #define __page_aligned_bss	__section(.bss.page_aligned) __aligned(PAGE_SIZE)
 
 /*
+ * For assembly routines.
+ *
+ * Note when using these that you must specify the appropriate
+ * alignment directives yourself
+ */
+#define __PAGE_ALIGNED_DATA	.section ".data.page_aligned", "aw"
+#define __PAGE_ALIGNED_BSS	.section ".bss.page_aligned", "aw"
+
+/*
  * This is used by architectures to keep arguments on the stack
  * untouched by the compiler by keeping them live until the end.
  * The argument stack may be owned by the assembly-language
diff --git a/scripts/.gitignore b/scripts/.gitignore
index b939fbd..52cab46 100644
--- a/scripts/.gitignore
+++ b/scripts/.gitignore
@@ -7,3 +7,4 @@ pnmtologo
 bin2c
 unifdef
 binoffset
+ihex2fw
diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 01c2d13..b19f1f4 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -16,6 +16,8 @@ create_package() {
 	local pname="$1" pdir="$2"
 
 	cp debian/copyright "$pdir/usr/share/doc/$pname/"
+	cp debian/changelog "$pdir/usr/share/doc/$pname/changelog.Debian"
+	gzip -9 "$pdir/usr/share/doc/$pname/changelog.Debian"
 
 	# Fix ownership and permissions
 	chown -R root:root "$pdir"
