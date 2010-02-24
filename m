Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab0BXJmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 04:42:21 -0500
Received: from thoth.sbs.de ([192.35.17.2]:18338 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578Ab0BXJmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 04:42:18 -0500
Message-ID: <4B84F466.2080009@siemens.com>
Date: Wed, 24 Feb 2010 10:41:58 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Avi Kivity <avi@redhat.com>, KVM <kvm@vger.kernel.org>,
       Gleb Natapov <gleb@redhat.com>, RT <linux-rt-users@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: x86: Kick VCPU outside PIC lock again
References: <20100217135901.331576359@linutronix.de> <4B842A1F.50601@siemens.com> <alpine.LFD.2.00.1002232321320.3232@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002232321320.3232@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Tue, 23 Feb 2010, Jan Kiszka wrote:
> 
>> Thomas Gleixner wrote:
>>> The i8254/i8259 locks need to be real spinlocks on preempt-rt. Convert
>>> them to raw_spinlock. No change for !RT kernels.
>> Doesn't fly for -rt anymore: pic_irq_update runs under this raw lock and
>> calls kvm_vcpu_kick which tries to wake_up some thread -> scheduling
>> while atomic.
> 
> Hmm, a wakeup itself is fine. Is that code waking a wake queue ?

Yes, it's a wake queue.

>  
>> This used to work up to 956f97cf. -rt for 2.6.31 is not yet affected,
>> but 2.6.33 should be broken (haven't checked, using kvm-kmod over 2.6.31
>> ATM). I can provide a patch that restores the deferred kicking if it's
>> acceptable for upstream.
> 
> Well, at least is would be nice to have one for -rt.
> 

Here we go. Haven't run kvm.git long enough over -rt yet to say that it
was the only remaining issue, but at least it doesn't complain instantly
anymore when starting a VM.

Jan

---------->

This restores the deferred VCPU kicking before 956f97cf. We need this
over -rt as wake_up* requires non-atomic context in this configuration.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---

 arch/x86/kvm/i8259.c |   53 ++++++++++++++++++++++++++++++++++++--------------
 arch/x86/kvm/irq.h   |    1 +
 2 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 07771da..ca426bd 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -32,6 +32,29 @@
 #include <linux/kvm_host.h>
 #include "trace.h"
 
+static void pic_lock(struct kvm_pic *s)
+	__acquires(&s->lock)
+{
+	raw_spin_lock(&s->lock);
+}
+
+static void pic_unlock(struct kvm_pic *s)
+	__releases(&s->lock)
+{
+	bool wakeup = s->wakeup_needed;
+	struct kvm_vcpu *vcpu;
+
+	s->wakeup_needed = false;
+
+	raw_spin_unlock(&s->lock);
+
+	if (wakeup) {
+		vcpu = s->kvm->bsp_vcpu;
+		if (vcpu)
+			kvm_vcpu_kick(vcpu);
+	}
+}
+
 static void pic_clear_isr(struct kvm_kpic_state *s, int irq)
 {
 	s->isr &= ~(1 << irq);
@@ -44,19 +67,19 @@ static void pic_clear_isr(struct kvm_kpic_state *s, int irq)
 	 * Other interrupt may be delivered to PIC while lock is dropped but
 	 * it should be safe since PIC state is already updated at this stage.
 	 */
-	raw_spin_unlock(&s->pics_state->lock);
+	pic_unlock(s->pics_state);
 	kvm_notify_acked_irq(s->pics_state->kvm, SELECT_PIC(irq), irq);
-	raw_spin_lock(&s->pics_state->lock);
+	pic_lock(s->pics_state);
 }
 
 void kvm_pic_clear_isr_ack(struct kvm *kvm)
 {
 	struct kvm_pic *s = pic_irqchip(kvm);
 
-	raw_spin_lock(&s->lock);
+	pic_lock(s);
 	s->pics[0].isr_ack = 0xff;
 	s->pics[1].isr_ack = 0xff;
-	raw_spin_unlock(&s->lock);
+	pic_unlock(s);
 }
 
 /*
@@ -157,9 +180,9 @@ static void pic_update_irq(struct kvm_pic *s)
 
 void kvm_pic_update_irq(struct kvm_pic *s)
 {
-	raw_spin_lock(&s->lock);
+	pic_lock(s);
 	pic_update_irq(s);
-	raw_spin_unlock(&s->lock);
+	pic_unlock(s);
 }
 
 int kvm_pic_set_irq(void *opaque, int irq, int level)
@@ -167,14 +190,14 @@ int kvm_pic_set_irq(void *opaque, int irq, int level)
 	struct kvm_pic *s = opaque;
 	int ret = -1;
 
-	raw_spin_lock(&s->lock);
+	pic_lock(s);
 	if (irq >= 0 && irq < PIC_NUM_PINS) {
 		ret = pic_set_irq1(&s->pics[irq >> 3], irq & 7, level);
 		pic_update_irq(s);
 		trace_kvm_pic_set_irq(irq >> 3, irq & 7, s->pics[irq >> 3].elcr,
 				      s->pics[irq >> 3].imr, ret == 0);
 	}
-	raw_spin_unlock(&s->lock);
+	pic_unlock(s);
 
 	return ret;
 }
@@ -204,7 +227,7 @@ int kvm_pic_read_irq(struct kvm *kvm)
 	int irq, irq2, intno;
 	struct kvm_pic *s = pic_irqchip(kvm);
 
-	raw_spin_lock(&s->lock);
+	pic_lock(s);
 	irq = pic_get_irq(&s->pics[0]);
 	if (irq >= 0) {
 		pic_intack(&s->pics[0], irq);
@@ -229,7 +252,7 @@ int kvm_pic_read_irq(struct kvm *kvm)
 		intno = s->pics[0].irq_base + irq;
 	}
 	pic_update_irq(s);
-	raw_spin_unlock(&s->lock);
+	pic_unlock(s);
 
 	return intno;
 }
@@ -443,7 +466,7 @@ static int picdev_write(struct kvm_io_device *this,
 			printk(KERN_ERR "PIC: non byte write\n");
 		return 0;
 	}
-	raw_spin_lock(&s->lock);
+	pic_lock(s);
 	switch (addr) {
 	case 0x20:
 	case 0x21:
@@ -456,7 +479,7 @@ static int picdev_write(struct kvm_io_device *this,
 		elcr_ioport_write(&s->pics[addr & 1], addr, data);
 		break;
 	}
-	raw_spin_unlock(&s->lock);
+	pic_unlock(s);
 	return 0;
 }
 
@@ -473,7 +496,7 @@ static int picdev_read(struct kvm_io_device *this,
 			printk(KERN_ERR "PIC: non byte read\n");
 		return 0;
 	}
-	raw_spin_lock(&s->lock);
+	pic_lock(s);
 	switch (addr) {
 	case 0x20:
 	case 0x21:
@@ -487,7 +510,7 @@ static int picdev_read(struct kvm_io_device *this,
 		break;
 	}
 	*(unsigned char *)val = data;
-	raw_spin_unlock(&s->lock);
+	pic_unlock(s);
 	return 0;
 }
 
@@ -504,7 +527,7 @@ static void pic_irq_request(void *opaque, int level)
 	s->output = level;
 	if (vcpu && level && (s->pics[0].isr_ack & (1 << irq))) {
 		s->pics[0].isr_ack &= ~(1 << irq);
-		kvm_vcpu_kick(vcpu);
+		s->wakeup_needed = true;
 	}
 }
 
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 34b1591..cd1f362 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -63,6 +63,7 @@ struct kvm_kpic_state {
 
 struct kvm_pic {
 	raw_spinlock_t lock;
+	bool wakeup_needed;
 	unsigned pending_acks;
 	struct kvm *kvm;
 	struct kvm_kpic_state pics[2]; /* 0 is master pic, 1 is slave pic */
