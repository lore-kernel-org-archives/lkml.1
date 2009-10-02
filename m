Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbZJBUTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbZJBUTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757974AbZJBUTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:19:52 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:45117 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808AbZJBUTu (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Fri, 2 Oct 2009 16:19:50 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH v2 4/4] KVM: add scatterlist support to xinterface
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ghaskins@novell.com
Date: Fri, 02 Oct 2009 16:19:38 -0400
Message-ID: <20091002201937.4014.96148.stgit@dev.haskins.net>
In-Reply-To: <20091002201159.4014.33268.stgit@dev.haskins.net>
References: <20091002201159.4014.33268.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows a scatter-gather approach to IO, which will be useful for
building high performance interfaces, like zero-copy and low-latency
copy (avoiding multiple calls to copy_to/from).

The interface is based on the existing scatterlist infrastructure.  The
caller is expected to pass in a scatterlist with its "dma" field
populated with valid GPAs.  The xinterface will then populate each
entry by translating the GPA to a page*.

The caller signifies completion by simply performing a put_page() on
each page returned in the list.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/kvm_xinterface.h |    4 ++
 virt/kvm/xinterface.c          |   72 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm_xinterface.h b/include/linux/kvm_xinterface.h
index 684b6f8..eefb575 100644
--- a/include/linux/kvm_xinterface.h
+++ b/include/linux/kvm_xinterface.h
@@ -9,6 +9,7 @@
 #include <linux/kref.h>
 #include <linux/module.h>
 #include <linux/file.h>
+#include <linux/scatterlist.h>
 
 struct kvm_xinterface;
 struct kvm_xvmap;
@@ -36,6 +37,9 @@ struct kvm_xinterface_ops {
 					u64 addr,
 					unsigned long len,
 					unsigned long flags);
+	unsigned long (*sgmap)(struct kvm_xinterface *intf,
+			       struct scatterlist *sgl, int nents,
+			       unsigned long flags);
 	void (*release)(struct kvm_xinterface *);
 };
 
diff --git a/virt/kvm/xinterface.c b/virt/kvm/xinterface.c
index c356835..16729f6 100644
--- a/virt/kvm/xinterface.c
+++ b/virt/kvm/xinterface.c
@@ -467,6 +467,77 @@ fail:
 
 }
 
+static unsigned long
+xinterface_sgmap(struct kvm_xinterface *intf,
+		 struct scatterlist *sgl, int nents,
+		 unsigned long flags)
+{
+	struct _xinterface     *_intf   = to_intf(intf);
+	struct task_struct     *p       = _intf->task;
+	struct mm_struct       *mm      = _intf->mm;
+	struct kvm             *kvm     = _intf->kvm;
+	struct kvm_memory_slot *memslot = NULL;
+	bool                    kthread = !current->mm;
+	int                     ret;
+	struct scatterlist     *sg;
+	int                     i;
+
+	down_read(&kvm->slots_lock);
+
+	if (kthread)
+		use_mm(_intf->mm);
+
+	for_each_sg(sgl, sg, nents, i) {
+		unsigned long           gpa    = sg_dma_address(sg);
+		unsigned long           len    = sg_dma_len(sg);
+		unsigned long           gfn    = gpa >> PAGE_SHIFT;
+		off_t                   offset = offset_in_page(gpa);
+		unsigned long           hva;
+		struct page            *pg;
+
+		/* ensure that we do not have more than one page per entry */
+		if ((PAGE_ALIGN(len + offset) >> PAGE_SHIFT) != 1) {
+			ret = -EINVAL;
+			break;
+		}
+
+		/* check for a memslot-cache miss */
+		if (!memslot
+		    || gfn < memslot->base_gfn
+		    || gfn >= memslot->base_gfn + memslot->npages) {
+			memslot = gfn_to_memslot(kvm, gfn);
+			if (!memslot) {
+				ret = -EFAULT;
+				break;
+			}
+		}
+
+		hva = (memslot->userspace_addr +
+		       (gfn - memslot->base_gfn) * PAGE_SIZE);
+
+		if (kthread || current->mm == mm)
+			ret = get_user_pages_fast(hva, 1, 1, &pg);
+		else
+			ret = get_user_pages(p, mm, hva, 1, 1, 0, &pg, NULL);
+
+		if (ret != 1) {
+			if (ret >= 0)
+				ret = -EFAULT;
+			break;
+		}
+
+		sg_set_page(sg, pg, len, offset);
+		ret = 0;
+	}
+
+	if (kthread)
+		unuse_mm(_intf->mm);
+
+	up_read(&kvm->slots_lock);
+
+	return ret;
+}
+
 static void
 xinterface_release(struct kvm_xinterface *intf)
 {
@@ -483,6 +554,7 @@ struct kvm_xinterface_ops _xinterface_ops = {
 	.copy_from   = xinterface_copy_from,
 	.vmap        = xinterface_vmap,
 	.ioevent     = xinterface_ioevent,
+	.sgmap       = xinterface_sgmap,
 	.release     = xinterface_release,
 };
 

