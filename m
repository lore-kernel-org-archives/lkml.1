Return-Path: <linux-kernel-owner+w=401wt.eu-S1760305AbYG2UK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbYG2UK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbYG2UJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:09:14 -0400
Received: from xenotime.net ([66.160.160.81]:57021 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751969AbYG2UJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:09:10 -0400
Date: Tue, 29 Jul 2008 13:05:15 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 1/5] docsrc: build Documentation/ sources
Message-ID: <12173619152424@xenotime.net>
In-Reply-To: 
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Currently source files in the Documentation/ sub-dir can easily bit-rot
since they are not generally buildable, either because they are hidden
in text files or because there are no Makefile rules for them.
This needs to be fixed so that the source files remain usable and good
examples of code instead of bad examples.

Add the ability to build source files that are in the Documentation/ dir.
Add to Kconfig as "BUILD_DOCSRC" config symbol.

Use "CONFIG_BUILD_DOCSRC=1 make ..." to build objects from the
Documentation/ sources.  Or enable BUILD_DOCSRC in the *config system.
However, this symbol depends on HEADERS_CHECK since the header files
need to be installed (for userspace builds).

Built (using cross-tools) for x86-64, i386, alpha, ia64, sparc32,
sparc64, powerpc, sh, m68k, & mips.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
---
 Documentation/DocBook/Makefile              |    7 +++++++
 Documentation/Makefile                      |    3 +++
 Documentation/accounting/Makefile           |   10 ++++++++++
 Documentation/auxdisplay/Makefile           |   10 ++++++++++
 Documentation/connector/Makefile            |   11 +++++++++++
 Documentation/filesystems/configfs/Makefile |    3 +++
 Documentation/ia64/Makefile                 |    8 ++++++++
 Documentation/networking/Makefile           |    8 ++++++++
 Documentation/pcmcia/Makefile               |   10 ++++++++++
 Documentation/spi/Makefile                  |   11 +++++++++++
 Documentation/video4linux/Makefile          |    8 ++++++++
 Documentation/vm/Makefile                   |    8 ++++++++
 Documentation/watchdog/src/Makefile         |    8 ++++++++
 Makefile                                    |    5 ++++-
 lib/Kconfig.debug                           |    9 +++++++++
 15 files changed, 118 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/Makefile
 create mode 100644 Documentation/accounting/Makefile

--- /dev/null
+++ linux-next-20080729/Documentation/Makefile
@@ -0,0 +1,3 @@
+obj-m := DocBook/ accounting/ auxdisplay/ connector/ \
+	filesystems/configfs/ ia64/ networking/ \
+	pcmcia/ spi/ video4linux/ vm/ watchdog/src/
--- /dev/null
+++ linux-next-20080729/Documentation/accounting/Makefile
@@ -0,0 +1,10 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := getdelays
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
+
+HOSTCFLAGS_getdelays.o += -I$(objtree)/usr/include
--- linux-next-20080729.orig/Makefile
+++ linux-next-20080729/Makefile
@@ -823,6 +823,9 @@ endif
 ifdef CONFIG_SAMPLES
 	$(Q)$(MAKE) $(build)=samples
 endif
+ifdef CONFIG_BUILD_DOCSRC
+	$(Q)$(MAKE) $(build)=Documentation
+endif
 	$(call vmlinux-modpost)
 	$(call if_changed_rule,vmlinux__)
 	$(Q)rm -f .old_version
@@ -1167,7 +1170,7 @@ MRPROPER_FILES += .config .config.old in
 #
 clean: rm-dirs  := $(CLEAN_DIRS)
 clean: rm-files := $(CLEAN_FILES)
-clean-dirs      := $(addprefix _clean_,$(srctree) $(vmlinux-alldirs))
+clean-dirs      := $(addprefix _clean_,$(srctree) $(vmlinux-alldirs) Documentation)
 
 PHONY += $(clean-dirs) clean archclean
 $(clean-dirs):
--- linux-next-20080729.orig/Documentation/DocBook/Makefile
+++ linux-next-20080729/Documentation/DocBook/Makefile
@@ -102,6 +102,13 @@ C-procfs-example = procfs_example.xml
 C-procfs-example2 = $(addprefix $(obj)/,$(C-procfs-example))
 $(obj)/procfs-guide.xml: $(C-procfs-example2)
 
+# List of programs to build
+##oops, this is a kernel module::hostprogs-y := procfs_example
+obj-m += procfs_example.o
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
+
 notfoundtemplate = echo "*** You have to install docbook-utils or xmlto ***"; \
 		   exit 1
 db2xtemplate = db2TYPE -o $(dir $@) $<
--- /dev/null
+++ linux-next-20080729/Documentation/auxdisplay/Makefile
@@ -0,0 +1,10 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := cfag12864b-example
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
+
+HOSTCFLAGS_cfag12864b-example.o += -I$(objtree)/usr/include
--- /dev/null
+++ linux-next-20080729/Documentation/connector/Makefile
@@ -0,0 +1,11 @@
+ifneq ($(CONFIG_CONNECTOR),)
+obj-m += cn_test.o
+endif
+
+# List of programs to build
+hostprogs-y := ucon
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
+
+HOSTCFLAGS_ucon.o += -I$(objtree)/usr/include
--- /dev/null
+++ linux-next-20080729/Documentation/ia64/Makefile
@@ -0,0 +1,8 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := aliasing-test
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
--- /dev/null
+++ linux-next-20080729/Documentation/networking/Makefile
@@ -0,0 +1,8 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := ifenslave
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
--- /dev/null
+++ linux-next-20080729/Documentation/pcmcia/Makefile
@@ -0,0 +1,10 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := crc32hash
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
+
+HOSTCFLAGS_crc32hash.o += -I$(objtree)/usr/include
--- /dev/null
+++ linux-next-20080729/Documentation/spi/Makefile
@@ -0,0 +1,11 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := spidev_test spidev_fdx
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
+
+HOSTCFLAGS_spidev_test.o += -I$(objtree)/usr/include
+HOSTCFLAGS_spidev_fdx.o += -I$(objtree)/usr/include
--- /dev/null
+++ linux-next-20080729/Documentation/video4linux/Makefile
@@ -0,0 +1,8 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := v4lgrab
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
--- /dev/null
+++ linux-next-20080729/Documentation/vm/Makefile
@@ -0,0 +1,8 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := slabinfo
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
--- /dev/null
+++ linux-next-20080729/Documentation/watchdog/src/Makefile
@@ -0,0 +1,8 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := watchdog-simple watchdog-test
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
--- /dev/null
+++ linux-next-20080729/Documentation/filesystems/configfs/Makefile
@@ -0,0 +1,3 @@
+ifneq ($(CONFIG_CONFIGFS_FS),)
+obj-m += configfs_example_explicit.o configfs_example_macros.o
+endif
--- linux-next-20080729.orig/lib/Kconfig.debug
+++ linux-next-20080729/lib/Kconfig.debug
@@ -644,6 +644,15 @@ config FIREWIRE_OHCI_REMOTE_DMA
 
 	  If unsure, say N.
 
+menuconfig BUILD_DOCSRC
+	bool "Build targets in Documentation/ tree"
+	depends on HEADERS_CHECK
+	help
+	  This option attempts to build objects from the source files in the
+	  kernel Documentation/ tree.
+
+	  Say N if you are unsure.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"


-- 

