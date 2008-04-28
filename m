Return-Path: <linux-kernel-owner+w=401wt.eu-S1763492AbYD1Bp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763492AbYD1Bp5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 21:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbYD1Bpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 21:45:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbYD1Bpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 21:45:45 -0400
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64 vDSO: use initdata
X-Fcc: ~/Mail/linus
X-Shopping-List: (1) Tremulous vagrants
   (2) Atomic Garden Weasels
   (3) Instant Ritz Cracker Crumbs
Message-Id: <20080428014538.DC68926F8F0@magilla.localdomain>
Date: Sun, 27 Apr 2008 18:45:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 64-bit vDSO image is in a special ".vdso" section for no reason
I can determine.  Furthermore, the location of the vdso_end symbol
includes some wrongly-calculated padding space in the image, which
is then (correctly) rounded to page size, resulting in an extra page
of zeros in the image mapped in to user processes.

This changes it to put the vdso.so image into normal initdata as we
have always done for the 32-bit vDSO images.  The extra padding is
gone, so the user VMA is one page instead of two.  The image that
was already copied around at boot time is now in initdata, so we
recover that wasted space after boot.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/vmlinux_64.lds.S |    6 ------
 arch/x86/vdso/vdso.S             |   10 +++++++++-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index b7ab3c3..fad3674 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -209,12 +209,6 @@ SECTIONS
 	EXIT_DATA
   }
 
-/* vdso blob that is mapped into user space */
-  vdso_start = . ;
-  .vdso  : AT(ADDR(.vdso) - LOAD_OFFSET) { *(.vdso) }
-  . = ALIGN(PAGE_SIZE);
-  vdso_end = .;
-
 #ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(PAGE_SIZE);
   __initramfs_start = .;
diff --git a/arch/x86/vdso/vdso.S b/arch/x86/vdso/vdso.S
index 4b1620a..1d3aa6b 100644
--- a/arch/x86/vdso/vdso.S
+++ b/arch/x86/vdso/vdso.S
@@ -1,2 +1,10 @@
-	.section ".vdso","a"
+#include <linux/init.h>
+
+__INITDATA
+
+	.globl vdso_start, vdso_end
+vdso_start:
 	.incbin "arch/x86/vdso/vdso.so"
+vdso_end:
+
+__FINIT
