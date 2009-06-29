Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbZF2Sam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbZF2Sam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758255AbZF2S3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:29:35 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35038 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221AbZF2S3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:29:31 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v7 4/5] KVM: add irqfd DEASSIGN feature
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com,
       davidel@xmailserver.org
Date: Mon, 29 Jun 2009 14:29:20 -0400
Message-ID: <20090629182920.1886.22941.stgit@dev.haskins.net>
In-Reply-To: <20090629181954.1886.20225.stgit@dev.haskins.net>
References: <20090629181954.1886.20225.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEASSIGN allows us to optionally disassociate an IRQFD from its underlying
eventfd without destroying the eventfd in the process.  This is useful
for conditions like live-migration which may have an eventfd associated
with a device and an IRQFD.  We need to be able to decouple the guest
from the event source while not perturbing the event source itself.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Michael S. Tsirkin <mst@redhat.com>
---

 include/linux/kvm.h |    2 ++
 virt/kvm/eventfd.c  |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 38ff31e..6710518 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -490,6 +490,8 @@ struct kvm_x86_mce {
 };
 #endif
 
+#define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
+
 struct kvm_irqfd {
 	__u32 fd;
 	__u32 gsi;
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index cb29a85..c1ade4f 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -151,8 +151,8 @@ irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
 	add_wait_queue(wqh, &irqfd->wait);
 }
 
-int
-kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
+static int
+kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
 {
 	struct _irqfd *irqfd;
 	struct file *file = NULL;
@@ -232,6 +232,48 @@ kvm_irqfd_init(struct kvm *kvm)
 }
 
 /*
+ * shutdown any irqfd's that match fd+gsi
+ */
+static int
+kvm_irqfd_deassign(struct kvm *kvm, int fd, int gsi)
+{
+	struct _irqfd *irqfd, *tmp;
+	struct eventfd_ctx *eventfd;
+
+	eventfd = eventfd_ctx_fdget(fd);
+	if (IS_ERR(eventfd))
+		return PTR_ERR(eventfd);
+
+	spin_lock_irq(&kvm->irqfds.lock);
+
+	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list) {
+		if (irqfd->eventfd == eventfd && irqfd->gsi == gsi)
+			irqfd_deactivate(irqfd);
+	}
+
+	spin_unlock_irq(&kvm->irqfds.lock);
+	eventfd_ctx_put(eventfd);
+
+	/*
+	 * Block until we know all outstanding shutdown jobs have completed
+	 * so that we guarantee there will not be any more interrupts on this
+	 * gsi once this deassign function returns.
+	 */
+	flush_workqueue(irqfd_cleanup_wq);
+
+	return 0;
+}
+
+int
+kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
+{
+	if (flags & KVM_IRQFD_FLAG_DEASSIGN)
+		return kvm_irqfd_deassign(kvm, fd, gsi);
+
+	return kvm_irqfd_assign(kvm, fd, gsi);
+}
+
+/*
  * This function is called as the kvm VM fd is being released. Shutdown all
  * irqfds that still remain open
  */

