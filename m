Return-Path: <linux-kernel-owner+w=401wt.eu-S1752558Ab0AKV1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab0AKV1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852Ab0AKV1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:27:36 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:60356 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab0AKV1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=fsfvoEIpywfvfsFy7WQcSoTpreBapI/GXO7CFxh9ipARAFRRwUG63MusNg7W6irCYq
         6wcSsIhc+GZN8wp32zH0J4ugFoJiB9eWUcuiUJzqUkVgqs/nZ5Xd4uuu0P96Jz3sB9VH
         KUpr83jrJNXumvTFTYMh20BIEtHNhofQZ4yLc=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 17/26] x86: kvm: Convert i8254/i8259 locks to raw_spinlock
Date: Mon, 11 Jan 2010 22:26:47 +0100
Message-Id: <1263245216-14754-18-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-17-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
 <1263245216-14754-4-git-send-email-jkacur@redhat.com>
 <1263245216-14754-5-git-send-email-jkacur@redhat.com>
 <1263245216-14754-6-git-send-email-jkacur@redhat.com>
 <1263245216-14754-7-git-send-email-jkacur@redhat.com>
 <1263245216-14754-8-git-send-email-jkacur@redhat.com>
 <1263245216-14754-9-git-send-email-jkacur@redhat.com>
 <1263245216-14754-10-git-send-email-jkacur@redhat.com>
 <1263245216-14754-11-git-send-email-jkacur@redhat.com>
 <1263245216-14754-12-git-send-email-jkacur@redhat.com>
 <1263245216-14754-13-git-send-email-jkacur@redhat.com>
 <1263245216-14754-14-git-send-email-jkacur@redhat.com>
 <1263245216-14754-15-git-send-email-jkacur@redhat.com>
 <1263245216-14754-16-git-send-email-jkacur@redhat.com>
 <1263245216-14754-17-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks which cannot sleep in preempt-rt to raw_spinlocks.

See also 4b064e4f9ec7a5befcab91b9b1f2b0314c5a051a

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/x86/kvm/i8254.c |   10 +++++-----
 arch/x86/kvm/i8254.h |    2 +-
 arch/x86/kvm/i8259.c |   30 +++++++++++++++---------------
 arch/x86/kvm/irq.h   |    2 +-
 arch/x86/kvm/x86.c   |    8 ++++----
 5 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 296aba4..23265ee 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -242,11 +242,11 @@ static void kvm_pit_ack_irq(struct kvm_irq_ack_notifier *kian)
 {
 	struct kvm_kpit_state *ps = container_of(kian, struct kvm_kpit_state,
 						 irq_ack_notifier);
-	spin_lock(&ps->inject_lock);
+	raw_spin_lock(&ps->inject_lock);
 	if (atomic_dec_return(&ps->pit_timer.pending) < 0)
 		atomic_inc(&ps->pit_timer.pending);
 	ps->irq_ack = 1;
-	spin_unlock(&ps->inject_lock);
+	raw_spin_unlock(&ps->inject_lock);
 }
 
 void __kvm_migrate_pit_timer(struct kvm_vcpu *vcpu)
@@ -621,7 +621,7 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 
 	mutex_init(&pit->pit_state.lock);
 	mutex_lock(&pit->pit_state.lock);
-	spin_lock_init(&pit->pit_state.inject_lock);
+	raw_spin_lock_init(&pit->pit_state.inject_lock);
 
 	kvm->arch.vpit = pit;
 	pit->kvm = kvm;
@@ -720,12 +720,12 @@ void kvm_inject_pit_timer_irqs(struct kvm_vcpu *vcpu)
 		/* Try to inject pending interrupts when
 		 * last one has been acked.
 		 */
-		spin_lock(&ps->inject_lock);
+		raw_spin_lock(&ps->inject_lock);
 		if (atomic_read(&ps->pit_timer.pending) && ps->irq_ack) {
 			ps->irq_ack = 0;
 			inject = 1;
 		}
-		spin_unlock(&ps->inject_lock);
+		raw_spin_unlock(&ps->inject_lock);
 		if (inject)
 			__inject_pit_timer_intr(kvm);
 	}
diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
index d4c1c7f..900d6b0 100644
--- a/arch/x86/kvm/i8254.h
+++ b/arch/x86/kvm/i8254.h
@@ -27,7 +27,7 @@ struct kvm_kpit_state {
 	u32    speaker_data_on;
 	struct mutex lock;
 	struct kvm_pit *pit;
-	spinlock_t inject_lock;
+	raw_spinlock_t inject_lock;
 	unsigned long irq_ack;
 	struct kvm_irq_ack_notifier irq_ack_notifier;
 };
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index d057c0c..3271405 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -44,18 +44,18 @@ static void pic_clear_isr(struct kvm_kpic_state *s, int irq)
 	 * Other interrupt may be delivered to PIC while lock is dropped but
 	 * it should be safe since PIC state is already updated at this stage.
 	 */
-	spin_unlock(&s->pics_state->lock);
+	raw_spin_unlock(&s->pics_state->lock);
 	kvm_notify_acked_irq(s->pics_state->kvm, SELECT_PIC(irq), irq);
