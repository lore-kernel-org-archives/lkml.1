Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbXH0PkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbXH0PkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 11:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbXH0Pj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:39:56 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59884 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbXH0Pj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:39:56 -0400
From: Anthony Liguori <aliguori@us.ibm.com>
To: kvm-devel@lists.sourceforge.net
Cc: Anthony Liguori <aliguori@us.ibm.com>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Implement emulator_write_phys()
Date: Mon, 27 Aug 2007 10:16:44 -0500
Message-Id: <1188227808405-git-send-email-aliguori@us.ibm.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <11882278064002-git-send-email-aliguori@us.ibm.com>
References: <11882278064002-git-send-email-aliguori@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since a hypercall may span two pages and is a gva, we need a function to write
to a gva that may span multiple pages.  emulator_write_phys() seems like the
logical choice for this.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index d154487..ebcc5c9 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -962,8 +962,35 @@ static int emulator_write_std(unsigned long addr,
 			      unsigned int bytes,
 			      struct kvm_vcpu *vcpu)
 {
-	pr_unimpl(vcpu, "emulator_write_std: addr %lx n %d\n", addr, bytes);
-	return X86EMUL_UNHANDLEABLE;
+	const void *data = val;
+
+	while (bytes) {
+		gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
+		unsigned offset = addr & (PAGE_SIZE-1);
+		unsigned tocopy = min(bytes, (unsigned)PAGE_SIZE - offset);
+		unsigned long pfn;
+		struct page *page;
+		void *page_virt;
+
+		if (gpa == UNMAPPED_GVA)
+			return X86EMUL_PROPAGATE_FAULT;
+		pfn = gpa >> PAGE_SHIFT;
+		page = gfn_to_page(vcpu->kvm, pfn);
+		if (!page)
+			return X86EMUL_UNHANDLEABLE;
+		page_virt = kmap_atomic(page, KM_USER0);
+
+		memcpy(page_virt + offset, data, tocopy);
+
+		kunmap_atomic(page_virt, KM_USER0);
+		mark_page_dirty(vcpu->kvm, addr >> PAGE_SHIFT);
+
+		bytes -= tocopy;
+		data += tocopy;
+		addr += tocopy;
+	}
+
+	return X86EMUL_CONTINUE;
 }
 
 static struct kvm_io_device *vcpu_find_mmio_dev(struct kvm_vcpu *vcpu,
