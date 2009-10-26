Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbZJZQWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbZJZQWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbZJZQWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:22:15 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:33065 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbZJZQWM (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Mon, 26 Oct 2009 12:22:12 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v3 3/3] KVM: Directly inject interrupts if they support
	lockless operation
To: kvm@vger.kernel.org
Cc: alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Mon, 26 Oct 2009 12:22:08 -0400
Message-ID: <20091026162208.23704.19953.stgit@dev.haskins.net>
In-Reply-To: <20091026162148.23704.47286.stgit@dev.haskins.net>
References: <20091026162148.23704.47286.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQFD currently uses a deferred workqueue item to execute the injection
operation.  It was originally designed this way because kvm_set_irq()
required the caller to hold the irq_lock mutex, and the eventfd callback
is invoked from within a non-preemptible critical section.

With the advent of lockless injection support for certain GSIs, the
deferment mechanism is no longer technically needed in all cases.
Since context switching to the workqueue is a source of interrupt
latency, lets switch to a direct method whenever possible.  Fortunately
for us, the most common use of irqfd (MSI-based GSIs) readily support
lockless injection.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 virt/kvm/eventfd.c |   31 +++++++++++++++++++++++++++----
 1 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 30f70fd..e6cc958 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -51,20 +51,34 @@ struct _irqfd {
 	wait_queue_t              wait;
 	struct work_struct        inject;
 	struct work_struct        shutdown;
+	void (*execute)(struct _irqfd *);
 };
 
 static struct workqueue_struct *irqfd_cleanup_wq;
 
 static void
-irqfd_inject(struct work_struct *work)
+irqfd_inject(struct _irqfd *irqfd)
 {
-	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
 	struct kvm *kvm = irqfd->kvm;
 
 	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
 	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
 }
 
+static void
+irqfd_deferred_inject(struct work_struct *work)
+{
+	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
+
+	irqfd_inject(irqfd);
+}
+
+static void
+irqfd_schedule(struct _irqfd *irqfd)
+{
+	schedule_work(&irqfd->inject);
+}
+
 /*
  * Race-free decouple logic (ordering is critical)
  */
@@ -126,7 +140,7 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
 
 	if (flags & POLLIN)
 		/* An event has been signaled, inject an interrupt */
-		schedule_work(&irqfd->inject);
+		irqfd->execute(irqfd);
 
 	if (flags & POLLHUP) {
 		/* The eventfd is closing, detach from KVM */
@@ -179,7 +193,7 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
 	irqfd->kvm = kvm;
 	irqfd->gsi = gsi;
 	INIT_LIST_HEAD(&irqfd->list);
-	INIT_WORK(&irqfd->inject, irqfd_inject);
+	INIT_WORK(&irqfd->inject, irqfd_deferred_inject);
 	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
 
 	file = eventfd_fget(fd);
@@ -209,6 +223,15 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
 	list_add_tail(&irqfd->list, &kvm->irqfds.items);
 	spin_unlock_irq(&kvm->irqfds.lock);
 
+	ret = kvm_irq_check_lockless(kvm, gsi);
+	if (ret < 0)
+		goto fail;
+
+	if (ret)
+		irqfd->execute = &irqfd_inject;
+	else
+		irqfd->execute = &irqfd_schedule;
+
 	/*
 	 * Check if there was an event already pending on the eventfd
 	 * before we registered, and trigger it as if we didn't miss it.

