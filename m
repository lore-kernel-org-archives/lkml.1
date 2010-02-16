Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab0BPKox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:44:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932779Ab0BPKfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:39 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/38] KVM: fix cleanup_srcu_struct on vm destruction
Date: Tue, 16 Feb 2010 12:35:02 +0200
Message-Id: <1266316536-28936-5-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

cleanup_srcu_struct on VM destruction remains broken:

BUG: unable to handle kernel paging request at ffffffffffffffff
IP: [<ffffffff802533d2>] srcu_read_lock+0x16/0x21
RIP: 0010:[<ffffffff802533d2>]  [<ffffffff802533d2>] srcu_read_lock+0x16/0x21
Call Trace:
 [<ffffffffa05354c4>] kvm_arch_vcpu_uninit+0x1b/0x48 [kvm]
 [<ffffffffa05339c6>] kvm_vcpu_uninit+0x9/0x15 [kvm]
 [<ffffffffa0569f7d>] vmx_free_vcpu+0x7f/0x8f [kvm_intel]
 [<ffffffffa05357b5>] kvm_arch_destroy_vm+0x78/0x111 [kvm]
 [<ffffffffa053315b>] kvm_put_kvm+0xd4/0xfe [kvm]

Move it to kvm_arch_destroy_vm.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 arch/ia64/kvm/kvm-ia64.c   |    1 +
 arch/powerpc/kvm/powerpc.c |    1 +
 arch/s390/kvm/kvm-s390.c   |    1 +
 arch/x86/kvm/x86.c         |    1 +
 virt/kvm/kvm_main.c        |    1 -
 5 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index e6ac549..0618898 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1404,6 +1404,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kfree(kvm->arch.vioapic);
 	kvm_release_vm_pages(kvm);
 	kvm_free_physmem(kvm);
+	cleanup_srcu_struct(&kvm->srcu);
 	free_kvm(kvm);
 }
 
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 2c29116..51aedd7 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -137,6 +137,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	kvmppc_free_vcpus(kvm);
 	kvm_free_physmem(kvm);
+	cleanup_srcu_struct(&kvm->srcu);
 	kfree(kvm);
 }
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8bedd31..8f09959 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -241,6 +241,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_free_physmem(kvm);
 	free_page((unsigned long)(kvm->arch.sca));
 	debug_unregister(kvm->arch.dbf);
+	cleanup_srcu_struct(&kvm->srcu);
 	kfree(kvm);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b0758b..322c2c5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5547,6 +5547,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		put_page(kvm->arch.apic_access_page);
 	if (kvm->arch.ept_identity_pagetable)
 		put_page(kvm->arch.ept_identity_pagetable);
+	cleanup_srcu_struct(&kvm->srcu);
 	kfree(kvm->arch.aliases);
 	kfree(kvm);
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2b7cd6c..7c5c873 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -506,7 +506,6 @@ static void kvm_destroy_vm(struct kvm *kvm)
 #else
 	kvm_arch_flush_shadow(kvm);
 #endif
-	cleanup_srcu_struct(&kvm->srcu);
 	kvm_arch_destroy_vm(kvm);
 	hardware_disable_all();
 	mmdrop(mm);
-- 
1.6.5.3

