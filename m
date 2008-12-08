Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbYLHLl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbYLHLl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYLHLh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:37:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48259 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbYLHLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 36/45] KVM: Enable Function Level Reset for assigned device
Date: Mon,  8 Dec 2008 13:36:47 +0200
Message-Id: <1228736216-15787-37-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Ideally, every assigned device should in a clear condition before and after
assignment, so that the former state of device won't affect later work.
Some devices provide a mechanism named Function Level Reset, which is
defined in PCI/PCI-e document. We should execute it before and after device
assignment.

(But sadly, the feature is new, and most device on the market now don't
support it. We are considering using D0/D3hot transmit to emulate it later,
but not that elegant and reliable as FLR itself.)

[Update: Reminded by Xiantao, execute FLR after we ensure that the device can
be assigned to the guest.]

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c  |    2 +-
 virt/kvm/kvm_main.c |    5 +++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 38f79b6..9a4a39c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4148,8 +4148,8 @@ static void kvm_free_vcpus(struct kvm *kvm)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
-	kvm_iommu_unmap_guest(kvm);
 	kvm_free_all_assigned_devices(kvm);
+	kvm_iommu_unmap_guest(kvm);
 	kvm_free_pit(kvm);
 	kfree(kvm->arch.vpic);
 	kfree(kvm->arch.vioapic);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4f43abe..1838052 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -152,6 +152,8 @@ static void kvm_free_assigned_device(struct kvm *kvm,
 		 */
 		kvm_put_kvm(kvm);
 
+	pci_reset_function(assigned_dev->dev);
+
 	pci_release_regions(assigned_dev->dev);
 	pci_disable_device(assigned_dev->dev);
 	pci_dev_put(assigned_dev->dev);
@@ -283,6 +285,9 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 		       __func__);
 		goto out_disable;
 	}
+
+	pci_reset_function(dev);
+
 	match->assigned_dev_id = assigned_dev->assigned_dev_id;
 	match->host_busnr = assigned_dev->busnr;
 	match->host_devfn = assigned_dev->devfn;
-- 
1.6.0.3

