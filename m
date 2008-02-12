Return-Path: <linux-kernel-owner+w=401wt.eu-S1760171AbYBLPYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171AbYBLPYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbYBLPY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:24:27 -0500
Received: from smtp-107-backup.noc.nerim.net ([62.4.17.107]:3409 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752727AbYBLPY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:24:26 -0500
Date: Tue, 12 Feb 2008 16:24:22 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Subject: [PATCH] dmi: Clean-up dmi helper declarations
Message-ID: <20080212162422.3780e44c@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The declaration of dmi helper functions is a bit messy and inconsistent
at the moment:
* On ia64 they are declared in <asm/io.h>.
* On x86-64 they are declared in <asm/dmi.h>.
* On i386 they are declared both in <asm/io.h> and <asm/dmi.h>.

Fix the header files so that the dmi helper functions are consistently
defined in <asm/dmi.h>.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Matt Domsch <Matt_Domsch@dell.com>
---
Only tested on i386 and x86-64, maybe Matt can test on ia64?

 include/asm-ia64/dmi.h  |    5 +++++
 include/asm-ia64/io.h   |    5 -----
 include/asm-x86/dmi.h   |    1 +
 include/asm-x86/io_32.h |    5 -----
 4 files changed, 6 insertions(+), 10 deletions(-)

--- linux-2.6.25-rc1.orig/include/asm-ia64/dmi.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.25-rc1/include/asm-ia64/dmi.h	2008-02-12 14:44:31.000000000 +0100
@@ -3,4 +3,9 @@
 
 #include <asm/io.h>
 
+/* Use normal IO mappings for DMI */
+#define dmi_ioremap ioremap
+#define dmi_iounmap(x,l) iounmap(x)
+#define dmi_alloc(l) kmalloc(l, GFP_ATOMIC)
+
 #endif
--- linux-2.6.25-rc1.orig/include/asm-ia64/io.h	2008-01-25 10:27:06.000000000 +0100
+++ linux-2.6.25-rc1/include/asm-ia64/io.h	2008-02-12 14:44:35.000000000 +0100
@@ -423,11 +423,6 @@ extern void __iomem * ioremap(unsigned l
 extern void __iomem * ioremap_nocache (unsigned long offset, unsigned long size);
 extern void iounmap (volatile void __iomem *addr);
 
-/* Use normal IO mappings for DMI */
-#define dmi_ioremap ioremap
-#define dmi_iounmap(x,l) iounmap(x)
-#define dmi_alloc(l) kmalloc(l, GFP_ATOMIC)
-
 /*
  * String version of IO memory access ops:
  */
--- linux-2.6.25-rc1.orig/include/asm-x86/dmi.h	2008-02-11 09:49:09.000000000 +0100
+++ linux-2.6.25-rc1/include/asm-x86/dmi.h	2008-02-12 14:45:47.000000000 +0100
@@ -27,6 +27,7 @@ static inline void *dmi_alloc(unsigned l
 
 #endif
 
+/* Use early IO mappings for DMI because it's initialized early */
 #define dmi_ioremap early_ioremap
 #define dmi_iounmap early_iounmap
 
--- linux-2.6.25-rc1.orig/include/asm-x86/io_32.h	2008-02-11 09:49:09.000000000 +0100
+++ linux-2.6.25-rc1/include/asm-x86/io_32.h	2008-02-12 14:45:54.000000000 +0100
@@ -139,11 +139,6 @@ extern void *early_ioremap(unsigned long
 extern void early_iounmap(void *addr, unsigned long size);
 extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
 
-/* Use early IO mappings for DMI because it's initialized early */
-#define dmi_ioremap early_ioremap
-#define dmi_iounmap early_iounmap
-#define dmi_alloc alloc_bootmem
-
 /*
  * ISA I/O bus memory addresses are 1:1 with the physical address.
  */


-- 
Jean Delvare
