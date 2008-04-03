Return-Path: <linux-kernel-owner+w=401wt.eu-S932077AbYDCTe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbYDCTe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759137AbYDCTdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:00 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53020
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757577AbYDCTc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:57 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH 05/35] KVM: sparse fixes for kvm/x86.c
Date: Thu,  3 Apr 2008 22:32:20 +0300
Message-Id: <1207251170-5013-6-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>

In two case statements, use the ever popular 'i' instead of index:
arch/x86/kvm/x86.c:1063:7: warning: symbol 'index' shadows an earlier one
arch/x86/kvm/x86.c:1000:9: originally declared here
arch/x86/kvm/x86.c:1079:7: warning: symbol 'index' shadows an earlier one
arch/x86/kvm/x86.c:1000:9: originally declared here

Make it static.
arch/x86/kvm/x86.c:1945:24: warning: symbol 'emulate_ops' was not declared. Should it be static?

Drop the return statements.
arch/x86/kvm/x86.c:2878:2: warning: returning void-valued expression
arch/x86/kvm/x86.c:2944:2: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 15bba5d..cf6261e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1083,32 +1083,32 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
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
@@ -1965,7 +1965,7 @@ void kvm_report_emulation_failure(struct kvm_vcpu *vcpu, const char *context)
 }
 EXPORT_SYMBOL_GPL(kvm_report_emulation_failure);
 
-struct x86_emulate_ops emulate_ops = {
+static struct x86_emulate_ops emulate_ops = {
 	.read_std            = emulator_read_std,
 	.read_emulated       = emulator_read_emulated,
 	.write_emulated      = emulator_write_emulated,
@@ -2899,7 +2899,7 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 static void get_segment(struct kvm_vcpu *vcpu,
 			struct kvm_segment *var, int seg)
 {
-	return kvm_x86_ops->get_segment(vcpu, var, seg);
+	kvm_x86_ops->get_segment(vcpu, var, seg);
 }
 
 void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
@@ -2965,7 +2965,7 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 static void set_segment(struct kvm_vcpu *vcpu,
 			struct kvm_segment *var, int seg)
 {
-	return kvm_x86_ops->set_segment(vcpu, var, seg);
+	kvm_x86_ops->set_segment(vcpu, var, seg);
 }
 
 int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
-- 
1.5.4.5

