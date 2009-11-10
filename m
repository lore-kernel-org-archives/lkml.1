Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbZKJWHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbZKJWHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbZKJWHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:07:17 -0500
Received: from 1wt.eu ([62.212.114.60]:50931 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbZKJWHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:07:14 -0500
Date: Tue, 10 Nov 2009 23:06:52 +0100
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, Avi Kivity <avi@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091110220652.GE26633@1wt.eu>
References: <20091110105642.215804e0@lxorguk.ukuu.org.uk> <4AF99E04.8080704@zytor.com> <20091110172454.3c4481f2@lxorguk.ukuu.org.uk> <4AF9B5AB.5010800@zytor.com> <4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com> <20091110201602.GA26633@1wt.eu> <20091110205445.GB1407@ucw.cz> <20091110211259.GD26633@1wt.eu> <4AF9D8E2.7050205@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF9D8E2.7050205@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 01:19:30PM -0800, H. Peter Anvin wrote:
> Willy, perhaps you can come up with a list of features you think should
> be emulated, together with an explanation of why you opted for that list
> of features and *did not* opt for others.

Well, the instructions I had to emulate were the result of failures
to run standard distros on older machines. When I ran a 486 distro
on my old 386, I found that almost everything worked except a few
programs making use of BSWAP for htonl(), and a small group of other
ones making occasional use of CMPXCHG for mutex handling. So I checked
the differences between 386 and 486 and found that the last remaining
one was XADD which I did not find in my binaries but which was really
obvious to implement, so it made sense to complete the emulator. That
said, a feature was missing with CMPXCHG. It was generally used with
a LOCK prefix which could not be emulated. In practice, that wasn't
an issue since I did not have any SMP i386 and I think we might only
find them on some very specific industrial boards if any.

So with just CMPXCHG + BSWAP (+xadd for the sake of completeness),
my 486 distro was fully operational on my 386.

At one point I got a laptop equipped with a K6-2. This one lacked
CMOV but I was very rarely hit, so I did not bother extending the
patch.

Later when I bought a VIA C3 the same issue happened when I sometimes
transferred a binary from my athlon to the C3 (both mounted the same
NFS home dirs, and my GCC on the athlon was optimizing by default for
686). Then I experimented a little bit with CMOV, discovering that it
only implemented CMOV reg,reg. So I added the instruction to the patch.

I then regularly started to get mails from people installing i686
distros on their C3 or K6 boards and who wanted the patch for the
same reasons (K6 induced people in error because of the "6" in its
name).

I remember that Debian at one point merged the part of the patch
providing the 486 emulation in their kernel. I don't know if they
finally merged the CMOV part too, I think not because they did
not optimize for 686.

But what I can say is that after emulating those instructions, I
never got any illegal instruction anymore on my systems. Here
Matteo reports an issue with NOPL, which might have been introduced
with newer compilers. So if we get NOPL+CMOV, I think that every
CPU starting from 486 will be able to execute all the applications
I have been running on those machines. We can add the 486 ones if
we think it's worth it.

Once again, I have no argument against emulating more instructions.
It's just that I never needed them, and I fear that doing so might
render the code a lot more complex and slower. Maybe time will prove
me wrong and I will have no problem with that. We can re-open this
thread after the first report of a SIGILL with the patch applied.

So in my opinion, we should have :
  - CMOV (for 486, Pentium, C3, K6, ...)
  - NOPL (newcomer)

And if we want to extend down to i386 :
  - BSWAP (=htonl)
  - CMPXCHG (mutex)
  - XADD (never encoutered but cheap)

I still have the 2.4 patch for BSWAP, CMPXCHG, CMOV and XADD lying
around. I'm appending it to the end of this mail in case it can fuel
the discussion. I've not ported it to 2.6 yet simply because my old
systems are still on 2.4, but volunteers are welcome :-)

> Note: emulated FPU is a special subcase.  The FPU operations are
> heavyweight enough that the overhead of trapping versus library calls is
> relatively insignificant.

Agreed for most of them, though some cheap ones such as FADD can
see a huge difference. In fact it's mostly that it's been common
for a long time to see slow software FPU (till 386 & 486-SX), so
it's been avoided for a long time.

Regards,
Willy

---

diff -urN linux-2.4.25-wt2-base/Documentation/Configure.help linux-2.4.25-wt2/Documentation/Configure.help
--- linux-2.4.25-wt2-base/Documentation/Configure.help	Thu Mar  4 17:14:48 2004
+++ linux-2.4.25-wt2/Documentation/Configure.help	Thu Mar  4 17:23:08 2004
@@ -5279,6 +5279,66 @@
 
   Note, this kernel will not boot on older (pre model 9) C3s.
 
