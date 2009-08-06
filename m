Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbZHFOnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbZHFOnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 10:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbZHFOnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 10:43:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60615 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbZHFOm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 10:42:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH 4/7] vbus-proxy: add a pci-to-vbus bridge
Date: Thu, 6 Aug 2009 16:42:40 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
References: <20090803171030.17268.26962.stgit@dev.haskins.net> <20090803171751.17268.48169.stgit@dev.haskins.net>
In-Reply-To: <20090803171751.17268.48169.stgit@dev.haskins.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908061642.40614.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1876N1Dhs/8h9sWsdR/i/ONXoTFA4DYPLYkXMt
 ZTvgKZI/jmbKMHw7ml3aLIy+v2r1DYv2ia5UCZEHa+KOaMyzcv
 Svh+K+dW+vjsqK7+7JH+w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, Gregory Haskins wrote:
> This patch adds a pci-based driver to interface between the a host VBUS
> and the guest's vbus-proxy bus model.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>

This seems to be duplicating parts of virtio-pci that could be kept
common by extending the virtio code. Layering on top of virtio
would also make it possible to use the same features you add
on top of other transports (e.g. the s390 virtio code) without
adding yet another backend for each of them.

> +static int
> +vbus_pci_hypercall(unsigned long nr, void *data, unsigned long len)
> +{
> +	struct vbus_pci_hypercall params = {
> +		.vector = nr,
> +		.len    = len,
> +		.datap  = __pa(data),
> +	};
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&vbus_pci.lock, flags);
> +
> +	memcpy_toio(&vbus_pci.regs->hypercall.data, &params, sizeof(params));
> +	ret = ioread32(&vbus_pci.regs->hypercall.result);
> +
> +	spin_unlock_irqrestore(&vbus_pci.lock, flags);
> +
> +	return ret;
> +}

The functionality looks reasonable but please don't call this a hypercall.
A hypercall would be hypervisor specific by definition while this one
is device specific if I understand it correctly. How about "command queue",
"mailbox", "message queue", "devcall" or something else that we have in
existing PCI devices?

> +
> +static int
> +vbus_pci_device_open(struct vbus_device_proxy *vdev, int version, int flags)
> +{
> +	struct vbus_pci_device *dev = to_dev(vdev);
> +	struct vbus_pci_deviceopen params;
> +	int ret;
> +
> +	if (dev->handle)
> +		return -EINVAL;
> +
> +	params.devid   = vdev->id;
> +	params.version = version;
> +
> +	ret = vbus_pci_hypercall(VBUS_PCI_HC_DEVOPEN,
> +				 &params, sizeof(params));
> +	if (ret < 0)
> +		return ret;
> +
> +	dev->handle = params.handle;
> +
> +	return 0;
> +}

This seems to add an artificial abstraction that does not make sense
if you stick to the PCI abstraction. The two sensible and common models
for virtual devices that I've seen are:

* The hypervisor knows what virtual resources exist and provides them
  to the guest. The guest owns them as soon as they show up in the
  bus (e.g. PCI) probe. The 'handle' is preexisting.

* The guest starts without any devices and asks for resources it wants
  to access. There is no probing of resources but the guest issues
  a hypercall to get a handle to a newly created virtual device
  (or -ENODEV).

What is your reasoning for requiring both a probe and an allocation?

> +static int
> +vbus_pci_device_shm(struct vbus_device_proxy *vdev, int id, int prio,
> +		    void *ptr, size_t len,
> +		    struct shm_signal_desc *sdesc, struct shm_signal **signal,
> +		    int flags)
> +{
> +	struct vbus_pci_device *dev = to_dev(vdev);
> +	struct _signal *_signal = NULL;
> +	struct vbus_pci_deviceshm params;
> +	unsigned long iflags;
> +	int ret;
> +
> +	if (!dev->handle)
> +		return -EINVAL;
> +
> +	params.devh   = dev->handle;
> +	params.id     = id;
> +	params.flags  = flags;
> +	params.datap  = (u64)__pa(ptr);
> +	params.len    = len;
> +
> +	if (signal) {
> +		/*
> +		 * The signal descriptor must be embedded within the
> +		 * provided ptr
> +		 */
> +		if (!sdesc
> +		    || (len < sizeof(*sdesc))
> +		    || ((void *)sdesc < ptr)
> +		    || ((void *)sdesc > (ptr + len - sizeof(*sdesc))))
> +			return -EINVAL;
> +
> +		_signal = kzalloc(sizeof(*_signal), GFP_KERNEL);
> +		if (!_signal)
> +			return -ENOMEM;
> +
> +		_signal_init(&_signal->signal, sdesc, &_signal_ops);
> +
> +		/*
> +		 * take another reference for the host.  This is dropped
> +		 * by a SHMCLOSE event
> +		 */
> +		shm_signal_get(&_signal->signal);
> +
> +		params.signal.offset = (u64)sdesc - (u64)ptr;
> +		params.signal.prio   = prio;
> +		params.signal.cookie = (u64)_signal;
> +
> +	} else
> +		params.signal.offset = -1; /* yes, this is a u32, but its ok */
> +
> +	ret = vbus_pci_hypercall(VBUS_PCI_HC_DEVSHM,
> +				 &params, sizeof(params));
> +	if (ret < 0) {
> +		if (_signal) {
> +			/*
> +			 * We held two references above, so we need to drop
> +			 * both of them
> +			 */
> +			shm_signal_put(&_signal->signal);
> +			shm_signal_put(&_signal->signal);
> +		}
> +
> +		return ret;
> +	}
> +
> +	if (signal) {
> +		_signal->handle = ret;
> +
> +		spin_lock_irqsave(&vbus_pci.lock, iflags);
> +
> +		list_add_tail(&_signal->list, &dev->shms);
> +
> +		spin_unlock_irqrestore(&vbus_pci.lock, iflags);
> +
> +		shm_signal_get(&_signal->signal);
> +		*signal = &_signal->signal;
> +	}
> +
> +	return 0;
> +}

