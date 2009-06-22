Return-Path: <linux-kernel-owner+w=401wt.eu-S1751566AbZFVMbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbZFVMbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbZFVMbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:31:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47388 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbZFVMbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:31:04 -0400
Date: Mon, 22 Jun 2009 15:30:22 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v8 3/3] KVM: add iosignalfd support
Message-ID: <20090622123022.GC12867@redhat.com>
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622104435.GA11594@redhat.com> <4A3F757C.6030508@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3F757C.6030508@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 08:13:48AM -0400, Gregory Haskins wrote:
> >> + * notification when the memory has been touched.
> >> + * --------------------------------------------------------------------
> >> + */
> >> +
> >> +/*
> >> + * Design note: We create one PIO/MMIO device (iosignalfd_group) which
> >> + * aggregates  one or more iosignalfd_items.  Each item points to exactly one
                   ^^                             ^^
> >> + * eventfd, and can be registered to trigger on any write to the group
> >> + * (wildcard), or to a write of a specific value.  If more than one item is to
                                                       ^^
> >> + * be supported, the addr/len ranges must all be identical in the group.  If a
                                                                              ^^
> >> + * trigger value is to be supported on a particular item, the group range must
> >> + * be exactly the width of the trigger.
> >>     
> >
> > Some duplicate spaces in the text above, apparently at random places.
> >
> >   
> 
> -ENOPARSE ;)
> 
> Can you elaborate?


Marked with ^^

> 
> >> + */
> >> +
> >> +struct _iosignalfd_item {
> >> +	struct list_head     list;
> >> +	struct file         *file;
> >> +	u64                  match;
> >> +	struct rcu_head      rcu;
> >> +	int                  wildcard:1;
> >> +};
> >> +
> >> +struct _iosignalfd_group {
> >> +	struct list_head     list;
> >> +	u64                  addr;
> >> +	size_t               length;
> >> +	size_t               count;
> >> +	struct list_head     items;
> >> +	struct kvm_io_device dev;
> >> +	struct rcu_head      rcu;
> >> +};
> >> +
> >> +static inline struct _iosignalfd_group *
> >> +to_group(struct kvm_io_device *dev)
> >> +{
> >> +	return container_of(dev, struct _iosignalfd_group, dev);
> >> +}
> >> +
> >> +static void
> >> +iosignalfd_item_free(struct _iosignalfd_item *item)
> >> +{
> >> +	fput(item->file);
> >> +	kfree(item);
> >> +}
> >> +
> >> +static void
> >> +iosignalfd_item_deferred_free(struct rcu_head *rhp)
> >> +{
> >> +	struct _iosignalfd_item *item;
> >> +
> >> +	item = container_of(rhp, struct _iosignalfd_item, rcu);
> >> +
> >> +	iosignalfd_item_free(item);
> >> +}
> >> +
> >> +static void
> >> +iosignalfd_group_deferred_free(struct rcu_head *rhp)
> >> +{
> >> +	struct _iosignalfd_group *group;
> >> +
> >> +	group = container_of(rhp, struct _iosignalfd_group, rcu);
> >> +
> >> +	kfree(group);
> >> +}
> >> +
> >> +static int
> >> +iosignalfd_group_in_range(struct kvm_io_device *this, gpa_t addr, int len,
> >> +			  int is_write)
> >> +{
> >> +	struct _iosignalfd_group *p = to_group(this);
> >> +
> >> +	return ((addr >= p->addr && (addr < p->addr + p->length)));
> >> +}
> >>     
> >
> > What does this test? len is ignored ...
> >
> >   
> Yeah, I was following precedent with other IO devices.  However, this
> *is* sloppy, I agree.  Will fix.
> 
> >> +
> >> +static int
> >>     
> >
> > This seems to be returning bool ...
> >   
> 
> Ack
> >   
> >> +iosignalfd_is_match(struct _iosignalfd_group *group,
> >> +		    struct _iosignalfd_item *item,
> >> +		    const void *val,
> >> +		    int len)
> >> +{
> >> +	u64 _val;
> >> +
> >> +	if (len != group->length)
> >> +		/* mis-matched length is always a miss */
> >> +		return false;
> >>     
> >
> > Why is that? what if there's 8 byte write which covers
> > a 4 byte group?
> >   
> 
> v7 and earlier used to allow that for wildcards, actually.   It of
> course would never make sense to allow mis-matched writes for
> non-wildcards, since the idea is to match the value exactly.  However,
> the feedback I got from Avi was that we should make the wildcard vs
> non-wildcard access symmetrical and ensure they both conform to the size.
> >   
> >> +
> >> +	if (item->wildcard)
> >> +		/* wildcard is always a hit */
> >> +		return true;
> >> +
> >> +	/* otherwise, we have to actually compare the data */
> >> +
> >> +	if (!IS_ALIGNED((unsigned long)val, len))
> >> +		/* protect against this request causing a SIGBUS */
> >> +		return false;
> >>     
> >
> > Could you explain what this does please?
> >   
> Sure:  item->match is a fixed u64 to represent all group->length
> values.  So it might have a 1, 2, 4, or 8 byte value in it.  When I
> write arrives, we need to cast the data-register (in this case
> represented by (void*)val) into a u64 so the equality check (see [A],
> below) can be done.  However, you can't cast an unaligned pointer, or it
> will SIGBUS on many (most?) architectures.

I mean guest access. Does it have to be aligned?
You could memcpy the value...

> > I thought misaligned accesses are allowed.
> >   
> If thats true, we are in trouble ;)

