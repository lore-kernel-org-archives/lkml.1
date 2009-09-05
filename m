Return-Path: <linux-kernel-owner+w=401wt.eu-S964893AbZIEAZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964893AbZIEAZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964797AbZIEAVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:21:24 -0400
Received: from kroah.org ([198.145.64.141]:42174 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934606AbZIEAU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:58 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:52 2009
Message-Id: <20090905001452.452348736@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
       "Michael S. Tsirkin" <mst@redhat.com>
Subject: [patch 33/71] KVM: fix ack not being delivered when msi present
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=kvm-fix-ack-not-being-delivered-when-msi-present.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael S. Tsirkin <mst@redhat.com>

(cherry picked from commit 5116d8f6b977970ebefc1932c0f313163a6ec91f)

kvm_notify_acked_irq does not check irq type, so that it sometimes
interprets msi vector as irq.  As a result, ack notifiers are not
called, which typially hangs the guest.  The fix is to track and
check irq type.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kvm_host.h |    1 +
 virt/kvm/irq_comm.c      |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -110,6 +110,7 @@ struct kvm_memory_slot {
 
 struct kvm_kernel_irq_routing_entry {
 	u32 gsi;
+	u32 type;
 	int (*set)(struct kvm_kernel_irq_routing_entry *e,
 		    struct kvm *kvm, int level);
 	union {
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -141,7 +141,8 @@ void kvm_notify_acked_irq(struct kvm *kv
 	unsigned gsi = pin;
 
 	list_for_each_entry(e, &kvm->irq_routing, link)
-		if (e->irqchip.irqchip == irqchip &&
+		if (e->type == KVM_IRQ_ROUTING_IRQCHIP &&
+		    e->irqchip.irqchip == irqchip &&
 		    e->irqchip.pin == pin) {
 			gsi = e->gsi;
 			break;
@@ -240,6 +241,7 @@ static int setup_routing_entry(struct kv
 	int delta;
 
 	e->gsi = ue->gsi;
+	e->type = ue->type;
 	switch (ue->type) {
 	case KVM_IRQ_ROUTING_IRQCHIP:
 		delta = 0;


