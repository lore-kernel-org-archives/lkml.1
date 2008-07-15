Return-Path: <linux-kernel-owner+w=401wt.eu-S1759526AbYGOMNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526AbYGOMNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbYGOMMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:12:44 -0400
Received: from il.qumranet.com ([212.179.150.194]:30329 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611AbYGOMMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:12:40 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 04/19] KVM: s390: dont allocate dirty bitmap
Date: Tue, 15 Jul 2008 15:12:23 +0300
Message-Id: <1216123958-10717-5-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1216123958-10717-1-git-send-email-avi@qumranet.com>
References: <1216123958-10717-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

This patch #ifdefs the bitmap array for dirty tracking. We don't have dirty
tracking on s390 today, and we'd love to use our storage keys to store the
dirty information for migration. Therefore, we won't need this array at all,
and due to our limited amount of vmalloc space this limits the amount of guests
we can run.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 virt/kvm/kvm_main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f9427e2..b90da0b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -359,6 +359,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	r = -ENOMEM;
 
 	/* Allocate if a slot is being created */
+#ifndef CONFIG_S390
 	if (npages && !new.rmap) {
 		new.rmap = vmalloc(npages * sizeof(struct page *));
 
@@ -399,6 +400,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			goto out_free;
 		memset(new.dirty_bitmap, 0, dirty_bytes);
 	}
+#endif /* not defined CONFIG_S390 */
 
 	if (mem->slot >= kvm->nmemslots)
 		kvm->nmemslots = mem->slot + 1;
-- 
1.5.6.1

