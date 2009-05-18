Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbZERJak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbZERJak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755857AbZERJXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38408 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbZERJXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:09 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 08/43] KVM: Ioctls for init MSI-X entry
Date: Mon, 18 May 2009 12:22:30 +0300
Message-Id: <1242638585-18470-9-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Introduce KVM_SET_MSIX_NR and KVM_SET_MSIX_ENTRY two ioctls.

This two ioctls are used by userspace to specific guest device MSI-X entry
number and correlate MSI-X entry with GSI during the initialization stage.

MSI-X should be well initialzed before enabling.

Don't support change MSI-X entry number for now.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm.h      |   18 ++++++++
 include/linux/kvm_host.h |   10 ++++
 virt/kvm/kvm_main.c      |  104 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 132 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 8cc1379..78cdee8 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -487,6 +487,10 @@ struct kvm_irq_routing {
 #define KVM_REINJECT_CONTROL      _IO(KVMIO, 0x71)
 #define KVM_DEASSIGN_PCI_DEVICE _IOW(KVMIO, 0x72, \
 				     struct kvm_assigned_pci_dev)
+#define KVM_ASSIGN_SET_MSIX_NR \
+			_IOW(KVMIO, 0x73, struct kvm_assigned_msix_nr)
+#define KVM_ASSIGN_SET_MSIX_ENTRY \
+			_IOW(KVMIO, 0x74, struct kvm_assigned_msix_entry)
 
 /*
  * ioctls for vcpu fds
@@ -607,4 +611,18 @@ struct kvm_assigned_irq {
 #define KVM_DEV_IRQ_ASSIGN_MSI_ACTION	KVM_DEV_IRQ_ASSIGN_ENABLE_MSI
 #define KVM_DEV_IRQ_ASSIGN_ENABLE_MSI	(1 << 0)
 
+struct kvm_assigned_msix_nr {
+	__u32 assigned_dev_id;
+	__u16 entry_nr;
+	__u16 padding;
+};
+
+#define KVM_MAX_MSIX_PER_DEV		512
+struct kvm_assigned_msix_entry {
+	__u32 assigned_dev_id;
+	__u32 gsi;
+	__u16 entry; /* The index of entry in the MSI-X table */
+	__u16 padding[3];
+};
+
 #endif
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1a2f98f..432edc2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -319,6 +319,12 @@ struct kvm_irq_ack_notifier {
 	void (*irq_acked)(struct kvm_irq_ack_notifier *kian);
 };
 
