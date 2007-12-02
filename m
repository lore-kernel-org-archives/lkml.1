Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbXLBNrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbXLBNrl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 08:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbXLBNrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 08:47:33 -0500
Received: from mis011-2.exch011.intermedia.net ([64.78.21.129]:50671 "EHLO
	mis011-2.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822AbXLBNrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 08:47:32 -0500
From: Amit Shah <amit.shah@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure (v2)
Date: Sun, 2 Dec 2007 19:17:28 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Anthony Liguori <aliguori@us.ibm.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>
References: <11898788932902-git-send-email-aliguori@us.ibm.com>
In-Reply-To: <11898788932902-git-send-email-aliguori@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712021917.28706.amit.shah@qumranet.com>
X-OriginalArrivalTime: 02 Dec 2007 13:47:31.0486 (UTC) FILETIME=[E2A9C3E0:01C834E9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anthony Liguori wrote:
> This patch refactors the current hypercall infrastructure to better support
> live migration and SMP.  It eliminates the hypercall page by trapping the
> UD exception that would occur if you used the wrong hypercall instruction
> for the underlying architecture and replacing it with the right one lazily.

This doesn't work right for SVM. It keeps looping indefinitely; on a kvm_stat 
run, I get about 230,000 light vm exits per second, with the hypercall never 
returning to the guest.

...

> diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
> index 729f1cd..d09a9f5 100644
> --- a/drivers/kvm/svm.c
> +++ b/drivers/kvm/svm.c
> @@ -476,7 +476,8 @@ static void init_vmcb(struct vmcb *vmcb)
>  					INTERCEPT_DR5_MASK |
>  					INTERCEPT_DR7_MASK;
>
> -	control->intercept_exceptions = 1 << PF_VECTOR;
> +	control->intercept_exceptions = (1 << PF_VECTOR) |
> +					(1 << UD_VECTOR);
>
>
>  	control->intercept = 	(1ULL << INTERCEPT_INTR) |
> @@ -970,6 +971,17 @@ static int pf_interception(struct vcpu_svm *svm,
> struct kvm_run *kvm_run) return 0;
>  }
>
> +static int ud_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
> +{
> +	int er;
> +
> +	er = emulate_instruction(&svm->vcpu, kvm_run, 0, 0);
> +	if (er != EMULATE_DONE)
> +		inject_ud(&svm->vcpu);
> +
> +	return 1;
> +}
> +
>  static int nm_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
>  {
>  	svm->vmcb->control.intercept_exceptions &= ~(1 << NM_VECTOR);
> @@ -1036,7 +1048,8 @@ static int vmmcall_interception(struct vcpu_svm *svm,
> struct kvm_run *kvm_run) {
>  	svm->next_rip = svm->vmcb->save.rip + 3;
>  	skip_emulated_instruction(&svm->vcpu);
> -	return kvm_hypercall(&svm->vcpu, kvm_run);
> +	kvm_emulate_hypercall(&svm->vcpu);
> +	return 1;
>  }
>
>  static int invalid_op_interception(struct vcpu_svm *svm,
> @@ -1232,6 +1245,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm
> *svm, [SVM_EXIT_WRITE_DR3]			= emulate_on_interception,
>  	[SVM_EXIT_WRITE_DR5]			= emulate_on_interception,
>  	[SVM_EXIT_WRITE_DR7]			= emulate_on_interception,
> +	[SVM_EXIT_EXCP_BASE + UD_VECTOR]	= ud_interception,
>  	[SVM_EXIT_EXCP_BASE + PF_VECTOR] 	= pf_interception,
>  	[SVM_EXIT_EXCP_BASE + NM_VECTOR] 	= nm_interception,
>  	[SVM_EXIT_INTR] 			= nop_on_interception,
> @@ -1664,7 +1678,6 @@ svm_patch_hypercall(struct kvm_vcpu *vcpu, unsigned
> char *hypercall) hypercall[0] = 0x0f;
>  	hypercall[1] = 0x01;
>  	hypercall[2] = 0xd9;
> -	hypercall[3] = 0xc3;
>  }

...

> +/* This instruction is vmcall.  On non-VT architectures, it will generate
> a + * trap that we will then rewrite to the appropriate instruction. */
> -#define __NR_hypercalls			0
> +#define KVM_HYPERCALL ".byte 0x0f,0x01,0xc1"

.. which never happens.
