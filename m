Return-Path: <linux-kernel-owner+w=401wt.eu-S964818AbZIEAVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818AbZIEAVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964804AbZIEAV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:21:27 -0400
Received: from kroah.org ([198.145.64.141]:42168 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964784AbZIEAU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:57 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:52 2009
Message-Id: <20090905001452.322385146@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, avi@redhat.com
Subject: [patch 32/71] [stable] [PATCH 14/16] KVM: MMU: limit rmap chain length
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=kvm-mmu-limit-rmap-chain-length.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Marcelo Tosatti <mtosatti@redhat.com>

(cherry picked from commit 53a27b39ff4d2492f84b1fdc2f0047175f0b0b93)

Otherwise the host can spend too long traversing an rmap chain, which
happens under a spinlock.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/mmu.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -490,16 +490,20 @@ static unsigned long *gfn_to_rmap(struct
  *
  * If rmapp bit zero is one, (then rmap & ~1) points to a struct kvm_rmap_desc
  * containing more mappings.
+ *
+ * Returns the number of rmap entries before the spte was added or zero if
+ * the spte was not added.
+ *
  */
-static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn, int lpage)
+static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn, int lpage)
 {
 	struct kvm_mmu_page *sp;
 	struct kvm_rmap_desc *desc;
 	unsigned long *rmapp;
-	int i;
+	int i, count = 0;
 
 	if (!is_rmap_pte(*spte))
-		return;
+		return count;
 	gfn = unalias_gfn(vcpu->kvm, gfn);
 	sp = page_header(__pa(spte));
 	sp->gfns[spte - sp->spt] = gfn;
@@ -516,8 +520,10 @@ static void rmap_add(struct kvm_vcpu *vc
 	} else {
 		rmap_printk("rmap_add: %p %llx many->many\n", spte, *spte);
 		desc = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
-		while (desc->shadow_ptes[RMAP_EXT-1] && desc->more)
+		while (desc->shadow_ptes[RMAP_EXT-1] && desc->more) {
 			desc = desc->more;
+			count += RMAP_EXT;
+		}
 		if (desc->shadow_ptes[RMAP_EXT-1]) {
 			desc->more = mmu_alloc_rmap_desc(vcpu);
 			desc = desc->more;
@@ -526,6 +532,7 @@ static void rmap_add(struct kvm_vcpu *vc
 			;
 		desc->shadow_ptes[i] = spte;
 	}
+	return count;
 }
 
 static void rmap_desc_remove_entry(unsigned long *rmapp,
@@ -755,6 +762,19 @@ static int kvm_age_rmapp(struct kvm *kvm
 	return young;
 }
 
+#define RMAP_RECYCLE_THRESHOLD 1000
+
+static void rmap_recycle(struct kvm_vcpu *vcpu, gfn_t gfn, int lpage)
+{
+	unsigned long *rmapp;
+
+	gfn = unalias_gfn(vcpu->kvm, gfn);
+	rmapp = gfn_to_rmap(vcpu->kvm, gfn, lpage);
+
+	kvm_unmap_rmapp(vcpu->kvm, rmapp);
+	kvm_flush_remote_tlbs(vcpu->kvm);
+}
+
 int kvm_age_hva(struct kvm *kvm, unsigned long hva)
 {
 	return kvm_handle_hva(kvm, hva, kvm_age_rmapp);
@@ -1771,6 +1791,7 @@ static void mmu_set_spte(struct kvm_vcpu
 {
 	int was_rmapped = 0;
 	int was_writeble = is_writeble_pte(*shadow_pte);
+	int rmap_count;
 
 	pgprintk("%s: spte %llx access %x write_fault %d"
 		 " user_fault %d gfn %lx\n",
@@ -1812,9 +1833,11 @@ static void mmu_set_spte(struct kvm_vcpu
 
 	page_header_update_slot(vcpu->kvm, shadow_pte, gfn);
 	if (!was_rmapped) {
-		rmap_add(vcpu, shadow_pte, gfn, largepage);
+		rmap_count = rmap_add(vcpu, shadow_pte, gfn, largepage);
 		if (!is_rmap_pte(*shadow_pte))
 			kvm_release_pfn_clean(pfn);
+		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
+			rmap_recycle(vcpu, gfn, largepage);
 	} else {
 		if (was_writeble)
 			kvm_release_pfn_dirty(pfn);


