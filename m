Return-Path: <linux-kernel-owner+w=401wt.eu-S1761465AbXJQOQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761465AbXJQOQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 10:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbXJQOQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 10:16:18 -0400
Received: from il.qumranet.com ([82.166.9.18]:35153 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754252AbXJQOQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 10:16:17 -0400
Message-ID: <4716192E.7040402@qumranet.com>
Date: Wed, 17 Oct 2007 16:16:14 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, borntraeger@de.ibm.com
Subject: Re: [PATCH] clear PF_VCPU in kvm_guest_exit()
References: <47135D1B.1060004@bull.net> <11926264852739-git-send-email-Laurent.Vivier@bull.net>
In-Reply-To: <11926264852739-git-send-email-Laurent.Vivier@bull.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Wed, 17 Oct 2007 16:16:14 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
> clear PF_VCPU in kvm_guest_exit() and move kvm_guest_exit() after 
> local_irq_enable().
>
> According comments from Avi, we can clear PF_VCPU in kvm_guest_exit if we move 
> it after local_irq_enable().
>
> http://lkml.org/lkml/2007/10/15/114
>
> To simplify s390 port, we don't clear it in account_system_time().
>
> http://lkml.org/lkml/2007/10/15/183
>
> Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
> ---
>  drivers/kvm/kvm.h      |    1 +
>  drivers/kvm/kvm_main.c |    3 ++-
>  kernel/sched.c         |    1 -
>  3 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
> index e9dbf67..e8b4902 100644
> --- a/drivers/kvm/kvm.h
> +++ b/drivers/kvm/kvm.h
> @@ -677,6 +677,7 @@ static inline void kvm_guest_enter(void)
>  
>  static inline void kvm_guest_exit(void)
>  {
> +	current->flags &= ~PF_VCPU;
>  }
>   


Ingo already added this.

>  
>  static inline int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
> diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
> index 87275be..a9db477 100644
> --- a/drivers/kvm/kvm_main.c
> +++ b/drivers/kvm/kvm_main.c
> @@ -2194,12 +2194,13 @@ again:
>  
>  	kvm_x86_ops->run(vcpu, kvm_run);
>  
> -	kvm_guest_exit();
>  	vcpu->guest_mode = 0;
>  	local_irq_enable();
>  
>  	++vcpu->stat.exits;
>  
>   

Need a barrier() here.  Otherwise the compiler may reorder
"kvm_guest_exit();" and "++vcpu->stats.exits;", making kvm_guest_exit()
right after local_irq_enable().  If it inlines kvm_guest_exit(), and
further encodes it in one instruction (both likely) we get:

         sti
         andl $something, (something_else)

The andl executes in interrupt shadow (that is, interrupts are still
disabled) and the timer tick won't see PF_VCPU.

> +	kvm_guest_exit();
> +
>  	preempt_enable();
>  
>  	/*
>   


Please copy kvm-devel on kvm patches.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

