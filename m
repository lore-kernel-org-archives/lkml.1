Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbZJUOid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbZJUOid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 10:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbZJUOfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 10:35:05 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:38002 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbZJUOfD (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Wed, 21 Oct 2009 10:35:03 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH 2/2] KVM: Remove unecessary irqfd-cleanup-wq
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net
Date: Wed, 21 Oct 2009 10:34:59 -0400
Message-ID: <20091021143458.14955.23897.stgit@dev.haskins.net>
In-Reply-To: <20091021143042.14955.22470.stgit@dev.haskins.net>
References: <20091021143042.14955.22470.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We originally created the irqfd-cleanup-wq so that we could safely
implement a shutdown that blocked on outstanding injection-requests
that may have been in flight.  We couldn't reuse something like kevent
to shutdown since the injection path was also using kevent and that may
have caused a deadlock if we tried.

Since the injection path is now no longer utilizing a work-item, it is
no longer necessary to maintain a separate cleanup WQ.  The standard
kevent queues should be sufficient, and thus we can eliminate an extra
kthread from the system.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 virt/kvm/eventfd.c |   30 +++---------------------------
 1 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 1a529d4..fb698f4 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -52,8 +52,6 @@ struct _irqfd {
 	struct work_struct        shutdown;
 };
 
-static struct workqueue_struct *irqfd_cleanup_wq;
-
 static void
 irqfd_inject(struct _irqfd *irqfd)
 {
@@ -104,7 +102,7 @@ irqfd_deactivate(struct _irqfd *irqfd)
 
 	list_del_init(&irqfd->list);
 
-	queue_work(irqfd_cleanup_wq, &irqfd->shutdown);
+	schedule_work(&irqfd->shutdown);
 }
 
 /*
@@ -262,7 +260,7 @@ kvm_irqfd_deassign(struct kvm *kvm, int fd, int gsi)
 	 * so that we guarantee there will not be any more interrupts on this
 	 * gsi once this deassign function returns.
 	 */
-	flush_workqueue(irqfd_cleanup_wq);
+	flush_scheduled_work();
 
 	return 0;
 }
@@ -296,33 +294,11 @@ kvm_irqfd_release(struct kvm *kvm)
 	 * Block until we know all outstanding shutdown jobs have completed
 	 * since we do not take a kvm* reference.
 	 */
-	flush_workqueue(irqfd_cleanup_wq);
+	flush_scheduled_work();
 
 }
 
 /*
- * create a host-wide workqueue for issuing deferred shutdown requests
- * aggregated from all vm* instances. We need our own isolated single-thread
- * queue to prevent deadlock against flushing the normal work-queue.
- */
-static int __init irqfd_module_init(void)
-{
-	irqfd_cleanup_wq = create_singlethread_workqueue("kvm-irqfd-cleanup");
-	if (!irqfd_cleanup_wq)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static void __exit irqfd_module_exit(void)
-{
-	destroy_workqueue(irqfd_cleanup_wq);
-}
-
-module_init(irqfd_module_init);
-module_exit(irqfd_module_exit);
-
-/*
  * --------------------------------------------------------------------
  * ioeventfd: translate a PIO/MMIO memory write to an eventfd signal.
  *

