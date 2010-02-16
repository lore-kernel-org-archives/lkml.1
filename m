Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003Ab0BPKnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:43:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932788Ab0BPKfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:39 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/38] KVM: x86: fix checking of cr0 validity
Date: Tue, 16 Feb 2010 12:35:10 +0200
Message-Id: <1266316536-28936-13-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Move to/from Control Registers chapter of Intel SDM says.  "Reserved bits
in CR0 remain clear after any load of those registers; attempts to set
them have no impact". Control Register chapter says "Bits 63:32 of CR0 are
reserved and must be written with zeros. Writing a nonzero value to any
of the upper 32 bits results in a general-protection exception, #GP(0)."

This patch tries to implement this twisted logic.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Reported-by: Lorenzo Martignoni <martignlo@gmail.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/x86.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fd5101b..ce267d9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -430,12 +430,16 @@ void kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	cr0 |= X86_CR0_ET;
 
-	if (cr0 & CR0_RESERVED_BITS) {
+#ifdef CONFIG_X86_64
+	if (cr0 & 0xffffffff00000000UL) {
 		printk(KERN_DEBUG "set_cr0: 0x%lx #GP, reserved bits 0x%lx\n",
 		       cr0, kvm_read_cr0(vcpu));
 		kvm_inject_gp(vcpu, 0);
 		return;
 	}
+#endif
+
+	cr0 &= ~CR0_RESERVED_BITS;
 
 	if ((cr0 & X86_CR0_NW) && !(cr0 & X86_CR0_CD)) {
 		printk(KERN_DEBUG "set_cr0: #GP, CD == 0 && NW == 1\n");
-- 
1.6.5.3

