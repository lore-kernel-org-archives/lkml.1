Return-Path: <linux-kernel-owner+w=401wt.eu-S932672AbZDCPr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbZDCPr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934142AbZDCPp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:45:56 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:48189 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931AbZDCPpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:45:53 -0400
Date: Fri, 3 Apr 2009 17:42:29 +0200
From: Bastian Blank <waldi@debian.org>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 5/5] s390: Use libgcc
Message-ID: <20090403154229.GE7200@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
References: <20090403153941.GA7045@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090403153941.GA7045@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build our version of the libgcc.  Remove conflicting __negdi2
implementation.

Signed-off-by: Bastian Blank <waldi@debian.org>
---
 arch/s390/Kconfig                       |    3 ++
 arch/s390/include/asm/libgcc/config.h   |    4 +++
 arch/s390/include/asm/libgcc/longlong.h |   42 +++++++++++++++++++++++++++++++
 arch/s390/math-emu/math.c               |   20 --------------
 4 files changed, 49 insertions(+), 20 deletions(-)
 create mode 100644 arch/s390/include/asm/libgcc/config.h
 create mode 100644 arch/s390/include/asm/libgcc/longlong.h

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index dcb667c..87128ef 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -75,6 +75,9 @@ config VIRT_CPU_ACCOUNTING
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	def_bool y
 
+config LIBGCC_SUPPORT
+	def_bool y
+
 mainmenu "Linux Kernel Configuration"
 
 config S390
diff --git a/arch/s390/include/asm/libgcc/config.h b/arch/s390/include/asm/libgcc/config.h
new file mode 100644
index 0000000..1688497
--- /dev/null
+++ b/arch/s390/include/asm/libgcc/config.h
@@ -0,0 +1,4 @@
+#define MIN_UNITS_PER_WORD 4
+#define BITS_PER_UNIT 8
+#define WORDS_BIG_ENDIAN 1
+#define LONG_LONG_TYPE_SIZE 64
diff --git a/arch/s390/include/asm/libgcc/longlong.h b/arch/s390/include/asm/libgcc/longlong.h
new file mode 100644
index 0000000..742445d
--- /dev/null
+++ b/arch/s390/include/asm/libgcc/longlong.h
@@ -0,0 +1,42 @@
+/*
+ * Definitions for mixed size 32/64 bit arithmetic, s390 specific parts.
+ *
+ * Copyright (C) 1991-2009 Free Software Foundation, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#if W_TYPE_SIZE == 32
+#define smul_ppmm(xh, xl, m0, m1) \
+  do {									\
+    union {DItype __ll;							\
+	   struct {USItype __h, __l;} __i;				\
+	  } __x;							\
+    __asm__ ("lr %N0,%1\n\tmr %0,%2"					\
+	     : "=&r" (__x.__ll)						\
+	     : "r" (m0), "r" (m1));					\
+    (xh) = __x.__i.__h; (xl) = __x.__i.__l;				\
+  } while (0)
+#define sdiv_qrnnd(q, r, n1, n0, d) \
+  do {									\
+    union {DItype __ll;							\
+	   struct {USItype __h, __l;} __i;				\
+	  } __x;							\
+    __x.__i.__h = n1; __x.__i.__l = n0;					\
+    __asm__ ("dr %0,%2"							\
+	     : "=r" (__x.__ll)						\
+	     : "0" (__x.__ll), "r" (d));				\
+    (q) = __x.__i.__l; (r) = __x.__i.__h;				\
+  } while (0)
+#endif
diff --git a/arch/s390/math-emu/math.c b/arch/s390/math-emu/math.c
index 3ee78cc..9f6869f 100644
--- a/arch/s390/math-emu/math.c
+++ b/arch/s390/math-emu/math.c
@@ -2233,23 +2233,3 @@ int math_emu_srnm(__u8 *opcode, struct pt_regs *regs) {
         current->thread.fp_regs.fpc |= (temp & 3);
         return 0;
 }
-
-/* broken compiler ... */
-long long
-__negdi2 (long long u)
-{
-
-  union lll {
-    long long ll;
-    long s[2];
-  };
-
-  union lll w,uu;
-
-  uu.ll = u;
-
-  w.s[1] = -uu.s[1];
-  w.s[0] = -uu.s[0] - ((int) w.s[1] != 0);
-
-  return w.ll;
-}
-- 
1.6.2.1