+struct kvm_guest_msix_entry {
+	u32 vector;
+	u16 entry;
+	u16 flags;
+};
+
 struct kvm_assigned_dev_kernel {
 	struct kvm_irq_ack_notifier ack_notifier;
 	struct work_struct interrupt_work;
@@ -326,13 +332,17 @@ struct kvm_assigned_dev_kernel {
 	int assigned_dev_id;
 	int host_busnr;
 	int host_devfn;
+	unsigned int entries_nr;
 	int host_irq;
 	bool host_irq_disabled;
+	struct msix_entry *host_msix_entries;
 	int guest_irq;
+	struct kvm_guest_msix_entry *guest_msix_entries;
 #define KVM_ASSIGNED_DEV_GUEST_INTX	(1 << 0)
 #define KVM_ASSIGNED_DEV_GUEST_MSI	(1 << 1)
 #define KVM_ASSIGNED_DEV_HOST_INTX	(1 << 8)
 #define KVM_ASSIGNED_DEV_HOST_MSI	(1 << 9)
+#define KVM_ASSIGNED_DEV_MSIX		((1 << 2) | (1 << 10))
 	unsigned long irq_requested_type;
 	int irq_source_id;
 	int flags;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1ecbe23..fd33def 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1593,6 +1593,88 @@ static int kvm_vcpu_ioctl_set_sigmask(struct kvm_vcpu *vcpu, sigset_t *sigset)
 	return 0;
 }
 
+#ifdef __KVM_HAVE_MSIX
+static int kvm_vm_ioctl_set_msix_nr(struct kvm *kvm,
+				    struct kvm_assigned_msix_nr *entry_nr)
+{
+	int r = 0;
+	struct kvm_assigned_dev_kernel *adev;
+
+	mutex_lock(&kvm->lock);
+
+	adev = kvm_find_assigned_dev(&kvm->arch.assigned_dev_head,
+				      entry_nr->assigned_dev_id);
+	if (!adev) {
+		r = -EINVAL;
+		goto msix_nr_out;
+	}
+
+	if (adev->entries_nr == 0) {
+		adev->entries_nr = entry_nr->entry_nr;
+		if (adev->entries_nr == 0 ||
+		    adev->entries_nr >= KVM_MAX_MSIX_PER_DEV) {
+			r = -EINVAL;
+			goto msix_nr_out;
+		}
+
+		adev->host_msix_entries = kzalloc(sizeof(struct msix_entry) *
+						entry_nr->entry_nr,
+						GFP_KERNEL);
+		if (!adev->host_msix_entries) {
+			r = -ENOMEM;
+			goto msix_nr_out;
+		}
+		adev->guest_msix_entries = kzalloc(
+				sizeof(struct kvm_guest_msix_entry) *
+				entry_nr->entry_nr, GFP_KERNEL);
+		if (!adev->guest_msix_entries) {
+			kfree(adev->host_msix_entries);
+			r = -ENOMEM;
+			goto msix_nr_out;
+		}
+	} else /* Not allowed set MSI-X number twice */
+		r = -EINVAL;
+msix_nr_out:
+	mutex_unlock(&kvm->lock);
+	return r;
+}
+
+static int kvm_vm_ioctl_set_msix_entry(struct kvm *kvm,
+				       struct kvm_assigned_msix_entry *entry)
+{
+	int r = 0, i;
+	struct kvm_assigned_dev_kernel *adev;
+
+	mutex_lock(&kvm->lock);
+
+	adev = kvm_find_assigned_dev(&kvm->arch.assigned_dev_head,
+				      entry->assigned_dev_id);
+
+	if (!adev) {
+		r = -EINVAL;
+		goto msix_entry_out;
+	}
+
+	for (i = 0; i < adev->entries_nr; i++)
+		if (adev->guest_msix_entries[i].vector == 0 ||
+		    adev->guest_msix_entries[i].entry == entry->entry) {
+			adev->guest_msix_entries[i].entry = entry->entry;
+			adev->guest_msix_entries[i].vector = entry->gsi;
+			adev->host_msix_entries[i].entry = entry->entry;
+			break;
+		}
+	if (i == adev->entries_nr) {
+		r = -ENOSPC;
+		goto msix_entry_out;
+	}
+
+msix_entry_out:
+	mutex_unlock(&kvm->lock);
+
+	return r;
+}
+#endif
+
 static long kvm_vcpu_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -1917,7 +1999,29 @@ static long kvm_vm_ioctl(struct file *filp,
 		vfree(entries);
 		break;
 	}
+#ifdef __KVM_HAVE_MSIX
+	case KVM_ASSIGN_SET_MSIX_NR: {
+		struct kvm_assigned_msix_nr entry_nr;
+		r = -EFAULT;
+		if (copy_from_user(&entry_nr, argp, sizeof entry_nr))
+			goto out;
+		r = kvm_vm_ioctl_set_msix_nr(kvm, &entry_nr);
+		if (r)
+			goto out;
+		break;
+	}
+	case KVM_ASSIGN_SET_MSIX_ENTRY: {
+		struct kvm_assigned_msix_entry entry;
+		r = -EFAULT;
+		if (copy_from_user(&entry, argp, sizeof entry))
+			goto out;
+		r = kvm_vm_ioctl_set_msix_entry(kvm, &entry);
+		if (r)
+			goto out;
+		break;
+	}
 #endif
+#endif /* KVM_CAP_IRQ_ROUTING */
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 	}
-- 
1.6.0.6

