Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbZF2Qjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbZF2Qjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbZF2QjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:39:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38008 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbZF2QjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:39:21 -0400
Date: Mon, 29 Jun 2009 19:38:51 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       markmc@redhat.com
Subject: Re: [PATCHv3 3/4] kvm: convert bus to slots_lock
Message-ID: <20090629163851.GD22029@redhat.com>
References: <cover.1246276816.git.mst@redhat.com> <20090629120911.GD21273@redhat.com> <20090629155031.GA16444@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629155031.GA16444@amt.cnet>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 12:50:31PM -0300, Marcelo Tosatti wrote:
> > diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
> > index 148c52a..1851aec 100644
> > --- a/arch/x86/kvm/i8259.c
> > +++ b/arch/x86/kvm/i8259.c
> > @@ -548,6 +548,6 @@ struct kvm_pic *kvm_create_pic(struct kvm *kvm)
> >  	 * Initialize PIO device
> >  	 */
> >  	kvm_iodevice_init(&s->dev, &picdev_ops);
> > -	kvm_io_bus_register_dev(&kvm->pio_bus, &s->dev);
> > +	kvm_io_bus_register_dev(kvm, &kvm->pio_bus, &s->dev);
> >  	return s;
> 
> case KVM_CREATE_PIT2:
> create_pit:
> mutex_lock(&kvm->lock);
> kvm_io_bus_register_dev
> down_write(slots_lock);
> 
> But the order is slots_lock -> kvm->lock.
> 
> (you might want to update the comment on top of kvm_main.c to 
> reflect that).

Good catch. I think it's easiest to replace kvm->lock by slots_lock
here as well. Does something like the following make sense?
If yes I'll roll it up in the series.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 3155ffa..add108b 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -585,6 +585,7 @@ static const struct kvm_io_device_ops speaker_dev_ops = {
 	.write    = speaker_ioport_write,
 };
 
+/* Caller must have writers lock on slots_lock */
 struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 {
 	struct kvm_pit *pit;
@@ -623,11 +624,11 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 	kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 
 	kvm_iodevice_init(&pit->dev, &pit_dev_ops);
-	kvm_io_bus_register_dev(kvm, &kvm->pio_bus, &pit->dev);
+	__kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
 
 	if (flags & KVM_PIT_SPEAKER_DUMMY) {
 		kvm_iodevice_init(&pit->speaker_dev, &speaker_dev_ops);
-		kvm_io_bus_register_dev(kvm, &kvm->pio_bus, &pit->speaker_dev);
+		__kvm_io_bus_register_dev(kvm, &kvm->pio_bus, &pit->speaker_dev);
 	}
 
 	return pit;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 82e76da..4c171e8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2115,7 +2115,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 				   sizeof(struct kvm_pit_config)))
 			goto out;
 	create_pit:
-		mutex_lock(&kvm->lock);
+		down_write(&kvm->slots_lock);
 		r = -EEXIST;
 		if (kvm->arch.vpit)
 			goto create_pit_unlock;
@@ -2124,7 +2124,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		if (kvm->arch.vpit)
 			r = 0;
 	create_pit_unlock:
-		mutex_unlock(&kvm->lock);
+		up_write(&kvm->slots_lock);
 		break;
 	case KVM_IRQ_LINE_STATUS:
 	case KVM_IRQ_LINE: {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2ca0eb5..3f95332 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -64,6 +64,8 @@ int kvm_io_bus_write(struct kvm_io_bus *bus, gpa_t addr, int len,
 		     const void *val);
 int kvm_io_bus_read(struct kvm_io_bus *bus, gpa_t addr, int len,
 		    void *val);
+void __kvm_io_bus_register_dev(struct kvm_io_bus *bus,
+			       struct kvm_io_device *dev);
 void kvm_io_bus_register_dev(struct kvm *kvm, struct kvm_io_bus *bus,
 			     struct kvm_io_device *dev);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3730cc4..728118f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2509,10 +2509,17 @@ void kvm_io_bus_register_dev(struct kvm *kvm, struct kvm_io_bus *bus,
 			     struct kvm_io_device *dev)
 {
 	down_write(&kvm->slots_lock);
+	__kvm_io_bus_register_dev(bus, dev);
+	up_write(&kvm->slots_lock);
+}
+
+/* An unlocked version. Caller must have write lock on slots_lock. */
+void __kvm_io_bus_register_dev(struct kvm_io_bus *bus,
+			     struct kvm_io_device *dev)
+{
 	BUG_ON(bus->dev_count > (NR_IOBUS_DEVS-1));
 
 	bus->devs[bus->dev_count++] = dev;
-	up_write(&kvm->slots_lock);
 }
 
 static struct notifier_block kvm_cpu_notifier = {
