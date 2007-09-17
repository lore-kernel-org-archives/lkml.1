Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbXIQIoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbXIQIoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbXIQIc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:58 -0400
Received: from il.qumranet.com ([82.166.9.18]:45244 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399AbXIQIcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:32 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eddie Dong <eddie.dong@intel.com>
Subject: [PATCH 069/104] KVM: Protect in-kernel pio using kvm->lock
Date: Mon, 17 Sep 2007 10:31:51 +0200
Message-Id: <11900179483314-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

pio operation and IRQ_LINE kvm_vm_ioctl is not kvm->lock
protected.  Add lock to same with IOAPIC MMIO operations.

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 4384364..5063b3a 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1790,6 +1790,7 @@ static void kernel_pio(struct kvm_io_device *pio_dev,
 {
 	/* TODO: String I/O for in kernel device */
 
+	mutex_lock(&vcpu->kvm->lock);
 	if (vcpu->pio.in)
 		kvm_iodevice_read(pio_dev, vcpu->pio.port,
 				  vcpu->pio.size,
@@ -1798,6 +1799,7 @@ static void kernel_pio(struct kvm_io_device *pio_dev,
 		kvm_iodevice_write(pio_dev, vcpu->pio.port,
 				   vcpu->pio.size,
 				   pd);
+	mutex_unlock(&vcpu->kvm->lock);
 }
 
 static void pio_string_write(struct kvm_io_device *pio_dev,
@@ -1807,12 +1809,14 @@ static void pio_string_write(struct kvm_io_device *pio_dev,
 	void *pd = vcpu->pio_data;
 	int i;
 
+	mutex_lock(&vcpu->kvm->lock);
 	for (i = 0; i < io->cur_count; i++) {
 		kvm_iodevice_write(pio_dev, io->port,
 				   io->size,
 				   pd);
 		pd += io->size;
 	}
+	mutex_unlock(&vcpu->kvm->lock);
 }
 
 int kvm_emulate_pio (struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
@@ -2818,6 +2822,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		if (copy_from_user(&irq_event, argp, sizeof irq_event))
 			goto out;
 		if (irqchip_in_kernel(kvm)) {
+			mutex_lock(&kvm->lock);
 			if (irq_event.irq < 16)
 				kvm_pic_set_irq(pic_irqchip(kvm),
 					irq_event.irq,
@@ -2825,6 +2830,7 @@ static long kvm_vm_ioctl(struct file *filp,
 			kvm_ioapic_set_irq(kvm->vioapic,
 					irq_event.irq,
 					irq_event.level);
+			mutex_unlock(&kvm->lock);
 			r = 0;
 		}
 		break;
-- 
1.5.3

