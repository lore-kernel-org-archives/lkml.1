Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbYIHTc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbYIHTc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 15:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbYIHTci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 15:32:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33506 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbYIHTch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 15:32:37 -0400
Date: Mon, 8 Sep 2008 12:32:31 -0700
Message-Id: <200809081932.m88JWVZG013061@askone.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull] x86 fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	-hpa

------------------>
H. Peter Anvin (1):
      x86: prevent binutils from being "smart" and generating NOPLs for us

Jeremy Fitzhardinge (1):
      xen: fix 2.6.27-rc5 xen balloon driver warnings

Linus Torvalds (1):
      x86: disable static NOPLs on 32 bits


 arch/x86/Kconfig.cpu     |   13 ++++++++-----
 arch/x86/Makefile_32.cpu |    5 +++++
 drivers/xen/balloon.c    |    2 +-
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 2c518fb..b225219 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -382,14 +382,17 @@ config X86_OOSTORE
 # P6_NOPs are a relatively minor optimization that require a family >=
 # 6 processor, except that it is broken on certain VIA chips.
 # Furthermore, AMD chips prefer a totally different sequence of NOPs
-# (which work on all CPUs).  As a result, disallow these if we're
-# compiling X86_GENERIC but not X86_64 (these NOPs do work on all
-# x86-64 capable chips); the list of processors in the right-hand clause
-# are the cores that benefit from this optimization.
+# (which work on all CPUs).  In addition, it looks like Virtual PC
+# does not understand them.
+#
+# As a result, disallow these if we're not compiling for X86_64 (these
+# NOPs do work on all x86-64 capable chips); the list of processors in
+# the right-hand clause are the cores that benefit from this optimization.
 #
 config X86_P6_NOP
 	def_bool y
-	depends on (X86_64 || !X86_GENERIC) && (M686 || MPENTIUMII || MPENTIUMIII || MPENTIUMM || MCORE2 || MPENTIUM4 || MPSC)
+	depends on X86_64
+	depends on (MCORE2 || MPENTIUM4 || MPSC)
 
 config X86_TSC
 	def_bool y
diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index e372b58..b72b4f7 100644
--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -45,3 +45,8 @@ cflags-$(CONFIG_MGEODEGX1)	+= -march=pentium-mmx
 # cpu entries
 cflags-$(CONFIG_X86_GENERIC) 	+= $(call tune,generic,$(call tune,i686))
 
+# Bug fix for binutils: this option is required in order to keep
+# binutils from generating NOPL instructions against our will.
+ifneq ($(CONFIG_X86_P6_NOP),y)
+cflags-y			+= $(call cc-option,-Wa$(comma)-mtune=generic32,)
+endif
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index d4427cb..2e15da5 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -60,7 +60,7 @@
 
 #define PAGES2KB(_p) ((_p)<<(PAGE_SHIFT-10))
 
-#define BALLOON_CLASS_NAME "memory"
+#define BALLOON_CLASS_NAME "xen_memory"
 
 struct balloon_stats {
 	/* We aim for 'current allocation' == 'target allocation'. */
