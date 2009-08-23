Return-Path: <linux-kernel-owner+w=401wt.eu-S933681AbZHWL7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933681AbZHWL7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 07:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933570AbZHWL6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 07:58:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933557AbZHWL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 32/46] KVM: x86: use kvm_get_gdt() and kvm_read_ldt()
Date: Sun, 23 Aug 2009 14:56:31 +0300
Message-Id: <1251028605-31977-33-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

Use kvm_get_gdt() and kvm_read_ldt() to reduce inline assembly code.

Cc: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/svm.c |    6 +++---
 arch/x86/kvm/x86.c |    5 ++---
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8728e51..92fc0da 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -290,7 +290,7 @@ static void svm_hardware_enable(void *garbage)
 
 	struct svm_cpu_data *svm_data;
 	uint64_t efer;
-	struct desc_ptr gdt_descr;
+	struct descriptor_table gdt_descr;
 	struct desc_struct *gdt;
 	int me = raw_smp_processor_id();
 
@@ -310,8 +310,8 @@ static void svm_hardware_enable(void *garbage)
 	svm_data->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
 	svm_data->next_asid = svm_data->max_asid + 1;
 
-	asm volatile ("sgdt %0" : "=m"(gdt_descr));
-	gdt = (struct desc_struct *)gdt_descr.address;
+	kvm_get_gdt(&gdt_descr);
+	gdt = (struct desc_struct *)gdt_descr.base;
 	svm_data->tss_desc = (struct kvm_ldttss_desc *)(gdt + GDT_ENTRY_TSS);
 
 	rdmsrl(MSR_EFER, efer);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0ebd684..18ce27f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -132,13 +132,12 @@ unsigned long segment_base(u16 selector)
 	if (selector == 0)
 		return 0;
 
-	asm("sgdt %0" : "=m"(gdt));
+	kvm_get_gdt(&gdt);
 	table_base = gdt.base;
 
 	if (selector & 4) {           /* from ldt */
-		u16 ldt_selector;
+		u16 ldt_selector = kvm_read_ldt();
 
-		asm("sldt %0" : "=g"(ldt_selector));
 		table_base = segment_base(ldt_selector);
 	}
 	d = (struct desc_struct *)(table_base + (selector & ~7));
-- 
1.6.4.1

