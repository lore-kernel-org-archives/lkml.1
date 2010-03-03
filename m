Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab0CCTPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:15:49 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:20936
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754052Ab0CCTNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:13:04 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYQ01C-02-H5L-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 16/18] KVM: X86: Add callback to let modules decide over some supported cpuid bits
Date: Wed, 3 Mar 2010 20:12:19 +0100
Message-ID: <1267643541-451-17-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Mar 2010 19:12:42.0829 (UTC) FILETIME=[7FE2EFD0:01CABB05]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the get_supported_cpuid callback to
kvm_x86_ops. It will be used in do_cpuid_ent to delegate the
decission about some supported cpuid bits to the
architecture modules.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    2 ++
 arch/x86/kvm/svm.c              |    6 ++++++
 arch/x86/kvm/vmx.c              |    6 ++++++
 arch/x86/kvm/x86.c              |    3 +++
 4 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 66a698e..7d649f9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -555,6 +555,8 @@ struct kvm_x86_ops {
 	bool (*rdtscp_supported)(void);
 	void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 
+	void (*set_supported_cpuid)(u32 func, struct kvm_cpuid_entry2 *entry);
+
 	const struct trace_print_flags *exit_reasons_str;
 };
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index bce10fe..fe1398e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3287,6 +3287,10 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 {
 }
 
+static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
+{
+}
+
 static const struct trace_print_flags svm_exit_reasons_str[] = {
 	{ SVM_EXIT_READ_CR0,			"read_cr0" },
 	{ SVM_EXIT_READ_CR3,			"read_cr3" },
@@ -3435,6 +3439,8 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.rdtscp_supported = svm_rdtscp_supported,
 
 	.set_tdp_cr3 = set_tdp_cr3,
+
+	.set_supported_cpuid = svm_set_supported_cpuid,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 530d14d..9216867 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4146,6 +4146,10 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void vmx_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
+{
+}
+
 static struct kvm_x86_ops vmx_x86_ops = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -4220,6 +4224,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.rdtscp_supported = vmx_rdtscp_supported,
 
 	.set_tdp_cr3 = vmx_set_cr3,
+
+	.set_supported_cpuid = vmx_set_supported_cpuid,
 };
 
 static int __init vmx_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f8b02d..53360de 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1921,6 +1921,9 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		entry->ecx &= kvm_supported_word6_x86_features;
 		break;
 	}
+
+	kvm_x86_ops->set_supported_cpuid(function, entry);
+
 	put_cpu();
 }
 
-- 
1.7.0


