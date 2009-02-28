Return-Path: <linux-kernel-owner+w=401wt.eu-S932253AbZB1Bwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbZB1Bwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbZB1BnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:43:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41775 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448AbZB1Bl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:58 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/30] KVM: MMU: handle compound pages in kvm_is_mmio_pfn
Date: Sat, 28 Feb 2009 03:41:34 +0200
Message-Id: <1235785309-12835-16-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The function kvm_is_mmio_pfn is called before put_page is called on a
page by KVM. This is a problem when when this function is called on some
struct page which is part of a compund page. It does not test the
reserved flag of the compound page but of the struct page within the
compount page. This is a problem when KVM works with hugepages allocated
at boot time. These pages have the reserved bit set in all tail pages.
Only the flag in the compount head is cleared. KVM would not put such a
page which results in a memory leak.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 266bdaf..0ed662d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -535,8 +535,10 @@ static inline int valid_vcpu(int n)
 
 inline int kvm_is_mmio_pfn(pfn_t pfn)
 {
-	if (pfn_valid(pfn))
-		return PageReserved(pfn_to_page(pfn));
+	if (pfn_valid(pfn)) {
+		struct page *page = compound_head(pfn_to_page(pfn));
+		return PageReserved(page);
+	}
 
 	return true;
 }
-- 
1.6.0.6

