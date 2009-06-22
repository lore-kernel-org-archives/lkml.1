Return-Path: <linux-kernel-owner+w=401wt.eu-S1751694AbZFVMOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbZFVMOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbZFVMN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:13:59 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:57161 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbZFVMN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:13:57 -0400
Message-ID: <4A3F757C.6030508@novell.com>
Date: Mon, 22 Jun 2009 08:13:48 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v8 3/3] KVM: add iosignalfd support
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622104435.GA11594@redhat.com>
In-Reply-To: <20090622104435.GA11594@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5BB765DA2A1D425F8A1558A1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5BB765DA2A1D425F8A1558A1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> Some comments below:
>
> On Thu, Jun 18, 2009 at 08:30:46PM -0400, Gregory Haskins wrote:
>  =20
>> iosignalfd is a mechanism to register PIO/MMIO regions to trigger an e=
ventfd
>> signal when written to by a guest.  Host userspace can register any ar=
bitrary
>> IO address with a corresponding eventfd and then pass the eventfd to a=

>> specific end-point of interest for handling.
>>
>> Normal IO requires a blocking round-trip since the operation may cause=

>> side-effects in the emulated model or may return data to the caller.
>> Therefore, an IO in KVM traps from the guest to the host, causes a VMX=
/SVM
>> "heavy-weight" exit back to userspace, and is ultimately serviced by q=
emu's
>> device model synchronously before returning control back to the vcpu.
>>
>> However, there is a subclass of IO which acts purely as a trigger for
>> other IO (such as to kick off an out-of-band DMA request, etc).  For t=
hese
>> patterns, the synchronous call is particularly expensive since we real=
ly
>> only want to simply get our notification transmitted asychronously and=

>> return as quickly as possible.  All the sychronous infrastructure to e=
nsure
>> proper data-dependencies are met in the normal IO case are just uneces=
sary
>> overhead for signalling.  This adds additional computational load on t=
he
>> system, as well as latency to the signalling path.
>>
>> Therefore, we provide a mechanism for registration of an in-kernel tri=
gger
>> point that allows the VCPU to only require a very brief, lightweight
>> exit just long enough to signal an eventfd.  This also means that any
>> clients compatible with the eventfd interface (which includes userspac=
e
>> and kernelspace equally well) can now register to be notified. The end=

>> result should be a more flexible and higher performance notification A=
PI
>> for the backend KVM hypervisor and perhipheral components.
>>
>> To test this theory, we built a test-harness called "doorbell".  This
>> module has a function called "doorbell_ring()" which simply increments=
 a
>> counter for each time the doorbell is signaled.  It supports signallin=
g
>> from either an eventfd, or an ioctl().
>>
>> We then wired up two paths to the doorbell: One via QEMU via a registe=
red
>> io region and through the doorbell ioctl().  The other is direct via
>> iosignalfd.
>>
>> You can download this test harness here:
>>
>> ftp://ftp.novell.com/dev/ghaskins/doorbell.tar.bz2
>>
>> The measured results are as follows:
>>
>> qemu-mmio:       110000 iops, 9.09us rtt
>> iosignalfd-mmio: 200100 iops, 5.00us rtt
>> iosignalfd-pio:  367300 iops, 2.72us rtt
>>
>> I didn't measure qemu-pio, because I have to figure out how to registe=
r a
>> PIO region with qemu's device model, and I got lazy.  However, for now=
 we