I think it works at least on x86:
http://en.wikipedia.org/wiki/Packed#x86_and_x86-64

> >   
> >> +
> >> +	switch (len) {
> >> +	case 1:
> >> +		_val = *(u8 *)val;
> >> +		break;
> >> +	case 2:
> >> +		_val = *(u16 *)val;
> >> +		break;
> >> +	case 4:
> >> +		_val = *(u32 *)val;
> >> +		break;
> >> +	case 8:
> >> +		_val = *(u64 *)val;
> >> +		break;
> >> +	default:
> >> +		return false;
> >> +	}
> >>     
> >
> > So legal values for len are 1,2,4 and 8?
> > Might be a good idea to document this.
> >
> >   
> Ack
> 
> >> +
> >> +	return _val == item->match;
> >>     
> 
> [A]
> 
> >> +}
> >> +
> >> +/*
> >> + * MMIO/PIO writes trigger an event (if the data matches).
> >> + *
> >> + * This is invoked by the io_bus subsystem in response to an address match
> >> + * against the group.  We must then walk the list of individual items to check
> >> + * for a match and, if applicable, to send the appropriate signal. If the item
> >> + * in question does not have a "match" pointer, it is considered a wildcard
> >> + * and will always generate a signal.  There can be an arbitrary number
> >> + * of distinct matches or wildcards per group.
> >> + */
> >> +static void
> >> +iosignalfd_group_write(struct kvm_io_device *this, gpa_t addr, int len,
> >> +		       const void *val)
> >> +{
> >> +	struct _iosignalfd_group *group = to_group(this);
> >> +	struct _iosignalfd_item *item;
> >> +
> >> +	rcu_read_lock();
> >> +
> >> +	list_for_each_entry_rcu(item, &group->items, list) {
> >> +		if (iosignalfd_is_match(group, item, val, len))
> >> +			eventfd_signal(item->file, 1);
> >> +	}
> >> +
> >> +	rcu_read_unlock();
> >> +}
> >> +
> >> +/*
> >> + * MMIO/PIO reads against the group indiscriminately return all zeros
> >> + */
> >>     
> >
> > Does it have to be so? It would be better to bounce reads to
> > userspace...
> >
> >   
> Good idea.  I can set is_write = false and I should never get this
> function called.
> 
> >> +static void
> >> +iosignalfd_group_read(struct kvm_io_device *this, gpa_t addr, int len,
> >> +		      void *val)
> >> +{
> >> +	memset(val, 0, len);
> >> +}
> >> +
> >> +/*
> >> + * This function is called as KVM is completely shutting down.  We do not
> >> + * need to worry about locking or careful RCU dancing...just nuke anything
> >> + * we have as quickly as possible
> >> + */
> >> +static void
> >> +iosignalfd_group_destructor(struct kvm_io_device *this)
> >> +{
> >> +	struct _iosignalfd_group *group = to_group(this);
> >> +	struct _iosignalfd_item *item, *tmp;
> >> +
> >> +	list_for_each_entry_safe(item, tmp, &group->items, list) {
> >> +		list_del(&item->list);
> >> +		iosignalfd_item_free(item);
> >> +	}
> >> +
> >> +	list_del(&group->list);
> >> +	kfree(group);
> >> +}
> >> +
> >> +static const struct kvm_io_device_ops iosignalfd_ops = {
> >> +	.read       = iosignalfd_group_read,
> >> +	.write      = iosignalfd_group_write,
> >> +	.in_range   = iosignalfd_group_in_range,
> >> +	.destructor = iosignalfd_group_destructor,
> >> +};
> >> +
> >> +/* assumes kvm->lock held */
> >> +static struct _iosignalfd_group *
> >> +iosignalfd_group_find(struct kvm *kvm, u64 addr)
> >> +{
> >> +	struct _iosignalfd_group *group;
> >> +
> >> +	list_for_each_entry(group, &kvm->iosignalfds, list) {
> >>     
> >
> > {} not needed here
> >   
> 
> Ack
> >   
> >> +		if (group->addr == addr)
> >> +			return group;
> >> +	}
> >> +
> >> +	return NULL;
> >> +}
> >> +
> >> +/* assumes kvm->lock is held */
> >> +static struct _iosignalfd_group *
> >> +iosignalfd_group_create(struct kvm *kvm, struct kvm_io_bus *bus,
> >> +			u64 addr, size_t len)
> >> +{
> >> +	struct _iosignalfd_group *group;
> >> +	int ret;
> >> +
> >> +	group = kzalloc(sizeof(*group), GFP_KERNEL);
> >> +	if (!group)
> >> +		return ERR_PTR(-ENOMEM);
> >> +
> >> +	INIT_LIST_HEAD(&group->list);
> >> +	INIT_LIST_HEAD(&group->items);
> >> +	group->addr   = addr;
> >> +	group->length = len;
> >> +	kvm_iodevice_init(&group->dev, &iosignalfd_ops);
> >> +
> >> +	ret = kvm_io_bus_register_dev(kvm, bus, &group->dev);
> >> +	if (ret < 0) {
> >> +		kfree(group);
> >> +		return ERR_PTR(ret);
> >> +	}
> >> +
> >> +	list_add_tail(&group->list, &kvm->iosignalfds);
> >> +
> >> +	return group;
> >> +}
> >> +
> >> +static int
> >> +kvm_assign_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
> >> +{
> >> +	int                       pio = args->flags & KVM_IOSIGNALFD_FLAG_PIO;
> >> +	struct kvm_io_bus        *bus = pio ? &kvm->pio_bus : &kvm->mmio_bus;
> >> +	struct _iosignalfd_group *group = NULL;
> >>     
> >
> > why does group need to be initialized?
> >
> >   
> >> +	struct _iosignalfd_item  *item = NULL;
> >>     
> >
> > Why does item need to be initialized?
> >
> >   
> 
> Probably leftover from versions prior to v8.  Will fix.
> 
> >> +	struct file              *file;
> >> +	int                       ret;
> >> +
> >> +	if (args->len > sizeof(u64))
> >>     
> >
> > Is e.g. value 3 legal?
> >   
> 
> Ack.  Will check against legal values.
> 
> >   
> >> +		return -EINVAL;
> >>     
> >
> >   
> >> +
> >> +	file = eventfd_fget(args->fd);
> >> +	if (IS_ERR(file))
> >> +		return PTR_ERR(file);
> >> +
> >> +	item = kzalloc(sizeof(*item), GFP_KERNEL);
> >> +	if (!item) {
> >> +		ret = -ENOMEM;
> >> +		goto fail;
> >> +	}
> >> +
> >> +	INIT_LIST_HEAD(&item->list);
> >> +	item->file = file;
> >> +
> >> +	/*
> >> +	 * A trigger address is optional, otherwise this is a wildcard
> >> +	 */
> >> +	if (args->flags & KVM_IOSIGNALFD_FLAG_TRIGGER)
> >> +		item->match = args->trigger;
> >> +	else
> >> +		item->wildcard = true;
> >> +
> >> +	mutex_lock(&kvm->lock);
> >> +
> >> +	/*
> >> +	 * Put an upper limit on the number of items we support
> >> +	 */
> >>     
> >
> > Groups and items, actually, right?
> >
> >   
> 
> Yeah, though technically that is implicit when you say "items", since
> each group always has at least one item.  I will try to make this
> clearer, though.
> 
> >> +	if (kvm->io_device_count >= CONFIG_KVM_MAX_IO_DEVICES) {
> >> +		ret = -ENOSPC;
> >> +		goto unlock_fail;
> >> +	}
> >> +
> >> +	group = iosignalfd_group_find(kvm, args->addr);
> >> +	if (!group) {
> >> +
> >> +		group = iosignalfd_group_create(kvm, bus,
> >> +						args->addr, args->len);
> >> +		if (IS_ERR(group)) {
> >> +			ret = PTR_ERR(group);
> >> +			goto unlock_fail;
> >> +		}
> >> +
> >> +		/*
> >> +		 * Note: We do not increment io_device_count for the first item,
> >> +		 * as this is represented by the group device that we just
> >> +		 * registered.  Make sure we handle this properly when we
> >> +		 * deassign the last item
> >> +		 */
> >> +	} else {
> >> +
> >> +		if (group->length != args->len) {
> >> +			/*
> >> +			 * Existing groups must have the same addr/len tuple
> >> +			 * or we reject the request
> >> +			 */
> >> +			ret = -EINVAL;
> >> +			goto unlock_fail;
> >>     
> >
> > Most errors seem to trigger EINVAL. Applications will be
> > easier to debug if different errors are returned on
> > different mistakes.
> 
> Yeah, agreed.  Will try to differentiate some errors here.
> 
> >  E.g. here EBUSY might be good. And same
> > in other places.
> >
> >   
> 
> Actually, I think EBUSY is supposed to be a transitory error, and would
> not be appropriate to use here.  That said, your point is taken: Find
> more appropriate and descriptive errors.
> 
> >> +		}
> >> +
> >> +		kvm->io_device_count++;
> >> +	}
> >> +
> >> +	/*
> >> +	 * Note: We are committed to succeed at this point since we have
> >> +	 * (potentially) published a new group-device.  Any failure handling
> >> +	 * added in the future after this point will need to be carefully
> >> +	 * considered.
> >> +	 */
> >> +
> >> +	list_add_tail_rcu(&item->list, &group->items);
> >> +	group->count++;
> >> +
> >> +	mutex_unlock(&kvm->lock);
> >> +
> >> +	return 0;
> >> +
> >> +unlock_fail:
> >> +	mutex_unlock(&kvm->lock);
> >> +fail:
> >> +	if (item)
> >> +		/*
> >> +		 * it would have never made it to the group->items list
> >> +		 * in the failure path, so we dont need to worry about removing
> >> +		 * it
> >> +		 */
> >> +		kfree(item);
> >> +
> >> +	fput(file);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +
> >> +static int
> >> +kvm_deassign_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
> >> +{
> >> +	int                       pio = args->flags & KVM_IOSIGNALFD_FLAG_PIO;
> >> +	struct kvm_io_bus        *bus = pio ? &kvm->pio_bus : &kvm->mmio_bus;
> >> +	struct _iosignalfd_group *group;
> >> +	struct _iosignalfd_item  *item, *tmp;
> >> +	struct file              *file;
> >> +	int                       ret = 0;
> >> +
> >> +	file = eventfd_fget(args->fd);
> >> +	if (IS_ERR(file))
> >> +		return PTR_ERR(file);
> >> +
> >> +	mutex_lock(&kvm->lock);
> >> +
> >> +	group = iosignalfd_group_find(kvm, args->addr);
> >> +	if (!group) {
> >> +		ret = -EINVAL;
> >> +		goto out;
> >> +	}
> >> +
> >> +	/*
> >> +	 * Exhaustively search our group->items list for any items that might
> >> +	 * match the specified fd, and (carefully) remove each one found.
> >> +	 */
> >> +	list_for_each_entry_safe(item, tmp, &group->items, list) {
> >> +
> >> +		if (item->file != file)
> >> +			continue;
> >> +
> >> +		list_del_rcu(&item->list);
> >> +		group->count--;
> >> +		if (group->count)
> >> +			/*
> >> +			 * We only decrement the global count if this is *not*
> >> +			 * the last item.  The last item will be accounted for
> >> +			 * by the io_bus_unregister
> >> +			 */
> >> +			kvm->io_device_count--;
> >> +
> >> +		/*
> >> +		 * The item may be still referenced inside our group->write()
> >> +		 * path's RCU read-side CS, so defer the actual free to the
> >> +		 * next grace
> >> +		 */
> >> +		call_rcu(&item->rcu, iosignalfd_item_deferred_free);
> >> +	}
> >> +
> >> +	/*
> >> +	 * Check if the group is now completely vacated as a result of
> >> +	 * removing the items.  If so, unregister/delete it
> >> +	 */
> >> +	if (!group->count) {
> >> +
> >> +		kvm_io_bus_unregister_dev(kvm, bus, &group->dev);
> >> +
> >> +		/*
> >> +		 * Like the item, the group may also still be referenced as
> >> +		 * per above.  However, the kvm->iosignalfds list is not
> >> +		 * RCU protected (its protected by kvm->lock instead) so
> >> +		 * we can just plain-vanilla remove it.  What needs to be
> >> +		 * done carefully is the actual freeing of the group pointer
> >> +		 * since we walk the group->items list within the RCU CS.
> >> +		 */
> >> +		list_del(&group->list);
> >> +		call_rcu(&group->rcu, iosignalfd_group_deferred_free);
> >>     
> >
> > This is a deferred call, is it not, with no guarantee on when it will
> > run? If correct I think synchronize_rcu might be better here:
> > - can the module go away while iosignalfd_group_deferred_free is
> >   running?
> >   
> 
> Good catch.  Once I go this route it will be easy to use SRCU instead of
> RCU, too.  So I will fix this up.
> 
> 
> > - can eventfd be signalled *after* ioctl exits? If yes
> >   this might confuse applications if they use the eventfd
> >   for something else.
> >   
> 
> Not by iosignalfd.  Once this function completes, we synchronously
> guarantee that no more IO activity will generate an event on the
> affected eventfds.  Of course, this has no bearing on whether some other
> producer wont signal, but that is beyond the scope of iosignalfd.
> >   
> >> +	}
> >> +
> >> +out:
> >> +	mutex_unlock(&kvm->lock);
> >> +
> >> +	fput(file);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +int
> >> +kvm_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
> >> +{
> >> +	if (args->flags & KVM_IOSIGNALFD_FLAG_DEASSIGN)
> >> +		return kvm_deassign_iosignalfd(kvm, args);
> >> +
> >> +	return kvm_assign_iosignalfd(kvm, args);
> >> +}
> >> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> >> index 42cbea7..e6495d4 100644
> >> --- a/virt/kvm/kvm_main.c
> >> +++ b/virt/kvm/kvm_main.c
> >> @@ -971,7 +971,7 @@ static struct kvm *kvm_create_vm(void)
> >>  	atomic_inc(&kvm->mm->mm_count);
> >>  	spin_lock_init(&kvm->mmu_lock);
> >>  	kvm_io_bus_init(&kvm->pio_bus);
> >> -	kvm_irqfd_init(kvm);
> >> +	kvm_eventfd_init(kvm);
> >>  	mutex_init(&kvm->lock);
> >>  	mutex_init(&kvm->irq_lock);
> >>  	kvm_io_bus_init(&kvm->mmio_bus);
> >> @@ -2227,6 +2227,15 @@ static long kvm_vm_ioctl(struct file *filp,
> >>  		r = kvm_irqfd(kvm, data.fd, data.gsi, data.flags);
> >>  		break;
> >>  	}
> >> +	case KVM_IOSIGNALFD: {
> >> +		struct kvm_iosignalfd data;
> >> +
> >> +		r = -EFAULT;
> >> +		if (copy_from_user(&data, argp, sizeof data))
> >> +			goto out;
> >> +		r = kvm_iosignalfd(kvm, &data);
> >> +		break;
> >> +	}
> >>  #ifdef CONFIG_KVM_APIC_ARCHITECTURE
> >>  	case KVM_SET_BOOT_CPU_ID:
> >>  		r = 0;
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe kvm" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>     
> 
> Thanks Michael,
> -Greg
> 
> 


