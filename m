Return-Path: <linux-kernel-owner+w=401wt.eu-S1762722AbYDCTry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762722AbYDCTry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756885AbYDCTro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:47:44 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:35036 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497AbYDCTrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:47:42 -0400
Date: Thu, 3 Apr 2008 12:45:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-kbuild@vger.kernel.org, samr <sam@ravnborg.org>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] documentation: build source files in Documentation sub-dir
Message-Id: <20080403124529.3f2efb79.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
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

The Makefiles use $objdir/usr/include for header files, so doing
"make headers_install" is required.  This is done for you if you enable
CONFIG_HEADERS_CHECK=y.

Note: needs documentation-move-spidev_fdx-example-to-its-own-source-file.patch
from -mm patchset.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
---
 Documentation/DocBook/Makefile              |    7 +++++++
 Documentation/Makefile                      |    3 +++
 Documentation/accounting/Makefile           |   10 ++++++++++
 Documentation/auxdisplay/Makefile           |   10 ++++++++++
 Documentation/connector/Makefile            |    9 +++++++++
 Documentation/filesystems/configfs/Makefile |    1 +
 Documentation/ia64/Makefile                 |    8 ++++++++
 Documentation/networking/Makefile           |    8 ++++++++
 Documentation/pcmcia/Makefile               |   10 ++++++++++
 Documentation/spi/Makefile                  |   11 +++++++++++
 Documentation/video4linux/Makefile          |    8 ++++++++
 Documentation/vm/Makefile                   |    8 ++++++++
 Documentation/watchdog/src/Makefile         |    8 ++++++++
 Makefile                                    |    5 ++++-
 lib/Kconfig.debug                           |    8 ++++++++
 15 files changed, 113 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/Makefile
 create mode 100644 Documentation/accounting/Makefile

--- /dev/null
+++ lin2625-rc8-docsrc/Documentation/Makefile
@@ -0,0 +1,3 @@
+obj-m := DocBook/ accounting/ auxdisplay/ connector/ \
+	filesystems/configfs/ ia64/ networking/ \
+	pcmcia/ spi/ video4linux/ vm/ watchdog/src/
--- /dev/null
+++ lin2625-rc8-docsrc/Documentation/accounting/Makefile
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
+HOSTCFLAGS_getdelays.o += -I$(srctree)/usr/include
--- lin2625-rc8-docsrc.orig/Makefile
+++ lin2625-rc8-docsrc/Makefile
@@ -806,6 +806,9 @@ endif
 ifdef CONFIG_SAMPLES
 	$(Q)$(MAKE) $(build)=samples
 endif
+ifdef CONFIG_BUILD_DOCSRC
+	$(Q)$(MAKE) $(build)=Documentation
+endif
 	$(call vmlinux-modpost)
 	$(call if_changed_rule,vmlinux__)
 	$(Q)rm -f .old_version
@@ -1114,7 +1117,7 @@ MRPROPER_FILES += .config .config.old in
 #
 clean: rm-dirs  := $(CLEAN_DIRS)
 clean: rm-files := $(CLEAN_FILES)
-clean-dirs      := $(addprefix _clean_,$(srctree) $(vmlinux-alldirs))
+clean-dirs      := $(addprefix _clean_,$(srctree) $(vmlinux-alldirs) Documentation)
 
 PHONY += $(clean-dirs) clean archclean
 $(clean-dirs):
--- lin2625-rc8-docsrc.orig/Documentation/DocBook/Makefile
+++ lin2625-rc8-docsrc/Documentation/DocBook/Makefile
@@ -101,6 +101,13 @@ C-procfs-example = procfs_example.xml
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
+++ lin2625-rc8-docsrc/Documentation/auxdisplay/Makefile
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
+HOSTCFLAGS_cfag12864b-example.o += -I$(srctree)/usr/include
--- /dev/null
+++ lin2625-rc8-docsrc/Documentation/connector/Makefile
@@ -0,0 +1,9 @@
+obj-m += cn_test.o
+
+# List of programs to build
+hostprogs-y := ucon
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
+
+HOSTCFLAGS_ucon.o += -I$(srctree)/usr/include
--- /dev/null
+++ lin2625-rc8-docsrc/Documentation/ia64/Makefile
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
+++ lin2625-rc8-docsrc/Documentation/networking/Makefile
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
+++ lin2625-rc8-docsrc/Documentation/pcmcia/Makefile
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
+HOSTCFLAGS_crc32hash.o += -I$(srctree)/usr/include
--- /dev/null
+++ lin2625-rc8-docsrc/Documentation/spi/Makefile
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
+HOSTCFLAGS_spidev_test.o += -I$(srctree)/usr/include
+HOSTCFLAGS_spidev_fdx.o += -I$(srctree)/usr/include
--- /dev/null
+++ lin2625-rc8-docsrc/Documentation/video4linux/Makefile
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
+++ lin2625-rc8-docsrc/Documentation/vm/Makefile
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
+++ lin2625-rc8-docsrc/Documentation/watchdog/src/Makefile
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
+++ lin2625-rc8-docsrc/Documentation/filesystems/configfs/Makefile
@@ -0,0 +1 @@
+obj-m += configfs_example.o
--- lin2625-rc8-docsrc.orig/lib/Kconfig.debug
+++ lin2625-rc8-docsrc/lib/Kconfig.debug
@@ -621,4 +621,12 @@ config PROVIDE_OHCI1394_DMA_INIT
 
 	  See Documentation/debugging-via-ohci1394.txt for more information.
 
+menuconfig BUILD_DOCSRC
+	bool "Build targets in Documentation/ tree"
+	help
+	  This option attempts to build objects from the source files in the
+	  kernel Documentation/ tree.
+
+	  Say N if you are unsure.
+
 source "samples/Kconfig"
