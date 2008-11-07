Return-Path: <linux-kernel-owner+w=401wt.eu-S933223AbZD3Pw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223AbZD3Pw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932480AbZD3Pmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:42:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57250 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383AbZD3PmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:42:03 -0400
Message-Id: <f2c76fdc73bd2bb03ab8ffa9983c71c0bba41c03.1241105648.git.arnd@arndb.de>
In-Reply-To: <cover.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 7 Nov 2008 21:43:31 +0100
Subject: [PATCH 14/27] asm-generic: make bitops.h usable
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
X-Provags-ID: V01U2FsdGVkX19X/0pH2BGp0n6sJVwotRIUKdXX1pfu9UsVyDw
 pQVVtQ2TmDkZvh5REGXvKWyqQ3LU8TmPcnloJqWYP/jBfcY0e0
 /1Vz4KRjG3gdZKSa+9vDw==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bitops.h apparently suffered from some level of bitrot, it
was missing the smp_mb__{before,after}_clear_bit functions,
and included other headers in an invalid order.

This changes the file so that new architectures can use
it out of the box.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
 include/asm-generic/bitops.h |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/bitops.h b/include/asm-generic/bitops.h
index c9f369c..a54f442 100644
--- a/include/asm-generic/bitops.h
+++ b/include/asm-generic/bitops.h
@@ -1,19 +1,29 @@
-#ifndef _ASM_GENERIC_BITOPS_H_
-#define _ASM_GENERIC_BITOPS_H_
+#ifndef __ASM_GENERIC_BITOPS_H
+#define __ASM_GENERIC_BITOPS_H
 
 /*
  * For the benefit of those who are trying to port Linux to another
  * architecture, here are some C-language equivalents.  You should
  * recode these in the native assembly language, if at all possible.
- * 
+ *
  * C language equivalents written by Theodore Ts'o, 9/26/92
  */
 
-#include <asm-generic/bitops/atomic.h>
-#include <asm-generic/bitops/non-atomic.h>
+#include <linux/irqflags.h>
+#include <linux/compiler.h>
+
+/*
+ * clear_bit may not imply a memory barrier
+ */
+#ifndef smp_mb__before_clear_bit
+#define smp_mb__before_clear_bit()	smp_mb()
+#define smp_mb__after_clear_bit()	smp_mb()
+#endif
+
 #include <asm-generic/bitops/__ffs.h>
 #include <asm-generic/bitops/ffz.h>
 #include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/find.h>
 
@@ -26,8 +36,10 @@
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
+#include <asm-generic/bitops/atomic.h>
+#include <asm-generic/bitops/non-atomic.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 
-#endif /* _ASM_GENERIC_BITOPS_H */
+#endif /* __ASM_GENERIC_BITOPS_H */
-- 
1.5.6.3


