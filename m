Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbYBGMtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbYBGMtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:49:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbYBGMs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:48:27 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:1602 "EHLO
	outbound6-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755558AbYBGMsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:48:24 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>
cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 5/8] MMU: make the __nonpaging_map function generic
Date: Thu,  7 Feb 2008 13:47:42 +0100
Message-ID: <1202388465-8657-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202388465-8657-1-git-send-email-joerg.roedel@amd.com>
References: <1202388465-8657-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Feb 2008 12:47:45.0751 (UTC)
 FILETIME=[A3134670:01C86987]
MIME-Version: 1.0
X-WSS-ID: 6BB421852IW10730682-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mapping function for the nonpaging case in the softmmu does basically the
same as required for Nested Paging. Make this function generic so it can be
used for both.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3477395..5e76963 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -965,10 +965,9 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 {
 }
 
-static int __nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write,
-			   gfn_t gfn, struct page *page)
+static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
+			   gfn_t gfn, struct page *page, int level)
 {
-	int level = PT32E_ROOT_LEVEL;
 	hpa_t table_addr = vcpu->arch.mmu.root_hpa;
 	int pt_write = 0;
 
@@ -1026,7 +1025,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 	kvm_mmu_free_some_pages(vcpu);
-	r = __nonpaging_map(vcpu, v, write, gfn, page);
+	r = __direct_map(vcpu, v, write, gfn, page, PT32E_ROOT_LEVEL);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 	up_read(&current->mm->mmap_sem);
-- 
1.5.3.7



