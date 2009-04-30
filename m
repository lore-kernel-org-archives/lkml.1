Return-Path: <linux-kernel-owner+w=401wt.eu-S933186AbZD3RdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186AbZD3RdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764660AbZD3RIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:18 -0400
Received: from kroah.org ([198.145.64.141]:56713 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764628AbZD3RIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:04 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:46 2009
Message-Id: <20090430165746.828420780@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com, avi@redhat.com,
       Sheng Yang <sheng@linux.intel.com>
Subject: [patch 57/88] KVM: MMU: Extend kvm_mmu_page->slot_bitmap size
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=kvm-mmu-extend-kvm_mmu_page-slot_bitmap-size.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sheng Yang <sheng@linux.intel.com>

(cherry picked from 291f26bc0f89518ad7ee3207c09eb8a743ac8fcc)

Otherwise set_bit() for private memory slot(above KVM_MEMORY_SLOTS) would
corrupted memory in 32bit host.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/include/asm/kvm_host.h |    8 +++++---
 arch/x86/kvm/mmu.c              |    6 +++---
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -190,9 +190,11 @@ struct kvm_mmu_page {
 	u64 *spt;
 	/* hold the gfn of each spte inside spt */
 	gfn_t *gfns;
-	unsigned long slot_bitmap; /* One bit set per slot which has memory
-				    * in this shadow page.
-				    */
+	/*
+	 * One bit set per slot which has memory
+	 * in this shadow page.
+	 */
+	DECLARE_BITMAP(slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
 	int multimapped;         /* More than one parent_pte? */
 	int root_count;          /* Currently serving as active root */
 	bool unsync;
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -787,7 +787,7 @@ static struct kvm_mmu_page *kvm_mmu_allo
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
 	ASSERT(is_empty_shadow_page(sp->spt));
-	sp->slot_bitmap = 0;
+	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
 	sp->multimapped = 0;
 	sp->parent_pte = parent_pte;
 	--vcpu->kvm->arch.n_free_mmu_pages;
@@ -1362,7 +1362,7 @@ static void page_header_update_slot(stru
 	int slot = memslot_id(kvm, gfn_to_memslot(kvm, gfn));
 	struct kvm_mmu_page *sp = page_header(__pa(pte));
 
-	__set_bit(slot, &sp->slot_bitmap);
+	__set_bit(slot, sp->slot_bitmap);
 }
 
 static void mmu_convert_notrap(struct kvm_mmu_page *sp)
@@ -2451,7 +2451,7 @@ void kvm_mmu_slot_remove_write_access(st
 		int i;
 		u64 *pt;
 
-		if (!test_bit(slot, &sp->slot_bitmap))
+		if (!test_bit(slot, sp->slot_bitmap))
 			continue;
 
 		pt = sp->spt;