>> can extrapolate based on the data from the NULLIO runs of +2.56us for =
MMIO,
>> and -350ns for HC, we get:
>>
>> qemu-pio:      153139 iops, 6.53us rtt
>> iosignalfd-hc: 412585 iops, 2.37us rtt
>>
>> these are just for fun, for now, until I can gather more data.
>>
>> Here is a graph for your convenience:
>>
>> http://developer.novell.com/wiki/images/7/76/Iofd-chart.png
>>
>> The conclusion to draw is that we save about 4us by skipping the users=
pace
>> hop.
>>
>> --------------------
>>
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> ---
>>
>>  arch/x86/kvm/x86.c       |    1=20
>>  include/linux/kvm.h      |   15 ++
>>  include/linux/kvm_host.h |   10 +
>>  virt/kvm/eventfd.c       |  426 +++++++++++++++++++++++++++++++++++++=
+++++++++
>>  virt/kvm/kvm_main.c      |   11 +
>>  5 files changed, 459 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 1b91ea7..9b119e4 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1097,6 +1097,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>>  	case KVM_CAP_IRQ_INJECT_STATUS:
>>  	case KVM_CAP_ASSIGN_DEV_IRQ:
>>  	case KVM_CAP_IRQFD:
>> +	case KVM_CAP_IOSIGNALFD:
>>  	case KVM_CAP_PIT2:
>>  		r =3D 1;
>>  		break;
>> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
>> index 38ff31e..9de6486 100644
>> --- a/include/linux/kvm.h
>> +++ b/include/linux/kvm.h
>> @@ -307,6 +307,19 @@ struct kvm_guest_debug {
>>  	struct kvm_guest_debug_arch arch;
>>  };
>> =20
>> +#define KVM_IOSIGNALFD_FLAG_TRIGGER   (1 << 0)
>> +#define KVM_IOSIGNALFD_FLAG_PIO       (1 << 1)
>> +#define KVM_IOSIGNALFD_FLAG_DEASSIGN  (1 << 2)
>>    =20
>
> This is exposed to userspace authors.
> So - some documentation for flags?
>  =20

Yeah, its probably not a bad idea.  However, note that I did document
the interface in the qemu-kvm.git patch, and there isn't a lot of
precedent for documentation in kvm.h for other interfaces.

