Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbZBRNY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbZBRNY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 08:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZBRNYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 08:24:15 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:2989 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751492AbZBRNYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 08:24:14 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Feb 2009 08:24:14 EST
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KF9J72-03-C6N-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/3] kvm mmu: handle compound pages in kvm_is_mmio_pfn
Date: Wed, 18 Feb 2009 14:08:58 +0100
Message-ID: <1234962540-7131-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1234962540-7131-1-git-send-email-joerg.roedel@amd.com>
References: <1234962540-7131-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 18 Feb 2009 13:09:00.0194 (UTC) FILETIME=[106F9820:01C991CA]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function kvm_is_mmio_pfn is called before put_page is called on a
page by KVM. This is a problem when when this function is called on some
struct page which is part of a compund page. It does not test the
reserved flag of the compound page but of the struct page within the
compount page. This is a problem when KVM works with hugepages allocated
at boot time. These pages have the reserved bit set in all tail pages.
Only the flag in the compount head is cleared. KVM would not put such a
page which results in a memory leak.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
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
1.5.6.4