-	spin_lock(&s->pics_state->lock);
+	raw_spin_lock(&s->pics_state->lock);
 }
 
 void kvm_pic_clear_isr_ack(struct kvm *kvm)
 {
 	struct kvm_pic *s = pic_irqchip(kvm);
-	spin_lock(&s->lock);
+	raw_spin_lock(&s->lock);
 	s->pics[0].isr_ack = 0xff;
 	s->pics[1].isr_ack = 0xff;
-	spin_unlock(&s->lock);
+	raw_spin_unlock(&s->lock);
 }
 
 /*
@@ -156,9 +156,9 @@ static void pic_update_irq(struct kvm_pic *s)
 
 void kvm_pic_update_irq(struct kvm_pic *s)
 {
-	spin_lock(&s->lock);
+	raw_spin_lock(&s->lock);
 	pic_update_irq(s);
-	spin_unlock(&s->lock);
+	raw_spin_unlock(&s->lock);
 }
 
 int kvm_pic_set_irq(void *opaque, int irq, int level)
@@ -166,14 +166,14 @@ int kvm_pic_set_irq(void *opaque, int irq, int level)
 	struct kvm_pic *s = opaque;
 	int ret = -1;
 
-	spin_lock(&s->lock);
+	raw_spin_lock(&s->lock);
 	if (irq >= 0 && irq < PIC_NUM_PINS) {
 		ret = pic_set_irq1(&s->pics[irq >> 3], irq & 7, level);
 		pic_update_irq(s);
 		trace_kvm_pic_set_irq(irq >> 3, irq & 7, s->pics[irq >> 3].elcr,
 				      s->pics[irq >> 3].imr, ret == 0);
 	}
-	spin_unlock(&s->lock);
+	raw_spin_unlock(&s->lock);
 
 	return ret;
 }
@@ -203,7 +203,7 @@ int kvm_pic_read_irq(struct kvm *kvm)
 	int irq, irq2, intno;
 	struct kvm_pic *s = pic_irqchip(kvm);
 
-	spin_lock(&s->lock);
+	raw_spin_lock(&s->lock);
 	irq = pic_get_irq(&s->pics[0]);
 	if (irq >= 0) {
 		pic_intack(&s->pics[0], irq);
@@ -228,7 +228,7 @@ int kvm_pic_read_irq(struct kvm *kvm)
 		intno = s->pics[0].irq_base + irq;
 	}
 	pic_update_irq(s);
-	spin_unlock(&s->lock);
+	raw_spin_unlock(&s->lock);
 
 	return intno;
 }
@@ -442,7 +442,7 @@ static int picdev_write(struct kvm_io_device *this,
 			printk(KERN_ERR "PIC: non byte write\n");
 		return 0;
 	}
-	spin_lock(&s->lock);
+	raw_spin_lock(&s->lock);
 	switch (addr) {
 	case 0x20:
 	case 0x21:
@@ -455,7 +455,7 @@ static int picdev_write(struct kvm_io_device *this,
 		elcr_ioport_write(&s->pics[addr & 1], addr, data);
 		break;
 	}
-	spin_unlock(&s->lock);
+	raw_spin_unlock(&s->lock);
 	return 0;
 }
 
@@ -472,7 +472,7 @@ static int picdev_read(struct kvm_io_device *this,
 			printk(KERN_ERR "PIC: non byte read\n");
 		return 0;
 	}
-	spin_lock(&s->lock);
+	raw_spin_lock(&s->lock);
 	switch (addr) {
 	case 0x20:
 	case 0x21:
@@ -486,7 +486,7 @@ static int picdev_read(struct kvm_io_device *this,
 		break;
 	}
 	*(unsigned char *)val = data;
-	spin_unlock(&s->lock);
+	raw_spin_unlock(&s->lock);
 	return 0;
 }
 
@@ -520,7 +520,7 @@ struct kvm_pic *kvm_create_pic(struct kvm *kvm)
 	s = kzalloc(sizeof(struct kvm_pic), GFP_KERNEL);
 	if (!s)
 		return NULL;
-	spin_lock_init(&s->lock);
+	raw_spin_lock_init(&s->lock);
 	s->kvm = kvm;
 	s->pics[0].elcr_mask = 0xf8;
 	s->pics[1].elcr_mask = 0xde;
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index be399e2..b994083 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -62,7 +62,7 @@ struct kvm_kpic_state {
 };
 
 struct kvm_pic {
-	spinlock_t lock;
+	raw_spinlock_t lock;
 	unsigned pending_acks;
 	struct kvm *kvm;
 	struct kvm_kpic_state pics[2]; /* 0 is master pic, 1 is slave pic */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6651dbf..920d5c0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2274,18 +2274,18 @@ static int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 	r = 0;
 	switch (chip->chip_id) {
 	case KVM_IRQCHIP_PIC_MASTER:
-		spin_lock(&pic_irqchip(kvm)->lock);
+		raw_spin_lock(&pic_irqchip(kvm)->lock);
 		memcpy(&pic_irqchip(kvm)->pics[0],
 			&chip->chip.pic,
 			sizeof(struct kvm_pic_state));
-		spin_unlock(&pic_irqchip(kvm)->lock);
+		raw_spin_unlock(&pic_irqchip(kvm)->lock);
 		break;
 	case KVM_IRQCHIP_PIC_SLAVE:
-		spin_lock(&pic_irqchip(kvm)->lock);
+		raw_spin_lock(&pic_irqchip(kvm)->lock);
 		memcpy(&pic_irqchip(kvm)->pics[1],
 			&chip->chip.pic,
 			sizeof(struct kvm_pic_state));
-		spin_unlock(&pic_irqchip(kvm)->lock);
+		raw_spin_unlock(&pic_irqchip(kvm)->lock);
 		break;
 	case KVM_IRQCHIP_IOAPIC:
 		r = kvm_set_ioapic(kvm, &chip->chip.ioapic);
-- 
1.6.5.2

