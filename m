Return-Path: <linux-kernel-owner+w=401wt.eu-S1759836AbYHAWO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836AbYHAWO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbYHAWOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:14:48 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42640 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbYHAWOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:14:47 -0400
Date: Sat, 2 Aug 2008 01:13:44 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>, Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sh: fix LIBGCC
Message-ID: <20080801221344.GI19682@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f15cbe6f1a4b4d9df59142fc8e4abb973302cf44
(sh: migrate to arch/sh/include/) moved KBUILD_CFLAGS
(which is used by LIBGCC) below LIBGCC, causing build
errors like the following:

<--  snip  -->

...
  LD      .tmp_vmlinux1
arch/sh/kernel/built-in.o: In function `module_clk_recalc':
clock-sh4.c:(.text+0x80f0): undefined reference to `__udivsi3_i4i'
...
make[1]: *** [.tmp_vmlinux1] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/sh/Makefile |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

d85920b1d9470920dad5f6541952d6765fcde8de 
diff --git a/arch/sh/Makefile b/arch/sh/Makefile
index 7b70cfd..01d85c7 100644
--- a/arch/sh/Makefile
+++ b/arch/sh/Makefile
@@ -95,8 +95,6 @@ head-y			:= arch/sh/kernel/init_task.o
 head-$(CONFIG_SUPERH32)	+= arch/sh/kernel/head_32.o
 head-$(CONFIG_SUPERH64)	+= arch/sh/kernel/head_64.o
 
-LIBGCC := $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
-
 core-y				+= arch/sh/kernel/ arch/sh/mm/ arch/sh/boards/
 core-$(CONFIG_SH_FPU_EMU)	+= arch/sh/math-emu/
 
@@ -145,10 +143,6 @@ cpuincdir-$(CONFIG_CPU_SH4)	+= cpu-sh4
 cpuincdir-$(CONFIG_CPU_SH5)	+= cpu-sh5
 cpuincdir-y			+= cpu-common	# Must be last
 
-libs-$(CONFIG_SUPERH32)		:= arch/sh/lib/	$(libs-y)
-libs-$(CONFIG_SUPERH64)		:= arch/sh/lib64/ $(libs-y)
-libs-y				+= $(LIBGCC)
-
 drivers-y			+= arch/sh/drivers/
 drivers-$(CONFIG_OPROFILE)	+= arch/sh/oprofile/
 
@@ -161,6 +155,12 @@ KBUILD_CFLAGS		+= -pipe $(cflags-y)
 KBUILD_CPPFLAGS		+= $(cflags-y)
 KBUILD_AFLAGS		+= $(cflags-y)
 
+LIBGCC := $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
+
+libs-$(CONFIG_SUPERH32)		:= arch/sh/lib/	$(libs-y)
+libs-$(CONFIG_SUPERH64)		:= arch/sh/lib64/ $(libs-y)
+libs-y				+= $(LIBGCC)
+
 PHONY += maketools FORCE
 
 maketools:  include/linux/version.h FORCE
