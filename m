Return-Path: <linux-kernel-owner+w=401wt.eu-S1759835AbZBZOVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835AbZBZOVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbZBZOQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:16:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43073 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbZBZOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Izik Eidus <ieidus@redhat.com>
Subject: [PATCH 31/40] KVM: introduce kvm_read_guest_virt, kvm_write_guest_virt
Date: Thu, 26 Feb 2009 16:15:21 +0200
Message-Id: <1235657730-27683-32-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <ieidus@redhat.com>

This commit change the name of emulator_read_std into kvm_read_guest_virt,
and add new function name kvm_write_guest_virt that allow writing into a
guest virtual address.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    4 ---
 arch/x86/kvm/x86.c              |   56 +++++++++++++++++++++++++++++---------
 2 files changed, 42 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9efc446..b74576a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -609,10 +609,6 @@ void kvm_inject_nmi(struct kvm_vcpu *vcpu);
 
 void fx_init(struct kvm_vcpu *vcpu);
 
-int emulator_read_std(unsigned long addr,
-		      void *val,
-		      unsigned int bytes,
-		      struct kvm_vcpu *vcpu);
 int emulator_write_emulated(unsigned long addr,
 			    const void *val,
 			    unsigned int bytes,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3b2acfd..67f9176 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1976,10 +1976,8 @@ static struct kvm_io_device *vcpu_find_mmio_dev(struct kvm_vcpu *vcpu,
 	return dev;
 }
 
-int emulator_read_std(unsigned long addr,
-			     void *val,
-			     unsigned int bytes,
-			     struct kvm_vcpu *vcpu)
+int kvm_read_guest_virt(gva_t addr, void *val, unsigned int bytes,
+			struct kvm_vcpu *vcpu)
 {
 	void *data = val;
 	int r = X86EMUL_CONTINUE;
@@ -1987,27 +1985,57 @@ int emulator_read_std(unsigned long addr,
 	while (bytes) {
 		gpa_t gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, addr);
 		unsigned offset = addr & (PAGE_SIZE-1);
-		unsigned tocopy = min(bytes, (unsigned)PAGE_SIZE - offset);
+		unsigned toread = min(bytes, (unsigned)PAGE_SIZE - offset);
 		int ret;
 
 		if (gpa == UNMAPPED_GVA) {
 			r = X86EMUL_PROPAGATE_FAULT;
 			goto out;
 		}
-		ret = kvm_read_guest(vcpu->kvm, gpa, data, tocopy);
+		ret = kvm_read_guest(vcpu->kvm, gpa, data, toread);
 		if (ret < 0) {
 			r = X86EMUL_UNHANDLEABLE;
 			goto out;
 		}
 
-		bytes -= tocopy;
-		data += tocopy;
-		addr += tocopy;
+		bytes -= toread;
+		data += toread;
+		addr += toread;
 	}
 out:
 	return r;
 }
-EXPORT_SYMBOL_GPL(emulator_read_std);
+
+int kvm_write_guest_virt(gva_t addr, void *val, unsigned int bytes,
+			 struct kvm_vcpu *vcpu)
+{
+	void *data = val;
+	int r = X86EMUL_CONTINUE;
+
+	while (bytes) {
+		gpa_t gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, addr);
+		unsigned offset = addr & (PAGE_SIZE-1);
+		unsigned towrite = min(bytes, (unsigned)PAGE_SIZE - offset);
+		int ret;
+
+		if (gpa == UNMAPPED_GVA) {
+			r = X86EMUL_PROPAGATE_FAULT;
+			goto out;
+		}
+		ret = kvm_write_guest(vcpu->kvm, gpa, data, towrite);
+		if (ret < 0) {
+			r = X86EMUL_UNHANDLEABLE;
+			goto out;
+		}
+
+		bytes -= towrite;
+		data += towrite;
+		addr += towrite;
+	}
+out:
+	return r;
+}
+
 
 static int emulator_read_emulated(unsigned long addr,
 				  void *val,
@@ -2029,8 +2057,8 @@ static int emulator_read_emulated(unsigned long addr,
 	if ((gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
 		goto mmio;
 
-	if (emulator_read_std(addr, val, bytes, vcpu)
-			== X86EMUL_CONTINUE)
+	if (kvm_read_guest_virt(addr, val, bytes, vcpu)
+				== X86EMUL_CONTINUE)
 		return X86EMUL_CONTINUE;
 	if (gpa == UNMAPPED_GVA)
 		return X86EMUL_PROPAGATE_FAULT;
@@ -2233,7 +2261,7 @@ void kvm_report_emulation_failure(struct kvm_vcpu *vcpu, const char *context)
 
 	rip_linear = rip + get_segment_base(vcpu, VCPU_SREG_CS);
 
-	emulator_read_std(rip_linear, (void *)opcodes, 4, vcpu);
+	kvm_read_guest_virt(rip_linear, (void *)opcodes, 4, vcpu);
 
 	printk(KERN_ERR "emulation failed (%s) rip %lx %02x %02x %02x %02x\n",
 	       context, rip, opcodes[0], opcodes[1], opcodes[2], opcodes[3]);
@@ -2241,7 +2269,7 @@ void kvm_report_emulation_failure(struct kvm_vcpu *vcpu, const char *context)
 EXPORT_SYMBOL_GPL(kvm_report_emulation_failure);
 
 static struct x86_emulate_ops emulate_ops = {
-	.read_std            = emulator_read_std,
+	.read_std            = kvm_read_guest_virt,
 	.read_emulated       = emulator_read_emulated,
 	.write_emulated      = emulator_write_emulated,
 	.cmpxchg_emulated    = emulator_cmpxchg_emulated,
-- 
1.6.0.6

