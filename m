Return-Path: <linux-kernel-owner+w=401wt.eu-S1760266AbXH2X3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266AbXH2X3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 19:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbXH2X32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 19:29:28 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37914 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758896AbXH2X31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 19:29:27 -0400
Date: Thu, 30 Aug 2007 01:29:28 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <andi@firstfloor.org>, jdike@karaya.com
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       discuss@x86-64.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [2.6 patch] rename .i assembler includes to .h
Message-ID: <20070829232928.GY26410@stusta.de>
References: <20070801131051.GO3972@stusta.de> <20070801190753.GB5763@martell.zuzino.mipt.ru> <20070801191037.GR3972@stusta.de> <20070819230136.GE32595@stusta.de> <20070820001646.GB10087@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070820001646.GB10087@one.firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 02:16:46AM +0200, Andi Kleen wrote:
> On Mon, Aug 20, 2007 at 01:01:36AM +0200, Adrian Bunk wrote:
> > On Wed, Aug 01, 2007 at 09:10:37PM +0200, Adrian Bunk wrote:
> > > On Wed, Aug 01, 2007 at 11:07:53PM +0400, Alexey Dobriyan wrote:
> > > > On Wed, Aug 01, 2007 at 03:10:51PM +0200, Adrian Bunk wrote:
> > > > > --- linux-2.6.23-rc1-mm2/.gitignore.old
> > > > > +++ linux-2.6.23-rc1-mm2/.gitignore
> > > > > @@ -14,18 +14,25 @@
> > > > >  *.so
> > > > >  *.mod.c
> > > > >  *.i
> > > > > +!include/asm-*/*.i
> > > > 
> > > > I think these should be renamed to .S and let .i alone for preprocessed
> > > > stuff.
> > > >...
> > > 
> > > Fine with me if Andi agrees.
> > 
> > Andi?
> 
> Hmm, perhaps rename alternative-asm.i to .h and stick a #ifdef __ASSEMBLY__
> around it.

Patch below.

> There is actually only one includer currently, but there might
> be more in the future again.
> 
> -Andi

cu
Adrian


<--  snip  -->


.i is an ending used for preprocessed stuff.

This patch therefore renames assembler include files to .h and guards 
the contents with an #ifdef __ASSEMBLY__.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/i386/lib/semaphore.S            |    4 ++--
 arch/x86_64/lib/rwlock.S             |    2 +-
 include/asm-i386/alternative-asm.h   |   16 ++++++++++++++++
 include/asm-i386/alternative-asm.i   |   12 ------------
 include/asm-i386/frame.h             |   27 +++++++++++++++++++++++++++
 include/asm-i386/frame.i             |   23 -----------------------
 include/asm-um/alternative-asm.h     |    6 ++++++
 include/asm-um/alternative-asm.i     |    6 ------
 include/asm-um/frame.h               |    6 ++++++
 include/asm-um/frame.i               |    6 ------
 include/asm-x86_64/alternative-asm.h |   16 ++++++++++++++++
 include/asm-x86_64/alternative-asm.i |   12 ------------
 12 files changed, 74 insertions(+), 62 deletions(-)

7b64536780b39820b13bebd144983c3c8c9ae64c 
diff --git a/arch/i386/lib/semaphore.S b/arch/i386/lib/semaphore.S
index c01eb39..444fba4 100644
--- a/arch/i386/lib/semaphore.S
+++ b/arch/i386/lib/semaphore.S
@@ -15,8 +15,8 @@
 
 #include <linux/linkage.h>
 #include <asm/rwlock.h>
-#include <asm/alternative-asm.i>
-#include <asm/frame.i>
+#include <asm/alternative-asm.h>
+#include <asm/frame.h>
 #include <asm/dwarf2.h>
 
 /*
diff --git a/arch/x86_64/lib/rwlock.S b/arch/x86_64/lib/rwlock.S
index 0cde1f8..05ea55f 100644
--- a/arch/x86_64/lib/rwlock.S
+++ b/arch/x86_64/lib/rwlock.S
@@ -2,7 +2,7 @@
 
 #include <linux/linkage.h>
 #include <asm/rwlock.h>
-#include <asm/alternative-asm.i>
+#include <asm/alternative-asm.h>
 #include <asm/dwarf2.h>
 
 /* rdi:	pointer to rwlock_t */
