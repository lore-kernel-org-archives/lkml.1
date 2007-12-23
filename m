Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbXLWPDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbXLWPDw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbXLWOwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:22 -0500
Received: from il.qumranet.com ([82.166.9.18]:35897 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbXLWOvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:44 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 33/50] KVM: MMU: Disable write access on clean large pages
Date: Sun, 23 Dec 2007 16:51:18 +0200
Message-Id: <1198421495-31481-34-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By forcing clean huge pages to be read-only, we have separate roles
for the shadow of a clean large page and the shadow of a dirty large
page.  This is necessary because different ptes will be instantiated
for the two cases, even for read faults.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index e07cb2e..4538b15 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -382,6 +382,8 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			metaphysical = 1;
 			hugepage_access = walker->pte;
 			hugepage_access &= PT_USER_MASK | PT_WRITABLE_MASK;
+			if (!is_dirty_pte(walker->pte))
+				hugepage_access &= ~PT_WRITABLE_MASK;
 			hugepage_access >>= PT_WRITABLE_SHIFT;
 			if (walker->pte & PT64_NX_MASK)
 				hugepage_access |= (1 << 2);
-- 
1.5.3.7

