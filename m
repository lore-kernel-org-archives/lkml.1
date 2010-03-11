Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab0CKUzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 15:55:55 -0500
Received: from claw.goop.org ([74.207.240.146]:46897 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874Ab0CKUzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 15:55:54 -0500
Message-ID: <4B9958D6.1000103@goop.org>
Date: Thu, 11 Mar 2010 12:55:50 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 4 of 5] evtchn delivery on HVM
References: <alpine.DEB.2.00.1003101506570.28412@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1003101506570.28412@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2010 07:47 AM, Stefano Stabellini wrote:
> Hi all,
> this patch sets the callback to receive evtchns from Xen, using the
> callback vector delivery mechanism.
>    

Please see my comments on Sheng's version of this patch and his updates, 
specifically regarding the xen_hvm_domain() tests in xen_evtchn_do_upcall().

Thanks,
     J

> Signed-off-by: Stefano Stabellini<stefano.stabellini@eu.citrix.com>
> Signed-off-by: Sheng Yang<sheng@linux.intel.com>
>
> ---
>
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 6292cc6..72e8546 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -34,8 +34,11 @@
>   #include<xen/interface/vcpu.h>
>   #include<xen/interface/memory.h>
>   #include<xen/interface/hvm/hvm_op.h>
> +#include<xen/interface/hvm/params.h>
>   #include<xen/features.h>
>   #include<xen/page.h>
> +#include<xen/hvm.h>
> +#include<xen/events.h>
>   #include<xen/hvc-console.h>
>
>   #include<asm/paravirt.h>
> @@ -1267,9 +1270,25 @@ static void __init init_pv_clocksource(void)
>   	xen_register_clocksource();
>   }
>
> +static int set_callback_via(uint64_t via)
> +{
> +	struct xen_hvm_param a;
> +
> +	a.domid = DOMID_SELF;
> +	a.index = HVM_PARAM_CALLBACK_IRQ;
> +	a.value = via;
> +	return HYPERVISOR_hvm_op(HVMOP_set_param,&a);
> +}
> +
> +void do_hvm_pv_evtchn_intr(void)
> +{
> +	xen_evtchn_do_upcall(get_irq_regs());
> +}
> +
>   void __init xen_guest_init(void)
>   {
>   	int r;
> +	uint64_t callback_via;
>
>   	r = init_hvm_pv_info();
>   	if (r<  0)
> @@ -1277,5 +1296,14 @@ void __init xen_guest_init(void)
>
>   	init_shared_info();
>   	init_pv_clocksource();
> +
> +	callback_via = HVM_CALLBACK_VECTOR(GENERIC_INTERRUPT_VECTOR);
> +	set_callback_via(callback_via);
> +	generic_interrupt_extension = do_hvm_pv_evtchn_intr;
> +
> +	have_vcpu_info_placement = 0;
> +	x86_init.irqs.intr_init = xen_init_IRQ;
> +	pv_time_ops = xen_time_ops;
> +	machine_ops = xen_machine_ops;
>   }
>
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 2f57276..ef25a53 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -621,9 +621,10 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
>   	struct vcpu_info *vcpu_info = __get_cpu_var(xen_vcpu);
>    	unsigned count;
>
> -	exit_idle();
> -	irq_enter();
> -
> +	if (!xen_hvm_domain()) {
> +		exit_idle();
> +		irq_enter();
> +	}
>   	do {
>   		unsigned long pending_words;
>
> @@ -659,8 +660,10 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
>   	} while(count != 1);
>
>   out:
> -	irq_exit();
> -	set_irq_regs(old_regs);
> +	if (!xen_hvm_domain()) {
> +		irq_exit();
> +		set_irq_regs(old_regs);
> +	}
>
>   	put_cpu();
>   }
> @@ -939,5 +942,8 @@ void __init xen_init_IRQ(void)
>   	for (i = 0; i<  NR_EVENT_CHANNELS; i++)
>   		mask_evtchn(i);
>
> -	irq_ctx_init(smp_processor_id());
> +	if (xen_hvm_domain())
> +		native_init_IRQ();
> +	else
> +		irq_ctx_init(smp_processor_id());
>   }
> diff --git a/include/xen/events.h b/include/xen/events.h
> index e68d59a..b0d3b3c 100644
> --- a/include/xen/events.h
> +++ b/include/xen/events.h
> @@ -56,4 +56,6 @@ void xen_poll_irq(int irq);
>   /* Determine the IRQ which is bound to an event channel */
>   unsigned irq_from_evtchn(unsigned int evtchn);
>
> +void xen_evtchn_do_upcall(struct pt_regs *regs);
> +
>   #endif	/* _XEN_EVENTS_H */
> diff --git a/include/xen/hvm.h b/include/xen/hvm.h
> index c2a55f6..35c9c11 100644
> --- a/include/xen/hvm.h
> +++ b/include/xen/hvm.h
> @@ -3,6 +3,7 @@
>   #define XEN_HVM_H__
>
>   #include<xen/interface/hvm/params.h>
> +#include<asm/xen/hypercall.h>
>
>   static inline unsigned long hvm_get_parameter(int idx)
>   {
> @@ -20,4 +21,9 @@ static inline unsigned long hvm_get_parameter(int idx)
>          return xhv.value;
>   }
>
> +#define HVM_CALLBACK_VIA_TYPE_VECTOR 0x2
> +#define HVM_CALLBACK_VIA_TYPE_SHIFT 56
> +#define HVM_CALLBACK_VECTOR(x) (((uint64_t)HVM_CALLBACK_VIA_TYPE_VECTOR)<<\
> +                               HVM_CALLBACK_VIA_TYPE_SHIFT | (x))
> +
>   #endif /* XEN_HVM_H__ */
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
>
>    

