Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbZKSNnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbZKSNnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:43:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbZKSNnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:43:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388AbZKSNfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:07 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 05/35] KVM: introduce kvm_vcpu_on_spin
Date: Thu, 19 Nov 2009 15:34:41 +0200
Message-Id: <1258637711-11674-6-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhai, Edwin <edwin.zhai@intel.com>

Introduce kvm_vcpu_on_spin, to be used by VMX/SVM to yield processing
once the cpu detects pause-based looping.

Signed-off-by: "Zhai, Edwin" <edwin.zhai@intel.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b985a29..bd5a616 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -286,6 +286,7 @@ int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
 void kvm_vcpu_block(struct kvm_vcpu *vcpu);
+void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu);
 void kvm_resched(struct kvm_vcpu *vcpu);
 void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
 void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70c8cbe..cac69c4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1108,6 +1108,21 @@ void kvm_resched(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_resched);
 
+void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu)
+{
+	ktime_t expires;
+	DEFINE_WAIT(wait);
+
+	prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
+
+	/* Sleep for 100 us, and hope lock-holder got scheduled */
+	expires = ktime_add_ns(ktime_get(), 100000UL);
+	schedule_hrtimeout(&expires, HRTIMER_MODE_ABS);
+
+	finish_wait(&vcpu->wq, &wait);
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
+
 static int kvm_vcpu_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct kvm_vcpu *vcpu = vma->vm_file->private_data;
-- 
1.6.5.2

