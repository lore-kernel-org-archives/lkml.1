Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbXGXGGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbXGXGGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 02:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbXGXGGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 02:06:42 -0400
Received: from ozlabs.org ([203.10.76.45]:33552 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbXGXGGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 02:06:41 -0400
Subject: Re: [PATCH] [2/11] x86: Fix alternatives and kprobes to remap
	write-protected kernel text
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@suse.de>
Cc: jbeulich@novell.com, jeremy@goop.org, compudj@krystal.dyndns.org,
       zach@vmware.com, patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070720153246.6597614E79@wotan.suse.de>
References: <20070720532.949522000@suse.de>
	 <20070720153246.6597614E79@wotan.suse.de>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 16:06:08 +1000
Message-Id: <1185257169.1803.213.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-20 at 17:32 +0200, Andi Kleen wrote:
> Reenable kprobes and alternative patching when the kernel text is write
> protected by DEBUG_RODATA
> Add a general utility function to change write protected text.
> The new function remaps the code using vmap to write it and takes
> care of CPU synchronization. It also does CLFLUSH to make icache recovery
> faster. 
> 
> There are some limitations on when the function can be used, see
> the comment.
> 
> This is a newer version that also changes the paravirt_ops code.
> text_poke also supports multi byte patching now.

Hmm, I wrote this code originally, and would have liked to catch this
change before it went in.

It's broken on i386 w/ paravirt_ops.

Problem: lookup_address() contains paravirt_ops.  So we call
paravirt_ops.patch which patches part of the instructions, then calls
nop_out to patch the end of the instructions.  This calls text_poke
which calls lookup_address, which is what we've half-patched.  Mainly,
we get lucky at the moment (I just hit this in lguest).

We could use a simpler nop_out at boot, or fix this a little more
robustly by making everyone do their patching via a single call to
text_poke.

Needs testing for VMI and Xen (lguest and native booted here):
===
Make patching more robust, fix paravirt issue

Commit 19d36ccdc34f5ed444f8a6af0cbfdb6790eb1177 "x86: Fix alternatives
and kprobes to remap write-protected kernel text" uses code which is
being patched for patching.

In particular, paravirt_ops does patching in two stages: first it
calls paravirt_ops.patch, then it fills any remaining instructions
with nop_out().  nop_out calls text_poke() which calls
lookup_address() which calls pgd_val() (aka paravirt_ops.pgd_val):
that call site is one of the places we patch.

If we always do patching as one single call to text_poke(), we only
need make sure we're not patching the memcpy in text_poke itself.
This means the prototype to paravirt_ops.patch needs to change, to
marshal the new code into a buffer rather than patching in place as it
does now.  It also means all patching goes through text_poke(), which
is known to be safe (apply_alternatives is also changed to make a
single patch).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r b81206bbf749 arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c	Tue Jul 24 13:05:36 2007 +1000
+++ b/arch/i386/kernel/alternative.c	Tue Jul 24 14:50:54 2007 +1000
@@ -10,6 +10,8 @@
 #include <asm/pgtable.h>
 #include <asm/mce.h>
 #include <asm/nmi.h>
+
+#define MAX_PATCH_LEN 128
 
 #ifdef CONFIG_HOTPLUG_CPU
 static int smp_alt_once;
@@ -148,7 +150,8 @@ static unsigned char** find_nop_table(vo
 
 #endif /* CONFIG_X86_64 */
 
-static void nop_out(void *insns, unsigned int len)
+/* Use this to add nops to a buffer, then text_poke the whole buffer. */
+static void add_nops(void *insns, unsigned int len)
 {
 	unsigned char **noptable = find_nop_table();
 
@@ -156,7 +159,7 @@ static void nop_out(void *insns, unsigne
 		unsigned int noplen = len;
 		if (noplen > ASM_NOP_MAX)
 			noplen = ASM_NOP_MAX;
-		text_poke(insns, noptable[noplen], noplen);
+		memcpy(insns, noptable[noplen], noplen);
 		insns += noplen;
 		len -= noplen;
 	}
@@ -174,15 +177,14 @@ void apply_alternatives(struct alt_instr
 void apply_alternatives(struct alt_instr *start, struct alt_instr *end)
 {
 	struct alt_instr *a;
-	u8 *instr;
-	int diff;
+	char insnbuf[MAX_PATCH_LEN];
 
 	DPRINTK("%s: alt table %p -> %p\n", __FUNCTION__, start, end);
 	for (a = start; a < end; a++) {
 		BUG_ON(a->replacementlen > a->instrlen);
+		BUG_ON(a->instrlen > sizeof(insnbuf));
 		if (!boot_cpu_has(a->cpuid))
 			continue;
-		instr = a->instr;
 #ifdef CONFIG_X86_64
 		/* vsyscall code is not mapped yet. resolve it manually. */
 		if (instr >= (u8 *)VSYSCALL_START && instr < (u8*)VSYSCALL_END) {
@@ -191,9 +193,10 @@ void apply_alternatives(struct alt_instr
 				__FUNCTION__, a->instr, instr);
 		}
 #endif
-		memcpy(instr, a->replacement, a->replacementlen);
-		diff = a->instrlen - a->replacementlen;
-		nop_out(instr + a->replacementlen, diff);
+		memcpy(insnbuf, a->replacement, a->replacementlen);
+		add_nops(insnbuf + a->replacementlen,
+			 a->instrlen - a->replacementlen);
+		text_poke(a->instr, insnbuf, a->instrlen);
 	}
 }
 
@@ -215,16 +218,18 @@ static void alternatives_smp_unlock(u8 *
 static void alternatives_smp_unlock(u8 **start, u8 **end, u8 *text, u8 *text_end)
 {
 	u8 **ptr;
+	char insn[1];
 
 	if (noreplace_smp)
 		return;
 
+	add_nops(insn, 1);
 	for (ptr = start; ptr < end; ptr++) {
 		if (*ptr < text)
 			continue;
 		if (*ptr > text_end)
 			continue;
-		nop_out(*ptr, 1);
+		text_poke(*ptr, insn, 1);
 	};
 }
 
@@ -351,6 +356,7 @@ void apply_paravirt(struct paravirt_patc
 		    struct paravirt_patch_site *end)
 {
 	struct paravirt_patch_site *p;
+	char insnbuf[MAX_PATCH_LEN];
 
 	if (noreplace_paravirt)
 		return;
@@ -358,13 +364,15 @@ void apply_paravirt(struct paravirt_patc
 	for (p = start; p < end; p++) {
 		unsigned int used;
 
-		used = paravirt_ops.patch(p->instrtype, p->clobbers, p->instr,
-					  p->len);
+		BUG_ON(p->len > MAX_PATCH_LEN);
+		used = paravirt_ops.patch(p->instrtype, p->clobbers, insnbuf,
+					  (unsigned long)p->instr, p->len);
 
 		BUG_ON(used > p->len);
 
 		/* Pad the rest with nops */
-		nop_out(p->instr + used, p->len - used);
+		add_nops(insnbuf + used, p->len - used);
+		text_poke(p->instr, insnbuf, p->len);
 	}
 }
 extern struct paravirt_patch_site __start_parainstructions[],
diff -r b81206bbf749 arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c	Tue Jul 24 13:05:36 2007 +1000
+++ b/arch/i386/kernel/paravirt.c	Tue Jul 24 15:13:32 2007 +1000
@@ -69,7 +69,8 @@ DEF_NATIVE(read_tsc, "rdtsc");
 
 DEF_NATIVE(ud2a, "ud2a");
 
-static unsigned native_patch(u8 type, u16 clobbers, void *insns, unsigned len)
+static unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
+			     unsigned long addr, unsigned len)
 {
 	const unsigned char *start, *end;
 	unsigned ret;
@@ -90,7 +91,7 @@ static unsigned native_patch(u8 type, u1
 #undef SITE
 
 	patch_site:
-		ret = paravirt_patch_insns(insns, len, start, end);
+		ret = paravirt_patch_insns(ibuf, len, start, end);
 		break;
 
 	case PARAVIRT_PATCH(make_pgd):
@@ -107,7 +108,7 @@ static unsigned native_patch(u8 type, u1
 		break;
 
 	default:
-		ret = paravirt_patch_default(type, clobbers, insns, len);
+		ret = paravirt_patch_default(type, clobbers, ibuf, addr, len);
 		break;
 	}
 
@@ -129,68 +130,67 @@ struct branch {
 	u32 delta;
 } __attribute__((packed));
 
-unsigned paravirt_patch_call(void *target, u16 tgt_clobbers,
-			     void *site, u16 site_clobbers,
+unsigned paravirt_patch_call(void *insnbuf,
+			     const void *target, u16 tgt_clobbers,
+			     unsigned long addr, u16 site_clobbers,
 			     unsigned len)
 {
-	unsigned char *call = site;
-	unsigned long delta = (unsigned long)target - (unsigned long)(call+5);
-	struct branch b;
+	struct branch *b = insnbuf;
+	unsigned long delta = (unsigned long)target - (addr+5);
 
 	if (tgt_clobbers & ~site_clobbers)
 		return len;	/* target would clobber too much for this site */
 	if (len < 5)
 		return len;	/* call too long for patch site */
 
-	b.opcode = 0xe8; /* call */
-	b.delta = delta;
-	BUILD_BUG_ON(sizeof(b) != 5);
-	text_poke(call, (unsigned char *)&b, 5);
+	b->opcode = 0xe8; /* call */
+	b->delta = delta;
+	BUILD_BUG_ON(sizeof(*b) != 5);
 
 	return 5;
 }
 
-unsigned paravirt_patch_jmp(void *target, void *site, unsigned len)
-{
-	unsigned char *jmp = site;
-	unsigned long delta = (unsigned long)target - (unsigned long)(jmp+5);
-	struct branch b;
+unsigned paravirt_patch_jmp(const void *target, void *insnbuf,
+			    unsigned long addr, unsigned len)
+{
+	struct branch *b = insnbuf;
+	unsigned long delta = (unsigned long)target - (addr+5);
 
 	if (len < 5)
 		return len;	/* call too long for patch site */
 
-	b.opcode = 0xe9;	/* jmp */
-	b.delta = delta;
-	text_poke(jmp, (unsigned char *)&b, 5);
+	b->opcode = 0xe9;	/* jmp */
+	b->delta = delta;
 
 	return 5;
 }
 
-unsigned paravirt_patch_default(u8 type, u16 clobbers, void *site, unsigned len)
+unsigned paravirt_patch_default(u8 type, u16 clobbers, void *insnbuf,
+				unsigned long addr, unsigned len)
 {
 	void *opfunc = *((void **)&paravirt_ops + type);
 	unsigned ret;
 
 	if (opfunc == NULL)
 		/* If there's no function, patch it with a ud2a (BUG) */
-		ret = paravirt_patch_insns(site, len, start_ud2a, end_ud2a);
+		ret = paravirt_patch_insns(insnbuf, len, start_ud2a, end_ud2a);
 	else if (opfunc == paravirt_nop)
 		/* If the operation is a nop, then nop the callsite */
 		ret = paravirt_patch_nop();
 	else if (type == PARAVIRT_PATCH(iret) ||
 		 type == PARAVIRT_PATCH(irq_enable_sysexit))
 		/* If operation requires a jmp, then jmp */
-		ret = paravirt_patch_jmp(opfunc, site, len);
+		ret = paravirt_patch_jmp(opfunc, insnbuf, addr, len);
 	else
 		/* Otherwise call the function; assume target could
 		   clobber any caller-save reg */
-		ret = paravirt_patch_call(opfunc, CLBR_ANY,
-					  site, clobbers, len);
+		ret = paravirt_patch_call(insnbuf, opfunc, CLBR_ANY,
+					  addr, clobbers, len);
 
 	return ret;
 }
 
-unsigned paravirt_patch_insns(void *site, unsigned len,
+unsigned paravirt_patch_insns(void *insnbuf, unsigned len,
 			      const char *start, const char *end)
 {
 	unsigned insn_len = end - start;
@@ -198,7 +198,7 @@ unsigned paravirt_patch_insns(void *site
 	if (insn_len > len || start == NULL)
 		insn_len = len;
 	else
-		memcpy(site, start, insn_len);
+		memcpy(insnbuf, start, insn_len);
 
 	return insn_len;
 }
diff -r b81206bbf749 arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c	Tue Jul 24 13:05:36 2007 +1000
+++ b/arch/i386/kernel/vmi.c	Tue Jul 24 15:12:42 2007 +1000
@@ -87,12 +87,14 @@ struct vmi_timer_ops vmi_timer_ops;
 #define IRQ_PATCH_INT_MASK 0
 #define IRQ_PATCH_DISABLE  5
 
-static inline void patch_offset(unsigned char *eip, unsigned char *dest)
-{
-        *(unsigned long *)(eip+1) = dest-eip-5;
-}
-
-static unsigned patch_internal(int call, unsigned len, void *insns)
+static inline void patch_offset(void *insnbuf,
+				unsigned long eip, unsigned long dest)
+{
+        *(unsigned long *)(insnbuf+1) = dest-eip-5;
+}
+
+static unsigned patch_internal(int call, unsigned len, void *insnbuf,
+			       unsigned long eip)
 {
 	u64 reloc;
 	struct vmi_relocation_info *const rel = (struct vmi_relocation_info *)&reloc;
@@ -100,14 +102,14 @@ static unsigned patch_internal(int call,
 	switch(rel->type) {
 		case VMI_RELOCATION_CALL_REL:
 			BUG_ON(len < 5);
-			*(char *)insns = MNEM_CALL;
-			patch_offset(insns, rel->eip);
+			*(char *)insnbuf = MNEM_CALL;
+			patch_offset(insnbuf, eip, (unsigned long)rel->eip);
 			return 5;
 
 		case VMI_RELOCATION_JUMP_REL:
 			BUG_ON(len < 5);
-			*(char *)insns = MNEM_JMP;
-			patch_offset(insns, rel->eip);
+			*(char *)insnbuf = MNEM_JMP;
+			patch_offset(insnbuf, eip, (unsigned long)rel->eip);
 			return 5;
 
 		case VMI_RELOCATION_NOP:
@@ -128,21 +130,26 @@ static unsigned patch_internal(int call,
  * Apply patch if appropriate, return length of new instruction
  * sequence.  The callee does nop padding for us.
  */
-static unsigned vmi_patch(u8 type, u16 clobbers, void *insns, unsigned len)
+static unsigned vmi_patch(u8 type, u16 clobbers, void *insns,
+			  unsigned long eip, unsigned len)
 {
 	switch (type) {
 		case PARAVIRT_PATCH(irq_disable):
-			return patch_internal(VMI_CALL_DisableInterrupts, len, insns);
+			return patch_internal(VMI_CALL_DisableInterrupts, len,
+					      insns, eip);
 		case PARAVIRT_PATCH(irq_enable):
-			return patch_internal(VMI_CALL_EnableInterrupts, len, insns);
+			return patch_internal(VMI_CALL_EnableInterrupts, len,
+					      insns, eip);
 		case PARAVIRT_PATCH(restore_fl):
-			return patch_internal(VMI_CALL_SetInterruptMask, len, insns);
+			return patch_internal(VMI_CALL_SetInterruptMask, len,
+					      insns, eip);
 		case PARAVIRT_PATCH(save_fl):
-			return patch_internal(VMI_CALL_GetInterruptMask, len, insns);
+			return patch_internal(VMI_CALL_GetInterruptMask, len,
+					      insns, eip);
 		case PARAVIRT_PATCH(iret):
-			return patch_internal(VMI_CALL_IRET, len, insns);
+			return patch_internal(VMI_CALL_IRET, len, insns, eip);
 		case PARAVIRT_PATCH(irq_enable_sysexit):
-			return patch_internal(VMI_CALL_SYSEXIT, len, insns);
+			return patch_internal(VMI_CALL_SYSEXIT, len, insns, eip);
 		default:
 			break;
 	}
diff -r b81206bbf749 arch/i386/xen/enlighten.c
--- a/arch/i386/xen/enlighten.c	Tue Jul 24 13:05:36 2007 +1000
+++ b/arch/i386/xen/enlighten.c	Tue Jul 24 15:10:37 2007 +1000
@@ -842,7 +842,8 @@ void __init xen_setup_vcpu_info_placemen
 	}
 }
 
-static unsigned xen_patch(u8 type, u16 clobbers, void *insns, unsigned len)
+static unsigned xen_patch(u8 type, u16 clobbers, void *insnbuf,
+			  unsigned long addr, unsigned len)
 {
 	char *start, *end, *reloc;
 	unsigned ret;
@@ -869,7 +870,7 @@ static unsigned xen_patch(u8 type, u16 c
 		if (start == NULL || (end-start) > len)
 			goto default_patch;
 
-		ret = paravirt_patch_insns(insns, len, start, end);
+		ret = paravirt_patch_insns(insnbuf, len, start, end);
 
 		/* Note: because reloc is assigned from something that
 		   appears to be an array, gcc assumes it's non-null,
@@ -877,8 +878,8 @@ static unsigned xen_patch(u8 type, u16 c
 		   end. */
 		if (reloc > start && reloc < end) {
 			int reloc_off = reloc - start;
-			long *relocp = (long *)(insns + reloc_off);
-			long delta = start - (char *)insns;
+			long *relocp = (long *)(insnbuf + reloc_off);
+			long delta = start - (char *)addr;
 
 			*relocp += delta;
 		}
@@ -886,7 +887,8 @@ static unsigned xen_patch(u8 type, u16 c
 
 	default_patch:
 	default:
-		ret = paravirt_patch_default(type, clobbers, insns, len);
+		ret = paravirt_patch_default(type, clobbers, insnbuf,
+					     addr, len);
 		break;
 	}
 
diff -r b81206bbf749 drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c	Tue Jul 24 13:05:36 2007 +1000
+++ b/drivers/lguest/lguest.c	Tue Jul 24 15:08:20 2007 +1000
@@ -521,21 +521,22 @@ static const struct lguest_insns
 	[PARAVIRT_PATCH(restore_fl)] = { lgstart_popf, lgend_popf },
 	[PARAVIRT_PATCH(save_fl)] = { lgstart_pushf, lgend_pushf },
 };
-static unsigned lguest_patch(u8 type, u16 clobber, void *insns, unsigned len)
+static unsigned lguest_patch(u8 type, u16 clobber, void *ibuf,
+			     unsigned long addr, unsigned len)
 {
 	unsigned int insn_len;
 
 	/* Don't touch it if we don't have a replacement */
 	if (type >= ARRAY_SIZE(lguest_insns) || !lguest_insns[type].start)
-		return paravirt_patch_default(type, clobber, insns, len);
+		return paravirt_patch_default(type, clobber, ibuf, addr, len);
 
 	insn_len = lguest_insns[type].end - lguest_insns[type].start;
 
 	/* Similarly if we can't fit replacement. */
 	if (len < insn_len)
-		return paravirt_patch_default(type, clobber, insns, len);
-
-	memcpy(insns, lguest_insns[type].start, insn_len);
+		return paravirt_patch_default(type, clobber, ibuf, addr, len);
+
+	memcpy(ibuf, lguest_insns[type].start, insn_len);
 	return insn_len;
 }
 
diff -r b81206bbf749 include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Tue Jul 24 13:05:36 2007 +1000
+++ b/include/asm-i386/paravirt.h	Tue Jul 24 14:57:44 2007 +1000
@@ -47,7 +47,8 @@ struct paravirt_ops
 	 * The patch function should return the number of bytes of code
 	 * generated, as we nop pad the rest in generic code.
 	 */
-	unsigned (*patch)(u8 type, u16 clobber, void *firstinsn, unsigned len);
+	unsigned (*patch)(u8 type, u16 clobber, void *insnbuf,
+			  unsigned long addr, unsigned len);
 
 	/* Basic arch-specific setup */
 	void (*arch_setup)(void);
@@ -253,13 +254,16 @@ extern struct paravirt_ops paravirt_ops;
 
 unsigned paravirt_patch_nop(void);
 unsigned paravirt_patch_ignore(unsigned len);
-unsigned paravirt_patch_call(void *target, u16 tgt_clobbers,
-			     void *site, u16 site_clobbers,
+unsigned paravirt_patch_call(void *insnbuf,
+			     const void *target, u16 tgt_clobbers,
+			     unsigned long addr, u16 site_clobbers,
 			     unsigned len);
-unsigned paravirt_patch_jmp(void *target, void *site, unsigned len);
-unsigned paravirt_patch_default(u8 type, u16 clobbers, void *site, unsigned len);
-
-unsigned paravirt_patch_insns(void *site, unsigned len,
+unsigned paravirt_patch_jmp(const void *target, void *insnbuf,
+			    unsigned long addr, unsigned len);
+unsigned paravirt_patch_default(u8 type, u16 clobbers, void *insnbuf,
+				unsigned long addr, unsigned len);
+
+unsigned paravirt_patch_insns(void *insnbuf, unsigned len,
 			      const char *start, const char *end);
 
 int paravirt_disable_iospace(void);



