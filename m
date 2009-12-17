Return-Path: <linux-kernel-owner+w=401wt.eu-S936661AbZLQEmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936661AbZLQEmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763069AbZLQEEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:00 -0500
Received: from kroah.org ([198.145.64.141]:55375 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763830AbZLQED5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:03:57 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:47 2009
Message-Id: <20091217035647.086599672@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [032/151] KVM: fix irq_source_id size verification
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit cd5a2685de4a642fd0bd763e8c19711ef08dbe27 upstream.

find_first_zero_bit works with bit numbers, not bytes.

Fixes

https://sourceforge.net/tracker/?func=detail&aid=2847560&group_id=180599&atid=893831

Reported-by: "Xu, Jiajun" <jiajun.xu@intel.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 virt/kvm/irq_comm.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -205,10 +205,9 @@ int kvm_request_irq_source_id(struct kvm
 	int irq_source_id;
 
 	mutex_lock(&kvm->irq_lock);
-	irq_source_id = find_first_zero_bit(bitmap,
-				sizeof(kvm->arch.irq_sources_bitmap));
+	irq_source_id = find_first_zero_bit(bitmap, BITS_PER_LONG);
 
-	if (irq_source_id >= sizeof(kvm->arch.irq_sources_bitmap)) {
+	if (irq_source_id >= BITS_PER_LONG) {
 		printk(KERN_WARNING "kvm: exhaust allocatable IRQ sources!\n");
 		return -EFAULT;
 	}
@@ -228,7 +227,7 @@ void kvm_free_irq_source_id(struct kvm *
 
 	mutex_lock(&kvm->irq_lock);
 	if (irq_source_id < 0 ||
-	    irq_source_id >= sizeof(kvm->arch.irq_sources_bitmap)) {
+	    irq_source_id >= BITS_PER_LONG) {
 		printk(KERN_ERR "kvm: IRQ source ID out of range!\n");
 		return;
 	}


