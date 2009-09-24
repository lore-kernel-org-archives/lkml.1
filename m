Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbZIXPwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbZIXPwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbZIXPwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:52:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839AbZIXPwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:52:41 -0400
Date: Thu, 24 Sep 2009 12:52:24 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH: kvm 3/6] Fix hotadd of CPUs for KVM.
Message-ID: <20090924155224.GC14102@amt.cnet>
References: <1253762945-5750-1-git-send-email-zamsden@redhat.com> <1253762945-5750-2-git-send-email-zamsden@redhat.com> <1253762945-5750-3-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253762945-5750-3-git-send-email-zamsden@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 05:29:02PM -1000, Zachary Amsden wrote:
> Both VMX and SVM require per-cpu memory allocation, which is done at module
> init time, for only online cpus.  When bringing a new CPU online, we must
> also allocate this structure.  The method chosen to implement this is to
> make the CPU online notifier available via a call to the arch code.  This
> allows memory allocation to be done smoothly, without any need to allocate
> extra structures.
> 
> Note: CPU up notifiers may call KVM callback before calling cpufreq callbacks.
> This would causes the CPU frequency not to be detected (and it is not always
> clear on non-constant TSC platforms what the bringup TSC rate will be, so the
> guess of using tsc_khz could be wrong).  So, we clear the rate to zero in such
> a case and add logic to query it upon entry.
> 
> Signed-off-by: Zachary Amsden <zamsden@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    2 ++
>  arch/x86/kvm/svm.c              |   15 +++++++++++++--
>  arch/x86/kvm/vmx.c              |   17 +++++++++++++++++
>  arch/x86/kvm/x86.c              |   14 +++++++++++++-
>  include/linux/kvm_host.h        |    6 ++++++
>  virt/kvm/kvm_main.c             |    3 ++-
>  6 files changed, 53 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 299cc1b..b7dd14b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -459,6 +459,7 @@ struct descriptor_table {
>  struct kvm_x86_ops {
>  	int (*cpu_has_kvm_support)(void);          /* __init */
>  	int (*disabled_by_bios)(void);             /* __init */
> +	int (*cpu_hotadd)(int cpu);
>  	int (*hardware_enable)(void *dummy);
>  	void (*hardware_disable)(void *dummy);
>  	void (*check_processor_compatibility)(void *rtn);
> @@ -791,6 +792,7 @@ asmlinkage void kvm_handle_fault_on_reboot(void);
>  	_ASM_PTR " 666b, 667b \n\t" \
>  	".popsection"
>  
> +#define KVM_ARCH_WANT_HOTPLUG_NOTIFIER
>  #define KVM_ARCH_WANT_MMU_NOTIFIER
>  int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
>  int kvm_age_hva(struct kvm *kvm, unsigned long hva);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 9a4daca..8f99d0c 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -330,13 +330,13 @@ static int svm_hardware_enable(void *garbage)
>  		return -EBUSY;
>  
>  	if (!has_svm()) {
> -		printk(KERN_ERR "svm_cpu_init: err EOPNOTSUPP on %d\n", me);
> +		printk(KERN_ERR "svm_hardware_enable: err EOPNOTSUPP on %d\n", me);
>  		return -EINVAL;
>  	}
>  	svm_data = per_cpu(svm_data, me);
>  
>  	if (!svm_data) {
> -		printk(KERN_ERR "svm_cpu_init: svm_data is NULL on %d\n",
> +		printk(KERN_ERR "svm_hardware_enable: svm_data is NULL on %d\n",
>  		       me);
>  		return -EINVAL;
>  	}
> @@ -394,6 +394,16 @@ err_1:
>  
>  }
>  
> +static __cpuinit int svm_cpu_hotadd(int cpu)
> +{
> +	struct svm_cpu_data *svm_data = per_cpu(svm_data, cpu);
> +
> +	if (svm_data)
> +		return 0;
> +
> +	return svm_cpu_init(cpu);
> +}
> +
>  static void set_msr_interception(u32 *msrpm, unsigned msr,
>  				 int read, int write)
>  {
> @@ -2858,6 +2868,7 @@ static struct kvm_x86_ops svm_x86_ops = {
>  	.hardware_setup = svm_hardware_setup,
>  	.hardware_unsetup = svm_hardware_unsetup,
>  	.check_processor_compatibility = svm_check_processor_compat,
> +	.cpu_hotadd = svm_cpu_hotadd,
>  	.hardware_enable = svm_hardware_enable,
>  	.hardware_disable = svm_hardware_disable,
>  	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 3fe0d42..b8a8428 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -1408,6 +1408,22 @@ static __exit void hardware_unsetup(void)
>  	free_kvm_area();
>  }
>  
> +static __cpuinit int vmx_cpu_hotadd(int cpu)
> +{
> +	struct vmcs *vmcs;
> +
> +	if (per_cpu(vmxarea, cpu))
> +		return 0;
> +
> +	vmcs = alloc_vmcs_cpu(cpu);
> +	if (!vmcs) 
> +		return -ENOMEM;
> +
> +	per_cpu(vmxarea, cpu) = vmcs;
> +
> +	return 0;
> +}

Have to free in __cpuexit?

Is it too wasteful to allocate statically with DEFINE_PER_CPU_PAGE_ALIGNED?