+486 emulation
+CONFIG_CPU_EMU486
+  When used on a 386, Linux can emulate 3 instructions from the 486 set.
+  This allows user space programs compiled for 486 to run on a 386
+  without crashing with a SIGILL. As any emulation, performance will be
+  very low, but since these instruction are not often used, this might
+  not hurt. The emulated instructions are :
+     - bswap (does the same as htonl())
+     - cmpxchg (used in multi-threading, mutex locking)
+     - xadd (rarely used)
+
+  Note that this can also allow Step-A 486's to correctly run multi-thread
+  applications since cmpxchg has a wrong opcode on this early CPU.
+
+  Don't use this to enable multi-threading on an SMP machine, the lock
+  atomicity can't be guaranted !
+
+  Although it's highly preferable that you only execute programs targetted
+  for your CPU, it may happen that, consecutively to a hardware replacement,
+  or during rescue of a damaged system, you have to execute such programs
+  on an inadapted processor. In this case, this option will help you get
+  your programs working, even if they will be slower.
+
+  It is recommended that you say N here in any case, except for the
+  kernels that you will use on your rescue disks.
+  
+  This option should not be left on by default, because it means that
+  you execute a program not targetted for your CPU. You should recompile
+  your applications whenever possible.
+
+  If you are not sure, say N.
+
+Pentium-Pro CMOV emulation
+CONFIG_CPU_EMU686
+  Intel Pentium-Pro processor brought a new set of instructions borrowed
+  from RISC processors, which permit to write many simple conditionnal
+  blocks without a branch instruction, thus being faster. They are supported
+  on all PentiumII, PentiumIII, Pentium4 and Celerons to date. GCC generates
+  these instructions when "-march=i686" is specified. There is an ever
+  increasing number of programs compiled with this option, that will simply
+  crash on 386/486/Pentium/AmdK6 and others when trying to execute the
+  faulty instruction.
+
+  Although it's highly preferable that you only execute programs targetted
+  for your CPU, it may happen that, consecutively to a hardware replacement,
+  or during rescue of a damaged system, you have to execute such programs
+  on an inadapted processor. In this case, this option will help you keep
+  your programs working, even if some may be noticeably slower : an overhead
+  of 1us has been measured on a k6-2/450 (about 450 cycles).
+
+  It is recommended that you say N here in any case, except for the
+  kernels that you will use on your rescue disks. This emulation typically
+  increases a bzImage with 500 bytes.
+  
+  This option should not be left on by default, because it means that
+  you execute a program not targetted for your CPU. You should recompile
+  your applications whenever possible.
+
+  If you are not sure, say N.
+
 32-bit PDC
 CONFIG_PDC_NARROW
   Saying Y here will allow developers with a C180, C200, C240, C360,
diff -urN linux-2.4.25-wt2-base/arch/i386/config.in linux-2.4.25-wt2/arch/i386/config.in
--- linux-2.4.25-wt2-base/arch/i386/config.in	Thu Mar  4 17:14:48 2004
+++ linux-2.4.25-wt2/arch/i386/config.in	Thu Mar  4 17:26:01 2004
@@ -59,6 +59,8 @@
    define_bool CONFIG_RWSEM_XCHGADD_ALGORITHM n
    define_bool CONFIG_X86_PPRO_FENCE y
    define_bool CONFIG_X86_F00F_WORKS_OK n
+   bool '486 emulation' CONFIG_CPU_EMU486
+   dep_bool 'Pentium-Pro CMOV emulation' CONFIG_CPU_EMU686 $CONFIG_CPU_EMU486
 else
    define_bool CONFIG_X86_WP_WORKS_OK y
    define_bool CONFIG_X86_INVLPG y
@@ -75,6 +77,7 @@
    define_bool CONFIG_X86_ALIGNMENT_16 y
    define_bool CONFIG_X86_PPRO_FENCE y
    define_bool CONFIG_X86_F00F_WORKS_OK n
+   bool 'Pentium-Pro CMOV emulation' CONFIG_CPU_EMU686
 fi
 if [ "$CONFIG_M586" = "y" ]; then
    define_int  CONFIG_X86_L1_CACHE_SHIFT 5
