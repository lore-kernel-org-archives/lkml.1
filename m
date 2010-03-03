Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab0CCTQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:16:25 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:11401
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753447Ab0CCTM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:12:59 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h6bh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYQ016-02-H56-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/18] KVM: MMU: Check for root_level instead of long mode
Date: Wed, 3 Mar 2010 20:12:04 +0100
Message-ID: <1267643541-451-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Mar 2010 19:12:42.0423 (UTC) FILETIME=[7FA4FC70:01CABB05]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The walk_addr function checks for !is_long_mode in its 64
bit version. But what is meant here is a check for pae
paging. Change the condition to really check for pae paging
so that it also works with nested nested paging.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/paging_tmpl.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 81eab9a..92b6bb5 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -128,7 +128,7 @@ walk:
 	walker->level = vcpu->arch.mmu.root_level;
 	pte = vcpu->arch.cr3;
 #if PTTYPE == 64
-	if (!is_long_mode(vcpu)) {
+	if (vcpu->arch.mmu.root_level == PT32E_ROOT_LEVEL) {
 		pte = kvm_pdptr_read(vcpu, (addr >> 30) & 3);
 		trace_kvm_mmu_paging_element(pte, walker->level);
 		if (!is_present_gpte(pte))
@@ -194,7 +194,7 @@ walk:
 				(PTTYPE == 64 || is_pse(vcpu))) ||
 		    ((walker->level == PT_PDPE_LEVEL) &&
 				(pte & PT_PAGE_SIZE_MASK)  &&
-				is_long_mode(vcpu))) {
+				vcpu->arch.mmu.root_level == PT64_ROOT_LEVEL)) {
 			int lvl = walker->level;
 
 			walker->gfn = gpte_to_gfn_lvl(pte, lvl);
-- 
1.7.0


