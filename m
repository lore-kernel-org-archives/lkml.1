Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbZGRPJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbZGRPJJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 11:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbZGRPJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 11:09:08 -0400
Received: from mail-pz0-f195.google.com ([209.85.222.195]:51218 "EHLO
	mail-pz0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbZGRPJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 11:09:07 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Jul 2009 11:09:06 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sB4lNDeQlF48evHc6mf7dz2jlVkYC+4qUNyxZlsCieKeOpyEzp6AZG0Vq8QpimAARz
         VgDQuYckiUzO/cRmbla18LJd6UO2yPh1FzUaJN9Pwr7zc+nlcieBnYtlaOYnOufy4DnX
         pLeJFheoc8Nnj2owotcPkChckEmn6JZ0NYlDw=
Date: Sun, 19 Jul 2009 00:00:01 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org, x86@kernel.org
Subject: [PATCH 2/2] kvm: use kvm_get_gdt() and kvm_read_ldt()
Message-ID: <20090718150000.GA11279@localhost.localdomain>
References: <20090718145830.GA11275@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20090718145830.GA11275@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kvm_get_gdt() and kvm_read_ldt() to reduce inline assembly code.

Cc: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kvm/svm.c |    6 +++---
 arch/x86/kvm/x86.c |    5 ++---
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 71510e0..c7c6234 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -263,7 +263,7 @@ static void svm_hardware_enable(void *garbage)
 
 	struct svm_cpu_data *svm_data;
 	uint64_t efer;
-	struct desc_ptr gdt_descr;
+	struct descriptor_table gdt_descr;
 	struct desc_struct *gdt;
 	int me = raw_smp_processor_id();
 
@@ -283,8 +283,8 @@ static void svm_hardware_enable(void *garbage)
 	svm_data->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
 	svm_data->next_asid = svm_data->max_asid + 1;
 
-	asm volatile ("sgdt %0" : "=m"(gdt_descr));
-	gdt = (struct desc_struct *)gdt_descr.address;
+	kvm_get_gdt(&gdt_descr);
+	gdt = (struct desc_struct *)gdt_descr.base;
 	svm_data->tss_desc = (struct kvm_ldttss_desc *)(gdt + GDT_ENTRY_TSS);
 
 	rdmsrl(MSR_EFER, efer);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 38d9b53..8d32333 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -122,13 +122,12 @@ unsigned long segment_base(u16 selector)
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
1.6.0.6

