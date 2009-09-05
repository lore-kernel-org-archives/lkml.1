Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbZIERTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbZIERTp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 13:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZIERT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 13:19:27 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:49252 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbZIERTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 13:19:04 -0400
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: akpm@linux-foundation.org
Cc: hpa@zytor.com, mingo@elte.hu, phillip@lougher.demon.co.uk,
       rmk@arm.linux.org.uk, sam@ravnborg.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: [PATCH v2 4/5] Add support for LZO-compressed kernels on x86
Date: Sat,  5 Sep 2009 19:19:05 +0200
Message-Id: <1252171146-13805-5-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252171146-13805-4-git-send-email-albin.tonnerre@free-electrons.com>
References: <1252171146-13805-1-git-send-email-albin.tonnerre@free-electrons.com>
 <1252171146-13805-2-git-send-email-albin.tonnerre@free-electrons.com>
 <1252171146-13805-3-git-send-email-albin.tonnerre@free-electrons.com>
 <1252171146-13805-4-git-send-email-albin.tonnerre@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third and last part of the patch, which contains the
necessary changes to the x86 Kconfig and boot/compressed to allow the
use of this new compression method

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
---
 arch/x86/Kconfig                  |    1 +
 arch/x86/boot/compressed/Makefile |    5 ++++-
 arch/x86/boot/compressed/misc.c   |    4 ++++
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 13ffa5d..1cbe738 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -49,6 +49,7 @@ config X86
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
+	select HAVE_KERNEL_LZO
 	select HAVE_ARCH_KMEMCHECK
 
 config OUTPUT_FORMAT
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index f8ed065..0e835d0 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -4,7 +4,7 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma head_$(BITS).o misc.o piggy.o
+targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.lzo head_$(BITS).o misc.o piggy.o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
@@ -48,10 +48,13 @@ $(obj)/vmlinux.bin.bz2: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,bzip2)
 $(obj)/vmlinux.bin.lzma: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,lzma)
+$(obj)/vmlinux.bin.lzo: $(vmlinux.bin.all-y) FORCE
+	$(call if_changed,lzo)
 
 suffix-$(CONFIG_KERNEL_GZIP)	:= gz
 suffix-$(CONFIG_KERNEL_BZIP2)	:= bz2
 suffix-$(CONFIG_KERNEL_LZMA)	:= lzma
+suffix-$(CONFIG_KERNEL_LZO) 	:= lzo
 
 quiet_cmd_mkpiggy = MKPIGGY $@
       cmd_mkpiggy = $(obj)/mkpiggy $< > $@ || ( rm -f $@ ; false )
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 842b2a3..3b22fe8 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -162,6 +162,10 @@ static int lines, cols;
 #include "../../../../lib/decompress_unlzma.c"
 #endif
 
+#ifdef CONFIG_KERNEL_LZO
+#include "../../../../lib/decompress_unlzo.c"
+#endif
+
 static void scroll(void)
 {
 	int i;
-- 
1.6.3.3

