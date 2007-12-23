Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbXLWO54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbXLWO54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953AbXLWOv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:51:59 -0500
Received: from il.qumranet.com ([82.166.9.18]:35902 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbXLWOvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:43 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <izik@Home1 (none)>
Subject: [PATCH 21/50] KVM: Add general accessors to read and write guest memory
Date: Sun, 23 Dec 2007 16:51:06 +0200
Message-Id: <1198421495-31481-22-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izik@Home1.(none)>

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    9 +++
 drivers/kvm/kvm_main.c |  160 +++++++++++++++++++++++++++++++++++++++---------
 drivers/kvm/vmx.c      |   43 ++++++-------
 3 files changed, 158 insertions(+), 54 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 80cfb99..1965438 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -559,6 +559,15 @@ extern hpa_t bad_page_address;
 
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn);
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
+int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
+			int len);
+int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);
+int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn, const void *data,
+			 int offset, int len);
+int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
+		    unsigned long len);
+int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
+int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index ac563fc..3d1972e 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -400,22 +400,16 @@ static int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 	gfn_t pdpt_gfn = cr3 >> PAGE_SHIFT;
 	unsigned offset = ((cr3 & (PAGE_SIZE-1)) >> 5) << 2;
 	int i;
-	u64 *pdpt;
 	int ret;
-	struct page *page;
 	u64 pdpte[ARRAY_SIZE(vcpu->pdptrs)];
 
 	mutex_lock(&vcpu->kvm->lock);
