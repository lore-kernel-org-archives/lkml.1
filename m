Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222Ab0AZXqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab0AZXqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090Ab0AZXqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:46:34 -0500
Received: from kroah.org ([198.145.64.141]:35552 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950Ab0AZXoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:24 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:33 2010
Message-Id: <20100126233933.172606623@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Slaby <jirislaby@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Avi Kivity <avi@redhat.com>
Subject: [93/98] KVM: fix lock imbalance in kvm_*_irq_source_id()
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit 0c6ddcebd8303ada6faefa6f72ac18b6230320c4 upstream.

Stanse found 2 lock imbalances in kvm_request_irq_source_id and
kvm_free_irq_source_id. They omit to unlock kvm->irq_lock on fail paths.

Fix that by adding unlock labels at the end of the functions and jump
there from the fail paths.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 virt/kvm/irq_comm.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -209,11 +209,13 @@ int kvm_request_irq_source_id(struct kvm
 
 	if (irq_source_id >= BITS_PER_LONG) {
 		printk(KERN_WARNING "kvm: exhaust allocatable IRQ sources!\n");
-		return -EFAULT;
+		irq_source_id = -EFAULT;
+		goto unlock;
 	}
 
 	ASSERT(irq_source_id != KVM_USERSPACE_IRQ_SOURCE_ID);
 	set_bit(irq_source_id, bitmap);
+unlock:
 	mutex_unlock(&kvm->irq_lock);
 
 	return irq_source_id;
@@ -229,11 +231,12 @@ void kvm_free_irq_source_id(struct kvm *
 	if (irq_source_id < 0 ||
 	    irq_source_id >= BITS_PER_LONG) {
 		printk(KERN_ERR "kvm: IRQ source ID out of range!\n");
-		return;
+		goto unlock;
 	}
 	for (i = 0; i < KVM_IOAPIC_NUM_PINS; i++)
 		clear_bit(irq_source_id, &kvm->arch.irq_states[i]);
 	clear_bit(irq_source_id, &kvm->arch.irq_sources_bitmap);
+unlock:
 	mutex_unlock(&kvm->irq_lock);
 }
 


