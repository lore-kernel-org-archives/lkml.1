Return-Path: <linux-kernel-owner+w=401wt.eu-S936709AbZLQEoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936709AbZLQEoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763633AbZLQEnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:43:20 -0500
Received: from kroah.org ([198.145.64.141]:55358 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763614AbZLQEDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:03:55 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:46 2009
Message-Id: <20091217035646.693037750@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>
Subject: [029/151] KVM: x86 emulator: limit instructions to 15 bytes
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

commit eb3c79e64a70fb8f7473e30fa07e89c1ecc2c9bb upstream.

While we are never normally passed an instruction that exceeds 15 bytes,
smp games can cause us to attempt to interpret one, which will cause
large latencies in non-preempt hosts.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -129,7 +129,7 @@ struct decode_cache {
 	u8 seg_override;
 	unsigned int d;
 	unsigned long regs[NR_VCPU_REGS];
-	unsigned long eip;
+	unsigned long eip, eip_orig;
 	/* modrm */
 	u8 modrm;
 	u8 modrm_mod;
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index d226dff..7e8faea 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -622,6 +622,9 @@ static int do_insn_fetch(struct x86_emulate_ctxt *ctxt,
 {
 	int rc = 0;
 
+	/* x86 instructions are limited to 15 bytes. */
+	if (eip + size - ctxt->decode.eip_orig > 15)
+		return X86EMUL_UNHANDLEABLE;
 	eip += ctxt->cs_base;
 	while (size--) {
 		rc = do_fetch_insn_byte(ctxt, ops, eip++, dest++);
@@ -880,7 +883,7 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	/* Shadow copy of register state. Committed on successful emulation. */
 
 	memset(c, 0, sizeof(struct decode_cache));
-	c->eip = kvm_rip_read(ctxt->vcpu);
+	c->eip = c->eip_orig = kvm_rip_read(ctxt->vcpu);
 	ctxt->cs_base = seg_base(ctxt, VCPU_SREG_CS);
 	memcpy(c->regs, ctxt->vcpu->arch.regs, sizeof c->regs);
 


