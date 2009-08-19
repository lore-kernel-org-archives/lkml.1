Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbZHSNGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbZHSNGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbZHSNEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:04:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50583 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752012AbZHSNCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 42/47] KVM: switch coalesced mmio changes to slots_lock
Date: Wed, 19 Aug 2009 16:02:38 +0300
Message-Id: <1250686963-8357-43-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

switch coalesced mmio slots_lock.  slots_lock is already taken for read
everywhere, so we only need to take it for write when changing zones.
This is in preparation to removing in_range and kvm->lock around it.

[avi: fix build]

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/coalesced_mmio.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 397f419..b40946c 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -115,16 +115,16 @@ int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
 	if (dev == NULL)
 		return -EINVAL;
 
-	mutex_lock(&kvm->lock);
+	down_write(&kvm->slots_lock);
 	if (dev->nb_zones >= KVM_COALESCED_MMIO_ZONE_MAX) {
-		mutex_unlock(&kvm->lock);
+		up_write(&kvm->slots_lock);
 		return -ENOBUFS;
 	}
 
 	dev->zone[dev->nb_zones] = *zone;
 	dev->nb_zones++;
 
-	mutex_unlock(&kvm->lock);
+	up_write(&kvm->slots_lock);
 	return 0;
 }
 
@@ -138,7 +138,7 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
 	if (dev == NULL)
 		return -EINVAL;
 
-	mutex_lock(&kvm->lock);
+	down_write(&kvm->slots_lock);
 
 	i = dev->nb_zones;
 	while(i) {
@@ -156,7 +156,7 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
 		i--;
 	}
 
-	mutex_unlock(&kvm->lock);
+	up_write(&kvm->slots_lock);
 
 	return 0;
 }
-- 
1.6.3.3

