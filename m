Return-Path: <linux-kernel-owner+w=401wt.eu-S1763761AbYETUpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763761AbYETUpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 16:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbYETUpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 16:45:42 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:36565 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbYETUpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 16:45:41 -0400
From: Trent Piepho <tpiepho@freescale.com>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, Trent Piepho <tpiepho@freescale.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>
Subject: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
Date: Tue, 20 May 2008 13:40:25 -0700
Message-Id: <1211316025-29069-1-git-send-email-tpiepho@freescale.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 4cb3cee03d558fd457cb58f56c80a2a09a66110c the code generated
for the in_beXX() and out_beXX() mmio functions has been sub-optimal.

The out_leXX() family of functions are created with the macro
DEF_MMIO_OUT_LE() while the out_beXX() family are created with
DEF_MMIO_OUT_BE().  In what was perhaps a bit too much macro use, both of
these macros are in turn created via the macro DEF_MMIO_OUT().

For the LE versions, eventually they boil down to an asm that will look
something like this:
asm("sync; stwbrx %1,0,%2" : "=m" (*addr) : "r" (val), "r" (addr));

While not perfect, this appears to be the best one can do.  The issue is
that the "stwbrx" instruction only comes in an indexed, or 'x', version, in
which the address is represented by the sum of two registers (the "0,%2").
Unfortunately, gcc doesn't have a constraint for an indexed memory
reference.  The "m" constraint allows both indexed and offset, i.e.
register plus constant, memory references and there is no "stwbr" version
for offset references.

The unused first operand to the asm is just to tell gcc that *addr is an
output of the asm.  The address used is passed in a single register via the
third asm operand, and the index register is just hard coded as 0.  This
means gcc is forced to put the address in a single register and can't use
index addressing, e.g. if one has the data in register 9, a base address in
register 3 and an index in register 4, gcc must emit code like "add 11,4,3;
stwbrx 9,0,11" instead of just "stwbrx 9,4,3".  This costs an extra add
instruction and another register.

This brings us the to problem with the BE version.  In this case, the "stw"
instruction does have both indexed and non-indexed versions.  The final asm
ends up looking like this:
asm("sync; stw%U0%X0 %1,%0" : "=m" (*addr) : "r" (val), "r" (addr));

The undocumented codes "%U0" and "%0X" will generate a 'u' if the memory
reference should be a auto-updating one, and an 'x' if the memory reference
is indexed, respectively.  The third operand is unused, it's just there
because asm the code is reused from the LE version.  However, gcc does not
know this, and generates unnecessary code to stick addr in a register!  To
use the example from the LE version, gcc will generate "add 11,4,3; stwx
9,4,3".  It is able to use the indexed address "4,3" for the "stwx", but
still thinks it needs to put 4+3 into register 11, which will never be
used.

This also ends up happening a lot for the offset addressing mode, where
common code like this:  out_be32(&device_registers->some_register, data);
uses an instruction like "stw 9, 42(3)", where register 3 has the pointer
device_registers and 42 is the offset of some_register in that structure.
gcc will be forced to generate the unnecessary instruction "addi 11, 3, 42"
to put the address into a single (unused) register.

The in_* versions end up having these exact same problems as well.

Signed-off-by: Trent Piepho <tpiepho@freescale.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Scott Wood <scottwood@freescale.com>
---
There was some discussion on a Freescale list if the powerpc I/O accessors
should be strictly ordered w.r.t.  normal memory.  Currently they are not.  It
does not appear as if any other architecture's I/O accessors are strictly
ordered in this manner.  memory-barriers.txt explicitly states that the I/O
space (inb, outw, etc.) are NOT strictly ordered w.r.t. normal memory
accesses and it's implied the other I/O accessors (e.g., writel) are the same.

However, it is somewhat harder to program for this model, and there are almost
certainly a number of drivers using coherent DMA which have subtle bugs because
the do not include the necessary barriers.

But clearly and change to this would be a subject for a different patch.

 include/asm-powerpc/io.h |   44 +++++++++++++++++++++++++-------------------
 1 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/include/asm-powerpc/io.h b/include/asm-powerpc/io.h
index e0062d7..795b5d4 100644
--- a/include/asm-powerpc/io.h
+++ b/include/asm-powerpc/io.h
@@ -95,33 +95,39 @@ extern resource_size_t isa_mem_base;
 #define IO_SET_SYNC_FLAG()
 #endif
 
-#define DEF_MMIO_IN(name, type, insn)					\
-static inline type name(const volatile type __iomem *addr)		\
+#define DEF_MMIO_IN_LE(name, size, insn)				\
+static inline u##size name(const volatile u##size __iomem *addr)	\
 {									\
-	type ret;							\
-	__asm__ __volatile__("sync;" insn ";twi 0,%0,0;isync"		\
- 		: "=r" (ret) : "r" (addr), "m" (*addr));		\
+	u##size ret;							\
+	__asm__ __volatile__("sync;"#insn" %0,0,%1;twi 0,%0,0;isync"	\
+		: "=r" (ret) : "r" (addr), "m" (*addr));		\
 	return ret;							\
 }
 
-#define DEF_MMIO_OUT(name, type, insn)					\
-static inline void name(volatile type __iomem *addr, type val)		\
+#define DEF_MMIO_IN_BE(name, size, insn)				\
+static inline u##size name(const volatile u##size __iomem *addr)	\
 {									\
-	__asm__ __volatile__("sync;" insn				\
- 		: "=m" (*addr) : "r" (val), "r" (addr));		\
-	IO_SET_SYNC_FLAG();					\
+	u##size ret;							\
+	__asm__ __volatile__("sync;"#insn"%U1%X1 %0,%1;twi 0,%0,0;isync"\
+		: "=r" (ret) : "m" (*addr));				\
+	return ret;							\
 }
 
+#define DEF_MMIO_OUT_BE(name, size, insn)				\
+static inline void name(volatile u##size __iomem *addr, u##size val)	\
+{									\
+	__asm__ __volatile__("sync;"#insn"%U0%X0 %1,%0"			\
+		: "=m" (*addr) : "r" (val));				\
+	IO_SET_SYNC_FLAG();						\
+}
 
-#define DEF_MMIO_IN_BE(name, size, insn) \
-	DEF_MMIO_IN(name, u##size, __stringify(insn)"%U2%X2 %0,%2")
-#define DEF_MMIO_IN_LE(name, size, insn) \
-	DEF_MMIO_IN(name, u##size, __stringify(insn)" %0,0,%1")
-
-#define DEF_MMIO_OUT_BE(name, size, insn) \
-	DEF_MMIO_OUT(name, u##size, __stringify(insn)"%U0%X0 %1,%0")
-#define DEF_MMIO_OUT_LE(name, size, insn) \
-	DEF_MMIO_OUT(name, u##size, __stringify(insn)" %1,0,%2")
+#define DEF_MMIO_OUT_LE(name, size, insn) 				\
+static inline void name(volatile u##size __iomem *addr, u##size val)	\
+{									\
+	__asm__ __volatile__("sync;"#insn" %1,0,%2"			\
+		: "=m" (*addr) : "r" (val), "r" (addr));		\
+	IO_SET_SYNC_FLAG();						\
+}
 
 DEF_MMIO_IN_BE(in_8,     8, lbz);
 DEF_MMIO_IN_BE(in_be16, 16, lhz);
-- 
1.5.4.1

