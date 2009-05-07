Return-Path: <linux-kernel-owner+w=401wt.eu-S1760968AbZEGPb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760968AbZEGPb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 11:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbZEGPbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 11:31:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40252 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565AbZEGPbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 11:31:44 -0400
Message-ID: <4A02FECC.6060609@redhat.com>
Date: Thu, 07 May 2009 18:31:24 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mark Langsdorf <mark.langsdorf@amd.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][KVM][retry 1] Add support for Pause Filtering to AMD
 SVM
References: <200905050909.58583.mark.langsdorf@amd.com> <20090507135522.GJ4059@amd.com> <200905071000.14038.mark.langsdorf@amd.com>
In-Reply-To: <200905071000.14038.mark.langsdorf@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(copying Ingo)

Mark Langsdorf wrote:
> commit 01813db8627e74018c8cec90df7e345839351f23
> Author: root <root@xendinar01.amd.com>
> Date:   Thu May 7 09:44:10 2009 -0500
>
>     New AMD processors will support the Pause Filter Feature.
>     This feature creates a new field in the VMCB called Pause
>     Filter Count.  If Pause Filter Count is greater than 0 and
>     intercepting PAUSEs is enabled, the processor will increment
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

(please use git format-patch rather than git show, and set up user.name 
and user.email properly)

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

3000 or 5000?

>  
> +static int pause_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
> +{
> +	/* Simple yield */
> +	vcpu_put(&svm->vcpu);
> +	schedule();
> +	vcpu_load(&svm->vcpu);
> +	return 1;
> +

Ingo, will this do anything under CFS, or will CFS note that nothing has 
changed in the accounting and reschedule us immediately?



-- 
error compiling committee.c: too many arguments to function

