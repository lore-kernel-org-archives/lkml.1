Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbZHSNHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbZHSNHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZHSNEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:04:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50584 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752018AbZHSNCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 37/47] KVM: introduce module parameter for ignoring unknown MSRs accesses
Date: Wed, 19 Aug 2009 16:02:33 +0300
Message-Id: <1250686963-8357-38-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Przywara <andre.przywara@amd.com>

KVM will inject a #GP into the guest if that tries to access unhandled
MSRs. This will crash many guests. Although it would be the correct
way to actually handle these MSRs, we introduce a runtime switchable
module param called "ignore_msrs" (defaults to 0). If this is Y, unknown
MSR reads will return 0, while MSR writes are simply dropped. In both cases
we print a message to dmesg to inform the user about that.

You can change the behaviour at any time by saying:

 # echo 1 > /sys/modules/kvm/parameters/ignore_msrs

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6aace61..0be75d5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -83,6 +83,9 @@ struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 struct kvm_x86_ops *kvm_x86_ops;
 EXPORT_SYMBOL_GPL(kvm_x86_ops);
 
+int ignore_msrs = 0;
+module_param_named(ignore_msrs, ignore_msrs, bool, S_IRUGO | S_IWUSR);
+
 struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "pf_fixed", VCPU_STAT(pf_fixed) },
 	{ "pf_guest", VCPU_STAT(pf_guest) },
@@ -930,8 +933,15 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 			"0x%x data 0x%llx\n", msr, data);
 		break;
 	default:
-		pr_unimpl(vcpu, "unhandled wrmsr: 0x%x data %llx\n", msr, data);
-		return 1;
+		if (!ignore_msrs) {
+			pr_unimpl(vcpu, "unhandled wrmsr: 0x%x data %llx\n",
+				msr, data);
+			return 1;
+		} else {
+			pr_unimpl(vcpu, "ignored wrmsr: 0x%x data %llx\n",
+				msr, data);
+			break;
+		}
 	}
 	return 0;
 }
@@ -1078,8 +1088,14 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
 		return get_msr_mce(vcpu, msr, pdata);
 	default:
-		pr_unimpl(vcpu, "unhandled rdmsr: 0x%x\n", msr);
-		return 1;
+		if (!ignore_msrs) {
+			pr_unimpl(vcpu, "unhandled rdmsr: 0x%x\n", msr);
+			return 1;
+		} else {
+			pr_unimpl(vcpu, "ignored rdmsr: 0x%x\n", msr);
+			data = 0;
+		}
+		break;
 	}
 	*pdata = data;
 	return 0;
-- 
1.6.3.3

