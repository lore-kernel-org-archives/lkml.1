Return-Path: <linux-kernel-owner+w=401wt.eu-S934054AbZDAT3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934054AbZDAT3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760438AbZDAT3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:29:31 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:53050 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540AbZDAT3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:29:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HTyBx1wvfH5eh37zpwxXd9c0dyWIPoraUHxExtsg18zWKWSXse0PLeiwVja5ZAMWlm
         q66Ol77N4QXRpoelzhaVKCwODDqbk+/Sv+MQar0oabmwrEMLN3gYxx5nDb3/1WePKMcY
         XhCeSY3zlAajogvVFhtDxVnQ1Y+Z+gPUAjDcs=
Subject: Re: [PATCH 3/3] lib: enable lzo-compressed kernels
From: Andreas Robinson <andr345@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>, linux-kernel@vger.kernel.org
In-Reply-To: <1238593252-3435-1-git-send-email-andr345@gmail.com>
References: <1238593252-3435-1-git-send-email-andr345@gmail.com>
Content-Type: text/plain
Date: Wed, 01 Apr 2009 21:29:18 +0200
Message-Id: <1238614158.10514.42.camel@andreas-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andreas Robinson <andr345@gmail.com>
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 34bc3a8..3d1c2a6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -40,6 +40,7 @@ config X86
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select USER_STACKTRACE_SUPPORT
+	select HAVE_KERNEL_LZO
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 3ca4c19..561790b 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -4,7 +4,7 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma head_$(BITS).o misc.o piggy.o
+targets := vmlinux vmlinux.bin vmlinux.bin.lzo vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma head_$(BITS).o misc.o piggy.o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
@@ -45,6 +45,8 @@ $(obj)/vmlinux.bin.all: $(vmlinux.bin.all-y) FORCE
 ifeq ($(CONFIG_X86_32),y)
 
 ifdef CONFIG_RELOCATABLE
+$(obj)/vmlinux.bin.lzo: $(obj)/vmlinux.bin.all FORCE
+	$(call if_changed,lzop)
 $(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin.all FORCE
 	$(call if_changed,gzip)
 $(obj)/vmlinux.bin.bz2: $(obj)/vmlinux.bin.all FORCE
@@ -52,6 +54,8 @@ $(obj)/vmlinux.bin.bz2: $(obj)/vmlinux.bin.all FORCE
 $(obj)/vmlinux.bin.lzma: $(obj)/vmlinux.bin.all FORCE
 	$(call if_changed,lzma)
 else
+$(obj)/vmlinux.bin.lzo: $(obj)/vmlinux.bin FORCE
+	$(call if_changed,lzop)
 $(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin FORCE
 	$(call if_changed,gzip)
 $(obj)/vmlinux.bin.bz2: $(obj)/vmlinux.bin FORCE
@@ -63,6 +67,8 @@ LDFLAGS_piggy.o := -r --format binary --oformat elf32-i386 -T
 
 else
 
+$(obj)/vmlinux.bin.lzo: $(obj)/vmlinux.bin FORCE
+	$(call if_changed,lzop)
 $(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin FORCE
 	$(call if_changed,gzip)
 $(obj)/vmlinux.bin.bz2: $(obj)/vmlinux.bin FORCE
@@ -73,6 +79,7 @@ $(obj)/vmlinux.bin.lzma: $(obj)/vmlinux.bin FORCE
 LDFLAGS_piggy.o := -r --format binary --oformat elf64-x86-64 -T
 endif
 
+suffix_$(CONFIG_KERNEL_LZO)  = lzo
 suffix_$(CONFIG_KERNEL_GZIP)  = gz
 suffix_$(CONFIG_KERNEL_BZIP2) = bz2
 suffix_$(CONFIG_KERNEL_LZMA)  = lzma
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index e45be73..a0fd406 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -150,6 +150,10 @@ static char *vidmem;
 static int vidport;
 static int lines, cols;
 
+#ifdef CONFIG_KERNEL_LZO
+#include "../../../../lib/decompress_unlzo.c"
+#endif
+
 #ifdef CONFIG_KERNEL_GZIP
 #include "../../../../lib/decompress_inflate.c"
 #endif
diff --git a/init/Kconfig b/init/Kconfig
index 14c483d..c59e55d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -101,6 +101,9 @@ config LOCALVERSION_AUTO
 
 	  which is done within the script "scripts/setlocalversion".)
 
+config HAVE_KERNEL_LZO
+	bool
+
 config HAVE_KERNEL_GZIP
 	bool
 
@@ -113,7 +116,7 @@ config HAVE_KERNEL_LZMA
 choice
 	prompt "Kernel compression mode"
 	default KERNEL_GZIP
-	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA
+	depends on HAVE_KERNEL_LZO || HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA
 	help
 	  The linux kernel is a kind of self-extracting executable.
 	  Several compression algorithms are available, which differ
@@ -132,20 +135,29 @@ choice
 
 	  If in doubt, select 'gzip'
 
+config KERNEL_LZO
+	bool "LZO"
+	depends on HAVE_KERNEL_LZO
+	help
+	  Lempel Ziv Oberhumer compression. Its compression ratio is
+	  the poorest among the four choices; maximum compression yields
+	  roughly 7% larger kernels compared to gzip. However, decompression
+	  time is only 55 - 60% of that of gzip.
+
 config KERNEL_GZIP
 	bool "Gzip"
 	depends on HAVE_KERNEL_GZIP
 	help
 	  The old and tried gzip compression. Its compression ratio is
-	  the poorest among the 3 choices; however its speed (both
-	  compression and decompression) is the fastest.
+	  worse than that of bzip2 and lzma; however compression and
+	  decompression are faster.
 
 config KERNEL_BZIP2
 	bool "Bzip2"
 	depends on HAVE_KERNEL_BZIP2
 	help
 	  Its compression ratio and speed is intermediate.
-	  Decompression speed is slowest among the three.  The kernel
+	  Decompression speed is slowest among the four.  The kernel
 	  size is about 10% smaller with bzip2, in comparison to gzip.
 	  Bzip2 uses a large amount of memory. For modern kernels you
 	  will need at least 8MB RAM or more for booting.
@@ -155,9 +167,9 @@ config KERNEL_LZMA
 	depends on HAVE_KERNEL_LZMA
 	help
 	  The most recent compression algorithm.
-	  Its ratio is best, decompression speed is between the other
-	  two. Compression is slowest.	The kernel size is about 33%
-	  smaller with LZMA in comparison to gzip.
+	  Its ratio is best, decompression speed is between gzip and bzip2
+	  Compression is slowest. The kernel size is about 33% smaller with
+	  LZMA compared to gzip.
 
 endchoice
 
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 9796195..f29037b 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -200,3 +200,11 @@ cmd_bzip2 = (bzip2 -9 < $< && $(size_append) $<) > $@ || (rm -f $@ ; false)
 
 quiet_cmd_lzma = LZMA    $@
 cmd_lzma = (lzma -9 -c $< && $(size_append) $<) >$@ || (rm -f $@ ; false)
+
+# Lzo
+# ---------------------------------------------------------------------------
+
+quiet_cmd_lzop = LZOP    $@
+cmd_lzop = (lzop -9 -c $< && $(size_append) $<) >$@ || (rm -f $@ ; false)
+
+
-- 
1.5.6.3


