Return-Path: <linux-kernel-owner+w=401wt.eu-S1758880AbYEWNsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbYEWNsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757440AbYEWNqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:46:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49166 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756977AbYEWNqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:46:18 -0400
Subject: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Haroldo Gamal <gamal@alternex.com.br>, Takashi Iwai <tiwai@suse.de>
In-Reply-To: <1211550282.28967.8.camel@pmac.infradead.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Fri, 23 May 2008 14:46:14 +0100
Message-Id: <1211550374.28967.10.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows arbitrary firmware files to be included in the static kernel
where the firmware loader can find them without requiring userspace to
be alive.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 Makefile             |    2 +-
 drivers/base/Kconfig |   12 ++++++++++++
 firmware/Makefile    |   23 +++++++++++++++++++++++
 3 files changed, 36 insertions(+), 1 deletions(-)
 create mode 100644 firmware/Makefile

diff --git a/Makefile b/Makefile
index 20b3235..ac2ab7e 100644
--- a/Makefile
+++ b/Makefile
@@ -450,7 +450,7 @@ scripts: scripts_basic include/config/auto.conf
 
 # Objects we will link into vmlinux / subdirs we need to visit
 init-y		:= init/
-drivers-y	:= drivers/ sound/
+drivers-y	:= drivers/ sound/ firmware/
 net-y		:= net/
 libs-y		:= lib/
 core-y		:= usr/
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index d7da109..687f097 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -34,6 +34,18 @@ config FW_LOADER
 	  require userspace firmware loading support, but a module built outside
 	  the kernel tree does.
 
+config BUILTIN_FIRMWARE
+       string "Firmware blobs to build into the kernel binary"
+       depends on FW_LOADER
+       help
+         This option allows firmware to be built into the kernel, for the cases
+	 where the user either cannot or doesn't want to provide it from
+	 userspace at runtime (for example, when the firmware in question is
+	 required for accessing the boot device, and the user doesn't want to
+	 use an initrd). Multiple files should be separated with spaces, and
+	 the required files should exist under the firmware/ directory in
+	 the source tree.
+
 config DEBUG_DRIVER
 	bool "Driver Core verbose debug messages"
 	depends on DEBUG_KERNEL
diff --git a/firmware/Makefile b/firmware/Makefile
new file mode 100644
index 0000000..184b8ef
--- /dev/null
+++ b/firmware/Makefile
@@ -0,0 +1,23 @@
+#
+# kbuild file for firmware/
+#
+
+FIRMWARE_BINS := $(subst ",,$(CONFIG_BUILTIN_FIRMWARE))
+FIRMWARE_OBJS := $(patsubst %,%.o, $(FIRMWARE_BINS))
+FIRMWARE_SRCS := $(patsubst %,$(obj)/%.c, $(FIRMWARE_BINS))
+
+
+quiet_cmd_fwbin = MK_FW   $@
+      cmd_fwbin = echo '/* File automatically generated */' > $@ ;	 \
+		  echo '\#include <linux/firmware.h>' >> $@ ;		 \
+		  echo 'static const unsigned char fw[] = {' >> $@ ;	 \
+		  od -t x1 -A none -v $(srctree)/$(patsubst %.c,%,$@) | \
+		   sed -e 's/ /, 0x/g' -e 's/^,//' -e 's/$$/,/' >> $@ ; \
+		  echo '};' >> $@ ;					 \
+		  echo 'DECLARE_BUILTIN_FIRMWARE("$(patsubst firmware/%.c,%,$@)",fw);' >> $@
+
+$(FIRMWARE_SRCS): $(obj)/%.c: $(srctree)/$(obj)/%
+	$(call cmd,fwbin)
+
+obj-y := $(FIRMWARE_OBJS)
+
-- 
1.5.4.5


-- 
dwmw2

