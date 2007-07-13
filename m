Return-Path: <linux-kernel-owner+w=401wt.eu-S933338AbXGMDwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338AbXGMDwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 23:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758670AbXGMDwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 23:52:08 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59733 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757451AbXGMDwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 23:52:07 -0400
Date: Fri, 13 Jul 2007 05:52:39 +0200
From: Adrian Bunk <bunk@stusta.de>
To: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru, linux-kernel@vger.kernel.org
Subject: [2.6 patch] cleanup arch/alpha/Makefile
Message-ID: <20070713035239.GY3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- binutils 2.7 is far below the current minimum supported version,
  and there's therefore no longer a need for an extra test
- since even gcc 3.2 already supports all options used we can use them
  unconditionally

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 arch/alpha/Makefile |   79 +++++++-------------------------------------
 1 file changed, 14 insertions(+), 65 deletions(-)

--- linux-2.6.22-rc6-mm1/arch/alpha/Makefile.old	2007-07-13 04:44:24.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/alpha/Makefile	2007-07-13 05:01:32.000000000 +0200
@@ -12,73 +12,22 @@
 
 LDFLAGS_vmlinux	:= -static -N #-relax
 CHECKFLAGS	+= -D__alpha__ -m64
-cflags-y	:= -pipe -mno-fp-regs -ffixed-8
+cflags-y	:= -pipe -mno-fp-regs -ffixed-8 -msmall-data
 
-# Determine if we can use the BWX instructions with GAS.
-old_gas := $(shell if $(AS) --version 2>&1 | grep 'version 2.7' > /dev/null; then echo y; else echo n; fi)
+cpuflags-$(CONFIG_ALPHA_EV67)		:= -mcpu=ev67
+cpuflags-$(CONFIG_ALPHA_EV6)		:= -mcpu=ev6
+cpuflags-$(CONFIG_ALPHA_POLARIS)	:= -mcpu=pca56
+cpuflags-$(CONFIG_ALPHA_SX164)		:= -mcpu=pca56
+cpuflags-$(CONFIG_ALPHA_EV56)		:= -mcpu=ev56
+cpuflags-$(CONFIG_ALPHA_EV5)		:= -mcpu=ev5
+cpuflags-$(CONFIG_ALPHA_EV4)		:= -mcpu=ev4
+# If GENERIC, make sure to turn off any instruction set extensions that
+# the host compiler might have on by default.  Given that EV4 and EV5
+# have the same instruction set, prefer EV5 because an EV5 schedule is
+# more likely to keep an EV4 processor busy than vice-versa.
+cpuflags-$(CONFIG_ALPHA_GENERIC)	:= -mcpu=ev5
 
-ifeq ($(old_gas),y)
-$(error The assembler '$(AS)' does not support the BWX instruction)
-endif
-
-# Determine if GCC understands the -mcpu= option.
-have_mcpu        := $(call cc-option-yn, -mcpu=ev5)
-have_mcpu_pca56  := $(call cc-option-yn, -mcpu=pca56)
-have_mcpu_ev6    := $(call cc-option-yn, -mcpu=ev6)
-have_mcpu_ev67   := $(call cc-option-yn, -mcpu=ev67)
-have_msmall_data := $(call cc-option-yn, -msmall-data)
-
-cflags-$(have_msmall_data) += -msmall-data
-
-# Turn on the proper cpu optimizations.
-ifeq ($(have_mcpu),y)
-  mcpu_done := n
-  # If GENERIC, make sure to turn off any instruction set extensions that
-  # the host compiler might have on by default.  Given that EV4 and EV5
-  # have the same instruction set, prefer EV5 because an EV5 schedule is
-  # more likely to keep an EV4 processor busy than vice-versa.
-  ifeq ($(CONFIG_ALPHA_GENERIC),y)
-    mcpu := ev5
-    mcpu_done := y
-  endif
-  ifeq ($(mcpu_done)$(CONFIG_ALPHA_SX164)$(have_mcpu_pca56),nyy)
-    mcpu := pca56
-    mcpu_done := y
-  endif
-  ifeq ($(mcpu_done)$(CONFIG_ALPHA_POLARIS)$(have_mcpu_pca56),nyy)
-    mcpu := pca56
-    mcpu_done := y
-  endif
-  ifeq ($(mcpu_done)$(CONFIG_ALPHA_EV4),ny)
-    mcpu := ev4
-    mcpu_done := y
-  endif
-  ifeq ($(mcpu_done)$(CONFIG_ALPHA_EV56),ny)
-    mcpu := ev56
-    mcpu_done := y
-  endif
-  ifeq ($(mcpu_done)$(CONFIG_ALPHA_EV5),ny)
-    mcpu := ev5
-    mcpu_done := y
-  endif
-  ifeq ($(mcpu_done)$(CONFIG_ALPHA_EV67)$(have_mcpu_ev67),nyy)
-    mcpu := ev67
-    mcpu_done := y
-  endif
-  ifeq ($(mcpu_done)$(CONFIG_ALPHA_EV6),ny)
-    ifeq ($(have_mcpu_ev6),y)
-      mcpu := ev6
-    else
-      ifeq ($(have_mcpu_pca56),y)
-        mcpu := pca56
-      else
-        mcpu=ev56
-      endif
-    endif
-    mcpu_done := y
-  endif
-  cflags-$(mcpu_done) += -mcpu=$(mcpu)
-endif
+cflags-y				+= $(cpuflags-y)
 
 
 # For TSUNAMI, we must have the assembler not emulate our instructions.

