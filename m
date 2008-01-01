Return-Path: <linux-kernel-owner+w=401wt.eu-S1758824AbYAAPte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbYAAPte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbYAAPg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:56 -0500
Received: from il.qumranet.com ([82.166.9.18]:33802 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755188AbYAAPga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:30 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 43/54] KVM: MMU: Set nx bit correctly on shadow ptes
Date: Tue,  1 Jan 2008 17:36:09 +0200
Message-Id: <1199201780-14001-44-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While the page table walker correctly generates a guest page fault
if a guest tries to execute a non-executable page, the shadow code does
not mark it non-executable.  This means that if a guest accesses an nx
page first with a read access, then subsequent code fetch accesses will
succeed.

Fix by setting the nx bit on shadow ptes.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 7688cbf..59ba752 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -255,6 +255,8 @@ static void FNAME(set_pte)(struct kvm_vcpu *vcpu, pt_element_t gpte,
 	spte |= gpte & PT64_NX_MASK;
 	if (!dirty)
 		pte_access &= ~ACC_WRITE_MASK;
+	if (!(pte_access & ACC_EXEC_MASK))
+		spte |= PT64_NX_MASK;
 
 	page = gfn_to_page(vcpu->kvm, gfn);
 
-- 
1.5.3.7

