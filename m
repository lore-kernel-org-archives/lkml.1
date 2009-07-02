Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbZGBP2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbZGBP2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756150AbZGBP1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:27:54 -0400
Received: from mail-ew0-f215.google.com ([209.85.219.215]:55517 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbZGBP1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:27:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Hvu/Ud5rTebMHzmywB/ylhM+TdxhkUcJiiVAg5TTlockesb14hKy9ivnmtMIphOHty
         lWwKK+/DOx5ZVS3Uh+KEaBOBAGLrE9AkTFVeXXcGmwlBiWUMoqMzP2MK7HjJHKFrg9Zx
         bhQnMlnciOowRpRNjaP8m/WncriCVYIdLjRt0=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       ralf@linux-mips.org
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, Yan Hua <yanh@lemote.com>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>,
       loongson-dev <loongson-dev@googlegroups.com>,
       Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>,
       Arnaud Patard <apatard@mandriva.com>
Subject: [PATCH v4 15/16] [loongson] add gcc 4.4 support for Loongson2E
Date: Thu,  2 Jul 2009 23:27:41 +0800
Message-Id: <c99f466b537534606e679fd21e06f19838dfd79d.1246546684.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1246546684.git.wuzhangjin@gmail.com>
References: <cover.1246546684.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

because only gcc >=4.4 have loongson-specific support, we need to choose
the suitable -march argument for gcc <= 4.3 and gcc >= 4.4, and here, we
use -march=loongson2e for loongson2e.

thanks goes to Arnaud Patard <apatard@mandriva.com> for suggestion of
using cc-options(Documentation/kbuild/makefiles.txt). and thanks Zhang
Le for introducing the new CPU_LOONGSON2E kernel option.

NOTE: -mtune option is not need if -march and -mtune use the same value.

Signed-off-by: Zhang Le <r0bertz@gentoo.org>
Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/Kconfig          |   18 +++++++++++-------
 arch/mips/Makefile         |    6 +++++-
 arch/mips/loongson/Kconfig |    2 +-
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 482dcc3..466920a 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1030,12 +1030,10 @@ choice
 	prompt "CPU type"
 	default CPU_R4X00
 
-config CPU_LOONGSON2
-	bool "Loongson 2"
-	depends on SYS_HAS_CPU_LOONGSON2
-	select CPU_SUPPORTS_32BIT_KERNEL
-	select CPU_SUPPORTS_64BIT_KERNEL
-	select CPU_SUPPORTS_HIGHMEM
+config CPU_LOONGSON2E
+	bool "Loongson 2E"
+	depends on SYS_HAS_CPU_LOONGSON2E
+	select CPU_LOONGSON2
 	help
 	  The Loongson 2E processor implements the MIPS III instruction set
 	  with many extensions.
@@ -1282,7 +1280,13 @@ config CPU_CAVIUM_OCTEON
 
 endchoice
 
-config SYS_HAS_CPU_LOONGSON2
+config CPU_LOONGSON2
+	bool
+	select CPU_SUPPORTS_32BIT_KERNEL
+	select CPU_SUPPORTS_64BIT_KERNEL
+	select CPU_SUPPORTS_HIGHMEM
+
+config SYS_HAS_CPU_LOONGSON2E
 	bool
 
 config SYS_HAS_CPU_MIPS32_R1
diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 94d6f58..1efa9aa 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -120,7 +120,11 @@ cflags-$(CONFIG_CPU_R4300)	+= -march=r4300 -Wa,--trap
 cflags-$(CONFIG_CPU_VR41XX)	+= -march=r4100 -Wa,--trap
 cflags-$(CONFIG_CPU_R4X00)	+= -march=r4600 -Wa,--trap
 cflags-$(CONFIG_CPU_TX49XX)	+= -march=r4600 -Wa,--trap
-cflags-$(CONFIG_CPU_LOONGSON2)	+= -march=r4600 -Wa,--trap
+# only gcc >= 4.4 have the loongson-specific support
+cflags-$(CONFIG_CPU_LOONGSON2)	+= -Wa,--trap
+cflags-$(CONFIG_CPU_LOONGSON2E) += \
+	$(call cc-option,-march=loongson2e,-march=r4600)
+
 cflags-$(CONFIG_CPU_MIPS32_R1)	+= $(call cc-option,-march=mips32,-mips32 -U_MIPS_ISA -D_MIPS_ISA=_MIPS_ISA_MIPS32) \
 			-Wa,-mips32 -Wa,--trap
 cflags-$(CONFIG_CPU_MIPS32_R2)	+= $(call cc-option,-march=mips32r2,-mips32r2 -U_MIPS_ISA -D_MIPS_ISA=_MIPS_ISA_MIPS32) \
diff --git a/arch/mips/loongson/Kconfig b/arch/mips/loongson/Kconfig
index 376712a..d450925 100644
--- a/arch/mips/loongson/Kconfig
+++ b/arch/mips/loongson/Kconfig
@@ -7,7 +7,7 @@ config LEMOTE_FULOONG2E
     select ARCH_SPARSEMEM_ENABLE
     select CEVT_R4K
     select CSRC_R4K
-    select SYS_HAS_CPU_LOONGSON2
+    select SYS_HAS_CPU_LOONGSON2E
     select DMA_NONCOHERENT
     select BOOT_ELF32
     select BOARD_SCACHE
-- 
1.6.2.1

