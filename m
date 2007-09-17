Return-Path: <linux-kernel-owner+w=401wt.eu-S1760319AbXIQJGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760319AbXIQJGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbXIQIeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:34:12 -0400
Received: from il.qumranet.com ([82.166.9.18]:45250 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbXIQIcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:25 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 023/104] KVM: load_pdptrs() cleanups
Date: Mon, 17 Sep 2007 10:31:05 +0200
Message-Id: <11900179471537-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

load_pdptrs can be handed an invalid cr3, and it should not oops.
This can happen because we injected #gp in set_cr3() after we set
vcpu->cr3 to the invalid value, or from kvm_vcpu_ioctl_set_sregs(), or
memory configuration changes after the guest did set_cr3().

We should also copy the pdpte array once, before checking and
assigning, otherwise an SMP guest can potentially alter the values
between the check and the set.

Finally one nitpick: ret = 1 should be done as late as possible: this
allows GCC to check for unset "ret" should the function change in
future.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 80ee427..65c9a31 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -442,30 +442,32 @@ static int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 	gfn_t pdpt_gfn = cr3 >> PAGE_SHIFT;
 	unsigned offset = ((cr3 & (PAGE_SIZE-1)) >> 5) << 2;
 	int i;
-	u64 pdpte;
 	u64 *pdpt;
 	int ret;
 	struct page *page;
+	u64 pdpte[ARRAY_SIZE(vcpu->pdptrs)];
 
 	spin_lock(&vcpu->kvm->lock);
 	page = gfn_to_page(vcpu->kvm, pdpt_gfn);
-	/* FIXME: !page - emulate? 0xff? */
+	if (!page) {
+		ret = 0;
+		goto out;
+	}
+
 	pdpt = kmap_atomic(page, KM_USER0);
+	memcpy(pdpte, pdpt+offset, sizeof(pdpte));
+	kunmap_atomic(pdpt, KM_USER0);
 
-	ret = 1;
-	for (i = 0; i < 4; ++i) {
-		pdpte = pdpt[offset + i];
-		if ((pdpte & 1) && (pdpte & 0xfffffff0000001e6ull)) {
+	for (i = 0; i < ARRAY_SIZE(pdpte); ++i) {
+		if ((pdpte[i] & 1) && (pdpte[i] & 0xfffffff0000001e6ull)) {
 			ret = 0;
 			goto out;
 		}
 	}
+	ret = 1;
 
-	for (i = 0; i < 4; ++i)
-		vcpu->pdptrs[i] = pdpt[offset + i];
-
+	memcpy(vcpu->pdptrs, pdpte, sizeof(vcpu->pdptrs));
 out:
-	kunmap_atomic(pdpt, KM_USER0);
 	spin_unlock(&vcpu->kvm->lock);
 
 	return ret;
-- 
1.5.3

