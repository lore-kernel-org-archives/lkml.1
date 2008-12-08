Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654AbYLHLjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbYLHLjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYLHLhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:37:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48261 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbYLHLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 20/45] KVM: Add local get_mtrr_type() to support MTRR
Date: Mon,  8 Dec 2008 13:36:31 +0200
Message-Id: <1228736216-15787-21-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

For EPT memory type support.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |  104 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 104 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 410ddbc..ac2304f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1393,6 +1393,110 @@ struct page *gva_to_page(struct kvm_vcpu *vcpu, gva_t gva)
 	return page;
 }
 
+/*
+ * The function is based on mtrr_type_lookup() in
+ * arch/x86/kernel/cpu/mtrr/generic.c
+ */
+static int get_mtrr_type(struct mtrr_state_type *mtrr_state,
+			 u64 start, u64 end)
+{
+	int i;
+	u64 base, mask;
+	u8 prev_match, curr_match;
+	int num_var_ranges = KVM_NR_VAR_MTRR;
+
+	if (!mtrr_state->enabled)
+		return 0xFF;
+
+	/* Make end inclusive end, instead of exclusive */
+	end--;
+
+	/* Look in fixed ranges. Just return the type as per start */
+	if (mtrr_state->have_fixed && (start < 0x100000)) {
+		int idx;
+
+		if (start < 0x80000) {
+			idx = 0;
+			idx += (start >> 16);
+			return mtrr_state->fixed_ranges[idx];
+		} else if (start < 0xC0000) {
+			idx = 1 * 8;
+			idx += ((start - 0x80000) >> 14);
+			return mtrr_state->fixed_ranges[idx];
+		} else if (start < 0x1000000) {
+			idx = 3 * 8;
+			idx += ((start - 0xC0000) >> 12);
+			return mtrr_state->fixed_ranges[idx];
+		}
+	}
+
+	/*
+	 * Look in variable ranges
+	 * Look of multiple ranges matching this address and pick type
+	 * as per MTRR precedence
+	 */
+	if (!(mtrr_state->enabled & 2))
+		return mtrr_state->def_type;
+
+	prev_match = 0xFF;
+	for (i = 0; i < num_var_ranges; ++i) {
+		unsigned short start_state, end_state;
+
+		if (!(mtrr_state->var_ranges[i].mask_lo & (1 << 11)))
+			continue;
+
+		base = (((u64)mtrr_state->var_ranges[i].base_hi) << 32) +
+		       (mtrr_state->var_ranges[i].base_lo & PAGE_MASK);
+		mask = (((u64)mtrr_state->var_ranges[i].mask_hi) << 32) +
+		       (mtrr_state->var_ranges[i].mask_lo & PAGE_MASK);
+
+		start_state = ((start & mask) == (base & mask));
+		end_state = ((end & mask) == (base & mask));
+		if (start_state != end_state)
+			return 0xFE;
+
+		if ((start & mask) != (base & mask))
+			continue;
+
+		curr_match = mtrr_state->var_ranges[i].base_lo & 0xff;
+		if (prev_match == 0xFF) {
+			prev_match = curr_match;
+			continue;
+		}
+
+		if (prev_match == MTRR_TYPE_UNCACHABLE ||
+		    curr_match == MTRR_TYPE_UNCACHABLE)
+			return MTRR_TYPE_UNCACHABLE;
+
+		if ((prev_match == MTRR_TYPE_WRBACK &&
+		     curr_match == MTRR_TYPE_WRTHROUGH) ||
+		    (prev_match == MTRR_TYPE_WRTHROUGH &&
+		     curr_match == MTRR_TYPE_WRBACK)) {
+			prev_match = MTRR_TYPE_WRTHROUGH;
+			curr_match = MTRR_TYPE_WRTHROUGH;
+		}
+
+		if (prev_match != curr_match)
+			return MTRR_TYPE_UNCACHABLE;
+	}
+
+	if (prev_match != 0xFF)
+		return prev_match;
+
+	return mtrr_state->def_type;
+}
+
+static u8 get_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	u8 mtrr;
+
+	mtrr = get_mtrr_type(&vcpu->arch.mtrr_state, gfn << PAGE_SHIFT,
+			     (gfn << PAGE_SHIFT) + PAGE_SIZE);
+	if (mtrr == 0xfe || mtrr == 0xff)
+		mtrr = MTRR_TYPE_WRBACK;
+	return mtrr;
+}
+
 static int kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
 	unsigned index;
-- 
1.6.0.3