>  =20
>> +
>> +struct kvm_iosignalfd {
>> +	__u64 trigger;
>>    =20
>
> Is value, or trigger_value, a better name?
>  =20

I think trigger is fine personally, but I dont feel strongly either
way.  Any comments by others?

> Which bits are used if len is e.g. 1
> and what happens with unused bits?
>  =20

Will document.
>  =20
>> +	__u64 addr;
>> +	__u32 len;
>>    =20
>
> What are the legal values for len/addr?
> Probably should document them.
>
>  =20
Ack

>> +	__u32 fd;
>>    =20
>
> fd should probably be signed? You cast it to int later.
>
>  =20
Ack

>> +	__u32 flags;
>> +	__u8  pad[36];
>>    =20
>
> 4 byte padding not enough?
>
>  =20
It doesn't leave much room for expansion, so I like a round 64 better.

>> +};
>> +
>>  #define KVM_TRC_SHIFT           16
>>  /*
>>   * kvm trace categories
>> @@ -438,6 +451,7 @@ struct kvm_trace_rec {
>>  #define KVM_CAP_PIT2 33
>>  #endif
>>  #define KVM_CAP_SET_BOOT_CPU_ID 34
>> +#define KVM_CAP_IOSIGNALFD 35
>> =20
>>  #ifdef KVM_CAP_IRQ_ROUTING
>> =20
>> @@ -544,6 +558,7 @@ struct kvm_irqfd {
>>  #define KVM_IRQFD                  _IOW(KVMIO, 0x76, struct kvm_irqfd=
)
>>  #define KVM_CREATE_PIT2		   _IOW(KVMIO, 0x77, struct kvm_pit_config)
>>  #define KVM_SET_BOOT_CPU_ID        _IO(KVMIO, 0x78)
>> +#define KVM_IOSIGNALFD             _IOW(KVMIO, 0x79, struct kvm_iosig=
nalfd)
>> =20
>>  /*
>>   * ioctls for vcpu fds
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 707c4d8..6c0569a 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -146,6 +146,7 @@ struct kvm {
>>  	struct kvm_io_bus pio_bus;
>>  #ifdef CONFIG_HAVE_KVM_EVENTFD
>>    =20
>
> BTW, do we want this config option?
>  =20

I think so, yes.

>  =20
>>  	struct list_head irqfds;
>> +	struct list_head iosignalfds;
>>  #endif
>>  	struct kvm_vm_stat stat;
>>  	struct kvm_arch arch;
>> @@ -554,19 +555,24 @@ static inline void kvm_free_irq_routing(struct k=
vm *kvm) {}
>> =20
>>  #ifdef CONFIG_HAVE_KVM_EVENTFD
>> =20
>> -void kvm_irqfd_init(struct kvm *kvm);
>> +void kvm_eventfd_init(struct kvm *kvm);
>>  int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags);
>>  void kvm_irqfd_release(struct kvm *kvm);
>> +int kvm_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args);
>> =20
>>  #else
>> =20
>> -static inline void kvm_irqfd_init(struct kvm *kvm) {}
>> +static inline void kvm_eventfd_init(struct kvm *kvm) {}
>>  static inline int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int fla=
gs)
>>  {
>>  	return -EINVAL;
>>  }
>> =20
>>  static inline void kvm_irqfd_release(struct kvm *kvm) {}
>> +static inline int kvm_iosignalfd(struct kvm *kvm, struct kvm_iosignal=
fd *args)
>> +{
>> +	return -EINVAL;
>> +}
>>    =20
>
> I thought ENOTTY is the accepted error for an unsupported ioctl?
>
>  =20

Yeah, I think Avi suggested ENOSYS in a similar scenario for other code
I have.  Either is probably better than EINVAL.  Does anyone have a
preference between ENOTTY and ENOSYS?

>> =20
>>  #endif /* CONFIG_HAVE_KVM_EVENTFD */
>> =20
>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>> index 2c8028c..52ac455 100644
>> --- a/virt/kvm/eventfd.c
>> +++ b/virt/kvm/eventfd.c
>> @@ -21,6 +21,7 @@
>>   */
>> =20
>>  #include <linux/kvm_host.h>
>> +#include <linux/kvm.h>
>>  #include <linux/workqueue.h>
>>  #include <linux/syscalls.h>
>>  #include <linux/wait.h>
>> @@ -29,6 +30,9 @@
>>  #include <linux/list.h>
>>  #include <linux/eventfd.h>
>>  #include <linux/srcu.h>
>> +#include <linux/kernel.h>
>> +
>> +#include "iodev.h"
>> =20
>>  /*
>>   * ------------------------------------------------------------------=
--
>> @@ -202,9 +206,10 @@ fail:
>>  }
>> =20
>>  void
>> -kvm_irqfd_init(struct kvm *kvm)
>> +kvm_eventfd_init(struct kvm *kvm)
>>  {
>>  	INIT_LIST_HEAD(&kvm->irqfds);
>> +	INIT_LIST_HEAD(&kvm->iosignalfds);
>>  }
>> =20
>>  void
>> @@ -215,3 +220,422 @@ kvm_irqfd_release(struct kvm *kvm)
>>  	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list)
>>  		irqfd_disconnect(irqfd);
>>  }
>> +
>> +/*
>> + * ------------------------------------------------------------------=
--
>> + * iosignalfd: translate a PIO/MMIO memory write to an eventfd signal=
=2E
>> + *
>> + * userspace can register a PIO/MMIO address with an eventfd for reci=
eving
>>    =20
>
> typo
>  =20

Thx, will fix
>  =20
>> + * notification when the memory has been touched.
>> + * ------------------------------------------------------------------=
--
>> + */
>> +
>> +/*
>> + * Design note: We create one PIO/MMIO device (iosignalfd_group) whic=
h
>> + * aggregates  one or more iosignalfd_items.  Each item points to exa=
ctly one
>> + * eventfd, and can be registered to trigger on any write to the grou=
p
>> + * (wildcard), or to a write of a specific value.  If more than one i=
tem is to
>> + * be supported, the addr/len ranges must all be identical in the gro=
up.  If a
>> + * trigger value is to be supported on a particular item, the group r=
ange must
>> + * be exactly the width of the trigger.
>>    =20
>
> Some duplicate spaces in the text above, apparently at random places.
>
>  =20

-ENOPARSE ;)

Can you elaborate?

>> + */
>> +
>> +struct _iosignalfd_item {
>> +	struct list_head     list;
>> +	struct file         *file;
>> +	u64                  match;
>> +	struct rcu_head      rcu;
>> +	int                  wildcard:1;
>> +};
>> +
>> +struct _iosignalfd_group {
>> +	struct list_head     list;
>> +	u64                  addr;
>> +	size_t               length;
>> +	size_t               count;
>> +	struct list_head     items;
>> +	struct kvm_io_device dev;
>> +	struct rcu_head      rcu;
>> +};
>> +
>> +static inline struct _iosignalfd_group *
>> +to_group(struct kvm_io_device *dev)
>> +{
>> +	return container_of(dev, struct _iosignalfd_group, dev);
>> +}
>> +
>> +static void
>> +iosignalfd_item_free(struct _iosignalfd_item *item)
>> +{
>> +	fput(item->file);
>> +	kfree(item);
>> +}
>> +
>> +static void
>> +iosignalfd_item_deferred_free(struct rcu_head *rhp)
>> +{
>> +	struct _iosignalfd_item *item;
>> +
>> +	item =3D container_of(rhp, struct _iosignalfd_item, rcu);
>> +
>> +	iosignalfd_item_free(item);
>> +}
>> +
>> +static void
>> +iosignalfd_group_deferred_free(struct rcu_head *rhp)
>> +{
>> +	struct _iosignalfd_group *group;
>> +
>> +	group =3D container_of(rhp, struct _iosignalfd_group, rcu);
>> +
>> +	kfree(group);
>> +}
>> +
>> +static int
>> +iosignalfd_group_in_range(struct kvm_io_device *this, gpa_t addr, int=
 len,
>> +			  int is_write)
>> +{
>> +	struct _iosignalfd_group *p =3D to_group(this);
>> +
>> +	return ((addr >=3D p->addr && (addr < p->addr + p->length)));
>> +}
>>    =20
>
> What does this test? len is ignored ...
>
>  =20
Yeah, I was following precedent with other IO devices.  However, this
*is* sloppy, I agree.  Will fix.

