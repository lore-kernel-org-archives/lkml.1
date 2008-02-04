Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYBDEh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYBDEh1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 23:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbYBDEhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 23:37:13 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:26692 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbYBDEhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 23:37:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pPQAtbXnrehXnR9TXc657hrkVzKVSR36Oa5zMqdZkug15DklEOOvPVCtVOxhJVDtsuqCync3+uNKdxCCM73WAi4ZlGQCsJ/MLQZjjTfxESOHyZBgC7fzm/VAFaspTGByTJklwSguR9rgg5bkLiflEjZM8Kb80JaX933Y8ebflig=
Subject: [PATCH] x86: sparse fixes for kvm/x86.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 03 Feb 2008 20:37:21 -0800
Message-Id: <1202099841.1844.72.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although this looks strange:
gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, (gva_t)tmp);

it is correct as tmp is just used a dummy for this one call and
not used again, just needed a stand-in.  tmp will be used in a
kmap_atomic/kunmap_atomic pair right afterwards.  Use the gva_t
cast to keep types happy.

In two case statements, use the ever popular 'i' instead of index:
arch/x86/kvm/x86.c:935:7: warning: symbol 'index' shadows an earlier one
arch/x86/kvm/x86.c:872:9: originally declared here
arch/x86/kvm/x86.c:951:7: warning: symbol 'index' shadows an earlier one
arch/x86/kvm/x86.c:872:9: originally declared here

X86_32-only: use tmp instead of addr which shadows a function arg name:
arch/x86/kvm/x86.c:1742:8: warning: symbol 'addr' shadows an earlier one
arch/x86/kvm/x86.c:1725:52: originally declared here

Make it static:
arch/x86/kvm/x86.c:1832:24: warning: symbol 'emulate_ops' was not declared. Should it be static?

Drop the return statements:
arch/x86/kvm/x86.c:2764:2: warning: returning void-valued expression
arch/x86/kvm/x86.c:2830:2: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kvm/x86.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8f94a0b..3f1152b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -932,32 +932,32 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	}
 	/* function 4 and 0xb have additional index. */
 	case 4: {
-		int index, cache_type;
+		int i, cache_type;
 
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		/* read more entries until cache_type is zero */
-		for (index = 1; *nent < maxnent; ++index) {
-			cache_type = entry[index - 1].eax & 0x1f;
+		for (i = 1; *nent < maxnent; ++i) {
+			cache_type = entry[i - 1].eax & 0x1f;
 			if (!cache_type)
 				break;
-			do_cpuid_1_ent(&entry[index], function, index);
-			entry[index].flags |=
+			do_cpuid_1_ent(&entry[i], function, i);
+			entry[i].flags |=
 			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 			++*nent;
 		}
 		break;
 	}
 	case 0xb: {
-		int index, level_type;
+		int i, level_type;
 
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		/* read more entries until level_type is zero */
-		for (index = 1; *nent < maxnent; ++index) {
-			level_type = entry[index - 1].ecx & 0xff;
+		for (i = 1; *nent < maxnent; ++i) {
+			level_type = entry[i - 1].ecx & 0xff;
 			if (!level_type)
 				break;
-			do_cpuid_1_ent(&entry[index], function, index);
-			entry[index].flags |=
+			do_cpuid_1_ent(&entry[i], function, i);
+			entry[i].flags |=
 			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 			++*nent;
 		}
@@ -1739,11 +1739,11 @@ static int emulator_cmpxchg_emulated(unsigned long addr,
 	if (bytes == 8) {
 		gpa_t gpa;
 		struct page *page;
-		char *addr;
+		char *tmp;
 		u64 val;
 
 		down_read(&current->mm->mmap_sem);
-		gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, addr);
+		gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, (gva_t)tmp);
 
 		if (gpa == UNMAPPED_GVA ||
 		   (gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
@@ -1754,9 +1754,9 @@ static int emulator_cmpxchg_emulated(unsigned long addr,
 
 		val = *(u64 *)new;
 		page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
-		addr = kmap_atomic(page, KM_USER0);
-		set_64bit((u64 *)(addr + offset_in_page(gpa)), val);
-		kunmap_atomic(addr, KM_USER0);
+		tmp = kmap_atomic(page, KM_USER0);
+		set_64bit((u64 *)(tmp + offset_in_page(gpa)), val);
+		kunmap_atomic(tmp, KM_USER0);
 		kvm_release_page_dirty(page);
 	emul_write:
 		up_read(&current->mm->mmap_sem);
@@ -1829,7 +1829,7 @@ void kvm_report_emulation_failure(struct kvm_vcpu *vcpu, const char *context)
 }
 EXPORT_SYMBOL_GPL(kvm_report_emulation_failure);
 
-struct x86_emulate_ops emulate_ops = {
+static struct x86_emulate_ops emulate_ops = {
 	.read_std            = emulator_read_std,
 	.read_emulated       = emulator_read_emulated,
 	.write_emulated      = emulator_write_emulated,
@@ -2761,7 +2761,7 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 static void get_segment(struct kvm_vcpu *vcpu,
 			struct kvm_segment *var, int seg)
 {
-	return kvm_x86_ops->get_segment(vcpu, var, seg);
+	kvm_x86_ops->get_segment(vcpu, var, seg);
 }
 
 void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
@@ -2827,7 +2827,7 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 static void set_segment(struct kvm_vcpu *vcpu,
 			struct kvm_segment *var, int seg)
 {
-	return kvm_x86_ops->set_segment(vcpu, var, seg);
+	kvm_x86_ops->set_segment(vcpu, var, seg);
 }
 
 int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
-- 
1.5.4.rc5.1138.g2602



