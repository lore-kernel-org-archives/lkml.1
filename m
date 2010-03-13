Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935209Ab0CMAZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:25:26 -0500
Received: from kroah.org ([198.145.64.141]:32891 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935068Ab0CMAVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:21:12 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:15 2010
Message-Id: <20100313001515.557361243@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 119/123] KVM: x86 emulator: Check CPL level during privilege instruction emulation
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Gleb Natapov <gleb@redhat.com>

commit e92805ac1228626c59c865f2f4e9059b9fb8c97b upstream.

Add CPL checking in case emulator is tricked into emulating
privilege instruction from userspace.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/emulate.c |   35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -76,6 +76,7 @@
 #define GroupDual   (1<<15)     /* Alternate decoding of mod == 3 */
 #define GroupMask   0xff        /* Group number stored in bits 0:7 */
 /* Misc flags */
+#define Priv        (1<<27) /* instruction generates #GP if current CPL != 0 */
 #define No64	    (1<<28)
 /* Source 2 operand type */
 #define Src2None    (0<<29)
@@ -211,7 +212,7 @@ static u32 opcode_table[256] = {
 	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
 	/* 0xF0 - 0xF7 */
 	0, 0, 0, 0,
-	ImplicitOps, ImplicitOps, Group | Group3_Byte, Group | Group3,
+	ImplicitOps | Priv, ImplicitOps, Group | Group3_Byte, Group | Group3,
 	/* 0xF8 - 0xFF */
 	ImplicitOps, 0, ImplicitOps, ImplicitOps,
 	ImplicitOps, ImplicitOps, Group | Group4, Group | Group5,
@@ -219,16 +220,20 @@ static u32 opcode_table[256] = {
 
 static u32 twobyte_table[256] = {
 	/* 0x00 - 0x0F */
-	0, Group | GroupDual | Group7, 0, 0, 0, ImplicitOps, ImplicitOps, 0,
-	ImplicitOps, ImplicitOps, 0, 0, 0, ImplicitOps | ModRM, 0, 0,
+	0, Group | GroupDual | Group7, 0, 0,
+	0, ImplicitOps, ImplicitOps | Priv, 0,
+	ImplicitOps | Priv, ImplicitOps | Priv, 0, 0,
+	0, ImplicitOps | ModRM, 0, 0,
 	/* 0x10 - 0x1F */
 	0, 0, 0, 0, 0, 0, 0, 0, ImplicitOps | ModRM, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x20 - 0x2F */
-	ModRM | ImplicitOps, ModRM, ModRM | ImplicitOps, ModRM, 0, 0, 0, 0,
+	ModRM | ImplicitOps | Priv, ModRM | Priv,
+	ModRM | ImplicitOps | Priv, ModRM | Priv,
+	0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x30 - 0x3F */
-	ImplicitOps, 0, ImplicitOps, 0,
-	ImplicitOps, ImplicitOps, 0, 0,
+	ImplicitOps | Priv, 0, ImplicitOps | Priv, 0,
+	ImplicitOps, ImplicitOps | Priv, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x40 - 0x47 */
 	DstReg | SrcMem | ModRM | Mov, DstReg | SrcMem | ModRM | Mov,
@@ -322,9 +327,9 @@ static u32 group_table[] = {
 	SrcMem | ModRM | Stack, 0,
 	SrcMem | ModRM | Stack, 0, SrcMem | ModRM | Stack, 0,
 	[Group7*8] =
-	0, 0, ModRM | SrcMem, ModRM | SrcMem,
+	0, 0, ModRM | SrcMem | Priv, ModRM | SrcMem | Priv,
 	SrcNone | ModRM | DstMem | Mov, 0,
-	SrcMem16 | ModRM | Mov, SrcMem | ModRM | ByteOp,
+	SrcMem16 | ModRM | Mov | Priv, SrcMem | ModRM | ByteOp | Priv,
 	[Group8*8] =
 	0, 0, 0, 0,
 	DstMem | SrcImmByte | ModRM, DstMem | SrcImmByte | ModRM,
@@ -335,7 +340,7 @@ static u32 group_table[] = {
 
 static u32 group2_table[] = {
 	[Group7*8] =
-	SrcNone | ModRM, 0, 0, SrcNone | ModRM,
+	SrcNone | ModRM | Priv, 0, 0, SrcNone | ModRM,
 	SrcNone | ModRM | DstMem | Mov, 0,
 	SrcMem16 | ModRM | Mov, 0,
 	[Group9*8] =
@@ -1650,12 +1655,6 @@ emulate_sysexit(struct x86_emulate_ctxt
 		return -1;
 	}
 
-	/* sysexit must be called from CPL 0 */
-	if (kvm_x86_ops->get_cpl(ctxt->vcpu) != 0) {
-		kvm_inject_gp(ctxt->vcpu, 0);
-		return -1;
-	}
-
 	setup_syscalls_segments(ctxt, &cs, &ss);
 
 	if ((c->rex_prefix & 0x8) != 0x0)
@@ -1719,6 +1718,12 @@ x86_emulate_insn(struct x86_emulate_ctxt
 	memcpy(c->regs, ctxt->vcpu->arch.regs, sizeof c->regs);
 	saved_eip = c->eip;
 
+	/* Privileged instruction can be executed only in CPL=0 */
+	if ((c->d & Priv) && kvm_x86_ops->get_cpl(ctxt->vcpu)) {
+		kvm_inject_gp(ctxt->vcpu, 0);
+		goto done;
+	}
+
 	if (((c->d & ModRM) && (c->modrm_mod != 3)) || (c->d & MemAbs))
 		memop = c->modrm_ea;
 


