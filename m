Return-Path: <linux-kernel-owner+w=401wt.eu-S1763954AbZEHSof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763954AbZEHSof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757648AbZEHSoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:44:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55950 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281AbZEHSoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:44:23 -0400
Message-ID: <4A047D86.1070407@redhat.com>
Date: Fri, 08 May 2009 21:44:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mark Langsdorf <mark.langsdorf@amd.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][KVM][retry 2] Add support for Pause Filtering to AMD
 SVM
References: <200905050909.58583.mark.langsdorf@amd.com> <20090507135522.GJ4059@amd.com> <200905071000.14038.mark.langsdorf@amd.com> <200905081203.55484.mark.langsdorf@amd.com>
In-Reply-To: <200905081203.55484.mark.langsdorf@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Langsdorf wrote:
> From 01813db8627e74018c8cec90df7e345839351f23 Mon Sep 17 00:00:00 2001
> From: Mark Langsdorf <mark.langsdorf@amd.com>
> Date: Thu, 7 May 2009 09:44:10 -0500
> Subject: [PATCH] Add support for Pause Filtering to AMD SVM
>   

What's the differences wrt retry 1?

> This feature creates a new field in the VMCB called Pause
> Filter Count.  If Pause Filter Count is greater than 0 and
> intercepting PAUSEs is enabled, the processor will increment
> an internal counter when a PAUSE instruction occurs instead
> of intercepting.  When the internal counter reaches the
> Pause Filter Count value, a PAUSE intercept will occur.
>
> This feature can be used to detect contended spinlocks,
> especially when the lock holding VCPU is not scheduled.
> Rescheduling another VCPU prevents the VCPU seeking the
> lock from wasting its quantum by spinning idly.
>
> Experimental results show that most spinlocks are held
> for less than 1000 PAUSE cycles or more than a few
> thousand.  Default the Pause Filter Counter to 3000 to
> detect the contended spinlocks.
>   

3000.

> Processor support for this feature is indicated by a CPUID
> bit.
>
> On a 24 core system running 4 guests each with 16 VCPUs,
> this patch improved overall performance of each guest's
> 32 job kernbench by approximately 1%.  Further performance
> improvement may be possible with a more sophisticated
> yield algorithm.
>   

Like I mentioned earlier, I don't think schedule() does anything on CFS.

Try sched_yield(), but set /proc/sys/kernel/sched_compat_yield.

> +
> +	if (svm_has(SVM_FEATURE_PAUSE_FILTER)) {
> +		control->pause_filter_count = 5000;
> +		control->intercept |= (1ULL << INTERCEPT_PAUSE);
> +	}
> +
>   

Here, 5000?

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
>   

You don't need to vcpu_put() and vcpu_load().  The scheduler will call 
them for you if/when it switches tasks.



-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

