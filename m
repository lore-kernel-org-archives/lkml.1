Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbYCYIih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbYCYIih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 04:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYCYIi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 04:38:29 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:60415
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYCYIi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 04:38:28 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [GIT PULL] KVM fixes for 2.6.25-rc6
Date: Tue, 25 Mar 2008 10:38:26 +0200
Message-Id: <1206434306-26035-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the repo and branch

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git for-linus

The patches fix a memory leak, ioperm() failures on unrelated processes
on the host, a locking issue, and a host crash when host userspace changes
the memory map.

Diffstat, shortlog and individual patches follow:

 arch/x86/kvm/mmu.c |   18 ++++++++++++++----
 arch/x86/kvm/vmx.c |    7 ++-----
 2 files changed, 16 insertions(+), 9 deletions(-)

Avi Kivity (3):
      KVM: VMX: Restore tss even on x86_64
      KVM: MMU: Fix is_rmap_pte() with io ptes
      KVM: MMU: Fix memory leak on guest demand faults

Marcelo Tosatti (2):
      KVM: MMU: handle page removal with shadow mapping
      KVM: VMX: convert init_rmode_tss() to slots_lock

>From 5dc832628229d2736fab10523566855c3cda622d Mon Sep 17 00:00:00 2001
From: Avi Kivity <avi@qumranet.com>
Date: Sun, 16 Mar 2008 18:48:26 +0200
Subject: [PATCH] KVM: VMX: Restore tss even on x86_64

The vmx hardware state restore restores the tss selector and base address, but
not its length.  Usually, this does not matter since most of the tss contents
is within the default length of 0x67.  However, if a process is using ioperm()
to grant itself I/O port permissions, an additional bitmap within the tss,
but outside the default length is consulted.  The effect is that the process
will receive a SIGSEGV instead of transparently accessing the port.

Fix by restoring the tss length.  Note that i386 had this working already.

Closes bugzilla 10246.

Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 94ea724..f2df03c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -349,8 +349,6 @@ static void update_exception_bitmap(struct kvm_vcpu *vcpu)
 
 static void reload_tss(void)
 {
-#ifndef CONFIG_X86_64
-
 	/*
 	 * VT restores TR but not its size.  Useless.
 	 */
@@ -361,7 +359,6 @@ static void reload_tss(void)
 	descs = (void *)gdt.base;
 	descs[GDT_ENTRY_TSS].type = 9; /* available TSS */
 	load_TR_desc();
-#endif
 }
 
 static void load_transition_efer(struct vcpu_vmx *vmx)
-- 
1.5.4.2


>From 4b1a80fa65aa9e2ec5696998856136c886385538 Mon Sep 17 00:00:00 2001
From: Avi Kivity <avi@qumranet.com>
Date: Sun, 23 Mar 2008 12:18:19 +0200
Subject: [PATCH] KVM: MMU: Fix is_rmap_pte() with io ptes

is_rmap_pte() doesn't take into account io ptes, which have the avail bit set.

Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d8172aa..e49c4d4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -222,8 +222,7 @@ static int is_io_pte(unsigned long pte)
 
 static int is_rmap_pte(u64 pte)
 {
-	return pte != shadow_trap_nonpresent_pte
-		&& pte != shadow_notrap_nonpresent_pte;
+	return is_shadow_present_pte(pte);
 }
 
 static gfn_t pse36_gfn_delta(u32 gpte)
-- 
1.5.4.2


>From 15aaa819e20cb183f26392ed8ea16020630ef142 Mon Sep 17 00:00:00 2001
From: Marcelo Tosatti <marcelo@kvack.org>
Date: Mon, 17 Mar 2008 10:08:18 -0300
Subject: [PATCH] KVM: MMU: handle page removal with shadow mapping

Do not assume that a shadow mapping will always point to the same host
frame number.  Fixes crash with madvise(MADV_DONTNEED).

