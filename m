Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022Ab0BYRQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:16:56 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:37024
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932996Ab0BYRQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:16:08 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYEQMG-02-N9T-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/5] KVM: SVM: Add correct handling of nested iopm
Date: Thu, 25 Feb 2010 18:15:48 +0100
Message-ID: <1267118149-15737-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com>
References: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Feb 2010 17:15:52.0396 (UTC) FILETIME=[2EDD40C0:01CAB63E]
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
index bb75a44..3859e2c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -78,6 +78,7 @@ struct nested_state {
 
 	/* gpa pointers to the real vectors */
 	u64 vmcb_msrpm;
+	u64 vmcb_iopm;
 
 	/* A VMEXIT is required but not yet emulated */
 	bool exit_required;
@@ -1603,6 +1604,26 @@ static void nested_svm_unmap(struct page *page)
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
 static bool nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 {
 	u32 offset, msr, value;
@@ -1665,6 +1686,9 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 	case SVM_EXIT_MSR:
 		vmexit = nested_svm_exit_handled_msr(svm);
 		break;
+	case SVM_EXIT_IOIO:
+		vmexit = nested_svm_intercept_ioio(svm);
+		break;
 	case SVM_EXIT_READ_CR0 ... SVM_EXIT_READ_CR8: {
 		u32 cr_bits = 1 << (exit_code - SVM_EXIT_READ_CR0);
 		if (svm->nested.intercept_cr_read & cr_bits)
@@ -1989,6 +2013,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	svm->vmcb->save.cpl = nested_vmcb->save.cpl;
 
 	svm->nested.vmcb_msrpm = nested_vmcb->control.msrpm_base_pa;
+	svm->nested.vmcb_iopm  = nested_vmcb->control.iopm_base_pa  & ~0x0fffULL;
 
 	/* cache intercepts */
 	svm->nested.intercept_cr_read    = nested_vmcb->control.intercept_cr_read;
-- 
1.7.0


