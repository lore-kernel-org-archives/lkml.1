Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232Ab0CAOfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 09:35:05 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:20916 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab0CAOfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 09:35:00 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h2a8h6bh43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYLXU1-01-AWF-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/7] KVM; SVM: Add correct handling of nested iopm
Date: Mon, 1 Mar 2010 15:34:39 +0100
Message-ID: <1267454080-2513-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267454080-2513-1-git-send-email-joerg.roedel@amd.com>
References: <1267454080-2513-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 01 Mar 2010 14:34:46.0325 (UTC) FILETIME=[5716DE50:01CAB94C]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the correct handling of the nested io
permission bitmap. Old behavior was to not lookup the port
in the iopm but only reinject an io intercept to the guest.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b705115..eb3bfa4 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -78,6 +78,7 @@ struct nested_state {
 
 	/* gpa pointers to the real vectors */
 	u64 vmcb_msrpm;
+	u64 vmcb_iopm;
 
 	/* A VMEXIT is required but not yet emulated */
 	bool exit_required;
@@ -1652,6 +1653,26 @@ static void nested_svm_unmap(struct page *page)
 	kvm_release_page_dirty(page);
 }
 
+static int nested_svm_intercept_ioio(struct vcpu_svm *svm)
+{
+	unsigned port;
+	u8 val, bit;
+	u64 gpa;
+
+	if (!(svm->nested.intercept & (1ULL << INTERCEPT_IOIO_PROT)))
+		return NESTED_EXIT_HOST;
+
+	port = svm->vmcb->control.exit_info_1 >> 16;
+	gpa  = svm->nested.vmcb_iopm + (port / 8);
+	bit  = port % 8;
+	val  = 0;
+
+	if (kvm_read_guest(svm->vcpu.kvm, gpa, &val, 1))
+		val &= (1 << bit);
+
+	return val ? NESTED_EXIT_DONE : NESTED_EXIT_HOST;
+}
+
 static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 {
 	u32 offset, msr, value;
@@ -1717,6 +1738,9 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 	case SVM_EXIT_MSR:
 		vmexit = nested_svm_exit_handled_msr(svm);
 		break;
+	case SVM_EXIT_IOIO:
+		vmexit = nested_svm_intercept_ioio(svm);
+		break;
 	case SVM_EXIT_READ_CR0 ... SVM_EXIT_READ_CR8: {
 		u32 cr_bits = 1 << (exit_code - SVM_EXIT_READ_CR0);
 		if (svm->nested.intercept_cr_read & cr_bits)
@@ -2041,6 +2065,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	svm->vmcb->save.cpl = nested_vmcb->save.cpl;
 
 	svm->nested.vmcb_msrpm = nested_vmcb->control.msrpm_base_pa;
+	svm->nested.vmcb_iopm  = nested_vmcb->control.iopm_base_pa  & ~0x0fffULL;
 
 	/* cache intercepts */
 	svm->nested.intercept_cr_read    = nested_vmcb->control.intercept_cr_read;
-- 
1.7.0