diff --git a/include/asm-i386/alternative-asm.h b/include/asm-i386/alternative-asm.h
new file mode 100644
index 0000000..c478a03
--- /dev/null
+++ b/include/asm-i386/alternative-asm.h
@@ -0,0 +1,16 @@
+#ifdef __ASSEMBLY__
+
+#ifdef CONFIG_SMP
+	.macro LOCK_PREFIX
+1:	lock
+	.section .smp_locks,"a"
+	.align 4
+	.long 1b
+	.previous
+	.endm
+#else
+	.macro LOCK_PREFIX
+	.endm
+#endif
+
+#endif  /*  __ASSEMBLY__  */
diff --git a/include/asm-i386/alternative-asm.i b/include/asm-i386/alternative-asm.i
deleted file mode 100644
index f051020..0000000
--- a/include/asm-i386/alternative-asm.i
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifdef CONFIG_SMP
-	.macro LOCK_PREFIX
-1:	lock
-	.section .smp_locks,"a"
-	.align 4
-	.long 1b
-	.previous
-	.endm
-#else
-	.macro LOCK_PREFIX
-	.endm
-#endif
diff --git a/include/asm-i386/frame.h b/include/asm-i386/frame.h
new file mode 100644
index 0000000..06850a7
--- /dev/null
+++ b/include/asm-i386/frame.h
@@ -0,0 +1,27 @@
+#ifdef __ASSEMBLY__
+
+#include <asm/dwarf2.h>
+
+/* The annotation hides the frame from the unwinder and makes it look
+   like a ordinary ebp save/restore. This avoids some special cases for
+   frame pointer later */
+#ifdef CONFIG_FRAME_POINTER
+	.macro FRAME
+	pushl %ebp
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET ebp,0
+	movl %esp,%ebp
+	.endm
+	.macro ENDFRAME
+	popl %ebp
+	CFI_ADJUST_CFA_OFFSET -4
+	CFI_RESTORE ebp
+	.endm
+#else
+	.macro FRAME
+	.endm
+	.macro ENDFRAME
+	.endm
+#endif
+
+#endif  /*  __ASSEMBLY__  */
diff --git a/include/asm-i386/frame.i b/include/asm-i386/frame.i
deleted file mode 100644
index 0362025..0000000
--- a/include/asm-i386/frame.i
+++ /dev/null
@@ -1,23 +0,0 @@
-#include <asm/dwarf2.h>
-
-/* The annotation hides the frame from the unwinder and makes it look
-   like a ordinary ebp save/restore. This avoids some special cases for
-   frame pointer later */
-#ifdef CONFIG_FRAME_POINTER
-	.macro FRAME
-	pushl %ebp
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET ebp,0
-	movl %esp,%ebp
-	.endm
-	.macro ENDFRAME
-	popl %ebp
-	CFI_ADJUST_CFA_OFFSET -4
-	CFI_RESTORE ebp
-	.endm
-#else
-	.macro FRAME
-	.endm
-	.macro ENDFRAME
-	.endm
-#endif
diff --git a/include/asm-um/alternative-asm.h b/include/asm-um/alternative-asm.h
new file mode 100644
index 0000000..9aa9fa2
--- /dev/null
+++ b/include/asm-um/alternative-asm.h
@@ -0,0 +1,6 @@
+#ifndef __UM_ALTERNATIVE_ASM_I
+#define __UM_ALTERNATIVE_ASM_I
+
+#include "asm/arch/alternative-asm.h"
+
+#endif
diff --git a/include/asm-um/alternative-asm.i b/include/asm-um/alternative-asm.i
deleted file mode 100644
index cae9fac..0000000
--- a/include/asm-um/alternative-asm.i
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __UM_ALTERNATIVE_ASM_I
-#define __UM_ALTERNATIVE_ASM_I
-
-#include "asm/arch/alternative-asm.i"
-
-#endif
diff --git a/include/asm-um/frame.h b/include/asm-um/frame.h
new file mode 100644
index 0000000..8a8c1cb
--- /dev/null
+++ b/include/asm-um/frame.h
@@ -0,0 +1,6 @@
+#ifndef __UM_FRAME_I
+#define __UM_FRAME_I
+
+#include "asm/arch/frame.h"
+
+#endif
diff --git a/include/asm-um/frame.i b/include/asm-um/frame.i
deleted file mode 100644
index 09d5dca..0000000
--- a/include/asm-um/frame.i
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __UM_FRAME_I
-#define __UM_FRAME_I
-
-#include "asm/arch/frame.i"
-
-#endif
diff --git a/include/asm-x86_64/alternative-asm.h b/include/asm-x86_64/alternative-asm.h
new file mode 100644
index 0000000..b598daf
--- /dev/null
+++ b/include/asm-x86_64/alternative-asm.h
@@ -0,0 +1,16 @@
+#ifdef __ASSEMBLY__
+
+#ifdef CONFIG_SMP
+	.macro LOCK_PREFIX
+1:	lock
+	.section .smp_locks,"a"
+	.align 8
+	.quad 1b
+	.previous
+	.endm
+#else
+	.macro LOCK_PREFIX
+	.endm
+#endif
+
+#endif  /*  __ASSEMBLY__  */
diff --git a/include/asm-x86_64/alternative-asm.i b/include/asm-x86_64/alternative-asm.i
deleted file mode 100644
index 0b3f1a2..0000000
--- a/include/asm-x86_64/alternative-asm.i
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifdef CONFIG_SMP
-	.macro LOCK_PREFIX
-1:	lock
-	.section .smp_locks,"a"
-	.align 8
-	.quad 1b
-	.previous
-	.endm
-#else
-	.macro LOCK_PREFIX
-	.endm
-#endif

