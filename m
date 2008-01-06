Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbYAFOpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbYAFOpy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758422AbYAFOkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:40:04 -0500
Received: from il.qumranet.com ([82.166.9.18]:46606 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907AbYAFOjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:47 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Eddie Dong <eddie.dong@intel.com>
Subject: [PATCH 21/33] KVM: MMU: Coalesce remote tlb flushes
Date: Sun,  6 Jan 2008 16:39:27 +0200
Message-Id: <1199630379-28638-22-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

Host side TLB flush can be merged together if multiple
spte need to be write-protected.

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 401eb7c..9a57e1a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -513,6 +513,7 @@ static void rmap_write_protect(struct kvm *kvm, u64 gfn)
 {
 	unsigned long *rmapp;
 	u64 *spte;
+	int write_protected = 0;
 
 	gfn = unalias_gfn(kvm, gfn);
 	rmapp = gfn_to_rmap(kvm, gfn);
@@ -522,11 +523,14 @@ static void rmap_write_protect(struct kvm *kvm, u64 gfn)
 		BUG_ON(!spte);
 		BUG_ON(!(*spte & PT_PRESENT_MASK));
 		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
-		if (is_writeble_pte(*spte))
+		if (is_writeble_pte(*spte)) {
 			set_shadow_pte(spte, *spte & ~PT_WRITABLE_MASK);
-		kvm_flush_remote_tlbs(kvm);
+			write_protected = 1;
+		}
 		spte = rmap_next(kvm, rmapp, spte);
 	}
+	if (write_protected)
+		kvm_flush_remote_tlbs(kvm);
 }
 
 #ifdef MMU_DEBUG
-- 
1.5.3.7

