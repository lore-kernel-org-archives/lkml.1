Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091Ab0AZXqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab0AZXqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924Ab0AZXoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:44:25 -0500
Received: from kroah.org ([198.145.64.141]:35528 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949Ab0AZXoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:19 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:32 2010
Message-Id: <20100126233932.275072919@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Michael S. Tsirkin" <mst@redhat.com>,
       "Acked-by: Gregory Haskins" <ghaskins@novell.com>,
       Avi Kivity <avi@redhat.com>
Subject: [87/98] KVM: only allow one gsi per fd
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

commit f1d1c309f35e9b0fb961cffd70fbd04f450ec47c upstream.

Looks like repeatedly binding same fd to multiple gsi's with irqfd can
use up a ton of kernel memory for irqfd structures.

A simple fix is to allow each fd to only trigger one gsi: triggering a
storm of interrupts in guest is likely useless anyway, and we can do it
by binding a single gsi to many interrupts if we really want to.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Acked-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 virt/kvm/eventfd.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -168,7 +168,7 @@ irqfd_ptable_queue_proc(struct file *fil
 static int
 kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
 {
-	struct _irqfd *irqfd;
+	struct _irqfd *irqfd, *tmp;
 	struct file *file = NULL;
 	struct eventfd_ctx *eventfd = NULL;
 	int ret;
@@ -205,9 +205,20 @@ kvm_irqfd_assign(struct kvm *kvm, int fd
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
 


