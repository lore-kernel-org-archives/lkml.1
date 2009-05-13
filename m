Return-Path: <linux-kernel-owner+w=401wt.eu-S1762643AbZEMXA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762643AbZEMXA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 19:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761641AbZEMW5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:57:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:51511 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759769AbZEMW4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:56:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: [PATCH 09/15] asm-generic: make bitops.h usable
Date: Wed, 13 May 2009 22:56:32 +0000
Message-Id: <1242255398-23779-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1242255398-23779-1-git-send-email-arnd@arndb.de>
References: <1242255398-23779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/p64oWzgbGXFi3/6tdL0DshUVVSZbuWZ5QkOF
 VtW94CWI8/VsvYqYGGzPamvrRNb+cBH3o9GxRfoLctiziLyaTF
 hNbxf4nad470Zl3Jtx35A==
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
1.6.0.4

