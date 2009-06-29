Return-Path: <linux-kernel-owner+w=401wt.eu-S1760495AbZF2PwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760495AbZF2PwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759774AbZF2Pvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:51:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42576 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759980AbZF2Pvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:51:40 -0400
Date: Mon, 29 Jun 2009 12:50:31 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       markmc@redhat.com
Subject: Re: [PATCHv3 3/4] kvm: convert bus to slots_lock
Message-ID: <20090629155031.GA16444@amt.cnet>
References: <cover.1246276816.git.mst@redhat.com> <20090629120911.GD21273@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629120911.GD21273@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 03:09:11PM +0300, Michael S. Tsirkin wrote:
> Use slots_lock to protect device list on the bus.  slots_lock is already
> taken for read everywhere, so we only need to take it for write when
> registering devices.  This is in preparation to removing in_range and
> kvm->lock around it.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/x86/kvm/i8254.c     |    4 ++--
>  arch/x86/kvm/i8259.c     |    2 +-
>  include/linux/kvm_host.h |    3 ++-
>  virt/kvm/ioapic.c        |    2 +-
>  virt/kvm/kvm_main.c      |    5 ++++-
>  5 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
> index 331705f..c2387ec 100644
> --- a/arch/x86/kvm/i8254.c
> +++ b/arch/x86/kvm/i8254.c
> @@ -620,11 +620,11 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
>  	kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
>  
>  	kvm_iodevice_init(&pit->dev, &pit_dev_ops);
> -	kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
> +	kvm_io_bus_register_dev(kvm, &kvm->pio_bus, &pit->dev);
>  
>  	if (flags & KVM_PIT_SPEAKER_DUMMY) {
>  		kvm_iodevice_init(&pit->speaker_dev, &speaker_dev_ops);
> -		kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
> +		kvm_io_bus_register_dev(kvm, &kvm->pio_bus, &pit->speaker_dev);
>  	}
>  
>  	return pit;
> diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
> index 148c52a..1851aec 100644
> --- a/arch/x86/kvm/i8259.c
> +++ b/arch/x86/kvm/i8259.c
> @@ -548,6 +548,6 @@ struct kvm_pic *kvm_create_pic(struct kvm *kvm)
>  	 * Initialize PIO device
>  	 */
>  	kvm_iodevice_init(&s->dev, &picdev_ops);
> -	kvm_io_bus_register_dev(&kvm->pio_bus, &s->dev);
> +	kvm_io_bus_register_dev(kvm, &kvm->pio_bus, &s->dev);
>  	return s;

case KVM_CREATE_PIT2:
create_pit:
mutex_lock(&kvm->lock);
kvm_io_bus_register_dev
down_write(slots_lock);

But the order is slots_lock -> kvm->lock.

(you might want to update the comment on top of kvm_main.c to 
reflect that).

