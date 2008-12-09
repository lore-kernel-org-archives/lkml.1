Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYLIUg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYLIUg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbYLIUYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34873 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848AbYLIUXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiantao Zhang <xiantao.zhang@intel.com>
Subject: [PATCH 30/44] KVM: ia64: Add some debug points to provide crash infomation
Date: Tue,  9 Dec 2008 22:22:45 +0200
Message-Id: <1228854179-23002-31-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

Use printk infrastructure to print out some debug info once VM crashes.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/mmio.c    |   38 ++++++++++---------------
 arch/ia64/kvm/process.c |    9 +++--
 arch/ia64/kvm/vcpu.c    |   71 +++++++++++++++++++++++++++++++++++++++++++---
 arch/ia64/kvm/vcpu.h    |    2 +-
 arch/ia64/kvm/vmm.c     |    1 +
 5 files changed, 88 insertions(+), 33 deletions(-)

diff --git a/arch/ia64/kvm/mmio.c b/arch/ia64/kvm/mmio.c
index 7f1a858..21f63ff 100644
--- a/arch/ia64/kvm/mmio.c
+++ b/arch/ia64/kvm/mmio.c
@@ -66,31 +66,25 @@ void lsapic_write(struct kvm_vcpu *v, unsigned long addr,
 
 	switch (addr) {
 	case PIB_OFST_INTA:
-		/*panic_domain(NULL, "Undefined write on PIB INTA\n");*/
-		panic_vm(v);
+		panic_vm(v, "Undefined write on PIB INTA\n");
 		break;
 	case PIB_OFST_XTP:
 		if (length == 1) {
 			vlsapic_write_xtp(v, val);
 		} else {
-			/*panic_domain(NULL,
-			"Undefined write on PIB XTP\n");*/
-			panic_vm(v);
+			panic_vm(v, "Undefined write on PIB XTP\n");
 		}
 		break;
 	default:
 		if (PIB_LOW_HALF(addr)) {
-			/*lower half */
+			/*Lower half */
 			if (length != 8)
-				/*panic_domain(NULL,
-				"Can't LHF write with size %ld!\n",
-				length);*/
-				panic_vm(v);
+				panic_vm(v, "Can't LHF write with size %ld!\n",
+						length);
 			else
 				vlsapic_write_ipi(v, addr, val);
-		} else {   /*	upper half
-				printk("IPI-UHF write %lx\n",addr);*/
-			panic_vm(v);
+		} else {   /*Upper half */
+			panic_vm(v, "IPI-UHF write %lx\n", addr);
 		}
 		break;
 	}
@@ -108,22 +102,18 @@ unsigned long lsapic_read(struct kvm_vcpu *v, unsigned long addr,
 		if (length == 1) /* 1 byte load */
 			; /* There is no i8259, there is no INTA access*/
 		else
-			/*panic_domain(NULL,"Undefined read on PIB INTA\n"); */
-			panic_vm(v);
+			panic_vm(v, "Undefined read on PIB INTA\n");
 
 		break;
 	case PIB_OFST_XTP:
 		if (length == 1) {
 			result = VLSAPIC_XTP(v);
-			/* printk("read xtp %lx\n", result); */
 		} else {
-			/*panic_domain(NULL,
-			"Undefined read on PIB XTP\n");*/
-			panic_vm(v);
+			panic_vm(v, "Undefined read on PIB XTP\n");
 		}
 		break;
 	default:
-		panic_vm(v);
+		panic_vm(v, "Undefined addr access for lsapic!\n");
 		break;
 	}
 	return result;
@@ -162,7 +152,7 @@ static void mmio_access(struct kvm_vcpu *vcpu, u64 src_pa, u64 *dest,
 			/* it's necessary to ensure zero extending */
 			*dest = p->u.ioreq.data & (~0UL >> (64-(s*8)));
 	} else
-		panic_vm(vcpu);
+		panic_vm(vcpu, "Unhandled mmio access returned!\n");
 out:
 	local_irq_restore(psr);
 	return ;
@@ -324,7 +314,9 @@ void emulate_io_inst(struct kvm_vcpu *vcpu, u64 padr, u64 ma)
 		return;
 	} else {
 		inst_type = -1;
-		panic_vm(vcpu);
+		panic_vm(vcpu, "Unsupported MMIO access instruction! \
+				Bunld[0]=0x%lx, Bundle[1]=0x%lx\n",
+				bundle.i64[0], bundle.i64[1]);
 	}
 
 	size = 1 << size;
