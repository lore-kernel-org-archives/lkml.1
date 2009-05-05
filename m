Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbZEEQFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbZEEQFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 12:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZEEQFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 12:05:46 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:49797 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbZEEQFp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 12:05:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UownwQecIfJxC1yyg+T6B17GlVOi91JnLr2iXKjHkQDUbWHTFAETgSKFdSbPcmhZ+9
         fnLQE/AXqTxmc13t2wTRFbWNpn4HyVZ4JPX9+RdG+JpOmRe+G9vzdlRaSvP3xjEj0qI2
         JUlnAfuNJrEW5RTZpbSV9eUvK4AxEAe69WVMo=
MIME-Version: 1.0
In-Reply-To: <200905050909.58583.mark.langsdorf@amd.com>
References: <200905050909.58583.mark.langsdorf@amd.com>
Date: Tue, 5 May 2009 18:05:44 +0200
Message-ID: <36ca99e90905050905g1934f44ev3a12329259ff3bf5@mail.gmail.com>
Subject: Re: [PATCH][KVM] Add support for Pause Filtering to AMD SVM
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 5, 2009 at 16:09, Mark Langsdorf <mark.langsdorf@amd.com> wrote:
> commit 6f15c833f56267baf5abdd0fbc90a81489573053
> Author: Mark Langsdorf <mlangsdo@wshpnow.amd.com>
> Date:   Mon May 4 15:02:38 2009 -0500
>
>    New AMD processors will support the Pause Filter Feature.
>    This feature creates a new field in the VMCB called Pause
>    Filter Count.  If Pause Filter Count is greater than 0 and
>    ntercepting PAUSEs is enabled, the processor will increment
>    an internal counter when a PAUSE instruction occurs instead
>    of intercepting.  When the internal counter reaches the
>    Pause Filter Count value, a PAUSE intercept will occur.
>
>    This feature can be used to detect contended spinlocks,
>    especially when the lock holding VCPU is not scheduled.
>    Rescheduling another VCPU prevents the VCPU seeking the
>    lock from wasting its quantum by spinning idly.
>
>    Experimental results show that most spinlocks are held
>    for less than 1000 PAUSE cycles or more than a few
>    thousand.  Default the Pause Filter Counter to 3000 to
>    detect the contended spinlocks.
>
>    Processor support for this feature is indicated by a CPUID
>    bit.
>
>    On a 24 core system running 4 guests each with 16 VCPUs,
>    this patch improved overall performance of each guest's
>    32 job kernbench by approximately 1%.  Further performance
>    improvement may be possible with a more sophisticated
>    yield algorithm.
>
>    -Mark Langsdorf
>    Operating System Research Center
>    AMD
>
>    Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index ef43a18..14dab13 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -575,6 +576,12 @@ static void init_vmcb(struct vcpu_svm *svm)
>
>        svm->nested_vmcb = 0;
>        svm->vcpu.arch.hflags = HF_GIF_MASK;
> +
> +       if (svm_has(SVM_FEATURE_PAUSE_FILTER)) {
> +               control->pause_filter_count = 5000;
The commit message says something about 3000.

> +               control->intercept |= (1ULL << INTERCEPT_PAUSE);
> +       }
> +
>  }
>
>  static int svm_vcpu_reset(struct kvm_vcpu *vcpu)