>> +
>> +static int
>>    =20
>
> This seems to be returning bool ...
>  =20

Ack
>  =20
>> +iosignalfd_is_match(struct _iosignalfd_group *group,
>> +		    struct _iosignalfd_item *item,
>> +		    const void *val,
>> +		    int len)
>> +{
>> +	u64 _val;
>> +
>> +	if (len !=3D group->length)
>> +		/* mis-matched length is always a miss */
>> +		return false;
>>    =20
>
> Why is that? what if there's 8 byte write which covers
> a 4 byte group?
>  =20

v7 and earlier used to allow that for wildcards, actually.   It of
course would never make sense to allow mis-matched writes for
non-wildcards, since the idea is to match the value exactly.  However,
the feedback I got from Avi was that we should make the wildcard vs
non-wildcard access symmetrical and ensure they both conform to the size.=

>  =20
>> +
>> +	if (item->wildcard)
>> +		/* wildcard is always a hit */
>> +		return true;
>> +
>> +	/* otherwise, we have to actually compare the data */
>> +
>> +	if (!IS_ALIGNED((unsigned long)val, len))
>> +		/* protect against this request causing a SIGBUS */
>> +		return false;
>>    =20
>
> Could you explain what this does please?
>  =20
Sure:  item->match is a fixed u64 to represent all group->length
values.  So it might have a 1, 2, 4, or 8 byte value in it.  When I
write arrives, we need to cast the data-register (in this case
represented by (void*)val) into a u64 so the equality check (see [A],
below) can be done.  However, you can't cast an unaligned pointer, or it
will SIGBUS on many (most?) architectures.

> I thought misaligned accesses are allowed.
>  =20
If thats true, we are in trouble ;)

>  =20
>> +
>> +	switch (len) {
>> +	case 1:
>> +		_val =3D *(u8 *)val;
>> +		break;
>> +	case 2:
>> +		_val =3D *(u16 *)val;
>> +		break;
>> +	case 4:
>> +		_val =3D *(u32 *)val;
>> +		break;
>> +	case 8:
>> +		_val =3D *(u64 *)val;
>> +		break;
>> +	default:
>> +		return false;
>> +	}
>>    =20
>
> So legal values for len are 1,2,4 and 8?
> Might be a good idea to document this.
>
>  =20
Ack

>> +
>> +	return _val =3D=3D item->match;
>>    =20

[A]

>> +}
>> +
>> +/*
>> + * MMIO/PIO writes trigger an event (if the data matches).
>> + *
>> + * This is invoked by the io_bus subsystem in response to an address =
match
>> + * against the group.  We must then walk the list of individual items=
 to check
>> + * for a match and, if applicable, to send the appropriate signal. If=
 the item
>> + * in question does not have a "match" pointer, it is considered a wi=
ldcard
>> + * and will always generate a signal.  There can be an arbitrary numb=
er
>> + * of distinct matches or wildcards per group.
>> + */
>> +static void
>> +iosignalfd_group_write(struct kvm_io_device *this, gpa_t addr, int le=
n,
>> +		       const void *val)
>> +{
>> +	struct _iosignalfd_group *group =3D to_group(this);
>> +	struct _iosignalfd_item *item;
>> +
>> +	rcu_read_lock();
>> +
>> +	list_for_each_entry_rcu(item, &group->items, list) {
>> +		if (iosignalfd_is_match(group, item, val, len))
>> +			eventfd_signal(item->file, 1);
>> +	}
>> +
>> +	rcu_read_unlock();
>> +}
>> +
>> +/*
>> + * MMIO/PIO reads against the group indiscriminately return all zeros=

>> + */
>>    =20
>
> Does it have to be so? It would be better to bounce reads to
> userspace...
>
>  =20
Good idea.  I can set is_write =3D false and I should never get this
function called.

