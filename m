Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab0BPKh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:37:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932826Ab0BPKfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 38/38] KVM: Remove redundant reading of rax on OUT instructions
Date: Tue, 16 Feb 2010 12:35:36 +0200
Message-Id: <1266316536-28936-39-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>

kvm_emulate_pio() and complete_pio() both read out the
RAX register value and copy it to a place into which
the value read out from the port will be copied later.

This patch removes this redundancy.

/*** snippet from arch/x86/kvm/x86.c ***/
int complete_pio(struct kvm_vcpu *vcpu)
{
	...
	if (!io->string) {
		if (io->in) {
			val = kvm_register_read(vcpu, VCPU_REGS_RAX);
			memcpy(&val, vcpu->arch.pio_data, io->size);
			kvm_register_write(vcpu, VCPU_REGS_RAX, val);
		}
	...

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c91007f..bd3161c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3551,8 +3551,10 @@ int kvm_emulate_pio(struct kvm_vcpu *vcpu, int in, int size, unsigned port)
 	trace_kvm_pio(vcpu->run->io.direction == KVM_EXIT_IO_OUT, port,
 		      size, 1);
 
-	val = kvm_register_read(vcpu, VCPU_REGS_RAX);
-	memcpy(vcpu->arch.pio_data, &val, 4);
+	if (!vcpu->arch.pio.in) {
+		val = kvm_register_read(vcpu, VCPU_REGS_RAX);
+		memcpy(vcpu->arch.pio_data, &val, 4);
+	}
 
 	if (!kernel_pio(vcpu, vcpu->arch.pio_data)) {
 		complete_pio(vcpu);
-- 
1.6.5.3

