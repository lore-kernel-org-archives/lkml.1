Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbXLZLY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbXLZLY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbXLZLHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:07:13 -0500
Received: from il.qumranet.com ([82.166.9.18]:50469 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbXLZLGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:10 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <izike@qumranet.com>
Subject: [PATCH 46/55] KVM: Change kvm_{read,write}_guest() to use copy_{from,to}_user()
Date: Wed, 26 Dec 2007 13:05:51 +0200
Message-Id: <1198667160-22953-47-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

This changes kvm_write_guest_page/kvm_read_guest_page to use
copy_to_user/read_from_user, as a result we get better speed
and better dirty bit tracking.

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   38 ++++++++++++++------------------------
 1 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index d318c28..99ad04f 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -630,20 +630,15 @@ static int next_segment(unsigned long len, int offset)
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len)
 {
-	void *page_virt;
-	struct page *page;
+	int r;
+	unsigned long addr;
 
-	page = gfn_to_page(kvm, gfn);
-	if (is_error_page(page)) {
-		kvm_release_page(page);
+	addr = gfn_to_hva(kvm, gfn);
+	if (kvm_is_error_hva(addr))
+		return -EFAULT;
+	r = copy_from_user(data, (void __user *)addr + offset, len);
+	if (r)
 		return -EFAULT;
-	}
-	page_virt = kmap_atomic(page, KM_USER0);
-
-	memcpy(data, page_virt + offset, len);
-
-	kunmap_atomic(page_virt, KM_USER0);
-	kvm_release_page(page);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_page);
@@ -671,21 +666,16 @@ EXPORT_SYMBOL_GPL(kvm_read_guest);
 int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn, const void *data,
 			 int offset, int len)
 {
-	void *page_virt;
-	struct page *page;
+	int r;
+	unsigned long addr;
 
-	page = gfn_to_page(kvm, gfn);
-	if (is_error_page(page)) {
-		kvm_release_page(page);
+	addr = gfn_to_hva(kvm, gfn);
+	if (kvm_is_error_hva(addr))
+		return -EFAULT;
+	r = copy_to_user((void __user *)addr + offset, data, len);
+	if (r)
 		return -EFAULT;
-	}
-	page_virt = kmap_atomic(page, KM_USER0);
-
-	memcpy(page_virt + offset, data, len);
-
-	kunmap_atomic(page_virt, KM_USER0);
 	mark_page_dirty(kvm, gfn);
-	kvm_release_page(page);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_page);
-- 
1.5.3.7

