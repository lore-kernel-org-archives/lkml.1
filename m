Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbZEVWGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbZEVWGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 18:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757476AbZEVWGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 18:06:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45912 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757400AbZEVWGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 18:06:32 -0400
Date: Fri, 22 May 2009 19:05:54 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [KVM PATCH v3 4/4] kvm: add iosignalfd support
Message-ID: <20090522220554.GA3852@amt.cnet>
References: <20090521165059.14851.83681.stgit@dev.haskins.net> <20090521165129.14851.3249.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090521165129.14851.3249.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 12:51:29PM -0400, Gregory Haskins wrote:
> iosignalfd is a mechanism to register PIO/MMIO regions to trigger an eventfd
> signal when written to by a guest.  Host userspace can register any arbitrary
> IO address with a corresponding eventfd and then pass the eventfd to a
> specific end-point of interest for handling.
> 
> Normal IO requires a blocking round-trip since the operation may cause
> side-effects in the emulated model or may return data to the caller.
> Therefore, an IO in KVM traps from the guest to the host, causes a VMX/SVM
> "heavy-weight" exit back to userspace, and is ultimately serviced by qemu's
> device model synchronously before returning control back to the vcpu.
> 
> However, there is a subclass of IO which acts purely as a trigger for
> other IO (such as to kick off an out-of-band DMA request, etc).  For these
> patterns, the synchronous call is particularly expensive since we really
> only want to simply get our notification transmitted asychronously and
> return as quickly as possible.  All the sychronous infrastructure to ensure
> proper data-dependencies are met in the normal IO case are just unecessary
> overhead for signalling.  This adds additional computational load on the
> system, as well as latency to the signalling path.
> 
> Therefore, we provide a mechanism for registration of an in-kernel trigger
> point that allows the VCPU to only require a very brief, lightweight
> exit just long enough to signal an eventfd.  This also means that any
> clients compatible with the eventfd interface (which includes userspace
> and kernelspace equally well) can now register to be notified. The end
> result should be a more flexible and higher performance notification API
> for the backend KVM hypervisor and perhipheral components.
> 
> To test this theory, we built a test-harness called "doorbell".  This
> module has a function called "doorbell_ring()" which simply increments a
> counter for each time the doorbell is signaled.  It supports signalling
> from either an eventfd, or an ioctl().
> 
> We then wired up two paths to the doorbell: One via QEMU via a registered
> io region and through the doorbell ioctl().  The other is direct via iosignalfd.
> 
> You can download this test harness here:
> 
> ftp://ftp.novell.com/dev/ghaskins/doorbell.tar.bz2
> 
> The measured results are as follows:
> 
> qemu-mmio:       110000 iops, 9.09us rtt
> iosignalfd-mmio: 200100 iops, 5.00us rtt
> iosignalfd-pio:  367300 iops, 2.72us rtt
> 
> I didn't measure qemu-pio, because I have to figure out how to register a
> PIO region with qemu's device model, and I got lazy.  However, for now we
> can extrapolate based on the data from the NULLIO runs of +2.56us for MMIO,
> and -350ns for HC, we get:
> 
> qemu-pio:      153139 iops, 6.53us rtt
> iosignalfd-hc: 412585 iops, 2.37us rtt
> 
> these are just for fun, for now, until I can gather more data.
> 
> Here is a graph for your convenience:
> 
> http://developer.novell.com/wiki/images/7/76/Iofd-chart.png
> 
> The conclusion to draw is that we save about 4us by skipping the userspace
> hop.
> 
> --------------------
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
> 
>  arch/x86/kvm/x86.c       |    1 
>  include/linux/kvm.h      |   15 ++++
>  include/linux/kvm_host.h |   10 ++-
>  virt/kvm/eventfd.c       |  165 ++++++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c      |   11 +++
>  5 files changed, 198 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 98c2434..cee63ff 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1085,6 +1085,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_IRQ_INJECT_STATUS:
>  	case KVM_CAP_ASSIGN_DEV_IRQ:
>  	case KVM_CAP_IRQFD:
> +	case KVM_CAP_IOSIGNALFD:
>  		r = 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index 8f53f24..8162466 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -292,6 +292,19 @@ struct kvm_guest_debug {
>  	struct kvm_guest_debug_arch arch;
>  };
>  
> +#define KVM_IOSIGNALFD_FLAG_DEASSIGN  (1 << 0)
> +#define KVM_IOSIGNALFD_FLAG_PIO       (1 << 1)
> +#define KVM_IOSIGNALFD_FLAG_COOKIE    (1 << 2)
> +
> +struct kvm_iosignalfd {
> +	__u64 cookie;
> +	__u64 addr;
> +	__u32 len;
> +	__u32 fd;
> +	__u32 flags;
> +	__u8  pad[12];
> +};
> +
>  #define KVM_TRC_SHIFT           16
>  /*
>   * kvm trace categories
> @@ -419,6 +432,7 @@ struct kvm_trace_rec {
>  #define KVM_CAP_MCE 31
>  #endif
>  #define KVM_CAP_IRQFD 32
> +#define KVM_CAP_IOSIGNALFD 33
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -525,6 +539,7 @@ struct kvm_irqfd {
>  			_IOW(KVMIO, 0x74, struct kvm_assigned_msix_entry)
>  #define KVM_DEASSIGN_DEV_IRQ       _IOW(KVMIO, 0x75, struct kvm_assigned_irq)
>  #define KVM_IRQFD                  _IOW(KVMIO, 0x76, struct kvm_irqfd)
> +#define KVM_IOSIGNALFD             _IOW(KVMIO, 0x77, struct kvm_iosignalfd)
>  
>  /*
>   * ioctls for vcpu fds
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7dcae4b..5b2be86 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -138,6 +138,7 @@ struct kvm {
>  	struct kvm_io_bus pio_bus;
>  #ifdef CONFIG_HAVE_KVM_EVENTFD
>  	struct list_head irqfds;
> +	struct list_head iosignalfds;
>  #endif
>  	struct kvm_vm_stat stat;
>  	struct kvm_arch arch;
> @@ -535,19 +536,24 @@ static inline void kvm_free_irq_routing(struct kvm *kvm) {}
>  
>  #ifdef CONFIG_HAVE_KVM_EVENTFD
>  
> -void kvm_irqfd_init(struct kvm *kvm);
> +void kvm_eventfd_init(struct kvm *kvm);
>  int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags);
>  void kvm_irqfd_release(struct kvm *kvm);
> +int kvm_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args);
>  
>  #else
>  
> -static inline void kvm_irqfd_init(struct kvm *kvm) {}
> +static inline void kvm_eventfd_init(struct kvm *kvm) {}
>  static inline int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
>  {
>  	return -EINVAL;
>  }
>  
>  static inline void kvm_irqfd_release(struct kvm *kvm) {}
> +static inline int kvm_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
> +{
> +	return -EINVAL;
> +}
>  
>  #endif /* CONFIG_HAVE_KVM_EVENTFD */
>  
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index c63ff6a..7700e39 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -21,12 +21,16 @@
>   */
>  
>  #include <linux/kvm_host.h>
> +#include <linux/kvm.h>
>  #include <linux/workqueue.h>
>  #include <linux/syscalls.h>
>  #include <linux/wait.h>
>  #include <linux/poll.h>
>  #include <linux/file.h>
>  #include <linux/list.h>
> +#include <linux/eventfd.h>
> +
> +#include "iodev.h"
>  
>  /*
>   * --------------------------------------------------------------------
> @@ -207,9 +211,10 @@ kvm_deassign_irqfd(struct kvm *kvm, int fd, int gsi)
>  }
>  
>  void
> -kvm_irqfd_init(struct kvm *kvm)
> +kvm_eventfd_init(struct kvm *kvm)
>  {
>  	INIT_LIST_HEAD(&kvm->irqfds);
> +	INIT_LIST_HEAD(&kvm->iosignalfds);
>  }
>  
>  int
> @@ -232,3 +237,161 @@ kvm_irqfd_release(struct kvm *kvm)
>  		irqfd_release(irqfd);
>  	}
>  }
> +
> +/*
> + * --------------------------------------------------------------------
> + * iosignalfd: translate a PIO/MMIO memory write to an eventfd signal.
> + *
> + * userspace can register a PIO/MMIO address with an eventfd for recieving
> + * notification when the memory has been touched.
> + * --------------------------------------------------------------------
> + */
> +
> +struct _iosignalfd {
> +	u64                  cookie;
> +	u64                  addr;
> +	size_t               length;
> +	struct file         *file;
> +	struct list_head     list;
> +	struct kvm_io_device dev;
> +};
> +
> +static int
> +iosignalfd_in_range(struct kvm_io_device *this, gpa_t addr, int len,
> +		    int is_write)
> +{
> +	struct _iosignalfd *p = (struct _iosignalfd *)this->private;
> +
> +	return ((addr >= p->addr && (addr < p->addr + p->length)));
> +}
> +
> +/* writes trigger an event */
> +static void
> +iosignalfd_write(struct kvm_io_device *this, gpa_t addr, int len,
> +		 const void *val)
> +{
> +	struct _iosignalfd *iosignalfd = (struct _iosignalfd *)this->private;
> +
> +	eventfd_signal(iosignalfd->file, 1);
> +}
> +
> +/* reads return all zeros */
> +static void
> +iosignalfd_read(struct kvm_io_device *this, gpa_t addr, int len, void *val)
> +{
> +	memset(val, 0, len);
> +}

Gregory,

Can you explain the reasoning behind limiting the interface to 
write-only ranges, with reads returning zero.

Is that because it fits the use cases in mind for iosignalfd?

Not that I have a better suggestion at the moment, just trying
to understand.

Also, the heavy-weight exit avoidance assumes that the action signalled
will be serviced by the qemu device model in a separate CPU, otherwise
there is no gain, is that correct?

