Return-Path: <linux-kernel-owner+w=401wt.eu-S1757638AbYC1Uac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbYC1Uac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbYC1UaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:30:23 -0400
Received: from gw.goop.org ([64.81.55.164]:49451 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268AbYC1UaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:30:22 -0400
Message-ID: <47ED5542.2060503@goop.org>
Date: Fri, 28 Mar 2008 13:29:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Isaku Yamahata <yamahata@valinux.co.jp>
CC: chrisw@sous-sol.org, sct@redhat.com,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       xen-ia64-devel@lists.xensource.com, eddie.dong@intel.com
Subject: Re: [PATCH 08/12] xen: add resend_irq_on_evtchn() definition into
 events.c.
References: <12067044183207-git-send-email-yamahata@valinux.co.jp> <1206704418876-git-send-email-yamahata@valinux.co.jp>
In-Reply-To: <1206704418876-git-send-email-yamahata@valinux.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isaku Yamahata wrote:
> Define resend_irq_on_evtchn() which ia64/xen uses.
> Although it isn't used by current x86/xen code, it's arch generic
> so that put it into common code.
> make ipi_to_irq[] visible removing static because
> ia64/xen needs to access the variable from ia64 specific code
>   

What kind of access?  Would it be better to add some accessor functions?

If nothing else, it needs to be prefixed with xen_ if it goes non-static.

(As should resend_irq_on_evtchn(), but I'm less concerned about a name 
collision.)

    J

> Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
> ---
>  drivers/xen/events.c |   18 +++++++++++++++++-
>  include/xen/events.h |    1 +
>  2 files changed, 18 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 2396b44..1c2c193 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -48,7 +48,7 @@ static DEFINE_SPINLOCK(irq_mapping_update_lock);
>  static DEFINE_PER_CPU(int, virq_to_irq[NR_VIRQS]) = {[0 ... NR_VIRQS-1] = -1};
>  
>  /* IRQ <-> IPI mapping */
> -static DEFINE_PER_CPU(int, ipi_to_irq[XEN_NR_IPIS]) = {[0 ... XEN_NR_IPIS-1] = -1};
> +DEFINE_PER_CPU(int, ipi_to_irq[XEN_NR_IPIS]) = {[0 ... XEN_NR_IPIS-1] = -1};
>  
>  /* Packed IRQ information: binding type, sub-type index, and event channel. */
>  struct packed_irq
> @@ -586,6 +586,22 @@ static void set_affinity_irq(unsigned irq, cpumask_t dest)
>  	rebind_irq_to_cpu(irq, tcpu);
>  }
>  
> +int resend_irq_on_evtchn(unsigned int irq)
> +{
> +	int masked, evtchn = evtchn_from_irq(irq);
> +	struct shared_info *s = HYPERVISOR_shared_info;
> +
> +	if (!VALID_EVTCHN(evtchn))
> +		return 1;
> +
> +	masked = sync_test_and_set_bit(evtchn, s->evtchn_mask);
> +	sync_set_bit(evtchn, s->evtchn_pending);
> +	if (!masked)
> +		unmask_evtchn(evtchn);
> +
> +	return 1;
> +}
> +
>  static void enable_dynirq(unsigned int irq)
>  {
>  	int evtchn = evtchn_from_irq(irq);
> diff --git a/include/xen/events.h b/include/xen/events.h
> index 2bde54d..574cfa4 100644
> --- a/include/xen/events.h
> +++ b/include/xen/events.h
> @@ -37,6 +37,7 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
>  void unbind_from_irqhandler(unsigned int irq, void *dev_id);
>  
>  void xen_send_IPI_one(unsigned int cpu, enum ipi_vector vector);
> +int resend_irq_on_evtchn(unsigned int irq);
>  
>  static inline void notify_remote_via_evtchn(int port)
>  {
>   

