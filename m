Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbZFDQv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbZFDQv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbZFDQvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:51:51 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58994 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbZFDQvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:51:46 -0400
Date: Thu, 4 Jun 2009 09:51:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, mtosatti@redhat.com, markmc@redhat.com
Subject: Re: [KVM PATCH v5 2/2] kvm: add iosignalfd support
Message-ID: <20090604165145.GA6739@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090603200835.8206.8039.stgit@dev.haskins.net> <20090603201748.8206.96424.stgit@dev.haskins.net> <20090604013459.GG6640@linux.vnet.ibm.com> <4A273795.6080809@novell.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <4A273795.6080809@novell.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 03, 2009 at 10:55:17PM -0400, Gregory Haskins wrote:
> Paul E. McKenney wrote:
> > On Wed, Jun 03, 2009 at 04:17:49PM -0400, Gregory Haskins wrote:
> >   
> >> iosignalfd is a mechanism to register PIO/MMIO regions to trigger an eventfd
> >> signal when written to by a guest.  Host userspace can register any arbitrary
> >> IO address with a corresponding eventfd and then pass the eventfd to a
> >> specific end-point of interest for handling.
> >>
> >> Normal IO requires a blocking round-trip since the operation may cause
> >> side-effects in the emulated model or may return data to the caller.
> >> Therefore, an IO in KVM traps from the guest to the host, causes a VMX/SVM
> >> "heavy-weight" exit back to userspace, and is ultimately serviced by qemu's
> >> device model synchronously before returning control back to the vcpu.
> >>
> >> However, there is a subclass of IO which acts purely as a trigger for
> >> other IO (such as to kick off an out-of-band DMA request, etc).  For these
> >> patterns, the synchronous call is particularly expensive since we really
> >> only want to simply get our notification transmitted asychronously and
> >> return as quickly as possible.  All the sychronous infrastructure to ensure
> >> proper data-dependencies are met in the normal IO case are just unecessary
> >> overhead for signalling.  This adds additional computational load on the
> >> system, as well as latency to the signalling path.
> >>
> >> Therefore, we provide a mechanism for registration of an in-kernel trigger
> >> point that allows the VCPU to only require a very brief, lightweight
> >> exit just long enough to signal an eventfd.  This also means that any
> >> clients compatible with the eventfd interface (which includes userspace
> >> and kernelspace equally well) can now register to be notified. The end
> >> result should be a more flexible and higher performance notification API
> >> for the backend KVM hypervisor and perhipheral components.
> >>
> >> To test this theory, we built a test-harness called "doorbell".  This
> >> module has a function called "doorbell_ring()" which simply increments a
> >> counter for each time the doorbell is signaled.  It supports signalling
> >> from either an eventfd, or an ioctl().
> >>
> >> We then wired up two paths to the doorbell: One via QEMU via a registered
> >> io region and through the doorbell ioctl().  The other is direct via
> >> iosignalfd.
> >>
> >> You can download this test harness here:
> >>
> >> ftp://ftp.novell.com/dev/ghaskins/doorbell.tar.bz2
> >>
> >> The measured results are as follows:
> >>
> >> qemu-mmio:       110000 iops, 9.09us rtt
> >> iosignalfd-mmio: 200100 iops, 5.00us rtt
> >> iosignalfd-pio:  367300 iops, 2.72us rtt
> >>
> >> I didn't measure qemu-pio, because I have to figure out how to register a
> >> PIO region with qemu's device model, and I got lazy.  However, for now we
> >> can extrapolate based on the data from the NULLIO runs of +2.56us for MMIO,
> >> and -350ns for HC, we get:
> >>
> >> qemu-pio:      153139 iops, 6.53us rtt
> >> iosignalfd-hc: 412585 iops, 2.37us rtt
> >>
> >> these are just for fun, for now, until I can gather more data.
> >>
> >> Here is a graph for your convenience:
> >>
> >> http://developer.novell.com/wiki/images/7/76/Iofd-chart.png
> >>
> >> The conclusion to draw is that we save about 4us by skipping the userspace
> >> hop.
> >>
> >> --------------------
> >>     
> >
> > One set of decision criteria for RCU vs. SRCU below, and one question
> > about the RCU reader running concurrently with a deletion.  Looks pretty
> > good, in general!
> >
> > 							Thanx, Paul
> >
> >   
> >> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> >> ---
> >>
> >>  arch/x86/kvm/x86.c       |    1 
> >>  include/linux/kvm.h      |   15 ++
> >>  include/linux/kvm_host.h |   10 +
> >>  virt/kvm/eventfd.c       |  356 ++++++++++++++++++++++++++++++++++++++++++++++
> >>  virt/kvm/kvm_main.c      |   11 +
> >>  5 files changed, 389 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >> index c1ed485..c96c0e3 100644
> >> --- a/arch/x86/kvm/x86.c
> >> +++ b/arch/x86/kvm/x86.c
> >> @@ -1097,6 +1097,7 @@ int kvm_dev_ioctl_check_extension(long ext)
> >>  	case KVM_CAP_IRQ_INJECT_STATUS:
> >>  	case KVM_CAP_ASSIGN_DEV_IRQ:
> >>  	case KVM_CAP_IRQFD:
> >> +	case KVM_CAP_IOSIGNALFD:
> >>  	case KVM_CAP_PIT2:
> >>  		r = 1;
> >>  		break;
> >> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> >> index 632a856..53b720d 100644
> >> --- a/include/linux/kvm.h
> >> +++ b/include/linux/kvm.h
> >> @@ -300,6 +300,19 @@ struct kvm_guest_debug {
> >>  	struct kvm_guest_debug_arch arch;
> >>  };
> >>
> >> +#define KVM_IOSIGNALFD_FLAG_TRIGGER   (1 << 0)
> >> +#define KVM_IOSIGNALFD_FLAG_PIO       (1 << 1)
> >> +#define KVM_IOSIGNALFD_FLAG_DEASSIGN  (1 << 2)
> >> +
> >> +struct kvm_iosignalfd {
> >> +	__u64 trigger;
> >> +	__u64 addr;
> >> +	__u32 len;
> >> +	__u32 fd;
> >> +	__u32 flags;
> >> +	__u8  pad[36];
> >> +};
> >> +
> >>  #define KVM_TRC_SHIFT           16
> >>  /*
> >>   * kvm trace categories
> >> @@ -430,6 +443,7 @@ struct kvm_trace_rec {
> >>  #ifdef __KVM_HAVE_PIT
> >>  #define KVM_CAP_PIT2 33
> >>  #endif
> >> +#define KVM_CAP_IOSIGNALFD 34
> >>
> >>  #ifdef KVM_CAP_IRQ_ROUTING
> >>
> >> @@ -537,6 +551,7 @@ struct kvm_irqfd {
> >>  #define KVM_DEASSIGN_DEV_IRQ       _IOW(KVMIO, 0x75, struct kvm_assigned_irq)
> >>  #define KVM_IRQFD                  _IOW(KVMIO, 0x76, struct kvm_irqfd)
> >>  #define KVM_CREATE_PIT2		   _IOW(KVMIO, 0x77, struct kvm_pit_config)
> >> +#define KVM_IOSIGNALFD             _IOW(KVMIO, 0x78, struct kvm_iosignalfd)
> >>
> >>  /*
> >>   * ioctls for vcpu fds
> >> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> >> index 216fe07..b705960 100644
> >> --- a/include/linux/kvm_host.h
> >> +++ b/include/linux/kvm_host.h
> >> @@ -138,6 +138,7 @@ struct kvm {
> >>  	struct kvm_io_bus pio_bus;
> >>  #ifdef CONFIG_HAVE_KVM_EVENTFD
> >>  	struct list_head irqfds;
> >> +	struct list_head iosignalfds;
> >>  #endif
> >>  	struct kvm_vm_stat stat;
> >>  	struct kvm_arch arch;
> >> @@ -533,19 +534,24 @@ static inline void kvm_free_irq_routing(struct kvm *kvm) {}
> >>
> >>  #ifdef CONFIG_HAVE_KVM_EVENTFD
> >>
> >> -void kvm_irqfd_init(struct kvm *kvm);
> >> +void kvm_eventfd_init(struct kvm *kvm);
> >>  int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags);
> >>  void kvm_irqfd_release(struct kvm *kvm);
> >> +int kvm_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args);
> >>
> >>  #else
> >>
> >> -static inline void kvm_irqfd_init(struct kvm *kvm) {}
> >> +static inline void kvm_eventfd_init(struct kvm *kvm) {}
> >>  static inline int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
> >>  {
> >>  	return -EINVAL;
> >>  }
> >>
> >>  static inline void kvm_irqfd_release(struct kvm *kvm) {}
> >> +static inline int kvm_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
> >> +{
> >> +	return -EINVAL;
> >> +}
> >>
> >>  #endif /* CONFIG_HAVE_KVM_EVENTFD */
> >>
> >> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> >> index f3f2ea1..77befb3 100644
> >> --- a/virt/kvm/eventfd.c
> >> +++ b/virt/kvm/eventfd.c
> >> @@ -21,6 +21,7 @@
> >>   */
> >>
> >>  #include <linux/kvm_host.h>
> >> +#include <linux/kvm.h>
> >>  #include <linux/workqueue.h>
> >>  #include <linux/syscalls.h>
> >>  #include <linux/wait.h>
> >> @@ -29,6 +30,8 @@
> >>  #include <linux/list.h>
> >>  #include <linux/eventfd.h>
> >>
> >> +#include "iodev.h"
> >> +
> >>  /*
> >>   * --------------------------------------------------------------------
> >>   * irqfd: Allows an fd to be used to inject an interrupt to the guest
> >> @@ -208,9 +211,10 @@ kvm_deassign_irqfd(struct kvm *kvm, int fd, int gsi)
> >>  }
> >>
> >>  void
> >> -kvm_irqfd_init(struct kvm *kvm)
> >> +kvm_eventfd_init(struct kvm *kvm)
> >>  {
> >>  	INIT_LIST_HEAD(&kvm->irqfds);
> >> +	INIT_LIST_HEAD(&kvm->iosignalfds);
> >>  }
> >>
> >>  int
> >> @@ -233,3 +237,353 @@ kvm_irqfd_release(struct kvm *kvm)
> >>  		irqfd_release(irqfd);
> >>  	}
> >>  }
> >> +
> >> +/*
> >> + * --------------------------------------------------------------------
> >> + * iosignalfd: translate a PIO/MMIO memory write to an eventfd signal.
> >> + *
> >> + * userspace can register a PIO/MMIO address with an eventfd for recieving
> >> + * notification when the memory has been touched.
> >> + * --------------------------------------------------------------------
> >> + */
> >> +
> >> +/*
> >> + * Design note: We create one PIO/MMIO device (iosignalfd_group) which
> >> + * aggregates  one or more iosignalfd_items.  Each item points to exactly one
> >> + * eventfd, and can be registered to trigger on any write to the group
> >> + * (wildcard), or to a write of a specific value.  If more than one item is to
> >> + * be supported, the addr/len ranges must all be identical in the group.  If a
> >> + * trigger value is to be supported on a particular item, the group range must
> >> + * be exactly the width of the trigger.
> >> + */
> >> +
> >> +struct _iosignalfd_item {
> >> +	struct list_head     list;
> >> +	struct file         *file;
> >> +	unsigned char       *match;
> >> +	struct rcu_head      rcu;
> >> +};
> >> +
> >> +struct _iosignalfd_group {
> >> +	struct list_head     list;
> >> +	u64                  addr;
> >> +	size_t               length;
> >> +	struct list_head     items;
> >> +	struct kvm_io_device dev;
> >> +};
> >> +
> >> +static inline struct _iosignalfd_group *to_group(struct kvm_io_device *dev)
> >> +{
> >> +	return container_of(dev, struct _iosignalfd_group, dev);
> >> +}
> >> +
> >> +static inline struct _iosignalfd_item *to_item(struct rcu_head *rhp)
> >> +{
> >> +	return container_of(rhp, struct _iosignalfd_item, rcu);
> >> +}
> >>     
> >
> > Given that you only use to_item() in one place, not clear to me that it
> > is a win compared to open-coding it.  In contrast, to_group() is used
> > in several places, so it makes sense to define it.
> >   
> 
> Yeah, I think open-coding it resulted in a 80+ line that I had to break,
> and I hate that.  So I went for consistency and tidiness instead, if but
> a tad overkill. ;)
> >   
> >> +static int
> >> +iosignalfd_group_in_range(struct kvm_io_device *this, gpa_t addr, int len,
> >> +			  int is_write)
> >> +{
> >> +	struct _iosignalfd_group *p = to_group(this);
> >> +
> >> +	return ((addr >= p->addr && (addr < p->addr + p->length)));
> >> +}
> >> +
> >> +static int
> >> +iosignalfd_is_match(struct _iosignalfd_group *group,
> >> +		    struct _iosignalfd_item *item,
> >> +		    const void *val,
> >> +		    int len)
> >> +{
> >> +	if (!item->match)
> >> +		/* wildcard is a hit */
> >> +		return true;
> >> +
> >> +	if (len != group->length)
> >> +		/* mis-matched length is a miss */
> >> +		return false;
> >> +
> >> +	/* otherwise, we have to actually compare the data */
> >> +	return !memcmp(item->match, val, len) ? true : false;
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
> >> +	/* FIXME: We should probably use SRCU */
> >>     
> >
> > Some test questions to help with this decision:
> >
> > 1.	Ignoring lock-contention issues, would you be willing to hold a
> > 	spinlock_t across this critical section?  If the answer is
> > 	"yes", then you should also be willing to use rcu_read_lock().
> > 	If the answer is "no", proceed to the next question.
> >
> > 2.	Is this critical section's execution time almost always less than
> > 	a hundred microseconds or so?  If the answer is "yes", then you
> > 	should also be willing to use rcu_read_lock().	If the answer is
> > 	"no", proceed to the next question.
> >
> > 3.	Is this critical section executed infrequently (say, less than once
> > 	per few jiffies, on average), and is the critical section's
> > 	execution time less than a jiffy or so?  If the answer is "yes",
> > 	then you should also be willing to use rcu_read_lock().  If the
> > 	answer is "no", proceed to the next question.
> >
> > 4.	Did you get here?  If so, you probably don't want to use
> > 	rcu_read_lock().  Consider using something like srcu_read_lock(),
> > 	reference counts, or sleeplocks instead.
> >
> > Of course, these questions should be regarded as rough rules of thumb.
> > And for every rough rule of thumb, there will be exceptions.  These
> > questions should still serve as a good general guide.
> >   
> 
> Actually as it stands right now the eventfd_signal() takes a
> spin_lock_irq() for its duration, so a basic rcu_read_lock() may be in
> the noise (at least for now).  I'd like to work with Davide at some
> point in the future to change eventfd internals to allow signalling
> callbacks to be optionally preemptible (at least when they are called
> from preemptible code to begin with), but we can address this code path
> at that time.
> 
> The biggest caveat here is that while today the eventfd_signal()
> unavoidably introduces its own non-preemptible section, iosignalfd could
> conceivably be composed of an arbitrarily long list of
> iosignalfd_items.  We would therefore be extending this CS out a bit
> further than the single eventfd_signal overhead alone would imply.  That
> might be justification in of itself to use something more friendly, like
> srcu.

How long would the list normally be?  What conditions/configurations
would result in it being longer than (say) 1,000 elements?

> Out of curiosity, how much more expensive is an srcu read-side CS
> compared to plain rcu?  How about compared to an atomic (like
> atomic_inc)?  Don't go off running some microbenchmarks just for me.  I
> am just wondering if you have measured it in the past and know the
> relative numbers off the top of your head.

The attached table appeared in IBM Systems Journal last year.  It shows
srcu_read_lock() and srcu_read_unlock() being about the same cost as
rcu_read_lock_bh() and rcu_read_unlock_bh().  Of course, different
systems will see slightly different costs.  Either way, -much- cheaper
than a cache miss.

> >> +	rcu_read_lock();
> >> +
> >> +	list_for_each_entry_rcu(item, &group->items, list) {
> >> +		if (iosignalfd_is_match(group, item, val, len))
> >> +			eventfd_signal(item->file, 1);
> >>     
> >
> > From what I can see, this code could invoke eventfd_signal() on an
> > item that just got list_del_rcu()ed.  Is this really OK?
> >   
> 
> If I understand the question, this is similar to the situation with the
> irqfd review we just did:  that is, there is a window of time between
> unlinking the object and its destruction, and the question is whether
> its still ok to use the object during this window?
> 
> If that is true, the answer is "yes".  As in the irqfd case, I really
> only care about making sure that we cannot invoke the free()/fput()
> function while this critical section referenced above is running.  We
> hold a valid reference to item->file until the point that the
> iosignal_item_free() method is called (via call_rcu), so the
> eventfd_signal() should be ok as long as it completes before then.

Sounds good, then!

> > (No idea whether or not it is OK myself.  Looks like we might change
> > some state in the underlying file and attempt to wake up some processes.
> > Might be OK, might not, depending on what you are up to.)
> >
> >   
> >> +	}
> >> +
> >> +	rcu_read_unlock();
> >> +}
> >> +
> >> +/*
> >> + * MMIO/PIO reads against the group indiscriminately return all zeros
> >> + */
> >> +static void
> >> +iosignalfd_group_read(struct kvm_io_device *this, gpa_t addr, int len,
> >> +		      void *val)
> >> +{
> >> +	memset(val, 0, len);
> >> +}
> >> +
> >> +static void
> >> +_iosignalfd_group_destructor(struct _iosignalfd_group *group)
> >> +{
> >> +	list_del(&group->list);
> >> +	kfree(group);
> >> +}
> >> +
> >> +static void
> >> +iosignalfd_group_destructor(struct kvm_io_device *this)
> >> +{
> >> +	struct _iosignalfd_group *group = to_group(this);
> >> +
> >> +	_iosignalfd_group_destructor(group);
> >> +}
> >> +
> >> +/* assumes kvm->lock held */
> >> +static struct _iosignalfd_group *
> >> +iosignalfd_group_find(struct kvm *kvm, u64 addr)
> >> +{
> >> +	struct _iosignalfd_group *group;
> >> +
> >> +	list_for_each_entry(group, &kvm->iosignalfds, list) {
> >> +		if (group->addr == addr)
> >> +			return group;
> >> +	}
> >> +
> >> +	return NULL;
> >> +}
> >> +
> >> +static const struct kvm_io_device_ops iosignalfd_ops = {
> >> +	.read       = iosignalfd_group_read,
> >> +	.write      = iosignalfd_group_write,
> >> +	.in_range   = iosignalfd_group_in_range,
> >> +	.destructor = iosignalfd_group_destructor,
> >> +};
> >> +
> >> +/*
> >> + * Atomically find an existing group, or create a new one if it doesn't already
> >> + * exist.
> >> + *
> >> + * assumes kvm->lock is held
> >> + */
> >> +static struct _iosignalfd_group *
> >> +iosignalfd_group_get(struct kvm *kvm, struct kvm_io_bus *bus,
> >> +		      u64 addr, size_t len)
> >> +{
> >> +	struct _iosignalfd_group *group;
> >> +
> >> +	group = iosignalfd_group_find(kvm, addr);
> >> +	if (!group) {
> >> +		int ret;
> >> +
> >> +		group = kzalloc(sizeof(*group), GFP_KERNEL);
> >> +		if (!group)
> >> +			return ERR_PTR(-ENOMEM);
> >> +
> >> +		INIT_LIST_HEAD(&group->list);
> >> +		INIT_LIST_HEAD(&group->items);
> >> +		group->addr   = addr;
> >> +		group->length = len;
> >> +		kvm_iodevice_init(&group->dev, &iosignalfd_ops);
> >> +
> >> +		ret = kvm_io_bus_register_dev(bus, &group->dev);
> >> +		if (ret < 0) {
> >> +			kfree(group);
> >> +			return ERR_PTR(ret);
> >> +		}
> >> +
> >> +		list_add_tail(&group->list, &kvm->iosignalfds);
> >> +
> >> +	} else if (group->length != len)
> >> +		/*
> >> +		 * Existing groups must have the same addr/len tuple or we
> >> +		 * reject the request
> >> +		 */
> >> +		return ERR_PTR(-EINVAL);
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
> >> +	struct _iosignalfd_item  *item = NULL;
> >> +	struct file              *file;
> >> +	int                       ret;
> >> +
> >> +	file = eventfd_fget(args->fd);
> >> +	if (IS_ERR(file)) {
> >> +		ret = PTR_ERR(file);
> >> +		return ret;
> >> +	}
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
> >> +	 * Registering a "trigger" address is optional.  If this flag
> >> +	 * is not specified, we leave the item->match pointer NULL, which
> >> +	 * indicates a wildcard
> >> +	 */
> >> +	if (args->flags & KVM_IOSIGNALFD_FLAG_TRIGGER) {
> >> +		if (args->len > sizeof(u64)) {
> >> +			ret = -EINVAL;
> >> +			goto fail;
> >> +		}
> >> +
> >> +		item->match = kzalloc(args->len, GFP_KERNEL);
> >> +		if (!item->match) {
> >> +			ret = -ENOMEM;
> >> +			goto fail;
> >> +		}
> >> +
> >> +		if (copy_from_user(item->match,
> >> +				   (void *)args->trigger,
> >> +				   args->len)) {
> >> +			ret = -EFAULT;
> >> +			goto fail;
> >> +		}
> >> +	}
> >> +
> >> +	mutex_lock(&kvm->lock);
> >> +
> >> +	group = iosignalfd_group_get(kvm, bus, args->addr, args->len);
> >> +	if (IS_ERR(group)) {
> >> +		ret = PTR_ERR(group);
> >> +		mutex_unlock(&kvm->lock);
> >> +		goto fail;
> >> +	}
> >> +
> >> +	/*
> >> +	 * Note: We are committed to succeed at this point since we have
> >> +	 * (potentially) published a new group-device.  Any failure handling
> >> +	 * added in the future after this point will need to be handled
> >> +	 * carefully.
> >> +	 */
> >> +
> >> +	list_add_tail_rcu(&item->list, &group->items);
> >>     
> >
> > Good, protected by kvm->lock.
> >
> >   
> >> +	mutex_unlock(&kvm->lock);
> >> +
> >> +	return 0;
> >> +
> >> +fail:
> >> +	if (item) {
> >> +		/*
> >> +		 * it would have never made it to the group->items list
> >> +		 * in the failure path, so we dont need to worry about removing
> >> +		 * it
> >> +		 */
> >> +		kfree(item->match);
> >> +		kfree(item);
> >> +	}
> >> +
> >> +	if (file)
> >> +		fput(file);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static void
> >> +iosignalfd_item_free(struct rcu_head *rhp)
> >> +{
> >> +	struct _iosignalfd_item *item = to_item(rhp);
> >> +
> >> +	fput(item->file);
> >> +	kfree(item->match);
> >> +	kfree(item);
> >> +}
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
> >> +	mutex_lock(&kvm->lock);
> >> +
> >> +	group = iosignalfd_group_find(kvm, args->addr);
> >> +	if (!group) {
> >> +		ret = -EINVAL;
> >> +		goto out;
> >> +	}
> >> +
> >> +	file = eventfd_fget(args->fd);
> >> +	if (IS_ERR(file)) {
> >> +		ret = PTR_ERR(file);
> >> +		goto out;
> >> +	}
> >> +
> >> +	list_for_each_entry_safe(item, tmp, &group->items, list) {
> >>     
> 
> Just to be sure, its ok to use a non-rcu list iterator in conjunction
> with the list_add/del_rcu mutating primitives as long as I provide my
> own mutal exclusion (e.g. kvm->lock), right?

Correct.  The _rcu variants of the list iterators are only required in
situations where the list might be concurrently changing.  If you are
preventing such change (in this case by holding the relevant lock), then
it is OK to use the non-_rcu variants of the list iterators.

> >> +		/*
> >> +		 * any items registered at this group-address with the matching
> >> +		 * eventfd will be removed
> >> +		 */
> >> +		if (item->file != file)
> >> +			continue;
> >> +
> >> +		list_del_rcu(&item->list);
> >>     
> >
> > Good, also protected by kvm->lock.
> >
> >   
> >> +		call_rcu(&item->rcu, iosignalfd_item_free);
> >>     
> >
> > And also good here, deferring free of the RCU-protected structures.
> >   
> 
> Out of curiosity: Would call_rcu() work if we were using srcu instead? 
> Or is my only choice a blocking synchronize_srcu() here?  I couldn't
> seem to find a call_srcu().

Indeed, there is no call_srcu().  The reason for omitting call_srcu() is
to prevent memory piling up in case an SRCU reader blocks indefinitely.
With synchronize_srcu(), the amount of memory waiting for a grace period
is limited by the number of tasks blocked in synchronize_srcu().

If you really do need call_rcu(), one approach would be to traverse the
list in pieces.  One way to do this is as follows:

o	Have a number of elements that you are willing to traverse in
	one go, say 512 of them.

o	If you reach that limit, mark the current element and exit
	the RCU read-side critical section, retaining a reference
	to the marked element.  The marking operation must be performed
	under the protection of the lock used to modify the list.

	Hmm...  Unfortunately, this is a mutex, which means that it
	cannot be acquired in an RCU read-side critical section.
	So the mark will need to be set with a cmpxchg operation.
	If it is zero, set it to one.  If it is not zero, advance
	to the next element and retry.

o	If you need to delete the element, use a cmpxchg operation
	to set the mark to two.  If successful, use call_rcu() just
	like you do now.  Otherwise, if the value is 1, remove it
	from the list, but do not invoke call_rcu().

o	Upon restarting the RCU read-side scan, use cmpxchg to
	change the mark value from 1 to 0.  If this fails due to
	the value being 2, invoke call_rcu() on the element and
	continue the scan.

Seem reasonable?

> >> +	}
> >> +
> >> +	if (list_empty(&group->items)) {
> >> +		/*
> >> +		 * We should unpublish our group device if we just removed
> >> +		 * the last of its contained items
> >> +		 */
> >> +		kvm_io_bus_unregister_dev(bus, &group->dev);
> >> +		_iosignalfd_group_destructor(group);
> >>     
> 
> I think I screwed this part up.  I should technically defer the
> destruction of the group object until after the next grace as well,
> right?  (We are using its groups->items list in the read-side CS). 
> Otherwise its a race, I think.

Ah, I missed that part, as I failed to trace out all the data strcutures.
Yes, everything that is accessed by an RCU reader without some other
protection must be defer-freed, e.g., by call_rcu().  The lock protects
some of the fields, but the lock itself is acquired under only RCU
protection, so the structure containing the lock must sit for a grace
period between the time it is made inaccessible to RCU readers and the
time that it is freed.

> >> +	}
> >> +
> >> +	fput(file);
> >> +
> >> +out:
> >> +	mutex_unlock(&kvm->lock);
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
> >> index 179c650..91d0fe2 100644
> >> --- a/virt/kvm/kvm_main.c
> >> +++ b/virt/kvm/kvm_main.c
> >> @@ -977,7 +977,7 @@ static struct kvm *kvm_create_vm(void)
> >>  	atomic_inc(&kvm->mm->mm_count);
> >>  	spin_lock_init(&kvm->mmu_lock);
> >>  	kvm_io_bus_init(&kvm->pio_bus);
> >> -	kvm_irqfd_init(kvm);
> >> +	kvm_eventfd_init(kvm);
> >>  	mutex_init(&kvm->lock);
> >>  	kvm_io_bus_init(&kvm->mmio_bus);
> >>  	init_rwsem(&kvm->slots_lock);
> >> @@ -2215,6 +2215,15 @@ static long kvm_vm_ioctl(struct file *filp,
> >>  		r = kvm_irqfd(kvm, data.fd, data.gsi, data.flags);
> >>  		break;
> >>  	}
> >> +	case KVM_IOSIGNALFD: {
> >> +		struct kvm_iosignalfd entry;
> >> +
> >> +		r = -EFAULT;
> >> +		if (copy_from_user(&entry, argp, sizeof entry))
> >> +			goto out;
> >> +		r = kvm_iosignalfd(kvm, &entry);
> >> +		break;
> >> +	}
> >>  	default:
> >>  		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
> >>  	}
> >>
> >>     
> 
> Thanks again, Paul!
> -Greg
> 



