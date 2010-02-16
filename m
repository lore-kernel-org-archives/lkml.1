Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828Ab0BPKlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:41:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932806Ab0BPKfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:40 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 20/38] KVM: trace guest fpu loads and unloads
Date: Tue, 16 Feb 2010 12:35:18 +0200
Message-Id: <1266316536-28936-21-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/x86.c         |    2 ++
 include/trace/events/kvm.h |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 27af6e3..3b90298 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5292,6 +5292,7 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 	vcpu->guest_fpu_loaded = 1;
 	kvm_fx_save(&vcpu->arch.host_fx_image);
 	kvm_fx_restore(&vcpu->arch.guest_fx_image);
+	trace_kvm_fpu(1);
 }
 
 void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
@@ -5304,6 +5305,7 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 	kvm_fx_restore(&vcpu->arch.host_fx_image);
 	++vcpu->stat.fpu_reload;
 	set_bit(KVM_REQ_DEACTIVATE_FPU, &vcpu->requests);
+	trace_kvm_fpu(0);
 }
 
 void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index dbe1084..8abdc12 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -145,6 +145,25 @@ TRACE_EVENT(kvm_mmio,
 		  __entry->len, __entry->gpa, __entry->val)
 );
 
+#define kvm_fpu_load_symbol	\
+	{0, "unload"},		\
+	{1, "load"}
+
+TRACE_EVENT(kvm_fpu,
+	TP_PROTO(int load),
+	TP_ARGS(load),
+
+	TP_STRUCT__entry(
+		__field(	u32,	        load		)
+	),
+
+	TP_fast_assign(
+		__entry->load		= load;
+	),
+
+	TP_printk("%s", __print_symbolic(__entry->load, kvm_fpu_load_symbol))
+);
+
 #endif /* _TRACE_KVM_MAIN_H */
 
 /* This part must be outside protection */
-- 
1.6.5.3

