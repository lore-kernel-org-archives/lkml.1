Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbXGHL5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbXGHL5D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 07:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbXGHLzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:55:12 -0400
Received: from il.qumranet.com ([82.166.9.18]:38399 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbXGHLyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:54:45 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Luca Tettamanti <kronos.it@gmail.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 07/20] KVM: Avoid useless memory write when possible
Date: Sun,  8 Jul 2007 14:54:36 +0300
Message-Id: <11838956893243-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11838956891287-git-send-email-avi@qumranet.com>
References: <11838956891287-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luca Tettamanti <kronos.it@gmail.com>

When writing to normal memory and the memory area is unchanged the write
can be safely skipped, avoiding the costly kvm_mmu_pte_write.

Signed-Off-By: Luca Tettamanti <kronos.it@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 7826f16..5603000 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1170,8 +1170,10 @@ static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 		return 0;
 	mark_page_dirty(vcpu->kvm, gpa >> PAGE_SHIFT);
 	virt = kmap_atomic(page, KM_USER0);
-	kvm_mmu_pte_write(vcpu, gpa, virt + offset, val, bytes);
-	memcpy(virt + offset_in_page(gpa), val, bytes);
+	if (memcmp(virt + offset_in_page(gpa), val, bytes)) {
+		kvm_mmu_pte_write(vcpu, gpa, virt + offset, val, bytes);
+		memcpy(virt + offset_in_page(gpa), val, bytes);
+	}
 	kunmap_atomic(virt, KM_USER0);
 	return 1;
 }
-- 
1.5.2.2

