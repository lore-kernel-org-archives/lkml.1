Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbZGRPJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbZGRPJX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 11:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZGRPJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 11:09:22 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:34088 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbZGRPJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 11:09:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=onplmj3RoO6Vkapi+B8Ujvkr/LnGY/2SZUP6lqZMAhLTCI02i0N8V9LcxJlXc2XTRd
         L6Q1q9pOtMrdRNA0qsqTNTy3Ej3pyhyW1DllvwkZqwRSmInhVZ9uwmuPWuW7S/u7mrp3
         MrRW6HYfUb+CcolB6yDj9WImLPBghYkwj4LrU=
Date: Sat, 18 Jul 2009 23:58:32 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org, x86@kernel.org
Subject: [PATCH 1/2] kvm: use get_desc_base() and get_desc_limit()
Message-ID: <20090718145830.GA11275@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use get_desc_base() and get_desc_limit() to get the base address and
limit in desc_struct.

Cc: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kvm/x86.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe5474a..38d9b53 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -132,8 +132,7 @@ unsigned long segment_base(u16 selector)
 		table_base = segment_base(ldt_selector);
 	}
 	d = (struct desc_struct *)(table_base + (selector & ~7));
-	v = d->base0 | ((unsigned long)d->base1 << 16) |
-		((unsigned long)d->base2 << 24);
+	v = get_desc_base(d);
 #ifdef CONFIG_X86_64
 	if (d->s == 0 && (d->type == 2 || d->type == 9 || d->type == 11))
 		v |= ((unsigned long)((struct ldttss_desc64 *)d)->base3) << 32;
@@ -3617,11 +3616,8 @@ static void kvm_set_segment(struct kvm_vcpu *vcpu,
 static void seg_desct_to_kvm_desct(struct desc_struct *seg_desc, u16 selector,
 				   struct kvm_segment *kvm_desct)
 {
-	kvm_desct->base = seg_desc->base0;
-	kvm_desct->base |= seg_desc->base1 << 16;
-	kvm_desct->base |= seg_desc->base2 << 24;
-	kvm_desct->limit = seg_desc->limit0;
-	kvm_desct->limit |= seg_desc->limit << 16;
+	kvm_desct->base = get_desc_base(seg_desc);
+	kvm_desct->limit = get_desc_limit(seg_desc);
 	if (seg_desc->g) {
 		kvm_desct->limit <<= 12;
 		kvm_desct->limit |= 0xfff;
@@ -3700,11 +3696,7 @@ static int save_guest_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
 static u32 get_tss_base_addr(struct kvm_vcpu *vcpu,
 			     struct desc_struct *seg_desc)
 {
-	u32 base_addr;
-
-	base_addr = seg_desc->base0;
-	base_addr |= (seg_desc->base1 << 16);
-	base_addr |= (seg_desc->base2 << 24);
+	u32 base_addr = get_desc_base(seg_desc);
 
 	return vcpu->arch.mmu.gva_to_gpa(vcpu, base_addr);
 }
@@ -3993,7 +3985,7 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int reason)
 		}
 	}
 
-	if (!nseg_desc.p || (nseg_desc.limit0 | nseg_desc.limit << 16) < 0x67) {
+	if (!nseg_desc.p || get_desc_limit(&nseg_desc) < 0x67) {
 		kvm_queue_exception_e(vcpu, TS_VECTOR, tss_selector & 0xfffc);
 		return 1;
 	}
-- 
1.6.0.6