@@ -335,7 +327,7 @@ void emulate_io_inst(struct kvm_vcpu *vcpu, u64 padr, u64 ma)
 		if (inst_type == SL_INTEGER)
 			vcpu_set_gr(vcpu, inst.M1.r1, data, 0);
 		else
-			panic_vm(vcpu);
+			panic_vm(vcpu, "Unsupported instruction type!\n");
 
 	}
 	vcpu_increment_iip(vcpu);
diff --git a/arch/ia64/kvm/process.c b/arch/ia64/kvm/process.c
index 8008173..cefc349 100644
--- a/arch/ia64/kvm/process.c
+++ b/arch/ia64/kvm/process.c
@@ -527,7 +527,8 @@ void reflect_interruption(u64 ifa, u64 isr, u64 iim,
 	vector = vec2off[vec];
 
 	if (!(vpsr & IA64_PSR_IC) && (vector != IA64_DATA_NESTED_TLB_VECTOR)) {
-		panic_vm(vcpu);
+		panic_vm(vcpu, "Interruption with vector :0x%lx occurs "
+						"with psr.ic = 0\n", vector);
 		return;
 	}
 
@@ -586,7 +587,7 @@ static void set_pal_call_result(struct kvm_vcpu *vcpu)
 		vcpu_set_gr(vcpu, 10, p->u.pal_data.ret.v1, 0);
 		vcpu_set_gr(vcpu, 11, p->u.pal_data.ret.v2, 0);
 	} else
-		panic_vm(vcpu);
+		panic_vm(vcpu, "Mis-set for exit reason!\n");
 }
 
 static void set_sal_call_data(struct kvm_vcpu *vcpu)
@@ -614,7 +615,7 @@ static void set_sal_call_result(struct kvm_vcpu *vcpu)
 		vcpu_set_gr(vcpu, 10, p->u.sal_data.ret.r10, 0);
 		vcpu_set_gr(vcpu, 11, p->u.sal_data.ret.r11, 0);
 	} else
-		panic_vm(vcpu);
+		panic_vm(vcpu, "Mis-set for exit reason!\n");
 }
 
 void  kvm_ia64_handle_break(unsigned long ifa, struct kvm_pt_regs *regs,
@@ -680,7 +681,7 @@ static void generate_exirq(struct kvm_vcpu *vcpu)
 	vpsr = VCPU(vcpu, vpsr);
 	isr = vpsr & IA64_PSR_RI;
 	if (!(vpsr & IA64_PSR_IC))
-		panic_vm(vcpu);
+		panic_vm(vcpu, "Trying to inject one IRQ with psr.ic=0\n");
 	reflect_interruption(0, isr, 0, 12, regs); /* EXT IRQ */
 }
 
diff --git a/arch/ia64/kvm/vcpu.c b/arch/ia64/kvm/vcpu.c
index a528d70..ecd526b 100644
--- a/arch/ia64/kvm/vcpu.c
+++ b/arch/ia64/kvm/vcpu.c
@@ -1651,7 +1651,8 @@ void vcpu_set_psr(struct kvm_vcpu *vcpu, unsigned long val)
 	 * Otherwise panic
 	 */
 	if (val & (IA64_PSR_PK | IA64_PSR_IS | IA64_PSR_VM))
