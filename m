Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbXL3OIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbXL3OIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 09:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbXL3OIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 09:08:38 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:45200 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbXL3OIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 09:08:37 -0500
Date: Sun, 30 Dec 2007 15:08:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: unify arch/x86/lib/Makefile(s)
Message-ID: <20071230140835.GB13990@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial unification of Makefiles for the
x86 specific library part.
Linking order is slightly modified but should be harmless.

Tested doing a defconfig build before and after and saw
no build changes.

It adds almost as many lines as it deletes - bacause
I broke a few lines up fo readability in the Makefile.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

Last in the series for now.
mm/ and pci/ looks at first sight simple but here the linking
order may play games that I do not know too well.
So they are a later exercise.

	Sam


 arch/x86/lib/Makefile    |   26 ++++++++++++++++++++++++--
 arch/x86/lib/Makefile_32 |   11 -----------
 arch/x86/lib/Makefile_64 |   13 -------------
 3 files changed, 24 insertions(+), 26 deletions(-)
 delete mode 100644 arch/x86/lib/Makefile_32
 delete mode 100644 arch/x86/lib/Makefile_64

diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 329da27..4876182 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -1,5 +1,27 @@
+#
+# Makefile for x86 specific library files.
+#
+
+obj-$(CONFIG_SMP) := msr-on-cpu.o
+
+lib-y := delay_$(BITS).o
+lib-y += usercopy_$(BITS).o getuser_$(BITS).o putuser_$(BITS).o
+lib-y += memcpy_$(BITS).o
+
 ifeq ($(CONFIG_X86_32),y)
-include ${srctree}/arch/x86/lib/Makefile_32
+        lib-y += checksum_32.o
+        lib-y += strstr_32.o
+        lib-y += bitops_32.o semaphore_32.o string_32.o
+
+        lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
 else
-include ${srctree}/arch/x86/lib/Makefile_64
+        obj-y += io_64.o iomap_copy_64.o
+
+        CFLAGS_csum-partial_64.o := -funroll-loops
+
+        lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o
+        lib-y += thunk_64.o clear_page_64.o copy_page_64.o
+        lib-y += bitstr_64.o bitops_64.o
+        lib-y += memmove_64.o memset_64.o
+        lib-y += copy_user_64.o rwlock_64.o copy_user_nocache_64.o
 endif
diff --git a/arch/x86/lib/Makefile_32 b/arch/x86/lib/Makefile_32
deleted file mode 100644
index 98d1f1e..0000000
--- a/arch/x86/lib/Makefile_32
+++ /dev/null
@@ -1,11 +0,0 @@
-#
-# Makefile for i386-specific library files..
-#
-
-
-lib-y = checksum_32.o delay_32.o usercopy_32.o getuser_32.o putuser_32.o memcpy_32.o strstr_32.o \
-	bitops_32.o semaphore_32.o string_32.o
-
-lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
-
-obj-$(CONFIG_SMP)	+= msr-on-cpu.o
diff --git a/arch/x86/lib/Makefile_64 b/arch/x86/lib/Makefile_64
deleted file mode 100644
index bbabad3..0000000
--- a/arch/x86/lib/Makefile_64
+++ /dev/null
@@ -1,13 +0,0 @@
-#
-# Makefile for x86_64-specific library files.
-#
-
-CFLAGS_csum-partial_64.o := -funroll-loops
-
-obj-y := io_64.o iomap_copy_64.o
-obj-$(CONFIG_SMP)	+= msr-on-cpu.o
-
-lib-y := csum-partial_64.o csum-copy_64.o csum-wrappers_64.o delay_64.o \
-	usercopy_64.o getuser_64.o putuser_64.o  \
-	thunk_64.o clear_page_64.o copy_page_64.o bitstr_64.o bitops_64.o
-lib-y += memcpy_64.o memmove_64.o memset_64.o copy_user_64.o rwlock_64.o copy_user_nocache_64.o
-- 
1.5.3.7.1112.g9758e

