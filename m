Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbYAAPiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbYAAPiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbYAAPg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:28 -0500
Received: from il.qumranet.com ([82.166.9.18]:33788 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbYAAPgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:24 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 08/54] KVM: Portability: Move unalias_gfn to arch dependent file
Date: Tue,  1 Jan 2008 17:35:34 +0200
Message-Id: <1199201780-14001-9-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Non-x86 archs don't need this mechanism. Move it to arch, and
keep its interface in common.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   14 --------------
 drivers/kvm/x86.c      |   14 ++++++++++++++
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index a9e1c77..003a43c 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -408,20 +408,6 @@ int kvm_is_error_hva(unsigned long addr)
 }
 EXPORT_SYMBOL_GPL(kvm_is_error_hva);
 
-gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
-{
-	int i;
-	struct kvm_mem_alias *alias;
-
-	for (i = 0; i < kvm->naliases; ++i) {
-		alias = &kvm->aliases[i];
-		if (gfn >= alias->base_gfn
-		    && gfn < alias->base_gfn + alias->npages)
-			return alias->target_gfn + gfn - alias->base_gfn;
-	}
-	return gfn;
-}
-
 static struct kvm_memory_slot *__gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 7237cb2..2be5936 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -1119,6 +1119,20 @@ static int kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
 	return kvm->n_alloc_mmu_pages;
 }
 
+gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
+{
+	int i;
+	struct kvm_mem_alias *alias;
+
+	for (i = 0; i < kvm->naliases; ++i) {
+		alias = &kvm->aliases[i];
+		if (gfn >= alias->base_gfn
+		    && gfn < alias->base_gfn + alias->npages)
+			return alias->target_gfn + gfn - alias->base_gfn;
+	}
+	return gfn;
+}
+
 /*
  * Set a new alias region.  Aliases map a portion of physical memory into
  * another portion.  This is useful for memory windows, for example the PC
-- 
1.5.3.7

