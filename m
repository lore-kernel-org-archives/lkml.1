Return-Path: <linux-kernel-owner+w=401wt.eu-S939888AbXHIMo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939888AbXHIMo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939646AbXHIMlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:41:36 -0400
Received: from ns2.suse.de ([195.135.220.15]:34961 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939625AbXHIMle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:41:34 -0400
From: Andi Kleen <ak@suse.de>
References: <20070809241.425881000@suse.de>
In-Reply-To: <20070809241.425881000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [5/12] x86_64: Make patching more robust, fix paravirt issue
Message-Id: <20070809124132.C794A14F3B@wotan.suse.de>
Date: Thu,  9 Aug 2007 14:41:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


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

AK: fix compilation on x86-64 (bad rusty!)
AK: fix boot on x86-64 (sigh)
AK: merged with other patches

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/alternative.c |   33 ++++++++++++++++----------
 arch/i386/kernel/paravirt.c    |   52 ++++++++++++++++++++---------------------
 arch/i386/kernel/vmi.c         |   35 ++++++++++++++++-----------
 arch/i386/xen/enlighten.c      |   12 +++++----
 drivers/lguest/lguest.c        |    9 +++----
 include/asm-i386/paravirt.h    |   16 +++++++-----
 6 files changed, 90 insertions(+), 67 deletions(-)

Index: linux/arch/i386/kernel/alternative.c
===================================================================
--- linux.orig/arch/i386/kernel/alternative.c
+++ linux/arch/i386/kernel/alternative.c
@@ -11,6 +11,8 @@
 #include <asm/mce.h>
 #include <asm/nmi.h>
 
+#define MAX_PATCH_LEN (255-1)
+
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
@@ -174,15 +177,15 @@ extern u8 *__smp_locks[], *__smp_locks_e
 void apply_alternatives(struct alt_instr *start, struct alt_instr *end)
 {
 	struct alt_instr *a;
-	u8 *instr;
-	int diff;
+	char insnbuf[MAX_PATCH_LEN];
 
 	DPRINTK("%s: alt table %p -> %p\n", __FUNCTION__, start, end);
 	for (a = start; a < end; a++) {
+		u8 *instr = a->instr;
 		BUG_ON(a->replacementlen > a->instrlen);
+		BUG_ON(a->instrlen > sizeof(insnbuf));
 		if (!boot_cpu_has(a->cpuid))
 			continue;
-		instr = a->instr;
 #ifdef CONFIG_X86_64
 		/* vsyscall code is not mapped yet. resolve it manually. */
 		if (instr >= (u8 *)VSYSCALL_START && instr < (u8*)VSYSCALL_END) {
@@ -191,9 +194,10 @@ void apply_alternatives(struct alt_instr
 				__FUNCTION__, a->instr, instr);
 		}
 #endif
-		memcpy(instr, a->replacement, a->replacementlen);
-		diff = a->instrlen - a->replacementlen;
-		nop_out(instr + a->replacementlen, diff);
+		memcpy(insnbuf, a->replacement, a->replacementlen);
+		add_nops(insnbuf + a->replacementlen,
+			 a->instrlen - a->replacementlen);
+		text_poke(instr, insnbuf, a->instrlen);
 	}
 }
 
@@ -215,16 +219,18 @@ static void alternatives_smp_lock(u8 **s
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
 
@@ -351,6 +357,7 @@ void apply_paravirt(struct paravirt_patc
 		    struct paravirt_patch_site *end)
 {
 	struct paravirt_patch_site *p;
+	char insnbuf[MAX_PATCH_LEN];
 
 	if (noreplace_paravirt)
 		return;
@@ -358,13 +365,15 @@ void apply_paravirt(struct paravirt_patc
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
Index: linux/arch/i386/kernel/paravirt.c
===================================================================
--- linux.orig/arch/i386/kernel/paravirt.c
+++ linux/arch/i386/kernel/paravirt.c
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
+unsigned paravirt_patch_jmp(const void *target, void *insnbuf,
+			    unsigned long addr, unsigned len)
 {
-	unsigned char *jmp = site;
-	unsigned long delta = (unsigned long)target - (unsigned long)(jmp+5);
-	struct branch b;
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
Index: linux/arch/i386/kernel/vmi.c
===================================================================
--- linux.orig/arch/i386/kernel/vmi.c
+++ linux/arch/i386/kernel/vmi.c
@@ -87,12 +87,14 @@ struct vmi_timer_ops vmi_timer_ops;
 #define IRQ_PATCH_INT_MASK 0
 #define IRQ_PATCH_DISABLE  5
 
-static inline void patch_offset(unsigned char *eip, unsigned char *dest)
+static inline void patch_offset(void *insnbuf,
+				unsigned long eip, unsigned long dest)
 {
-        *(unsigned long *)(eip+1) = dest-eip-5;
+        *(unsigned long *)(insnbuf+1) = dest-eip-5;
 }
 
-static unsigned patch_internal(int call, unsigned len, void *insns)
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
Index: linux/arch/i386/xen/enlighten.c
===================================================================
--- linux.orig/arch/i386/xen/enlighten.c
+++ linux/arch/i386/xen/enlighten.c
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
 
Index: linux/drivers/lguest/lguest.c
===================================================================
--- linux.orig/drivers/lguest/lguest.c
+++ linux/drivers/lguest/lguest.c
@@ -933,23 +933,24 @@ static const struct lguest_insns
 /* Now our patch routine is fairly simple (based on the native one in
  * paravirt.c).  If we have a replacement, we copy it in and return how much of
  * the available space we used. */
-static unsigned lguest_patch(u8 type, u16 clobber, void *insns, unsigned len)
+static unsigned lguest_patch(u8 type, u16 clobber, void *ibuf,
+			     unsigned long addr, unsigned len)
 {
 	unsigned int insn_len;
 
 	/* Don't do anything special if we don't have a replacement */
 	if (type >= ARRAY_SIZE(lguest_insns) || !lguest_insns[type].start)
-		return paravirt_patch_default(type, clobber, insns, len);
+		return paravirt_patch_default(type, clobber, ibuf, addr, len);
 
 	insn_len = lguest_insns[type].end - lguest_insns[type].start;
 
 	/* Similarly if we can't fit replacement (shouldn't happen, but let's
 	 * be thorough). */
 	if (len < insn_len)
-		return paravirt_patch_default(type, clobber, insns, len);
+		return paravirt_patch_default(type, clobber, ibuf, addr, len);
 
 	/* Copy in our instructions. */
-	memcpy(insns, lguest_insns[type].start, insn_len);
+	memcpy(ibuf, lguest_insns[type].start, insn_len);
 	return insn_len;
 }
 
Index: linux/include/asm-i386/paravirt.h
===================================================================
--- linux.orig/include/asm-i386/paravirt.h
+++ linux/include/asm-i386/paravirt.h
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
+unsigned paravirt_patch_jmp(const void *target, void *insnbuf,
+			    unsigned long addr, unsigned len);
+unsigned paravirt_patch_default(u8 type, u16 clobbers, void *insnbuf,
+				unsigned long addr, unsigned len);
 
-unsigned paravirt_patch_insns(void *site, unsigned len,
+unsigned paravirt_patch_insns(void *insnbuf, unsigned len,
 			      const char *start, const char *end);
 
 int paravirt_disable_iospace(void);
