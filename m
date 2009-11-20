Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbZKTPCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbZKTPCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 10:02:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbZKTPCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 10:02:07 -0500
Received: from mail.free-electrons.com ([88.191.76.200]:49323 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbZKTPCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 10:02:06 -0500
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: akpm@linux-foundation.org
Cc: rmk+lkml@arm.linux.org.uk, tbm@cyrius.com, linux-kernel@vger.kernel.org,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: [PATCH] ARM: Add support for LZMA-compressed kernel images
Date: Fri, 20 Nov 2009 16:02:03 +0100
Message-Id: <1258729323-16318-1-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows using a kernel image compressed with LZMA on ARM,
using the support for multiple decompressors introduced in the LZO
support patch.
Extracting the image is fairly slow, but it might be useful on machines
with a very limited amount of storage.

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Tested-by: Martin Michlmayr <tbm@cyrius.com>
---
 arch/arm/Kconfig                      |    1 +
 arch/arm/boot/compressed/Makefile     |    1 +
 arch/arm/boot/compressed/misc.c       |    4 ++++
 arch/arm/boot/compressed/piggy.lzma.S |    6 ++++++
 4 files changed, 12 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/compressed/piggy.lzma.S

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 350921d..34163da 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -20,6 +20,7 @@ config ARM
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZO
+	select HAVE_KERNEL_LZMA
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 2d4d88b..3906432 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -65,6 +65,7 @@ SEDFLAGS	= s/TEXT_START/$(ZTEXTADDR)/;s/BSS_START/$(ZBSSADDR)/
 
 suffix_$(CONFIG_KERNEL_GZIP) = gzip
 suffix_$(CONFIG_KERNEL_LZO)  = lzo
+suffix_$(CONFIG_KERNEL_LZMA)  = lzma
 
 targets       := vmlinux vmlinux.lds \
 		 piggy.$(suffix_y) piggy.$(suffix_y).o \
diff --git a/arch/arm/boot/compressed/misc.c b/arch/arm/boot/compressed/misc.c
index 7e0fe4d..4e35a10 100644
--- a/arch/arm/boot/compressed/misc.c
+++ b/arch/arm/boot/compressed/misc.c
@@ -237,6 +237,10 @@ static unsigned long free_mem_end_ptr;
 #include "../../../../lib/decompress_inflate.c"
 #endif
 
+#ifdef CONFIG_KERNEL_LZMA
+#include "../../../../lib/decompress_unlzma.c"
+#endif
+
 #ifdef CONFIG_KERNEL_LZO
 #include "../../../../lib/decompress_unlzo.c"
 #endif
diff --git a/arch/arm/boot/compressed/piggy.lzma.S b/arch/arm/boot/compressed/piggy.lzma.S
new file mode 100644
index 0000000..d7e69cf
--- /dev/null
+++ b/arch/arm/boot/compressed/piggy.lzma.S
@@ -0,0 +1,6 @@
+	.section .piggydata,#alloc
+	.globl	input_data
+input_data:
+	.incbin	"arch/arm/boot/compressed/piggy.lzma"
+	.globl	input_data_end
+input_data_end:
-- 
1.6.3.3

