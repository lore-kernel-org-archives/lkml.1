Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187Ab0AZXqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab0AZXqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017Ab0AZXqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:46:01 -0500
Received: from kroah.org ([198.145.64.141]:35555 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953Ab0AZXo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:26 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:33 2010
Message-Id: <20100126233933.319365766@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:35:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [94/98] KVM: only clear irq_source_id if irqchip is present
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit e50212bb51356f0df48d6cce0aae5acf41df336d upstream.

Otherwise kvm might attempt to dereference a NULL pointer.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 virt/kvm/irq_comm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -233,9 +233,12 @@ void kvm_free_irq_source_id(struct kvm *
 		printk(KERN_ERR "kvm: IRQ source ID out of range!\n");
 		goto unlock;
 	}
+	clear_bit(irq_source_id, &kvm->arch.irq_sources_bitmap);
+	if (!irqchip_in_kernel(kvm))
+		goto unlock;
+
 	for (i = 0; i < KVM_IOAPIC_NUM_PINS; i++)
 		clear_bit(irq_source_id, &kvm->arch.irq_states[i]);
-	clear_bit(irq_source_id, &kvm->arch.irq_sources_bitmap);
 unlock:
 	mutex_unlock(&kvm->irq_lock);
 }


