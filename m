Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbYAAPxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbYAAPxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbYAAPhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:37:11 -0500
Received: from il.qumranet.com ([82.166.9.18]:33799 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197AbYAAPga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:30 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 44/54] KVM: MMU: Move pte access calculation into a helper function
Date: Tue,  1 Jan 2008 17:36:10 +0200
Message-Id: <1199201780-14001-45-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 59ba752..1fc4f9b 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -102,6 +102,18 @@ static bool FNAME(cmpxchg_gpte)(struct kvm *kvm,
 	return (ret != orig_pte);
 }
 
+static unsigned FNAME(gpte_access)(struct kvm_vcpu *vcpu, pt_element_t gpte)
+{
+	unsigned access;
+
+	access = (gpte & (PT_WRITABLE_MASK | PT_USER_MASK)) | ACC_EXEC_MASK;
+#if PTTYPE == 64
+	if (is_nx(vcpu))
+		access &= ~(gpte >> PT64_NX_SHIFT);
+#endif
+	return access;
+}
+
 /*
  * Fetch a guest pte for a guest virtual address
  */
@@ -166,13 +178,7 @@ walk:
 			pte |= PT_ACCESSED_MASK;
 		}
 
-		pte_access = pte & (PT_WRITABLE_MASK | PT_USER_MASK);
-		pte_access |= ACC_EXEC_MASK;
-#if PTTYPE == 64
-		if (is_nx(vcpu))
-			pte_access &= ~(pte >> PT64_NX_SHIFT);
-#endif
-		pte_access &= pt_access;
+		pte_access = pt_access & FNAME(gpte_access)(vcpu, pte);
 
 		if (walker->level == PT_PAGE_TABLE_LEVEL) {
 			walker->gfn = gpte_to_gfn(pte);
-- 
1.5.3.7