@@ -82,6 +85,7 @@
    define_bool CONFIG_X86_ALIGNMENT_16 y
    define_bool CONFIG_X86_PPRO_FENCE y
    define_bool CONFIG_X86_F00F_WORKS_OK n
+   bool 'Pentium-Pro CMOV emulation' CONFIG_CPU_EMU686
 fi
 if [ "$CONFIG_M586TSC" = "y" ]; then
    define_int  CONFIG_X86_L1_CACHE_SHIFT 5
@@ -90,6 +94,7 @@
    define_bool CONFIG_X86_HAS_TSC y
    define_bool CONFIG_X86_PPRO_FENCE y
    define_bool CONFIG_X86_F00F_WORKS_OK n
+   bool 'Pentium-Pro CMOV emulation' CONFIG_CPU_EMU686
 fi
 if [ "$CONFIG_M586MMX" = "y" ]; then
    define_int  CONFIG_X86_L1_CACHE_SHIFT 5
@@ -99,6 +104,7 @@
    define_bool CONFIG_X86_GOOD_APIC y
    define_bool CONFIG_X86_PPRO_FENCE y
    define_bool CONFIG_X86_F00F_WORKS_OK n
+   bool 'Pentium-Pro CMOV emulation' CONFIG_CPU_EMU686
 fi
 if [ "$CONFIG_M686" = "y" ]; then
    define_int  CONFIG_X86_L1_CACHE_SHIFT 5
@@ -139,6 +145,7 @@
    define_bool CONFIG_X86_ALIGNMENT_16 y
    define_bool CONFIG_X86_HAS_TSC y
    define_bool CONFIG_X86_USE_PPRO_CHECKSUM y
+   bool 'Pentium-Pro CMOV emulation' CONFIG_CPU_EMU686
 fi
 if [ "$CONFIG_MK8" = "y" ]; then
    # for now. may later want to add SSE support and optimized
@@ -162,6 +169,7 @@
    define_bool CONFIG_X86_USE_STRING_486 y
    define_bool CONFIG_X86_ALIGNMENT_16 y
    define_bool CONFIG_X86_F00F_WORKS_OK y
+   bool 'Pentium-Pro CMOV emulation' CONFIG_CPU_EMU686
 fi
 if [ "$CONFIG_MCYRIXIII" = "y" ]; then
    define_int  CONFIG_X86_L1_CACHE_SHIFT 5
@@ -170,6 +178,7 @@
    define_bool CONFIG_X86_USE_3DNOW y
    define_bool CONFIG_X86_USE_PPRO_CHECKSUM y
    define_bool CONFIG_X86_F00F_WORKS_OK y
+   bool 'Pentium-Pro CMOV emulation' CONFIG_CPU_EMU686
 fi
 if [ "$CONFIG_MVIAC3_2" = "y" ]; then
    define_int  CONFIG_X86_L1_CACHE_SHIFT 5
@@ -177,6 +186,7 @@
    define_bool CONFIG_X86_ALIGNMENT_16 y
    define_bool CONFIG_X86_USE_PPRO_CHECKSUM y
    define_bool CONFIG_X86_F00F_WORKS_OK y
+   bool 'Pentium-Pro CMOV emulation' CONFIG_CPU_EMU686
 fi
 if [ "$CONFIG_MCRUSOE" = "y" ]; then
    define_int  CONFIG_X86_L1_CACHE_SHIFT 5
@@ -189,6 +199,7 @@
    define_bool CONFIG_X86_USE_PPRO_CHECKSUM y
    define_bool CONFIG_X86_OOSTORE y
    define_bool CONFIG_X86_F00F_WORKS_OK y
+   bool 'Pentium-Pro CMOV emulation' CONFIG_CPU_EMU686
 fi
 if [ "$CONFIG_MWINCHIP2" = "y" ]; then
    define_int  CONFIG_X86_L1_CACHE_SHIFT 5
@@ -197,6 +208,7 @@
    define_bool CONFIG_X86_USE_PPRO_CHECKSUM y
    define_bool CONFIG_X86_OOSTORE y
    define_bool CONFIG_X86_F00F_WORKS_OK y
+   bool 'Pentium-Pro CMOV emulation' CONFIG_CPU_EMU686
 fi
 if [ "$CONFIG_MWINCHIP3D" = "y" ]; then
    define_int  CONFIG_X86_L1_CACHE_SHIFT 5
@@ -205,6 +217,7 @@
    define_bool CONFIG_X86_USE_PPRO_CHECKSUM y
    define_bool CONFIG_X86_OOSTORE y
    define_bool CONFIG_X86_F00F_WORKS_OK y
