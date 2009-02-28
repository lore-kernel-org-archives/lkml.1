Return-Path: <linux-kernel-owner+w=401wt.eu-S1762894AbZB1BvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762894AbZB1BvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757004AbZB1Bmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41788 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839AbZB1Bl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:59 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 20/30] KVM: MMU: Fix another largepage memory leak
Date: Sat, 28 Feb 2009 03:41:39 +0200
Message-Id: <1235785309-12835-21-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

In the paging_fetch function rmap_remove is called after setting a large
pte to non-present. This causes rmap_remove to not drop the reference to
the large page. The result is a memory leak of that page.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/paging_tmpl.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 7314c09..0f11792 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -306,9 +306,9 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			continue;
 
 		if (is_large_pte(*sptep)) {
+			rmap_remove(vcpu->kvm, sptep);
 			set_shadow_pte(sptep, shadow_trap_nonpresent_pte);
 			kvm_flush_remote_tlbs(vcpu->kvm);
-			rmap_remove(vcpu->kvm, sptep);
 		}
 
 		if (level == PT_DIRECTORY_LEVEL
-- 
1.6.0.6

