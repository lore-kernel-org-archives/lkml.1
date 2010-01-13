Return-Path: <linux-kernel-owner+w=401wt.eu-S1751957Ab0AMFUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab0AMFUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 00:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867Ab0AMFUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 00:20:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:59063 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab0AMFUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 00:20:22 -0500
Subject: [PATCH] zlib: Fix build of powerpc boot wrapper
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Joakim Tjernlund <joakim.tjernlund@transmode.se>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 16:19:34 +1100
Message-ID: <1263359974.724.219.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ac4c2a3bbe5db5fc570b1d0ee1e474db7cb22585 broke the build
of all powerpc boot wrappers.

It attempts to add an include of autoconf.h but used the wrong
path for it. It also adds -D__KERNEL__ to our boot wrapper, both
things that we pretty much didn't do on purpose so far.

We want our boot wrapper to remain independent enough of the kernel
for various reasons, one of them being that you can "wrap" an existing
kernel at distro install time which allows to ship one kernel image
and a set of boot wrappers for different platforms, the wrappers
don't have to be built out of the same kernel build tree.

It's also incorrect to do what the patch does in our boot environment
since we may not have a proper alignment exception handler which means
we may not be able to fixup the few cases where an unaligned access will
need SW emulation (depends on the core variant, could be when crossing
page or segment boundaries for example).

This patch fixes it by putting the old code back in and using the
new "fancy" variant only when CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
is set, which happens not to be set on powerpc since we don't include
autoconf.h. It also reverts the changes to our boot wrapper Makefile.

This means that x86 should, afaik, keep the optimisations since its
boot wrapper does include autoconf.h and define __KERNEL__ (though I
doubt they make that much different outside of slow embedded processors).

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Linus, if you don't like the approach, then please just revert
ac4c2a3bbe5db5fc570b1d0ee1e474db7cb22585 for now.

Cheers,
Ben.

 arch/powerpc/boot/Makefile |    4 +---
 lib/zlib_inflate/inffast.c |   32 ++++++++++++++++++++++++++++++--
 2 files changed, 31 insertions(+), 5 deletions(-)



diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index 826a30a..bb2465b 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -20,7 +20,7 @@
 all: $(obj)/zImage
 
 BOOTCFLAGS    := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
-		 -fno-strict-aliasing -Os -msoft-float -pipe -D__KERNEL__\
+		 -fno-strict-aliasing -Os -msoft-float -pipe \
 		 -fomit-frame-pointer -fno-builtin -fPIC -nostdinc \
 		 -isystem $(shell $(CROSS32CC) -print-file-name=include)
 BOOTAFLAGS	:= -D__ASSEMBLY__ $(BOOTCFLAGS) -traditional -nostdinc
@@ -34,8 +34,6 @@ BOOTCFLAGS	+= -fno-stack-protector
 endif
 
 BOOTCFLAGS	+= -I$(obj) -I$(srctree)/$(obj)
-BOOTCFLAGS	+= -include include/linux/autoconf.h -Iarch/powerpc/include
-BOOTCFLAGS	+= -Iinclude
 
 DTS_FLAGS	?= -p 1024
 
diff --git a/lib/zlib_inflate/inffast.c b/lib/zlib_inflate/inffast.c
index 05e1559..215447c 100644
--- a/lib/zlib_inflate/inffast.c
+++ b/lib/zlib_inflate/inffast.c
@@ -4,12 +4,25 @@
  */
 
 #include <linux/zutil.h>
-#include <asm/unaligned.h>
-#include <asm/byteorder.h>
 #include "inftrees.h"
 #include "inflate.h"
 #include "inffast.h"
 
+/* Only do the unaligned "Faster" variant when
+ * CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is set
+ *
+ * On powerpc, it won't be as we don't include autoconf.h
+ * automatically for the boot wrapper, which is intended as
+ * we run in an environment where we may not be able to deal
+ * with (even rare) alignment faults. In addition, we do not
+ * define __KERNEL__ for arch/powerpc/boot unlike x86
+ */
+
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+#include <asm/unaligned.h>
+#include <asm/byteorder.h>
+#endif
+
 #ifndef ASMINF
 
 /* Allow machine dependent optimization for post-increment or pre-increment.
@@ -243,6 +256,7 @@ void inflate_fast(z_streamp strm, unsigned start)
                     }
                 }
                 else {
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 		    unsigned short *sout;
 		    unsigned long loops;
 
@@ -284,6 +298,20 @@ void inflate_fast(z_streamp strm, unsigned start)
 		    }
 		    if (len & 1)
 			PUP(out) = PUP(from);
+#else /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
+                    from = out - dist;          /* copy direct from output */
+                    do {                        /* minimum length is three */
+			 PUP(out) = PUP(from);
+			 PUP(out) = PUP(from);
+			 PUP(out) = PUP(from);
+			 len -= 3;
+                    } while (len > 2);
+                    if (len) {
+			 PUP(out) = PUP(from);
+			 if (len > 1)
+			     PUP(out) = PUP(from);
+                    }
+#endif /* !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
                 }
             }
             else if ((op & 64) == 0) {          /* 2nd level distance code */


