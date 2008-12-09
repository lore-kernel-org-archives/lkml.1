Return-Path: <linux-kernel-owner+w=401wt.eu-S1756359AbYLIUdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbYLIUdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbYLIUYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34887 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610AbYLIUXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:12 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 01/44] KVM: ppc: adjust vcpu types to support 64-bit cores
Date: Tue,  9 Dec 2008 22:22:16 +0200
Message-Id: <1228854179-23002-2-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

However, some of these fields could be split into separate per-core structures
in the future.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_host.h |   50 +++++++++++++++++-----------------
 arch/powerpc/kvm/booke.c            |   10 +++---
 arch/powerpc/kvm/emulate.c          |    2 +-
 arch/powerpc/kvm/powerpc.c          |    4 +-
 4 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 765d8ec..a4a7d5e 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -84,32 +84,32 @@ struct kvm_vcpu_arch {
 	u32 host_msr;
 
 	u64 fpr[32];
-	u32 gpr[32];
+	ulong gpr[32];
 
-	u32 pc;
+	ulong pc;
 	u32 cr;
-	u32 ctr;
-	u32 lr;
-	u32 xer;
+	ulong ctr;
+	ulong lr;
+	ulong xer;
 
-	u32 msr;
+	ulong msr;
 	u32 mmucr;
-	u32 sprg0;
-	u32 sprg1;
-	u32 sprg2;
-	u32 sprg3;
-	u32 sprg4;
-	u32 sprg5;
-	u32 sprg6;
-	u32 sprg7;
-	u32 srr0;
-	u32 srr1;
-	u32 csrr0;
-	u32 csrr1;
-	u32 dsrr0;
-	u32 dsrr1;
-	u32 dear;
-	u32 esr;
+	ulong sprg0;
+	ulong sprg1;
+	ulong sprg2;
+	ulong sprg3;
+	ulong sprg4;
+	ulong sprg5;
+	ulong sprg6;
+	ulong sprg7;
+	ulong srr0;
+	ulong srr1;
+	ulong csrr0;
+	ulong csrr1;
+	ulong dsrr0;
+	ulong dsrr1;
+	ulong dear;
+	ulong esr;
 	u32 dec;
 	u32 decar;
 	u32 tbl;
@@ -117,7 +117,7 @@ struct kvm_vcpu_arch {
 	u32 tcr;
 	u32 tsr;
 	u32 ivor[16];
-	u32 ivpr;
+	ulong ivpr;
 	u32 pir;
 
 	u32 shadow_pid;
@@ -131,8 +131,8 @@ struct kvm_vcpu_arch {
 	u32 dbcr1;
 
 	u32 last_inst;
-	u32 fault_dear;
-	u32 fault_esr;
+	ulong fault_dear;
+	ulong fault_esr;
 	gpa_t paddr_accessed;
 
 	u8 io_gpr; /* GPR used as IO source/target */
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 883e9db..b23cd54 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -120,14 +120,14 @@ void kvmppc_dump_vcpu(struct kvm_vcpu *vcpu)
 {
 	int i;
 
-	printk("pc:   %08x msr:  %08x\n", vcpu->arch.pc, vcpu->arch.msr);
-	printk("lr:   %08x ctr:  %08x\n", vcpu->arch.lr, vcpu->arch.ctr);
-	printk("srr0: %08x srr1: %08x\n", vcpu->arch.srr0, vcpu->arch.srr1);
+	printk("pc:   %08lx msr:  %08lx\n", vcpu->arch.pc, vcpu->arch.msr);
+	printk("lr:   %08lx ctr:  %08lx\n", vcpu->arch.lr, vcpu->arch.ctr);
+	printk("srr0: %08lx srr1: %08lx\n", vcpu->arch.srr0, vcpu->arch.srr1);
 
 	printk("exceptions: %08lx\n", vcpu->arch.pending_exceptions);
 
 	for (i = 0; i < 32; i += 4) {
-		printk("gpr%02d: %08x %08x %08x %08x\n", i,
+		printk("gpr%02d: %08lx %08lx %08lx %08lx\n", i,
 		       vcpu->arch.gpr[i],
 		       vcpu->arch.gpr[i+1],
 		       vcpu->arch.gpr[i+2],
@@ -305,7 +305,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			break;
 		case EMULATE_FAIL:
 			/* XXX Deliver Program interrupt to guest. */
-			printk(KERN_CRIT "%s: emulation at %x failed (%08x)\n",
+			printk(KERN_CRIT "%s: emulation at %lx failed (%08x)\n",
 			       __func__, vcpu->arch.pc, vcpu->arch.last_inst);
 			/* For debugging, encode the failing instruction and
 			 * report it to userspace. */
diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index 30a49f8..814f1e6 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -380,7 +380,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 		}
 	}
 
-	KVMTRACE_3D(PPC_INSTR, vcpu, inst, vcpu->arch.pc, emulated, entryexit);
+	KVMTRACE_3D(PPC_INSTR, vcpu, inst, (int)vcpu->arch.pc, emulated, entryexit);
 
 	if (advance)
 		vcpu->arch.pc += 4; /* Advance past emulated instruction. */
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index dd279ee..0745b6d 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -250,14 +250,14 @@ int kvm_arch_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
 static void kvmppc_complete_dcr_load(struct kvm_vcpu *vcpu,
                                      struct kvm_run *run)
 {
-	u32 *gpr = &vcpu->arch.gpr[vcpu->arch.io_gpr];
+	ulong *gpr = &vcpu->arch.gpr[vcpu->arch.io_gpr];
 	*gpr = run->dcr.data;
 }
 
 static void kvmppc_complete_mmio_load(struct kvm_vcpu *vcpu,
                                       struct kvm_run *run)
 {
-	u32 *gpr = &vcpu->arch.gpr[vcpu->arch.io_gpr];
+	ulong *gpr = &vcpu->arch.gpr[vcpu->arch.io_gpr];
 
 	if (run->mmio.len > sizeof(*gpr)) {
 		printk(KERN_ERR "bad MMIO length: %d\n", run->mmio.len);
-- 
1.6.0.3

