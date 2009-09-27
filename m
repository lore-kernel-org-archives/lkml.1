Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbZI0Iw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbZI0Iw1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 04:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZI0Iw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 04:52:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbZI0IwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 04:52:25 -0400
Message-ID: <4ABF27C8.2000406@redhat.com>
Date: Sun, 27 Sep 2009 10:52:24 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH: kvm 3/5] Fix hotadd of CPUs for KVM.
References: <20090924151049.GB14102@amt.cnet> <1253839640-12695-1-git-send-email-zamsden@redhat.com> <1253839640-12695-2-git-send-email-zamsden@redhat.com> <1253839640-12695-3-git-send-email-zamsden@redhat.com> <1253839640-12695-4-git-send-email-zamsden@redhat.com>
In-Reply-To: <1253839640-12695-4-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2009 03:47 AM, Zachary Amsden wrote:
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
> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
> ---
>   arch/x86/include/asm/kvm_host.h |    2 ++
>   arch/x86/kvm/svm.c              |   15 +++++++++++++--
>   arch/x86/kvm/vmx.c              |   17 +++++++++++++++++
>   arch/x86/kvm/x86.c              |   13 +++++++++----
>   include/linux/kvm_host.h        |    6 ++++++
>   virt/kvm/kvm_main.c             |    6 ++----
>   6 files changed, 49 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 299cc1b..b7dd14b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -459,6 +459,7 @@ struct descriptor_table {
>   struct kvm_x86_ops {
>   	int (*cpu_has_kvm_support)(void);          /* __init */
>   	int (*disabled_by_bios)(void);             /* __init */
> +	int (*cpu_hotadd)(int cpu);
>   	int (*hardware_enable)(void *dummy);
>   	void (*hardware_disable)(void *dummy);
>   	void (*check_processor_compatibility)(void *rtn);
> @@ -791,6 +792,7 @@ asmlinkage void kvm_handle_fault_on_reboot(void);
>   	_ASM_PTR " 666b, 667b \n\t" \
>   	".popsection"
>
> +#define KVM_ARCH_WANT_HOTPLUG_NOTIFIER
>   #define KVM_ARCH_WANT_MMU_NOTIFIER
>   int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
>   int kvm_age_hva(struct kvm *kvm, unsigned long hva);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 9a4daca..8f99d0c 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -330,13 +330,13 @@ static int svm_hardware_enable(void *garbage)
>   		return -EBUSY;
>
>   	if (!has_svm()) {
> -		printk(KERN_ERR "svm_cpu_init: err EOPNOTSUPP on %d\n", me);
> +		printk(KERN_ERR "svm_hardware_enable: err EOPNOTSUPP on %d\n", me);
>   		return -EINVAL;
>   	}
>   	svm_data = per_cpu(svm_data, me);
>
>   	if (!svm_data) {
> -		printk(KERN_ERR "svm_cpu_init: svm_data is NULL on %d\n",
> +		printk(KERN_ERR "svm_hardware_enable: svm_data is NULL on %d\n",
>   		       me);
>   		return -EINVAL;
>   	}
> @@ -394,6 +394,16 @@ err_1:
>
>   }
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
>   static void set_msr_interception(u32 *msrpm, unsigned msr,
>   				 int read, int write)
>   {
> @@ -2858,6 +2868,7 @@ static struct kvm_x86_ops svm_x86_ops = {
>   	.hardware_setup = svm_hardware_setup,
>   	.hardware_unsetup = svm_hardware_unsetup,
>   	.check_processor_compatibility = svm_check_processor_compat,
> +	.cpu_hotadd = svm_cpu_hotadd,
>   	.hardware_enable = svm_hardware_enable,
>   	.hardware_disable = svm_hardware_disable,
>   	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 3fe0d42..b8a8428 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -1408,6 +1408,22 @@ static __exit void hardware_unsetup(void)
>   	free_kvm_area();
>   }
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
> +
>   static void fix_pmode_dataseg(int seg, struct kvm_save_segment *save)
>   {
>   	struct kvm_vmx_segment_field *sf =&kvm_vmx_segment_fields[seg];
> @@ -3925,6 +3941,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
>   	.hardware_setup = hardware_setup,
>   	.hardware_unsetup = hardware_unsetup,
>   	.check_processor_compatibility = vmx_check_processor_compat,
> +	.cpu_hotadd = vmx_cpu_hotadd,
>   	.hardware_enable = hardware_enable,
>   	.hardware_disable = hardware_disable,
>   	.cpu_has_accelerated_tpr = report_flexpriority,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c18e2fc..66c6bb9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1326,6 +1326,8 @@ out:
>   void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   {
>   	kvm_x86_ops->vcpu_load(vcpu, cpu);
> +	if (unlikely(per_cpu(cpu_tsc_khz, cpu) == 0))
> +		per_cpu(cpu_tsc_khz, cpu) = cpufreq_quick_get(cpu);
>   	kvm_request_guest_time_update(vcpu);
>   }
>
> @@ -4699,12 +4701,15 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
>   	return kvm_x86_ops->vcpu_reset(vcpu);
>   }
>
> +int kvm_arch_cpu_hotadd(int cpu)
> +{
> +	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
> +		per_cpu(cpu_tsc_khz, cpu) = 0;
> +	return kvm_x86_ops->cpu_hotadd(cpu);
> +}
> +
>   int kvm_arch_hardware_enable(void *garbage)
>   {
> -	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
> -		int cpu = raw_smp_processor_id();
> -		per_cpu(cpu_tsc_khz, cpu) = cpufreq_quick_get(cpu);
> -	}
>   	return kvm_x86_ops->hardware_enable(garbage);
>   }
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 0bf9ee9..2f075c4 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -345,6 +345,12 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id);
>   int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu);
>   void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu);
>
> +#ifdef KVM_ARCH_WANT_HOTPLUG_NOTIFIER
> +int kvm_arch_cpu_hotadd(int cpu);
> +#else
> +#define kvm_arch_cpu_hotadd(x) (0)
> +#endif
> +
>   int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu);
>   int kvm_arch_hardware_enable(void *garbage);
>   void kvm_arch_hardware_disable(void *garbage);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e27b7a9..7818b51 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1716,9 +1716,6 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
>   {
>   	int cpu = (long)v;
>
> -	if (!kvm_usage_count)
> -		return NOTIFY_OK;
> -
>    

Why?  You'll now do hardware_enable() even if kvm is not in use.

>   	val&= ~CPU_TASKS_FROZEN;
>   	switch (val) {
>   	case CPU_DYING:
> @@ -1734,7 +1731,8 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
>   	case CPU_ONLINE:
>   		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
>   		       cpu);
> -		smp_call_function_single(cpu, hardware_enable, NULL, 1);
> +		if (!kvm_arch_cpu_hotadd(cpu))
> +			smp_call_function_single(cpu, hardware_enable, NULL, 1);
>   		break;
>   	}
>    

if (!blah) when blah is not a boolean or a pointer is confusing.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