+   bool 'Pentium-Pro CMOV emulation' CONFIG_CPU_EMU686
 fi
 
 bool 'Machine Check Exception' CONFIG_X86_MCE
diff -urN linux-2.4.25-wt2-base/arch/i386/kernel/traps.c linux-2.4.25-wt2/arch/i386/kernel/traps.c
--- linux-2.4.25-wt2-base/arch/i386/kernel/traps.c	Thu Mar  4 17:14:45 2004
+++ linux-2.4.25-wt2/arch/i386/kernel/traps.c	Thu Mar  4 17:23:08 2004
@@ -85,6 +85,24 @@
 asmlinkage void spurious_interrupt_bug(void);
 asmlinkage void machine_check(void);
 
+#if defined(CONFIG_CPU_EMU486) || defined(CONFIG_CPU_EMU686)
+asmlinkage void do_general_protection(struct pt_regs * regs, long error_code);
+
+/* gives the address of any register member in a struct pt_regs */
+static const int reg_ofs[8] = {
+	(int)&((struct pt_regs *)0)->eax,
+	(int)&((struct pt_regs *)0)->ecx,
+	(int)&((struct pt_regs *)0)->edx,
+	(int)&((struct pt_regs *)0)->ebx,
+	(int)&((struct pt_regs *)0)->esp,
+	(int)&((struct pt_regs *)0)->ebp,
+	(int)&((struct pt_regs *)0)->esi,
+	(int)&((struct pt_regs *)0)->edi
+};
+
+#define REG_PTR(regs, reg) ((unsigned long *)(((void *)(regs)) + reg_ofs[reg]))
+#endif
+
 int kstack_depth_to_print = 24;
 
 
@@ -404,11 +422,501 @@
 	do_trap(trapnr, signr, str, 1, regs, error_code, &info); \
 }
 
