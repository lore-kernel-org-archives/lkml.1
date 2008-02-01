Return-Path: <linux-kernel-owner+w=401wt.eu-S935561AbYBAHnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935561AbYBAHnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933855AbYBAHjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:39:05 -0500
Received: from rex.snapgear.com ([203.143.235.140]:48070 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935124AbYBAHjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:39:03 -0500
Date: Fri, 1 Feb 2008 17:37:46 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010737.m117bkDI022707@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU 05/06]: move ColdFire vectors.c to its own coldfire directory
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move common ColdFire CPU vectors.c to common coldfire platform directory.

Currently the common ColdFire CPU family code sits in the
arch/m68knommu/platform/5307 directory. This is confusing, the files
containing this common code are in no way specific to the 5307 ColdFire.
Create an arch/m68knommu/platform/coldfire directory to contain this
common code. Other m68knommu CPU varients do not need use this code
though, so it doesn't make sense to move it to arch/m68knommu/kernel.

Signed-off-by: Greg Ungerer <gerg@uclinux.org


diff -Naurp linux-2.6.24/arch/m68knommu/platform/5307/vectors.c linux-2.6.24.1/arch/m68knommu/platform/5307/vectors.c
--- linux-2.6.24/arch/m68knommu/platform/5307/vectors.c	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24.1/arch/m68knommu/platform/5307/vectors.c	1970-01-01 10:00:00.000000000 +1000
@@ -1,105 +0,0 @@
-/***************************************************************************/
-
-/*
- *	linux/arch/m68knommu/platform/5307/vectors.c
- *
- *	Copyright (C) 1999-2007, Greg Ungerer <gerg@snapgear.com>
- */
-
-/***************************************************************************/
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/irq.h>
-#include <asm/traps.h>
-#include <asm/machdep.h>
-#include <asm/coldfire.h>
-#include <asm/mcfsim.h>
-#include <asm/mcfdma.h>
-#include <asm/mcfwdebug.h>
-
-/***************************************************************************/
-
-#ifdef TRAP_DBG_INTERRUPT
-
-asmlinkage void dbginterrupt_c(struct frame *fp)
-{
-	extern void dump(struct pt_regs *fp);
-	printk(KERN_DEBUG "%s(%d): BUS ERROR TRAP\n", __FILE__, __LINE__);
-	dump((struct pt_regs *) fp);
-	asm("halt");
-}
-
-#endif
-
-/***************************************************************************/
-
-extern e_vector	*_ramvec;
-
-void set_evector(int vecnum, void (*handler)(void))
-{
-	if (vecnum >= 0 && vecnum <= 255)
-		_ramvec[vecnum] = handler;
-}
-
-/***************************************************************************/
-
-/* Assembler routines */
-asmlinkage void buserr(void);
-asmlinkage void trap(void);
-asmlinkage void system_call(void);
-asmlinkage void inthandler(void);
-
-void __init init_vectors(void)
-{
-	int i;
-
-	/*
-	 *	There is a common trap handler and common interrupt
-	 *	handler that handle almost every vector. We treat
-	 *	the system call and bus error special, they get their
-	 *	own first level handlers.
-	 */
-	for (i = 3; (i <= 23); i++)
-		_ramvec[i] = trap;
-	for (i = 33; (i <= 63); i++)
-		_ramvec[i] = trap;
-	for (i = 24; (i <= 31); i++)
-		_ramvec[i] = inthandler;
-	for (i = 64; (i < 255); i++)
-		_ramvec[i] = inthandler;
-	_ramvec[255] = 0;
-
-	_ramvec[2] = buserr;
-	_ramvec[32] = system_call;
-
-#ifdef TRAP_DBG_INTERRUPT
-	_ramvec[12] = dbginterrupt;
-#endif
-}
-
-/***************************************************************************/
-
-void enable_vector(unsigned int irq)
-{
-	/* Currently no action on ColdFire */
-}
-
-void disable_vector(unsigned int irq)
-{
-	/* Currently no action on ColdFire */
-}
-
-void ack_vector(unsigned int irq)
-{
-	/* Currently no action on ColdFire */
-}
-
-/***************************************************************************/
-
-void coldfire_reset(void)
-{
-	HARD_RESET_NOW();
-}
-
-/***************************************************************************/
diff -Naurp linux-2.6.24/arch/m68knommu/platform/coldfire/vectors.c linux-2.6.24.1/arch/m68knommu/platform/coldfire/vectors.c
--- linux-2.6.24/arch/m68knommu/platform/coldfire/vectors.c	1970-01-01 10:00:00.000000000 +1000
+++ linux-2.6.24.1/arch/m68knommu/platform/coldfire/vectors.c	2008-01-25 08:58:37.000000000 +1000
@@ -0,0 +1,105 @@
+/***************************************************************************/
+
+/*
+ *	linux/arch/m68knommu/platform/5307/vectors.c
+ *
+ *	Copyright (C) 1999-2007, Greg Ungerer <gerg@snapgear.com>
+ */
+
+/***************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/irq.h>
+#include <asm/traps.h>
+#include <asm/machdep.h>
+#include <asm/coldfire.h>
+#include <asm/mcfsim.h>
+#include <asm/mcfdma.h>
+#include <asm/mcfwdebug.h>
+
+/***************************************************************************/
+
+#ifdef TRAP_DBG_INTERRUPT
+
+asmlinkage void dbginterrupt_c(struct frame *fp)
+{
+	extern void dump(struct pt_regs *fp);
+	printk(KERN_DEBUG "%s(%d): BUS ERROR TRAP\n", __FILE__, __LINE__);
+	dump((struct pt_regs *) fp);
+	asm("halt");
+}
+
+#endif
+
+/***************************************************************************/
+
+extern e_vector	*_ramvec;
+
+void set_evector(int vecnum, void (*handler)(void))
+{
+	if (vecnum >= 0 && vecnum <= 255)
+		_ramvec[vecnum] = handler;
+}
+
+/***************************************************************************/
+
+/* Assembler routines */
+asmlinkage void buserr(void);
+asmlinkage void trap(void);
+asmlinkage void system_call(void);
+asmlinkage void inthandler(void);
+
+void __init init_vectors(void)
+{
+	int i;
+
+	/*
+	 *	There is a common trap handler and common interrupt
+	 *	handler that handle almost every vector. We treat
+	 *	the system call and bus error special, they get their
+	 *	own first level handlers.
+	 */
+	for (i = 3; (i <= 23); i++)
+		_ramvec[i] = trap;
+	for (i = 33; (i <= 63); i++)
+		_ramvec[i] = trap;
+	for (i = 24; (i <= 31); i++)
+		_ramvec[i] = inthandler;
+	for (i = 64; (i < 255); i++)
+		_ramvec[i] = inthandler;
+	_ramvec[255] = 0;
+
+	_ramvec[2] = buserr;
+	_ramvec[32] = system_call;
+
+#ifdef TRAP_DBG_INTERRUPT
+	_ramvec[12] = dbginterrupt;
+#endif
+}
+
+/***************************************************************************/
+
+void enable_vector(unsigned int irq)
+{
+	/* Currently no action on ColdFire */
+}
+
+void disable_vector(unsigned int irq)
+{
+	/* Currently no action on ColdFire */
+}
+
+void ack_vector(unsigned int irq)
+{
+	/* Currently no action on ColdFire */
+}
+
+/***************************************************************************/
+
+void coldfire_reset(void)
+{
+	HARD_RESET_NOW();
+}
+
+/***************************************************************************/
