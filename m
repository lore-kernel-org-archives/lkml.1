Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYHYOuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYHYOuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 10:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYHYOt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 10:49:58 -0400
Received: from il.qumranet.com ([212.179.150.194]:26377 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbYHYOt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 10:49:57 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 2.6.27-rc4
Date: Mon, 25 Aug 2008 17:49:55 +0300
Message-Id: <1219675795-3303-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.6.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, the repo and branch

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git kvm-updates-2.6.27

await your pulling pleasure.  There's a fix for the kvmtrace ABI, a race
plugged in smp guests on i386 hosts, and a fix for the placement of
exception handlers used during host reboot.

Shortlog, diffstat, and diff follow.

Adrian Bunk (1):
      KVM: fix userspace ABI breakage

Avi Kivity (1):
      KVM: MMU: Fix torn shadow pte

Eduardo Habkost (1):
      KVM: Use .fixup instead of .text.fixup on __kvm_handle_fault_on_reboot

 arch/x86/kvm/paging_tmpl.h |    2 +-
 include/asm-x86/kvm_host.h |    2 +-
 include/linux/kvm.h        |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index f72ac1f..4a814bf 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -345,7 +345,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		shadow_addr = __pa(shadow_page->spt);
 		shadow_pte = shadow_addr | PT_PRESENT_MASK | PT_ACCESSED_MASK
 			| PT_WRITABLE_MASK | PT_USER_MASK;
-		*shadow_ent = shadow_pte;
+		set_shadow_pte(shadow_ent, shadow_pte);
 	}
 
 	mmu_set_spte(vcpu, shadow_ent, access, walker->pte_access & access,
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 0f3c531..c2e34c2 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -722,7 +722,7 @@ asmlinkage void kvm_handle_fault_on_reboot(void);
 
 #define __kvm_handle_fault_on_reboot(insn) \
 	"666: " insn "\n\t" \
-	".pushsection .text.fixup, \"ax\" \n" \
+	".pushsection .fixup, \"ax\" \n" \
 	"667: \n\t" \
 	KVM_EX_PUSH " $666b \n\t" \
 	"jmp kvm_handle_fault_on_reboot \n\t" \
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 69511f7..70a3065 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -320,12 +320,12 @@ struct kvm_trace_rec {
 		struct {
 			__u64 cycle_u64;
 			__u32 extra_u32[KVM_TRC_EXTRA_MAX];
-		} cycle;
+		} __attribute__((packed)) cycle;
 		struct {
 			__u32 extra_u32[KVM_TRC_EXTRA_MAX];
 		} nocycle;
 	} u;
-} __attribute__((packed));
+};
 
 #define KVMIO 0xAE
 
