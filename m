Return-Path: <linux-kernel-owner+w=401wt.eu-S1759862AbXFQJp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862AbXFQJp5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbXFQJom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:42 -0400
Received: from il.qumranet.com ([82.166.9.18]:55128 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757636AbXFQJok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:40 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, He@qumranet.com, Qing <qing.he@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 01/58] KVM: VMX: Enable io bitmaps to avoid IO port 0x80 VMEXITs
Date: Sun, 17 Jun 2007 12:43:42 +0300
Message-Id: <11820734793717-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: He, Qing <qing.he@intel.com>

This patch enables IO bitmaps control on vmx and unmask the 0x80 port to
avoid VMEXITs caused by accessing port 0x80. 0x80 is used as delays (see
include/asm/io.h), and handling VMEXITs on its access is unnecessary but
slows things down. This patch improves kernel build test at around
3%~5%.
	Because every VM uses the same io bitmap, it is shared between
all VMs rather than a per-VM data structure.

Signed-off-by: Qing He <qing.he@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index c1ac106..52bd5f0 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -34,6 +34,9 @@ MODULE_LICENSE("GPL");
 static DEFINE_PER_CPU(struct vmcs *, vmxarea);
 static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
 
+static struct page *vmx_io_bitmap_a;
+static struct page *vmx_io_bitmap_b;
+
 #ifdef CONFIG_X86_64
 #define HOST_IS_64 1
 #else
@@ -1129,8 +1132,8 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 	vmcs_write32(GUEST_PENDING_DBG_EXCEPTIONS, 0);
 
 	/* I/O */
-	vmcs_write64(IO_BITMAP_A, 0);
-	vmcs_write64(IO_BITMAP_B, 0);
+	vmcs_write64(IO_BITMAP_A, page_to_phys(vmx_io_bitmap_a));
+	vmcs_write64(IO_BITMAP_B, page_to_phys(vmx_io_bitmap_b));
 
 	guest_write_tsc(0);
 
@@ -1150,7 +1153,7 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 			       CPU_BASED_HLT_EXITING         /* 20.6.2 */
 			       | CPU_BASED_CR8_LOAD_EXITING    /* 20.6.2 */
 			       | CPU_BASED_CR8_STORE_EXITING   /* 20.6.2 */
-			       | CPU_BASED_UNCOND_IO_EXITING   /* 20.6.2 */
+			       | CPU_BASED_ACTIVATE_IO_BITMAP  /* 20.6.2 */
 			       | CPU_BASED_MOV_DR_EXITING
 			       | CPU_BASED_USE_TSC_OFFSETING   /* 21.3 */
 			);
@@ -2188,11 +2191,50 @@ static struct kvm_arch_ops vmx_arch_ops = {
 
 static int __init vmx_init(void)
 {
-	return kvm_init_arch(&vmx_arch_ops, THIS_MODULE);
+	void *iova;
+	int r;
+
+	vmx_io_bitmap_a = alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
+	if (!vmx_io_bitmap_a)
+		return -ENOMEM;
+
+	vmx_io_bitmap_b = alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
+	if (!vmx_io_bitmap_b) {
+		r = -ENOMEM;
+		goto out;
+	}
+
+	/*
+	 * Allow direct access to the PC debug port (it is often used for I/O
+	 * delays, but the vmexits simply slow things down).
+	 */
+	iova = kmap(vmx_io_bitmap_a);
+	memset(iova, 0xff, PAGE_SIZE);
+	clear_bit(0x80, iova);
+	kunmap(iova);
+
+	iova = kmap(vmx_io_bitmap_b);
+	memset(iova, 0xff, PAGE_SIZE);
+	kunmap(iova);
+
+	r = kvm_init_arch(&vmx_arch_ops, THIS_MODULE);
+	if (r)
+		goto out1;
+
+	return 0;
+
+out1:
+	__free_page(vmx_io_bitmap_b);
+out:
+	__free_page(vmx_io_bitmap_a);
+	return r;
 }
 
 static void __exit vmx_exit(void)
 {
+	__free_page(vmx_io_bitmap_b);
+	__free_page(vmx_io_bitmap_a);
+
 	kvm_exit_arch();
 }
 
-- 
1.5.0.6