[avi: move after first printk(), add another printk()]

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e49c4d4..4ba85d9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -892,14 +892,25 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 			 int *ptwrite, gfn_t gfn, struct page *page)
 {
 	u64 spte;
-	int was_rmapped = is_rmap_pte(*shadow_pte);
+	int was_rmapped = 0;
 	int was_writeble = is_writeble_pte(*shadow_pte);
+	hfn_t host_pfn = (*shadow_pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
 
 	pgprintk("%s: spte %llx access %x write_fault %d"
 		 " user_fault %d gfn %lx\n",
 		 __FUNCTION__, *shadow_pte, pt_access,
 		 write_fault, user_fault, gfn);
 
+	if (is_rmap_pte(*shadow_pte)) {
+		if (host_pfn != page_to_pfn(page)) {
+			pgprintk("hfn old %lx new %lx\n",
+				 host_pfn, page_to_pfn(page));
+			rmap_remove(vcpu->kvm, shadow_pte);
+		}
+		else
+			was_rmapped = 1;
+	}
+
 	/*
 	 * We don't set the accessed bit, since we sometimes want to see
 	 * whether the guest actually used the pte (in order to detect
-- 
1.5.4.2


>From 707a18a51d83d9180a63b3cbaad8eda7764a8689 Mon Sep 17 00:00:00 2001
From: Marcelo Tosatti <marcelo@kvack.org>
Date: Tue, 18 Mar 2008 17:42:34 -0300
Subject: [PATCH] KVM: VMX: convert init_rmode_tss() to slots_lock

init_rmode_tss was forgotten during the conversion from mmap_sem to
slots_lock.

INFO: task qemu-system-x86:3748 blocked for more than 120 seconds.
Call Trace:
 [<ffffffff8053d100>] __down_read+0x86/0x9e
 [<ffffffff8053fb43>] do_page_fault+0x346/0x78e
 [<ffffffff8053d235>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8053dcad>] error_exit+0x0/0xa9
 [<ffffffff8035a7a7>] copy_user_generic_string+0x17/0x40
 [<ffffffff88099a8a>] :kvm:kvm_write_guest_page+0x3e/0x5f
 [<ffffffff880b661a>] :kvm_intel:init_rmode_tss+0xa7/0xf9
 [<ffffffff880b7d7e>] :kvm_intel:vmx_vcpu_reset+0x10/0x38a
 [<ffffffff8809b9a5>] :kvm:kvm_arch_vcpu_setup+0x20/0x53
 [<ffffffff8809a1e4>] :kvm:kvm_vm_ioctl+0xad/0x1cf
 [<ffffffff80249dea>] __lock_acquire+0x4f7/0xc28
 [<ffffffff8028fad9>] vfs_ioctl+0x21/0x6b
 [<ffffffff8028fd75>] do_vfs_ioctl+0x252/0x26b
 [<ffffffff8028fdca>] sys_ioctl+0x3c/0x5e
 [<ffffffff8020b01b>] system_call_after_swapgs+0x7b/0x80

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f2df03c..8e14628 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1433,7 +1433,7 @@ static int init_rmode_tss(struct kvm *kvm)
 	int ret = 0;
 	int r;
 
-	down_read(&current->mm->mmap_sem);
+	down_read(&kvm->slots_lock);
 	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE);
 	if (r < 0)
 		goto out;
@@ -1456,7 +1456,7 @@ static int init_rmode_tss(struct kvm *kvm)
 
 	ret = 1;
 out:
-	up_read(&current->mm->mmap_sem);
+	up_read(&kvm->slots_lock);
 	return ret;
 }
 
-- 
1.5.4.2


>From e48bb497b95a0f7127f9ff596a6b4c4b206f7dcf Mon Sep 17 00:00:00 2001
From: Avi Kivity <avi@qumranet.com>
Date: Sun, 23 Mar 2008 14:21:08 +0200
Subject: [PATCH] KVM: MMU: Fix memory leak on guest demand faults

While backporting 72dc67a69690288538142df73a7e3ac66fea68dc, a gfn_to_page()
call was duplicated instead of moved (due to an unrelated patch not being
present in mainline).  This caused a page reference leak, resulting in a
fairly massive memory leak.

Fix by removing the extraneous gfn_to_page() call.

Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4ba85d9..e55af12 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1412,7 +1412,7 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	up_read(&current->mm->mmap_sem);
 
 	vcpu->arch.update_pte.gfn = gfn;
-	vcpu->arch.update_pte.page = gfn_to_page(vcpu->kvm, gfn);
+	vcpu->arch.update_pte.page = page;
 }
 
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
-- 
1.5.4.2

