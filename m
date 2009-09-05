Return-Path: <linux-kernel-owner+w=401wt.eu-S934642AbZIEAbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934642AbZIEAbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933789AbZIEAbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:31:37 -0400
Received: from kroah.org ([198.145.64.141]:42162 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934611AbZIEAU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:52 2009
Message-Id: <20090905001452.190682246@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, avi@redhat.com
Subject: [patch 31/71] KVM: MMU: handle n_free_mmu_pages > n_alloc_mmu_pages in kvm_mmu_change_mmu_pages
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=kvm-mmu-handle-n_free_mmu_pages-n_alloc_mmu_pages-in-kvm_mmu_change_mmu_pages.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Marcelo Tosatti <mtosatti@redhat.com>

(cherry picked from commit 025dbbf36a7680bffe54d9dcbf0a8bc01a7cbd10)

kvm_mmu_change_mmu_pages mishandles the case where n_alloc_mmu_pages is
smaller then n_free_mmu_pages, by not checking if the result of
the subtraction is negative.

Its a valid condition which can happen if a large number of pages has
been recently freed.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/mmu.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1417,24 +1417,25 @@ static int kvm_mmu_zap_page(struct kvm *
  */
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages)
 {
+	int used_pages;
+
+	used_pages = kvm->arch.n_alloc_mmu_pages - kvm->arch.n_free_mmu_pages;
+	used_pages = max(0, used_pages);
+
 	/*
 	 * If we set the number of mmu pages to be smaller be than the
 	 * number of actived pages , we must to free some mmu pages before we
 	 * change the value
 	 */
 
-	if ((kvm->arch.n_alloc_mmu_pages - kvm->arch.n_free_mmu_pages) >
-	    kvm_nr_mmu_pages) {
-		int n_used_mmu_pages = kvm->arch.n_alloc_mmu_pages
-				       - kvm->arch.n_free_mmu_pages;
-
-		while (n_used_mmu_pages > kvm_nr_mmu_pages) {
+	if (used_pages > kvm_nr_mmu_pages) {
+		while (used_pages > kvm_nr_mmu_pages) {
 			struct kvm_mmu_page *page;
 
 			page = container_of(kvm->arch.active_mmu_pages.prev,
 					    struct kvm_mmu_page, link);
 			kvm_mmu_zap_page(kvm, page);
-			n_used_mmu_pages--;
+			used_pages--;
 		}
 		kvm->arch.n_free_mmu_pages = 0;
 	}


