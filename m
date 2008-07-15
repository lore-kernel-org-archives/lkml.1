Return-Path: <linux-kernel-owner+w=401wt.eu-S1761367AbYGOMRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbYGOMRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757503AbYGOMM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:12:56 -0400
Received: from il.qumranet.com ([212.179.150.194]:30358 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756160AbYGOMMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:12:43 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 19/19] KVM: MMU: Fix potential race setting upper shadow ptes on nonpae hosts
Date: Tue, 15 Jul 2008 15:12:38 +0300
Message-Id: <1216123958-10717-20-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1216123958-10717-1-git-send-email-avi@qumranet.com>
References: <1216123958-10717-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The direct mapped shadow code (used for real mode and two dimensional paging)
sets upper-level ptes using direct assignment rather than calling
set_shadow_pte().  A nonpae host will split this into two writes, which opens
up a race if another vcpu accesses the same memory area.

Fix by calling set_shadow_pte() instead of assigning directly.

Noticed by Izik Eidus.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 7f57da6..b0e4ddc 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1189,9 +1189,10 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 				return -ENOMEM;
 			}
 
-			table[index] = __pa(new_table->spt)
-				| PT_PRESENT_MASK | PT_WRITABLE_MASK
-				| shadow_user_mask | shadow_x_mask;
+			set_shadow_pte(&table[index],
+				       __pa(new_table->spt)
+				       | PT_PRESENT_MASK | PT_WRITABLE_MASK
+				       | shadow_user_mask | shadow_x_mask);
 		}
 		table_addr = table[index] & PT64_BASE_ADDR_MASK;
 	}
-- 
1.5.6.1

