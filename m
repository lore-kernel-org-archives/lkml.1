Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbZFYN3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbZFYN3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbZFYN2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:28:48 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35748 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292AbZFYN2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:28:41 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v5 4/4] KVM: add irqfd DEASSIGN feature
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com,
       paulmck@linux.vnet.ibm.com, davidel@xmailserver.org,
       rusty@rustcorp.com.au
Date: Thu, 25 Jun 2009 09:28:32 -0400
Message-ID: <20090625132832.26748.35406.stgit@dev.haskins.net>
In-Reply-To: <20090625132441.26748.641.stgit@dev.haskins.net>
References: <20090625132441.26748.641.stgit@dev.haskins.net>
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
 virt/kvm/eventfd.c  |   56 +++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 56 insertions(+), 2 deletions(-)

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
index ca21e8a..2d4549c 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -180,8 +180,8 @@ irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
 	add_wait_queue(wqh, &irqfd->wait);
 }
 
-int
-kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
+static int
+kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
 {
 	struct _irqfd *irqfd;
 	struct file *file = NULL;
@@ -303,6 +303,58 @@ irqfd_shutdown(struct _irqfd *irqfd)
 	irqfd_release(irqfd);
 }
 
+/*
+ * assumes kvm->irqfds.lock is held
+ */
+static struct _irqfd *
+irqfd_find(struct kvm *kvm, int fd, int gsi)
+{
+	struct _irqfd *irqfd, *tmp, *ret = ERR_PTR(-ENOENT);
+	struct eventfd_ctx *eventfd;
+
+	eventfd = eventfd_ctx_fdget(fd);
+	if (IS_ERR(eventfd))
+		return ERR_PTR(PTR_ERR(eventfd));
+
+	spin_lock_irq(&kvm->irqfds.lock);
+
+	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list) {
+		if (irqfd->eventfd == eventfd && irqfd->gsi == gsi) {
+			irqfd_deactivate(irqfd);
+			ret = irqfd;
+			break;
+		}
+	}
+
+	spin_unlock_irq(&kvm->irqfds.lock);
+	eventfd_ctx_put(eventfd);
+
+	return ret;
+}
+
+static int
+kvm_irqfd_deassign(struct kvm *kvm, int fd, int gsi)
+{
+	struct _irqfd *irqfd;
+
+	irqfd = irqfd_find(kvm, fd, gsi);
+	if (IS_ERR(irqfd))
+		return PTR_ERR(irqfd);
+
+	irqfd_shutdown(irqfd);
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
 void
 kvm_irqfd_release(struct kvm *kvm)
 {