This could be implemented by virtio devices as well, right?

> +static int
> +vbus_pci_device_call(struct vbus_device_proxy *vdev, u32 func, void *data,
> +		     size_t len, int flags)
> +{
> +	struct vbus_pci_device *dev = to_dev(vdev);
> +	struct vbus_pci_devicecall params = {
> +		.devh  = dev->handle,
> +		.func  = func,
> +		.datap = (u64)__pa(data),
> +		.len   = len,
> +		.flags = flags,
> +	};
> +
> +	if (!dev->handle)
> +		return -EINVAL;
> +
> +	return vbus_pci_hypercall(VBUS_PCI_HC_DEVCALL, &params, sizeof(params));
> +}

Why the indirection? It seems to me that you could do the simpler

static int
vbus_pci_device_call(struct vbus_device_proxy *vdev, u32 func, void *data,
		     size_t len, int flags)
{
	struct vbus_pci_device *dev = to_dev(vdev);
	struct vbus_pci_hypercall params = {
		.vector = func,
		.len    = len,
		.datap  = __pa(data),
	};
	spin_lock_irqsave(&dev.lock, flags);
	memcpy_toio(&dev.regs->hypercall.data, &params, sizeof(params));
	ret = ioread32(&dev.regs->hypercall.result);
	spin_unlock_irqrestore(&dev.lock, flags);

	return ret;
}

This gets rid of your 'handle' and the unwinding through an extra pointer
indirection. You just need to make sure that the device specific call numbers
don't conflict with any global ones.

> +
> +static struct ioq_notifier eventq_notifier;

> ...

> +/* Invoked whenever the hypervisor ioq_signal()s our eventq */
> +static void
> +eventq_wakeup(struct ioq_notifier *notifier)
> +{
> +	struct ioq_iterator iter;
> +	int ret;
> +
> +	/* We want to iterate on the head of the in-use index */
> +	ret = ioq_iter_init(&vbus_pci.eventq, &iter, ioq_idxtype_inuse, 0);
> +	BUG_ON(ret < 0);
> +
> +	ret = ioq_iter_seek(&iter, ioq_seek_head, 0, 0);
> +	BUG_ON(ret < 0);
> +
> +	/*
> +	 * The EOM is indicated by finding a packet that is still owned by
> +	 * the south side.
> +	 *
> +	 * FIXME: This in theory could run indefinitely if the host keeps
> +	 * feeding us events since there is nothing like a NAPI budget.  We
> +	 * might need to address that
> +	 */
> +	while (!iter.desc->sown) {
> +		struct ioq_ring_desc *desc  = iter.desc;
> +		struct vbus_pci_event *event;
> +
> +		event = (struct vbus_pci_event *)desc->cookie;
> +
> +		switch (event->eventid) {
> +		case VBUS_PCI_EVENT_DEVADD:
> +			event_devadd(&event->data.add);
> +			break;
> +		case VBUS_PCI_EVENT_DEVDROP:
> +			event_devdrop(&event->data.handle);
> +			break;
> +		case VBUS_PCI_EVENT_SHMSIGNAL:
> +			event_shmsignal(&event->data.handle);
> +			break;
> +		case VBUS_PCI_EVENT_SHMCLOSE:
> +			event_shmclose(&event->data.handle);
> +			break;
> +		default:
> +			printk(KERN_WARNING "VBUS_PCI: Unexpected event %d\n",
> +			       event->eventid);
> +			break;
> +		};
> +
> +		memset(event, 0, sizeof(*event));
> +
> +		/* Advance the in-use head */
> +		ret = ioq_iter_pop(&iter, 0);
> +		BUG_ON(ret < 0);
> +	}
> +
> +	/* And let the south side know that we changed the queue */
> +	ioq_signal(&vbus_pci.eventq, 0);
> +}

Ah, so you have a global event queue and your own device hotplug mechanism.
But why would you then still use PCI to back it? We already have PCI hotplug
to add and remove devices and you have defined per device notifier queues 
that you can use for waking up the device, right?

	Arnd <><