-	page = gfn_to_page(vcpu->kvm, pdpt_gfn);
-	if (!page) {
+	ret = kvm_read_guest_page(vcpu->kvm, pdpt_gfn, pdpte,
+				  offset * sizeof(u64), sizeof(pdpte));
+	if (ret < 0) {
 		ret = 0;
 		goto out;
 	}
-
-	pdpt = kmap_atomic(page, KM_USER0);
-	memcpy(pdpte, pdpt+offset, sizeof(pdpte));
-	kunmap_atomic(pdpt, KM_USER0);
-
 	for (i = 0; i < ARRAY_SIZE(pdpte); ++i) {
 		if ((pdpte[i] & 1) && (pdpte[i] & 0xfffffff0000001e6ull)) {
 			ret = 0;
@@ -962,6 +956,127 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
+static int next_segment(unsigned long len, int offset)
+{
+	if (len > PAGE_SIZE - offset)
+		return PAGE_SIZE - offset;
+	else
+		return len;
+}
+
+int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
+			int len)
+{
+	void *page_virt;
+	struct page *page;
+
+	page = gfn_to_page(kvm, gfn);
+	if (!page)
+		return -EFAULT;
+	page_virt = kmap_atomic(page, KM_USER0);
+
+	memcpy(data, page_virt + offset, len);
+
+	kunmap_atomic(page_virt, KM_USER0);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_read_guest_page);
+
+int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len)
+{
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	int seg;
+	int offset = offset_in_page(gpa);
+	int ret;
+
+	while ((seg = next_segment(len, offset)) != 0) {
+		ret = kvm_read_guest_page(kvm, gfn, data, offset, seg);
+		if (ret < 0)
+			return ret;
+		offset = 0;
+		len -= seg;
+		data += seg;
+		++gfn;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_read_guest);
+
+int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn, const void *data,
+			 int offset, int len)
+{
+	void *page_virt;
+	struct page *page;
+
+	page = gfn_to_page(kvm, gfn);
+	if (!page)
+		return -EFAULT;
+	page_virt = kmap_atomic(page, KM_USER0);
+
+	memcpy(page_virt + offset, data, len);
+
+	kunmap_atomic(page_virt, KM_USER0);
+	mark_page_dirty(kvm, gfn);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_write_guest_page);
+
+int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
+		    unsigned long len)
+{
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	int seg;
+	int offset = offset_in_page(gpa);
+	int ret;
+
+	while ((seg = next_segment(len, offset)) != 0) {
+		ret = kvm_write_guest_page(kvm, gfn, data, offset, seg);
+		if (ret < 0)
+			return ret;
+		offset = 0;
+		len -= seg;
+		data += seg;
+		++gfn;
+	}
+	return 0;
+}
+
+int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len)
+{
+	void *page_virt;
+	struct page *page;
+
+	page = gfn_to_page(kvm, gfn);
+	if (!page)
+		return -EFAULT;
+	page_virt = kmap_atomic(page, KM_USER0);
+
+	memset(page_virt + offset, 0, len);
+
+	kunmap_atomic(page_virt, KM_USER0);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_clear_guest_page);
+
+int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
+{
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	int seg;
+	int offset = offset_in_page(gpa);
+	int ret;
+
+        while ((seg = next_segment(len, offset)) != 0) {
+		ret = kvm_clear_guest_page(kvm, gfn, offset, seg);
+		if (ret < 0)
+			return ret;
+		offset = 0;
+		len -= seg;
+		++gfn;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_clear_guest);
+
 /* WARNING: Does not work on aliased pages. */
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 {
@@ -988,21 +1103,13 @@ int emulator_read_std(unsigned long addr,
 		gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
 		unsigned offset = addr & (PAGE_SIZE-1);
 		unsigned tocopy = min(bytes, (unsigned)PAGE_SIZE - offset);
-		unsigned long pfn;
-		struct page *page;
-		void *page_virt;
+		int ret;
 
 		if (gpa == UNMAPPED_GVA)
 			return X86EMUL_PROPAGATE_FAULT;
-		pfn = gpa >> PAGE_SHIFT;
-		page = gfn_to_page(vcpu->kvm, pfn);
-		if (!page)
+		ret = kvm_read_guest(vcpu->kvm, gpa, data, tocopy);
+		if (ret < 0)
 			return X86EMUL_UNHANDLEABLE;
-		page_virt = kmap_atomic(page, KM_USER0);
-
-		memcpy(data, page_virt + offset, tocopy);
-
-		kunmap_atomic(page_virt, KM_USER0);
 
 		bytes -= tocopy;
 		data += tocopy;
@@ -1095,19 +1202,12 @@ static int emulator_read_emulated(unsigned long addr,
 static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 			       const void *val, int bytes)
 {
-	struct page *page;
-	void *virt;
+	int ret;
 
-	if (((gpa + bytes - 1) >> PAGE_SHIFT) != (gpa >> PAGE_SHIFT))
-		return 0;
-	page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
-	if (!page)
+	ret = kvm_write_guest(vcpu->kvm, gpa, val, bytes);
+	if (ret < 0)
 		return 0;
-	mark_page_dirty(vcpu->kvm, gpa >> PAGE_SHIFT);
-	virt = kmap_atomic(page, KM_USER0);
 	kvm_mmu_pte_write(vcpu, gpa, val, bytes);
-	memcpy(virt + offset_in_page(gpa), val, bytes);
-	kunmap_atomic(virt, KM_USER0);
 	return 1;
 }
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index c87f52b..ce15e51 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1387,33 +1387,28 @@ static void vmx_set_gdt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
 
 static int init_rmode_tss(struct kvm* kvm)
 {
-	struct page *p1, *p2, *p3;
 	gfn_t fn = rmode_tss_base(kvm) >> PAGE_SHIFT;
-	char *page;
-
-	p1 = gfn_to_page(kvm, fn++);
-	p2 = gfn_to_page(kvm, fn++);
-	p3 = gfn_to_page(kvm, fn);
+	u16 data = 0;
+	int r;
 
-	if (!p1 || !p2 || !p3) {
-		kvm_printf(kvm,"%s: gfn_to_page failed\n", __FUNCTION__);
+	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE);
+	if (r < 0)
+		return 0;
+	data = TSS_BASE_SIZE + TSS_REDIRECTION_SIZE;
+	r = kvm_write_guest_page(kvm, fn++, &data, 0x66, sizeof(u16));
+	if (r < 0)
+		return 0;
+	r = kvm_clear_guest_page(kvm, fn++, 0, PAGE_SIZE);
+	if (r < 0)
+		return 0;
+	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE);
+	if (r < 0)
+		return 0;
+	data = ~0;
+	r = kvm_write_guest_page(kvm, fn, &data, RMODE_TSS_SIZE - 2 * PAGE_SIZE - 1,
+			sizeof(u8));
+	if (r < 0)
 		return 0;
-	}
-
-	page = kmap_atomic(p1, KM_USER0);
-	clear_page(page);
-	*(u16*)(page + 0x66) = TSS_BASE_SIZE + TSS_REDIRECTION_SIZE;
-	kunmap_atomic(page, KM_USER0);
-
-	page = kmap_atomic(p2, KM_USER0);
-	clear_page(page);
-	kunmap_atomic(page, KM_USER0);
-
-	page = kmap_atomic(p3, KM_USER0);
-	clear_page(page);
-	*(page + RMODE_TSS_SIZE - 2 * PAGE_SIZE - 1) = ~0;
-	kunmap_atomic(page, KM_USER0);
-
 	return 1;
 }
 
-- 
1.5.3.7