>> +static void
>> +iosignalfd_group_read(struct kvm_io_device *this, gpa_t addr, int len=
,
>> +		      void *val)
>> +{
>> +	memset(val, 0, len);
>> +}
>> +
>> +/*
>> + * This function is called as KVM is completely shutting down.  We do=
 not
>> + * need to worry about locking or careful RCU dancing...just nuke any=
thing
>> + * we have as quickly as possible
>> + */
>> +static void
>> +iosignalfd_group_destructor(struct kvm_io_device *this)
>> +{
>> +	struct _iosignalfd_group *group =3D to_group(this);
>> +	struct _iosignalfd_item *item, *tmp;
>> +
>> +	list_for_each_entry_safe(item, tmp, &group->items, list) {
>> +		list_del(&item->list);
>> +		iosignalfd_item_free(item);
>> +	}
>> +
>> +	list_del(&group->list);
>> +	kfree(group);
>> +}
>> +
>> +static const struct kvm_io_device_ops iosignalfd_ops =3D {
>> +	.read       =3D iosignalfd_group_read,
>> +	.write      =3D iosignalfd_group_write,
>> +	.in_range   =3D iosignalfd_group_in_range,
>> +	.destructor =3D iosignalfd_group_destructor,
>> +};
>> +
>> +/* assumes kvm->lock held */
>> +static struct _iosignalfd_group *
>> +iosignalfd_group_find(struct kvm *kvm, u64 addr)
>> +{
>> +	struct _iosignalfd_group *group;
>> +
>> +	list_for_each_entry(group, &kvm->iosignalfds, list) {
>>    =20
>
> {} not needed here
>  =20

Ack
>  =20
>> +		if (group->addr =3D=3D addr)
>> +			return group;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +/* assumes kvm->lock is held */
>> +static struct _iosignalfd_group *
>> +iosignalfd_group_create(struct kvm *kvm, struct kvm_io_bus *bus,
>> +			u64 addr, size_t len)
>> +{
>> +	struct _iosignalfd_group *group;
>> +	int ret;
>> +
>> +	group =3D kzalloc(sizeof(*group), GFP_KERNEL);
>> +	if (!group)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	INIT_LIST_HEAD(&group->list);
>> +	INIT_LIST_HEAD(&group->items);
>> +	group->addr   =3D addr;
>> +	group->length =3D len;
>> +	kvm_iodevice_init(&group->dev, &iosignalfd_ops);
>> +
>> +	ret =3D kvm_io_bus_register_dev(kvm, bus, &group->dev);
>> +	if (ret < 0) {
>> +		kfree(group);
>> +		return ERR_PTR(ret);
>> +	}
>> +
>> +	list_add_tail(&group->list, &kvm->iosignalfds);
>> +
>> +	return group;
>> +}
>> +
>> +static int
>> +kvm_assign_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
>> +{
>> +	int                       pio =3D args->flags & KVM_IOSIGNALFD_FLAG_=
PIO;
>> +	struct kvm_io_bus        *bus =3D pio ? &kvm->pio_bus : &kvm->mmio_b=
us;
>> +	struct _iosignalfd_group *group =3D NULL;
>>    =20
>
> why does group need to be initialized?
>
>  =20
>> +	struct _iosignalfd_item  *item =3D NULL;
>>    =20
>
> Why does item need to be initialized?
>
>  =20

Probably leftover from versions prior to v8.  Will fix.

>> +	struct file              *file;
>> +	int                       ret;
>> +
>> +	if (args->len > sizeof(u64))
>>    =20
>
> Is e.g. value 3 legal?
>  =20

Ack.  Will check against legal values.

>  =20
>> +		return -EINVAL;
>>    =20
>
>  =20
>> +
>> +	file =3D eventfd_fget(args->fd);
>> +	if (IS_ERR(file))
>> +		return PTR_ERR(file);
>> +
>> +	item =3D kzalloc(sizeof(*item), GFP_KERNEL);
>> +	if (!item) {
>> +		ret =3D -ENOMEM;
>> +		goto fail;
>> +	}
>> +
>> +	INIT_LIST_HEAD(&item->list);
>> +	item->file =3D file;
>> +
>> +	/*
>> +	 * A trigger address is optional, otherwise this is a wildcard
>> +	 */
>> +	if (args->flags & KVM_IOSIGNALFD_FLAG_TRIGGER)
>> +		item->match =3D args->trigger;
>> +	else
>> +		item->wildcard =3D true;
>> +
>> +	mutex_lock(&kvm->lock);
>> +
>> +	/*
>> +	 * Put an upper limit on the number of items we support
>> +	 */
>>    =20
>
> Groups and items, actually, right?
>
>  =20

Yeah, though technically that is implicit when you say "items", since
each group always has at least one item.  I will try to make this
clearer, though.

>> +	if (kvm->io_device_count >=3D CONFIG_KVM_MAX_IO_DEVICES) {
>> +		ret =3D -ENOSPC;
>> +		goto unlock_fail;
>> +	}
>> +
>> +	group =3D iosignalfd_group_find(kvm, args->addr);
>> +	if (!group) {
>> +
>> +		group =3D iosignalfd_group_create(kvm, bus,
>> +						args->addr, args->len);
>> +		if (IS_ERR(group)) {
>> +			ret =3D PTR_ERR(group);
>> +			goto unlock_fail;
>> +		}
>> +
>> +		/*
>> +		 * Note: We do not increment io_device_count for the first item,
>> +		 * as this is represented by the group device that we just
>> +		 * registered.  Make sure we handle this properly when we
>> +		 * deassign the last item
>> +		 */
>> +	} else {
>> +
>> +		if (group->length !=3D args->len) {
>> +			/*
>> +			 * Existing groups must have the same addr/len tuple
>> +			 * or we reject the request
>> +			 */
>> +			ret =3D -EINVAL;
>> +			goto unlock_fail;
>>    =20
>
> Most errors seem to trigger EINVAL. Applications will be
> easier to debug if different errors are returned on
> different mistakes.

Yeah, agreed.  Will try to differentiate some errors here.

>  E.g. here EBUSY might be good. And same
> in other places.
>
>  =20

Actually, I think EBUSY is supposed to be a transitory error, and would
not be appropriate to use here.  That said, your point is taken: Find
more appropriate and descriptive errors.

>> +		}
>> +
>> +		kvm->io_device_count++;
>> +	}
>> +
>> +	/*
>> +	 * Note: We are committed to succeed at this point since we have
>> +	 * (potentially) published a new group-device.  Any failure handling=

>> +	 * added in the future after this point will need to be carefully
>> +	 * considered.
>> +	 */
>> +
>> +	list_add_tail_rcu(&item->list, &group->items);
>> +	group->count++;
>> +
>> +	mutex_unlock(&kvm->lock);
>> +
>> +	return 0;
>> +
>> +unlock_fail:
>> +	mutex_unlock(&kvm->lock);
>> +fail:
>> +	if (item)
>> +		/*
>> +		 * it would have never made it to the group->items list
>> +		 * in the failure path, so we dont need to worry about removing
>> +		 * it
>> +		 */
>> +		kfree(item);
>> +
>> +	fput(file);
>> +
>> +	return ret;
>> +}
>> +
>> +
>> +static int
>> +kvm_deassign_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)=

>> +{
>> +	int                       pio =3D args->flags & KVM_IOSIGNALFD_FLAG_=
PIO;
>> +	struct kvm_io_bus        *bus =3D pio ? &kvm->pio_bus : &kvm->mmio_b=
us;
>> +	struct _iosignalfd_group *group;
>> +	struct _iosignalfd_item  *item, *tmp;
>> +	struct file              *file;
>> +	int                       ret =3D 0;
>> +
>> +	file =3D eventfd_fget(args->fd);
>> +	if (IS_ERR(file))
>> +		return PTR_ERR(file);
>> +
>> +	mutex_lock(&kvm->lock);
>> +
>> +	group =3D iosignalfd_group_find(kvm, args->addr);
>> +	if (!group) {
>> +		ret =3D -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	/*
>> +	 * Exhaustively search our group->items list for any items that migh=
t
>> +	 * match the specified fd, and (carefully) remove each one found.
>> +	 */
>> +	list_for_each_entry_safe(item, tmp, &group->items, list) {
>> +
>> +		if (item->file !=3D file)
>> +			continue;
>> +
>> +		list_del_rcu(&item->list);
>> +		group->count--;
>> +		if (group->count)
>> +			/*
>> +			 * We only decrement the global count if this is *not*
>> +			 * the last item.  The last item will be accounted for
>> +			 * by the io_bus_unregister
>> +			 */
>> +			kvm->io_device_count--;
>> +
>> +		/*
>> +		 * The item may be still referenced inside our group->write()
>> +		 * path's RCU read-side CS, so defer the actual free to the
>> +		 * next grace
>> +		 */
>> +		call_rcu(&item->rcu, iosignalfd_item_deferred_free);
>> +	}
>> +
>> +	/*
>> +	 * Check if the group is now completely vacated as a result of
>> +	 * removing the items.  If so, unregister/delete it
>> +	 */
>> +	if (!group->count) {
>> +
>> +		kvm_io_bus_unregister_dev(kvm, bus, &group->dev);
>> +
>> +		/*
>> +		 * Like the item, the group may also still be referenced as
>> +		 * per above.  However, the kvm->iosignalfds list is not
>> +		 * RCU protected (its protected by kvm->lock instead) so
>> +		 * we can just plain-vanilla remove it.  What needs to be
>> +		 * done carefully is the actual freeing of the group pointer
>> +		 * since we walk the group->items list within the RCU CS.
>> +		 */
>> +		list_del(&group->list);
>> +		call_rcu(&group->rcu, iosignalfd_group_deferred_free);
>>    =20
>
> This is a deferred call, is it not, with no guarantee on when it will
> run? If correct I think synchronize_rcu might be better here:
> - can the module go away while iosignalfd_group_deferred_free is
>   running?
>  =20

Good catch.  Once I go this route it will be easy to use SRCU instead of
RCU, too.  So I will fix this up.


> - can eventfd be signalled *after* ioctl exits? If yes
>   this might confuse applications if they use the eventfd
>   for something else.
>  =20

Not by iosignalfd.  Once this function completes, we synchronously
guarantee that no more IO activity will generate an event on the
affected eventfds.  Of course, this has no bearing on whether some other
producer wont signal, but that is beyond the scope of iosignalfd.
>  =20
>> +	}
>> +
>> +out:
>> +	mutex_unlock(&kvm->lock);
>> +
>> +	fput(file);
>> +
>> +	return ret;
>> +}
>> +
>> +int
>> +kvm_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
>> +{
>> +	if (args->flags & KVM_IOSIGNALFD_FLAG_DEASSIGN)
>> +		return kvm_deassign_iosignalfd(kvm, args);
>> +
>> +	return kvm_assign_iosignalfd(kvm, args);
>> +}
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 42cbea7..e6495d4 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -971,7 +971,7 @@ static struct kvm *kvm_create_vm(void)
>>  	atomic_inc(&kvm->mm->mm_count);
>>  	spin_lock_init(&kvm->mmu_lock);
>>  	kvm_io_bus_init(&kvm->pio_bus);
>> -	kvm_irqfd_init(kvm);
>> +	kvm_eventfd_init(kvm);
>>  	mutex_init(&kvm->lock);
>>  	mutex_init(&kvm->irq_lock);
>>  	kvm_io_bus_init(&kvm->mmio_bus);
>> @@ -2227,6 +2227,15 @@ static long kvm_vm_ioctl(struct file *filp,
>>  		r =3D kvm_irqfd(kvm, data.fd, data.gsi, data.flags);
>>  		break;
>>  	}
>> +	case KVM_IOSIGNALFD: {
>> +		struct kvm_iosignalfd data;
>> +
>> +		r =3D -EFAULT;
>> +		if (copy_from_user(&data, argp, sizeof data))
>> +			goto out;
>> +		r =3D kvm_iosignalfd(kvm, &data);
>> +		break;
>> +	}
>>  #ifdef CONFIG_KVM_APIC_ARCHITECTURE
>>  	case KVM_SET_BOOT_CPU_ID:
>>  		r =3D 0;
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>    =20

Thanks Michael,
-Greg



--------------enig5BB765DA2A1D425F8A1558A1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko/dXwACgkQlOSOBdgZUxnapwCfaCOngwTbSx+8s04K4dNXt5wf
6u0An16/Q5WNLDutKyb2AsgbvbXUxKz2
=hbEG
-----END PGP SIGNATURE-----

--------------enig5BB765DA2A1D425F8A1558A1--
