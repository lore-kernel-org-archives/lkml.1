Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbZEGOAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbZEGOAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761737AbZEGNzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:55:37 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:11170
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760658AbZEGNzf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:55:35 -0400
X-BigFish: VPS-26(zz1432R98dR1805M936fJzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KJA1C7-01-R67-01
Date: Thu, 7 May 2009 15:55:22 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Mark Langsdorf <mark.langsdorf@amd.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][KVM] Add support for Pause Filtering to AMD SVM
Message-ID: <20090507135522.GJ4059@amd.com>
References: <200905050909.58583.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <200905050909.58583.mark.langsdorf@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 07 May 2009 13:55:23.0214 (UTC) FILETIME=[77773EE0:01C9CF1B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Beside the small style problem the patch looks good. Please remove this
empty line from the patch and resubmit. Please also add avi@redhat.com
and kvm@vger.kernel.org to the CC list.

Joerg

On Tue, May 05, 2009 at 09:09:58AM -0500, Mark Langsdorf wrote:
> commit 6f15c833f56267baf5abdd0fbc90a81489573053
> Author: Mark Langsdorf <mlangsdo@wshpnow.amd.com>
> Date:   Mon May 4 15:02:38 2009 -0500
> 
>     New AMD processors will support the Pause Filter Feature.
>     This feature creates a new field in the VMCB called Pause
>     Filter Count.  If Pause Filter Count is greater than 0 and
>     ntercepting PAUSEs is enabled, the processor will increment
>     an internal counter when a PAUSE instruction occurs instead
>     of intercepting.  When the internal counter reaches the
>     Pause Filter Count value, a PAUSE intercept will occur.
>     
>     This feature can be used to detect contended spinlocks,
>     especially when the lock holding VCPU is not scheduled.
>     Rescheduling another VCPU prevents the VCPU seeking the
>     lock from wasting its quantum by spinning idly.
>     
>     Experimental results show that most spinlocks are held
>     for less than 1000 PAUSE cycles or more than a few
>     thousand.  Default the Pause Filter Counter to 3000 to
>     detect the contended spinlocks.
>     
>     Processor support for this feature is indicated by a CPUID
>     bit.
>     
>     On a 24 core system running 4 guests each with 16 VCPUs,
>     this patch improved overall performance of each guest's
>     32 job kernbench by approximately 1%.  Further performance
>     improvement may be possible with a more sophisticated
>     yield algorithm.
>     
>     -Mark Langsdorf
>     Operating System Research Center
>     AMD
>     
>     Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 85574b7..1fecb7e 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -57,7 +57,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  	u16 intercept_dr_write;
>  	u32 intercept_exceptions;
>  	u64 intercept;
> -	u8 reserved_1[44];
> +	u8 reserved_1[42];
> +	u16 pause_filter_count;
>  	u64 iopm_base_pa;
>  	u64 msrpm_base_pa;
>  	u64 tsc_offset;
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index ef43a18..14dab13 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -45,6 +45,7 @@ MODULE_LICENSE("GPL");
>  #define SVM_FEATURE_NPT  (1 << 0)
>  #define SVM_FEATURE_LBRV (1 << 1)
>  #define SVM_FEATURE_SVML (1 << 2)
> +#define SVM_FEATURE_PAUSE_FILTER (1 << 10)
>  
>  #define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
>  
> @@ -575,6 +576,12 @@ static void init_vmcb(struct vcpu_svm *svm)
>  
>  	svm->nested_vmcb = 0;
>  	svm->vcpu.arch.hflags = HF_GIF_MASK;
> +
> +	if (svm_has(SVM_FEATURE_PAUSE_FILTER)) {
> +		control->pause_filter_count = 5000;
> +		control->intercept |= (1ULL << INTERCEPT_PAUSE);
> +	}
> +
>  }
>  
>  static int svm_vcpu_reset(struct kvm_vcpu *vcpu)
> @@ -2087,6 +2094,15 @@ static int interrupt_window_interception(struct vcpu_svm *svm,
>  	return 1;
>  }
>  
> +static int pause_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
> +{
> +	/* Simple yield */
> +	vcpu_put(&svm->vcpu);
> +	schedule();
> +	vcpu_load(&svm->vcpu);
> +	return 1;
> +}
> +
>  static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
>  				      struct kvm_run *kvm_run) = {
>  	[SVM_EXIT_READ_CR0]           		= emulate_on_interception,
> @@ -2123,6 +2139,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
>  	[SVM_EXIT_CPUID]			= cpuid_interception,
>  	[SVM_EXIT_IRET]                         = iret_interception,
>  	[SVM_EXIT_INVD]                         = emulate_on_interception,
> +	[SVM_EXIT_PAUSE]			= pause_interception,
>  	[SVM_EXIT_HLT]				= halt_interception,
>  	[SVM_EXIT_INVLPG]			= invlpg_interception,
>  	[SVM_EXIT_INVLPGA]			= invalid_op_interception,
> @@ -2227,6 +2244,7 @@ static void pre_svm_run(struct vcpu_svm *svm)
>  	if (svm->vcpu.cpu != cpu ||
>  	    svm->asid_generation != svm_data->asid_generation)
>  		new_asid(svm, svm_data);
> +
>  }

Minor style nit, please move this empty line from the patch.

>  
>  static void svm_drop_interrupt_shadow(struct kvm_vcpu *vcpu)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2b73e19..e2b730d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -710,6 +710,7 @@ void vcpu_load(struct kvm_vcpu *vcpu)
>  	kvm_arch_vcpu_load(vcpu, cpu);
>  	put_cpu();
>  }
> +EXPORT_SYMBOL_GPL(vcpu_load);
>  
>  void vcpu_put(struct kvm_vcpu *vcpu)
>  {
> @@ -719,6 +720,7 @@ void vcpu_put(struct kvm_vcpu *vcpu)
>  	preempt_enable();
>  	mutex_unlock(&vcpu->mutex);
>  }
> +EXPORT_SYMBOL_GPL(vcpu_put);
>  
>  static void ack_flush(void *_completed)
>  {

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

