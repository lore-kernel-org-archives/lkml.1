Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab0BMIIk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:08:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab0BMICE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/39] KVM: PPC: Pass through program interrupts
Date: Sat, 13 Feb 2010 10:01:35 +0200
Message-Id: <1266048119-14325-16-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

When we get a program interrupt in guest kernel mode, we try to emulate the
instruction.

If that doesn't fail, we report to the user and try again - at the exact same
instruction pointer. So if the guest kernel really does trigger an invalid
instruction, we loop forever.

So let's better go and forward program exceptions to the guest when we don't
know the instruction we're supposed to emulate.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/emulate.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index 8b0ba0b..b905623 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -476,6 +476,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			advance = 0;
 			printk(KERN_ERR "Couldn't emulate instruction 0x%08x "
 			       "(op %d xop %d)\n", inst, get_op(inst), get_xop(inst));
+			kvmppc_core_queue_program(vcpu, 0);
 		}
 	}
 
-- 
1.6.5.3

