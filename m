Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbXL3HPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbXL3HPn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756313AbXL3HLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:01 -0500
Received: from il.qumranet.com ([82.166.9.18]:59485 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087AbXL3HKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:45 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <izike@qumranet.com>
Subject: [PATCH 19/52] KVM: Simplify kvm_clear_guest_page()
Date: Sun, 30 Dec 2007 09:10:05 +0200
Message-Id: <1198998638-22713-20-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

Use kvm_write_guest_page() with empty_zero_page, instead of doing
kmap and memset.

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index f9fd865..469e6b4 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -633,22 +633,7 @@ int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
 
 int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len)
 {
-	void *page_virt;
-	struct page *page;
-
-	page = gfn_to_page(kvm, gfn);
-	if (is_error_page(page)) {
-		kvm_release_page(page);
-		return -EFAULT;
-	}
-	page_virt = kmap_atomic(page, KM_USER0);
-
-	memset(page_virt + offset, 0, len);
-
-	kunmap_atomic(page_virt, KM_USER0);
-	kvm_release_page(page);
-	mark_page_dirty(kvm, gfn);
-	return 0;
+	return kvm_write_guest_page(kvm, gfn, empty_zero_page, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest_page);
 
-- 
1.5.3.7

