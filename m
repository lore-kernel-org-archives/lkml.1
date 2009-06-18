Return-Path: <linux-kernel-owner+w=401wt.eu-S1762133AbZFRLp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762133AbZFRLp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 07:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbZFRLpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 07:45:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40603 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbZFRLpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 07:45:12 -0400
Message-ID: <4A3A28DF.5090803@redhat.com>
Date: Thu, 18 Jun 2009 14:45:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v7 2/2] KVM: add iosignalfd support
References: <20090616133751.14362.12674.stgit@dev.haskins.net> <20090616134235.14362.64014.stgit@dev.haskins.net>
In-Reply-To: <20090616134235.14362.64014.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2009 04:42 PM, Gregory Haskins wrote:
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
> io region and through the doorbell ioctl().  The other is direct via
> iosignalfd.
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
>
> +config KVM_MAX_IOSIGNALFD_ITEMS
> +	int "Maximum IOSIGNALFD items per address"
> +	depends on KVM
> +	default "32"
> +	---help---
> +	  This option influences the maximum number of fd's per PIO/MMIO
> +	  address that are allowed to register
> +
>    

Is there a per-vm limit on iosignalfds?  if not, userspace can exhaust 
kernel memory in that way.

We could limit the just total number of iosignafds, it's somewhat more 
natural.
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index daece36..a4b427f 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -12,3 +12,5 @@ config HAVE_KVM_EVENTFD
>
>   config KVM_APIC_ARCHITECTURE
>          bool
> +
> +
>    

Spurious, please drop.
> +/*
> + * Design note: We create one PIO/MMIO device (iosignalfd_group) which
> + * aggregates  one or more iosignalfd_items.  Each item points to exactly one
> + * eventfd, and can be registered to trigger on any write to the group
> + * (wildcard), or to a write of a specific value.  If more than one item is to
> + * be supported, the addr/len ranges must all be identical in the group.  If a
> + * trigger value is to be supported on a particular item, the group range must
> + * be exactly the width of the trigger.
> + */
> +
> +struct _iosignalfd_item {
> +	struct list_head     list;
> +	struct file         *file;
> +	unsigned char       *match;
> +	struct rcu_head      rcu;
> +};
>    

Why not u64 match?

> +static int
> +iosignalfd_is_match(struct _iosignalfd_group *group,
> +		    struct _iosignalfd_item *item,
> +		    const void *val,
> +		    int len)
> +{
> +	if (!item->match)
> +		/* wildcard is a hit */
> +		return true;
> +
> +	if (len != group->length)
> +		/* mis-matched length is a miss */
> +		return false;
>    

Should check length before match (i.e. require correctly sized access).

-- 
error compiling committee.c: too many arguments to function

