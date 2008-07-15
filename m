Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595AbYGOMM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbYGOMM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755742AbYGOMMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:12:41 -0400
Received: from il.qumranet.com ([212.179.150.194]:30327 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281AbYGOMMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:12:40 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Lalancette <clalance@redhat.com>
Subject: [PATCH 02/19] KVM: VMX: Fake emulate Intel perfctr MSRs
Date: Tue, 15 Jul 2008 15:12:21 +0300
Message-Id: <1216123958-10717-3-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1216123958-10717-1-git-send-email-avi@qumranet.com>
References: <1216123958-10717-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Lalancette <clalance@redhat.com>

Older linux guests (in this case, 2.6.9) can attempt to
access the performance counter MSRs without a fixup section, and injecting
a GPF kills the guest.  Work around by allowing the guest to write those MSRs.

Tested by me on RHEL-4 i386 and x86_64 guests, as well as F-9 guests.

Signed-off-by: Chris Lalancette <clalance@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index d7522aa..ea6bcf5 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -921,6 +921,18 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 	case MSR_IA32_TIME_STAMP_COUNTER:
 		guest_write_tsc(data);
 		break;
+	case MSR_P6_PERFCTR0:
+	case MSR_P6_PERFCTR1:
+	case MSR_P6_EVNTSEL0:
+	case MSR_P6_EVNTSEL1:
+		/*
+		 * Just discard all writes to the performance counters; this
+		 * should keep both older linux and windows 64-bit guests
+		 * happy
+		 */
+		pr_unimpl(vcpu, "unimplemented perfctr wrmsr: 0x%x data 0x%llx\n", msr_index, data);
+
+		break;
 	default:
 		vmx_load_host_state(vmx);
 		msr = find_msr_entry(vmx, msr_index);
-- 
1.5.6.1

