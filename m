Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbZFRRpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbZFRRpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbZFRRoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:44:30 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:49439 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952AbZFRRo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:44:26 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH 2/4] KVM: fix irqfd error checking
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, davidel@xmailserver.org, mingo@elte.hu,
       mst@redhat.com, avi@redhat.com, paulmck@linux.vnet.ibm.com,
       rusty@rustcorp.com.au
Date: Thu, 18 Jun 2009 13:44:21 -0400
Message-ID: <20090618174421.24119.86566.stgit@dev.haskins.net>
In-Reply-To: <20090618173534.24119.95115.stgit@dev.haskins.net>
References: <20090618173534.24119.95115.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tsirkin pointed out that f_ops->poll() does not return a standard
"int" error, yet we are treating it as such. Lets fix this.

Reported-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 virt/kvm/eventfd.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index a0e329f..a9e7de7 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -144,6 +144,7 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 	struct _irqfd *irqfd;
 	struct file *file = NULL;
 	int ret;
+	unsigned int events;
 
 	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
 	if (!irqfd)
@@ -169,9 +170,7 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
 	init_poll_funcptr(&irqfd->pt, irqfd_ptable_queue_proc);
 
-	ret = file->f_op->poll(file, &irqfd->pt);
-	if (ret < 0)
-		goto fail;
+	events = file->f_op->poll(file, &irqfd->pt);
 
 	kvm_get_kvm(kvm);
 
@@ -180,6 +179,12 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 	mutex_unlock(&kvm->lock);
 
 	/*
+	 * Check if there was an event already queued
+	 */
+	if (events & POLLIN)
+		schedule_work(&irqfd->inject);
+
+	/*
 	 * do not drop the file until the irqfd is fully initialized, otherwise
 	 * we might race against the POLLHUP
 	 */
@@ -188,9 +193,6 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 	return 0;
 
 fail:
-	if (irqfd->wqh)
-		remove_wait_queue(irqfd->wqh, &irqfd->wait);
-
 	if (file && !IS_ERR(file))
 		fput(file);
 

