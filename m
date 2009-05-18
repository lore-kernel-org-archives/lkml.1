Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbZERJZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbZERJZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbZERJXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38396 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbZERJXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:07 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 01/43] KVM: VMX: Don't use highmem pages for the msr and pio bitmaps
Date: Mon, 18 May 2009 12:22:23 +0300
Message-Id: <1242638585-18470-2-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Highmem pages are a pain, and saving three lowmem pages on i386 isn't worth
the extra code.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   59 ++++++++++++++++++++++------------------------------
 1 files changed, 25 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index bb48133..b20c9e4 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -111,9 +111,9 @@ static DEFINE_PER_CPU(struct vmcs *, vmxarea);
 static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
 static DEFINE_PER_CPU(struct list_head, vcpus_on_cpu);
 
-static struct page *vmx_io_bitmap_a;
-static struct page *vmx_io_bitmap_b;
-static struct page *vmx_msr_bitmap;
+static unsigned long *vmx_io_bitmap_a;
+static unsigned long *vmx_io_bitmap_b;
+static unsigned long *vmx_msr_bitmap;
 
 static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
 static DEFINE_SPINLOCK(vmx_vpid_lock);
@@ -2082,9 +2082,9 @@ static void allocate_vpid(struct vcpu_vmx *vmx)
 	spin_unlock(&vmx_vpid_lock);
 }
 
-static void vmx_disable_intercept_for_msr(struct page *msr_bitmap, u32 msr)
+static void vmx_disable_intercept_for_msr(unsigned long *msr_bitmap, u32 msr)
 {
-	void *va;
+	int f = sizeof(unsigned long);
 
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
@@ -2094,16 +2094,14 @@ static void vmx_disable_intercept_for_msr(struct page *msr_bitmap, u32 msr)
 	 * have the write-low and read-high bitmap offsets the wrong way round.
 	 * We can control MSRs 0x00000000-0x00001fff and 0xc0000000-0xc0001fff.
 	 */
-	va = kmap(msr_bitmap);
 	if (msr <= 0x1fff) {
-		__clear_bit(msr, va + 0x000); /* read-low */
-		__clear_bit(msr, va + 0x800); /* write-low */
+		__clear_bit(msr, msr_bitmap + 0x000 / f); /* read-low */
+		__clear_bit(msr, msr_bitmap + 0x800 / f); /* write-low */
 	} else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff)) {
 		msr &= 0x1fff;
-		__clear_bit(msr, va + 0x400); /* read-high */
-		__clear_bit(msr, va + 0xc00); /* write-high */
+		__clear_bit(msr, msr_bitmap + 0x400 / f); /* read-high */
+		__clear_bit(msr, msr_bitmap + 0xc00 / f); /* write-high */
 	}
-	kunmap(msr_bitmap);
 }
 
 /*
@@ -2121,11 +2119,11 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	u32 exec_control;
 
 	/* I/O */
-	vmcs_write64(IO_BITMAP_A, page_to_phys(vmx_io_bitmap_a));
-	vmcs_write64(IO_BITMAP_B, page_to_phys(vmx_io_bitmap_b));
+	vmcs_write64(IO_BITMAP_A, __pa(vmx_io_bitmap_a));
+	vmcs_write64(IO_BITMAP_B, __pa(vmx_io_bitmap_b));
 
 	if (cpu_has_vmx_msr_bitmap())
-		vmcs_write64(MSR_BITMAP, page_to_phys(vmx_msr_bitmap));
+		vmcs_write64(MSR_BITMAP, __pa(vmx_msr_bitmap));
 
 	vmcs_write64(VMCS_LINK_POINTER, -1ull); /* 22.3.1.5 */
 
@@ -3695,20 +3693,19 @@ static struct kvm_x86_ops vmx_x86_ops = {
 
 static int __init vmx_init(void)
 {
-	void *va;
 	int r;
 
-	vmx_io_bitmap_a = alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
+	vmx_io_bitmap_a = (unsigned long *)__get_free_page(GFP_KERNEL);
 	if (!vmx_io_bitmap_a)
 		return -ENOMEM;
 
-	vmx_io_bitmap_b = alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
+	vmx_io_bitmap_b = (unsigned long *)__get_free_page(GFP_KERNEL);
 	if (!vmx_io_bitmap_b) {
 		r = -ENOMEM;
 		goto out;
 	}
 
-	vmx_msr_bitmap = alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
+	vmx_msr_bitmap = (unsigned long *)__get_free_page(GFP_KERNEL);
 	if (!vmx_msr_bitmap) {
 		r = -ENOMEM;
 		goto out1;
@@ -3718,18 +3715,12 @@ static int __init vmx_init(void)
 	 * Allow direct access to the PC debug port (it is often used for I/O
 	 * delays, but the vmexits simply slow things down).
 	 */
-	va = kmap(vmx_io_bitmap_a);
-	memset(va, 0xff, PAGE_SIZE);
-	clear_bit(0x80, va);
-	kunmap(vmx_io_bitmap_a);
+	memset(vmx_io_bitmap_a, 0xff, PAGE_SIZE);
+	clear_bit(0x80, vmx_io_bitmap_a);
 
-	va = kmap(vmx_io_bitmap_b);
-	memset(va, 0xff, PAGE_SIZE);
-	kunmap(vmx_io_bitmap_b);
+	memset(vmx_io_bitmap_b, 0xff, PAGE_SIZE);
 
-	va = kmap(vmx_msr_bitmap);
-	memset(va, 0xff, PAGE_SIZE);
-	kunmap(vmx_msr_bitmap);
+	memset(vmx_msr_bitmap, 0xff, PAGE_SIZE);
 
 	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
 
@@ -3762,19 +3753,19 @@ static int __init vmx_init(void)
 	return 0;
 
 out2:
-	__free_page(vmx_msr_bitmap);
+	free_page((unsigned long)vmx_msr_bitmap);
 out1:
-	__free_page(vmx_io_bitmap_b);
+	free_page((unsigned long)vmx_io_bitmap_b);
 out:
-	__free_page(vmx_io_bitmap_a);
+	free_page((unsigned long)vmx_io_bitmap_a);
 	return r;
 }
 
 static void __exit vmx_exit(void)
 {
-	__free_page(vmx_msr_bitmap);
-	__free_page(vmx_io_bitmap_b);
-	__free_page(vmx_io_bitmap_a);
+	free_page((unsigned long)vmx_msr_bitmap);
+	free_page((unsigned long)vmx_io_bitmap_b);
+	free_page((unsigned long)vmx_io_bitmap_a);
 
 	kvm_exit();
 }
-- 
1.6.0.6

