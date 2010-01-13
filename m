Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115Ab0AMRBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab0AMRBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 12:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756117Ab0AMRBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 12:01:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756115Ab0AMRBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 12:01:12 -0500
Date: Wed, 13 Jan 2010 18:58:09 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, Gleb Natapov <gleb@redhat.com>,
       Julia Lawall <julia@diku.dk>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: only allow one gsi per fd
Message-ID: <20100113165809.GA13334@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like repeatedly binding same fd to multiple gsi's with irqfd can
use up a ton of kernel memory for irqfd structures.

A simple fix is to allow each fd to only trigger one gsi: triggering a
srorm of interrupts in guest is likely useless anyway, and we can do it
by binding a single gsi to many interrupts if we really want to.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

This patch is IMO a good candidate for 2.6.33 and 2.6.32.x.

 virt/kvm/eventfd.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 30f70fd..62e4cd9 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -166,7 +166,7 @@ irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
 static int
 kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
 {
-	struct _irqfd *irqfd;
+	struct _irqfd *irqfd, *tmp;
 	struct file *file = NULL;
 	struct eventfd_ctx *eventfd = NULL;
 	int ret;
@@ -203,9 +203,20 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
 	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
 	init_poll_funcptr(&irqfd->pt, irqfd_ptable_queue_proc);
 
+	spin_lock_irq(&kvm->irqfds.lock);
+
+	ret = 0;
+	list_for_each_entry(tmp, &kvm->irqfds.items, list) {
+		if (irqfd->eventfd != tmp->eventfd)
+			continue;
+		/* This fd is used for another irq already. */
+		ret = -EBUSY;
+		spin_unlock_irq(&kvm->irqfds.lock);
+		goto fail;
+	}
+
 	events = file->f_op->poll(file, &irqfd->pt);
 
-	spin_lock_irq(&kvm->irqfds.lock);
 	list_add_tail(&irqfd->list, &kvm->irqfds.items);
 	spin_unlock_irq(&kvm->irqfds.lock);
 
-- 
1.6.6.144.g5c3af
