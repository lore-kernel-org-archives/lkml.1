Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbYFZM32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbYFZM32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbYFZM2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:28:35 -0400
Received: from il.qumranet.com ([212.179.150.194]:32312 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbYFZM2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/50] KVM: VMX: move APIC_ACCESS trace entry to generic code
Date: Thu, 26 Jun 2008 15:27:45 +0300
Message-Id: <1214483312-9265-4-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch moves the trace entry for APIC accesses from the VMX code to the
generic lapic code. This way APIC accesses from SVM will also be traced.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/lapic.c |    4 ++++
 arch/x86/kvm/vmx.c   |    2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ebc03f5..f9201fb 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -572,6 +572,8 @@ static u32 __apic_read(struct kvm_lapic *apic, unsigned int offset)
 {
 	u32 val = 0;
 
+	KVMTRACE_1D(APIC_ACCESS, apic->vcpu, (u32)offset, handler);
+
 	if (offset >= LAPIC_MMIO_LENGTH)
 		return 0;
 
@@ -695,6 +697,8 @@ static void apic_mmio_write(struct kvm_io_device *this,
 
 	offset &= 0xff0;
 
+	KVMTRACE_1D(APIC_ACCESS, apic->vcpu, (u32)offset, handler);
+
 	switch (offset) {
 	case APIC_ID:		/* Local APIC ID */
 		apic_set_reg(apic, APIC_ID, val);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index bc3452a..158a7d8 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2554,8 +2554,6 @@ static int handle_apic_access(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	exit_qualification = vmcs_read64(EXIT_QUALIFICATION);
 	offset = exit_qualification & 0xffful;
 
-	KVMTRACE_1D(APIC_ACCESS, vcpu, (u32)offset, handler);
-
 	er = emulate_instruction(vcpu, kvm_run, 0, 0, 0);
 
 	if (er !=  EMULATE_DONE) {
-- 
1.5.6

