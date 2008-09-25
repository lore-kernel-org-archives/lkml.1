Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbYIYMG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbYIYMG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbYIYL4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:56:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48614 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821AbYIYL4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:56:21 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 35/39] KVM: MMU: Fix setting the accessed bit on non-speculative sptes
Date: Thu, 25 Sep 2008 14:55:07 +0300
Message-Id: <1222343711-12508-36-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

The accessed bit was accidentally turned on in a random flag word, rather
than, the spte itself, which was lucky, since it used the non-EPT compatible
PT_ACCESSED_MASK.

Fix by turning the bit on in the spte and changing it to use the portable
accessed mask.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 853a288..866d713 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1192,7 +1192,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 	 */
 	spte = shadow_base_present_pte | shadow_dirty_mask;
 	if (!speculative)
-		pte_access |= PT_ACCESSED_MASK;
+		spte |= shadow_accessed_mask;
 	if (!dirty)
 		pte_access &= ~ACC_WRITE_MASK;
 	if (pte_access & ACC_EXEC_MASK)
-- 
1.6.0.1

