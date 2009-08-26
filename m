Return-Path: <linux-kernel-owner+w=401wt.eu-S932497AbZHZKdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497AbZHZKdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757180AbZHZKd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:33:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757117AbZHZKaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:14 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 44/47] KVM: Use kvm_{read,write}_guest_virt() to read and write segment descriptors
Date: Wed, 26 Aug 2009 13:30:06 +0300
Message-Id: <1251282609-12835-45-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikhail Ershov <Mike.Ershov@gmail.com>

Segment descriptors tables can be placed on two non-contiguous pages.
This patch makes reading segment descriptors by linear address.

Signed-off-by: Mikhail Ershov <Mike.Ershov@gmail.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c0e9427..59a8ba4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4021,7 +4021,6 @@ static void get_segment_descriptor_dtable(struct kvm_vcpu *vcpu,
 static int load_guest_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
 					 struct desc_struct *seg_desc)
 {
-	gpa_t gpa;
 	struct descriptor_table dtable;
 	u16 index = selector >> 3;
 
@@ -4031,16 +4030,13 @@ static int load_guest_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
 		kvm_queue_exception_e(vcpu, GP_VECTOR, selector & 0xfffc);
 		return 1;
 	}
-	gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, dtable.base);
-	gpa += index * 8;
-	return kvm_read_guest(vcpu->kvm, gpa, seg_desc, 8);
+	return kvm_read_guest_virt(dtable.base + index*8, seg_desc, sizeof(*seg_desc), vcpu);
 }
 
 /* allowed just for 8 bytes segments */
 static int save_guest_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
 					 struct desc_struct *seg_desc)
 {
-	gpa_t gpa;
 	struct descriptor_table dtable;
 	u16 index = selector >> 3;
 
@@ -4048,9 +4044,7 @@ static int save_guest_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
 
 	if (dtable.limit < index * 8 + 7)
 		return 1;
-	gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, dtable.base);
-	gpa += index * 8;
-	return kvm_write_guest(vcpu->kvm, gpa, seg_desc, 8);
+	return kvm_write_guest_virt(dtable.base + index*8, seg_desc, sizeof(*seg_desc), vcpu);
 }
 
 static u32 get_tss_base_addr(struct kvm_vcpu *vcpu,
-- 
1.6.4.1

