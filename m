Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbZGaSOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbZGaSOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 14:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZGaSOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 14:14:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42505 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZGaSOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 14:14:04 -0400
Date: Fri, 31 Jul 2009 11:13:40 -0700
Message-Id: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit e00b95debb9a0f023b61abcd4b1e74f687276b47:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../bp/bp

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

H. Peter Anvin (1):
      x86: comment formatting cleanup in arch/x86/kernel/tsc.c

Pallipadi, Venkatesh (1):
      x86, pat: Fix set_memory_wc related corruption

Robert Richter (1):
      x86: fix section mismatch for i386 init code

Tan, Wei Chong (1):
      x86: SMI workaround for pit_expect_msb

 arch/x86/kernel/head_32.S |    6 +++++-
 arch/x86/kernel/tsc.c     |   22 ++++++++++++++++++++++
 arch/x86/mm/pageattr.c    |    9 ++++++---
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 8663afb..0d98a01 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -602,7 +602,11 @@ ignore_int:
 #endif
 	iret
 
-.section .cpuinit.data,"wa"
+#ifndef CONFIG_HOTPLUG_CPU
+	__CPUINITDATA
+#else
+	__REFDATA
+#endif
 .align 4
 ENTRY(initial_code)
 	.long i386_start_kernel
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 6e1a368..261ff00 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -285,10 +285,32 @@ static inline int pit_expect_msb(unsigned char val, u64 *tscp, unsigned long *de
 		inb(0x42);
 		if (inb(0x42) != val)
 			break;
+		/* 
+		 * What if an SMI kicks in here when count is just
+		 * slightly over 5 and SMI run long enough so that PIT
+		 * MSB value is way bigger then val?  Then tscp will
+		 * have an unreasonably large value, since the code
+		 * has no notion of how much inb(0x42) MSB is bigger
+		 * then val when it return from SMI.
+		 *
+		 * In addition, since the 2 get_cycles() are near,
+		 * deltap may get a sane value.  If this happen on the
+		 * final few readings just before
+		 * (d1+d2 < delta >> * 11), this may skew the average
+		 * delta variable of quick_pit_calibrate().
+		 */
 		tsc = get_cycles();
 	}
 	*deltap = get_cycles() - tsc;
 	*tscp = tsc;
+	/*
+	 * inb(0x42) will need to be separately repeated here as the
+	 * SMI may take so long that the old reading is no longer
+	 * reliable. inb(0x42) after all get_cycles is the safest.
+	 */
+	inb(0x42);
+	if (inb(0x42) < (val - 1))
+		return 0;
 
 	/*
 	 * We require _some_ success, but the quality control
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 1b734d7..895d90e 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -997,12 +997,15 @@ EXPORT_SYMBOL(set_memory_array_uc);
 int _set_memory_wc(unsigned long addr, int numpages)
 {
 	int ret;
+	unsigned long addr_copy = addr;
+
 	ret = change_page_attr_set(&addr, numpages,
 				    __pgprot(_PAGE_CACHE_UC_MINUS), 0);
-
 	if (!ret) {
-		ret = change_page_attr_set(&addr, numpages,
-				    __pgprot(_PAGE_CACHE_WC), 0);
+		ret = change_page_attr_set_clr(&addr_copy, numpages,
+					       __pgprot(_PAGE_CACHE_WC),
+					       __pgprot(_PAGE_CACHE_MASK),
+					       0, 0, NULL);
 	}
 	return ret;
 }
