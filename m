Return-Path: <linux-kernel-owner+w=401wt.eu-S932974AbXB0Imb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974AbXB0Imb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 03:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932893AbXB0Ilz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 03:41:55 -0500
Received: from gw.goop.org ([64.81.55.164]:46839 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932890AbXB0Iiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 03:38:52 -0500
Message-Id: <20070227081634.828471347@goop.org>
References: <20070227081337.434798469@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 27 Feb 2007 00:13:51 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@muc.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: [patch 14/26] Xen-paravirt_ops: add common patching machinery
Content-Disposition: inline; filename=paravirt-patch-machinery.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the actual patching machinery.  paravirt_patcher() contains
the logic to automatically patch a callsite based on a few simple
rules:

 - if the paravirt_op function is either NULL or native_nop, then patch nops
 - if the paravirt_op function is a jmp target, then jmp to it
 - if the paravirt_op function is callable and doesn't clobber too much
    for the callsite, call it directly

These rules will remove most of the expensive indirect calls in favour
of either a direct call or a pile of nops.

Paravirt backends can also pass in other patcher functions for
specific operations if they want to insert literal machine code, or do
more complex things.  The function paravirt_patch_insns() is available
to help with this.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>
---
 arch/i386/kernel/alternative.c |    3 
 arch/i386/kernel/paravirt.c    |  161 ++++++++++++++++++++++++++++++++--------
 include/asm-i386/paravirt.h    |   11 ++
 3 files changed, 145 insertions(+), 30 deletions(-)

===================================================================
--- a/arch/i386/kernel/alternative.c
+++ b/arch/i386/kernel/alternative.c
@@ -359,6 +359,9 @@ void apply_paravirt(struct paravirt_patc
 
 		used = paravirt_ops.patch(p->instrtype, p->clobbers, p->instr,
 					  p->len);
+
+		BUG_ON(used > p->len);
+
 #ifdef CONFIG_DEBUG_PARAVIRT
 		{
 		int i;
===================================================================
--- a/arch/i386/kernel/paravirt.c
+++ b/arch/i386/kernel/paravirt.c
@@ -53,40 +53,141 @@ char *memory_setup(void)
 #define DEF_NATIVE(name, code)					\
 	extern const char start_##name[], end_##name[];		\
 	asm("start_" #name ": " code "; end_" #name ":")
-DEF_NATIVE(cli, "cli");
-DEF_NATIVE(sti, "sti");
-DEF_NATIVE(popf, "push %eax; popf");
-DEF_NATIVE(pushf, "pushf; pop %eax");
+
+DEF_NATIVE(irq_disable, "cli");
+DEF_NATIVE(irq_enable, "sti");
+DEF_NATIVE(restore_fl, "push %eax; popf");
+DEF_NATIVE(save_fl, "pushf; pop %eax");
 DEF_NATIVE(iret, "iret");
-DEF_NATIVE(sti_sysexit, "sti; sysexit");
-
-static const struct native_insns
-{
-	const char *start, *end;
-} native_insns[] = {
-	[PARAVIRT_PATCH(irq_disable)] = { start_cli, end_cli },
-	[PARAVIRT_PATCH(irq_enable)] = { start_sti, end_sti },
-	[PARAVIRT_PATCH(restore_fl)] = { start_popf, end_popf },
-	[PARAVIRT_PATCH(save_fl)] = { start_pushf, end_pushf },
-	[PARAVIRT_PATCH(iret)] = { start_iret, end_iret },
-	[PARAVIRT_PATCH(irq_enable_sysexit)] = { start_sti_sysexit, end_sti_sysexit },
-};
+DEF_NATIVE(irq_enable_sysexit, "sti; sysexit");
+DEF_NATIVE(read_cr2, "mov %cr2, %eax");
+DEF_NATIVE(write_cr3, "mov %eax, %cr3");
+DEF_NATIVE(read_cr3, "mov %cr3, %eax");
+DEF_NATIVE(clts, "clts");
+DEF_NATIVE(read_tsc, "rdtsc");
+
+DEF_NATIVE(pushf_cli, "pushf; pop %eax; cli");
+DEF_NATIVE(ud2a, "ud2a");
 
 static unsigned native_patch(u8 type, u16 clobbers, void *insns, unsigned len)
 {
-	unsigned int insn_len;
-
-	/* Don't touch it if we don't have a replacement */
-	if (type >= ARRAY_SIZE(native_insns) || !native_insns[type].start)
-		return len;
-
-	insn_len = native_insns[type].end - native_insns[type].start;
-
-	/* Similarly if we can't fit replacement. */
-	if (len < insn_len)
-		return len;
-
-	memcpy(insns, native_insns[type].start, insn_len);
+	const unsigned char *start, *end;
+	unsigned ret;
+
+	switch(type) {
+#define SITE(x)	case PARAVIRT_PATCH(x):	start = start_##x; end = end_##x; goto patch_site
+		SITE(irq_disable);
+		SITE(irq_enable);
+		SITE(restore_fl);
+		SITE(save_fl);
+		SITE(iret);
+		SITE(irq_enable_sysexit);
+		SITE(read_cr2);
+		SITE(read_cr3);
+		SITE(write_cr3);
+		SITE(clts);
+		SITE(read_tsc);
+#undef SITE
+
+	patch_site:
+		ret = paravirt_patch_insns(insns, len, start, end);
+		break;
+
+	case PARAVIRT_PATCH(make_pgd):
+	case PARAVIRT_PATCH(make_pmd):
+	case PARAVIRT_PATCH(make_pte):
+	case PARAVIRT_PATCH(pgd_val):
+	case PARAVIRT_PATCH(pmd_val):
+	case PARAVIRT_PATCH(pte_val):
+		/* These functions end up returning exactly what
+		   they're passed, in the same registers. */
+		ret = paravirt_patch_nop();
+		break;
+
+	default:
+		ret = paravirt_patch_default(type, clobbers, insns, len);
+		break;
+	}
+
+	return ret;
+}
+
+unsigned paravirt_patch_nop(void)
+{
+	return 0;
+}
+
+unsigned paravirt_patch_ignore(unsigned len)
+{
+	return len;
+}
+
+unsigned paravirt_patch_call(void *target, u16 tgt_clobbers,
+			     void *site, u16 site_clobbers,
+			     unsigned len)
+{
+	unsigned char *call = site;
+	unsigned long delta = (unsigned long)target - (unsigned long)(call+5);
+
+	if (tgt_clobbers & ~site_clobbers)
+		return len;	/* target would clobber too much for this site */
+	if (len < 5)
+		return len;	/* call too long for patch site */
+
+	*call++ = 0xe8;		/* call */
+	*(unsigned long *)call = delta;
+
+	return 5;
+}
+
+unsigned paravirt_patch_jmp(void *target, void *site, unsigned len)
+{
+	unsigned char *jmp = site;
+	unsigned long delta = (unsigned long)target - (unsigned long)(jmp+5);
+
+	if (len < 5)
+		return len;	/* call too long for patch site */
+
+	*jmp++ = 0xe9;		/* jmp */
+	*(unsigned long *)jmp = delta;
+
+	return 5;
+}
+
+unsigned paravirt_patch_default(u8 type, u16 clobbers, void *site, unsigned len)
+{
+	void *opfunc = *((void **)&paravirt_ops + type);
+	unsigned ret;
+
+	if (opfunc == NULL)
+		/* If there's no function, patch it with a ud2a (BUG) */
+		ret = paravirt_patch_insns(site, len, start_ud2a, end_ud2a);
+	else if (opfunc == paravirt_nop)
+		/* If the operation is a nop, then nop the callsite */
+		ret = paravirt_patch_nop();
+	else if (type == PARAVIRT_PATCH(iret) ||
+		 type == PARAVIRT_PATCH(irq_enable_sysexit))
+		/* If operation requires a jmp, then jmp */
+		ret = paravirt_patch_jmp(opfunc, site, len);
+	else
+		/* Otherwise call the function; assume target could
+		   clobber any caller-save reg */
+		ret = paravirt_patch_call(opfunc, CLBR_ANY,
+					  site, clobbers, len);
+
+	return ret;
+}
+
+unsigned paravirt_patch_insns(void *site, unsigned len,
+			      const char *start, const char *end)
+{
+	unsigned insn_len = end - start;
+
+	if (insn_len > len || start == NULL)
+		insn_len = len;
+	else
+		memcpy(site, start, insn_len);
+
 	return insn_len;
 }
 
===================================================================
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -850,6 +850,17 @@ struct paravirt_patch_site {
 	u16 clobbers;		/* what registers you may clobber */
 };
 
+unsigned paravirt_patch_nop(void);
+unsigned paravirt_patch_ignore(unsigned len);
+unsigned paravirt_patch_call(void *target, u16 tgt_clobbers,
+			     void *site, u16 site_clobbers,
+			     unsigned len);
+unsigned paravirt_patch_jmp(void *target, void *site, unsigned len);
+unsigned paravirt_patch_default(u8 type, u16 clobbers, void *site, unsigned len);
+
+unsigned paravirt_patch_insns(void *site, unsigned len,
+			      const char *start, const char *end);
+
 extern struct paravirt_patch_site __start_parainstructions[],
 	__stop_parainstructions[];
 

-- 

