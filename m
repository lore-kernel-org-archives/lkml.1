Return-Path: <linux-kernel-owner+w=401wt.eu-S1761958AbYDUKkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761958AbYDUKkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbYDUKao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:44 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37945
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166AbYDUKaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:10 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 31/31] KVM: MMU: kvm_pv_mmu_op should not take mmap_sem
Date: Mon, 21 Apr 2008 13:29:57 +0300
Message-Id: <1208773797-7829-32-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

kvm_pv_mmu_op should not take mmap_sem. All gfn_to_page() callers down
in the MMU processing will take it if necessary, so as it is it can
deadlock.

Apparently a leftover from the days before slots_lock.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 078a7f1..2ad6f54 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2173,8 +2173,6 @@ int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
 	int r;
 	struct kvm_pv_mmu_op_buffer buffer;
 
-	down_read(&current->mm->mmap_sem);
-
 	buffer.ptr = buffer.buf;
 	buffer.len = min_t(unsigned long, bytes, sizeof buffer.buf);
 	buffer.processed = 0;
@@ -2194,7 +2192,6 @@ int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
 	r = 1;
 out:
 	*ret = buffer.processed;
-	up_read(&current->mm->mmap_sem);
 	return r;
 }
 
-- 
1.5.5

