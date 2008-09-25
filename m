Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbYIYMHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbYIYMHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbYIYL4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:56:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48583 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946AbYIYLz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:59 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 23/39] KVM: MMU: Unify direct map 4K and large page paths
Date: Thu, 25 Sep 2008 14:54:55 +0300
Message-Id: <1222343711-12508-24-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

The two paths are equivalent except for one argument, which is already
available.  Merge the two codepaths.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 51d4cd7..3ee856f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1240,15 +1240,10 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 		ASSERT(VALID_PAGE(table_addr));
 		table = __va(table_addr);
 
-		if (level == 1) {
+		if (level == 1 || (largepage && level == 2)) {
 			mmu_set_spte(vcpu, &table[index], ACC_ALL, ACC_ALL,
-				     0, write, 1, &pt_write, 0, gfn, pfn, false);
-			return pt_write;
-		}
-
-		if (largepage && level == 2) {
-			mmu_set_spte(vcpu, &table[index], ACC_ALL, ACC_ALL,
-				     0, write, 1, &pt_write, 1, gfn, pfn, false);
+				     0, write, 1, &pt_write, largepage,
+				     gfn, pfn, false);
 			return pt_write;
 		}
 
-- 
1.6.0.1