-		panic_vm(vcpu);
+		panic_vm(vcpu, "Only support guests with vpsr.pk =0 \
+				& vpsr.is=0\n");
 
 	/*
 	 * For those IA64_PSR bits: id/da/dd/ss/ed/ia
@@ -2104,7 +2105,7 @@ void kvm_init_all_rr(struct kvm_vcpu *vcpu)
 
 	if (is_physical_mode(vcpu)) {
 		if (vcpu->arch.mode_flags & GUEST_PHY_EMUL)
-			panic_vm(vcpu);
+			panic_vm(vcpu, "Machine Status conflicts!\n");
 
 		ia64_set_rr((VRN0 << VRN_SHIFT), vcpu->arch.metaphysical_rr0);
 		ia64_dv_serialize_data();
@@ -2153,10 +2154,70 @@ int vmm_entry(void)
 	return 0;
 }
 
-void panic_vm(struct kvm_vcpu *v)
-{
+static void kvm_show_registers(struct kvm_pt_regs *regs)
+{
+	unsigned long ip = regs->cr_iip + ia64_psr(regs)->ri;
+
+	struct kvm_vcpu *vcpu = current_vcpu;
+	if (vcpu != NULL)
+		printk("vcpu 0x%p vcpu %d\n",
+		       vcpu, vcpu->vcpu_id);
+
+	printk("psr : %016lx ifs : %016lx ip  : [<%016lx>]\n",
+	       regs->cr_ipsr, regs->cr_ifs, ip);
+
+	printk("unat: %016lx pfs : %016lx rsc : %016lx\n",
+	       regs->ar_unat, regs->ar_pfs, regs->ar_rsc);
+	printk("rnat: %016lx bspstore: %016lx pr  : %016lx\n",
+	       regs->ar_rnat, regs->ar_bspstore, regs->pr);
+	printk("ldrs: %016lx ccv : %016lx fpsr: %016lx\n",
+	       regs->loadrs, regs->ar_ccv, regs->ar_fpsr);
+	printk("csd : %016lx ssd : %016lx\n", regs->ar_csd, regs->ar_ssd);
+	printk("b0  : %016lx b6  : %016lx b7  : %016lx\n", regs->b0,
+							regs->b6, regs->b7);
+	printk("f6  : %05lx%016lx f7  : %05lx%016lx\n",
+	       regs->f6.u.bits[1], regs->f6.u.bits[0],
+	       regs->f7.u.bits[1], regs->f7.u.bits[0]);
+	printk("f8  : %05lx%016lx f9  : %05lx%016lx\n",
+	       regs->f8.u.bits[1], regs->f8.u.bits[0],
+	       regs->f9.u.bits[1], regs->f9.u.bits[0]);
+	printk("f10 : %05lx%016lx f11 : %05lx%016lx\n",
+	       regs->f10.u.bits[1], regs->f10.u.bits[0],
+	       regs->f11.u.bits[1], regs->f11.u.bits[0]);
+
+	printk("r1  : %016lx r2  : %016lx r3  : %016lx\n", regs->r1,
+							regs->r2, regs->r3);
+	printk("r8  : %016lx r9  : %016lx r10 : %016lx\n", regs->r8,
+							regs->r9, regs->r10);
+	printk("r11 : %016lx r12 : %016lx r13 : %016lx\n", regs->r11,
+							regs->r12, regs->r13);
+	printk("r14 : %016lx r15 : %016lx r16 : %016lx\n", regs->r14,
+							regs->r15, regs->r16);
+	printk("r17 : %016lx r18 : %016lx r19 : %016lx\n", regs->r17,
+							regs->r18, regs->r19);
+	printk("r20 : %016lx r21 : %016lx r22 : %016lx\n", regs->r20,
+							regs->r21, regs->r22);
+	printk("r23 : %016lx r24 : %016lx r25 : %016lx\n", regs->r23,
+							regs->r24, regs->r25);
+	printk("r26 : %016lx r27 : %016lx r28 : %016lx\n", regs->r26,
+							regs->r27, regs->r28);
+	printk("r29 : %016lx r30 : %016lx r31 : %016lx\n", regs->r29,
+							regs->r30, regs->r31);
+
+}
+
+void panic_vm(struct kvm_vcpu *v, const char *fmt, ...)
+{
+	va_list args;
+	char buf[256];
+
+	struct kvm_pt_regs *regs = vcpu_regs(v);
 	struct exit_ctl_data *p = &v->arch.exit_data;
-
+	va_start(args, fmt);
+	vsnprintf(buf, sizeof(buf), fmt, args);
+	va_end(args);
+	printk(buf);
+	kvm_show_registers(regs);
 	p->exit_reason = EXIT_REASON_VM_PANIC;
 	vmm_transition(v);
 	/*Never to return*/
diff --git a/arch/ia64/kvm/vcpu.h b/arch/ia64/kvm/vcpu.h
index e9b2a4e..0dad842 100644
--- a/arch/ia64/kvm/vcpu.h
+++ b/arch/ia64/kvm/vcpu.h
@@ -737,7 +737,7 @@ void kvm_init_vtlb(struct kvm_vcpu *v);
 void kvm_init_vhpt(struct kvm_vcpu *v);
 void thash_init(struct thash_cb *hcb, u64 sz);
 
-void panic_vm(struct kvm_vcpu *v);
+void panic_vm(struct kvm_vcpu *v, const char *fmt, ...);
 
 extern u64 ia64_call_vsa(u64 proc, u64 arg1, u64 arg2, u64 arg3,
 		u64 arg4, u64 arg5, u64 arg6, u64 arg7);
diff --git a/arch/ia64/kvm/vmm.c b/arch/ia64/kvm/vmm.c
index 9577795..d3dc0b0 100644
--- a/arch/ia64/kvm/vmm.c
+++ b/arch/ia64/kvm/vmm.c
@@ -20,6 +20,7 @@
  */
 
 
+#include<linux/kernel.h>
 #include<linux/module.h>
 #include<asm/fpswa.h>
 
-- 
1.6.0.3