+#if defined(CONFIG_CPU_EMU486) || defined(CONFIG_CPU_EMU686)
+/* This code can be used to allow old 386's to hopefully correctly execute some
+ * code which was originally compiled for a 486, and to allow CMOV-disabled
+ * processors to emulate CMOV instructions. In user space, only 3 instructions
+ * have been added between the 386 the 486 :
+ *    - BSWAP reg		performs exactly htonl())
+ *    - CMPXCHG reg/mem, reg	used for mutex locking
+ *    - XADD reg/mem, reg	not encountered yet.
+ *
+ * Warning: this will NEVER allow a kernel compiled for a 486 to boot on a 386,
+ * neither will it allow a CMOV-optimized kernel to run on a processor without
+ * CMOV ! It will only help to port programs, or save you on a rescue disk, but
+ * for performance's sake, it's far better to recompile.
+ *
+ * Tests patterns have been submitted to this code on a 386, and it now seems
+ * OK. If you think you've found a bug, please report it to
+ * Willy Tarreau <willy@meta-x.org>.
+ */
+
+/* [modrm_address] returns a pointer to a user-space location by decoding the
+ * mod/rm byte and the bytes at <from>, which point to the mod/reg/rm byte.
+ * This must only be called if modrm indicates memory and not register. The
+ * <from> parameter is updated when bytes are read.
+ * NOTE: this code has some ugly lines, which produce a better assembler output
+ * than the "cleaner" version.
+ */
+static void *modrm_address(struct pt_regs *regs, u8 **from,
+                           int bit32, int modrm)
+{
+	u32 offset = 0;
+	u8 sib, mod, rm;
+
+	/* better optimization to compute them here, even
+	 * if rm is not always used
+	 */
+	rm = modrm & 7;
+	mod = modrm & 0xC0;
+
+	if (bit32) {  /* 32-bits addressing mode (default) */
+		if (mod == 0 && rm == 5) /* 32 bits offset and nothing more */
+			return (void *)*((u32*)*from)++;
+		
+		if (rm == 4) {
+			/* SIB byte is present and must be used */
+			sib = *(*from)++; /* SS(7-6) IDX(5-3) BASE(2-0) */
+
+			/* index * scale */
+			if (((sib >> 3) & 7) != 4)
+				offset += *REG_PTR(regs, (sib >> 3) & 7) << (sib >> 6);
+
+			rm = (sib & 7); /* base replaces rm from now */
+			if (mod == 0 && rm == 5) /* base off32 + scaled index */
+				return (void *)offset + *((u32*)*from)++;
+		}
+
+		/* base register */
+		offset += *REG_PTR(regs, rm);
+	
+		if (mod) {
+			if (mod & 0x80) /* 32 bits unsigned offset */
+				offset += *((u32*)*from)++;
+			else  /* 0x40: 8 bits signed offset */
+				offset += *((s8*)*from)++;
+		}
+
+		return (void *)offset;
+
+	} else { /* 16-bits addressing mode */
+		/* handle special case now */
+		if (mod == 0 && rm == 6) /* 16 bits offset */
+			return (void *)(u32)*((u16*)*from)++;
+
+		if ((rm & 4) == 0)
+			offset += (rm & 2) ? regs->ebp : regs->ebx;
+		if (rm < 6)
+			offset += (rm & 1) ? regs->edi : regs->esi;
+		else if (rm == 6)  /* bp */
+			offset += regs->ebp;
+		else if (rm == 7)  /* bx */
+			offset += regs->ebx;
+
+		/* now, let's include 8/16 bits offset */
+		if (mod) {
+			if (mod & 0x80) /* 16 bits unsigned offset */
+				offset += *((u16*)*from)++;
+			else  /* 0x40: 8 bits signed offset */
+				offset += *((s8*)*from)++;
+		}
+		return (void *)(offset & 0xFFFF);
+	}
+}
+
+
+/*
+ * skip_modrm() computes the EIP value of next instruction from the
+ * pointer <from> which points to the first byte after the mod/rm byte.
+ * Its purpose is to implement a fast alternative to modrm_address()
+ * when offset value is not needed.
+ */
+static inline void *skip_modrm(u8 *from, int bit32, int modrm)
+{
+    	u8 mod,rm;
+
+	/* better optimization to compute them here, even
+	 * if rm is not always used
+	 */
+	rm = modrm & 7;
+	mod = modrm & 0xC0;
+
+	/* most common case first : registers */
+	if (mod == 0xC0)
+		return from;
+
+	if (bit32) { /* 32 bits addressing mode (default) */
+		if (rm == 4)	/* SIB byte : rm becomes base */
+			rm = (*from++ & 7);
+		if (mod == 0x00) {
+			if (rm == 5)  /* 32 bits offset and nothing more */
+				return from + 4;
+			else
+				return from;
+		}
+	}
+	else { /* 16 bits mode */
+		if (mod == 0x00) {
+			if (rm == 6)  /* 16 bits offset and nothing more */
+				return from + 2;
+			else
+				return from;
+		}
+	}
+
+	if (mod & 0x80)
+		return from + (2 * (bit32 + 1)); /* + 2 or 4 bytes */
+	else
+		return from + 1;
+}
+
+
+/* [reg_address] returns a pointer to a register in the regs struct, depending
+ * on <w> (byte/word) and reg. Since the caller knows about <w>, it's
+ * responsible for understanding the result as a byte, word or dword pointer.
+ * Only the 3 lower bits of <reg> are meaningful, higher ones are ignored.
+ */
+static inline void *reg_address(struct pt_regs *regs, char w, u8 reg)
+{
+	if (w)
+		/* 16/32 bits mode */
+		return REG_PTR(regs, reg & 7);
+	else
+		/* 8 bits mode : al,cl,dl,bl,ah,ch,dh,bh */
+		return ((reg & 4) >> 2) + (u8*)REG_PTR(regs, reg & 3);
+
+	/* this is set just to prevent the compiler from complaining */
+	return NULL;
+}
+
+/* [do_invalid_op] is called by exception 6 after an invalid opcode has been
+ * encountered. It will decode the prefixes and the instruction code, to try
+ * to emulate it, and will send a SIGILL or SIGSEGV to the process if not
+ * possible.
+ * REP/REPN prefixes are not supported anymore because it didn't make sense
+ * to emulate instructions prefixed with such opcodes since no arch-specific
+ * instruction start by one of them. At most, they will be the start of newer
+ * arch-specific instructions (SSE ?).
+ */
+asmlinkage void do_invalid_op(struct pt_regs * regs, long error_code)
+{
+	enum {
+		PREFIX_ES   = 1,
+		PREFIX_CS   = 2,
+		PREFIX_SS   = 4,
+		PREFIX_DS   = 8,
+		PREFIX_FS   = 16,
+		PREFIX_GS   = 32,
+		PREFIX_SEG  = 63,  /* any seg */
+		PREFIX_D32  = 64,
+		PREFIX_A32  = 128,
+		PREFIX_LOCK = 256,
+	} prefixes = 0;
+
+	u32 *src, *dst;
+	u8 *eip = (u8*)regs->eip;
+
+#ifdef BENCH_CPU_EXCEPTION_BUT_NOT_THE_CODE
+	regs->eip += 3;
+	return;
+#endif
+	/* we'll first read all known opcode prefixes, and discard obviously
+	   invalid combinations.*/
+	while (1) {
+		/* prefix for CMOV, BSWAP, CMPXCHG, XADD */
+		if (*eip == 0x0F) {
+			eip++;
+#if defined(CONFIG_CPU_EMU686)
+			/* here, we'll emulate the CMOV* instructions, which gcc
+			 * blindly generates when specifying -march=i686, even
+			 * though the processor flags must be checked against
+			 * support for these instructions.
+			 */
+			if ((*eip & 0xF0) == 0x40) {  /* CMOV* */
+				u8 cond, ncond, reg, modrm;
+				u32 flags;
+				
+				/* to optimize processing, we'll associate a flag mask to each opcode.
+				 * If the EFLAGS value ANDed with this mask is not null, then the cond
+				 * is met. One exception is CMOVL which is true if SF != OF. For this
+				 * purpose, we'll make a fake flag 'SFOF' (unused bit 3) which equals
+				 * SF^OF, so that CMOVL is true if SFOF != 0.
+				 */
+				static u16 cmov_flags[8] = {
+					0x0800, /* CMOVO	=> OF */
+					0x0001, /* CMOVB	=> CF */
+					0x0040, /* CMOVE	=> ZF */
+					0x0041, /* CMOVBE	=> CF | ZF */
+					0x0080, /* CMOVS	=> SF */
+					0x0004, /* CMOVP	=> PF */
+					0x0008, /* CMOVL	=> SF^OF */
+					0x0048, /* CMOVLE	=> SF^OF | ZF */
+				};
+
+				flags =	regs->eflags & 0x08C5; /* OF, SF, ZF, PF, CF */
+				
+				/* SFOF (flags_3) <= OF(flags_11) ^ SF(flags_7) */
+				flags |= ((flags ^ (flags >> 4)) >> 4) & 0x8;
+
+				cond  = *eip & 0x0F;
+				ncond = cond & 1;	/* condition is negated */
+				cond >>= 1;
+				ncond ^= !!(flags & cmov_flags[cond]);
+				/* ncond is now true if the cond matches the opcode */
+				
+				modrm = *(eip + 1);
+				eip += 2; /* skips all the opcodes */
+				
+				if (!ncond) {
+					/* condition is not valid, skip the instruction and do nothing */
+					regs->eip = (u32)skip_modrm(eip, !(prefixes & PREFIX_A32), modrm);
+					return;
+				}
+
+				/* condition is valid, we'll have to do the work */
+
+				reg = (modrm >> 3) & 7;
+				dst = reg_address(regs, 1, reg);
+				if ((modrm & 0xC0) == 0xC0) { /* register to register */
+					src = reg_address(regs, 1, modrm);
+				}
+				else {
+					src = modrm_address(regs, &eip, !(prefixes & PREFIX_A32), modrm);
+					/* we must verify that src is valid for this task */
+					if ((prefixes & (PREFIX_FS | PREFIX_GS)) ||
+					    verify_area(VERIFY_WRITE, (void *)src, ((prefixes & PREFIX_D32) ? 2 : 4))) {
+						do_general_protection(regs, error_code);
+						return;
+					}
+				}
+				
+				if (!(prefixes & PREFIX_D32)) /* 32 bits operands */
+					*(u32*)dst = *(u32*)src;
+				else
+					*(u16*)dst = *(u16*)src;
+				
+				regs->eip = (u32)eip;
+				return;
+			} /* if CMOV */
+#endif /* CONFIG_CPU_EMU686 */
+
+#if defined(CONFIG_CPU_EMU486)
+			/* we'll verify if this is a BSWAP opcode, main source of SIGILL on 386's */
+			if ((*eip & 0xF8) == 0xC8) {  /* BSWAP */
+				u8 w, reg, modrm;
+				
+				reg = *eip++ & 0x07;
+				src = reg_address(regs, 1, reg);
+				
+				__asm__ __volatile__ (
+						      "xchgb %%al, %%ah\n\t"
+						      "roll $16, %%eax\n\t"
+						      "xchgb %%al, %%ah\n\t"
+						      : "=a" (*(u32*)src)
+						      : "a" (*(u32*)src));
+				regs->eip = (u32)eip;
+				return;
+			}
+
+
+			/* we'll also try to emulate the CMPXCHG instruction (used in mutex locks).
+			   This instruction is often locked, but it's not possible to put a lock
+			   here. Anyway, I don't believe that there are lots of multiprocessors
+			   386 out there ...
+			*/
+			if ((*eip & 0xFE) == 0xB0) {  /* CMPXCHG */
+				u8 w, reg, modrm;
+
+				w = *eip & 1;
+				modrm = *(eip + 1);
+				eip += 2; /* skips all the opcodes */
+
+				reg = (modrm >> 3) & 7;
+				
+				dst = reg_address(regs, w, reg);
+				if ((modrm & 0xC0) == 0xC0) /* register to register */
+					src = reg_address(regs, w, modrm);
+				else {
+					src = modrm_address(regs, &eip, !(prefixes & PREFIX_A32), modrm);
+					/* we must verify that src is valid for this task */
+					if ((prefixes & (PREFIX_FS | PREFIX_GS)) ||
+					    verify_area(VERIFY_WRITE, (void *)src, (w?((prefixes & PREFIX_D32)?2:4):1))) {
+						do_general_protection(regs, error_code);
+					    return;
+					}
+				}
+				
+				if (!w) { /* 8 bits operands */
+					if ((u8)regs->eax == *(u8*)src) {
+						*(u8*)src = *(u8*)dst;
+						regs->eflags |= X86_EFLAGS_ZF;  /* set Zero Flag */
+					}
+					else {
+						*(u8*)&(regs->eax) = *(u8*)src;
+						regs->eflags &= ~X86_EFLAGS_ZF;  /* clear Zero Flag */
+					}
+				}
+				else if (!(prefixes & PREFIX_D32)) { /* 32 bits operands */
+					if ((u32)regs->eax == *(u32*)src) {
+						*(u32*)src = *(u32*)dst;
+						regs->eflags |= X86_EFLAGS_ZF;  /* set Zero Flag */
+					}
+					else {
+						regs->eax = *(u32*)src;
+						regs->eflags &= ~X86_EFLAGS_ZF;  /* clear Zero Flag */
+					}
+				}
+				else { /* 16 bits operands */
+					if ((u16)regs->eax == *(u16*)src) {
+						*(u16*)src = *(u16*)dst;
+						regs->eflags |= X86_EFLAGS_ZF;  /* set Zero Flag */
+					}
+					else {
+						*(u16*)&regs->eax = *(u16*)src;
+						regs->eflags &= ~X86_EFLAGS_ZF;  /* clear Zero Flag */
+					}
+				}
+				regs->eip = (u32)eip;
+				return;
+			}
+
+			/* we'll also try to emulate the XADD instruction (not very common) */
+			if ((*eip & 0xFE) == 0xC0) {  /* XADD */
+				u8 w, reg, modrm;
+				u32 op1, op2;
+
+				w = *eip & 1;
+				modrm = *(eip + 1);
+				eip += 2; /* skips all the opcodes */
+
+				reg = (modrm >> 3) & 7;
+				
+				dst = reg_address(regs, w, reg);
+				if ((modrm & 0xC0) == 0xC0) /* register to register */
+					src = reg_address(regs, w, modrm);
+				else {
+					src = modrm_address(regs, &eip, !(prefixes & PREFIX_A32), modrm);
+					/* we must verify that src is valid for this task */
+					if ((prefixes & (PREFIX_FS | PREFIX_GS)) ||
+					    verify_area(VERIFY_WRITE, (void *)src, (w?((prefixes & PREFIX_D32)?2:4):1))) {
+						do_general_protection(regs, error_code);
+						return;
+					}
+				}
+				
+				if (!w) { /* 8 bits operands */
+					op1 = *(u8*)src;
+					op2 = *(u8*)dst;
+					*(u8*)src = op1 + op2;
+					*(u8*)dst = op1;
+				}
+				else if (!(prefixes & PREFIX_D32)) { /* 32 bits operands */
+					op1 = *(u32*)src;
+					op2 = *(u32*)dst;
+					*(u32*)src = op1 + op2;
+					*(u32*)dst = op1;
+				}
+				else { /* 16 bits operands */
+					op1 = *(u16*)src;
+					op2 = *(u16*)dst;
+					*(u16*)src = op1 + op2;
+					*(u16*)dst = op1;
+				}
+				regs->eip = (u32)eip;
+				return;
+			}
+
+#endif /* CONFIG_CPU_EMU486 */
+
+		} /* if (*eip == 0x0F) */
+		else if ((*eip & 0xfc) == 0x64) {
+			switch (*eip) {
+			case 0x66: /* Operand switches 16/32 bits */
+				if (prefixes & PREFIX_D32)
+					goto invalid_opcode;
+				prefixes |= PREFIX_D32;
+				eip++;
+				continue;
+			case 0x67: /* Address switches 16/32 bits */
+				if (prefixes & PREFIX_A32)
+					goto invalid_opcode;
+				prefixes |= PREFIX_A32;
+				eip++;
+				continue;
+			case 0x64: /* FS: */
+				if (prefixes & PREFIX_SEG)
+					goto invalid_opcode;
+				prefixes |= PREFIX_FS;
+				eip++;
+				continue;
+			case 0x65: /* GS: */
+				if (prefixes & PREFIX_SEG)
+					goto invalid_opcode;
+				prefixes |= PREFIX_GS;
+				eip++;
+				continue;
+			}
+		}
+		else if (*eip == 0xf0) { /* lock */
+			if (prefixes & PREFIX_LOCK)
+				goto invalid_opcode;
+			prefixes |= PREFIX_LOCK;
+#ifdef CONFIG_SMP
+				/* if we're in SMP mode, a missing lock can lead to problems in
+				 * multi-threaded environment. We must send a warning. In UP,
+				 * however, this should have no effect.
+				 */
+				printk(KERN_WARNING "Warning ! LOCK prefix found at EIP=0x%08x in"
+				       "process %d(%s), has no effect before a software-emulated"
+				       "instruction\n", regs->eip, current->pid, current->comm);
+#endif
+				eip++;
+				continue;
+		}
+		else if ((*eip & 0xe7) == 0x26) {
+			switch (*eip) {
+			case 0x26: /* ES: */
+				if (prefixes & PREFIX_SEG)
+					goto invalid_opcode;
+				prefixes |= PREFIX_ES;
+				eip++;
+				continue;
+			case 0x2E: /* CS: */
+				if (prefixes & PREFIX_SEG)
+					goto invalid_opcode;
+				prefixes |= PREFIX_CS;
+				eip++;
+				continue;
+			case 0x36: /* SS: */
+				if (prefixes & PREFIX_SEG)
+					goto invalid_opcode;
+				prefixes |= PREFIX_SS;
+				eip++;
+				continue;
+			case 0x3E: /* DS: */
+				if (prefixes & PREFIX_SEG)
+					goto invalid_opcode;
+				prefixes |= PREFIX_DS;
+				eip++;
+				continue;
+			}
+		}
+		/* if this opcode has not been processed, it's not a prefix. */
+		break;
+	}
+
+	/* it's a case we can't handle. Unknown opcode or too many prefixes. */
+invalid_opcode:
+#ifdef CONFIG_CPU_EMU486_DEBUG
+	printk(KERN_DEBUG "do_invalid_op() : invalid opcode detected @%p : %02x %02x ...\n", eip, eip[0], eip[1]);
+#endif
+	current->thread.error_code = error_code;
+	current->thread.trap_no = 6;
+	force_sig(SIGILL, current);
+	die_if_kernel("invalid operand",regs,error_code);
+}
+
+#endif  /* CONFIG_CPU_EMU486 || CONFIG_CPU_EMU686 */
+
 DO_VM86_ERROR_INFO( 0, SIGFPE,  "divide error", divide_error, FPE_INTDIV, regs->eip)
 DO_VM86_ERROR( 3, SIGTRAP, "int3", int3)
 DO_VM86_ERROR( 4, SIGSEGV, "overflow", overflow)
 DO_VM86_ERROR( 5, SIGSEGV, "bounds", bounds)
+
+#if !defined(CONFIG_CPU_EMU486) && !defined(CONFIG_CPU_EMU686)
 DO_ERROR_INFO( 6, SIGILL,  "invalid operand", invalid_op, ILL_ILLOPN, regs->eip)
+#endif
+
 DO_VM86_ERROR( 7, SIGSEGV, "device not available", device_not_available)
 DO_ERROR( 8, SIGSEGV, "double fault", double_fault)
 DO_ERROR( 9, SIGFPE,  "coprocessor segment overrun", coprocessor_segment_overrun)

---

