Return-Path: <linux-kernel-owner+w=401wt.eu-S1760079AbXFQJqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079AbXFQJqv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759244AbXFQJop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:45 -0400
Received: from il.qumranet.com ([82.166.9.18]:55154 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757980AbXFQJol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:41 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 06/58] KVM: Reduce misfirings of the fork detector
Date: Sun, 17 Jun 2007 12:43:47 +0300
Message-Id: <11820734803633-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The kvm mmu tries to detects forks by looking for repeated writes to a
page table.  If it sees a fork, it unshadows the page table so the page
table copying can proceed at native speed instead of being emulated.

However, the detector also triggered on simple demand paging access patterns:
a linear walk of memory would of course cause repeated writes to the same
pagetable page, causing it to unshadow prematurely.

Fix by resetting the fork detector if we detect a demand fault.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 73ffbff..bc64cce 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -421,6 +421,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 		pgprintk("%s: guest page fault\n", __FUNCTION__);
 		inject_page_fault(vcpu, addr, walker.error_code);
 		FNAME(release_walker)(&walker);
+		vcpu->last_pt_write_count = 0; /* reset fork detector */
 		return 0;
 	}
 
@@ -442,6 +443,9 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 
 	FNAME(release_walker)(&walker);
 
+	if (!write_pt)
+		vcpu->last_pt_write_count = 0; /* reset fork detector */
+
 	/*
 	 * mmio: emulate if accessible, otherwise its a guest fault.
 	 */
-- 
1.5.0.6

