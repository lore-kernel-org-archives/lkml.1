Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbZHZGpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbZHZGpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbZHZGpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:45:23 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:57544
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755757AbZHZGpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:45:21 -0400
Subject: Subject: [PATCH 28/33] score: create lib/ files Makefile libgcc.h
	cmpdi2.c ucmpdi2.c string.S
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:34:52 +0800
Message-Id: <1251268492.3204.4.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3515e5ea96a4fa1f1f8cbeb0415b636540dc77b6 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:05:10 +0800
Subject: [PATCH 28/33] score: create lib/ files Makefile libgcc.h cmpdi2.c ucmpdi2.c string.S


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/lib/Makefile  |    8 ++
 arch/score/lib/cmpdi2.c  |   44 +++++++++++
 arch/score/lib/libgcc.h  |   37 +++++++++
 arch/score/lib/string.S  |  184 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/score/lib/ucmpdi2.c |   38 ++++++++++
 5 files changed, 311 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/lib/Makefile
 create mode 100644 arch/score/lib/cmpdi2.c
 create mode 100644 arch/score/lib/libgcc.h
 create mode 100644 arch/score/lib/string.S
 create mode 100644 arch/score/lib/ucmpdi2.c

diff --git a/arch/score/lib/Makefile b/arch/score/lib/Makefile
new file mode 100644
index 0000000..553e30e
--- /dev/null
+++ b/arch/score/lib/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for SCORE-specific library files..
+#
+
+lib-y += string.o checksum.o checksum_copy.o
+
+# libgcc-style stuff needed in the kernel
+obj-y += ashldi3.o ashrdi3.o cmpdi2.o lshrdi3.o ucmpdi2.o
diff --git a/arch/score/lib/cmpdi2.c b/arch/score/lib/cmpdi2.c
new file mode 100644
index 0000000..1ed5290
--- /dev/null
+++ b/arch/score/lib/cmpdi2.c
@@ -0,0 +1,44 @@
+/*
+ * arch/score/lib/cmpdi2.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include "libgcc.h"
+
+word_type __cmpdi2(long long a, long long b)
+{
+	const DWunion au = {
+		.ll = a
+	};
+	const DWunion bu = {
+		.ll = b
+	};
+
+	if (au.s.high < bu.s.high)
+		return 0;
+	else if (au.s.high > bu.s.high)
+		return 2;
+
+	if ((unsigned int) au.s.low < (unsigned int) bu.s.low)
+		return 0;
+	else if ((unsigned int) au.s.low > (unsigned int) bu.s.low)
+		return 2;
+
+	return 1;
+}
+EXPORT_SYMBOL(__cmpdi2);
diff --git a/arch/score/lib/libgcc.h b/arch/score/lib/libgcc.h
new file mode 100644
index 0000000..0f12543
--- /dev/null
+++ b/arch/score/lib/libgcc.h
@@ -0,0 +1,37 @@
+/*
+ * arch/score/lib/libgcc.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+
+#ifndef __ASM_LIBGCC_H
+#define __ASM_LIBGCC_H
+
+#include <asm/byteorder.h>
+
+typedef int word_type __attribute__((mode(__word__)));
+
+struct DWstruct {
+	int low, high;
+};
+
+typedef union {
+	struct DWstruct s;
+	long long ll;
+} DWunion;
+
+#endif /* __ASM_LIBGCC_H */
diff --git a/arch/score/lib/string.S b/arch/score/lib/string.S
new file mode 100644
index 0000000..00b7d3a
--- /dev/null
+++ b/arch/score/lib/string.S
@@ -0,0 +1,184 @@
+/*
+ * arch/score/lib/string.S
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/linkage.h>
+#include <asm-generic/errno.h>
+
+	.text
+	.align 2
+ENTRY(__strncpy_from_user)
+	cmpi.c	r6, 0
+	mv	r9, r6
+	ble	.L2
+0:	lbu	r7, [r5]
+	ldi	r8, 0
+1:	sb	r7, [r4]
+2:	lb	r6, [r5]
+	cmp.c	r6, r8
+	beq	.L2
+
+.L5:
+	addi	r8, 1
+	cmp.c	r8, r9
+	beq	.L7
+3:	lbu	r6, [r5, 1]+
+4:	sb	r6, [r4, 1]+
+5:	lb	r7, [r5]
+	cmpi.c	r7, 0
+	bne	.L5
+.L7:
+	mv	r4, r8
+	br	r3
+.L2:
+	ldi	r8, 0
+	mv	r4, r8
+	br	r3
+	.section .fixup, "ax"
+99:
+	ldi	r4, -EFAULT
+	br	r3
+	.previous
+	.section __ex_table, "a"
+	.align	2
+	.word	0b ,99b
+	.word	1b ,99b
+	.word	2b ,99b
+	.word	3b ,99b
+	.word	4b ,99b
+	.word	5b ,99b
+	.previous
+
+	.align 2
+ENTRY(__strnlen_user)
+	cmpi.c	r5, 0
+	ble	.L11
+0:	lb	r6, [r4]
+	ldi	r7, 0
+	cmp.c	r6, r7
+	beq	.L11
+.L15:
+	addi	r7, 1
+	cmp.c	r7, r5
+	beq	.L23
+1:	lb	r6, [r4,1]+
+	cmpi.c	r6, 0
+	bne	.L15
+.L23:
+	addri	r4, r7, 1
+	br	r3
+
+.L11:
+	ldi	r4, 1
+	br	r3
+	.section .fixup, "ax"
+99:
+	ldi	r4, 0
+	br	r3
+
+	.section __ex_table,"a"
+	.align 2
+	.word	0b, 99b
+	.word	1b, 99b
+	.previous
+
+	.align 2
+ENTRY(__strlen_user)
+0:	lb	r6, [r4]
+	mv	r7, r4
+	extsb	r6, r6
+	cmpi.c	r6, 0
+	mv	r4, r6
+	beq	.L27
+.L28:
+1:	lb	r6, [r7, 1]+
+	addi	r6, 1
+	cmpi.c	r6, 0
+	bne	.L28
+.L27:
+	br	r3
+	.section .fixup, "ax"
+	ldi	r4, 0x0
+	br	r3
+99:
+	ldi	r4, 0
+	br	r3
+	.previous
+	.section __ex_table, "a"
+	.align	2
+	.word	0b ,99b
+	.word	1b ,99b
+	.previous
+
+	.align 2
+ENTRY(__copy_tofrom_user)
+	cmpi.c	r6, 0
+	mv	r10,r6
+	beq	.L32
+	ldi	r9, 0
+.L34:
+	add	r6, r5, r9
+0:	lbu	r8, [r6]
+	add	r7, r4, r9
+1:	sb	r8, [r7]
+	addi	r9, 1
+	cmp.c	r9, r10
+	bne	.L34
+.L32:
+	ldi	r4, 0
+	br	r3
+	.section .fixup, "ax"
+99:
+	sub	r4, r10, r9
+	br	r3
+	.previous
+	.section __ex_table, "a"
+	.align	2
+	.word	0b, 99b
+	.word	1b, 99b
+	.previous
+
+	.align 2
+ENTRY(__clear_user)
+	cmpi.c	r5, 0
+	beq	.L38
+	ldi	r6, 0
+	mv	r7, r6
+.L40:
+	addi	r6, 1
+0:	sb	r7, [r4]+, 1
+	cmp.c	r6, r5
+	bne	.L40
+.L38:
+	ldi	r4, 0
+	br	r3
+
+	.section .fixup, "ax"
+	br	r3
+	.previous
+	.section __ex_table, "a"
+	.align	2
+99:
+	.word	0b, 99b
+	.previous
diff --git a/arch/score/lib/ucmpdi2.c b/arch/score/lib/ucmpdi2.c
new file mode 100644
index 0000000..b15241e
--- /dev/null
+++ b/arch/score/lib/ucmpdi2.c
@@ -0,0 +1,38 @@
+/*
+ * arch/score/lib/ucmpdi2.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include "libgcc.h"
+
+word_type __ucmpdi2(unsigned long long a, unsigned long long b)
+{
+	const DWunion au = {.ll = a};
+	const DWunion bu = {.ll = b};
+
+	if ((unsigned int) au.s.high < (unsigned int) bu.s.high)
+		return 0;
+	else if ((unsigned int) au.s.high > (unsigned int) bu.s.high)
+		return 2;
+	if ((unsigned int) au.s.low < (unsigned int) bu.s.low)
+		return 0;
+	else if ((unsigned int) au.s.low > (unsigned int) bu.s.low)
+		return 2;
+	return 1;
+}
+EXPORT_SYMBOL(__ucmpdi2);
-- 
1.6.2



