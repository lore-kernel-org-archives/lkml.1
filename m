Return-Path: <linux-kernel-owner+w=401wt.eu-S1760118AbZIPVVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118AbZIPVVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 17:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755754AbZIPVVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 17:21:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836AbZIPVVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 17:21:37 -0400
Date: Wed, 16 Sep 2009 18:21:12 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: x86 shared msr infrastructure
Message-ID: <20090916212112.GA15550@amt.cnet>
References: <1253105134-8862-1-git-send-email-avi@redhat.com> <1253105134-8862-4-git-send-email-avi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253105134-8862-4-git-send-email-avi@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 03:45:33PM +0300, Avi Kivity wrote:
> The various syscall-related MSRs are fairly expensive to switch.  Currently
> we switch them on every vcpu preemption, which is far too often:
> 
> - if we're switching to a kernel thread (idle task, threaded interrupt,
>   kernel-mode virtio server (vhost-net), for example) and back, then
>   there's no need to switch those MSRs since kernel threasd won't
>   be exiting to userspace.
> 
> - if we're switching to another guest running an identical OS, most likely
>   those MSRs will have the same value, so there's little point in reloading
>   them.
> 
> - if we're running the same OS on the guest and host, the MSRs will have
>   identical values and reloading is unnecessary.
> 
> This patch uses the new user return notifiers to implement last-minute
> switching, and checks the msr values to avoid unnecessary reloading.
> 
> Signed-off-by: Avi Kivity <avi@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    3 +
>  arch/x86/kvm/Kconfig            |    1 +
>  arch/x86/kvm/x86.c              |   79 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 83 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 45226f0..863bde8 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -799,4 +799,7 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
>  int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu);
>  int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
>  
> +void kvm_define_shared_msr(unsigned index, u32 msr);
> +void kvm_set_shared_msr(unsigned index, u64 val);
> +
>  #endif /* _ASM_X86_KVM_HOST_H */
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index b84e571..4cd4983 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -28,6 +28,7 @@ config KVM
>  	select HAVE_KVM_IRQCHIP
>  	select HAVE_KVM_EVENTFD
>  	select KVM_APIC_ARCHITECTURE
> +	select USER_RETURN_NOTIFIER
>  	---help---
>  	  Support hosting fully virtualized guest machines using hardware
>  	  virtualization extensions.  You will need a fairly recent
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1d454d9..0e7c40c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -37,6 +37,7 @@
>  #include <linux/iommu.h>
>  #include <linux/intel-iommu.h>
>  #include <linux/cpufreq.h>
> +#include <linux/user-return-notifier.h>
>  #include <trace/events/kvm.h>
>  #undef TRACE_INCLUDE_FILE
>  #define CREATE_TRACE_POINTS
> @@ -87,6 +88,25 @@ EXPORT_SYMBOL_GPL(kvm_x86_ops);
>  int ignore_msrs = 0;
>  module_param_named(ignore_msrs, ignore_msrs, bool, S_IRUGO | S_IWUSR);
>  
> +#define KVM_NR_SHARED_MSRS 16
> +
> +struct kvm_shared_msrs_global {
> +	int nr;
> +	struct kvm_shared_msr {
> +		u32 msr;
> +		u64 value;
> +	} msrs[KVM_NR_SHARED_MSRS];
> +};
> +
> +struct kvm_shared_msrs {
> +	struct user_return_notifier urn;
> +	bool registered;
> +	u64 current_value[KVM_NR_SHARED_MSRS];
> +};
> +
> +static struct kvm_shared_msrs_global __read_mostly shared_msrs_global;

Does this assume the MSRs in question are consistent across CPUs?

I guess that is not true with arch_prctl(ARCH_SET_GS/ARCH_GET_GS) ?

