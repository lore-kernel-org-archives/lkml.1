Return-Path: <linux-kernel-owner+w=401wt.eu-S1760459AbXGYLz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760459AbXGYLz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 07:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbXGYLzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 07:55:16 -0400
Received: from il.qumranet.com ([82.166.9.18]:56502 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbXGYLzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 07:55:14 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: KVM fixes for 2.6.23-rc2
Date: Wed, 25 Jul 2007 14:55:23 +0300
Message-Id: <11853645231572-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git for-linus

to fix various issues in kvm, including a silent, moderately rare guest
data corruption, a performance regression on forky workloads, a problem
with nx capable guests on non-nx-enabled hosts, and a race with cpu
hotplug.


Aurelien Jarno (1):
      KVM: disable writeback for 0x0f 0x01 instructions.

Avi Kivity (3):
      KVM: Correctly handle writes crossing a page boundary
      Revert "KVM: Avoid useless memory write when possible"
      KVM: Fix removal of nx capability from guest cpuid

Rusty Russell (1):
      KVM: Fix unlikely kvm_create vs decache_vcpus_on_cpu race

 drivers/kvm/kvm_main.c    |   44 +++++++++++++++++++++++++++++++-------------
 drivers/kvm/x86_emulate.c |    2 ++
 2 files changed, 33 insertions(+), 13 deletions(-)

commit b0fcd903e6f3f47189baddf3fe085bdf78c9644c
Author: Avi Kivity <avi@qumranet.com>
Date:   Sun Jul 22 18:48:54 2007 +0300

    KVM: Correctly handle writes crossing a page boundary
    
    Writes that are contiguous in virtual memory may not be contiguous in
    physical memory; so split writes that straddle a page boundary.
    
    Thanks to Aurelien for reporting the bug, patient testing, and a fix
    to this very patch.
    
    Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index bcbe683..a0a3fdd 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1078,10 +1078,10 @@ static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 	return 1;
 }
 
-static int emulator_write_emulated(unsigned long addr,
-				   const void *val,
-				   unsigned int bytes,
-				   struct x86_emulate_ctxt *ctxt)
+static int emulator_write_emulated_onepage(unsigned long addr,
+					   const void *val,
+					   unsigned int bytes,
+					   struct x86_emulate_ctxt *ctxt)
 {
 	struct kvm_vcpu      *vcpu = ctxt->vcpu;
 	struct kvm_io_device *mmio_dev;
@@ -1113,6 +1113,26 @@ static int emulator_write_emulated(unsigned long addr,
 	return X86EMUL_CONTINUE;
 }
 
+static int emulator_write_emulated(unsigned long addr,
+				   const void *val,
+				   unsigned int bytes,
+				   struct x86_emulate_ctxt *ctxt)
+{
+	/* Crossing a page boundary? */
+	if (((addr + bytes - 1) ^ addr) & PAGE_MASK) {
+		int rc, now;
+
+		now = -addr & ~PAGE_MASK;
+		rc = emulator_write_emulated_onepage(addr, val, now, ctxt);
+		if (rc != X86EMUL_CONTINUE)
+			return rc;
+		addr += now;
+		val += now;
+		bytes -= now;
+	}
+	return emulator_write_emulated_onepage(addr, val, bytes, ctxt);
+}
+
 static int emulator_cmpxchg_emulated(unsigned long addr,
 				     const void *old,
 				     const void *new,


commit 5e58cfe41c7e5902c32bb7f62993d43fb4c48ccf
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Jul 23 17:08:21 2007 +1000

    KVM: Fix unlikely kvm_create vs decache_vcpus_on_cpu race
    
    We add the kvm to the vm_list before initializing the vcpu mutexes,
    which can be mutex_trylock()'ed by decache_vcpus_on_cpu().
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index a0a3fdd..46efbe7 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -297,9 +297,6 @@ static struct kvm *kvm_create_vm(void)
 	kvm_io_bus_init(&kvm->pio_bus);
 	spin_lock_init(&kvm->lock);
 	INIT_LIST_HEAD(&kvm->active_mmu_pages);
-	spin_lock(&kvm_lock);
-	list_add(&kvm->vm_list, &vm_list);
-	spin_unlock(&kvm_lock);
 	kvm_io_bus_init(&kvm->mmio_bus);
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		struct kvm_vcpu *vcpu = &kvm->vcpus[i];
@@ -309,6 +306,9 @@ static struct kvm *kvm_create_vm(void)
 		vcpu->kvm = kvm;
 		vcpu->mmu.root_hpa = INVALID_PAGE;
 	}
+	spin_lock(&kvm_lock);
+	list_add(&kvm->vm_list, &vm_list);
+	spin_unlock(&kvm_lock);
 	return kvm;
 }
 


