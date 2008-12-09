Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbYLIUhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbYLIUhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbYLIUYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34868 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbYLIUXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 09/44] KVM: ensure that memslot userspace addresses are page-aligned
Date: Tue,  9 Dec 2008 22:22:24 +0200
Message-Id: <1228854179-23002-10-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Bad page translation and silent guest failure ensue if the userspace address is
not page-aligned.  I hit this problem using large (host) pages with qemu,
because qemu currently has a hardcoded 4096-byte alignment for guest memory
allocations.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a65baa9..0a0a959 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -715,6 +715,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		goto out;
 	if (mem->guest_phys_addr & (PAGE_SIZE - 1))
 		goto out;
+	if (mem->userspace_addr & (PAGE_SIZE - 1))
+		goto out;
 	if (mem->slot >= KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS)
 		goto out;
 	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
-- 
1.6.0.3

