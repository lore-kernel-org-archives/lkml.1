Return-Path: <linux-kernel-owner+w=401wt.eu-S1759849AbZDWHwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759849AbZDWHwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757283AbZDWHds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:33:48 -0400
Received: from sous-sol.org ([216.99.217.87]:50984 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755383AbZDWHdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:33:47 -0400
Message-Id: <20090423073006.598560092@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:46 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, chrisw@redhat.com
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
       alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com,
       Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 086/100] KVM: MMU: handle compound pages in kvm_is_mmio_pfn
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=kvm-mmu-handle-compound-pages-in-kvm_is_mmio_pfn.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Joerg Roedel <joerg.roedel@amd.com>

upstream commit: fc5659c8c6b6c4e02ac354b369017c1bf231f347

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
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 virt/kvm/kvm_main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -581,8 +581,10 @@ static inline int valid_vcpu(int n)
 
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

