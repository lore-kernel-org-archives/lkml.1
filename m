Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbZF2TZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbZF2TZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758881AbZF2TYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:24:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57905 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758801AbZF2TYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:24:46 -0400
Date: Mon, 29 Jun 2009 22:24:14 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: [PATCHv5 2/6] kvm: switch coalesced mmio changes to slots_lock
Message-ID: <20090629192414.GC27464@redhat.com>
References: <cover.1246297980.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1246297980.git.mst@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

switch coalesced mmio slots_lock.  slots_lock is already taken for read
everywhere, so we only need to take it for write when changing zones.
This is in preparation to removing in_range and kvm->lock around it.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 virt/kvm/coalesced_mmio.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 397f419..7b7cc9f 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -102,7 +102,7 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
 	kvm_iodevice_init(&dev->dev, &coalesced_mmio_ops);
 	dev->kvm = kvm;
 	kvm->coalesced_mmio_dev = dev;
-	kvm_io_bus_register_dev(&kvm->mmio_bus, &dev->dev);
+	kvm_io_bus_register_dev(kvm, &kvm->mmio_bus, &dev->dev);
 
 	return 0;
 }
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
1.6.2.2