commit 7cfa4b0a43286b1da3afa4f5f99d52e65a8f30fc
Author: Avi Kivity <avi@qumranet.com>
Date:   Mon Jul 23 18:33:14 2007 +0300

    Revert "KVM: Avoid useless memory write when possible"
    
    This reverts commit a3c870bdce4d34332ebdba7eb9969592c4c6b243.  While it
    does save useless updates, it (probably) defeats the fork detector, causing
    a massive performance loss.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 46efbe7..a8d8db8 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1070,10 +1070,8 @@ static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 		return 0;
 	mark_page_dirty(vcpu->kvm, gpa >> PAGE_SHIFT);
 	virt = kmap_atomic(page, KM_USER0);
-	if (memcmp(virt + offset_in_page(gpa), val, bytes)) {
-		kvm_mmu_pte_write(vcpu, gpa, virt + offset, val, bytes);
-		memcpy(virt + offset_in_page(gpa), val, bytes);
-	}
+	kvm_mmu_pte_write(vcpu, gpa, virt + offset, val, bytes);
+	memcpy(virt + offset_in_page(gpa), val, bytes);
 	kunmap_atomic(virt, KM_USER0);
 	return 1;
 }


commit 4c981b43d7ec18818754bf85b829865abd0ce340
Author: Avi Kivity <avi@qumranet.com>
Date:   Wed Jul 25 09:22:12 2007 +0300

    KVM: Fix removal of nx capability from guest cpuid
    
    Testing the wrong bit caused kvm not to disable nx on the guest when it is
    disabled on the host (an mmu optimization relies on the nx bits being the
    same in the guest and host).
    
    This allows Windows to boot when nx is disabled on te host (e.g. when
    host pae is disabled).
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index a8d8db8..9685609 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2432,9 +2432,9 @@ static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
 			break;
 		}
 	}
-	if (entry && (entry->edx & EFER_NX) && !(efer & EFER_NX)) {
+	if (entry && (entry->edx & (1 << 20)) && !(efer & EFER_NX)) {
 		entry->edx &= ~(1 << 20);
-		printk(KERN_INFO ": guest NX capability removed\n");
+		printk(KERN_INFO "kvm: guest NX capability removed\n");
 	}
 }
 


commit d37c85571904a622cbabc7a2e04b8c919de75ac0
Author: Aurelien Jarno <aurelien@aurel32.net>
Date:   Wed Jul 25 10:19:54 2007 +0200

    KVM: disable writeback for 0x0f 0x01 instructions.
    
    0x0f 0x01 instructions (ie lgdt, lidt, smsw, lmsw and invlpg) does
    not use writeback. This patch set no_wb=1 when emulating those
    instructions.
    
    This fixes a regression booting the FreeBSD kernel on AMD.
    
    Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 1b800fc..1f979cb 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1178,6 +1178,8 @@ pop_instruction:
 twobyte_insn:
 	switch (b) {
 	case 0x01: /* lgdt, lidt, lmsw */
+		/* Disable writeback. */
+		no_wb = 1;
 		switch (modrm_reg) {
 			u16 size;
 			unsigned long address;