--u3/rZRmxL6MmkK24
Content-Type: image/png
Content-Description: RCUperftableCrop.png
Content-Disposition: attachment; filename="RCUperftableCrop.png"
Content-Transfer-Encoding: base64

iVBORw0KGgoAAAANSUhEUgAABg4AAAGYCAYAAACatRl4AAAABmJLR0QA/wD/AP+gvaeTAAAA
CW9GRnMAAAAgAAABXADKSsuXAAAACXBIWXMAAACHAAAAiQB0liFQAACAAElEQVR42uzdUWgb
V943/q9f9krdFGy37O7bP3aX8BIbGrbFDWR8sY7hSQjYz15kQnEhDcnLYk8KzUJbX2Scy1q5
kBPYBLaWediErsGixL4oIyhOQVIurIAt0iUPSKGYvhLN2y2VbGhXup3/hd8zHckzoxlppJGs
7wdMFGk0OnPmN+fMnDNzTp+u6zqIiIiIiIiIiIiIiIgA/I+gE0BERERERERERERERJ3jV0En
gOgo6+vrM173wsM9TtsrPuuFfCAiomDY1TWsg4iIqB3q1UNWnxEREXUqPnFARERERERERERE
REQGdhwQEQCgVCohlUoFnQwiIiIiIiIiIiIKGDsOiAgA8OOPP2JzczPoZBAREREREREREVHA
2HFARACAr7/+OugkEBERERERERERUQfg5MhEXco8wZZfFEUJerOIiIiIiIiIiIgoYHzigKhL
taKRf3l5OejNIiIiIiIiIiIiooCx44CoSw0MDGBtbQ26rtv+RaNRaJrmuEyxWEQkEkEymYSu
60FvFhEREREREREREQWMHQdEXezNN9+0/SyVSuG1117D1NSU4zoGBwfx8ccf4/nz58jlckFv
EhEREREREREREQWMHQdEXWpubg5DQ0O2n29vb9ftNDC7dOkSHj9+HPRmERERERERERERUcA4
OTJRl3LqNACA/f19T+sLhULI5/NBbxYREREREREREREFjE8cEB1Re3t7QSeBiIiIiIiIiIiI
uhA7DoiOqOPHj3uas6BUKrGzgYiIiIiIiIiIiNhxQHRUnTp1Cn/9619RKpXqLlupVHDz5k1M
T08HnWwiIiIiIiIiIiIKGDsOiI6oiYkJAMB//ud/IhaLWT59UCgUEI/H8R//8R/48ccfMTk5
GXSyiShAqVQKhUIh6GSgUCgglUoFnQwiIiIiIiKinsWOA6Ij7Pbt2/jDH/6Ad999F6Ojo+jr
66v6Gx4exvT0NP7n//yfuHPnDkKhUNBJJqKApFIpPH/+vO7E6+0wNDSE58+fs/OAiIiIiIiI
KCB9uq7rQSeC6Kjq6+szXgd1qFUqFSQSCdthiKLRKC5duuRLp4HT9orPWORQLXPc1CPLMs6d
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
IqKjhE0wRETULThUEdER9t5772FkZCToZBAREREREREREVEXYccB0RF18uRJhEKhoJNxCO+w
6V3iqRPGALnFmCGv7GKGsUQA44C8Y8yQV/XqISIiom7CoYqIWijIoYo6bXt54UWMAfKKMUNe
seOAnDAOyCvGDHnlpuOA8URERN2CkyMTEREREREREREREZGhZR0HfX19rv8uXryIlZUVpFKp
pn6zVCohHo9jYWEB4+PjxvoXFhYQj8dRqVSMZSuVCi5evGj8P5fL1U2nmGzW7Xbmcjlf88xp
ffF43PZ7RNQazZQ5XspIcznpVA64WU/t9+uVfV7LsV7DGCCvWn2uUvt37do1xGIxlEoly/R0
wvkPNY7xRIwB8qpSqVjGzLVr1xgzR0gmk8HKygquXbuGhYUF4y8Wi6FQKASdPOoQ8Xgc165d
O3S9YT5erY4/IuoheosVi0VdlmUdgA5ALxaLh5bJZrP62tqaDkCXZVnf2dnx9BvlclmPRqPG
9zVN0/P5fFUaNE2rWnckEtHtNj+bzRrplWVZL5fLdbdRrC8SiVT9diOSyaTx+5IkuV5fsVjU
FUXRAeiKojSdjmbSL0mSvra2FsjvdxKxH9twqLmWTCar4kTTtLZsb7vyQcRfK/lZ5tSWkVbl
Tblc1pPJpLFcNBp1LJdq15nNZutuUz6f97Ucs9LKGCiXy/ra2lrVdquqqieTyZb9HmOg9Vpd
biSTSV1VVeNPURQ9Go1anqs0q5XnKoqiWC4j1ilJkg6gbnkf9PmPH4Kug3T94FiSZdnVcdco
xlNjWA8xBrw6avWQ2H+SJDFmWqRePdTquiifz+uKoli2q5hjQFXVlsSZFbYPdJ5yuawriqIr
inLofGVnZ0dXFEVPJpO6pmkd1ZZBRO3XlhJAVVVXleTOzo6xnNuT7Hw+7/pERBSO4iTbKT3m
E343yuWybYNPI0TDrtd17uzsuDrJaiXzSVErL5q7QbtOEMVFh+hssrvgMMe++U9RFF9iJqiO
g2KxqO/s7Lgua5rRijLHbbrF+pwu0Lyus3b9fpZjtVq1b0QjXTKZNNJubgRXFMXXCyPGQPu0
KmbK5bKuqqquaVrVtpo7XPxs7Av6XMX8+/Uu2oM+/2lWUB0H5XJZz2azVfutVedAjKfGsR5i
DHh1lOohcf5Q7+YDxkxzguw4EDcg1ru2E/vDy02KfuQJ2wc6h+g0cBKJRIzjloh6V0d1HOh6
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
XOfncjk8fvwYT58+xcDAAPb29vDWW2/h/PnzVW0fCwsLxpMaduu2axDXdb3l7RFe6se+vj7L
dWSzWezu7lpug7lNzOr7uq5btreJ49SPfWVupwKAgYEB9Pf3Y3R0FJOTk3XLLDdlBRH5oBXj
HxWLRT2bzRrjJaqqqufzeX1tbU0vl8vG+1aT4pXLZV1VVV2SJH1nZ6fqs2w2a6xLLJvNZo0J
l2AxplptWtDEuGtiXWIsR1VV9Wg0amyXOZ2SJOmKohwaM9Yqb8T/df2XcUlrx6DM5/O6JEl6
NBqt+i0xcZ7dmJRevmeVV7p+MO5l7b4Qy2iaZuwzc76Wy2VjEi67fdJMPpo1u19bCS0cy9Ks
0bhq5/a2Ix86lR8xms1mGxqv2AtxzDYyxq2XfKD6GDPV+UD1+TG54VGOmXbFkp+TTDYzObL4
Xr0Jcs2/IdSeU4gxsyORSFU6as/18vm87fmmVTry+bwuy/KhyVrFb7Vif3VimeJnzDQzObJV
LNip/Y12xYyuH1yDWJ3Pimsevyf77vaYEWPXi3zZ2dnRI5GIrqqqriiKHo1GGz7X8DNmWnXd
Kb7fCTHTiutCMa58q+I0mUzqkiQdOh6LxaKuKIququqhORUaLQ+c8tJtjIp2odr0ivetzj3M
cWxV7og0RqNR27rY7/aIRupHEc921/zie5FI5NA+E8dVbR5YtbfZ8ZoHOzs7uiRJeiQSObSd
yWTSMrbMaYhEIo5lBRH5p+VnQeaGYXHgi4LHqpJ2qjxE4WJ1UeumoPKrQDefrNkVSmIZWZZt
Jygy503t9tcW2JIk2a5LdLRYVSyNfM+cV5qmWVaQYsI+SZL0tbU1y2XERFx2E2H5mY+93nFQ
+5tu4qrd29uJF17t4keMyrJ86OTIL6Ijz6rDthX5QPUxZqrzgerzo/HxKMdMN3YciE7/RiYU
babjoHY9tefxZuZzPavGCPP5Yi1VVetODO23TixT/IwZ881ZXidIbaYRuPazVsWM6BixIxqb
/NTtMWOeUDuZTB7aZ2J/eJ2AXdf9jZlWXXd2Usy04rrQHAt+x+nOzo5jPVIul3VZlh1vOPBS
HjjlpZvz4Xqdjk5tH6J9yiodiqLUvdnB7/aIRutHsR1Wx7P4nl1eJ5NJx5sM/ew4EHFrFzti
X9Zuh/gNu3LAqf4gosa1peNAluVDB302mz1UeYgCwq7AEr2gThVxuzsOnIj02m2PyBurXl2z
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
Xcf5EYCDONA0zbhu2tvbw/T09KE7k8Wy7YiZpaUlTE5O4vXXX8f6+roRM2JYpunpad+Hnun2
mDETZcGDBw+QTqchSRKuXLliXCvbaUXMtOu6U9O0jomZdl0XCqVSCU+ePMHW1hYSiYRRdoin
P86ePVs1PJHTeh49elQ1Vn1/f39D7R1uy4Paibe9XOeL9KZSKQwMDNjua6tjSqRPsEtn7XKN
pNOJX/XjwsKCbZuXaB9yKjOc9qVVHdPovnr27JnRTlcbW82WFVb7ioi8aUnHwVFX2+BNjemF
fGz3CWLQ2HFAThgD5BVjhrwKouOAugfjgLxizJBXndJxQERE5IeOmuOAiIiIiIiIiIiIiIiC
xY4DIiIiIiIiIiIiIiIysOOAiIiIiIiIiIiIiIgM7DhowO7urvG6UCgEnZyuxXwkIiIiIiIi
IiIi6jzsOPAgHo+jr6+vasb24eFh9PX1IZfLBZ28rsF8JCIiIiIiIiIiIupcfbqu60Enguio
6uvrM173wqHmtL3is17IB7LGGCCvGDPklV3MMJYIYByQd4wZ8qpePWT1GRERUafiEwdERERE
RERERERERGRgxwERERERERERERERERnYcUBERERERERERERERAZ2HBARERERERERERERkcGY
HNk8WQ8REREREREREREREfWO/9dVAIBPHBARERERERERERERkcmvxAtzbwIR+cP8JE8vHGNO
2ys+64V8IGuMAfKKMUNe2cUMY4kAxgF5x5ghr+rVQ1afERERdSo+cUBERERERERERERERAZ2
HBARERERERERERERkYEdB0REREREREREREREZPhV86sIRqFQQDQaNf4fDoc7aqzAVCqFzc3N
jk0fdS/z+Jj1yLKMc+fO4cSJE5iYmAg66URERERERNRipVIJT548wdbWFhKJBNLpNABAVVWM
j49jcnISoVAIAFCpVHD58mU8fPgw6GQTVen0dj+iXtC1Txy88soreO+993Dy5EmEw+Ggk3PI
G2+8gffeew/Dw8MdmT7qXrquQ9d1FItFyLJsvF8sFo3PxN8nn3yCl19+GWfOnMHFixeRyWSC
Tn7PqFQqiMViuHjxIvr6+tDX14eFhQWkUinH78XjcSwtLaFUKgWS5vHxcRQKhaCyracxZqgR
hUIBKysrGB8fR19fH8bHx7G0tIRcLmf7HcZM+zV6fAu5XA5LS0tYWFgw/lZWVhz3c7vSRq3R
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
LcfJ96vsKRQK+PLLL6vOLYaHh43z4IWFBezt7WFgYADAL+cdzV4rNKIbyhS/9os453vw4IGx
PlVV6573eTm+Gyk/zN9NJBJ48uQJTpw4YVw/Xbp0CaFQ6ND109zcHD7//HNMTk7i9ddfx/r6
uhEzYsim6elp34eeaWfMLCwsuJrXo15anK6T7dbh5vrC7rrTKWb8rq+6OWZacV3opFQq4cmT
J9ja2kIikTDKAUVRMDExgbNnzzrWH+b1PHr0qGqs+v7+fpw6dcqyLHHTBuMU67XlWi6Xg6Zp
xn4/efKkY3kj0ptKpYy2GeDwvraK+do2Irt0WrUleU2nE7/qx4WFBdsyX7R7ObUlOe1Lq/qn
0X317Nkz4zyhNrZa1e5HRO61rOOAiNp/ghg0dhyQE8YAecWYIa86reOAOgvjgLxizJBXndJx
QERE5IeWznFARERERERERERERETdhR0HRERERERERERERERkYMcBEREREREREREREREZ2HFA
REREREREREREREQGdhwQEREREREREREREZGBHQdERERERERERERERGRgxwERERERERERERER
ERnYcUBERERERERERERERAZ2HBARERERERERERERkYEdB0REREREREREREREZOjTdV0HgL6+
vqDTQkREREREREREREREAfh/XQUA+MQBERERERERERERERGZ/Eq8MPcmEJE/zE/y9MIx5rS9
4rNeyAeyxhggrxgz5JVdzDCWCPj/27uj0Dau/F/g31z65G4Ktv8hm83i7BIutqFht7iBjB/q
GDYmYP/3IVOKC9mSlGJrA21hGz94nMdaeZAbaAI3Vlg2pQ3IlMgP+Y8gOAVLfrACskmXPIxM
MReJ5t+WSjakV3qd++D/mY6kmdGMpJFk6fuBUFczGp2Z85uZM+ecOYdxQN4xZsiravchq2VE
RETtim8cEBERERERERERERGRgQ0HRERERERERERERERkYMMBEREREREREVGHKRaLuHfvHorF
YquTQkREh9Ar9W+CiJrJPD5mNbIsY2JiAoODgxgbG2t10omIiIiIiKhJUqkUZmdn+TxIVKNE
IoG1tTXj/4PBIOcpoa7ChgOiQ0bcpPL5PGZnZxGNRgEAuVwO/f39Jeum02l8++23OH/+PGRZ
xvz8PEZGRlq9C10tnU7j/fffx+bmpuN6+Xwe0WgUmUzG+Ky3txdnz55tSKE/m83i8ePHePbs
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
HggEdEmS9Hg8XrJM0zQ9HA7rhULB8rckSdJDoVDJ8kKhoIfDYX1ra0tXFEUHoIdCIV3TND2X
y9W9X5lMxtV3VFXVAejhcNj4LBQK1ZwGOhxEnPhxquVyOV2WZdfnWDweN9ZVVdX4PBwOuz4/
69lfv47DYSKuA9WuHZFIRJckSVdVteR6lslk9HA4rAcCAcvroK6X5oHdb4hYKL/G2n3eKIwB
7xgzjBmvzGUU87W+nN8xY2aO40bdb+wcpntQOBwuOZZO/6zKi36fu26uP9XWMcdj+W8B0GVZ
tizbx+NxXZZl2xisVTvGgRfmsly1f1Z5q2masVySJMvfKBQKeiAQqLgG2H1u5nfMKIqiS5Kk
K4pScU6IZ0in614tGDPVYyYcDuuhUEjf2tqy/W27a42be5abdcxxZY6NdooZv54LM5mMHgqF
dAB6IBBwVb9gzlene7PX/HFTHhR5VR4vjToW9dQJNWp/xfJwOFxxj3Oq77L7HTdlLfM12pyf
hULBOOZOvydiwnyNV1XV9jvxeFyXJEkPh8Mlx1D8nrney82+O9X1NSNtYptWeZ/L5fRQKFRy
TYtEInXVKRIdJkd03TQYboPEYjHbV9v/p7Gi6jYSiQRSqRR2d3fR19eHU6dO4eTJkxgfH7dt
kc1ms3j8+DHW1tYwODgIADh16hQuXryIgYEBLCwsYG9vD319fQCAiYkJT71lnPZLURQsLi5W
3ScxgUtfX5/n36fDxzxJZaNONfM27WiaZvnqbTqdxsbGRsk50sg4dNpfscyHS05bS6fTlj24
zKyOicirL774wuiVoyhK1fxKJBKYn5/HRx99hOnpadv1xPXy2bNn6Ovrw97eHk6fPo133nnH
tyErujUGvGLM/Iox4161e4PVfcHPmHFzr3JTdqr1OLT7PSibzeLUqVOu17dKt1/nrlN5V1VV
TE5OYmFhwXb+ATGGst11TGzj7bffxpdffolsNouNjQ1kMhljndHRUccyf63aLQ68Gh0ddT1h
uV1ZcGVlBbdv33Yc6x44iANVVY3npr29PUxNTVm+hdSsmFlaWsL4+Dj+8Ic/IBqNGjEjhtiZ
mppq+NAzjBl3MWN+xohGowAOhiaamJiwHKLIqawj7g1unr2rxZWqqm0TM818LrS7v1arpxFp
qzd/xDlrRbzF8vDhw4Ycg3K11AkdP368ofsr8kVc28z3uL29PYyNjeHChQuWPf8bUeeUSqWw
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
XE7XNM0YU1FRFD2TyeiRSEQvFArG51bjKBYKBV1RFF2SpIrJ4jRNM7Yl1tU0TY9EIsZYY+Xj
npWnBXWMjWa1X+L/df3XSejKJ680jy3faCItXtItJskLhUIlY94WCgVj/EOnYySOd/kEWuLz
8kmazZNjWU3sGQqFjMmaysdcFPFg9Xt27H6nFeDzWJZuxycWY4xanVfN2l8/j8NhkcvldEmS
dEmSahrXW5yftU6ELvKg2rlknkStkRgD3jFmGDO1qCffOzVmmh1LmqY5jiluLrs6EfnR6LmJ
nPK51nJjJpPRw+FwSVnOadLVTCajy7JcMX+D+C0/8qudrynVYkbXf803pzHvxVjQomxdKzHh
rjl9dsevWTGj6wfPPlblfPG80ehJ1xkz7tUTM2KdcDhc8awi1lFV1Xg2ND+rVnuGbZeY8fu5
0Cwej1fss/m+W+0eX2v+WG1H1JHYxVahUNBlWdYlSaqp7NGIOqFG7K9IR/lxDgQCJfc58z3O
7pjVUuckzo3y3xN5X+34eqkrE+eO3fXb7ne81PXVmjZd915fJcTjccv9EvtWHh9E3cL3iBcX
O/PJJ05Yq5u0001/a2tLlyTJsoDk5mJSb8OB3X6Vp738AuVnw4GoOK4l3VYTI4kKZrsbe7XC
vLgRlN+sRJ5bTVycy+Ucf9Oq4ONmH9tBqxsOxAOZOL61TK7YqP3t5ptsoVDQt7a29EAgoAcC
Ac8VwJqm6aFQqO6Gn3at0KNKjJnS3yd36sn3To+ZZseSLMuOx3Fra8vT5MiNSrvXfPZSbrTq
ACLKeFYNH4qi2MaJ+F6jtfM1pVrM6Pqv5Wk3E93WUx4WlTt223XiZ8yIydftxOPxrmo46KSY
EfcNq/KOOSYikYjlOnbPsO0UM81sOAiFQhWxIY6j1wYiL/ljRdzvnY5zJBKpucOCVVrrqROq
d3/N23DaZ7u6o/LtuK1zCgQCuizLtmUKkQ921wy3dWVi0m2737KrDzKn3Y+6vvL99FpfJa4h
TvVOfpVdidpdUxoOZFmuqDDWNM2yFc/pZHWqJG1Fw4EsyyUXJNHKXM7PhoNAIOC6sCPS4dTa
bF6nnPkmaXdDEhfc8vwWhTar7Zp7uVhtNxwOe6o0Ey3t7aCZDQeKopT8M/dSbETM17u/3XiT
FQ9RIj9kWfZUKA6Hw8b3nR6W3GrXCj36FWPG+vfJWT353i0x08xYEj3WqhG9Bu0e4s2NC/Wm
vZZ89lJudOrBJ5aX/161B3SrN5Pr1a7XFLcxY674syuLm3vd1lohWv6mgK67e57xO2bEdcOu
I0wul+uahoNOiRld//UYW3UwK1/H7pph9wzbTjHTrIYDUbFrRTwfVmu0tkq3m/yxuq+Yn/Xt
8qFRedDIhoNa99dtOsznh91xcVvnVK2nvyDe7LDKe7d1ZU5vmOj6r2WX8uPnd12frtdeXyXO
GTfnRbveE4j81JSGA7eV9eJkdXqAkiTJ8iLVioYDt9vys+HASwHPzc3JKa1Ob4oI4mJtVXFv
94Acj8eNZVZ567URwOtbGH5q9RsHuVzOVW+GZuwvb7K/FlRq6UGu63rJ2yNuC/tm7VqhR/YY
M4yZWtST750aM82MJVmWXb0pKR6u7Xp+hsPhkkqeRnKTz17LjXbbsSszm8t+dj3TG61drylu
Y0bX7Ydg0HW9ZEjYWiuBt7a2LLftpeHAr5gx3xPtnsEaHTeMmerqiRld//UYuxlGxa6ewO63
2ilmmtVw4PS2vpfhisrTXc8wNyLGrCrj7eKnFo1sOKhnf93WFYn7oF0jhdvtiHq0as8KTkMk
ufktcyOQ3W/Z1Qf5Xden67XXV7l5K6Y8LUTdpGkNB9W4KUS6+Z1mNxy40Y4NB7Ws47YCulrD
Q3lBJhQKGb9bfoPZ2tpybO23woaDUuYWdL8bD9hwUF35+L9eiQJmLQ927VqhR84YM4yZWtST
750YM82KJVFJ5fZ+a7e+GFdZ3Of96H1fLZ/rLTcK1SqBzRWWYriKWq51brTjNcVrzOj6QXyU
v1Eq3lgz9zD3OueXGCve6vg3Kh7qiRnzWPbivAiFQrZDijQCY8ZZvTGj6415jrf7rXaKmWY1
HIRCIdtK71qGK2pk/li9CdHI4XQb2XDg9zZ0/dcyvl1HSTfx4qWuyamC3E2azW9CuskHqzT6
Vden67XXV3mZU7Md7wlEfnsFbWJ3d9f422p2eL8sLCw4Lp+dna06K3y3WF5eBgDcv3+/ZJb5
coqioLe3t+Lz0dFRAMAXX3yBmZkZAAez1u/u7mJoaAiBQADLy8v49NNP0d/fDwDY3t7GxYsX
W73rh1pPTw8++ugjJJNJTE1NoVAoNPUco1JvvfUWACCZTOLBgwfGueDW1atXEY1GEQwGMTEx
gbGxMdffFeeYl/Wp9RgzVIt68p0xU7tUKgUAOH36tKv1x8bGkMlk8PjxY6NM2tvbi/HxcYyM
jGB1dRUAMDg42PC01pPPjTA2NoZ4PI75+Xkkk0kEg0FjmSRJuHPnDkZGRpqaplbwGjMAMDMz
g5GREaiqiq+++goAcOrUKczOzhplaAA4efKkp7Q8ePAAH3/8cduWE3t6evDZZ5+hr68PwWAQ
0WgU0WjUWB4KhXDt2rW2TX+jMGbc67aYKRaLmJubc7Xu3Nxc0/Z9aGgIsiwjGo0ikUgY95t8
Pg8AJTHYTcT5try8jLt379a0DXM9mlvBYBCLi4uev/fjjz8afzvVo5XXBzWrrq/W+ipz+YOI
KrVNw0GrVLtI/O1vf2t1EtvO1atXMTk56fl7AwMDRoFhe3sbIyMjSKVSmJ6eBgBMTU1heXkZ
T58+Nbb/7Nkzz5VkVOno0aPG39lsFkNDQ61OUtcyH/vZ2VlcvnzZUwHK/JC4srLiqaKnr6/P
U1q9rk/+YMxQLerJd8ZM7USFjZdzdGBgwLass7OzA+DXzheNVE8+N8rY2Bi++eYbaJqG7777
Ds+fP0cwGEQymcSbb74JTdM6vsxSS8wAwMjIiGXDSjabNf72UrGcTqfx2muvtf3x7unpweLi
ImZnZ/H8+XO8ePECa2triEajmJubw/7+fk0VYocJY8abboqZVCqFcDjs+Pwci8UwNTVlrN+s
a79orF5bWzN+8+nTpxgfH2/1YaMatPM5U2t9FRFZ+1+tToDwm9/8piW/qx8M12T7z++C0MrK
Sl3fl2W5aceqEb0C3377bQAHbxIAB4WVs2fPAgDOnTsHAFBV1Vin1oJMp/VgbKRaeiWQe4lE
AqOjo1hYWECxWKy6vvlhrVgsYmFhAaOjo0gkElW/66VXL/BrxZNTDwzzcj8qqqgSY4a8qiff
GTP+SafTxt+NeFu1WCwaPWPPnDnj+bt+5nMjiHT19PRgZGQE09PTWFxcRKFQQDgcBgCjZ3Sn
anTMAMDPP/8M4OCtDS/PMbu7u3j33Xdx5MgRy3/Dw8PGuubPm8kcywMDA5icnMTMzAwePnwI
TdMgSRKCwWDJce00jBlvui1mUqlU1Te1xDO3WL9ZRANBMBg03jTY3NzsijfL7Lx48QLAQQ/4
Wv32t7/1/B0vdSXm+qpafgvwr66vvC6t1jog1h0ROWubhoPXX3/d+LvajdtNxcph8fz587q+
Pzg42LRXq0QlfrXKAKC0YsvMPFyRyEfRW6a/vx+hUAjLy8vI5/PY3t6uqUIhGAx2XA/GRhIF
FPKHeciF9fX1qusfO3bM+Ht9fd3oaTk/P1/1u14bDkXF097enuN6YrnXiiqqDWOGvKon3xkz
/ml0w7ymaQAO8sBrBaHf+dwI58+ft/y8p6cHMzMzUBSl44cP8KMzh+icU2041nKTk5OOnalE
PAKlHa+aaW1tzfY5cWhoCP/6178AdHYnGcaMN90UM8ViEaurq1Ur4sUzN3Dw9kqz6lZ6enqM
RuEnT57U/KzfSdbW1gDU14nC3EBnVwcjiHPSS+dMc32V+beq1dmZ0+JXXV95XVqt9VVevkfU
jdqm4aC/v9+4kWxsbDiu++DBg4qLoiRJjt8RBaJW8HMct1OnTjVtPy5cuGD0yqh2Qb9586bl
5wMDAwgEAkgmk1hcXDTeNhDE/z99+hSZTKbmnjTNPC6HgbmV/9mzZxXLY7FYq5PYMX73u98Z
f1v1yjBfu2RZLhnT05xPf/rTnyy3b36wmZiYsFwnnU5bnqNiuLDl5WXbc7hYLGJ5ebmmiiqq
DWOGvKon3xkz/vHaMB+LxTA6OmpbRhWff/rpp7bbsMuHRuWz35zK56Ojo1XL94ed15gRFW12
5bZisYgvvvgCkiTZDv9RLBYPde/qb7/91nZZuw+Z0wiMGe+6JWZSqRSuXLnial3zM3gz3zoQ
83bdvn0b6+vrJW8/NEI71wmVS6fTiEajjueeG+YGmWqdUsW8SRcuXKhY5uZ+a/4tp/MKKK0P
8ruuT6i1vkocj/X1dcfviTdliLpN2zQcAMDly5chyzJmZ2dtW0vz+TxevnxZ8aB56dIlAECh
ULD83vr6esteQRoYGDAuduaLTTabrbunnZhQpxmFuf7+fuMC++DBA9v1YrEYPvjgA9vlYkzF
YDBo23AwNTVVU8u7OA5eJ/bqdOZW/vLKnHw+z7cQGujq1asIBAKIx+OWPX7MBbryXqBnz56F
JEmIRCK2FUWiJ4QkSZY9RJeWljA8PIz33nvPsuAjtmvXs1187qaHKjUGY4a8qiffGTP+yWQy
ntafmppCMpk0HuTN0uk0ZmdnEYlEbCu2nPKhEfncDFb7Lrx48cJ1Jdhh5TVmVldXkUwmjbJ0
uQcPHiCZTGJlZcWy41KxWMR7772H4eFhLC0ttXr3a3L79m3byhvxeaMrI9sJY8a7bomZtbU1
18/ArWo4EJMkJ5NJAI2fFLnd6oTEEMzlisUiPv/8cwAHFdj1djS9fPkyAoEAFhcXbSu+Y7EY
kskk4vG45XEXx+6nn35y9VtO51UsFjPmsTR/r966vmppq7W+qr+/H6qqIplM4tGjR7bfu3//
vtesIeoMuo8ymYwOQAega5rm6ju5XE4PBAK6JEl6PB4vWaZpmh4Oh/VCoWD5W5Ik6aFQqGR5
oVDQw+GwvrW1pSuKogPQQ6GQrmmansvl6t6vTCbj6juqquoA9HA4bHwWCoVqTkN5WlRVdZ0G
p3Sb17FLWzwe1yVJ0sPhcMk6hUJBV1W1ZB+t5HI5Ix+shEIhx993s49u88Vv4lj6carlcjld
lmXX51g8HjfWNcdLOBx2fX7Ws79+HYd2FA6H9VAopG9tbZV8bs6D8uubkMlkdFmWdVVVS+JY
XMsA6JIk2ca4OQ/s1hHpKE+D3eeN0k0x4BVjxhpjxl49+d6NMdOMWBLlTLe/oyiKLklSyXkv
ylKSJOmRSMTVvtrlQ7357LXcaJcGu2sYAF2WZcuyfTwe12VZtizz16PdrileY0Yc7/JyfyaT
0UOhkC5JkmOZTtM04/ckSfKU1kbEg5t1nGJGnDOKolQ8J4hnSDfPRF4wZvyNGXN+2+Wdm3Xs
nmHbKWb8ei4UeQlADwQCrp6hzfnq9BzpNX/c3NtFXpWXeRt1LOqpE2rU/orl4XC44h7nVN9l
9ztu6jYKhYIeCAT0QCBQkp+iXFEtf0RMBAIBI72qqlp+R+yDLMsVseNUH1RrXZ+XtOl67fVV
dtfLXC6nh0KhkueySCRSV50i0WFyRNcbP9BgLBaz7dXwP40VVbeRSCSQSqWwu7uLvr4+nDp1
CidPnsT4+Lhti2w2m8Xjx4+xtraGwcFBAAdD1ly8eBEDAwNYWFjA3t6eMf79xMSEp/HdnPZL
UZSqM8snEgljApe+vj7Pv2/n7bffxrlz53D9+nXP6VZVFZOTk1hYWLAdR1bTtIrebvl8Hk+e
PEEikUBfXx96e3sBHPSec/PK58LCgu3+JxIJrK2tVT2eVpaWlvD06VM8fPiw7uPaCOYJwBp1
qrmZVMwqz4CDHowbGxsl50ij4rDa/oplPlxy2pL5WIvJLWVZxsTERMVwM+WKxSLW19exublZ
cl4qioLR0VHH62AikcD8/Dw++uijip4eZuJ6+ezZM/T19WFvbw+nT5/GO++849vQId0WA14x
ZioxZpzVk+/dFjPNiKXt7W28+eabiEQijsdFEHmgqqoxObEkSbhy5YpRdnXiJh9qyedGlBuB
0rGQrbbx9ttv48svv0Q2m8XGxkZJT+pqMVirdrumeI0Z4NdystfzVlhZWcHt27dx8+bNquW/
dDptm4+CrutNi5mlpSWMj4/jD3/4A6LRqBEzXp9DvGDM+BMzTuuJ52o3z97V4kpV1baJmWY+
F9rVTVSrpxFpqzd/xDlrRbzF4tfzei11QsePH2/o/op8Edc28z1ub28PY2NjuHDhgmXZvhF1
TqlUCvv7+8ZnZ86csf09s3Q6DVVV8fTpUwwODuLMmTOO1xlxbQEOzqnXXnsNIyMjVefZqKWu
z2vaaq2vyufziEajRtlV7JeInyNHjpRMZt3IuhSiduVLwwE1lyjMcTKXgwfNahUZzeRHAbGd
seGAnDAGyCvGDHnVyoYDan+MA/KKMUNeNbPh4DDa3t7Gjz/+aNuw0AnMDQedNI8GEXWntprj
gGpz4cIFJJPJtprspxW2t7eRTCYtJ/shIiIiIiIiotZZXV3tiDkliIi6BRsOOoCYpd5pgrlu
sLq6inA43PBJloiIiIiIiIjInUQigaWlpZLJevP5PHp7e/m8TkR0iLzS6gRQY8iyjP/8z/9E
Op3uytfh0uk01tfX8V//9V+tTgoRERERERFR1zp//jyAg7lLxLBE9+/frzrHAhERtRe+cdAh
+vv7sbCwgBs3brQ6KS1x48YNLCwssPcCERERERERUQspigJZlnHmzBkAB28g/P73v+/4To7Z
bNb4e3d3t9XJISKqGydH7jD37t0DAMzMzLQ6KU2zsrKCly9ftuU+d9skWJwcmZwwBsgrxgx5
xcmRyQnjgLxizJBXnBz5QDabxddff439/X309vaWvHnQidLpNIaHhy2XKYqCxcXFVieRiKgm
bDjoQPfu3cPg4CDGxsZanRTfJRIJ7OzstGWjAdB9BUQ2HJATxgB5xZghr9hwQE4YB+QVY4a8
YsMBERF1Eg5V1IFmZmbwww8/tDoZTfHDDz+0baMBERERERERERER0WHENw6IfNRtPUv4xgE5
YQyQV4wZ8opvHJATxgF5xZghr/jGARERdRK+cUBERERERERERERERAY2HBARERERERERERER
kcEYqsj86hwREREREREREREREXUP85B6fOOAiIiIiIiIiIiIiIgMr4g/OEEPUeN12yRYnByZ
nDAGyCvGDHnFyZHJCeOAvGLMkFecHJmIiDoJ3zggIiIiIiIiIiIiIiJDVzYcrKystDoJXYPH
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
AAAASUVORK5CYII=

--u3/rZRmxL6MmkK24--
