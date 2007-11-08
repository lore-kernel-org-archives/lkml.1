Return-Path: <linux-kernel-owner+w=401wt.eu-S1762907AbXKHVkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762907AbXKHVkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 16:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761394AbXKHVkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 16:40:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761207AbXKHVkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 16:40:10 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jeremy@goop.org, avi@qumranet.com, aliguori@us.ibm.com,
       kvm-devel@lists.sourceforge.net, hollisb@us.ibm.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 2/3] kvmclock - the host part.
Date: Thu,  8 Nov 2007 20:39:22 -0200
Message-Id: <11945615751747-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11945615703593-git-send-email-gcosta@redhat.com>
References: <11945615632624-git-send-email-gcosta@redhat.com> <11945615703593-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the host part of kvm clocksource implementation. As it does
not include clockevents, it is a fairly simple implementation. We
only have to register a per-vcpu area, and start writting to it periodically.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/kvm/kvm_main.c |    1 +
 drivers/kvm/x86.c      |   32 ++++++++++++++++++++++++++++++++
 drivers/kvm/x86.h      |    4 ++++
 3 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index d095002..c2c79b8 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1243,6 +1243,7 @@ static long kvm_dev_ioctl(struct file *filp,
 		case KVM_CAP_MMU_SHADOW_CACHE_CONTROL:
 		case KVM_CAP_USER_MEMORY:
 		case KVM_CAP_SET_TSS_ADDR:
+		case KVM_CAP_CLOCKSOURCE:
 			r = 1;
 			break;
 		default:
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index e905d46..ef31fed 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -19,6 +19,7 @@
 #include "segment_descriptor.h"
 #include "irq.h"
 
+#include <linux/clocksource.h>
 #include <linux/kvm.h>
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
@@ -1628,6 +1629,28 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_halt);
 
+static void kvm_write_guest_time(struct kvm_vcpu *vcpu)
+{
+	struct timespec ts;
+	int r;
+
+	if (!vcpu->clock_gpa)
+		return;
+
+	/* Updates version to the next odd number, indicating we're writing */
+	vcpu->hv_clock.version++;
+	kvm_write_guest(vcpu->kvm, vcpu->clock_gpa, &vcpu->hv_clock, PAGE_SIZE);
+
+	kvm_get_msr(vcpu, MSR_IA32_TIME_STAMP_COUNTER,
+			  &vcpu->hv_clock.last_tsc);
+
+	ktime_get_ts(&ts);
+	vcpu->hv_clock.now_ns = ts.tv_nsec + (NSEC_PER_SEC * (u64)ts.tv_sec);
+	vcpu->hv_clock.wc_sec = get_seconds();
+	vcpu->hv_clock.version++;
+	kvm_write_guest(vcpu->kvm, vcpu->clock_gpa, &vcpu->hv_clock, PAGE_SIZE);
+}
+
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
@@ -1648,7 +1671,15 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		a3 &= 0xFFFFFFFF;
 	}
 
+	ret = 0;
 	switch (nr) {
+	case  KVM_HCALL_REGISTER_CLOCK:
+
+		vcpu->clock_gpa = a0 << PAGE_SHIFT;
+		vcpu->hv_clock.tsc_mult = clocksource_khz2mult(tsc_khz, 22);
+
+		break;
+
 	default:
 		ret = -KVM_ENOSYS;
 		break;
@@ -1924,6 +1955,7 @@ out:
 		goto preempted;
 	}
 
+	kvm_write_guest_time(vcpu);
 	post_kvm_run_save(vcpu, kvm_run);
 
 	return r;
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 663b822..fd77b66 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -83,6 +83,10 @@ struct kvm_vcpu {
 	/* emulate context */
 
 	struct x86_emulate_ctxt emulate_ctxt;
+
+	struct kvm_hv_clock_s hv_clock;
+	gpa_t clock_gpa; /* guest frame number, physical addr */
+
 };
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva, u32 error_code);
-- 
1.5.0.6

