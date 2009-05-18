Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbZERJ0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbZERJ0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbZERJXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38398 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbZERJXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:07 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 02/43] KVM: VMX: Don't intercept MSR_KERNEL_GS_BASE
Date: Mon, 18 May 2009 12:22:24 +0300
Message-Id: <1242638585-18470-3-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Windows 2008 accesses this MSR often on context switch intensive workloads;
since we run in guest context with the guest MSR value loaded (so swapgs can
work correctly), we can simply disable interception of rdmsr/wrmsr for this
MSR.

A complication occurs since in legacy mode, we run with the host MSR value
loaded. In this case we enable interception.  This means we need two MSR
bitmaps, one for legacy mode and one for long mode.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   57 +++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index b20c9e4..b5eae7a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -113,7 +113,8 @@ static DEFINE_PER_CPU(struct list_head, vcpus_on_cpu);
 
 static unsigned long *vmx_io_bitmap_a;
 static unsigned long *vmx_io_bitmap_b;
-static unsigned long *vmx_msr_bitmap;
+static unsigned long *vmx_msr_bitmap_legacy;
+static unsigned long *vmx_msr_bitmap_longmode;
 
 static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
 static DEFINE_SPINLOCK(vmx_vpid_lock);
@@ -812,6 +813,7 @@ static void move_msr_up(struct vcpu_vmx *vmx, int from, int to)
 static void setup_msrs(struct vcpu_vmx *vmx)
 {
 	int save_nmsrs;
+	unsigned long *msr_bitmap;
 
 	vmx_load_host_state(vmx);
 	save_nmsrs = 0;
@@ -847,6 +849,15 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 		__find_msr_index(vmx, MSR_KERNEL_GS_BASE);
 #endif
 	vmx->msr_offset_efer = __find_msr_index(vmx, MSR_EFER);
+
+	if (cpu_has_vmx_msr_bitmap()) {
+		if (is_long_mode(&vmx->vcpu))
+			msr_bitmap = vmx_msr_bitmap_longmode;
+		else
+			msr_bitmap = vmx_msr_bitmap_legacy;
+
+		vmcs_write64(MSR_BITMAP, __pa(msr_bitmap));
+	}
 }
 
 /*
@@ -2082,7 +2093,7 @@ static void allocate_vpid(struct vcpu_vmx *vmx)
 	spin_unlock(&vmx_vpid_lock);
 }
 
-static void vmx_disable_intercept_for_msr(unsigned long *msr_bitmap, u32 msr)
+static void __vmx_disable_intercept_for_msr(unsigned long *msr_bitmap, u32 msr)
 {
 	int f = sizeof(unsigned long);
 
@@ -2104,6 +2115,13 @@ static void vmx_disable_intercept_for_msr(unsigned long *msr_bitmap, u32 msr)
 	}
 }
 
+static void vmx_disable_intercept_for_msr(u32 msr, bool longmode_only)
+{
+	if (!longmode_only)
+		__vmx_disable_intercept_for_msr(vmx_msr_bitmap_legacy, msr);
+	__vmx_disable_intercept_for_msr(vmx_msr_bitmap_longmode, msr);
+}
+
 /*
  * Sets up the vmcs for emulated real mode.
  */
@@ -2123,7 +2141,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	vmcs_write64(IO_BITMAP_B, __pa(vmx_io_bitmap_b));
 
 	if (cpu_has_vmx_msr_bitmap())
-		vmcs_write64(MSR_BITMAP, __pa(vmx_msr_bitmap));
+		vmcs_write64(MSR_BITMAP, __pa(vmx_msr_bitmap_legacy));
 
 	vmcs_write64(VMCS_LINK_POINTER, -1ull); /* 22.3.1.5 */
 
@@ -3705,12 +3723,18 @@ static int __init vmx_init(void)
 		goto out;
 	}
 
-	vmx_msr_bitmap = (unsigned long *)__get_free_page(GFP_KERNEL);
-	if (!vmx_msr_bitmap) {
+	vmx_msr_bitmap_legacy = (unsigned long *)__get_free_page(GFP_KERNEL);
+	if (!vmx_msr_bitmap_legacy) {
 		r = -ENOMEM;
 		goto out1;
 	}
 
+	vmx_msr_bitmap_longmode = (unsigned long *)__get_free_page(GFP_KERNEL);
+	if (!vmx_msr_bitmap_longmode) {
+		r = -ENOMEM;
+		goto out2;
+	}
+
 	/*
 	 * Allow direct access to the PC debug port (it is often used for I/O
 	 * delays, but the vmexits simply slow things down).
@@ -3720,19 +3744,21 @@ static int __init vmx_init(void)
 
 	memset(vmx_io_bitmap_b, 0xff, PAGE_SIZE);
 
-	memset(vmx_msr_bitmap, 0xff, PAGE_SIZE);
+	memset(vmx_msr_bitmap_legacy, 0xff, PAGE_SIZE);
+	memset(vmx_msr_bitmap_longmode, 0xff, PAGE_SIZE);
 
 	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
 
 	r = kvm_init(&vmx_x86_ops, sizeof(struct vcpu_vmx), THIS_MODULE);
 	if (r)
-		goto out2;
+		goto out3;
 
-	vmx_disable_intercept_for_msr(vmx_msr_bitmap, MSR_FS_BASE);
-	vmx_disable_intercept_for_msr(vmx_msr_bitmap, MSR_GS_BASE);
-	vmx_disable_intercept_for_msr(vmx_msr_bitmap, MSR_IA32_SYSENTER_CS);
-	vmx_disable_intercept_for_msr(vmx_msr_bitmap, MSR_IA32_SYSENTER_ESP);
-	vmx_disable_intercept_for_msr(vmx_msr_bitmap, MSR_IA32_SYSENTER_EIP);
+	vmx_disable_intercept_for_msr(MSR_FS_BASE, false);
+	vmx_disable_intercept_for_msr(MSR_GS_BASE, false);
+	vmx_disable_intercept_for_msr(MSR_KERNEL_GS_BASE, true);
+	vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_CS, false);
+	vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_ESP, false);
+	vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_EIP, false);
 
 	if (vm_need_ept()) {
 		bypass_guest_pf = 0;
@@ -3752,8 +3778,10 @@ static int __init vmx_init(void)
 
 	return 0;
 
+out3:
+	free_page((unsigned long)vmx_msr_bitmap_longmode);
 out2:
-	free_page((unsigned long)vmx_msr_bitmap);
+	free_page((unsigned long)vmx_msr_bitmap_legacy);
 out1:
 	free_page((unsigned long)vmx_io_bitmap_b);
 out:
@@ -3763,7 +3791,8 @@ out:
 
 static void __exit vmx_exit(void)
 {
-	free_page((unsigned long)vmx_msr_bitmap);
+	free_page((unsigned long)vmx_msr_bitmap_legacy);
+	free_page((unsigned long)vmx_msr_bitmap_longmode);
 	free_page((unsigned long)vmx_io_bitmap_b);
 	free_page((unsigned long)vmx_io_bitmap_a);
 
-- 
1.6.0.6

