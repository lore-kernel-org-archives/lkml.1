Return-Path: <linux-kernel-owner+w=401wt.eu-S1760499AbYAYUz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760499AbYAYUz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760310AbYAYUyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:54:37 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:42884 "EHLO
	outbound7-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760248AbYAYUyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:54:35 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
cc: "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 5/8] MMU: make the __nonpaging_map function generic
Date: Fri, 25 Jan 2008 21:53:10 +0100
Message-ID: <1201294393-22613-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Jan 2008 20:53:14.0723 (UTC)
 FILETIME=[4DECEB30:01C85F94]
MIME-Version: 1.0
X-WSS-ID: 6B8493F62IW8829137-01-01
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
index 635e70c..dfbcf5e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -956,10 +956,9 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
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
 
@@ -1017,7 +1016,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 	kvm_mmu_free_some_pages(vcpu);
-	r = __nonpaging_map(vcpu, v, write, gfn, page);
+	r = __direct_map(vcpu, v, write, gfn, page, PT32E_ROOT_LEVEL);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 	up_read(&current->mm->mmap_sem);
-- 
1.5.3.7



