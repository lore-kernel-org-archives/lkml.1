Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbYCORfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbYCORfw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 13:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbYCORfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 13:35:36 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:11486 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbYCORfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 13:35:34 -0400
Date: Sat, 15 Mar 2008 18:31:49 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       linux-arch <linux-arch@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>, heukelum@fastmail.fm
Subject: [2/3] Implement __fls on all 64-bit archs
Message-ID: <20080315173149.GB21659@mailshack.com>
References: <20080315172913.GA21648@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080315172913.GA21648@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Sat, 15 Mar 2008 18:34:49 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.73; VDF: 7.0.3.31; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement __fls on all 64-bit archs:

alpha has an implementation of fls64.
	Added __fls(x) = fls64(x) - 1.

ia64 has fls, but not __fls.
	Added __fls based on code of fls.

mips and powerpc have __ilog2, which is the same as __fls.
	Added __fls = __ilog2.

parisc, s390, sh and sparc64:
	Include generic __fls.

x86_64 already has __fls.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 include/asm-alpha/bitops.h   |    5 +++++
 include/asm-ia64/bitops.h    |   16 ++++++++++++++++
 include/asm-mips/bitops.h    |    5 +++++
 include/asm-parisc/bitops.h  |    1 +
 include/asm-powerpc/bitops.h |    5 +++++
 include/asm-s390/bitops.h    |    1 +
 include/asm-sh/bitops.h      |    1 +
 include/asm-sparc64/bitops.h |    1 +
 8 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/include/asm-alpha/bitops.h b/include/asm-alpha/bitops.h
index 9e19a70..15f3ae2 100644
--- a/include/asm-alpha/bitops.h
+++ b/include/asm-alpha/bitops.h
@@ -388,6 +388,11 @@ static inline int fls64(unsigned long x)
 }
 #endif
 
+static inline unsigned long __fls(unsigned long x)
+{
+	return fls64(x) - 1;
+}
+
 static inline int fls(int x)
 {
 	return fls64((unsigned int) x);
diff --git a/include/asm-ia64/bitops.h b/include/asm-ia64/bitops.h
index 953d3df..e2ca800 100644
--- a/include/asm-ia64/bitops.h
+++ b/include/asm-ia64/bitops.h
@@ -407,6 +407,22 @@ fls (int t)
 	return ia64_popcnt(x);
 }
 
+/*
+ * Find the last (most significant) bit set.  Undefined for x==0.
+ * Bits are numbered from 0..63 (e.g., __fls(9) == 3).
+ */
+static inline unsigned long
+__fls (unsigned long x)
+{
+	x |= x >> 1;
+	x |= x >> 2;
+	x |= x >> 4;
+	x |= x >> 8;
+	x |= x >> 16;
+	x |= x >> 32;
+	return ia64_popcnt(x) - 1;
+}
+
 #include <asm-generic/bitops/fls64.h>
 
 /*
diff --git a/include/asm-mips/bitops.h b/include/asm-mips/bitops.h
index ec75ce4..c2bd126 100644
--- a/include/asm-mips/bitops.h
+++ b/include/asm-mips/bitops.h
@@ -591,6 +591,11 @@ static inline int __ilog2(unsigned long x)
 	return 63 - lz;
 }
 
+static inline unsigned long __fls(unsigned long x)
+{
+	return __ilog2(x);
+}
+
 #if defined(CONFIG_CPU_MIPS32) || defined(CONFIG_CPU_MIPS64)
 
 /*
diff --git a/include/asm-parisc/bitops.h b/include/asm-parisc/bitops.h
index f8eebcb..7a6ea10 100644
--- a/include/asm-parisc/bitops.h
+++ b/include/asm-parisc/bitops.h
@@ -210,6 +210,7 @@ static __inline__ int fls(int x)
 	return ret;
 }
 
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
diff --git a/include/asm-powerpc/bitops.h b/include/asm-powerpc/bitops.h
index 220d9a7..2fc0c45 100644
--- a/include/asm-powerpc/bitops.h
+++ b/include/asm-powerpc/bitops.h
@@ -312,6 +312,11 @@ static __inline__ int fls(unsigned int x)
 	asm ("cntlzw %0,%1" : "=r" (lz) : "r" (x));
 	return 32 - lz;
 }
+
+static __inline__ unsigned long __fls(unsigned long x)
+{
+	return __ilog2(x);
+}
 #include <asm-generic/bitops/fls64.h>
 
 #include <asm-generic/bitops/hweight.h>
diff --git a/include/asm-s390/bitops.h b/include/asm-s390/bitops.h
index 965394e..b4eb24a 100644
--- a/include/asm-s390/bitops.h
+++ b/include/asm-s390/bitops.h
@@ -769,6 +769,7 @@ static inline int sched_find_first_bit(unsigned long *b)
 }
 
 #include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 
 #include <asm-generic/bitops/hweight.h>
diff --git a/include/asm-sh/bitops.h b/include/asm-sh/bitops.h
index b6ba5a6..d7d382f 100644
--- a/include/asm-sh/bitops.h
+++ b/include/asm-sh/bitops.h
@@ -95,6 +95,7 @@ static inline unsigned long ffz(unsigned long word)
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 #include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 
 #endif /* __KERNEL__ */
diff --git a/include/asm-sparc64/bitops.h b/include/asm-sparc64/bitops.h
index 982ce89..11f9d81 100644
--- a/include/asm-sparc64/bitops.h
+++ b/include/asm-sparc64/bitops.h
@@ -34,6 +34,7 @@ extern void change_bit(unsigned long nr, volatile unsigned long *addr);
 #include <asm-generic/bitops/ffz.h>
 #include <asm-generic/bitops/__ffs.h>
 #include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 
 #ifdef __KERNEL__

