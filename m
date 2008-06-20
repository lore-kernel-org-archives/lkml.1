Return-Path: <linux-kernel-owner+w=401wt.eu-S1758971AbYFTX6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971AbYFTX6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 19:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756738AbYFTX4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 19:56:48 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:33940 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbYFTX4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 19:56:44 -0400
Date: Sat, 21 Jun 2008 03:28:31 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: fix compile failures with gcc-4.3 (bug #10438)
Message-ID: <20080620232831.GC8061@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vast majority of these build failures are gcc-4.3 warnings
about static functions and objects being referenced from
non-static (read: "extern inline") functions, in conjunction
with our -Werror.

We cannot just convert "extern inline" to "static inline",
as people keep suggesting all the time, because "extern inline"
logic is crucial for generic kernel build.
So
- just make sure that all callees of critical "extern inline"
  functions are also "extern inline";
- use "static inline", wherever it's possible.

traps.c: work around gcc-4.3 being too smart about array
bounds-checking.

TODO: add "gnu_inline" attribute to all our "extern inline"
functions to ensure desired behaviour with future compilers.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/kernel/core_t2.c     |    2 ++
 arch/alpha/kernel/traps.c       |    3 ++-
 include/asm-alpha/core_mcpcia.h |    2 +-
 include/asm-alpha/core_t2.h     |   14 +++++++-------
 include/asm-alpha/io.h          |    6 +++---
 include/asm-alpha/mmu_context.h |    6 +++---
 include/asm-alpha/system.h      |   10 +++++-----
 include/asm-alpha/vga.h         |    6 +++---
 8 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/arch/alpha/kernel/core_t2.c b/arch/alpha/kernel/core_t2.c
index c075029..d9980d4 100644
--- a/arch/alpha/kernel/core_t2.c
+++ b/arch/alpha/kernel/core_t2.c
@@ -74,6 +74,8 @@
 # define DBG(args)
 #endif
 
+DEFINE_SPINLOCK(t2_hae_lock);
+
 static volatile unsigned int t2_mcheck_any_expected;
 static volatile unsigned int t2_mcheck_last_taken;
 
diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index dc57790..c778779 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -447,7 +447,7 @@ struct unaligned_stat {
 
 
 /* Macro for exception fixup code to access integer registers.  */
-#define una_reg(r)  (regs->regs[(r) >= 16 && (r) <= 18 ? (r)+19 : (r)])
+#define una_reg(r)  (_regs[(r) >= 16 && (r) <= 18 ? (r)+19 : (r)])
 
 
 asmlinkage void
@@ -456,6 +456,7 @@ do_entUna(void * va, unsigned long opcode, unsigned long reg,
 {
 	long error, tmp1, tmp2, tmp3, tmp4;
 	unsigned long pc = regs->pc - 4;
+	unsigned long *_regs = regs->regs;
 	const struct exception_table_entry *fixup;
 
 	unaligned[0].count++;
diff --git a/include/asm-alpha/core_mcpcia.h b/include/asm-alpha/core_mcpcia.h
index 525b4f6..acf55b4 100644
--- a/include/asm-alpha/core_mcpcia.h
+++ b/include/asm-alpha/core_mcpcia.h
@@ -261,7 +261,7 @@ struct el_MCPCIA_uncorrected_frame_mcheck {
 	}
 #endif
 
-static inline int __mcpcia_is_mmio(unsigned long addr)
+extern inline int __mcpcia_is_mmio(unsigned long addr)
 {
 	return (addr & 0x80000000UL) == 0;
 }
diff --git a/include/asm-alpha/core_t2.h b/include/asm-alpha/core_t2.h
index 90e6b5d..46bfff5 100644
--- a/include/asm-alpha/core_t2.h
+++ b/include/asm-alpha/core_t2.h
@@ -356,13 +356,13 @@ struct el_t2_frame_corrected {
 #define vip	volatile int *
 #define vuip	volatile unsigned int *
 
-static inline u8 t2_inb(unsigned long addr)
+extern inline u8 t2_inb(unsigned long addr)
 {
 	long result = *(vip) ((addr << 5) + T2_IO + 0x00);
 	return __kernel_extbl(result, addr & 3);
 }
 
-static inline void t2_outb(u8 b, unsigned long addr)
+extern inline void t2_outb(u8 b, unsigned long addr)
 {
 	unsigned long w;
 
@@ -371,13 +371,13 @@ static inline void t2_outb(u8 b, unsigned long addr)
 	mb();
 }
 
-static inline u16 t2_inw(unsigned long addr)
+extern inline u16 t2_inw(unsigned long addr)
 {
 	long result = *(vip) ((addr << 5) + T2_IO + 0x08);
 	return __kernel_extwl(result, addr & 3);
 }
 
-static inline void t2_outw(u16 b, unsigned long addr)
+extern inline void t2_outw(u16 b, unsigned long addr)
 {
 	unsigned long w;
 
@@ -386,12 +386,12 @@ static inline void t2_outw(u16 b, unsigned long addr)
 	mb();
 }
 
-static inline u32 t2_inl(unsigned long addr)
+extern inline u32 t2_inl(unsigned long addr)
 {
 	return *(vuip) ((addr << 5) + T2_IO + 0x18);
 }
 
-static inline void t2_outl(u32 b, unsigned long addr)
+extern inline void t2_outl(u32 b, unsigned long addr)
 {
 	*(vuip) ((addr << 5) + T2_IO + 0x18) = b;
 	mb();
@@ -435,7 +435,7 @@ static inline void t2_outl(u32 b, unsigned long addr)
 	set_hae(msb); \
 }
 
-static DEFINE_SPINLOCK(t2_hae_lock);
+extern spinlock_t t2_hae_lock;
 
 /*
  * NOTE: take T2_DENSE_MEM off in each readX/writeX routine, since
diff --git a/include/asm-alpha/io.h b/include/asm-alpha/io.h
index 38f18cf..e971ab0 100644
--- a/include/asm-alpha/io.h
+++ b/include/asm-alpha/io.h
@@ -35,7 +35,7 @@
  * register not being up-to-date with respect to the hardware
  * value.
  */
-static inline void __set_hae(unsigned long new_hae)
+extern inline void __set_hae(unsigned long new_hae)
 {
 	unsigned long flags;
 	local_irq_save(flags);
@@ -49,7 +49,7 @@ static inline void __set_hae(unsigned long new_hae)
 	local_irq_restore(flags);
 }
 
-static inline void set_hae(unsigned long new_hae)
+extern inline void set_hae(unsigned long new_hae)
 {
 	if (new_hae != alpha_mv.hae_cache)
 		__set_hae(new_hae);
@@ -176,7 +176,7 @@ REMAP2(u64, writeq, volatile)
 #undef REMAP1
 #undef REMAP2
 
-static inline void __iomem *generic_ioportmap(unsigned long a)
+extern inline void __iomem *generic_ioportmap(unsigned long a)
 {
 	return alpha_mv.mv_ioportmap(a);
 }
diff --git a/include/asm-alpha/mmu_context.h b/include/asm-alpha/mmu_context.h
index 6a5be1f..86c08a0 100644
--- a/include/asm-alpha/mmu_context.h
+++ b/include/asm-alpha/mmu_context.h
@@ -23,7 +23,7 @@
 #endif
 
 
-extern inline unsigned long
+static inline unsigned long
 __reload_thread(struct pcb_struct *pcb)
 {
 	register unsigned long a0 __asm__("$16");
@@ -114,7 +114,7 @@ extern unsigned long last_asn;
 #define __MMU_EXTERN_INLINE
 #endif
 
-static inline unsigned long
+extern inline unsigned long
 __get_new_mm_context(struct mm_struct *mm, long cpu)
 {
 	unsigned long asn = cpu_last_asn(cpu);
@@ -226,7 +226,7 @@ ev4_activate_mm(struct mm_struct *prev_mm, struct mm_struct *next_mm)
 # endif
 #endif
 
-extern inline int
+static inline int
 init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 {
 	int i;
diff --git a/include/asm-alpha/system.h b/include/asm-alpha/system.h
index ed221d6..afe20fa 100644
--- a/include/asm-alpha/system.h
+++ b/include/asm-alpha/system.h
@@ -184,7 +184,7 @@ enum amask_enum {
    __amask; })
 
 #define __CALL_PAL_R0(NAME, TYPE)				\
-static inline TYPE NAME(void)					\
+extern inline TYPE NAME(void)					\
 {								\
 	register TYPE __r0 __asm__("$0");			\
 	__asm__ __volatile__(					\
@@ -196,7 +196,7 @@ static inline TYPE NAME(void)					\
 }
 
 #define __CALL_PAL_W1(NAME, TYPE0)				\
-static inline void NAME(TYPE0 arg0)				\
+extern inline void NAME(TYPE0 arg0)				\
 {								\
 	register TYPE0 __r16 __asm__("$16") = arg0;		\
 	__asm__ __volatile__(					\
@@ -207,7 +207,7 @@ static inline void NAME(TYPE0 arg0)				\
 }
 
 #define __CALL_PAL_W2(NAME, TYPE0, TYPE1)			\
-static inline void NAME(TYPE0 arg0, TYPE1 arg1)			\
+extern inline void NAME(TYPE0 arg0, TYPE1 arg1)			\
 {								\
 	register TYPE0 __r16 __asm__("$16") = arg0;		\
 	register TYPE1 __r17 __asm__("$17") = arg1;		\
@@ -219,7 +219,7 @@ static inline void NAME(TYPE0 arg0, TYPE1 arg1)			\
 }
 
 #define __CALL_PAL_RW1(NAME, RTYPE, TYPE0)			\
-static inline RTYPE NAME(TYPE0 arg0)				\
+extern inline RTYPE NAME(TYPE0 arg0)				\
 {								\
 	register RTYPE __r0 __asm__("$0");			\
 	register TYPE0 __r16 __asm__("$16") = arg0;		\
@@ -232,7 +232,7 @@ static inline RTYPE NAME(TYPE0 arg0)				\
 }
 
 #define __CALL_PAL_RW2(NAME, RTYPE, TYPE0, TYPE1)		\
-static inline RTYPE NAME(TYPE0 arg0, TYPE1 arg1)		\
+extern inline RTYPE NAME(TYPE0 arg0, TYPE1 arg1)		\
 {								\
 	register RTYPE __r0 __asm__("$0");			\
 	register TYPE0 __r16 __asm__("$16") = arg0;		\
diff --git a/include/asm-alpha/vga.h b/include/asm-alpha/vga.h
index e8df1e7..c00106b 100644
--- a/include/asm-alpha/vga.h
+++ b/include/asm-alpha/vga.h
@@ -13,7 +13,7 @@
 #define VT_BUF_HAVE_MEMSETW
 #define VT_BUF_HAVE_MEMCPYW
 
-extern inline void scr_writew(u16 val, volatile u16 *addr)
+static inline void scr_writew(u16 val, volatile u16 *addr)
 {
 	if (__is_ioaddr(addr))
 		__raw_writew(val, (volatile u16 __iomem *) addr);
@@ -21,7 +21,7 @@ extern inline void scr_writew(u16 val, volatile u16 *addr)
 		*addr = val;
 }
 
-extern inline u16 scr_readw(volatile const u16 *addr)
+static inline u16 scr_readw(volatile const u16 *addr)
 {
 	if (__is_ioaddr(addr))
 		return __raw_readw((volatile const u16 __iomem *) addr);
@@ -29,7 +29,7 @@ extern inline u16 scr_readw(volatile const u16 *addr)
 		return *addr;
 }
 
-extern inline void scr_memsetw(u16 *s, u16 c, unsigned int count)
+static inline void scr_memsetw(u16 *s, u16 c, unsigned int count)
 {
 	if (__is_ioaddr(s))
 		memsetw_io((u16 __iomem *) s, c, count);
