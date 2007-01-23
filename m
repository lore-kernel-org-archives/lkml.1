Return-Path: <linux-kernel-owner+w=401wt.eu-S932998AbXAWOdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998AbXAWOdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 09:33:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933016AbXAWOdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 09:33:07 -0500
Received: from il.qumranet.com ([62.219.232.206]:60004 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933004AbXAWOdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 09:33:05 -0500
Subject: [PATCH 2/5] KVM: Emulate IA32_MISC_ENABLE msr
From: Avi Kivity <avi@qumranet.com>
Date: Tue, 23 Jan 2007 14:33:04 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45B61C09.5020501@qumranet.com>
In-Reply-To: <45B61C09.5020501@qumranet.com>
Message-Id: <20070123143304.3DD92250136@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This allows netbsd 3.1 i386 to get further along installing.

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/kvm_main.c
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm_main.c
+++ linux-2.6/drivers/kvm/kvm_main.c
@@ -1226,6 +1226,9 @@ int kvm_get_msr_common(struct kvm_vcpu *
 	case MSR_IA32_APICBASE:
 		data = vcpu->apic_base;
 		break;
+	case MSR_IA32_MISC_ENABLE:
+		data = vcpu->ia32_misc_enable_msr;
+		break;
 #ifdef CONFIG_X86_64
 	case MSR_EFER:
 		data = vcpu->shadow_efer;
@@ -1297,6 +1300,9 @@ int kvm_set_msr_common(struct kvm_vcpu *
 	case MSR_IA32_APICBASE:
 		vcpu->apic_base = data;
 		break;
+	case MSR_IA32_MISC_ENABLE:
+		vcpu->ia32_misc_enable_msr = data;
+		break;
 	default:
 		printk(KERN_ERR "kvm: unhandled wrmsr: 0x%x\n", msr);
 		return 1;
@@ -1600,6 +1606,10 @@ static u32 msrs_to_save[] = {
 
 static unsigned num_msrs_to_save;
 
+static u32 emulated_msrs[] = {
+	MSR_IA32_MISC_ENABLE,
+};
+
 static __init void kvm_init_msr_list(void)
 {
 	u32 dummy[2];
@@ -1925,7 +1935,7 @@ static long kvm_dev_ioctl(struct file *f
 		if (copy_from_user(&msr_list, user_msr_list, sizeof msr_list))
 			goto out;
 		n = msr_list.nmsrs;
-		msr_list.nmsrs = num_msrs_to_save;
+		msr_list.nmsrs = num_msrs_to_save + ARRAY_SIZE(emulated_msrs);
 		if (copy_to_user(user_msr_list, &msr_list, sizeof msr_list))
 			goto out;
 		r = -E2BIG;
@@ -1935,6 +1945,11 @@ static long kvm_dev_ioctl(struct file *f
 		if (copy_to_user(user_msr_list->indices, &msrs_to_save,
 				 num_msrs_to_save * sizeof(u32)))
 			goto out;
+		if (copy_to_user(user_msr_list->indices
+				 + num_msrs_to_save * sizeof(u32),
+				 &emulated_msrs,
+				 ARRAY_SIZE(emulated_msrs) * sizeof(u32)))
+			goto out;
 		r = 0;
 		break;
 	}
Index: linux-2.6/drivers/kvm/kvm.h
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm.h
+++ linux-2.6/drivers/kvm/kvm.h
@@ -242,6 +242,7 @@ struct kvm_vcpu {
 	u64 pdptrs[4]; /* pae */
 	u64 shadow_efer;
 	u64 apic_base;
+	u64 ia32_misc_enable_msr;
 	int nmsrs;
 	struct vmx_msr_entry *guest_msrs;
 	struct vmx_msr_entry *host_msrs;
