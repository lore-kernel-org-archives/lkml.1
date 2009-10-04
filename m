Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbZJDKZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbZJDKZt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 06:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbZJDKZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 06:25:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673AbZJDKZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 06:25:47 -0400
Message-ID: <4AC8780D.1060800@redhat.com>
Date: Sun, 04 Oct 2009 12:25:17 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] KVM: introduce "xinterface" API for external	interaction
 with guests
References: <20091002201159.4014.33268.stgit@dev.haskins.net> <20091002201927.4014.29432.stgit@dev.haskins.net>
In-Reply-To: <20091002201927.4014.29432.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2009 10:19 PM, Gregory Haskins wrote:
> What: xinterface is a mechanism that allows kernel modules external to
> the kvm.ko proper to interface with a running guest.  It accomplishes
> this by creating an abstracted interface which does not expose any
> private details of the guest or its related KVM structures, and provides
> a mechanism to find and bind to this interface at run-time.
>    

If this is needed, it should be done as a virt_address_space to which 
kvm and other modules bind, instead of as something that kvm exports and 
other modules import.  The virt_address_space can be identified by an fd 
and passed around to kvm and other modules.

> Why: There are various subsystems that would like to interact with a KVM
> guest which are ideally suited to exist outside the domain of the kvm.ko
> core logic. For instance, external pci-passthrough, virtual-bus, and
> virtio-net modules are currently under development.  In order for these
> modules to successfully interact with the guest, they need, at the very
> least, various interfaces for signaling IO events, pointer translation,
> and possibly memory mapping.
>
> The signaling case is covered by the recent introduction of the
> irqfd/ioeventfd mechanisms.  This patch provides a mechanism to cover the
> other cases.  Note that today we only expose pointer-translation related
> functions, but more could be added at a future date as needs arise.
>
> Example usage: QEMU instantiates a guest, and an external module "foo"
> that desires the ability to interface with the guest (say via
> open("/dev/foo")).  QEMU may then pass the kvmfd to foo via an
> ioctl, such as: ioctl(foofd, FOO_SET_VMID,&kvmfd).  Upon receipt, the
> foo module can issue kvm_xinterface_bind(kvmfd) to acquire
> the proper context.  Internally, the struct kvm* and associated
> struct module* will remain pinned at least until the foo module calls
> kvm_xinterface_put().
>
>    

So, under my suggestion above, you'd call 
sys_create_virt_address_space(), populate it, and pass the result to kvm 
and to foo.  This allows the use of virt_address_space without kvm and 
doesn't require foo to interact with kvm.

> +struct kvm_xinterface_ops {
> +	unsigned long (*copy_to)(struct kvm_xinterface *intf,
> +				 unsigned long gpa, const void *src,
> +				 unsigned long len);
> +	unsigned long (*copy_from)(struct kvm_xinterface *intf, void *dst,
> +				   unsigned long gpa, unsigned long len);
> +	struct kvm_xvmap* (*vmap)(struct kvm_xinterface *intf,
> +				  unsigned long gpa,
> +				  unsigned long len);
>    

How would vmap() work with live migration?

> +
> +static inline void
> +_kvm_xinterface_release(struct kref *kref)
> +{
> +	struct kvm_xinterface *intf;
> +	struct module *owner;
> +
> +	intf = container_of(kref, struct kvm_xinterface, kref);
> +
> +	owner = intf->owner;
> +	rmb();
>    

Why rmb?

> +
> +	intf->ops->release(intf);
> +	module_put(owner);
> +}
> +
>
> +
> +/*
> + * gpa_to_hva() - translate a guest-physical to host-virtual using
> + * a per-cpu cache of the memslot.
> + *
> + * The gfn_to_memslot() call is relatively expensive, and the gpa access
> + * patterns exhibit a high degree of locality.  Therefore, lets cache
> + * the last slot used on a per-cpu basis to optimize the lookup
> + *
> + * assumes slots_lock held for read
> + */
> +static unsigned long
> +gpa_to_hva(struct _xinterface *_intf, unsigned long gpa)
> +{
> +	int                     cpu     = get_cpu();
> +	unsigned long           gfn     = gpa>>  PAGE_SHIFT;
> +	struct kvm_memory_slot *memslot = _intf->slotcache[cpu];
> +	unsigned long           addr    = 0;
> +
> +	if (!memslot
> +	    || gfn<  memslot->base_gfn
> +	    || gfn>= memslot->base_gfn + memslot->npages) {
> +
> +		memslot = gfn_to_memslot(_intf->kvm, gfn);
> +		if (!memslot)
> +			goto out;
> +
> +		_intf->slotcache[cpu] = memslot;
> +	}
> +
> +	addr = _gfn_to_hva(gfn, memslot) + offset_in_page(gpa);
> +
> +out:
> +	put_cpu();
> +
> +	return addr;
> +}
>    


A simple per-vcpu cache (in struct kvm_vcpu) is likely to give better 
results.

> +static unsigned long
> +xinterface_copy_to(struct kvm_xinterface *intf, unsigned long gpa,
> +		   const void *src, unsigned long n)
> +{
> +	struct _xinterface *_intf = to_intf(intf);
> +	unsigned long dst;
> +	bool kthread = !current->mm;
> +
> +	down_read(&_intf->kvm->slots_lock);
> +
> +	dst = gpa_to_hva(_intf, gpa);
> +	if (!dst)
> +		goto out;
> +
> +	if (kthread)
> +		use_mm(_intf->mm);
> +
> +	if (kthread || _intf->mm == current->mm)
> +		n = copy_to_user((void *)dst, src, n);
> +	else
> +		n = _slow_copy_to_user(_intf, dst, src, n);
>    

Can't you switch the mm temporarily instead of this?


-- 
error compiling committee.c: too many arguments to function

