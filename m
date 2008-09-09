Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbYIITES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbYIITES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 15:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYIITEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 15:04:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53640 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbYIITEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 15:04:05 -0400
Date: Tue, 9 Sep 2008 12:03:58 -0700
Message-Id: <200809091903.m89J3wFd027106@askone.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull] x86 fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

This includes your patch for disabling static NOPL entirely on 32
bits; as discussed yesterday the -Wa,-mtune=generic32 patches are
deferred to post-27.

 Thanks,

	-hpa

------------------>
Jeremy Fitzhardinge (1):
      xen: fix 2.6.27-rc5 xen balloon driver warnings

Linus Torvalds (1):
      x86: disable static NOPLs on 32 bits

Prarit Bhargava (1):
      x86: fix memmap=exactmap boot argument


 arch/x86/Kconfig.cpu   |   13 ++++++++-----
 arch/x86/kernel/e820.c |    2 +-
 drivers/xen/balloon.c  |    2 +-
 3 files changed, 10 insertions(+), 7 deletions(-)

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
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 9af8907..66e48aa 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1203,7 +1203,7 @@ static int __init parse_memmap_opt(char *p)
 	if (!p)
 		return -EINVAL;
 
-	if (!strcmp(p, "exactmap")) {
+	if (!strncmp(p, "exactmap", 8)) {
 #ifdef CONFIG_CRASH_DUMP
 		/*
 		 * If we are doing a crash dump, we still need to know
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
