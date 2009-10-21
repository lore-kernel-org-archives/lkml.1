Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbZJUOfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbZJUOfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 10:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbZJUOfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 10:35:04 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:60073 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbZJUOfC (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Wed, 21 Oct 2009 10:35:02 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH 1/2] KVM: Directly inject interrupts via irqfd
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net
Date: Wed, 21 Oct 2009 10:34:53 -0400
Message-ID: <20091021143453.14955.80578.stgit@dev.haskins.net>
In-Reply-To: <20091021143042.14955.22470.stgit@dev.haskins.net>
References: <20091021143042.14955.22470.stgit@dev.haskins.net>
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

With the advent of lockless injection support in kvm_set_irq, the deferment
mechanism is no longer technically needed. Since context switching to the
workqueue is a source of interrupt latency, lets switch to a direct
method.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 virt/kvm/eventfd.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 30f70fd..1a529d4 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -49,16 +49,14 @@ struct _irqfd {
 	poll_table                pt;
 	wait_queue_head_t        *wqh;
 	wait_queue_t              wait;
-	struct work_struct        inject;
 	struct work_struct        shutdown;
 };
 
 static struct workqueue_struct *irqfd_cleanup_wq;
 
 static void
-irqfd_inject(struct work_struct *work)
+irqfd_inject(struct _irqfd *irqfd)
 {
-	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
 	struct kvm *kvm = irqfd->kvm;
 
 	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
@@ -80,12 +78,6 @@ irqfd_shutdown(struct work_struct *work)
 	remove_wait_queue(irqfd->wqh, &irqfd->wait);
 
 	/*
-	 * We know no new events will be scheduled at this point, so block
-	 * until all previously outstanding events have completed
-	 */
-	flush_work(&irqfd->inject);
-
-	/*
 	 * It is now safe to release the object's resources
 	 */
 	eventfd_ctx_put(irqfd->eventfd);
@@ -126,7 +118,7 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
 
 	if (flags & POLLIN)
 		/* An event has been signaled, inject an interrupt */
-		schedule_work(&irqfd->inject);
+		irqfd_inject(irqfd);
 
 	if (flags & POLLHUP) {
 		/* The eventfd is closing, detach from KVM */
@@ -179,7 +171,6 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
 	irqfd->kvm = kvm;
 	irqfd->gsi = gsi;
 	INIT_LIST_HEAD(&irqfd->list);
-	INIT_WORK(&irqfd->inject, irqfd_inject);
 	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
 
 	file = eventfd_fget(fd);
@@ -214,7 +205,7 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
 	 * before we registered, and trigger it as if we didn't miss it.
 	 */
 	if (events & POLLIN)
-		schedule_work(&irqfd->inject);
+		irqfd_inject(irqfd);
 
 	/*
 	 * do not drop the file until the irqfd is fully initialized, otherwise

